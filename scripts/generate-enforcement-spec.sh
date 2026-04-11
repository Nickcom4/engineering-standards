#!/usr/bin/env bash
# generate-enforcement-spec.sh: T6: generate enforcement-spec.yml from kind:gate REQ-IDs
# (DFMEA FM-03, FM-06; ADR-2026-03-25-ese-machine-readable-first-format.md)
#
# Reads all non-deprecated kind:gate requirements from the ESE corpus and
# produces enforcement-spec.yml at the repo root.
#
# Modes:
#   generate   Write (or overwrite) enforcement-spec.yml
#   verify     Regenerate (excluding timestamp line) and diff against committed file
#
# Exit 0 = pass. Exit 1 = failure.

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
MODE="${1:-generate}"
OUTPUT="$REPO_ROOT/enforcement-spec.yml"
HELPER="$REPO_ROOT/scripts/_generate_enforcement_spec.py"

if [[ "$MODE" != "generate" && "$MODE" != "verify" ]]; then
  echo "Usage: $0 [generate|verify]" >&2
  exit 1
fi

source "$REPO_ROOT/scripts/ese-corpus-files.sh"

if [ "$MODE" = "generate" ]; then
  python3 "$HELPER" "$REPO_ROOT" "${FILES[@]}" > "$OUTPUT"
  gate_count=$(grep -c "^  - id:" "$OUTPUT" || true)
  echo "PASS: enforcement-spec.yml generated ($gate_count gates)."
  exit 0
fi

# verify mode: regenerate and compare, ignoring the timestamp line
TMPFILE=$(mktemp)
python3 "$HELPER" "$REPO_ROOT" "${FILES[@]}" > "$TMPFILE"

# Strip timestamp lines for comparison (generated: "..." and # Generated: ...)
strip_timestamps() {
  grep -v '^generated: \|^# Generated: ' "$1"
}

COMMITTED=$(mktemp)
FRESH=$(mktemp)
strip_timestamps "$OUTPUT" > "$COMMITTED"
strip_timestamps "$TMPFILE" > "$FRESH"

if diff -q "$COMMITTED" "$FRESH" > /dev/null 2>&1; then
  gate_count=$(grep -c "^  - id:" "$OUTPUT" || true)
  echo "PASS: enforcement-spec.yml is up to date ($gate_count gates)."
  rm "$TMPFILE" "$COMMITTED" "$FRESH"
  exit 0
else
  echo "FAIL: enforcement-spec.yml is stale. Run: bash scripts/generate-enforcement-spec.sh generate"
  diff "$COMMITTED" "$FRESH" | head -20
  rm "$TMPFILE" "$COMMITTED" "$FRESH"
  exit 1
fi
