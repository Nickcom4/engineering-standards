#!/usr/bin/env bash
# T5: Section heading anchor linter (DFMEA FM-04)
# Verifies that every heading anchor in docs/section-anchors-baseline.txt
# is still present in the current corpus (STANDARDS.md and all addenda).
#
# A heading anchor is the GitHub-style slug derived from a markdown heading:
# lowercase, spaces replaced by hyphens, non-alphanumeric characters dropped.
#
# Failure = an adopter referencing a heading URL fragment (e.g. #21-the-lifecycle)
# will get a broken link after a heading rename or removal.
#
# Install: called from scripts/pre-commit and ci.yml Check 16.

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
BASELINE="$REPO_ROOT/docs/section-anchors-baseline.txt"

if [ ! -f "$BASELINE" ]; then
  echo "FAIL: docs/section-anchors-baseline.txt not found."
  echo "  Fix: run scripts/generate-section-anchors-baseline.sh to create it."
  exit 1
fi

# Extract current heading slugs from corpus (run from REPO_ROOT for relative paths)
CURRENT=$(cd "$REPO_ROOT" && python3 scripts/_extract_heading_anchors.py \
  STANDARDS.md \
  docs/addenda/*.md \
  2>/dev/null)

FAILED=0
while IFS= read -r anchor; do
  [ -z "$anchor" ] && continue
  [[ "$anchor" == \#* ]] && continue  # skip comment lines
  if ! echo "$CURRENT" | grep -qxF "$anchor"; then
    echo "FAIL: baseline anchor missing from corpus: $anchor"
    FAILED=1
  fi
done < "$BASELINE"

if [ "$FAILED" -eq 1 ]; then
  echo ""
  echo "FAIL: Section heading anchors were removed or renamed (DFMEA FM-04)."
  echo "  If the heading was intentionally renamed: update docs/section-anchors-baseline.txt"
  echo "  and document the breaking change in CHANGELOG.md with a migration note."
  exit 1
fi

BASELINE_COUNT=$(grep -c '^[^#]' "$BASELINE" || true)
echo "PASS: all $BASELINE_COUNT baseline heading anchors present in corpus."
