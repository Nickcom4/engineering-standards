#!/usr/bin/env bash
# Tests for scripts/lint-tag-tree-congruence.sh
#
# Builds isolated git fixtures in $TMPDIR and runs the linter against them
# under controlled conditions. Each case constructs a minimal repo, applies
# tags at deliberately good or bad commits, and asserts the linter returns
# the expected exit code with the expected message.
#
# Run: bash tests/test-lint-tag-tree-congruence.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
LINT="$REPO_ROOT/scripts/lint-tag-tree-congruence.sh"

if [ ! -x "$LINT" ] && [ ! -f "$LINT" ]; then
  echo "FAIL: linter not found at $LINT"
  exit 1
fi

PASS_CASES=0
FAIL_CASES=0

# -------------------------------------------------------------------------
# Fixture helpers
# -------------------------------------------------------------------------

# init_fixture <dir>: bootstrap a minimal repo with a known committer identity.
init_fixture() {
  local dir="$1"
  mkdir -p "$dir"
  git -C "$dir" init -q -b main
  git -C "$dir" config user.email "test@example.invalid"
  git -C "$dir" config user.name "Tag Tree Test"
}

# Write a CHANGELOG.md with [Unreleased] holding entries for the given version.
# Used to simulate the "tagged before promotion" state.
write_changelog_unreleased() {
  local dir="$1"
  local version="$2"
  cat > "$dir/CHANGELOG.md" <<EOF
# Changelog

## [Unreleased]

### Added

- Feature shipped in version $version (still under [Unreleased])

EOF
}

# Write a CHANGELOG.md with the given version promoted to a heading.
write_changelog_promoted() {
  local dir="$1"
  local version="$2"
  local date="$3"
  cat > "$dir/CHANGELOG.md" <<EOF
# Changelog

## [Unreleased]

## [$version] - $date

### Added

- Feature shipped in version $version

EOF
}

# Write a docs/standards-application.md with the given ese-version.
write_sa() {
  local dir="$1"
  local version="$2"
  local date="$3"
  mkdir -p "$dir/docs"
  cat > "$dir/docs/standards-application.md" <<EOF
---
ese-version: "$version"
last-updated: "$date"
---

# Standards application

*Standard version applied: $version*
*Last updated: $date*
EOF
}

# Run the linter against $1, capturing exit code and stdout.
# Sets globals RC and OUT.
run_lint() {
  local dir="$1"
  set +e
  OUT=$(PROJECT_ROOT="$dir" REACHABILITY_REF="main" bash "$LINT" 2>&1)
  RC=$?
  set -e
}

# assert_pass: expect exit 0 and a "PASS:" line for the named tag.
assert_case_pass() {
  local name="$1"
  local tag="$2"
  if [ "$RC" -ne 0 ]; then
    echo "FAIL [$name]: expected exit 0, got $RC"
    echo "$OUT" | sed 's/^/  /'
    FAIL_CASES=$((FAIL_CASES + 1))
    return
  fi
  if ! grep -qE "^PASS: ${tag} tree consistent" <<< "$OUT"; then
    echo "FAIL [$name]: expected 'PASS: $tag tree consistent' in output"
    echo "$OUT" | sed 's/^/  /'
    FAIL_CASES=$((FAIL_CASES + 1))
    return
  fi
  echo "PASS [$name]"
  PASS_CASES=$((PASS_CASES + 1))
}

# assert_case_fail: expect exit 1, a FAIL line for $tag, and a substring match.
assert_case_fail() {
  local name="$1"
  local tag="$2"
  local expect_msg="$3"
  if [ "$RC" -ne 1 ]; then
    echo "FAIL [$name]: expected exit 1, got $RC"
    echo "$OUT" | sed 's/^/  /'
    FAIL_CASES=$((FAIL_CASES + 1))
    return
  fi
  if ! grep -qE "^FAIL: ${tag}$" <<< "$OUT"; then
    echo "FAIL [$name]: expected 'FAIL: $tag' in output"
    echo "$OUT" | sed 's/^/  /'
    FAIL_CASES=$((FAIL_CASES + 1))
    return
  fi
  if ! grep -qF "$expect_msg" <<< "$OUT"; then
    echo "FAIL [$name]: expected substring '$expect_msg' in output"
    echo "$OUT" | sed 's/^/  /'
    FAIL_CASES=$((FAIL_CASES + 1))
    return
  fi
  echo "PASS [$name]"
  PASS_CASES=$((PASS_CASES + 1))
}

