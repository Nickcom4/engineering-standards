#!/usr/bin/env bash
# CHANGELOG-to-git-tag congruence linter
# Verifies that every versioned heading in CHANGELOG.md has a matching
# git tag, and every vX.Y.Z tag has a matching CHANGELOG heading. The
# [Unreleased] heading is explicitly exempt (it is the one allowed
# unmatched heading, by convention).
#
# Catches two classes of mistake:
#   1. A release ceremony commit that moved [Unreleased] to a versioned
#      heading but forgot to apply the git tag (or tagged the wrong SHA
#      and then force-moved/deleted it).
#   2. A git tag that was applied without a corresponding CHANGELOG
#      heading, which would mean a release shipped without a changelog
#      entry (REQ-4.3-01 violation).
#
# Per ADR-2026-04-11 (release trigger policy), release ceremony commits
# must atomically promote the [Unreleased] heading and (in the canonical
# direct-to-main flow) apply the tag in the same operation.
#
# Tag-applied-after-merge window (issue #30). PR-based release ceremonies
# under branch protection cannot apply the tag on the PR branch (the tag
# would point at a pre-merge SHA and fail reachability post-squash). The
# tag is applied to the squash-merged SHA after the PR lands on
# origin/main, which leaves a brief heading-without-tag window. This
# linter accepts that window when, and only when, EXACTLY ONE versioned
# heading has no matching tag AND that heading is the topmost (most
# recent) versioned heading in CHANGELOG.md. Any other unmatched-heading
# state remains a failure: two or more unmatched means the operator
# missed prior tags; a non-topmost unmatched means a stale skip.
#
# The window is bounded structurally rather than by time: a subsequent
# release ceremony that promotes a new heading without first tagging the
# pending one produces two unmatched headings and fails.
#
# Exit 0 = pass (including the pending-window state). Exit 1 = mismatch.

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
CHANGELOG="$REPO_ROOT/CHANGELOG.md"

if [ ! -f "$CHANGELOG" ]; then
  echo "SKIP: CHANGELOG.md not found."
  exit 0
fi

if ! git -C "$REPO_ROOT" rev-parse --git-dir >/dev/null 2>&1; then
  echo "SKIP: not inside a git working tree."
  exit 0
fi

