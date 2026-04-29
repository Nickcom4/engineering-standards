#!/usr/bin/env bash
# Tag-tree congruence linter
#
# For every annotated release tag of the form vX.Y.Z, asserts that the tag
# points at a commit whose worktree is internally consistent with the tag
# version: CHANGELOG.md has a matching '## [X.Y.Z] - YYYY-MM-DD' heading,
# docs/standards-application.md declares ese-version "X.Y.Z" (and the
# matching footer line), and the tag commit is reachable from origin/main.
#
# Catches the cut-before-promotion anti-pattern that produced two prior
# incidents:
#
#   1. v2.18.0 (2026-04-28): tag was applied at a commit that predated the
#      CHANGELOG promotion. CHANGELOG at that tree still listed the v2.18.0
#      entries under [Unreleased]; ese-version was still "2.17.0". Adopters
#      bumping the submodule to v2.18.0 had Tier3 of
#      lint-standards-application-frontmatter.sh fail. Fixed by cutting
#      v2.18.1 at a commit that included the promotion (CHANGELOG-2.18.1
#      Fixed entry).
#
#   2. v2.19.0 (2026-04-29): tag was applied at a commit (e9128a2) that
#      had the CHANGELOG heading promoted but ese-version was still
#      "2.18.1". Same defect class, different field. Fixed by a follow-up
#      commit and a force-moved tag.
#
# Existing lint-changelog-tags.sh checks that every CHANGELOG heading has
# a matching tag and vice versa, but only at the working-tree state. It
# does not look inside the tag's tree, so it cannot catch a tag pointing
# at a pre-promotion commit. This linter closes that gap.
#
# Per ADR-2026-04-11 (release trigger policy), release ceremony commits
# must atomically (a) move the [Unreleased] heading to a versioned heading
# in CHANGELOG.md and (b) update ese-version + footer in
# docs/standards-application.md. Tags must be applied at a ceremony commit,
# not before it.
#
# Parameterization:
#
#   PROJECT_ROOT       Repo root. Default: git rev-parse or pwd.
#   CHANGELOG_FILE     Filename inside the tag tree. Default: CHANGELOG.md
#   STANDARDS_APP_FILE Filename inside the tag tree.
#                      Default: docs/standards-application.md
#   REACHABILITY_REF   Ref the tag commit must be reachable from.
#                      Default: origin/main; falls back to main, then
#                      master, then HEAD if origin/main is unavailable
#                      (e.g. a fresh clone before the first fetch, or a
#                      test fixture without an origin remote).
#
# Exit 0 = pass (or skip with rationale). Exit 1 = at least one tag failed.
#
# status: gate

set -euo pipefail

PROJECT_ROOT="${PROJECT_ROOT:-$(git rev-parse --show-toplevel 2>/dev/null || pwd)}"
CHANGELOG_FILE="${CHANGELOG_FILE:-CHANGELOG.md}"
STANDARDS_APP_FILE="${STANDARDS_APP_FILE:-docs/standards-application.md}"

if ! git -C "$PROJECT_ROOT" rev-parse --git-dir >/dev/null 2>&1; then
  echo "SKIP: not inside a git working tree."
  exit 0
fi

# -------------------------------------------------------------------------
# Reachability ref selection
#
# Prefer origin/main (the canonical branch); fall back to local main,
# master, then HEAD. A repo with no origin/main reference still gets a
# meaningful reachability check against whatever local mainline exists.
# -------------------------------------------------------------------------
REACH_REF="${REACHABILITY_REF:-}"
if [ -z "$REACH_REF" ]; then
  for candidate in origin/main origin/master main master HEAD; do
    if git -C "$PROJECT_ROOT" rev-parse --verify --quiet "$candidate" >/dev/null 2>&1; then
      REACH_REF="$candidate"
      break
    fi
  done
fi
if [ -z "$REACH_REF" ]; then
  echo "SKIP: no reachability ref available (origin/main, main, master, HEAD all missing)."
  exit 0
fi

# -------------------------------------------------------------------------
# Historical-incident exemption
#
# v2.18.0 is the documented prior incident this linter exists to prevent.
# Its tree is intentionally exempt: the historical record stands as-is,
# the v2.18.1 CHANGELOG entry captures the failure, and retroactively
# rewriting the tag would invalidate any consumer who already pinned it.
# Add new entries only for tags whose state cannot be corrected and whose
# failure mode is already documented.
# -------------------------------------------------------------------------
EXEMPT_TAGS=(
  "v2.18.0"
)

is_exempt() {
  local tag="$1"
  local exempt
  for exempt in "${EXEMPT_TAGS[@]}"; do
    if [ "$tag" = "$exempt" ]; then
      return 0
    fi
  done
  return 1
}

