#!/usr/bin/env bash
# Standards-application frontmatter linter (adopter-portable version).
#
# Validates the YAML frontmatter in your project's standards-application.md
# against three tiers of rules:
#
#   Tier 1: Presence, types, enums, date formats, and numeric ranges.
#   Tier 2: Internal consistency between the YAML block and the prose
#           tables in the same file (Component Capabilities Declaration,
#           Applicable Addenda, FMEA Thresholds, §4.1 Verification Mode,
#           footer version/date lines, owner name citation).
#   Tier 3: Claim-vs-reality consistency against the rest of the repo
#           (ese-version matches the pinned submodule tag, template-
#           compliance evidence path exists and is wired into your CI,
#           addendum REQs not positively cited when the addendum is
#           declared not applicable).
#
# The frontmatter block is the machine-readable summary of the document's
# applicability claims. The prose stays human-readable; this linter
# enforces that the two never diverge.
#
# Parameterization (environment variables with sensible defaults):
#
#   PROJECT_ROOT        Your project's root (auto-detected from git if unset).
#   ESE_ROOT            Path to the vendored ESE submodule (default:
#                       $PROJECT_ROOT/.standards; set to the correct path
#                       if you vendored ESE elsewhere, e.g.
#                       $PROJECT_ROOT/engineering-standards).
#   APPLICATION_FILE    Path to your project's standards-application.md
#                       (default: $PROJECT_ROOT/docs/standards-application.md).
#   CHANGELOG_PATH      Path to the CHANGELOG.md used to validate the
#                       ese-version pin. Defaults to $ESE_ROOT/CHANGELOG.md
#                       so the pin is compared against the submodule's
#                       changelog, NOT your own project changelog. Override
#                       only if you use a non-standard ESE submodule layout.
#   CI_WORKFLOW         Path to your CI workflow file for the Tier 3 evidence-
#                       path check (default: $PROJECT_ROOT/.github/workflows/ci.yml).
#
# Exit 0 = pass. Exit 1 = violations found.

set -euo pipefail

# Auto-detect PROJECT_ROOT from git if unset.
if [ -z "${PROJECT_ROOT:-}" ]; then
    PROJECT_ROOT=$(git rev-parse --show-toplevel 2>/dev/null || pwd)
fi
: "${ESE_ROOT:=$PROJECT_ROOT/.standards}"
: "${APPLICATION_FILE:=$PROJECT_ROOT/docs/standards-application.md}"
: "${CHANGELOG_PATH:=$ESE_ROOT/CHANGELOG.md}"
: "${CI_WORKFLOW:=$PROJECT_ROOT/.github/workflows/ci.yml}"

export PROJECT_ROOT ESE_ROOT APPLICATION_FILE CHANGELOG_PATH CI_WORKFLOW

python3 - "$PROJECT_ROOT" "$APPLICATION_FILE" "$CHANGELOG_PATH" "$CI_WORKFLOW" "$ESE_ROOT" <<'PYEOF'
import os
import re
import sys
from pathlib import Path

project_root = Path(sys.argv[1])
application_file = Path(sys.argv[2])
changelog = Path(sys.argv[3])
ci_workflow = Path(sys.argv[4])
ese_root = Path(sys.argv[5])

violations = []

# ----------------------------------------------------------------------
# Tier 1: Frontmatter presence, types, enums.
# ----------------------------------------------------------------------

if not application_file.exists():
    print(f"FAIL: {application_file} does not exist")
    print(f"  Set APPLICATION_FILE to the correct path if your project uses a non-standard layout.")
    sys.exit(1)

content = application_file.read_text(encoding='utf-8')
m = re.match(r'^---\n(.*?)\n---\n', content, re.DOTALL)
if not m:
    print(f"FAIL: {application_file} has no YAML frontmatter block.")
    print("  Expected a --- delimited block at the top of the file.")
    sys.exit(1)
fm_text = m.group(1)


