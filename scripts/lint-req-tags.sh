#!/usr/bin/env bash
# T2: Tag schema linter (FM-02 corrective action)
# Validates REQ-ID tag lines in STANDARDS.md and addenda:
#   - Position 1 (kind): gate | artifact | advisory
#   - Position 2 (scope): discover | define | design | build | verify | document |
#                          deploy | monitor | close | commit | session-start |
#                          session-end | continuous
#   - Position 3 (enforcement): hard | soft | none
#   - Position 4 (applies-when): all | type:{name} | addendum:{CODE} | compound
#   - Position 5 (eval-scope): per-item | per-section | per-artifact | per-commit
#     Required when kind=gate, absent otherwise.
#
# Ignores lines inside fenced code blocks.
# Exit 0 = pass, Exit 1 = violations found.
#
# Usage: ./scripts/lint-req-tags.sh
# Runs as: pre-commit hook, CI gate (hard-block)

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
# Single source of truth for corpus file list
source "$REPO_ROOT/scripts/ese-corpus-files.sh"

VALID_KIND="gate|artifact|advisory"
VALID_SCOPE="discover|define|design|build|verify|document|deploy|monitor|close|commit|session-start|session-end|continuous"
VALID_ENFORCEMENT="hard|soft|none"
VALID_EVAL="per-item|per-section|per-artifact|per-commit"

VIOLATIONS=()
CHECKED=0

for file in "${FILES[@]}"; do
  in_fence=0
  prev_was_anchor=0
  anchor_id=""
  lineno=0

  while IFS= read -r line; do
    lineno=$((lineno + 1))

    # Track fenced code blocks
    if [[ "$line" =~ ^\`\`\` ]]; then
      in_fence=$((1 - in_fence))
      prev_was_anchor=0
      continue
    fi
    [ "$in_fence" -eq 1 ] && continue

    # Detect anchor line
    if [[ "$line" =~ \<a\ name=\"(REQ-[^\"]+)\"\> ]]; then
      prev_was_anchor=1
      anchor_id="${BASH_REMATCH[1]}"
      continue
    fi

    # Tag line follows anchor
    if [ "$prev_was_anchor" -eq 1 ]; then
      prev_was_anchor=0
      CHECKED=$((CHECKED + 1))

      # Extract backtick tokens
      tokens=()
      while [[ "$line" =~ \`([^\`]+)\` ]]; do
        tokens+=("${BASH_REMATCH[1]}")
        line="${line#*\`${BASH_REMATCH[1]}\`}"
      done

      fname="$(basename "$file")"

      # Check minimum 4 tokens
      if [ ${#tokens[@]} -lt 4 ]; then
        VIOLATIONS+=("$fname:$lineno $anchor_id: expected at least 4 tokens, found ${#tokens[@]}")
        continue
      fi

      # Position 1: kind
      kind="${tokens[0]}"
      if ! echo "$kind" | grep -qxE "$VALID_KIND"; then
        VIOLATIONS+=("$fname:$lineno $anchor_id: invalid kind '$kind' (expected: $VALID_KIND)")
      fi

      # Position 2: scope
      scope="${tokens[1]}"
      if ! echo "$scope" | grep -qxE "$VALID_SCOPE"; then
        VIOLATIONS+=("$fname:$lineno $anchor_id: invalid scope '$scope' (expected: $VALID_SCOPE)")
      fi

      # Position 3: enforcement
      enforcement="${tokens[2]}"
      if ! echo "$enforcement" | grep -qxE "$VALID_ENFORCEMENT"; then
        VIOLATIONS+=("$fname:$lineno $anchor_id: invalid enforcement '$enforcement' (expected: $VALID_ENFORCEMENT)")
      fi

      # Position 4: applies-when (allow any value - compound expressions are complex)
      # Just check it's non-empty
      if [ -z "${tokens[3]}" ]; then
        VIOLATIONS+=("$fname:$lineno $anchor_id: position 4 (applies-when) is empty")
      fi

      # Position 5: eval-scope - required for kind:gate, absent otherwise
      if [ "$kind" = "gate" ]; then
        if [ ${#tokens[@]} -lt 5 ]; then
          VIOLATIONS+=("$fname:$lineno $anchor_id: kind=gate requires position 5 (eval-scope), but only ${#tokens[@]} tokens found")
        else
          eval_scope="${tokens[4]}"
          # Skip if it starts with "deprecated:" - that's a 6th token
          if [[ "$eval_scope" != deprecated:* ]] && ! echo "$eval_scope" | grep -qxE "$VALID_EVAL"; then
            VIOLATIONS+=("$fname:$lineno $anchor_id: invalid eval-scope '$eval_scope' (expected: $VALID_EVAL)")
          fi
        fi
      elif [ ${#tokens[@]} -ge 5 ]; then
        fifth="${tokens[4]}"
        # Allow deprecated: token on any kind
        if [[ "$fifth" != deprecated:* ]]; then
          # Non-gate with eval-scope is a warning (not necessarily wrong if applies-when is compound)
          # Only flag if it looks like a valid eval-scope value
          if echo "$fifth" | grep -qxE "$VALID_EVAL"; then
            VIOLATIONS+=("$fname:$lineno $anchor_id: kind=$kind should not have eval-scope (position 5), but found '$fifth'")
          fi
        fi
      fi
    else
      prev_was_anchor=0
    fi
  done < "$file"
done

if [ ${#VIOLATIONS[@]} -gt 0 ]; then
  echo "FAIL: REQ-ID tag schema lint (ESE §4.9.2, FM-02):"
  for v in "${VIOLATIONS[@]}"; do
    echo "  $v"
  done
  echo ""
  echo "Checked: $CHECKED REQ-ID tag lines"
  echo "Violations: ${#VIOLATIONS[@]}"
  exit 1
else
  echo "PASS: $CHECKED REQ-ID tag lines validated, all conform to §4.9.2 schema."
  exit 0
fi
