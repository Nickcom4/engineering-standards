#!/usr/bin/env bash
# preflight.sh: single-command runner for the full ESE pre-commit checklist.
#
# Replaces the CLAUDE.md "Before Every Commit" content verification and CI
# verification blocks with one invocation. Run this before claiming any
# work complete; it runs everything CI will run, plus the typographic and
# content-boundary scans that live outside the linter suite.
#
# Usage:
#
#   bash scripts/preflight.sh          # run everything, print per-check output
#   bash scripts/preflight.sh --quiet  # summary only
#   bash scripts/preflight.sh --help
#
# What preflight runs:
#
#   1. All scripts/lint-*.sh (currently 28 linters including
#      lint-vsm-baseline-reference.sh; preflight discovers linters
#      dynamically)
#   2. Three manifest verifiers: generate-req-manifest.sh verify,
#      generate-enforcement-spec.sh verify, generate-req-index.sh verify
#   3. Typographic scan: em dashes (U+2014), en dashes (U+2013), smart
#      quotes, and ASCII double-hyphen sentence dashes in all .md and .sh
#      files
#   4. Content-boundary scans: person names in normative docs, absolute
#      paths, vault-style private-tracked-system IDs in forbidden places,
#      operator-specific project codenames
#
# Exit 0 if everything passes, exit 1 if any check fails. Advisory linters
# (currently lint-adr-triggers.sh and lint-orphan-adrs.sh) warn but do not
# affect exit code.

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$REPO_ROOT"

MODE=normal
for arg in "$@"; do
    case "$arg" in
        --quiet) MODE=quiet ;;
        --help|-h)
            sed -n '2,31p' "$0" | sed 's/^# \{0,1\}//'
            exit 0
            ;;
        *) echo "preflight: unknown argument: $arg" >&2; exit 2 ;;
    esac
done

ADVISORY=("lint-adr-triggers.sh" "lint-orphan-adrs.sh")

is_advisory() {
    local script_name="$(basename "$1")"
    for a in "${ADVISORY[@]}"; do
        [ "$script_name" = "$a" ] && return 0
    done
    return 1
}

total=0
passed=0
failed_gate=0
failed_advisory=0
failures=()

run_check() {
    local label="$1"
    local cmd="$2"
    local is_adv="${3:-0}"
    total=$((total + 1))
    local tmp
    tmp=$(mktemp)
    if eval "$cmd" >"$tmp" 2>&1; then
        passed=$((passed + 1))
        if [ "$MODE" = "normal" ]; then
            echo "  PASS  $label"
        fi
    else
        if [ "$is_adv" = "1" ]; then
            failed_advisory=$((failed_advisory + 1))
            if [ "$MODE" = "normal" ]; then
                echo "  WARN  $label"
                sed 's/^/         /' "$tmp" | head -5
            fi
        else
            failed_gate=$((failed_gate + 1))
            failures+=("$label")
            if [ "$MODE" = "normal" ]; then
                echo "  FAIL  $label"
                sed 's/^/         /' "$tmp" | head -10
            fi
        fi
    fi
    rm -f "$tmp"
}

# Block 1: lint scripts (auto-discover)
[ "$MODE" = "normal" ] && echo "=== Linter suite ==="
for lint in scripts/lint-*.sh; do
    [ -f "$lint" ] || continue
    name=$(basename "$lint")
    adv=0
    is_advisory "$lint" && adv=1
    run_check "$name" "bash '$lint'" "$adv"
done

# Block 2: manifest verifies
[ "$MODE" = "normal" ] && { echo ""; echo "=== Manifest verifies ==="; }
run_check "generate-req-manifest.sh verify" "bash scripts/generate-req-manifest.sh verify"
run_check "generate-enforcement-spec.sh verify" "bash scripts/generate-enforcement-spec.sh verify"
run_check "generate-req-index.sh verify" "bash scripts/generate-req-index.sh verify"