def strip_inline_comment(val):
    """Strip a trailing YAML inline comment (space-hash onward) from a
    scalar value. Quote-aware: a hash inside a quoted string is preserved."""
    if val.startswith('"'):
        end = val.find('"', 1)
        if end >= 0:
            return val[:end + 1]
        return val
    if val.startswith("'"):
        end = val.find("'", 1)
        if end >= 0:
            return val[:end + 1]
        return val
    idx = val.find(' #')
    if idx >= 0:
        return val[:idx].rstrip()
    return val.rstrip()


def parse_scalar(val):
    val = strip_inline_comment(val)
    if val.startswith('"') and val.endswith('"'):
        return val[1:-1]
    if val.startswith("'") and val.endswith("'"):
        return val[1:-1]
    if val in ('true', 'yes'):
        return True
    if val in ('false', 'no'):
        return False
    if re.match(r'^-?\d+$', val):
        return int(val)
    return val


def parse_frontmatter(text):
    """Minimal nested YAML parser for the known schema shape."""
    root = {}
    current_parent = None
    for raw in text.split('\n'):
        if not raw.strip() or raw.lstrip().startswith('#'):
            continue
        if re.match(r'^[a-zA-Z]', raw):
            mm = re.match(r'^([a-zA-Z0-9_-]+):\s*(.*)$', raw)
            if not mm:
                continue
            key, val = mm.group(1), mm.group(2).strip()
            if not val:
                root[key] = {}
                current_parent = key
            else:
                root[key] = parse_scalar(val)
                current_parent = None
        elif current_parent is not None:
            mm = re.match(r'^\s+([a-zA-Z0-9_-]+):\s*(.*)$', raw)
            if not mm:
                continue
            key, val = mm.group(1), mm.group(2).strip()
            root[current_parent][key] = parse_scalar(val)
    return root


fm = parse_frontmatter(fm_text)

REQUIRED_CAPABILITIES = [
    'has-runtime-service', 'deploys-to-production', 'exposes-api',
    'has-persistent-storage', 'manages-infrastructure', 'handles-sensitive-data',
    'has-external-users', 'produces-user-visible-output',
    'has-runtime-dependencies', 'has-multiple-repositories', 'contains-logic-code',
]
REQUIRED_ADDENDA = [
    'multi-service', 'multi-team', 'web-applications', 'containerized',
    'ai-ml', 'event-driven', 'continuous-improvement',
]
ALLOWED_CADENCES = {
    'every-significant-release', 'quarterly', 'semi-annual', 'annual', 'event-triggered',
}
ALLOWED_TEMPLATE_MODES = {'automated', 'compliance-review'}


def get(path):
    cur = fm
    for p in path.split('.'):
        if not isinstance(cur, dict) or p not in cur:
            return None
        cur = cur[p]
    return cur


def require(path, typecheck, errmsg):
    val = get(path)
    if val is None:
        violations.append(f"Tier1: frontmatter missing {path}")
        return None
    if not typecheck(val):
        violations.append(f"Tier1: frontmatter {path} = {val!r} {errmsg}")
        return None
    return val


def is_nonempty_str(v):
    return isinstance(v, str) and v != ''


def is_bool(v):
    return isinstance(v, bool)


def is_pos_int(v):
    return isinstance(v, int) and not isinstance(v, bool) and v > 0


ese_version = require('ese-version', is_nonempty_str, 'is not a non-empty string')
last_updated = require('last-updated', is_nonempty_str, 'is not a non-empty string')
require('owner.name', is_nonempty_str, 'is not a non-empty string')
require('owner.contact', is_nonempty_str, 'is not a non-empty string')
cadence = require('compliance-review.cadence', is_nonempty_str, 'is not a non-empty string')
require('compliance-review.last-review-date', is_nonempty_str, 'is not a non-empty string')
require('compliance-review.next-review-trigger', is_nonempty_str, 'is not a non-empty string')

if cadence and cadence not in ALLOWED_CADENCES:
    violations.append(
        f"Tier1: compliance-review.cadence={cadence!r} not in {sorted(ALLOWED_CADENCES)}"
    )

for key in REQUIRED_CAPABILITIES:
    require(f'capabilities.{key}', is_bool, 'is not a bool')
