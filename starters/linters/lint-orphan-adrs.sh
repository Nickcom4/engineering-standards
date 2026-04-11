#!/usr/bin/env bash
# Orphan ADR detector (adopter starter, advisory)
#
# Detects Accepted or Proposed ADRs that are not referenced from any
# living document in the repo. An orphan ADR is a decision record that
# nothing points at: the decision still stands, but no living document
# acknowledges it.
#
# Advisory: exits 0 even on warnings. An orphan ADR may be terminal by
# design (an internal record). To acknowledge an intentional orphan,
# add the frontmatter line:
#
#   cross-reference-free: intentional
#
# Parameterization:
#
#   PROJECT_ROOT  Your repo root. Default: git rev-parse or pwd.
#   ADR_DIR       Directory containing ADR-*.md files.
#                 Default: ${PROJECT_ROOT}/docs/decisions
#   SEARCH_FILES  Space-separated list of files to search for references.
#                 Default: STANDARDS.md (if present), CLAUDE.md,
#                 AGENTS.md, README.md, CHANGELOG.md,
#                 docs/standards-application.md, and any *.md under
#                 docs/addenda/, docs/architecture/, docs/decisions/,
#                 templates/, starters/ (if those directories exist).
#
# Exit 0 always (advisory).

set -euo pipefail

PROJECT_ROOT="${PROJECT_ROOT:-$(git rev-parse --show-toplevel 2>/dev/null || pwd)}"
ADR_DIR="${ADR_DIR:-${PROJECT_ROOT}/docs/decisions}"

if [ ! -d "$ADR_DIR" ]; then
  echo "SKIP: ADR directory not found at $ADR_DIR"
  exit 0
fi

# Build search corpus
SEARCH_CORPUS=()
if [ -n "${SEARCH_FILES:-}" ]; then
  for f in $SEARCH_FILES; do
    [ -f "$f" ] && SEARCH_CORPUS+=("$f")
  done
else
  for candidate in \
    "$PROJECT_ROOT/STANDARDS.md" \
    "$PROJECT_ROOT/CLAUDE.md" \
    "$PROJECT_ROOT/AGENTS.md" \
    "$PROJECT_ROOT/README.md" \
    "$PROJECT_ROOT/CHANGELOG.md" \
    "$PROJECT_ROOT/docs/standards-application.md" \
    "$PROJECT_ROOT/docs/adoption.md" \
    "$PROJECT_ROOT/docs/background.md"; do
    [ -f "$candidate" ] && SEARCH_CORPUS+=("$candidate")
  done
  for dir in docs/addenda docs/architecture templates starters; do
    if [ -d "$PROJECT_ROOT/$dir" ]; then
      for f in "$PROJECT_ROOT"/$dir/*.md; do
        [ -f "$f" ] && SEARCH_CORPUS+=("$f")
      done
    fi
  done
fi

CHECKED=0
ORPHANS=()
EXEMPTED=0

for adr in "$ADR_DIR"/ADR-*.md; do
  [ -f "$adr" ] || continue

  if ! grep -qE '^status: (Accepted|Proposed)' "$adr"; then
    continue
  fi

  CHECKED=$((CHECKED + 1))
  name=$(basename "$adr" .md)

  if grep -q '^cross-reference-free: intentional' "$adr"; then
    EXEMPTED=$((EXEMPTED + 1))
    continue
  fi

  PATTERNS=()
  PATTERNS+=("$name")
  frontmatter_id=$(awk -F': ' '/^id: / {gsub(/^ +| +$/,"",$2); print $2; exit}' "$adr")
  if [ -n "$frontmatter_id" ] && [ "$frontmatter_id" != "$name" ]; then
    PATTERNS+=("$frontmatter_id")
  fi
  if [[ "$name" =~ ^(ADR-[0-9]{3}) ]]; then
    short="${BASH_REMATCH[1]}"
    [ "$short" != "$name" ] && PATTERNS+=("$short")
  elif [[ "$name" =~ ^(ADR-[0-9]{4}-[0-9]{2}-[0-9]{2}) ]]; then
    short="${BASH_REMATCH[1]}"
    [ "$short" != "$name" ] && PATTERNS+=("$short")
  fi

  ref_found=0
  if [ ${#SEARCH_CORPUS[@]} -gt 0 ]; then
    for searchfile in "${SEARCH_CORPUS[@]}"; do
      for pat in "${PATTERNS[@]}"; do
        if grep -q -F "$pat" "$searchfile"; then
          ref_found=1
          break 2
        fi
      done
    done
  fi

  if [ "$ref_found" -eq 0 ]; then
    for other in "$ADR_DIR"/*.md; do
      [ "$other" = "$adr" ] && continue
      for pat in "${PATTERNS[@]}"; do
        if grep -q -F "$pat" "$other"; then
          ref_found=1
          break 2
        fi
      done
    done
  fi

  if [ "$ref_found" -eq 0 ]; then
    ORPHANS+=("$name")
  fi
done

if [ ${#ORPHANS[@]} -gt 0 ]; then
  echo "WARN: $CHECKED ADRs checked; ${#ORPHANS[@]} with no cross-references from any living document (advisory):"
  for o in "${ORPHANS[@]}"; do echo "  $o"; done
  echo ""
  echo "An orphan ADR may be terminal by design. To acknowledge an"
  echo "intentional orphan, add this line to the ADR frontmatter:"
  echo "  cross-reference-free: intentional"
  exit 0
fi

if [ "$EXEMPTED" -gt 0 ]; then
  echo "PASS: $CHECKED ADRs checked; all referenced at least once ($EXEMPTED exempted via cross-reference-free: intentional)."
else
  echo "PASS: $CHECKED ADRs checked; all referenced at least once from a living document."
fi
