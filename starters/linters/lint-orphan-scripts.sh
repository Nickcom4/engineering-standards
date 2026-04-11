#!/usr/bin/env bash
# Orphan script detector (adopter starter)
#
# Fails when a lint-*.sh or validate-*.sh script exists in scripts/
# but is not referenced by BOTH the CI workflow AND the project agent
# context file. Catches the pattern where a gating script is added
# but nothing ever runs it.
#
# Parameterization:
#
#   PROJECT_ROOT     Your repo root. Default: git rev-parse or pwd.
#   SCRIPTS_DIR      Directory of lint/validate/generate scripts.
#                    Default: ${PROJECT_ROOT}/scripts
#   CI_WORKFLOW      CI workflow file to check for script references.
#                    Default: ${PROJECT_ROOT}/.github/workflows/ci.yml
#   AGENT_CONTEXT    Project agent context file (e.g. CLAUDE.md,
#                    AGENTS.md). Default: the first of CLAUDE.md,
#                    AGENTS.md, .cursorrules, .agent.md found at the
#                    project root.
#   ORPHAN_ALLOWLIST Space-separated list of script basenames exempt
#                    from the wiring check (helpers, non-gating
#                    generators). Default: ese-corpus-files.sh
#                    generate-fmea-views.sh generate-mode2-candidates.sh
#
# Exit 0 = pass. Exit 1 = orphans found.

set -euo pipefail

PROJECT_ROOT="${PROJECT_ROOT:-$(git rev-parse --show-toplevel 2>/dev/null || pwd)}"
SCRIPTS_DIR="${SCRIPTS_DIR:-${PROJECT_ROOT}/scripts}"
CI_WORKFLOW="${CI_WORKFLOW:-${PROJECT_ROOT}/.github/workflows/ci.yml}"

# Auto-detect agent context file if not set
if [ -z "${AGENT_CONTEXT:-}" ]; then
  for candidate in CLAUDE.md AGENTS.md .cursorrules .agent.md; do
    if [ -f "$PROJECT_ROOT/$candidate" ]; then
      AGENT_CONTEXT="$PROJECT_ROOT/$candidate"
      break
    fi
  done
fi

if [ ! -d "$SCRIPTS_DIR" ]; then
  echo "SKIP: $SCRIPTS_DIR not found."
  exit 0
fi
if [ ! -f "${CI_WORKFLOW:-}" ]; then
  echo "SKIP: CI workflow not found at ${CI_WORKFLOW:-unset}"
  exit 0
fi
if [ -z "${AGENT_CONTEXT:-}" ] || [ ! -f "$AGENT_CONTEXT" ]; then
  echo "SKIP: no project agent context file found (set AGENT_CONTEXT env var)"
  exit 0
fi

# Allowlist: helpers that are legitimately not gates
read -r -a ALLOWLIST <<< "${ORPHAN_ALLOWLIST:-ese-corpus-files.sh generate-fmea-views.sh generate-mode2-candidates.sh}"

is_allowlisted() {
  local candidate="$1"
  local allowed
  for allowed in "${ALLOWLIST[@]}"; do
    [ "$allowed" = "$candidate" ] && return 0
  done
  return 1
}

ORPHANS_MISSING_CI=()
ORPHANS_MISSING_AGENT=()
ORPHANS_MISSING_BOTH=()

for script in "$SCRIPTS_DIR"/*.sh; do
  [ -f "$script" ] || continue
  name=$(basename "$script")
  case "$name" in
    lint-*|validate-*|generate-*) ;;
    *) continue ;;
  esac
  is_allowlisted "$name" && continue

  in_ci=0
  in_agent=0
  grep -q -F "$name" "$CI_WORKFLOW" && in_ci=1
  grep -q -F "$name" "$AGENT_CONTEXT" && in_agent=1

  if [ "$in_ci" -eq 0 ] && [ "$in_agent" -eq 0 ]; then
    ORPHANS_MISSING_BOTH+=("$name")
  elif [ "$in_ci" -eq 0 ]; then
    ORPHANS_MISSING_CI+=("$name")
  elif [ "$in_agent" -eq 0 ]; then
    ORPHANS_MISSING_AGENT+=("$name")
  fi
done

TOTAL_ORPHANS=$((${#ORPHANS_MISSING_BOTH[@]} + ${#ORPHANS_MISSING_CI[@]} + ${#ORPHANS_MISSING_AGENT[@]}))

if [ "$TOTAL_ORPHANS" -gt 0 ]; then
  echo "FAIL: Orphaned lint/validate/generate scripts detected."
  echo ""
  if [ ${#ORPHANS_MISSING_BOTH[@]} -gt 0 ]; then
    echo "Missing from BOTH $CI_WORKFLOW AND $(basename $AGENT_CONTEXT):"
    for s in "${ORPHANS_MISSING_BOTH[@]}"; do echo "  $s"; done
    echo ""
  fi
  if [ ${#ORPHANS_MISSING_CI[@]} -gt 0 ]; then
    echo "In $(basename $AGENT_CONTEXT) but missing from $CI_WORKFLOW:"
    for s in "${ORPHANS_MISSING_CI[@]}"; do echo "  $s"; done
    echo ""
  fi
  if [ ${#ORPHANS_MISSING_AGENT[@]} -gt 0 ]; then
    echo "In $CI_WORKFLOW but missing from $(basename $AGENT_CONTEXT):"
    for s in "${ORPHANS_MISSING_AGENT[@]}"; do echo "  $s"; done
    echo ""
  fi
  echo "Fix: wire the script into the CI workflow AND add it to the"
  echo "project agent context file's local-suite list. If the script is"
  echo "a helper or not meant to be a gate, add it to ORPHAN_ALLOWLIST."
  exit 1
fi

echo "PASS: All lint/validate/generate scripts wired to CI workflow and agent context."