for key in REQUIRED_ADDENDA:
    require(f'addenda.{key}', is_bool, 'is not a bool')

tc_mode = require('template-compliance.mode', is_nonempty_str, 'is not a non-empty string')
tc_evidence = require('template-compliance.evidence', is_nonempty_str, 'is not a non-empty string')
if tc_mode and tc_mode not in ALLOWED_TEMPLATE_MODES:
    violations.append(
        f"Tier1: template-compliance.mode={tc_mode!r} not in {sorted(ALLOWED_TEMPLATE_MODES)}"
    )

rpn_threshold = require('fmea.rpn-threshold', is_pos_int, 'is not a positive int')
sev_threshold = require('fmea.severity-threshold', is_pos_int, 'is not a positive int')
if isinstance(rpn_threshold, int) and not (1 <= rpn_threshold <= 1000):
    violations.append(f"Tier1: fmea.rpn-threshold={rpn_threshold} out of range 1-1000")
if isinstance(sev_threshold, int) and not (1 <= sev_threshold <= 10):
    violations.append(f"Tier1: fmea.severity-threshold={sev_threshold} out of range 1-10")

for date_path in ('last-updated', 'compliance-review.last-review-date'):
    val = get(date_path)
    if isinstance(val, str) and not re.match(r'^\d{4}-\d{2}-\d{2}$', val):
        violations.append(f"Tier1: {date_path}={val!r} is not YYYY-MM-DD")

if violations:
    print(f"FAIL: {application_file} frontmatter violations:")
    for v in violations:
        print(f"  {v}")
    sys.exit(1)

# ----------------------------------------------------------------------
# Tier 2: Internal consistency (YAML ↔ prose).
# ----------------------------------------------------------------------

def prose_yesno_to_bool(cell):
    s = cell.strip().lower()
    if s in ('yes', 'y'):
        return True
    if s in ('no', 'n'):
        return False
    return None


def strip_md_link(s):
    """Strip markdown link syntax '[Label](url)' -> 'Label' for cell value
    matching. Adopter prose may use linked labels for addenda rows."""
    return re.sub(r'\[([^\]]+)\]\([^)]*\)', r'\1', s)


def parse_md_table(body, heading_exact):
    lines = body.split('\n')
    try:
        start = next(i for i, ln in enumerate(lines) if ln.strip() == heading_exact)
    except StopIteration:
        return None
    rows = []
    header = None
    for ln in lines[start + 1:]:
        if ln.startswith('## ') or ln.startswith('# '):
            break
        if not ln.lstrip().startswith('|'):
            continue
        cells = [strip_md_link(c.strip()) for c in ln.strip().strip('|').split('|')]
        if all(re.match(r'^[-:\s]+$', c) for c in cells):
            continue
        if header is None:
            header = cells
            continue
        if len(cells) == len(header):
            rows.append(dict(zip(header, cells)))
    return rows


CAP_LABEL_TO_KEY = {
    'Has runtime service (always-on process)': 'has-runtime-service',
    'Deploys to production environment': 'deploys-to-production',
    'Exposes API consumed by other systems': 'exposes-api',
    'Has database or persistent storage': 'has-persistent-storage',
    'Manages infrastructure (servers, cloud)': 'manages-infrastructure',
    'Handles sensitive or personal data': 'handles-sensitive-data',
    'Has external users or consumers': 'has-external-users',
    'Produces user-visible output': 'produces-user-visible-output',
    'Has declared runtime dependencies': 'has-runtime-dependencies',
    'Has multiple repositories': 'has-multiple-repositories',
    'Contains logic code (branching, looping, error handling)': 'contains-logic-code',
}

cap_rows = parse_md_table(content, '## Component Capabilities Declaration')
if cap_rows is None:
    violations.append("Tier2: prose '## Component Capabilities Declaration' section not found")
