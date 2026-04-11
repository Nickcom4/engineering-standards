#!/usr/bin/env bash
set -euo pipefail

ERRORS=0
FOUND=0

for adr in docs/decisions/ADR-*.md; do
  [ -f "$adr" ] || continue
  FOUND=$((FOUND + 1))
  if ! grep -qi "## Validation\|### Validation" "$adr"; then
    echo "WARN: $(basename $adr) missing Validation section"
    ERRORS=$((ERRORS + 1))
  fi
done

if [ "$FOUND" -eq 0 ]; then
  echo "PASS: No ADRs to check."
  exit 0
fi

if [ "$ERRORS" -gt 0 ]; then
  echo "WARN: $ERRORS ADRs missing Validation section (advisory)."
  exit 0
fi

echo "PASS: All $FOUND ADRs have Validation sections."
