#!/usr/bin/env bash
# Detect broken markdown tables: table rows separated by blank lines.
# A blank line between two pipe-rows breaks the table in most renderers.
#
# Exit 0 = pass. Exit 1 = violations found.

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"

source "$REPO_ROOT/scripts/ese-corpus-files.sh"
for f in "$REPO_ROOT"/docs/decisions/*.md; do [ -f "$f" ] && FILES+=("$f"); done

VIOLATIONS=()

for file in "${FILES[@]}"; do
  relpath="${file#$REPO_ROOT/}"
  in_fence=0
  prev_line=""
  prev_prev_line=""
  lineno=0

  while IFS= read -r line; do
    lineno=$((lineno + 1))

    # Track code fences
    if [[ "$line" =~ ^\`\`\` ]]; then
      in_fence=$((1 - in_fence))
    fi
    if [ "$in_fence" -eq 1 ]; then
      prev_prev_line="$prev_line"
      prev_line="$line"
      continue
    fi

    # Pattern: prev_prev is a table row, prev is blank, current is a table row
    stripped="${line#"${line%%[! ]*}"}"
    prev_stripped="${prev_line#"${prev_line%%[! ]*}"}"
    pp_stripped="${prev_prev_line#"${prev_prev_line%%[! ]*}"}"

    if [[ "$pp_stripped" == \|* ]] && [[ -z "$prev_stripped" ]] && [[ "$stripped" == \|* ]]; then
      # Skip if current line is a table header (new table is fine after blank line + header)
      # A new table starts with header + separator. If the NEXT line is |---|, it's a new table.
      # But we can't look ahead. So flag it and let the human decide.
      # Actually: if prev_prev was a data row (not separator) and current is a data row (not separator), it's broken.
      if [[ ! "$pp_stripped" =~ ^\|[-[:space:]|]+\|$ ]] && [[ ! "$stripped" =~ ^\|[-[:space:]|]+\|$ ]]; then
        VIOLATIONS+=("$relpath:$lineno: table row after blank line (broken table) — merge with table above or add header+separator for new table")
      fi
    fi

    prev_prev_line="$prev_line"
    prev_line="$line"
  done < "$file"
done

if [ ${#VIOLATIONS[@]} -gt 0 ]; then
  echo "FAIL: Broken table formatting (rows separated by blank lines):"
  for v in "${VIOLATIONS[@]}"; do
    echo "  $v"
  done
  exit 1
else
  echo "PASS: No broken tables found."
  exit 0
fi
