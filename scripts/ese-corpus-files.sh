#!/usr/bin/env bash
# Single source of truth for the ESE corpus file list.
# All scripts that scan REQ-IDs source this file to get the FILES array.
# Adding a new file group requires changing ONLY this file.
#
# Usage (from another script):
#   REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
#   source "$REPO_ROOT/scripts/ese-corpus-files.sh"
#   # FILES array is now populated
#
# Root cause: -- 4 scripts had independent file lists, causing
# T7 manifest to silently exclude 129 REQ-IDs.

FILES=("$REPO_ROOT/STANDARDS.md")

# Addenda
for f in "$REPO_ROOT"/docs/addenda/*.md; do
  [ -f "$f" ] && FILES+=("$f")
done

# Adoption guide
[ -f "$REPO_ROOT/docs/adoption.md" ] && FILES+=("$REPO_ROOT/docs/adoption.md")

# Templates
for f in "$REPO_ROOT"/templates/*.md; do
  [ -f "$f" ] && FILES+=("$f")
done

# Starters
for f in "$REPO_ROOT"/starters/*.md; do
  [ -f "$f" ] && FILES+=("$f")
done
