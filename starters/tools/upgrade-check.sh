#!/usr/bin/env bash
# upgrade-check.sh: detect drift between your project's pinned ESE version
# and the current ESE submodule state, and produce a task list of what to
# update.
#
# Usage:
#
#   bash scripts/upgrade-check.sh          # show drift report and task list
#   bash scripts/upgrade-check.sh --quiet  # exit code only; no output
#
# Three drift dimensions are checked:
#
#   1. Submodule pin drift. Your `.standards/` submodule HEAD vs the tracked
#      upstream branch. If your local pin is behind upstream, this tool
#      reports the commit delta and suggests `git -C .standards checkout`.
#
#   2. Declared version vs pinned version. Your `docs/standards-application.md`
#      frontmatter `ese-version` field vs the latest version tag visible in
#      `.standards/`. If you have bumped the submodule but forgotten to update
#      the declaration, this tool surfaces that.
#
#   3. Vendored file drift. Each script in `scripts/lint-*.sh`,
#      `scripts/new-artifact.sh`, `scripts/pre-commit`, and
#      `scripts/template-instance-mappings.txt` is byte-compared against its
#      upstream counterpart in `.standards/starters/`. Drift is reported
#      file-by-file so you can decide which local customizations to keep.
#
# Exit 0 if no drift detected. Exit 1 if any drift category fired.
# Exit 2 on usage or setup error.
#
# Parameterization:
#
#   ESE_ROOT          Path to vendored ESE submodule (default: .standards)
#   APPLICATION_FILE  Path to your standards-application.md
#                     (default: docs/standards-application.md)

set -euo pipefail

PROJECT_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
cd "$PROJECT_ROOT"

: "${ESE_ROOT:=.standards}"
: "${APPLICATION_FILE:=docs/standards-application.md}"

MODE=normal
for arg in "$@"; do
    case "$arg" in
        --quiet) MODE=quiet ;;
        --help|-h)
            sed -n '2,34p' "$0" | sed 's/^# \{0,1\}//'
            exit 0
            ;;
        *) echo "upgrade-check.sh: unknown argument: $arg" >&2; exit 2 ;;
    esac
done

if [ ! -d "$ESE_ROOT" ]; then
    echo "upgrade-check.sh: $ESE_ROOT does not exist; is the submodule initialized?" >&2
    exit 2
fi

drift=0
say() { [ "$MODE" = "normal" ] && echo "$@"; return 0; }

say "=== ESE upgrade check ==="
say ""

# 1. Submodule pin drift
say "--- Dimension 1: submodule pin drift ---"
pinned=$(git -C "$ESE_ROOT" rev-parse HEAD 2>/dev/null || echo "")
if [ -z "$pinned" ]; then
    say "WARN: could not read submodule HEAD; is $ESE_ROOT a valid git repo?"
    drift=1
else
    git -C "$ESE_ROOT" fetch origin --quiet 2>/dev/null || true
    upstream=$(git -C "$ESE_ROOT" rev-parse origin/main 2>/dev/null || echo "")
    if [ -z "$upstream" ]; then
        say "WARN: could not read upstream ref; is $ESE_ROOT/origin/main reachable?"
        drift=1
    elif [ "$pinned" = "$upstream" ]; then
        say "OK: submodule at origin/main ($pinned)"
    else
        behind=$(git -C "$ESE_ROOT" rev-list --count "$pinned..$upstream" 2>/dev/null || echo "?")
        say "DRIFT: submodule is $behind commits behind origin/main"
        say "  pinned:   $pinned"
        say "  upstream: $upstream"
        say "  Fix: git -C $ESE_ROOT fetch origin && git -C $ESE_ROOT checkout origin/main && git add $ESE_ROOT && git commit -m 'chore: bump ESE submodule'"
        drift=1
    fi
fi
say ""

# 2. Declared version vs pinned version
say "--- Dimension 2: declared ese-version vs pinned submodule tag ---"
if [ ! -f "$APPLICATION_FILE" ]; then
    say "WARN: $APPLICATION_FILE does not exist; cannot check ese-version declaration"
    drift=1
