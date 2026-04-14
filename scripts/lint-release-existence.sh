#!/usr/bin/env bash
# Release existence linter
#
# Errors when a repo has content under [Unreleased] in its CHANGELOG.md
# AND zero versioned git tags (git tag -l 'v*' returns empty). The
# combination means the repo accumulates changes without ever cutting a
# release, which bypasses lint-changelog-tags.sh (nothing to enforce) and
# the release trigger policy in ADR-2026-04-11.
#
# Parameterization:
#
#   PROJECT_ROOT      Repo root. Default: git rev-parse or pwd.
#   CHANGELOG_FILE    Path to CHANGELOG.md.
#                     Default: ${PROJECT_ROOT}/CHANGELOG.md
#
# Exit 0 = pass. Exit 1 = fail.

set -euo pipefail

PROJECT_ROOT="${PROJECT_ROOT:-$(git rev-parse --show-toplevel 2>/dev/null || pwd)}"
CHANGELOG_FILE="${CHANGELOG_FILE:-${PROJECT_ROOT}/CHANGELOG.md}"

if [ ! -f "$CHANGELOG_FILE" ]; then
  echo "SKIP: CHANGELOG not found at $CHANGELOG_FILE"
  exit 0
fi

if ! git -C "$PROJECT_ROOT" rev-parse --git-dir >/dev/null 2>&1; then
  echo "SKIP: not inside a git working tree."
  exit 0
fi

TAG_COUNT=$(git -C "$PROJECT_ROOT" tag -l 'v*' 2>/dev/null | wc -l | tr -d ' ')
if [ "$TAG_COUNT" -gt 0 ]; then
  echo "PASS: $TAG_COUNT versioned tag(s) found; release existence satisfied."
  exit 0
fi

in_unreleased=false
has_content=false

while IFS= read -r line; do
  if [[ "$line" =~ ^##\ \[Unreleased\] ]]; then
    in_unreleased=true
    continue
  fi
  if $in_unreleased && [[ "$line" =~ ^## ]]; then
    break
  fi
  if $in_unreleased; then
    stripped="${line#"${line%%[![:space:]]*}"}"
    [ -z "$stripped" ] && continue
    [ "$stripped" = "---" ] && continue
    [[ "$stripped" == "*No unreleased changes.*" ]] && continue
    has_content=true
    break
  fi
done < "$CHANGELOG_FILE"

if $has_content; then
  echo "FAIL: CHANGELOG has content under [Unreleased] but no versioned git tags exist."
  echo ""
  echo "  This repo has never cut a release. Changes accumulate under [Unreleased]"
  echo "  indefinitely, bypassing lint-changelog-tags.sh and the release trigger policy"
  echo "  (ADR-2026-04-11)."
  echo ""
  echo "  Fix: cut an initial release:"
  echo "    1. Move [Unreleased] content to a [0.1.0] heading with today's date"
  echo "    2. Commit: git commit -m \"chore: cut v0.1.0 release\""
  echo "    3. Tag:    git tag -a v0.1.0 -m \"v0.1.0\""
  exit 1
fi

echo "PASS: no versioned tags, but [Unreleased] has no real content; release existence satisfied."