# -------------------------------------------------------------------------
# Collect release tags
# -------------------------------------------------------------------------
TAGS=()
while IFS= read -r tag; do
  if [[ "$tag" =~ ^v[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    TAGS+=("$tag")
  fi
done < <(git -C "$PROJECT_ROOT" tag -l 'v*' 2>/dev/null | sort -V)

if [ "${#TAGS[@]}" -eq 0 ]; then
  echo "SKIP: no annotated vX.Y.Z tags found (fresh clone or pre-release repo)."
  exit 0
fi

# -------------------------------------------------------------------------
# Per-tag checks
# -------------------------------------------------------------------------
FAIL_COUNT=0
PASS_COUNT=0
EXEMPT_COUNT=0

for tag in "${TAGS[@]}"; do
  version="${tag#v}"

  if is_exempt "$tag"; then
    echo "EXEMPT: $tag (historical incident; see lint script header)."
    EXEMPT_COUNT=$((EXEMPT_COUNT + 1))
    continue
  fi

  failures=()

  # Check 1: CHANGELOG.md inside the tag tree has matching versioned heading.
  #
  # Implementation note: use bash here-strings (<<<) rather than pipes into
  # grep -q. With `set -o pipefail`, grep -q exits early on match, which
  # SIGPIPEs the upstream `printf` and produces exit 141 for the pipeline.
  # The `if !` then reads as "not match" even on a real match. Here-strings
  # avoid the pipe entirely.
  cl_content=$(git -C "$PROJECT_ROOT" show "${tag}:${CHANGELOG_FILE}" 2>/dev/null || true)
  if [ -z "$cl_content" ]; then
    failures+=("missing ${CHANGELOG_FILE} in tag tree")
  else
    # Pattern: ## [X.Y.Z] - YYYY-MM-DD
    # Trailing whitespace tolerated (some prior commits had it).
    if ! grep -qE "^## \[${version//./\\.}\] - [0-9]{4}-[0-9]{2}-[0-9]{2}" <<< "$cl_content"; then
      failures+=("CHANGELOG.md has no '## [${version}] - YYYY-MM-DD' heading at this tree (likely still under [Unreleased])")
    fi
  fi

  # Check 2: docs/standards-application.md ese-version frontmatter matches.
  sa_content=$(git -C "$PROJECT_ROOT" show "${tag}:${STANDARDS_APP_FILE}" 2>/dev/null || true)
  if [ -z "$sa_content" ]; then
    # Not all repos have docs/standards-application.md; skip silently for those.
    # When the file is absent across the entire history, the lint adds no
    # value but should not block.
    if git -C "$PROJECT_ROOT" cat-file -e "${tag}:${STANDARDS_APP_FILE}" 2>/dev/null; then
      failures+=("could not read ${STANDARDS_APP_FILE} at tag tree")
    fi
    # else: file does not exist at this tag; treat as not-applicable.
  else
    declared_ev=$(grep -E '^ese-version:' <<< "$sa_content" | head -1 | sed -E 's/^ese-version:[[:space:]]*"?([^"#]+)"?.*/\1/' | tr -d '[:space:]' || true)
    if [ -z "$declared_ev" ]; then
      failures+=("${STANDARDS_APP_FILE} has no ese-version field at this tree")
    elif [ "$declared_ev" != "$version" ]; then
      failures+=("ese-version=\"${declared_ev}\" but tag is ${tag} (frontmatter not bumped)")
    else
      # Footer line must also match per the ceremony rule.
      if ! grep -qE "^\*Standard version applied: ${version//./\\.}\*" <<< "$sa_content"; then
        failures+=("footer 'Standard version applied: ${version}' missing or stale in ${STANDARDS_APP_FILE}")
      fi
    fi
  fi

  # Check 3: tag commit reachable from the chosen mainline ref.
  if ! git -C "$PROJECT_ROOT" merge-base --is-ancestor "$tag" "$REACH_REF" >/dev/null 2>&1; then
    failures+=("tag commit not reachable from ${REACH_REF} (orphaned tag on a side branch?)")
  fi

  if [ "${#failures[@]}" -eq 0 ]; then
    echo "PASS: $tag tree consistent (CHANGELOG heading, ese-version, reachability)."
    PASS_COUNT=$((PASS_COUNT + 1))
  else
    echo "FAIL: $tag"
    for f in "${failures[@]}"; do
      echo "  - $f"
    done
    FAIL_COUNT=$((FAIL_COUNT + 1))
  fi
done

echo ""
if [ "$FAIL_COUNT" -gt 0 ]; then
  echo "FAIL: $FAIL_COUNT tag(s) failed; $PASS_COUNT passed; $EXEMPT_COUNT exempt."
  echo ""
  echo "Fix: a release tag must point at the ceremony commit that promoted"
  echo "[Unreleased] to ## [X.Y.Z] in CHANGELOG.md AND bumped ese-version +"
  echo "footer in docs/standards-application.md (per ADR-2026-04-11). If the"
  echo "tag was applied early, force-move it to the correct ceremony SHA"
  echo "(git tag -f vX.Y.Z <sha> && git push --force origin vX.Y.Z) only if"
  echo "no consumer has pinned it; otherwise cut a follow-up patch release."
  exit 1
fi

echo "PASS: $PASS_COUNT tag(s) tree-consistent; $EXEMPT_COUNT exempt; reachability checked against ${REACH_REF}."
exit 0
