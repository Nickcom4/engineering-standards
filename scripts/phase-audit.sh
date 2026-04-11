#!/usr/bin/env bash
# phase-audit.sh: agent/operator helper for running a phase-closure audit
# before claiming work complete.
#
# Greps a configurable list of canonical onboarding and agent-context files
# for one or more NEEDLE strings (feature names, new filenames, new function
# names, etc.) and reports which canonical files reference each needle.
#
# This is a SOFT helper, not a gate. It exits 0 even when coverage is
# partial; it exists to surface gaps for agent/operator review. Use it
# BEFORE claiming a phase complete, as part of the phase-closure discipline.
#
# Usage:
#
#   bash scripts/phase-audit.sh NEEDLE [NEEDLE2 ...]
#
#     Audits the default canonical file list for each needle.
#     Example: bash scripts/phase-audit.sh verify.sh upgrade-check.sh catchup.sh
#
#   bash scripts/phase-audit.sh --files FILE1 FILE2 -- NEEDLE1 NEEDLE2
#
#     Audits a custom file list (useful when auditing adopter-repo state
#     from outside ESE). Delimiter '--' separates files from needles.
#
#   bash scripts/phase-audit.sh --help
#
# Default canonical file list (ESE-internal):
#
#   README.md
#   CLAUDE.md
#   CHANGELOG.md
#   docs/adoption.md
#   docs/standards-application.md
#   docs/migrating-from-partial-adoption.md
#   starters/tools/README.md
#   starters/linters/README.md
#
# Output: one row per needle with PASS/FAIL per canonical file, plus a
# summary line at the bottom. Exit 0 always; rows marked FAIL are
# informational and left for the operator to address.

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$REPO_ROOT"

DEFAULT_CANONICAL=(
    "README.md"
    "CLAUDE.md"
    "CHANGELOG.md"
    "docs/adoption.md"
    "docs/standards-application.md"
    "docs/migrating-from-partial-adoption.md"
    "starters/tools/README.md"
    "starters/linters/README.md"
)

show_help() {
    sed -n '2,42p' "$0" | sed 's/^# \{0,1\}//'
}

custom_files=()
needles=()
parsing_files=0

if [ $# -eq 0 ]; then
    show_help
    exit 2
fi

for arg in "$@"; do
    case "$arg" in
        --help|-h)
            show_help
            exit 0
            ;;
        --files)
            parsing_files=1
            ;;
        --)
            parsing_files=0
            ;;
        *)
            if [ "$parsing_files" = "1" ]; then
                custom_files+=("$arg")
            else
                needles+=("$arg")
            fi
            ;;
    esac
done

if [ ${#needles[@]} -eq 0 ]; then
    echo "phase-audit: at least one NEEDLE required" >&2
    show_help
    exit 2
fi

if [ ${#custom_files[@]} -gt 0 ]; then
    files=("${custom_files[@]}")
else
    files=("${DEFAULT_CANONICAL[@]}")
fi

# Filter files that actually exist
existing_files=()
for f in "${files[@]}"; do
    if [ -f "$f" ]; then
        existing_files+=("$f")
    else
        echo "phase-audit: skipping missing file: $f" >&2
    fi
done

if [ ${#existing_files[@]} -eq 0 ]; then
    echo "phase-audit: no canonical files to check" >&2
    exit 2
fi

echo "=== phase-audit report ==="
echo ""
echo "Canonical files (${#existing_files[@]}):"
for f in "${existing_files[@]}"; do
    echo "  - $f"
done
echo ""

# Build a results table
for needle in "${needles[@]}"; do
    total=0
    present=0
    echo "--- needle: $needle ---"
    for f in "${existing_files[@]}"; do
        total=$((total + 1))
        if grep -q -F "$needle" "$f" 2>/dev/null; then
            printf "  [x] %s\n" "$f"
            present=$((present + 1))
        else
            printf "  [ ] %s\n" "$f"
        fi
    done
    pct=$((present * 100 / total))
    echo "  coverage: $present/$total ($pct%)"
    echo ""
done

echo "=== summary ==="
any_missing=0
for needle in "${needles[@]}"; do
    total=0
    present=0
    for f in "${existing_files[@]}"; do
        total=$((total + 1))
        if grep -q -F "$needle" "$f" 2>/dev/null; then
            present=$((present + 1))
        fi
    done
    if [ "$present" -eq 0 ]; then
        echo "  ABSENT:    $needle (0/$total canonical files reference it)"
        any_missing=1
    elif [ "$present" -lt "$total" ]; then
        echo "  PARTIAL:   $needle ($present/$total canonical files reference it)"
    else
        echo "  FULL:      $needle ($present/$total canonical files reference it)"
    fi
done
echo ""

if [ "$any_missing" = "1" ]; then
    echo "At least one needle is absent from every canonical file. Review the"
    echo "ABSENT entries above and update the relevant docs before claiming the"
    echo "phase complete. This is a soft check; exit code is 0 regardless."
fi

exit 0
