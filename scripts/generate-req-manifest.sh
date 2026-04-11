#!/usr/bin/env bash
# T7: REQ-ID integrity manifest generator
# Extracts each REQ-ID block (anchor + tag line + statement line) from
# all corpus files (STANDARDS.md, addenda, adoption.md, templates, starters),
# computes a SHA-256 hash per block, and
# writes req-manifest.sha256 at the repo root with one line per REQ-ID:
#   REQ-ID|sha256hex|relative-file-path
#
# Ignores blocks inside fenced code blocks.
#
# Modes:
#   generate   Write (or overwrite) req-manifest.sha256
#   verify     Regenerate in memory and diff against committed manifest (CI / pre-commit gate)
#
# Usage:
#   ./scripts/generate-req-manifest.sh generate
#   ./scripts/generate-req-manifest.sh verify
#
# Exit 0 = pass. Exit 1 = failure (verify diff or generate error).

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
MANIFEST_FILE="$REPO_ROOT/req-manifest.sha256"
HELPER="$REPO_ROOT/scripts/_req_manifest_helper.py"

MODE="${1:-generate}"
if [[ "$MODE" != "generate" && "$MODE" != "verify" ]]; then
  echo "Usage: $0 [generate|verify]" >&2
  exit 1
fi

# Single source of truth for corpus file list
source "$REPO_ROOT/scripts/ese-corpus-files.sh"
# Generate manifest lines via Python helper (avoids heredoc/backtick shell-parsing issues)
MANIFEST=$(python3 "$HELPER" "$REPO_ROOT" "${FILES[@]}")
TOTAL=$(echo "$MANIFEST" | grep -c '|' 2>/dev/null || echo 0)

if [[ "$MODE" == "generate" ]]; then
  echo "$MANIFEST" > "$MANIFEST_FILE"
  echo "PASS: req-manifest.sha256 written with $TOTAL REQ-ID blocks."
  exit 0
fi

# verify mode: regenerate in memory, diff against committed manifest
if [ ! -f "$MANIFEST_FILE" ]; then
  echo "FAIL: req-manifest.sha256 not found. Run './scripts/generate-req-manifest.sh generate' to create it." >&2
  exit 1
fi

COMMITTED=$(cat "$MANIFEST_FILE")
if [ "$MANIFEST" = "$COMMITTED" ]; then
  echo "PASS: req-manifest.sha256 is up to date ($TOTAL REQ-ID blocks)."
  exit 0
else
  echo "FAIL: req-manifest.sha256 diverges from STANDARDS.md / addenda." >&2
  echo "" >&2
  echo "Changed or added blocks (< committed, > current):" >&2
  diff <(echo "$COMMITTED") <(echo "$MANIFEST") | grep '^[<>]' | head -20 >&2
  echo "" >&2
  echo "Run './scripts/generate-req-manifest.sh generate' and commit the updated manifest." >&2
  exit 1
fi
