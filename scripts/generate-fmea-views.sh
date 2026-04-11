#!/usr/bin/env bash
# Generate FMEA derived views (High-Severity table, RPN Summary) from source FM tables.
# Replaces manual maintenance with auto-generation, same pattern as T7 manifest.
#
# Usage: ./scripts/generate-fmea-views.sh <fmea-file>
# Rewrites the High-Severity and RPN Summary sections in-place.

set -euo pipefail

FMEA_FILE="$1"

if [ ! -f "$FMEA_FILE" ]; then
  echo "Usage: $0 <path-to-fmea.md>" >&2
  exit 1
fi

python3 - "$FMEA_FILE" << 'PYEOF'
import re, sys

fmea_path = sys.argv[1]
with open(fmea_path) as f:
    content = f.read()

# Extract severity threshold
sev_thresh = 7
m = re.search(r'Severity >= (\d+)', content)
if m:
    sev_thresh = int(m.group(1))

# Extract RPN threshold
rpn_thresh = 75
m = re.search(r'RPN >= (\d+)', content)
if m:
    rpn_thresh = int(m.group(1))

# Parse all FM rows from main tables (source of truth)
main_fms = {}
for line in content.split('\n'):
    m = re.match(r'\| ((?:PF|FM)-\d+) \|', line)
    if m:
        parts = [p.strip() for p in line.split('|')]
        if len(parts) >= 11:
            try:
                fm = parts[1]
                # Find S,O,D,RPN columns dynamically (4 consecutive numeric columns)
                nums = []
                for j, p in enumerate(parts):
                    try:
                        v = int(p.replace('**',''))
                        nums.append((j, v))
                    except ValueError:
                        pass
                # S,O,D,RPN are the last 4 consecutive numerics
                if len(nums) >= 4:
                    s = nums[-4][1]
                    o = nums[-3][1]
                    d = nums[-2][1]
                    rpn = nums[-1][1]
                    # Action is the column after RPN
                    action_idx = nums[-1][0] + 1
                    action = parts[action_idx] if action_idx < len(parts) else ''
                    # Status is the last non-empty column
                    status_col = ''
                    for k in range(len(parts)-1, action_idx, -1):
                        if parts[k].strip() in ('stable','open','review','accepted'):
                            status_col = parts[k].strip()
                            break
                    if not status_col:
                        status_col = 'stable' if 'Controlled' in action else 'open'
                    if fm not in main_fms:
                        main_fms[fm] = (s, o, d, rpn, action, status_col)
            except (ValueError, IndexError):
                pass

# Generate High-Severity table
hs_lines = [f"## High-Severity Failure Modes (Severity >= {sev_thresh})\n"]
hs_lines.append(f"\n> Per REQ-2.1-17: Severity >= {sev_thresh} requires review regardless of RPN.\n")
hs_lines.append(f"\n| FM# | Severity | RPN | Action | Status |")
hs_lines.append(f"\n|---|---|---|---|---|")
for fm in sorted(main_fms.keys(), key=lambda x: int(re.search(r'\d+', x).group())):
    s, o, d, rpn, action, status_col = main_fms[fm]
    if s >= sev_thresh:
        # Extract control REQ-ID or status
        # Action: extract REQ-ID references from the action text
        import re as _re
        req_refs = _re.findall(r'REQ-[0-9][0-9A-Z.]*-[0-9]+', action)
        script_refs = _re.findall(r'lint-[\w-]+\.sh', action)
        refs = req_refs + script_refs
        ctrl = ', '.join(refs) if refs else action[:50]
        # Status: extract from main table if available, else derive
        hs_lines.append(f"\n| {fm} | {s} | {rpn} | {ctrl} | {status_col} |")

# Generate RPN Summary
above = [(fm, rpn, action) for fm, (s, o, d, rpn, action, status_col) in main_fms.items() if rpn >= rpn_thresh]
rps_lines = [f"\n\n## RPN Summary\n"]
rps_lines.append(f"\n**Threshold:** RPN >= {rpn_thresh} requires action. Severity >= {sev_thresh} requires review regardless of RPN.\n")
if above:
    rps_lines.append(f"\n| FM# | RPN | Status |")
    rps_lines.append(f"\n|---|---|---|")
    for fm, rpn, action in sorted(above, key=lambda x: -x[1]):
        ctrl = "Controlled" if "Controlled" in action else action[:40]
        rps_lines.append(f"\n| {fm} | {rpn} | {ctrl} |")
    rps_lines.append(f"\n\n{len(above)} failure modes above threshold.")
else:
    rps_lines.append(f"\nAll failure modes below RPN threshold. Highest: {max(rpn for _, (_, _, _, rpn, _, _) in main_fms.items())}.")

# Replace High-Severity section
hs_start = content.find('## High-Severity')
if hs_start >= 0:
    hs_end = content.find('\n## ', hs_start + 10)
    if hs_end < 0: hs_end = content.find('\n---', hs_start + 10)
    content = content[:hs_start] + ''.join(hs_lines) + '\n' + content[hs_end:]

# Replace RPN Summary section
rps_start = content.find('## RPN Summary')
if rps_start >= 0:
    rps_end = content.find('\n## ', rps_start + 10)
    if rps_end < 0: rps_end = content.find('\n---', rps_start + 10)
    if rps_end < 0: rps_end = content.find('\n*Status:', rps_start + 10)
    content = content[:rps_start] + ''.join(rps_lines) + '\n' + content[rps_end:]

with open(fmea_path, 'w') as f:
    f.write(content)

print(f"Generated: {len([fm for fm, (s,_,_,_,_,_) in main_fms.items() if s >= sev_thresh])} high-severity, {len(above)} above RPN threshold")
PYEOF
