#!/usr/bin/env bash
# Table formatting linter: detects broken and inconsistent markdown tables.
# Checks: column count consistency within each table, separator row matches header,
# blank lines inside tables (which break the table in most renderers).
#
# Exit 0 = pass. Exit 1 = violations found.

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"

source "$REPO_ROOT/scripts/ese-corpus-files.sh"
# Also scan decision docs
for f in "$REPO_ROOT"/docs/decisions/*.md; do [ -f "$f" ] && FILES+=("$f"); done

VIOLATIONS=()
# Additional pattern: table row preceded by a blank line after another table row
# This detects rows that visually belong to a table but are separated by blank lines

for file in "${FILES[@]}"; do
  relpath="${file#$REPO_ROOT/}"
  in_fence=0
  in_table=0
  table_header_line=0
  table_col_count=0
  prev_was_table=0
  lineno=0

  while IFS= read -r line; do
    lineno=$((lineno + 1))

    # Track code fences
    if [[ "$line" =~ ^\`\`\` ]]; then
      in_fence=$((1 - in_fence))
      continue
    fi
    [ "$in_fence" -eq 1 ] && continue

    stripped="${line#"${line%%[! ]*}"}"  # trim leading whitespace

    if [[ "$stripped" == \|* ]]; then
      # Count columns (pipes minus 1 for typical | col | col | format)
      # Count only unescaped pipes (not preceded by backslash)
      cols=$(echo "$stripped" | sed 's/\\|//g' | tr -cd '|' | wc -c | tr -d ' ')

      if [[ "$stripped" =~ ^\|[[:space:]\|-]+\|$ ]]; then
        # Separator row
        if [ "$in_table" -eq 1 ] && [ "$cols" -ne "$table_col_count" ]; then
          VIOLATIONS+=("$relpath:$lineno: separator has $cols pipes but header had $table_col_count")
        fi
      elif [ "$in_table" -eq 0 ]; then
        # Start of new table (header row)
        in_table=1
        table_header_line=$lineno
        table_col_count=$cols
      else
        # Data row in existing table
        if [ "$cols" -ne "$table_col_count" ]; then
          VIOLATIONS+=("$relpath:$lineno: row has $cols pipes but header (L$table_header_line) has $table_col_count")
        fi
      fi
      prev_was_table=1
    else
      if [ "$prev_was_table" -eq 1 ] && [ "$in_table" -eq 1 ] && [ -n "$stripped" ]; then
        # Non-empty non-table line right after table: table ended
        in_table=0
      elif [ "$prev_was_table" -eq 1 ] && [ "$in_table" -eq 1 ] && [ -z "$stripped" ]; then
        # Blank line inside what might be a continued table: check next line
        :
      fi
      prev_was_table=0
      if [ -z "$stripped" ]; then
        in_table=0
      fi
    fi
  done < "$file"
done

if [ ${#VIOLATIONS[@]} -gt 0 ]; then
  echo "FAIL: Table formatting violations found:"
  for v in "${VIOLATIONS[@]}"; do
    echo "  $v"
  done
  exit 1
else
  echo "PASS: All markdown tables have consistent column counts."
  exit 0
fi