# -------------------------------------------------------------------------
# Case 1: PASS fixture.
# CHANGELOG has matching '## [1.0.0] - YYYY-MM-DD' heading; ese-version is
# "1.0.0"; tag commit is on main. Linter must exit 0 with PASS: v1.0.0.
# -------------------------------------------------------------------------
case_pass() {
  local dir
  dir=$(mktemp -d -t tag-tree-pass.XXXXXX)
  init_fixture "$dir"
  write_changelog_promoted "$dir" "1.0.0" "2026-04-29"
  write_sa "$dir" "1.0.0" "2026-04-29"
  git -C "$dir" add -A
  git -C "$dir" commit -q -m "release: v1.0.0"
  git -C "$dir" tag -a v1.0.0 -m "v1.0.0"

  run_lint "$dir"
  assert_case_pass "case 1: PASS fixture" "v1.0.0"
  rm -rf "$dir"
}

# -------------------------------------------------------------------------
# Case 2: FAIL fixture (CHANGELOG mismatch / cut-before-promotion).
# Tag points at a commit where CHANGELOG still has the v2.18.0 entries
# under [Unreleased] (the v2.18.0 incident pattern). Linter must exit 1
# with a "no '## [X.Y.Z] - YYYY-MM-DD' heading" failure.
# -------------------------------------------------------------------------
case_fail_changelog_unreleased() {
  local dir
  dir=$(mktemp -d -t tag-tree-fail-cl.XXXXXX)
  init_fixture "$dir"
  write_changelog_unreleased "$dir" "1.0.0"
  write_sa "$dir" "1.0.0" "2026-04-29"
  git -C "$dir" add -A
  git -C "$dir" commit -q -m "tag-before-promotion: v1.0.0 entries still under [Unreleased]"
  # Tag this pre-promotion commit (the anti-pattern).
  git -C "$dir" tag -a v1.0.0 -m "v1.0.0"

  run_lint "$dir"
  assert_case_fail \
    "case 2: CHANGELOG still under [Unreleased] (v2.18.0 pattern)" \
    "v1.0.0" \
    "no '## [1.0.0] - YYYY-MM-DD' heading"
  rm -rf "$dir"
}

# -------------------------------------------------------------------------
# Case 3: FAIL fixture (orphaned tag on side branch).
# Tag is applied on a side branch never merged into main. Linter must
# exit 1 with a "not reachable from" failure.
# -------------------------------------------------------------------------
case_fail_orphan_tag() {
  local dir
  dir=$(mktemp -d -t tag-tree-fail-orphan.XXXXXX)
  init_fixture "$dir"
  # main: an initial commit that does NOT correspond to v1.0.0.
  echo "initial" > "$dir/README.md"
  git -C "$dir" add -A
  git -C "$dir" commit -q -m "initial"
  # side: branch off, write a tree-consistent v1.0.0 commit, tag it,
  # but never merge into main.
  git -C "$dir" checkout -q -b side
  write_changelog_promoted "$dir" "1.0.0" "2026-04-29"
  write_sa "$dir" "1.0.0" "2026-04-29"
  git -C "$dir" add -A
  git -C "$dir" commit -q -m "release: v1.0.0 (side branch only)"
  git -C "$dir" tag -a v1.0.0 -m "v1.0.0"
  # back to main; the tag is now unreachable from main.
  git -C "$dir" checkout -q main

  run_lint "$dir"
  assert_case_fail \
    "case 3: orphan tag on side branch" \
    "v1.0.0" \
    "not reachable from main"
  rm -rf "$dir"
}

# -------------------------------------------------------------------------
# Case 4: FAIL fixture (ese-version mismatch / v2.19.0 pattern).
# CHANGELOG has the matching heading, but standards-application.md
# ese-version is stale. This is the e9128a2 state that produced the
# v2.19.0 incident. Linter must exit 1 with an "ese-version" failure.
# -------------------------------------------------------------------------
case_fail_ese_version_stale() {
  local dir
  dir=$(mktemp -d -t tag-tree-fail-ev.XXXXXX)
  init_fixture "$dir"
  write_changelog_promoted "$dir" "1.0.0" "2026-04-29"
  # ese-version stale at "0.9.0" while we are tagging v1.0.0.
  write_sa "$dir" "0.9.0" "2026-04-29"
  git -C "$dir" add -A
  git -C "$dir" commit -q -m "partial-promotion: CHANGELOG bumped, ese-version stale"
  git -C "$dir" tag -a v1.0.0 -m "v1.0.0"

  run_lint "$dir"
  assert_case_fail \
    "case 4: ese-version stale (v2.19.0 pattern)" \
    "v1.0.0" \
    "ese-version=\"0.9.0\" but tag is v1.0.0"
  rm -rf "$dir"
}

# -------------------------------------------------------------------------
# Run all cases
# -------------------------------------------------------------------------
echo "Running tests for lint-tag-tree-congruence.sh..."
echo ""
case_pass
case_fail_changelog_unreleased
case_fail_orphan_tag
case_fail_ese_version_stale

echo ""
echo "Test summary: $PASS_CASES passed, $FAIL_CASES failed."
if [ "$FAIL_CASES" -gt 0 ]; then
  exit 1
fi
exit 0
