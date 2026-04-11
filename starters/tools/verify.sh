#!/usr/bin/env bash
# verify.sh: run the full vendored ESE linter suite against your project and
# produce a summary pass/fail report.
#
# Usage:
#
#   bash scripts/verify.sh           # run all linters, show summary, exit 0/1
#   bash scripts/verify.sh --json    # same but emit a JSON summary on stdout
#   bash scripts/verify.sh --quiet   # suppress per-linter output, show summary only
#
# This is a convenience wrapper around the eight vendored drift-detection
# linters in scripts/. It does not add any new checks; it provides a single
# entry point that an adopter can run locally or wire into CI as one step.
#
# Parameterization: this tool discovers linters by scanning scripts/lint-*.sh.
# Any linter you have vendored into scripts/ is automatically included.
#
# Exit 0 if every gate linter passes. Exit 1 if any gate linter fails.
# Advisory linters (currently lint-orphan-adrs.sh) print their output but
# do not affect the exit code.

set -euo pipefail

PROJECT_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
cd "$PROJECT_ROOT"

MODE=normal
for arg in "$@"; do
    case "$arg" in
        --json) MODE=json ;;
        --quiet) MODE=quiet ;;
        --help|-h)
            sed -n '2,22p' "$0" | sed 's/^# \{0,1\}//'
            exit 0
            ;;
        *) echo "verify.sh: unknown argument: $arg" >&2; exit 2 ;;
    esac
done

# Linters that are advisory (non-blocking). Add more here if your project
# wants to downgrade specific linters to advisory status.
ADVISORY=("lint-orphan-adrs.sh")

is_advisory() {
    local script_name="$(basename "$1")"
    for a in "${ADVISORY[@]}"; do
        [ "$script_name" = "$a" ] && return 0
    done
    return 1
}

# Discover vendored linters
linters=()
for f in scripts/lint-*.sh; do
    [ -f "$f" ] && linters+=("$f")
done

if [ ${#linters[@]} -eq 0 ]; then
    echo "verify.sh: no scripts/lint-*.sh found; nothing to verify" >&2
    exit 2
fi

# Results
declare -a results_scripts results_status results_output
total=0
failed_gates=0
failed_advisory=0

for lint in "${linters[@]}"; do
    total=$((total + 1))
    name=$(basename "$lint")
    tmp=$(mktemp)
    if bash "$lint" >"$tmp" 2>&1; then
        status=pass
    else
        status=fail
        if is_advisory "$lint"; then
            status=advisory-fail
            failed_advisory=$((failed_advisory + 1))
        else
            failed_gates=$((failed_gates + 1))
        fi
    fi
    results_scripts+=("$name")
    results_status+=("$status")
    out=$(cat "$tmp"); rm -f "$tmp"
    results_output+=("$out")
done

# Report
if [ "$MODE" = "json" ]; then
    python3 - "$total" "$failed_gates" "$failed_advisory" <<PYEOF
import json, sys
total = int(sys.argv[1])
failed = int(sys.argv[2])
adv = int(sys.argv[3])
scripts = """${results_scripts[@]}""".split()
statuses = """${results_status[@]}""".split()
out = {
    "total": total,
    "passed": total - failed - adv,
    "failed_gates": failed,
    "advisory_fail": adv,
    "exit_code": 1 if failed > 0 else 0,
    "linters": [{"name": s, "status": st} for s, st in zip(scripts, statuses)]
}
print(json.dumps(out, indent=2))
PYEOF
else
    if [ "$MODE" != "quiet" ]; then
        i=0
        for name in "${results_scripts[@]}"; do
            status="${results_status[$i]}"
            output="${results_output[$i]}"
            case "$status" in
                pass) icon="PASS" ;;
                advisory-fail) icon="WARN" ;;
                fail) icon="FAIL" ;;
            esac
            echo "=== $icon $name ==="
            echo "$output"
            echo ""
            i=$((i + 1))
        done
    fi
    echo "===================="
    echo "verify.sh summary"
    echo "===================="
    printf "  total linters:      %d\n" "$total"
    printf "  passed:             %d\n" $((total - failed_gates - failed_advisory))
    printf "  gate failures:      %d\n" "$failed_gates"
    printf "  advisory failures:  %d\n" "$failed_advisory"
    echo ""
    if [ "$failed_gates" -gt 0 ]; then
        echo "GATE FAILURES (blocking):"
        i=0
        for name in "${results_scripts[@]}"; do
            status="${results_status[$i]}"
            if [ "$status" = "fail" ]; then
                echo "  - $name"
            fi
            i=$((i + 1))
        done
    fi
fi

[ "$failed_gates" -gt 0 ] && exit 1
exit 0
