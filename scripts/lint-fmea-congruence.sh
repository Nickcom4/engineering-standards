#!/usr/bin/env bash
# FMEA congruence linter (REQ-2.1-37, REQ-2.1-41, REQ-2.1-42, REQ-2.1-43)
#
# Catches a specific class of FMEA drift where the document's declared
# state overstates the actual state:
#
#   1. Status says "Complete" or "Closed" but an FM has current RPN or
#      Severity above threshold without a named control in the
#      Controls Summary.
#
#   2. Frontmatter status declares "iteration N" (or the narrative's
#      highest iteration is N) but the RPN Tracking Table has fewer
#      than N Iter columns, so failure modes added in later iterations
#      have no home in the tracking table.
#
#   3. The bolded current RPN in the main FM table does not match the
#      latest non-dash value in that FM's row of the RPN Tracking Table.
#
#   4. A [x] control in the Controls Summary has no verification token
#      (a script path, commit SHA, vault-ID, ADR reference, or REQ-ID).
#      Self-certifying "[x] this is done" lines are flagged so every
#      checked control has at least one pointer to concrete evidence.
#
# Complements:
#   - lint-fmea-consistency.sh  (derived tables match source FM tables)
#   - lint-fmea-controls.sh     ([x] script references exist and are wired)
#   - lint-fmea-completeness.sh (above-threshold FMs have controls)
#
# Those three linters check narrower slices; this linter asserts the
# wider congruence across status, iteration, main table, tracking
# table, and controls.
#
# Exit 0 = pass. Exit 1 = drift detected.

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
FMEA_DIR="$REPO_ROOT/docs/decisions"
APPLICATION_FILE="$REPO_ROOT/docs/standards-application.md"

# Read default FMEA thresholds from the standards-application frontmatter
# if present. This makes standards-application.md the single source of truth
# for project-wide FMEA thresholds (REQ-2.1-48). Falls back to the ESE defaults
# (RPN=75, severity=7) if the frontmatter or its fmea block is missing.
python3 - "$REPO_ROOT" "$FMEA_DIR" "$APPLICATION_FILE" <<'PYEOF'
import os
import re
import sys

repo_root = sys.argv[1]
fmea_dir = sys.argv[2]
application_file = sys.argv[3]

ESE_DEFAULT_RPN_THRESHOLD = 75
ESE_DEFAULT_SEV_THRESHOLD = 7

def read_thresholds_from_frontmatter(path):
    """Return (rpn, sev) from the YAML frontmatter's fmea block, or ESE defaults."""
    rpn = ESE_DEFAULT_RPN_THRESHOLD
    sev = ESE_DEFAULT_SEV_THRESHOLD
    if not os.path.exists(path):
        return (rpn, sev)
    with open(path, encoding='utf-8') as f:
        content = f.read()
    m = re.match(r'^---\n(.*?)\n---\n', content, re.DOTALL)
    if not m:
        return (rpn, sev)
    fm_block = m.group(1)
    # Look for a fmea: block and its two int fields.
    in_fmea = False
    for line in fm_block.split('\n'):
        if re.match(r'^fmea:\s*$', line):
            in_fmea = True
            continue
        if in_fmea:
            if re.match(r'^\S', line):
                # Left the fmea block (next top-level key).
                break
            m2 = re.match(r'^\s+rpn-threshold:\s*(\d+)\s*$', line)
            if m2:
                rpn = int(m2.group(1))
                continue
            m2 = re.match(r'^\s+severity-threshold:\s*(\d+)\s*$', line)
            if m2:
                sev = int(m2.group(1))
                continue
    return (rpn, sev)

DEFAULT_RPN_THRESHOLD, DEFAULT_SEV_THRESHOLD = read_thresholds_from_frontmatter(application_file)

# Verification token patterns for [x] controls. At least one must match.
# A verification token is anything concrete a future auditor can resolve:
# a script (with or without the scripts/ prefix), a commit SHA, a vault-ID,
# a REQ-ID, an ADR reference, a CI Check number, a template/starter path,
# or an explicit N/A with rationale.
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
    """Return the integer iteration number from a status string, or None."""
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
    """Scan the Iteration Narrative section for the highest 'iteration N' or
    'iter N' reference."""
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
    """Return a tuple (iter_column_count, rows_by_fm).
    rows_by_fm maps FM-ID -> list of cell values (one per data column,
    trailing Resolution column included)."""
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
    """Return dict fm_id -> dict(S, O, D, RPN, action). Parses main FM
    table rows and extracts both the numeric scores and the action-column
    text that describes the control."""
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
            # Action column is immediately after RPN
            action = parts[rpn_pos + 1].strip() if rpn_pos + 1 < len(parts) else ''
            if fm_id not in result:
                result[fm_id] = {'s': s, 'o': o, 'd': d, 'rpn': rpn, 'action': action}
    return result

def action_is_control(action):
    """An action-column value counts as a stated control if it is
    non-empty and does not match placeholder patterns."""
    if not action:
        return False
    stripped = action.strip()
    if len(stripped) < 5:
        return False
    placeholders = [
        r'^action\s+needed$',
        r'^action\s+required$',
        r'^tbd$',
        r'^todo$',
        r'^pending$',
        r'^\-+$',
    ]
    for p in placeholders:
        if re.match(p, stripped, re.IGNORECASE):
            return False
    return True