else:
    seen = set()
    for row in cap_rows:
        label = row.get('Capability', '').strip()
        present_cell = row.get('Present?', '').strip()
        if label not in CAP_LABEL_TO_KEY:
            continue
        key = CAP_LABEL_TO_KEY[label]
        seen.add(label)
        prose_bool = prose_yesno_to_bool(present_cell)
        if prose_bool is None:
            violations.append(
                f"Tier2: Capabilities row {label!r} Present? cell is {present_cell!r} (expected Yes/No)"
            )
            continue
        yaml_bool = fm['capabilities'].get(key)
        if prose_bool != yaml_bool:
            violations.append(
                f"Tier2: capabilities.{key}={yaml_bool} but prose table says {present_cell!r}"
            )
    for label in CAP_LABEL_TO_KEY:
        if label not in seen:
            violations.append(f"Tier2: Capabilities table missing row {label!r}")

ADDENDUM_LABEL_TO_KEY = {
    'Multi-Service Architectures': 'multi-service',
    'Multi-Team Organizations': 'multi-team',
    'Web Applications': 'web-applications',
    'Containerized and Orchestrated Systems': 'containerized',
    'AI and ML Systems': 'ai-ml',
    'Event-Driven Systems': 'event-driven',
    'Continuous Improvement': 'continuous-improvement',
}

add_rows = parse_md_table(content, '## Applicable Addenda')
if add_rows is None:
    violations.append("Tier2: prose '## Applicable Addenda' section not found")
else:
    seen = set()
    for row in add_rows:
        label = row.get('Addendum', '').strip()
        applies_cell = row.get('Applies?', '').strip()
        if label not in ADDENDUM_LABEL_TO_KEY:
            continue
        key = ADDENDUM_LABEL_TO_KEY[label]
        seen.add(label)
        prose_bool = prose_yesno_to_bool(applies_cell)
        if prose_bool is None:
            violations.append(
                f"Tier2: Addenda row {label!r} Applies? cell is {applies_cell!r} (expected Yes/No)"
            )
            continue
        yaml_bool = fm['addenda'].get(key)
        if prose_bool != yaml_bool:
            violations.append(
                f"Tier2: addenda.{key}={yaml_bool} but prose table says {applies_cell!r}"
            )
    for label in ADDENDUM_LABEL_TO_KEY:
        if label not in seen:
            violations.append(f"Tier2: Addenda table missing row {label!r}")

m = re.search(r'\*\*RPN threshold:\*\*\s*(\d+)', content)
if not m:
    violations.append("Tier2: 'FMEA Thresholds' section missing '**RPN threshold:** N' line")
elif int(m.group(1)) != rpn_threshold:
    violations.append(f"Tier2: fmea.rpn-threshold={rpn_threshold} but prose says {m.group(1)}")

m = re.search(r'\*\*Severity threshold:\*\*\s*(\d+)', content)
if not m:
    violations.append("Tier2: 'FMEA Thresholds' section missing '**Severity threshold:** N' line")
elif int(m.group(1)) != sev_threshold:
    violations.append(f"Tier2: fmea.severity-threshold={sev_threshold} but prose says {m.group(1)}")

tc_heading = '## §4.1 Template Compliance Verification Mode'
tc_start = content.find(tc_heading)
if tc_start < 0:
    violations.append(f"Tier2: prose '{tc_heading}' section not found")
else:
    tc_end = content.find('\n## ', tc_start + 10)
    tc_section = content[tc_start:tc_end] if tc_end > 0 else content[tc_start:]
    mm = re.search(r'\*\*Verification mode:\*\*\s*(\w+)', tc_section)
    if not mm:
        violations.append("Tier2: §4.1 section missing '**Verification mode:** <value>' line")
    elif mm.group(1).lower() != tc_mode.lower():
        violations.append(
            f"Tier2: template-compliance.mode={tc_mode!r} but prose says {mm.group(1)!r}"
        )
    if tc_evidence and tc_evidence not in tc_section:
        violations.append(
            f"Tier2: template-compliance.evidence={tc_evidence!r} not cited in §4.1 prose"
        )

owner_name = get('owner.name')
if owner_name and owner_name not in content:
    violations.append(f"Tier2: owner.name={owner_name!r} not cited in prose")

