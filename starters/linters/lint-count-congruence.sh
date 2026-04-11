#!/usr/bin/env bash
# Count congruence linter (adopter starter)
#
# Asserts that every "N <thing>" claim in living documents matches the
# authoritative generator for that thing. Complements the stale-count
# pattern by catching gate counts, CI check counts, and script counts
# in prose.
#
# This starter ships with the ESE default sources of truth and files.
# Adopters override via environment variables to point at their own
# generators and their own docs.
#
# Parameterization:
#
#   PROJECT_ROOT       Your repo root. Default: git rev-parse or pwd.
#
#   COUNT_FILES        Space-separated list of files to scan for count
#                      claims. Default: CLAUDE.md README.md AGENTS.md
#                      docs/standards-application.md (if each exists).
#
#   GATE_COUNT_FILE    Path to a file whose "gate_count:" field is the
#                      authoritative gate count. Default:
#                      ${PROJECT_ROOT}/enforcement-spec.yml
#                      (set to empty to skip gate count check)
#
#   CI_WORKFLOW        Path to CI workflow with "# Check N" markers.
#                      Default: ${PROJECT_ROOT}/.github/workflows/ci.yml
#                      (set to empty to skip CI check count check)
#
#   SCRIPTS_DIR        Directory of scripts/*.sh files counted for the
#                      "N scripts" claim. Default: ${PROJECT_ROOT}/scripts
#                      (set to empty to skip script count check)
#
# Exit 0 = pass. Exit 1 = drift detected.

set -euo pipefail

PROJECT_ROOT="${PROJECT_ROOT:-$(git rev-parse --show-toplevel 2>/dev/null || pwd)}"
GATE_COUNT_FILE="${GATE_COUNT_FILE-${PROJECT_ROOT}/enforcement-spec.yml}"
CI_WORKFLOW="${CI_WORKFLOW-${PROJECT_ROOT}/.github/workflows/ci.yml}"
SCRIPTS_DIR="${SCRIPTS_DIR-${PROJECT_ROOT}/scripts}"

ACTUAL_GATES=""
if [ -n "$GATE_COUNT_FILE" ] && [ -f "$GATE_COUNT_FILE" ]; then
  ACTUAL_GATES=$(awk -F': ' '/^gate_count:/ {gsub(/"/,"",$2); gsub(/ /,"",$2); print $2; exit}' "$GATE_COUNT_FILE" 2>/dev/null || true)
fi

ACTUAL_CHECKS=""
if [ -n "$CI_WORKFLOW" ] && [ -f "$CI_WORKFLOW" ]; then
  ACTUAL_CHECKS=$(grep -c "^      # Check [0-9]" "$CI_WORKFLOW" 2>/dev/null || echo 0)
fi

ACTUAL_SCRIPTS=""
if [ -n "$SCRIPTS_DIR" ] && [ -d "$SCRIPTS_DIR" ]; then
  ACTUAL_SCRIPTS=$(ls "$SCRIPTS_DIR"/*.sh 2>/dev/null | wc -l | tr -d ' ')
fi

# Default scan files
COUNT_FILES_DEFAULT=""
for candidate in "$PROJECT_ROOT/CLAUDE.md" "$PROJECT_ROOT/README.md" "$PROJECT_ROOT/AGENTS.md" "$PROJECT_ROOT/docs/standards-application.md"; do
  [ -f "$candidate" ] && COUNT_FILES_DEFAULT="$COUNT_FILES_DEFAULT $candidate"
done
COUNT_FILES="${COUNT_FILES:-$COUNT_FILES_DEFAULT}"

if [ -z "$COUNT_FILES" ]; then
  echo "SKIP: no files to scan (set COUNT_FILES env var)"
  exit 0
fi

VIOLATIONS=()

for file in $COUNT_FILES; do
  [ -f "$file" ] || continue
  relpath="${file#$PROJECT_ROOT/}"
  lineno=0
  in_fence=0
  while IFS= read -r line; do
    lineno=$((lineno + 1))
    if [[ "$line" =~ ^\`\`\` ]]; then
      in_fence=$((1 - in_fence))
      continue
    fi
    [ "$in_fence" -eq 1 ] && continue
    [[ "$line" =~ ^\|[-\ ]+\|$ ]] && continue
    if [[ "$line" =~ was\ |from\ |previously|grew\ from|iteration|prior\ |earlier ]]; then
      continue
    fi

    if [ -n "$ACTUAL_GATES" ] && [[ "$line" =~ ([0-9]+)\ (machine-readable\ |declared\ )?gate ]]; then
      num="${BASH_REMATCH[1]}"
      if [ "$num" -ge 100 ] && [ "$num" -le 9999 ] && [ "$num" != "$ACTUAL_GATES" ]; then
        VIOLATIONS+=("$relpath:$lineno: gates claim $num but source has $ACTUAL_GATES")
      fi
    fi

    if [ -n "$ACTUAL_CHECKS" ] && [[ "$line" =~ ([0-9]+)\ (CI\ )?checks? ]]; then
      num="${BASH_REMATCH[1]}"
      if [ "$num" -ge 10 ] && [ "$num" -le 999 ] && [ "$num" != "$ACTUAL_CHECKS" ]; then
        VIOLATIONS+=("$relpath:$lineno: checks claim $num but CI workflow has $ACTUAL_CHECKS")
      fi
    fi

    if [ -n "$ACTUAL_SCRIPTS" ] && [[ "$line" =~ ([0-9]+)\ (CI\ |bash\ )?scripts? ]]; then
      num="${BASH_REMATCH[1]}"
      if [ "$num" -ge 10 ] && [ "$num" -le 999 ] && [ "$num" != "$ACTUAL_SCRIPTS" ]; then
        VIOLATIONS+=("$relpath:$lineno: scripts claim $num but scripts/*.sh has $ACTUAL_SCRIPTS")
      fi
    fi
  done < "$file"
done

if [ ${#VIOLATIONS[@]} -gt 0 ]; then
  echo "FAIL: Count drift detected."
  echo ""
  for v in "${VIOLATIONS[@]}"; do echo "  $v"; done
  echo ""
  echo "Authoritative sources:"
  [ -n "$ACTUAL_GATES" ] && echo "  Gates:   $ACTUAL_GATES"
  [ -n "$ACTUAL_CHECKS" ] && echo "  Checks:  $ACTUAL_CHECKS"
  [ -n "$ACTUAL_SCRIPTS" ] && echo "  Scripts: $ACTUAL_SCRIPTS"
  exit 1
fi

msg="PASS:"
[ -n "$ACTUAL_GATES" ] && msg="$msg gates=$ACTUAL_GATES"
[ -n "$ACTUAL_CHECKS" ] && msg="$msg checks=$ACTUAL_CHECKS"
[ -n "$ACTUAL_SCRIPTS" ] && msg="$msg scripts=$ACTUAL_SCRIPTS"
echo "$msg congruent across living documents."