else
    declared=$(python3 -c "
import re, sys
try:
    c = open('$APPLICATION_FILE').read()
    m = re.match(r'^---\n(.*?)\n---\n', c, re.DOTALL)
    if m:
        for line in m.group(1).split('\n'):
            mm = re.match(r'^ese-version:\s*\"?([^\"\s#]+)', line)
            if mm:
                print(mm.group(1))
                sys.exit(0)
    print('')
except Exception:
    print('')
")
    pinned_tag=$(git -C "$ESE_ROOT" describe --tags --abbrev=0 2>/dev/null || echo "")
    if [ -z "$declared" ]; then
        say "WARN: no ese-version field in $APPLICATION_FILE frontmatter"
        drift=1
    elif [ -z "$pinned_tag" ]; then
        say "WARN: $ESE_ROOT has no tags visible; cannot compare"
        drift=1
    else
        declared_clean="${declared#v}"
        pinned_clean="${pinned_tag#v}"
        if [ "$declared_clean" = "$pinned_clean" ]; then
            say "OK: declared ese-version '$declared_clean' matches pinned submodule tag '$pinned_tag'"
        else
            say "DRIFT: declared ese-version '$declared_clean' vs pinned submodule tag '$pinned_tag'"
            say "  Fix: update ese-version in $APPLICATION_FILE YAML frontmatter AND the footer"
            say "       '*Standard version applied: X*' line to match pinned tag"
            drift=1
        fi
    fi
fi
say ""

# 3. Vendored file drift
say "--- Dimension 3: vendored file drift ---"
expected_mappings=(
    "scripts/lint-template-compliance.sh:$ESE_ROOT/starters/linters/lint-template-compliance.sh"
    "scripts/lint-standards-application-frontmatter.sh:$ESE_ROOT/starters/linters/lint-standards-application-frontmatter.sh"
    "scripts/lint-fmea-congruence.sh:$ESE_ROOT/starters/linters/lint-fmea-congruence.sh"
    "scripts/lint-orphan-adrs.sh:$ESE_ROOT/starters/linters/lint-orphan-adrs.sh"
    "scripts/lint-changelog-tags.sh:$ESE_ROOT/starters/linters/lint-changelog-tags.sh"
    "scripts/lint-orphan-scripts.sh:$ESE_ROOT/starters/linters/lint-orphan-scripts.sh"
    "scripts/lint-readme-structure.sh:$ESE_ROOT/starters/linters/lint-readme-structure.sh"
    "scripts/lint-count-congruence.sh:$ESE_ROOT/starters/linters/lint-count-congruence.sh"
    "scripts/new-artifact.sh:$ESE_ROOT/starters/tools/new-artifact.sh"
)
vendored_drift=0
for pair in "${expected_mappings[@]}"; do
    local_file="${pair%%:*}"
    upstream_file="${pair##*:}"
    if [ ! -f "$local_file" ]; then
        say "MISSING: $local_file (upstream: $upstream_file)"
        vendored_drift=$((vendored_drift + 1))
    elif [ ! -f "$upstream_file" ]; then
        say "UPSTREAM MISSING: $upstream_file (local: $local_file)"
    elif ! diff -q "$local_file" "$upstream_file" >/dev/null 2>&1; then
        say "DRIFT: $local_file differs from $upstream_file"
        vendored_drift=$((vendored_drift + 1))
    fi
done
if [ "$vendored_drift" -eq 0 ]; then
    say "OK: all vendored files byte-identical to upstream (or intentionally missing)"
else
    drift=1
    say ""
    say "  Fix: decide per file whether to re-copy from upstream (discarding local changes)"
    say "       or keep the local customization and document why in a CHANGELOG entry."
fi
say ""

say "=== upgrade-check summary ==="
if [ "$drift" -eq 0 ]; then
    say "OK: no drift detected across all three dimensions"
else
    say "DRIFT DETECTED: see dimensions above"
fi

exit "$drift"
