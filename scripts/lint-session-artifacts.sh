#!/usr/bin/env bash
set -euo pipefail

# Validates work session logs against the required sections from
# templates/work-session-log.md (REQ-4.6-01). Accepts both the canonical
# template headings and common historical variants.
#
# Each check group uses OR logic: any matching pattern satisfies the check.

ERRORS=0
FOUND_FILES=0

for log in docs/work-sessions/*.md; do
  [ -f "$log" ] || continue
  FOUND_FILES=$((FOUND_FILES + 1))

  # Check 1: What was attempted / done
  # Template: "What Was Attempted"; historical: "What Was Done", "Review Summary",
  # "Compliance Review", "Changes Reviewed"
  if ! grep -qi "attempted\|what was attempted\|what was done\|review summary\|compliance review\|changes reviewed" "$log"; then
    echo "WARN: $(basename "$log") missing section matching 'attempted' or 'what was done'"
    ERRORS=$((ERRORS + 1))
  fi

  # Check 2: What succeeded
  # Template: "What Succeeded"; historical: "What Was Done" (combined section),
  # "a tracked work item system Closed", "Changes Reviewed", "Key metrics"
  if ! grep -qi "succeeded\|what succeeded\|what was done\|work items closed\|changes reviewed\|key metrics" "$log"; then
    echo "WARN: $(basename "$log") missing section matching 'succeeded' or equivalent"
    ERRORS=$((ERRORS + 1))
  fi

  # Check 3: What failed
  # Template: "What Failed"; historical: "Quality Issues Caught", "Gaps Found",
  # "New Gaps Found". When nothing failed, a "Nothing failed" line is acceptable.
  if ! grep -qi "failed\|what failed\|quality issues\|gaps found\|nothing failed\|no failures" "$log"; then
    echo "WARN: $(basename "$log") missing section matching 'failed' or equivalent"
    ERRORS=$((ERRORS + 1))
  fi

  # Check 4: Open items
  # Template: "Open Items"; historical: "What Is Still Open", "Left Open",
  # "Open Questions", "Next Session"
  if ! grep -qi "left open\|open items\|open questions\|still open\|next session\|actions" "$log"; then
    echo "WARN: $(basename "$log") missing section matching 'open items' or equivalent"
    ERRORS=$((ERRORS + 1))
  fi

  # Check 5: Decisions
  # Template: "Decisions Made"; historical: "Decisions"
  if ! grep -qi "decisions" "$log"; then
    echo "WARN: $(basename "$log") missing section matching 'decisions'"
    ERRORS=$((ERRORS + 1))
  fi
done

if [ "$FOUND_FILES" -eq 0 ]; then
  echo "PASS: No work session logs to check."
  exit 0
fi

if [ "$ERRORS" -gt 0 ]; then
  echo "WARN: $ERRORS missing work session log sections (advisory)."
  exit 0
fi

echo "PASS: All work session logs have required sections."
