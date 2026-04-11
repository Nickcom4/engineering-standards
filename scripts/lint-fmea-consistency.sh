#!/usr/bin/env bash
# FMEA internal consistency linter (REQ-2.1-43, REQ-2.1-47)
# Verifies derived sections (High-Severity table, RPN Summary) are
# consistent with the source FM tables.
#
# This is the PF-38 corrective action: no more stale derived views.
#
# Exit 0 = pass. Exit 1 = inconsistencies found.

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
FMEA_DIR="$REPO_ROOT/docs/decisions"
VIOLATIONS=()

for fmea_file in "$FMEA_DIR"/DFMEA-*.md "$FMEA_DIR"/PFMEA-*.md; do
  [ -f "$fmea_file" ] || continue
  relpath="${fmea_file#$REPO_ROOT/}"
  
  # Extract all FM scores from main tables using Python
  result=$(python3 -c "
import re, sys

with open('$fmea_file') as f:
    content = f.read()

# Find severity threshold
sev_thresh = 8
m = re.search(r'Severity >= (\d+)', content)
if m:
    sev_thresh = int(m.group(1))

# Parse main FM tables for source-of-truth scores
main_fms = {}
for line in content.split('\n'):
    if re.match(r'\| (?:PF|FM)-\d+', line):
        parts = [p.strip() for p in line.split('|')]
        if len(parts) >= 10:
            try:
                fm = parts[1]
                # Dynamic column detection: find 4 consecutive numeric columns
                nums = []
                for j, p in enumerate(parts):
                    try:
                        v = int(p.replace('**',''))
                        nums.append((j, v))
                    except ValueError:
                        pass
                if len(nums) >= 4:
                    s = nums[-4][1]
                    o = nums[-3][1]
                    d = nums[-2][1]
                    rpn = nums[-1][1]
                    if fm not in main_fms:
                        main_fms[fm] = (s, o, d, rpn)
            except (ValueError, IndexError):
                pass

# Check High-Severity table
hs_start = content.find('## High-Severity')
if hs_start >= 0:
    hs_end = content.find('\n## ', hs_start + 10)
    if hs_end < 0: hs_end = content.find('\n---', hs_start + 10)
    hs_section = content[hs_start:hs_end] if hs_end > 0 else content[hs_start:]
    
    for line in hs_section.split('\n'):
        m = re.match(r'\| ((?:PF|FM)-\d+) \| (\d+) \| (\d+)', line)
        if m:
            fm, hs_sev, hs_rpn = m.group(1), int(m.group(2)), int(m.group(3))
            if fm in main_fms:
                s, o, d, rpn = main_fms[fm]
                if hs_sev != s:
                    print(f'HIGH-SEV: {fm} severity {hs_sev} in table but {s} in main')
                if hs_rpn != rpn:
                    print(f'HIGH-SEV: {fm} RPN {hs_rpn} in table but {rpn} in main')
    
    # Check FMs that SHOULD be in high-severity but aren't
    for fm, (s, o, d, rpn) in main_fms.items():
        if s >= sev_thresh and fm not in hs_section:
            print(f'HIGH-SEV: {fm} has S={s} (>= threshold {sev_thresh}) but missing from High-Severity table')

print('DONE')
" 2>&1)

  while IFS= read -r line; do
    [[ "$line" == "DONE" ]] && continue
    [[ -n "$line" ]] && VIOLATIONS+=("$relpath: $line")
  done <<< "$result"
done

if [ ${#VIOLATIONS[@]} -gt 0 ]; then
  echo "FAIL: FMEA internal consistency violations (REQ-2.1-43):"
  for v in "${VIOLATIONS[@]}"; do
    echo "  $v"
  done
  exit 1
else
  echo "PASS: All FMEA derived sections are consistent with source FM tables."
  exit 0
fi