def extract_fm_control_text(content, fm_id):
    """Return concatenated text of all lines mentioning the FM ID across
    the main FM table and Controls Summary. Used to check whether a given
    FM has any control associated with it."""
    hits = []
    for line in content.split('\n'):
        if fm_id in line:
            hits.append(line)
    return '\n'.join(hits)

def extract_controls_summary(content):
    """Return list of (line_number, line_text) for every bullet in
    Controls Summary, whether [x] or [ ] or other markers."""
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
    """Extract RPN and Severity thresholds from the FMEA document if
    stated, else return defaults."""
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

# -------------------------------------------------------------------------
# Main loop over FMEA files
# -------------------------------------------------------------------------
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

    rpn_threshold, sev_threshold = threshold_from_content(
        content, DEFAULT_RPN_THRESHOLD, DEFAULT_SEV_THRESHOLD
    )

    main_fms = parse_main_fm_table(content)
    iter_count, tracking_rows = parse_rpn_tracking_table(content)
    status_iteration = extract_iteration_from_status(status)
    narrative_iteration = highest_narrative_iteration(content)

    # ---- Check 1: Status vs threshold congruence ----
    #
    # If the FMEA is marked Complete/Closed, every FM whose current RPN
    # or Severity is at or above threshold must have a stated control.
    # A control is stated if EITHER (a) the main table Action column has
    # non-placeholder content, OR (b) the Controls Summary has a bullet
    # that mentions the FM ID.
    if is_complete_status(status):
        for fm_id, row in main_fms.items():
            s = row['s']
            rpn = row['rpn']
            action = row['action']

            # Does the FMEA document a control for this FM anywhere?
            controlled_in_action = action_is_control(action)
            controlled_in_summary = False
            for _, cs_line in extract_controls_summary(content):
                if fm_id in cs_line and (
                    cs_line.lstrip().startswith('- [x]') or
                    cs_line.lstrip().startswith('- [X]')
                ):
                    controlled_in_summary = True
                    break
            has_control = controlled_in_action or controlled_in_summary

            if rpn > rpn_threshold and not has_control:
                violations.append(
                    f"{relpath}: status declared complete but {fm_id} has RPN={rpn} "
                    f"(threshold {rpn_threshold}) with no control in Action column or Controls Summary"
                )
            if s >= sev_threshold and not has_control:
                violations.append(
                    f"{relpath}: status declared complete but {fm_id} has S={s} "
                    f"(threshold {sev_threshold}) with no control in Action column or Controls Summary"
                )

    # ---- Check 2: Iteration column coverage ----
    declared_iter = None
    if status_iteration is not None:
        declared_iter = status_iteration
    elif narrative_iteration is not None:
        declared_iter = narrative_iteration

    if declared_iter is not None and iter_count > 0 and declared_iter > iter_count:
        violations.append(
            f"{relpath}: status/narrative references iteration {declared_iter} but "
            f"RPN Tracking Table has only {iter_count} Iter columns "
            f"(FMs added in later iterations have no home in the tracking table)"
        )

    # ---- Check 3: Current-RPN congruence between main table and tracking table ----
    for fm_id, cells in tracking_rows.items():
        if fm_id not in main_fms:
            continue
        main_rpn = main_fms[fm_id]['rpn']
        # Iter columns are cells[0:iter_count]. Resolution is the last cell.
        iter_cells = cells[:iter_count] if iter_count > 0 else cells[:-1]
        latest = None
        for cell in reversed(iter_cells):
            # Strip bold markers and check for a numeric value
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
            violations.append(
                f"{relpath}: {fm_id} main table RPN={main_rpn} but latest tracking table value is {latest}"
            )

    # ---- Check 4: [x] controls have a verification token ----
    for lineno, line in extract_controls_summary(content):
        stripped = line.lstrip()
        if not stripped.startswith('- [x]') and not stripped.startswith('- [X]'):
            continue
        has_token = any(p.search(line) for p in VERIFY_PATTERNS)
        if not has_token:
            snippet = line.strip()[:120]
            violations.append(
                f"{relpath}:{lineno}: [x] control has no verification token (script, SHA, vault-ID, ADR, REQ-ID, CI Check, or N/A): {snippet}"
            )

# -------------------------------------------------------------------------
# Report
# -------------------------------------------------------------------------
if violations:
    print("FAIL: FMEA congruence violations (REQ-2.1-37, REQ-2.1-41, REQ-2.1-42, REQ-2.1-43):")
    print()
    for v in violations:
        print(f"  {v}")
    print()
    print(f"Summary: {total_checked} FMEAs checked, {len(violations)} violations.")
    print()
    print("Fix:")
    print("  - If status is Complete/Closed but an FM is above threshold, either")
    print("    implement the control (and link it in Controls Summary) or change")
    print("    the status back to in-progress.")
    print("  - If status/narrative mentions an iteration N, add the Iter N column")
    print("    to the RPN Tracking Table so FMs introduced in iteration N have a")
    print("    home. Resolution column is not a substitute for an Iter N column.")
    print("  - If main table RPN differs from the latest tracking table value,")
    print("    update the tracking table with a new iteration column showing the")
    print("    current score.")
    print("  - If a [x] control has no verification token, add one: the commit")
    print("    SHA where the control was implemented, a vault-ID, a REQ-ID, an")
    print("    ADR reference, a CI Check number, a scripts/*.sh path, or an")
    print("    explicit N/A if the control is genuinely not applicable.")
    sys.exit(1)

print(f"PASS: {total_checked} FMEAs checked; status/iteration/main-table/tracking-table/controls congruent.")
PYEOF
