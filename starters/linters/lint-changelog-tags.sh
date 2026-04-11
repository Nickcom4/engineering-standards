#!/usr/bin/env bash
# CHANGELOG-to-git-tag congruence linter (adopter starter)
#
# Verifies every versioned heading in CHANGELOG.md (at or after the
# tagging-era consistency floor) has a matching annotated git tag,
# and every vX.Y.Z git tag has a matching CHANGELOG heading.
#
# The [Unreleased] heading is explicitly exempt.
#
# Parameterization:
#
#   PROJECT_ROOT      Your repo root. Default: git rev-parse or pwd.
#   CHANGELOG_FILE    Path to CHANGELOG.md.
#                     Default: ${PROJECT_ROOT}/CHANGELOG.md
#   CHANGELOG_TAGS_FLOOR  Lowest version to enforce (semver).
#                         Default: 0.0.0 (enforce all; override if
#                         historical releases were inconsistently tagged).
#
# Exit 0 = pass. Exit 1 = mismatch.

set -euo pipefail

PROJECT_ROOT="${PROJECT_ROOT:-$(git rev-parse --show-toplevel 2>/dev/null || pwd)}"
CHANGELOG_FILE="${CHANGELOG_FILE:-${PROJECT_ROOT}/CHANGELOG.md}"
FLOOR="${CHANGELOG_TAGS_FLOOR:-0.0.0}"

if [ ! -f "$CHANGELOG_FILE" ]; then
  echo "SKIP: CHANGELOG not found at $CHANGELOG_FILE"
  exit 0
fi

if ! git -C "$PROJECT_ROOT" rev-parse --git-dir >/dev/null 2>&1; then
  echo "SKIP: not inside a git working tree."
  exit 0
fi

CHANGELOG_VERSIONS=()
while IFS= read -r line; do
  if [[ "$line" =~ ^\#\#\ \[([0-9]+\.[0-9]+\.[0-9]+[^]]*)\]\ -\ ([0-9]{4}-[0-9]{2}-[0-9]{2}) ]]; then
    CHANGELOG_VERSIONS+=("${BASH_REMATCH[1]}")
  fi
done < "$CHANGELOG_FILE"

GIT_TAGS=()
while IFS= read -r tag; do
  if [[ "$tag" =~ ^v[0-9]+\.[0-9]+\.[0-9]+ ]]; then
    GIT_TAGS+=("${tag#v}")
  fi
done < <(git -C "$PROJECT_ROOT" tag -l 'v*' 2>/dev/null)

version_ge() {
  [ "$1" = "$2" ] && return 0
  local lowest
  lowest=$(printf '%s\n%s\n' "$1" "$2" | sort -V | head -1)
  [ "$lowest" = "$2" ]
}

MISSING_TAG=()
ORPHANED_TAG=()
SKIPPED_PRE_FLOOR=0

# Guard the loop for bash 3.2 + set -u empty-array behavior: an empty
# CHANGELOG_VERSIONS array expansion raises "unbound variable" without
# the length check. Matches the fix in ESE's internal version.
if [ ${#CHANGELOG_VERSIONS[@]} -gt 0 ]; then
  for v in "${CHANGELOG_VERSIONS[@]}"; do
    if ! version_ge "$v" "$FLOOR"; then
      SKIPPED_PRE_FLOOR=$((SKIPPED_PRE_FLOOR + 1))
      continue
    fi
    found=0
    if [ ${#GIT_TAGS[@]} -gt 0 ]; then
      for t in "${GIT_TAGS[@]}"; do
        [ "$v" = "$t" ] && found=1 && break
      done
    fi
    [ "$found" -eq 0 ] && MISSING_TAG+=("v$v")
  done
fi

if [ ${#GIT_TAGS[@]} -gt 0 ]; then
  for t in "${GIT_TAGS[@]}"; do
    found=0
    if [ ${#CHANGELOG_VERSIONS[@]} -gt 0 ]; then
      for v in "${CHANGELOG_VERSIONS[@]}"; do
        [ "$v" = "$t" ] && found=1 && break
      done
    fi
    [ "$found" -eq 0 ] && ORPHANED_TAG+=("v$t")
  done
fi

if [ ${#MISSING_TAG[@]} -gt 0 ] || [ ${#ORPHANED_TAG[@]} -gt 0 ]; then
  echo "FAIL: CHANGELOG-to-git-tag congruence mismatch."
  echo ""
  if [ ${#MISSING_TAG[@]} -gt 0 ]; then
    echo "CHANGELOG versions with no matching git tag:"
    for v in "${MISSING_TAG[@]}"; do echo "  $v"; done
    echo ""
  fi
  if [ ${#ORPHANED_TAG[@]} -gt 0 ]; then
    echo "Git tags with no matching CHANGELOG heading:"
    for t in "${ORPHANED_TAG[@]}"; do echo "  $t"; done
    echo ""
  fi
  echo "Raise CHANGELOG_TAGS_FLOOR if historical releases were"
  echo "inconsistently tagged and pre-floor drift is acceptable."
  exit 1
fi

CHECKED=$((${#CHANGELOG_VERSIONS[@]} - SKIPPED_PRE_FLOOR))
if [ "$SKIPPED_PRE_FLOOR" -gt 0 ]; then
  echo "PASS: $CHECKED CHANGELOG versions at/after floor v$FLOOR all have matching git tags ($SKIPPED_PRE_FLOOR pre-floor versions exempt)."
else
  echo "PASS: ${#CHANGELOG_VERSIONS[@]} CHANGELOG versions all have matching git tags."
fi
