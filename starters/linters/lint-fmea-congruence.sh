#!/usr/bin/env bash
# FMEA congruence linter (adopter starter)
#
# Catches FMEAs whose declared state overstates the actual state:
#
#   1. Status says "Complete" or "Closed" but an FM has current RPN or
#      Severity above threshold without a named control.
#   2. Frontmatter status declares "iteration N" (or narrative references
#      iteration N) but the RPN Tracking Table has fewer than N Iter
#      columns.
#   3. The bolded current RPN in the main FM table does not match the
#      latest non-dash value in that FM's row of the RPN Tracking Table.
#   4. A [x] control in the Controls Summary has no verification token
#      (script path, commit SHA, vault-ID, REQ-ID, ADR reference,
#      CI Check number, template/starter/docs path, or explicit N/A).
#
# Parameterization:
#
#   PROJECT_ROOT        Your repo root. Default: git rev-parse or pwd.
#   FMEA_DIR            Directory containing DFMEA-*.md and PFMEA-*.md
#                       files. Default: ${PROJECT_ROOT}/docs/decisions
#   RPN_THRESHOLD       Default RPN threshold if not stated in the FMEA.
#                       Default: 75 (ESE default).
#   SEV_THRESHOLD       Default Severity threshold if not stated.
#                       Default: 7 (ESE default).
#
# Exit 0 = pass. Exit 1 = drift detected.

set -euo pipefail

PROJECT_ROOT="${PROJECT_ROOT:-$(git rev-parse --show-toplevel 2>/dev/null || pwd)}"
FMEA_DIR="${FMEA_DIR:-${PROJECT_ROOT}/docs/decisions}"
DEFAULT_RPN_THRESHOLD="${RPN_THRESHOLD:-75}"
DEFAULT_SEV_THRESHOLD="${SEV_THRESHOLD:-7}"

if [ ! -d "$FMEA_DIR" ]; then
  echo "SKIP: FMEA directory not found at $FMEA_DIR"
  exit 0
fi

python3 - "$PROJECT_ROOT" "$FMEA_DIR" "$DEFAULT_RPN_THRESHOLD" "$DEFAULT_SEV_THRESHOLD" <<'PYEOF'
import os
import re
import sys

repo_root = sys.argv[1]
fmea_dir = sys.argv[2]
DEFAULT_RPN_THRESHOLD = int(sys.argv[3])
DEFAULT_SEV_THRESHOLD = int(sys.argv[4])

VERIFY_PATTERNS = [
    re.compile(r'scripts/[A-Za-z0-9_.-]+\.sh'),
    re.compile(r'\b(?:lint|validate|generate)-[a-z0-9-]+\.sh\b'),
    re.compile(r'\btemplates/[A-Za-z0-9_.-]+\.md\b'),
    re.compile(r'\bstarters/[A-Za-z0-9_.-]+\.md\b'),
    re.compile(r'\bdocs/[A-Za-z0-9_./-]+\.md\b'),
    re.compile(r'\bcommit\s+[0-9a-f]{7,40}\b', re.IGNORECASE),
    re.compile(r'\(commit\s+[0-9a-f]{7,40}\)', re.IGNORECASE),
    re.compile(r'\bvault-[a-z0-9]+\b'),
    re.compile(r'\bREQ-[0-9A-Z.]+-[0-9A-Z]+\b'),
    re.compile(r'\bREQ-ADD-[A-Z]+-\d+\b'),
    re.compile(r'\bADR-[0-9A-Za-z-]+\b'),
    re.compile(r'\bCI\s*Check\s*\d+\b', re.IGNORECASE),
    re.compile(r'\bN/?A\b'),
]

violations = []
total_checked = 0

def extract_frontmatter(content):
    m = re.match(r'^---\n(.*?)\n---\n', content, re.DOTALL)
    if not m:
        return {}
    fm = {}
    for line in m.group(1).split('\n'):
        if ':' in line:
            k, v = line.split(':', 1)
            fm[k.strip()] = v.strip().strip('"')
    return fm

