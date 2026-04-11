#!/usr/bin/env bash
# T3: Unclassified obligation linter (§4.9.7)
# Scans all ESE documents for obligation keywords in prose lines
# that are NOT within N lines of a REQ-ID anchor (bidirectional).
#
# Two-pass approach:
#   Pass 1: collect all REQ-ID anchor line numbers per file
#   Pass 2: scan for obligation keywords, skip if any anchor is within PROXIMITY lines
#
# Exit 0 = no unclassified obligations (or non-strict mode)
# Exit 1 = strict mode and findings exist

set -euo pipefail

STRICT=0
PROXIMITY=10  # lines in either direction from a REQ-ID anchor
if [ "${1:-}" = "--strict" ]; then
  STRICT=1
fi

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
# Single source of truth for corpus file list
source "$REPO_ROOT/scripts/ese-corpus-files.sh"
# docs/req-schema.md removed (de-cascade complete, content returned to STANDARDS.md)

KEYWORDS="must|required|shall|block[s]?|gate[s]?|cannot"

FINDINGS=()
TOTAL_SCANNED=0

for file in "${FILES[@]}"; do
  fname="$(basename "$file")"

  # Pass 1: collect REQ-ID anchor line numbers
  anchor_lines=()
  in_fence=0
  lineno=0
  while IFS= read -r line; do
    lineno=$((lineno + 1))
    if [[ "$line" =~ ^\`\`\` ]]; then in_fence=$((1 - in_fence)); continue; fi
    [ "$in_fence" -eq 1 ] && continue
    if [[ "$line" =~ \<a\ name=\"REQ- ]]; then
      anchor_lines+=("$lineno")
    fi
  done < "$file"

  # Pass 2: scan for obligation keywords
  in_fence=0
  in_frontmatter=0
  lineno=0
  while IFS= read -r line; do
    lineno=$((lineno + 1))

    # YAML frontmatter
    if [ "$lineno" -eq 1 ] && [ "$(echo "$line" | tr -d '[:space:]')" = "---" ]; then
      in_frontmatter=1; continue
    fi
    if [ "$in_frontmatter" -eq 1 ]; then
      [ "$(echo "$line" | tr -d '[:space:]')" = "---" ] && in_frontmatter=0; continue
    fi

    # Fenced code blocks
    if [[ "$line" =~ ^\`\`\` ]]; then in_fence=$((1 - in_fence)); continue; fi
    [ "$in_fence" -eq 1 ] && continue

    # Skip table rows, headings, empty lines
    stripped="${line#"${line%%[![:space:]]*}"}"
    [[ "$stripped" == "|"* ]] && continue
    [[ "$stripped" == "#"* ]] && continue
    [ -z "$stripped" ] && continue

    # Skip REQ-ID anchor lines and their immediate block (tag + statement)
    if [[ "$line" =~ \<a\ name=\"REQ- ]]; then continue; fi

    # Check proximity to ANY anchor (bidirectional)
    near_anchor=0
    for anc in "${anchor_lines[@]+"${anchor_lines[@]}"}"; do
      diff=$((lineno - anc))
      if [ "$diff" -lt 0 ]; then diff=$((-diff)); fi
      if [ "$diff" -le "$PROXIMITY" ]; then
        near_anchor=1
        break
      fi
    done
    [ "$near_anchor" -eq 1 ] && continue

    TOTAL_SCANNED=$((TOTAL_SCANNED + 1))

    # Check for obligation keywords
    if echo "$line" | grep -iqwE "\b($KEYWORDS)\b" 2>/dev/null; then
      keyword=$(echo "$line" | grep -ioE "\b($KEYWORDS)\b" 2>/dev/null | head -1)

      # Context filter: skip non-obligation uses of keywords
      skip=0
      case "$line" in
        # §4.9 format spec definitions and meta-prose
        *'`kind` semantics'*|*'`enforcement` semantics'*|*'Type 1 (gate)'*|*'Type 2 (artifact)'*|*'Type 3 (advisory)'*|*'Type 4 (narrative)'*) skip=1 ;;
        # ToC entries with "(Required)" in section title
        *'- ['*'(Required'*']('#*) skip=1 ;;
        # "Activates at:" lifecycle stage headers
        *'**Activates at:**'*) skip=1 ;;
        # Lifecycle stage activation intro text
        *'Lifecycle stage activation'*) skip=1 ;;
        # §4.9 meta-specification prose: defines the requirement format itself
        *'canonical format for expressing'*) skip=1 ;;
        *'enforcement-system extensions'*) skip=1 ;;
        *'Positions 1-4 are required'*|*'Position 5 is required'*) skip=1 ;;
        *'granularity at which an automated evaluator'*) skip=1 ;;
        *'globally unique: base IDs carry'*) skip=1 ;;
        *'deprecated:{superseding'*) skip=1 ;;
        *'A statement earns a REQ-ID'*) skip=1 ;;
        # §1 introductory definitional prose
        *'They are gates that block progress when violated'*) skip=1 ;;
        # §1.1 significance threshold definition
        *'"Significant work" defined:'*) skip=1 ;;
        # §2.2 type system narrative (defining, not requiring)
        *'type that determines which lifecycle gates'*) skip=1 ;;
        *'Type is distinct from both priority'*) skip=1 ;;
        # Template guidance blocks (instructions for template users)
        *'> Required by'*) skip=1 ;;
        *'> List all FMs'*) skip=1 ;;
        *'> Unchecked items must'*) skip=1 ;;
        # Template/addenda lifecycle stage descriptions
        *'**Lifecycle stages:**'*) skip=1 ;;
        *'**Define thresholds before scoring.**'*) skip=1 ;;
        *'**Controls must reference'*) skip=1 ;;
        # ADR template closure condition prose
        *'blocks ADR closure'*) skip=1 ;;
      esac
      [ "$skip" -eq 1 ] && continue

      FINDINGS+=("$fname:$lineno [$keyword]: $(echo "$line" | head -c 120)")
    fi
  done < "$file"
done

echo "Scanned $TOTAL_SCANNED prose lines across ${#FILES[@]} files (proximity window: $PROXIMITY lines)."
echo ""

if [ ${#FINDINGS[@]} -gt 0 ]; then
  echo "UNCLASSIFIED OBLIGATIONS: ${#FINDINGS[@]} lines contain obligation keywords without a REQ-ID within $PROXIMITY lines:"
  echo ""
  for f in "${FINDINGS[@]}"; do
    echo "  $f"
  done
  echo ""
  if [ "$STRICT" -eq 1 ]; then
    exit 1
  else
    exit 0
  fi
else
  echo "PASS: No unclassified obligation keywords found."
  exit 0
fi
