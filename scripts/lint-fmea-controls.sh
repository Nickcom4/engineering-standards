#!/usr/bin/env bash
# lint-fmea-controls.sh — verify DFMEA/PFMEA Controls Summary [x] entries
# that reference scripts confirm those scripts exist in scripts/ and appear in ci.yml.
#
# Rationale: A Controls Summary [x] entry for a non-existent or unwired script
# gives false assurance that a failure mode is controlled. This gate ensures
# the document state matches implementation state.
#
# Exit 0 = pass. Exit 1 = violations found.

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
CI_YML="$REPO_ROOT/.github/workflows/ci.yml"
SCRIPTS_DIR="$REPO_ROOT/scripts"
FMEA_DIR="$REPO_ROOT/docs/decisions"

FAILED=0

for fmea in "$FMEA_DIR"/DFMEA-*.md "$FMEA_DIR"/PFMEA-*.md; do
  [ -f "$fmea" ] || continue
  relpath="${fmea#$REPO_ROOT/}"

  # Find checked [x] entries that reference a scripts/*.sh file
  in_controls=false
  while IFS= read -r line; do
    # Enter Controls Summary section
    if echo "$line" | grep -q '^## Controls Summary\|^## Control Summary'; then
      in_controls=true
      continue
    fi
    # Exit on next top-level section (but not sub-items)
    if $in_controls && echo "$line" | grep -qE '^## [A-Z]'; then
      in_controls=false
    fi

    # Process [x] lines anywhere in file (Controls Summary may not have a clean header boundary)
    if echo "$line" | grep -q '^\- \[x\]'; then
      # Extract any scripts/*.sh references
      scripts_in_line=$(echo "$line" | grep -oE 'scripts/[a-zA-Z0-9_-]+\.sh' || true)
      for script_ref in $scripts_in_line; do
        script_name="${script_ref#scripts/}"
        full_path="$SCRIPTS_DIR/$script_name"

        # Skip helper/library scripts (prefixed with _ or named as sourced libraries)
        # These are not CI entry points; they are sourced by other scripts.
        case "$script_name" in
          _*|ese-corpus-files.sh) continue ;;
        esac

        # Check script exists
        if [ ! -f "$full_path" ]; then
          echo "FAIL [$relpath]: [x] entry references $script_ref but file does not exist."
          FAILED=1
          continue
        fi

        # Check script appears in ci.yml (as a callable, not just a source reference)
        if ! grep -q "$script_name" "$CI_YML" 2>/dev/null; then
          echo "FAIL [$relpath]: [x] entry references $script_ref but it is not called in ci.yml."
          FAILED=1
        fi
      done
    fi
  done < "$fmea"
done

if [ "$FAILED" -eq 1 ]; then
  echo ""
  echo "FAIL: FMEA Controls Summary has [x] entries whose scripts do not exist or are not wired to CI."
  echo "  Fix: either implement the missing script/wiring, or change [x] to [ ] with a deferral note."
  exit 1
fi

echo "PASS: All FMEA Controls Summary [x] script references exist and appear in ci.yml."
