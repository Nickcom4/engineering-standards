#!/usr/bin/env bash
# Orphan script detector
# Scans scripts/lint-*.sh and scripts/validate-*.sh and fails if any of them
# is not wired into BOTH .github/workflows/ci.yml AND CLAUDE.md's
# "Before Every Commit" local suite. Catches the pattern where a gating
# script is added to scripts/ but nothing ever runs it, which happened
# with 6 scripts in the v2.1.0 to v2.2.0 window and took a manual audit
# to discover.
#
# Allowlist: helper scripts and scripts that are intentionally pre-commit-only
# or advisory-only. Add a file to ALLOWLIST below with a one-line reason if
# it should not be required in ci.yml or CLAUDE.md.
#
# Exit 0 = pass. Exit 1 = orphans found.

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
CI_YAML="$REPO_ROOT/.github/workflows/ci.yml"
CLAUDE_MD="$REPO_ROOT/CLAUDE.md"

if [ ! -f "$CI_YAML" ]; then
  echo "SKIP: .github/workflows/ci.yml not found."
  exit 0
fi
if [ ! -f "$CLAUDE_MD" ]; then
  echo "SKIP: CLAUDE.md not found."
  exit 0
fi

# Allowlist: scripts exempt from the wiring check. Each entry has a one-line
# rationale in the comment above it. Bash 3.2 compatible (no associative arrays).
ALLOWLIST=(
  # helper sourced by other scripts; not run directly
  "ese-corpus-files.sh"
  # advisory/exploratory generator; not wired as a gate
  "generate-mode2-candidates.sh"
  # auto-invoked by pre-commit hook per FMEA file; not a standalone CI check
  "generate-fmea-views.sh"
  # scaffolding tool for new artifact instances; invoked manually by users,
  # not a gate (creating artifacts is not a verification step)
  "new-artifact.sh"
)

is_allowlisted() {
  local candidate="$1"
  local allowed
  for allowed in "${ALLOWLIST[@]}"; do
    if [ "$allowed" = "$candidate" ]; then
      return 0
    fi
  done
  return 1
}

ORPHANS_MISSING_CI=()
ORPHANS_MISSING_CLAUDE=()
ORPHANS_MISSING_BOTH=()

for script in "$REPO_ROOT/scripts"/*.sh; do
  [ -f "$script" ] || continue
  name=$(basename "$script")

  if is_allowlisted "$name"; then
    continue
  fi

  in_ci=0
  in_claude=0
  grep -q -F "$name" "$CI_YAML" && in_ci=1
  grep -q -F "$name" "$CLAUDE_MD" && in_claude=1

  if [ "$in_ci" -eq 0 ] && [ "$in_claude" -eq 0 ]; then
    ORPHANS_MISSING_BOTH+=("$name")
  elif [ "$in_ci" -eq 0 ]; then
    ORPHANS_MISSING_CI+=("$name")
  elif [ "$in_claude" -eq 0 ]; then
    ORPHANS_MISSING_CLAUDE+=("$name")
  fi
done

TOTAL_ORPHANS=$((${#ORPHANS_MISSING_BOTH[@]} + ${#ORPHANS_MISSING_CI[@]} + ${#ORPHANS_MISSING_CLAUDE[@]}))

if [ "$TOTAL_ORPHANS" -gt 0 ]; then
  echo "FAIL: Orphaned lint/validate/generate scripts detected."
  echo ""
  if [ ${#ORPHANS_MISSING_BOTH[@]} -gt 0 ]; then
    echo "Missing from BOTH .github/workflows/ci.yml AND CLAUDE.md Before Every Commit:"
    for s in "${ORPHANS_MISSING_BOTH[@]}"; do echo "  $s"; done
    echo ""
  fi
  if [ ${#ORPHANS_MISSING_CI[@]} -gt 0 ]; then
    echo "In CLAUDE.md but missing from .github/workflows/ci.yml:"
    for s in "${ORPHANS_MISSING_CI[@]}"; do echo "  $s"; done
    echo ""
  fi
  if [ ${#ORPHANS_MISSING_CLAUDE[@]} -gt 0 ]; then
    echo "In .github/workflows/ci.yml but missing from CLAUDE.md Before Every Commit:"
    for s in "${ORPHANS_MISSING_CLAUDE[@]}"; do echo "  $s"; done
    echo ""
  fi
  echo "Fix: add the script as a new Check entry in ci.yml AND to the CLAUDE.md"
  echo "'Before Every Commit' local suite. If the script is a helper or is"
  echo "intentionally not run as a gate, add it to the ALLOWLIST in this"
  echo "linter with a one-line rationale."
  exit 1
fi

echo "PASS: All lint/validate/generate scripts are wired to both ci.yml and CLAUDE.md."
