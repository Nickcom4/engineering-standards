#!/usr/bin/env bash
# lint-adr-lifecycle-refs.sh — verify ADR lifecycle document cross-references (REQ-4.2-08, REQ-4.2-09)
#
# For every ADR in docs/decisions/:
#   - If dfmea: field is populated (not ~ or absent), verify the named file exists
#     in docs/decisions/ and its adr: frontmatter field references this ADR's id.
#   - If pfmea: field is populated, same check.
#
# Exit 0 = pass. Exit 1 = violations found.

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
DECISIONS_DIR="$REPO_ROOT/docs/decisions"

FAILED=0

for adr_file in "$DECISIONS_DIR"/ADR-*.md; do
  [ -f "$adr_file" ] || continue
  relpath="${adr_file#$REPO_ROOT/}"

  # Extract frontmatter block (between first two --- delimiters)
  frontmatter=$(awk '/^---/{count++; if(count==2) exit} count==1' "$adr_file")

  # Get the ADR id from frontmatter
  adr_id=$(echo "$frontmatter" | grep '^id:' | sed 's/^id: *//' | tr -d '"')
  [ -z "$adr_id" ] && continue

  # Check dfmea field
  dfmea_val=$(echo "$frontmatter" | grep '^dfmea:' | sed 's/^dfmea: *//' | tr -d '"' | tr -d "'" || true)
  if [ -n "$dfmea_val" ] && [ "$dfmea_val" != "~" ] && [ "$dfmea_val" != "null" ]; then
    dfmea_path="$DECISIONS_DIR/$dfmea_val"
    if [ ! -f "$dfmea_path" ]; then
      echo "FAIL [$relpath]: dfmea: $dfmea_val does not exist in docs/decisions/"
      FAILED=1
    else
      # Verify the DFMEA's adr: field references this ADR
      dfmea_adr=$(grep '^adr:' "$dfmea_path" | head -1 | sed 's/^adr: *//' | tr -d '"' || true)
      if [ "$dfmea_adr" != "$adr_id" ]; then
        echo "FAIL [$relpath]: dfmea $dfmea_val has adr: '$dfmea_adr' but expected '$adr_id'"
        FAILED=1
      fi
    fi
  fi

  # Check pfmea field
  pfmea_val=$(echo "$frontmatter" | grep '^pfmea:' | sed 's/^pfmea: *//' | tr -d '"' | tr -d "'" || true)
  if [ -n "$pfmea_val" ] && [ "$pfmea_val" != "~" ] && [ "$pfmea_val" != "null" ]; then
    pfmea_path="$DECISIONS_DIR/$pfmea_val"
    if [ ! -f "$pfmea_path" ]; then
      echo "FAIL [$relpath]: pfmea: $pfmea_val does not exist in docs/decisions/"
      FAILED=1
    else
      pfmea_adr=$(grep '^adr:' "$pfmea_path" | head -1 | sed 's/^adr: *//' | tr -d '"' || true)
      if [ "$pfmea_adr" != "$adr_id" ]; then
        echo "FAIL [$relpath]: pfmea $pfmea_val has adr: '$pfmea_adr' but expected '$adr_id'"
        FAILED=1
      fi
    fi
  fi
done

if [ "$FAILED" -eq 1 ]; then
  echo ""
  echo "FAIL: ADR lifecycle document cross-references are broken (REQ-4.2-08, REQ-4.2-09)."
  exit 1
fi

adr_count=$(find "$DECISIONS_DIR" -name 'ADR-*.md' | wc -l | tr -d ' ')
echo "PASS: $adr_count ADRs checked; all dfmea/pfmea cross-references are consistent."
