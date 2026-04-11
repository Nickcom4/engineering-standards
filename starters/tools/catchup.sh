#!/usr/bin/env bash
# catchup.sh: compact view of ESE changes between your project's pinned
# version and a target version.
#
# Usage:
#
#   bash scripts/catchup.sh              # catchup from pinned to latest
#   bash scripts/catchup.sh v2.5.0       # catchup from pinned to v2.5.0
#   bash scripts/catchup.sh v2.5.0 v2.6.0  # catchup from v2.5.0 to v2.6.0
#
# Produces three blocks:
#
#   1. Commit log (oneline) between the two versions, scoped to files adopters
#      care about: STANDARDS.md, addenda, templates, starters, scripts.
#   2. Files changed in those categories, bucketed by type.
#   3. A hint line pointing at CHANGELOG.md for the human-readable narrative.
#
# Parameterization:
#
#   ESE_ROOT  Path to vendored ESE submodule (default: .standards)

set -euo pipefail

PROJECT_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
cd "$PROJECT_ROOT"

: "${ESE_ROOT:=.standards}"

if [ ! -d "$ESE_ROOT" ]; then
    echo "catchup.sh: $ESE_ROOT does not exist" >&2
    exit 2
fi

# Ensure submodule knows about latest upstream
git -C "$ESE_ROOT" fetch origin --tags --quiet 2>/dev/null || true

# Resolve FROM and TO
FROM="${1:-}"
TO="${2:-origin/main}"

if [ -z "$FROM" ]; then
    FROM=$(git -C "$ESE_ROOT" rev-parse HEAD)
fi

# Resolve refs to commit SHAs
from_sha=$(git -C "$ESE_ROOT" rev-parse "$FROM" 2>/dev/null || echo "")
to_sha=$(git -C "$ESE_ROOT" rev-parse "$TO" 2>/dev/null || echo "")

if [ -z "$from_sha" ]; then
    echo "catchup.sh: cannot resolve FROM ref '$FROM'" >&2
    exit 2
fi
if [ -z "$to_sha" ]; then
    echo "catchup.sh: cannot resolve TO ref '$TO'" >&2
    exit 2
fi
if [ "$from_sha" = "$to_sha" ]; then
    echo "catchup.sh: FROM and TO are the same commit ($from_sha); nothing to report"
    exit 0
fi

echo "=== ESE catchup: $FROM -> $TO ==="
echo "  from: $from_sha"
echo "  to:   $to_sha"
echo ""

# 1. Commit log
echo "--- commits (oneline, adopter-relevant paths) ---"
git -C "$ESE_ROOT" log \
    --oneline \
    --no-decorate \
    "$from_sha..$to_sha" \
    -- \
    STANDARDS.md \
    'docs/addenda/**' \
    'templates/**' \
    'starters/**' \
    'scripts/**' \
    CHANGELOG.md \
    2>/dev/null || echo "  (no commits in this range touching adopter-relevant paths)"
echo ""

# 2. Files changed, bucketed
echo "--- files changed, by category ---"
changed=$(git -C "$ESE_ROOT" diff --name-only "$from_sha..$to_sha" 2>/dev/null || true)

category() {
    local label="$1"; shift
    local lines=""
    for pattern in "$@"; do
        lines="$lines"$'\n'"$(echo "$changed" | grep -E "^$pattern$" || true)"
    done
    lines=$(echo "$lines" | grep -v '^$' | sort -u)
    if [ -n "$lines" ]; then
        echo "  $label:"
        echo "$lines" | sed 's/^/    /'
    fi
}

category "STANDARDS.md" 'STANDARDS\.md'
category "addenda" 'docs/addenda/.*\.md'
category "templates" 'templates/.*\.md'
category "starter linters" 'starters/linters/.*'
category "starter tools" 'starters/tools/.*'
category "starter docs" 'starters/.*\.md'
category "ESE internal scripts (adopters do not vendor these)" 'scripts/.*'
category "CHANGELOG" 'CHANGELOG\.md'
echo ""

# 3. Hint
echo "--- next step ---"
echo "  Read .standards/CHANGELOG.md for the narrative of what shipped in each release."
echo "  Run 'bash scripts/upgrade-check.sh' after bumping the submodule to see drift impact."

exit 0
