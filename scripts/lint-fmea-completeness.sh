#!/usr/bin/env bash
# FMEA completeness linter (REQ-2.1-37, REQ-2.1-38)
# Parses DFMEA and PFMEA documents and flags:
#   - Above-threshold failure modes without a named control
#   - Controls Summary items that are unchecked without a tracked work item reference
#
# Exit 0 = pass. Exit 1 = violations found.

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
FMEA_DIR="$REPO_ROOT/docs/decisions"
VIOLATIONS=()
RPN_THRESHOLD=75

for fmea_file in "$FMEA_DIR"/DFMEA-*.md "$FMEA_DIR"/PFMEA-*.md; do
  [ -f "$fmea_file" ] || continue
  relpath="${fmea_file#$REPO_ROOT/}"

  # Check 1: above-threshold FMs without controls
  while IFS= read -r line; do
    if [[ "$line" =~ ^\|\ (PF-[0-9]+|FM-[0-9]+)\ .*\|.*\|.*\| ]]; then
      # Try to extract RPN from the line
      # For main FM tables: FM# | ... | S | O | D | **RPN** | Action | Status
      rpn=""
      if [[ "$line" =~ \*\*([0-9]+)\*\* ]]; then
        rpn="${BASH_REMATCH[1]}"
      fi
      if [ -n "$rpn" ] && [ "$rpn" -ge "$RPN_THRESHOLD" ] 2>/dev/null; then
        fm_id="${BASH_REMATCH[0]}"
        # Check if the line mentions an implemented control
        if [[ "$line" =~ Action\ needed ]] && [[ ! "$line" =~ Controlled ]] && [[ ! "$line" =~ CI\ Check ]] && [[ ! "$line" =~ linter ]]; then
          VIOLATIONS+=("$relpath: $fm_id RPN=$rpn has 'Action needed' but no implemented control")
        fi
      fi
    fi
  done < "$fmea_file"

  # Check 2: unchecked Controls Summary items
  in_controls=0
  while IFS= read -r line; do
    if [[ "$line" == *"Controls Summary"* ]]; then
      in_controls=1
    elif [[ "$line" == "---" ]] && [ "$in_controls" -eq 1 ]; then
      in_controls=0
    fi
    if [ "$in_controls" -eq 1 ] && [[ "$line" =~ ^\-\ \[\ \] ]]; then
      # Unchecked control - check if it has a vault- reference or "deferred" or "future"
      if [[ ! "$line" =~ vault-|deferred|future|N/A ]]; then
        VIOLATIONS+=("$relpath: unchecked control without work item or deferral reason: ${line:0:80}")
      fi
    fi
  done < "$fmea_file"
done

if [ ${#VIOLATIONS[@]} -gt 0 ]; then
  echo "FAIL: FMEA completeness violations (REQ-2.1-37, REQ-2.1-38):"
  for v in "${VIOLATIONS[@]}"; do
    echo "  $v"
  done
  exit 1
else
  echo "PASS: All above-threshold FMs have controls; all unchecked controls have deferral rationale."
  exit 0
fi