# Block 3: typographic scan (inline function, not a variable, to avoid
# bash quoting issues with embedded Python)
[ "$MODE" = "normal" ] && { echo ""; echo "=== Typographic scan ==="; }
typo_scan() {
    python3 - <<'PYEOF'
import os, sys
EM, EN = chr(0x2014), chr(0x2013)
SMART = chr(0x201C) + chr(0x201D) + chr(0x2018) + chr(0x2019)
bad = []
for root, dirs, files in os.walk("."):
    dirs[:] = [d for d in dirs if not d.startswith(".") and d != "node_modules"]
    for fname in files:
        if not (fname.endswith(".md") or fname.endswith(".sh")):
            continue
        fp = os.path.join(root, fname)
        try:
            c = open(fp).read()
        except Exception:
            continue
        em = c.count(EM)
        en = c.count(EN)
        sm = sum(c.count(ch) for ch in SMART)
        # Double-hyphen sentence dashes flagged only in .md files.
        # In .sh files, the bare double-hyphen is legitimate CLI syntax.
        dh = 0
        if fname.endswith(".md"):
            for ln in c.splitlines():
                if " -- " in ln and not ln.lstrip().startswith("|") and not ln.startswith("    "):
                    dh += 1
        if em or en or sm or dh:
            bad.append(f"{fp}: em={em} en={en} sm={sm} dh={dh}")
if bad:
    print("typographic violations:")
    for b in bad:
        print("  " + b)
    sys.exit(1)
print("typographic clean")
PYEOF
}
run_check "typographic scan (em/en/smart in .md+.sh, double-hyphen in .md only)" "typo_scan"

# Block 4: content-boundary scans (as functions to avoid eval-string quoting issues)
[ "$MODE" = "normal" ] && { echo ""; echo "=== Content-boundary scans ==="; }

person_scan() {
    if grep -rni "nick baker" STANDARDS.md docs/addenda/*.md templates/*.md starters/*.md 2>/dev/null; then
        return 1
    fi
    echo "person-names scan clean"
    return 0
}

abs_path_scan() {
    local hits
    hits=$(grep -rn "~/repos/\|/Users/" --include='*.md' STANDARDS.md docs/ templates/ starters/ README.md CLAUDE.md 2>/dev/null \
        | grep -v 'CHANGELOG' \
        | grep -v 'work-sessions' \
        | grep -v 'work-items/active' \
        | grep -v 'lint-standards-application-frontmatter' \
        | grep -v 'adoption.md' \
        || true)
    if [ -n "$hits" ]; then
        echo "$hits"
        return 1
    fi
    echo "absolute-paths scan clean"
    return 0
}

vault_scan() {
    if grep -rn "vault-[a-z0-9]" STANDARDS.md docs/addenda/*.md templates/*.md starters/*.md 2>/dev/null; then
        return 1
    fi
    echo "vault-ID scan clean"
    return 0
}

codename_scan() {
    if grep -rniE '\bApex\b|\bBEAM\b|\bToolBroker\b|\bManifestAnalyzer\b|\bBeads\b' STANDARDS.md docs/addenda/*.md templates/*.md starters/*.md 2>/dev/null; then
        return 1
    fi
    echo "codename scan clean"
    return 0
}

run_check "person names in normative docs" "person_scan"
run_check "absolute paths in normative and living docs" "abs_path_scan"
run_check "private tracked-system IDs in normative docs" "vault_scan"
run_check "operator project codenames in normative docs" "codename_scan"

# Report
echo ""
echo "=== preflight summary ==="
printf "  total checks:       %d\n" "$total"
printf "  passed:             %d\n" "$passed"
printf "  gate failures:      %d\n" "$failed_gate"
printf "  advisory failures:  %d\n" "$failed_advisory"
if [ "$failed_gate" -gt 0 ]; then
    echo ""
    echo "GATE FAILURES:"
    for f in "${failures[@]}"; do
        echo "  - $f"
    done
fi
# Write a state file on success so the phase-closure-audit Stop hook can
# detect that preflight ran recently without having to scan the full
# conversation transcript. See ~/.claude/hooks/phase-closure-audit.sh.
write_state_file() {
    local state_dir="$HOME/.claude/state"
    local state_file="$state_dir/preflight-run.json"
    mkdir -p "$state_dir" 2>/dev/null || return 0
    local ts
    ts=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
    cat > "$state_file" <<EOF
{
  "audit_timestamp": "$ts",
  "audit_type": "preflight",
  "script": "scripts/preflight.sh",
  "exit_code": 0,
  "total_checks": $total,
  "passed": $passed,
  "gate_failures": $failed_gate,
  "advisory_failures": $failed_advisory,
  "repo_root": "$(pwd)"
}
EOF
}

echo ""
if [ "$failed_gate" -eq 0 ]; then
    write_state_file
    echo "OK. Ready to commit."
    exit 0
else
    echo "BLOCKED. Fix the gate failures above before committing."
    exit 1
fi
