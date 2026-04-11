#!/usr/bin/env bash
# PF-37 corrective action: detect stale REQ-ID count references in documentation.
# Compares any number matching "N REQ-IDs" or "N REQ-ID blocks" or "N total"
# in docs against the actual count from req-manifest.sha256.
#
# Exit 0 = pass. Exit 1 = stale references found.
#
# Runs as: CI gate, pre-commit (after T7 auto-regenerate)

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"

# Single source of truth: manifest line count
ACTUAL_COUNT=$(wc -l < "$REPO_ROOT/req-manifest.sha256" | tr -d ' ')

# Scan all documentation for count references
# Patterns: "NNN REQ-IDs", "NNN REQ-ID blocks", "NNN total REQ-IDs", "NNN unique"
# Skip lines in code blocks
VIOLATIONS=()

source "$REPO_ROOT/scripts/ese-corpus-files.sh"
# Also scan decision docs, architecture docs, and root-level living docs
for f in "$REPO_ROOT"/docs/decisions/*.md; do [ -f "$f" ] && FILES+=("$f"); done
# docs/work-sessions/ excluded: historical session records, not living documents
for f in "$REPO_ROOT"/docs/architecture/*.md; do [ -f "$f" ] && FILES+=("$f"); done
# docs/research/ excluded: point-in-time analysis snapshots, not living documents
# Root-level living documents that describe the current state of the standard
for f in "$REPO_ROOT/CLAUDE.md" "$REPO_ROOT/README.md" "$REPO_ROOT/dependencies.md"; do
  [ -f "$f" ] && FILES+=("$f")
done
# Living docs under docs/ that describe current state (exclude historical review snapshots and generated files)
for f in "$REPO_ROOT/docs/standards-application.md" "$REPO_ROOT/docs/background.md" "$REPO_ROOT/docs/setup.md" "$REPO_ROOT/docs/deployment.md"; do
  [ -f "$f" ] && FILES+=("$f")
done
# docs/requirement-index.md excluded: generated file, its count reference is authoritative by construction
# docs/compliance-review-*.md excluded: point-in-time review snapshots, not living
# docs/work-items/ excluded: exported work item records are historical snapshots
# CHANGELOG.md excluded: versioned history entries reference counts at time of release

for file in "${FILES[@]}"; do
  relpath="${file#$REPO_ROOT/}"
  in_fence=0
  lineno=0
  while IFS= read -r line; do
    lineno=$((lineno + 1))
    # Track code fences
    if [[ "$line" =~ ^\`\`\` ]]; then
      in_fence=$((1 - in_fence))
      continue
    fi
    [ "$in_fence" -eq 1 ] && continue

    # Skip YAML frontmatter
    # Skip lines that are explaining historical progression (contain "was" or "from")
    # Only flag lines asserting a CURRENT count

    # Match patterns: "NNN REQ-IDs", "NNN REQ-ID blocks", "NNN total", "NNN unique",
    # "NNN requirement(s)", "NNN machine-readable requirement(s)"
    if [[ "$line" =~ ([0-9]+)\ REQ-ID ]] || [[ "$line" =~ ([0-9]+)\ total ]] || [[ "$line" =~ ([0-9]+)\ unique ]] || [[ "$line" =~ ([0-9]+)\ (machine-readable\ )?requirement ]]; then
      num="${BASH_REMATCH[1]}"
      # Only flag 3-digit numbers that look like REQ-ID counts (400-999 range)
      if [ "$num" -ge 400 ] && [ "$num" -le 999 ] && [ "$num" != "$ACTUAL_COUNT" ]; then
        # Skip lines that are clearly historical (contain "was", "from", "at iteration", "grew from")
        if [[ "$line" =~ was\ |from\ |at\ iteration|grew\ from|Count\ [0-9] ]]; then
          continue
        fi
        VIOLATIONS+=("$relpath:$lineno: references $num but actual count is $ACTUAL_COUNT")
      fi
    fi
  done < "$file"
done

if [ ${#VIOLATIONS[@]} -gt 0 ]; then
  echo "FAIL: Stale REQ-ID count references (PFMEA PF-37):"
  for v in "${VIOLATIONS[@]}"; do
    echo "  $v"
  done
  echo ""
  echo "Actual REQ-ID count (from req-manifest.sha256): $ACTUAL_COUNT"
  echo "Fix: update the stale references to $ACTUAL_COUNT, or use relative language instead of hardcoded counts."
  exit 1
else
  echo "PASS: All REQ-ID count references match actual count ($ACTUAL_COUNT)."
  exit 0
fi
