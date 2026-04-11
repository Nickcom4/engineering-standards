#!/usr/bin/env bash
# Orphan ADR detector (advisory)
#
# Detects ADRs in docs/decisions/ with status Accepted or Proposed
# that are not referenced from any living document in the repo. An
# orphan ADR is a decision record that nothing points at: the decision
# still stands, but no living document acknowledges it.
#
# This is advisory (exit 0 on warnings), not a hard gate. An orphan
# ADR may be terminal by design (an internal record that consumers
# never need to cite). To acknowledge an intentional orphan, add the
# frontmatter line:
#
#   cross-reference-free: intentional
#
# Search corpus for references:
#   STANDARDS.md, CLAUDE.md, README.md, CHANGELOG.md,
#   docs/standards-application.md, docs/addenda/*.md,
#   docs/architecture/*.md, and other ADRs in docs/decisions/
#
# An ADR is considered referenced if its filename (without the .md
# extension) appears anywhere in the search corpus.
#
# DFMEA-*.md and PFMEA-*.md files are NOT ADRs and are excluded.
#
# Exit 0 always (advisory). Prints a warning summary when orphans exist.

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"

if [ ! -d "$REPO_ROOT/docs/decisions" ]; then
  echo "SKIP: docs/decisions/ not found."
  exit 0
fi

# Build the search corpus (files to grep for ADR references)
SEARCH_CORPUS=()
for candidate in \
  "$REPO_ROOT/STANDARDS.md" \
  "$REPO_ROOT/CLAUDE.md" \
  "$REPO_ROOT/README.md" \
  "$REPO_ROOT/CHANGELOG.md" \
  "$REPO_ROOT/docs/standards-application.md" \
  "$REPO_ROOT/docs/adoption.md" \
  "$REPO_ROOT/docs/background.md"; do
  [ -f "$candidate" ] && SEARCH_CORPUS+=("$candidate")
done
for f in "$REPO_ROOT"/docs/addenda/*.md; do
  [ -f "$f" ] && SEARCH_CORPUS+=("$f")
done
for f in "$REPO_ROOT"/docs/architecture/*.md; do
  [ -f "$f" ] && SEARCH_CORPUS+=("$f")
done
for f in "$REPO_ROOT"/templates/*.md; do
  [ -f "$f" ] && SEARCH_CORPUS+=("$f")
done
for f in "$REPO_ROOT"/starters/*.md; do
  [ -f "$f" ] && SEARCH_CORPUS+=("$f")
done

CHECKED=0
ORPHANS=()
EXEMPTED=0

for adr in "$REPO_ROOT"/docs/decisions/ADR-*.md; do
  [ -f "$adr" ] || continue

  # Status check: only Accepted or Proposed ADRs are candidates
  if ! grep -qE '^status: (Accepted|Proposed)' "$adr"; then
    continue
  fi

  CHECKED=$((CHECKED + 1))
  name=$(basename "$adr" .md)

  # Opt-out via frontmatter
  if grep -q '^cross-reference-free: intentional' "$adr"; then
    EXEMPTED=$((EXEMPTED + 1))
    continue
  fi

  # Build the list of search patterns for this ADR. A reference is counted
  # if ANY of these appears in a living document:
  #
  #   1. Full basename: ADR-010-archived-document-handling
  #   2. Frontmatter id: ADR-010 (short form)
  #   3. Short prefix extracted from filename: ADR-010 or ADR-2026-04-09
  #
  # The short forms matter because most living-document references use
  # them, not the full hyphenated title.
  PATTERNS=()
  PATTERNS+=("$name")

  # Extract id from frontmatter (if present)
  frontmatter_id=$(awk -F': ' '/^id: / {gsub(/^ +| +$/,"",$2); print $2; exit}' "$adr")
  if [ -n "$frontmatter_id" ] && [ "$frontmatter_id" != "$name" ]; then
    PATTERNS+=("$frontmatter_id")
  fi

  # Short prefix: ADR-NNN (sequential) or ADR-YYYY-MM-DD (date-based)
  if [[ "$name" =~ ^(ADR-[0-9]{3}) ]]; then
    short="${BASH_REMATCH[1]}"
    [ "$short" != "$name" ] && PATTERNS+=("$short")
  elif [[ "$name" =~ ^(ADR-[0-9]{4}-[0-9]{2}-[0-9]{2}) ]]; then
    short="${BASH_REMATCH[1]}"
    [ "$short" != "$name" ] && PATTERNS+=("$short")
  fi

  # Look for references in the search corpus
  ref_found=0
  for searchfile in "${SEARCH_CORPUS[@]}"; do
    for pat in "${PATTERNS[@]}"; do
      if grep -q -F "$pat" "$searchfile"; then
        ref_found=1
        break 2
      fi
    done
  done

  # Also search other ADRs in docs/decisions/ (cross-ADR references)
  if [ "$ref_found" -eq 0 ]; then
    for other in "$REPO_ROOT"/docs/decisions/*.md; do
      [ "$other" = "$adr" ] && continue
      for pat in "${PATTERNS[@]}"; do
        if grep -q -F "$pat" "$other"; then
          ref_found=1
          break 2
        fi
      done
    done
  fi

  if [ "$ref_found" -eq 0 ]; then
    ORPHANS+=("$name")
  fi
done

if [ ${#ORPHANS[@]} -gt 0 ]; then
  echo "WARN: $CHECKED Accepted/Proposed ADRs checked; ${#ORPHANS[@]} with no cross-references from any living document (advisory):"
  for o in "${ORPHANS[@]}"; do
    echo "  $o"
  done
  echo ""
  echo "An orphan ADR may be terminal by design (an internal record that"
  echo "consumers never need to cite). To acknowledge an intentional orphan,"
  echo "add this line to the ADR's frontmatter:"
  echo ""
  echo "  cross-reference-free: intentional"
  echo ""
  echo "Otherwise, add a reference from a living document (CHANGELOG entry,"
  echo "STANDARDS.md section, standards-application.md, or another ADR)."
  exit 0  # Advisory
fi

if [ "$EXEMPTED" -gt 0 ]; then
  echo "PASS: $CHECKED ADRs checked; all referenced at least once ($EXEMPTED exempted via cross-reference-free: intentional)."
else
  echo "PASS: $CHECKED ADRs checked; all referenced at least once from a living document."
fi
