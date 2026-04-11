#!/usr/bin/env bash
# generate-req-index.sh — generate docs/requirement-index.md from REQ-ID tags (B15)
# Organizes all active REQ-IDs by lifecycle scope, then by applies-when group.
# Fully generated; requires no manual maintenance.
#
# Modes:
#   generate   Write (or overwrite) docs/requirement-index.md
#   verify     Regenerate in memory and diff against committed file (CI gate)
#
# Exit 0 = pass. Exit 1 = failure.

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
MODE="${1:-generate}"
OUTPUT="$REPO_ROOT/docs/requirement-index.md"
HELPER="$REPO_ROOT/scripts/_generate_req_index.py"

if [[ "$MODE" != "generate" && "$MODE" != "verify" ]]; then
  echo "Usage: $0 [generate|verify]" >&2
  exit 1
fi

source "$REPO_ROOT/scripts/ese-corpus-files.sh"

if [ "$MODE" = "generate" ]; then
  python3 "$HELPER" "$REPO_ROOT" "${FILES[@]}" > "$OUTPUT"
  req_count=$(grep -c '^| `REQ-' "$OUTPUT" || true)
  lines=$(wc -l < "$OUTPUT" | tr -d ' ')
  echo "PASS: docs/requirement-index.md generated ($req_count active REQ-IDs, $lines lines)."
  exit 0
fi

# verify mode
TMPFILE=$(mktemp)
python3 "$HELPER" "$REPO_ROOT" "${FILES[@]}" > "$TMPFILE"
if diff -q "$OUTPUT" "$TMPFILE" > /dev/null 2>&1; then
  req_count=$(grep -c '^| `REQ-' "$OUTPUT" || true)
  echo "PASS: docs/requirement-index.md is up to date ($req_count active REQ-IDs)."
  rm "$TMPFILE"
  exit 0
else
  echo "FAIL: docs/requirement-index.md is stale. Run: bash scripts/generate-req-index.sh generate"
  diff "$OUTPUT" "$TMPFILE" | head -20
  rm "$TMPFILE"
  exit 1
fi
