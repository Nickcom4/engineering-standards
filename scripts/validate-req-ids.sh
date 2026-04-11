#!/usr/bin/env bash
# T1: Unique REQ-ID validator (FM-01 corrective action)
# Scans STANDARDS.md and all addenda for duplicate <a name="REQ-..."> anchors.
# Ignores anchors inside fenced code blocks (``` ... ```).
# Exit 0 = pass, Exit 1 = duplicates found.
#
# Usage: ./scripts/validate-req-ids.sh
# Runs as: pre-commit hook, CI gate (hard-block)

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
# Single source of truth for corpus file list
source "$REPO_ROOT/scripts/ese-corpus-files.sh"

ALL_IDS=()
VIOLATIONS=()

for file in "${FILES[@]}"; do
  in_fence=0
  while IFS= read -r line; do
    # Track fenced code blocks
    if [[ "$line" =~ ^\`\`\` ]]; then
      in_fence=$((1 - in_fence))
      continue
    fi
    [ "$in_fence" -eq 1 ] && continue

    # Extract REQ-ID from anchor
    if [[ "$line" =~ \<a\ name=\"(REQ-[^\"]+)\"\> ]]; then
      id="${BASH_REMATCH[1]}"
      ALL_IDS+=("$id|$file")
    fi
  done < "$file"
done

# Check for duplicates using sort + uniq
DUPES=$(printf '%s\n' "${ALL_IDS[@]}" | cut -d'|' -f1 | sort | uniq -d)
if [ -n "$DUPES" ]; then
  while IFS= read -r dup_id; do
    locations=""
    for entry in "${ALL_IDS[@]}"; do
      id="${entry%%|*}"
      file="${entry##*|}"
      if [ "$id" = "$dup_id" ]; then
        locations="$locations $(basename "$file")"
      fi
    done
    VIOLATIONS+=("DUPLICATE: $dup_id found in:$locations")
  done <<< "$DUPES"
fi

if [ ${#VIOLATIONS[@]} -gt 0 ]; then
  echo "FAIL: REQ-ID uniqueness check (ESE §4.9.5, FM-01):"
  for v in "${VIOLATIONS[@]}"; do
    echo "  $v"
  done
  echo ""
  echo "Total REQ-IDs scanned: ${#ALL_IDS[@]}"
  echo "Duplicates found: ${#VIOLATIONS[@]}"
  exit 1
else
  echo "PASS: ${#ALL_IDS[@]} REQ-IDs scanned, all unique."
  exit 0
fi
