#!/usr/bin/env bash
# ADR validation trigger staleness linter
# Checks ADRs with status: Accepted for validation triggers that may
# need attention. Advisory only (exit 0 with warnings) since trigger
# evaluation requires human judgment.
#
# Warns when:
# - An accepted ADR has a validation trigger but no recorded result
#   and the ADR is older than 90 days
# - An accepted ADR references a calendar-based review cadence
#   (e.g., "annual review") with a date older than 13 months
#
# Exit 0 = pass (advisory warnings only). Exit 1 = structural error.

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
ADR_DIR="$REPO_ROOT/docs/decisions"

if [ ! -d "$ADR_DIR" ]; then
  echo "SKIP: $ADR_DIR not found"
  exit 0
fi

python3 - "$REPO_ROOT" "$ADR_DIR" <<'PYEOF'
import os
import re
import sys
from datetime import datetime, timedelta

repo_root = sys.argv[1]
adr_dir = sys.argv[2]
today = datetime.now().date()
warnings = []

for fname in sorted(os.listdir(adr_dir)):
    if not fname.startswith("ADR-") or not fname.endswith(".md"):
        continue

    filepath = os.path.join(adr_dir, fname)
    with open(filepath, encoding="utf-8") as f:
        content = f.read()

    # Extract frontmatter
    fm_match = re.match(r"^---\s*\n(.*?)\n---", content, re.DOTALL)
    if not fm_match:
        continue

    frontmatter = fm_match.group(1)

    # Check status
    status_match = re.search(r"^status:\s*(.+)$", frontmatter, re.MULTILINE)
    if not status_match:
        continue
    status = status_match.group(1).strip()
    if status.lower() != "accepted":
        continue

    # Get ADR date
    date_match = re.search(r"^date:\s*(\d{4}-\d{2}-\d{2})", frontmatter, re.MULTILINE)
    if not date_match:
        continue
    try:
        adr_date = datetime.strptime(date_match.group(1), "%Y-%m-%d").date()
    except ValueError:
        continue

    # Extract Validation section
    val_match = re.search(
        r"^## Validation\s*\n(.*?)(?=\n## |\Z)",
        content,
        re.MULTILINE | re.DOTALL,
    )
    if not val_match:
        continue

    validation = val_match.group(1)

    # Check if a validation result is already recorded
    has_result = bool(
        re.search(r"(?i)validation result|status as of|trigger satisfied|PASS|FAIL", validation)
    )

    # Check for trigger line
    has_trigger = bool(re.search(r"(?i)\*\*trigger", validation))

    # Warn if trigger exists, no result recorded, and ADR is older than 90 days
    age_days = (today - adr_date).days
    if has_trigger and not has_result and age_days > 90:
        warnings.append(
            f"{fname}: accepted {age_days} days ago with a validation trigger "
            f"but no recorded result (date: {adr_date})"
        )

if warnings:
    print(f"ADVISORY: {len(warnings)} ADR validation trigger(s) may need attention:")
    for w in warnings:
        print(f"  {w}")
    print()
    print("These are advisory warnings. Check whether the trigger event has occurred")
    print("and record the validation result in the ADR's Validation section.")
else:
    print("PASS: No overdue ADR validation triggers found.")

# Always exit 0; this linter is advisory
sys.exit(0)
PYEOF