# -------------------------------------------------------------------------
# Extract versioned headings from CHANGELOG
# Pattern: ## [X.Y.Z] - YYYY-MM-DD
# The [Unreleased] heading is explicitly excluded.
# -------------------------------------------------------------------------
CHANGELOG_VERSIONS=()
while IFS= read -r line; do
  if [[ "$line" =~ ^\#\#\ \[([0-9]+\.[0-9]+\.[0-9]+[^]]*)\]\ -\ ([0-9]{4}-[0-9]{2}-[0-9]{2}) ]]; then
    CHANGELOG_VERSIONS+=("${BASH_REMATCH[1]}")
  fi
done < "$CHANGELOG"

# -------------------------------------------------------------------------
# Extract vX.Y.Z tags from git
# -------------------------------------------------------------------------
GIT_TAGS=()
while IFS= read -r tag; do
  # Accept v-prefixed semver tags (with optional pre-release suffix)
  if [[ "$tag" =~ ^v[0-9]+\.[0-9]+\.[0-9]+ ]]; then
    GIT_TAGS+=("${tag#v}")
  fi
done < <(git -C "$REPO_ROOT" tag -l 'v*' 2>/dev/null)

# -------------------------------------------------------------------------
# Tagging-era consistency floor
#
# Pre-v2.1.0 releases had inconsistent tagging: v1.7.0 and v1.8.0 were
# tagged, then v1.9.0 through v2.0.0 shipped untagged, then tagging
# resumed at v2.1.0. Starting with v2.1.0, every release is expected
# to be tagged per the release discipline that was later formalized
# in ADR-2026-04-11.
#
# This floor is therefore explicit rather than derived from "first tag"
# (which would give v1.7.0 and wrongly require v1.9.0-v2.0.0 to be
# retroactively tagged). Pre-floor CHANGELOG versions are intentionally
# exempt: their SHAs are not recoverable with useful precision and the
# historical record stands as-is.
#
# Update FLOOR only when a deliberate policy change moves the
# consistency boundary forward; never move it backward (that would
# require retroactive tagging).
# -------------------------------------------------------------------------
FLOOR="2.1.0"

# version_ge: returns 0 (true) if $1 >= $2 in semver order
version_ge() {
  [ "$1" = "$2" ] && return 0
  local lowest
  lowest=$(printf '%s\n%s\n' "$1" "$2" | sort -V | head -1)
  [ "$lowest" = "$2" ]
}

# -------------------------------------------------------------------------
# Congruence checks
# -------------------------------------------------------------------------
MISSING_TAG=()
ORPHANED_TAG=()
SKIPPED_PRE_FLOOR=0

# Every CHANGELOG version at or after the tagging-era floor should have a
# matching tag. Pre-floor versions are historical and exempt.
# Guard the loop for bash 3.2 + set -u empty-array behavior: an empty
# CHANGELOG_VERSIONS array expansion raises "unbound variable" without
# the length check.
if [ "${#CHANGELOG_VERSIONS[@]}" -gt 0 ]; then
  for v in "${CHANGELOG_VERSIONS[@]}"; do
    # Skip pre-floor versions (exempt)
    if [ -n "$FLOOR" ] && ! version_ge "$v" "$FLOOR"; then
      SKIPPED_PRE_FLOOR=$((SKIPPED_PRE_FLOOR + 1))
      continue
    fi

    found=0
    if [ "${#GIT_TAGS[@]}" -gt 0 ]; then
      for t in "${GIT_TAGS[@]}"; do
        if [ "$v" = "$t" ]; then
          found=1
          break
        fi
      done
    fi
    if [ "$found" -eq 0 ]; then
      MISSING_TAG+=("v$v")
    fi
  done
fi

# Tag-applied-after-merge window (issue #30): if exactly one CHANGELOG
# version is unmatched AND it is the topmost versioned heading (the most
# recent release ceremony promotion), accept it as the pending release
# whose tag will be applied to the squash-merged SHA after the PR lands.
# Any other shape (zero, two-or-more, or a non-topmost single) keeps the
# original behavior.
PENDING_RELEASE=""
if [ "${#MISSING_TAG[@]}" -eq 1 ] && [ "${#CHANGELOG_VERSIONS[@]}" -gt 0 ]; then
  topmost_version="${CHANGELOG_VERSIONS[0]}"
  candidate_version="${MISSING_TAG[0]#v}"
  if [ "$candidate_version" = "$topmost_version" ]; then
    PENDING_RELEASE="$candidate_version"
    MISSING_TAG=()
  fi
fi

# Every git tag should have a matching CHANGELOG version
if [ "${#GIT_TAGS[@]}" -gt 0 ]; then
  for t in "${GIT_TAGS[@]}"; do
    found=0
    if [ "${#CHANGELOG_VERSIONS[@]}" -gt 0 ]; then
      for v in "${CHANGELOG_VERSIONS[@]}"; do
        if [ "$v" = "$t" ]; then
          found=1
          break
        fi
      done
    fi
    if [ "$found" -eq 0 ]; then
      ORPHANED_TAG+=("v$t")
    fi
  done
fi

if [ ${#MISSING_TAG[@]} -gt 0 ] || [ ${#ORPHANED_TAG[@]} -gt 0 ]; then
  echo "FAIL: CHANGELOG-to-git-tag congruence mismatch."
  echo ""
  if [ ${#MISSING_TAG[@]} -gt 0 ]; then
    echo "CHANGELOG versions with no matching git tag:"
    for v in "${MISSING_TAG[@]}"; do
      echo "  $v: in CHANGELOG.md but 'git tag $v' does not exist"
    done
    echo ""
    echo "Fix: apply the missing tag to the ceremony commit with"
    echo "  git tag <version> <sha> -m '...'"
    echo "or remove the stale CHANGELOG heading if the release never shipped."
    echo ""
  fi
  if [ ${#ORPHANED_TAG[@]} -gt 0 ]; then
    echo "Git tags with no matching CHANGELOG heading:"
    for t in "${ORPHANED_TAG[@]}"; do
      echo "  $t: git tag exists but '## [${t#v}] - YYYY-MM-DD' not in CHANGELOG.md"
    done
    echo ""
    echo "Fix: add a '## [${ORPHANED_TAG[0]#v}] - YYYY-MM-DD' heading to CHANGELOG.md"
    echo "summarizing what shipped in that release, or delete the tag if applied"
    echo "in error (git tag -d ${ORPHANED_TAG[0]})."
    echo ""
  fi
  exit 1
fi

CHECKED=$((${#CHANGELOG_VERSIONS[@]} - SKIPPED_PRE_FLOOR))
PENDING_NOTE=""
if [ -n "$PENDING_RELEASE" ]; then
  PENDING_NOTE=" (v${PENDING_RELEASE} pending: heading promoted, tag-application window open until merged SHA is tagged on origin/main)"
fi
if [ "$SKIPPED_PRE_FLOOR" -gt 0 ]; then
  echo "PASS: $CHECKED CHANGELOG versions at/after floor v$FLOOR all have matching git tags (${#GIT_TAGS[@]} tags total; $SKIPPED_PRE_FLOOR pre-floor versions exempt)${PENDING_NOTE}."
else
  echo "PASS: ${#CHANGELOG_VERSIONS[@]} CHANGELOG versions all have matching git tags (${#GIT_TAGS[@]} tags total)${PENDING_NOTE}."
fi