if f"*Standard version applied: {ese_version}*" not in content:
    violations.append(
        f"Tier2: footer 'Standard version applied' does not match ese-version={ese_version!r}"
    )
if f"*Last updated: {last_updated}*" not in content:
    violations.append(
        f"Tier2: footer 'Last updated' does not match last-updated={last_updated!r}"
    )

# ----------------------------------------------------------------------
# Tier 3: Claim-vs-reality (cross-repo).
# ----------------------------------------------------------------------

# 3a. ese-version matches the pinned submodule CHANGELOG's latest version
# heading. The CHANGELOG_PATH defaults to the submodule's CHANGELOG, NOT
# the adopter's own CHANGELOG, because ese-version pins the ESE version,
# not the adopter project's version.
if changelog.exists():
    cl_text = changelog.read_text(encoding='utf-8')
    headings = re.findall(r'^##\s+\[(\d+\.\d+\.\d+)\]', cl_text, re.MULTILINE)
    if not headings:
        violations.append(f"Tier3: {changelog} has no versioned headings")
    elif headings[0] != ese_version:
        violations.append(
            f"Tier3: ese-version={ese_version!r} but latest heading in "
            f"{changelog.relative_to(project_root) if changelog.is_relative_to(project_root) else changelog}"
            f" is {headings[0]!r} (the ESE submodule version your project pinned in "
            f"the starter YAML does not match the submodule's own latest release)"
        )
else:
    violations.append(
        f"Tier3: {changelog} does not exist "
        f"(set CHANGELOG_PATH to the correct submodule CHANGELOG location)"
    )

# 3b. template-compliance.evidence script exists and is wired into CI.
if tc_mode == 'automated' and tc_evidence:
    ev_path = project_root / tc_evidence
    if not ev_path.exists():
        violations.append(
            f"Tier3: template-compliance.evidence={tc_evidence!r} does not exist on disk"
        )
    elif ci_workflow.exists():
        ci_text = ci_workflow.read_text(encoding='utf-8')
        if os.path.basename(tc_evidence) not in ci_text:
            violations.append(
                f"Tier3: template-compliance.evidence={tc_evidence!r} not wired into "
                f"{ci_workflow.relative_to(project_root) if ci_workflow.is_relative_to(project_root) else ci_workflow}"
            )

# 3c. Addendum REQ activation: if addendum X is false, no REQ-ID with
# applies_when: "addendum:<token>" may be positively cited inside the
# adopter's standards-application.md itself.
ADDENDUM_TO_TOKEN = {
    'multi-service': 'MS',
    'multi-team': 'MT',
    'web-applications': 'WEB',
    'containerized': 'CTR',
    'ai-ml': 'AI',
    'event-driven': 'EVT',
    'continuous-improvement': 'CI',
}

for addendum_key, token in ADDENDUM_TO_TOKEN.items():
    if fm['addenda'].get(addendum_key):
        continue
    pattern = re.compile(rf'\bREQ-ADD-{token}-\d+\b')
    if pattern.search(content):
        hits = pattern.findall(content)
        violations.append(
            f"Tier3: addenda.{addendum_key}=false but {application_file.name} "
            f"references {sorted(set(hits))} (addendum REQs should not be cited when addendum is inactive)"
        )

# ----------------------------------------------------------------------
# Report
# ----------------------------------------------------------------------
if violations:
    print(f"FAIL: {application_file} frontmatter violations:")
    for v in violations:
        print(f"  {v}")
    print()
    print("Fix:")
    print("  - Tier1 violations: correct the frontmatter schema.")
    print("  - Tier2 violations: reconcile the YAML block with the prose tables and footer.")
    print("  - Tier3 violations: update the YAML to match reality, or fix the reality to match the YAML.")
    print()
    print("Parameterization (env vars): PROJECT_ROOT, ESE_ROOT, APPLICATION_FILE, CHANGELOG_PATH, CI_WORKFLOW.")
    sys.exit(1)

print(f"PASS: {application_file.name} frontmatter is schema-valid and consistent with prose and repo state.")
PYEOF