def extract_iteration_from_status(status):
    if not status:
        return None
    m = re.search(r'iteration\s+(\d+)', status, re.IGNORECASE)
    if m:
        return int(m.group(1))
    m = re.search(r'iter(?:ation)?\s*(\d+)', status, re.IGNORECASE)
    if m:
        return int(m.group(1))
    return None

def highest_narrative_iteration(content):
    start = content.find('## Iteration Narrative')
    if start < 0:
        return None
    end = content.find('\n## ', start + 10)
    section = content[start:end] if end > 0 else content[start:]
    highest = None
    for m in re.finditer(r'iteration\s+(\d+)', section, re.IGNORECASE):
        n = int(m.group(1))
        if highest is None or n > highest:
            highest = n
    return highest

def is_complete_status(status):
    if not status:
        return False
    s = status.lower()
    return ('complete' in s) or ('closed' in s) or ('accepted' in s)

def parse_rpn_tracking_table(content):
    start = content.find('## RPN Tracking Table')
    if start < 0:
        return (0, {})
    end = content.find('\n## ', start + 10)
    section = content[start:end] if end > 0 else content[start:]

    lines = section.split('\n')
    header_line = None
    for line in lines:
        if line.startswith('| #') or line.startswith('| FM'):
            if 'Iter' in line or 'Resolution' in line:
                header_line = line
                break
    if not header_line:
        return (0, {})

    header_parts = [p.strip() for p in header_line.split('|')]
    header_parts = [p for p in header_parts if p]
    iter_cols = [p for p in header_parts if re.match(r'Iter\s*\d+$', p, re.IGNORECASE)]
    iter_count = len(iter_cols)

    rows = {}
    for line in lines:
        m = re.match(r'\|\s*((?:FM|PF)-\d+)\s*\|(.+)\|\s*$', line)
        if not m:
            continue
        fm_id = m.group(1)
        cells = [c.strip() for c in m.group(2).split('|')]
        rows[fm_id] = cells
    return (iter_count, rows)

def parse_main_fm_table(content):
    result = {}
    for line in content.split('\n'):
        m = re.match(r'\|\s*((?:FM|PF)-\d+)\s*\|', line)
        if not m:
            continue
        fm_id = m.group(1)
        parts = [p.strip() for p in line.split('|')]
        nums = []
        num_positions = []
        for i, p in enumerate(parts):
            stripped = p.replace('**', '').strip()
            if stripped.isdigit():
                nums.append(int(stripped))
                num_positions.append(i)
        if len(nums) >= 4:
            s, o, d, rpn = nums[-4], nums[-3], nums[-2], nums[-1]
            rpn_pos = num_positions[-1]
            action = parts[rpn_pos + 1].strip() if rpn_pos + 1 < len(parts) else ''
            if fm_id not in result:
                result[fm_id] = {'s': s, 'o': o, 'd': d, 'rpn': rpn, 'action': action}
    return result

def action_is_control(action):
    if not action:
        return False
    stripped = action.strip()
    if len(stripped) < 5:
        return False
    placeholders = [r'^action\s+needed$', r'^action\s+required$', r'^tbd$', r'^todo$', r'^pending$', r'^\-+$']
    for p in placeholders:
        if re.match(p, stripped, re.IGNORECASE):
            return False
    return True

def extract_controls_summary(content):
    start = content.find('## Controls Summary')
    if start < 0:
        start = content.find('## Control Summary')
    if start < 0:
        return []
    end = content.find('\n## ', start + 10)
    section = content[start:end] if end > 0 else content[start:]
    results = []
    base_lineno = content[:start].count('\n') + 1
    for i, line in enumerate(section.split('\n')):
        stripped = line.lstrip()
        if stripped.startswith('- '):
            results.append((base_lineno + i, line))
    return results

def threshold_from_content(content, default_rpn, default_sev):
    rpn = default_rpn
    sev = default_sev
    m = re.search(r'RPN\s*(?:threshold)?\s*[:=]\s*(\d+)', content, re.IGNORECASE)
    if m:
        rpn = int(m.group(1))
    m = re.search(r'Severity\s*(?:threshold)?\s*[:=]\s*(\d+)', content, re.IGNORECASE)
    if m:
        sev = int(m.group(1))
    m = re.search(r'Severity\s*>=\s*(\d+)', content)
    if m:
        sev = int(m.group(1))
    return (rpn, sev)

for fname in sorted(os.listdir(fmea_dir)):
    if not (fname.startswith('DFMEA-') or fname.startswith('PFMEA-')):
        continue
    if not fname.endswith('.md'):
        continue
    fpath = os.path.join(fmea_dir, fname)
    relpath = os.path.relpath(fpath, repo_root)
    total_checked += 1

    with open(fpath, encoding='utf-8') as f:
        content = f.read()

    frontmatter = extract_frontmatter(content)
    status = frontmatter.get('status', '')
    rpn_threshold, sev_threshold = threshold_from_content(content, DEFAULT_RPN_THRESHOLD, DEFAULT_SEV_THRESHOLD)
    main_fms = parse_main_fm_table(content)
    iter_count, tracking_rows = parse_rpn_tracking_table(content)
    status_iteration = extract_iteration_from_status(status)
    narrative_iteration = highest_narrative_iteration(content)

    if is_complete_status(status):
        for fm_id, row in main_fms.items():
            s = row['s']
            rpn = row['rpn']
            action = row['action']
            controlled_in_action = action_is_control(action)
            controlled_in_summary = False
            for _, cs_line in extract_controls_summary(content):
                if fm_id in cs_line and (cs_line.lstrip().startswith('- [x]') or cs_line.lstrip().startswith('- [X]')):
                    controlled_in_summary = True
                    break
            has_control = controlled_in_action or controlled_in_summary

            if rpn > rpn_threshold and not has_control:
                violations.append(f"{relpath}: status declared complete but {fm_id} has RPN={rpn} (threshold {rpn_threshold}) with no control in Action column or Controls Summary")
            if s >= sev_threshold and not has_control:
                violations.append(f"{relpath}: status declared complete but {fm_id} has S={s} (threshold {sev_threshold}) with no control in Action column or Controls Summary")

    declared_iter = status_iteration if status_iteration is not None else narrative_iteration
    if declared_iter is not None and iter_count > 0 and declared_iter > iter_count:
        violations.append(f"{relpath}: status/narrative references iteration {declared_iter} but RPN Tracking Table has only {iter_count} Iter columns (FMs added in later iterations have no home in the tracking table)")

    for fm_id, cells in tracking_rows.items():
        if fm_id not in main_fms:
            continue
        main_rpn = main_fms[fm_id]['rpn']
        iter_cells = cells[:iter_count] if iter_count > 0 else cells[:-1]
        latest = None
        for cell in reversed(iter_cells):
            bare = cell.replace('**', '').strip()
            if bare and bare != '-':
                try:
                    latest = int(bare)
                    break
                except ValueError:
                    continue
        if latest is None:
            continue
        if latest != main_rpn:
            violations.append(f"{relpath}: {fm_id} main table RPN={main_rpn} but latest tracking table value is {latest}")

    for lineno, line in extract_controls_summary(content):
        stripped = line.lstrip()
        if not stripped.startswith('- [x]') and not stripped.startswith('- [X]'):
            continue
        has_token = any(p.search(line) for p in VERIFY_PATTERNS)
        if not has_token:
            snippet = line.strip()[:120]
            violations.append(f"{relpath}:{lineno}: [x] control has no verification token (script, SHA, vault-ID, ADR, REQ-ID, CI Check, or N/A): {snippet}")

if violations:
    print("FAIL: FMEA congruence violations:")
    print()
    for v in violations:
        print(f"  {v}")
    print()
    print(f"Summary: {total_checked} FMEAs checked, {len(violations)} violations.")
    sys.exit(1)

print(f"PASS: {total_checked} FMEAs checked; status/iteration/main-table/tracking-table/controls congruent.")
PYEOF
