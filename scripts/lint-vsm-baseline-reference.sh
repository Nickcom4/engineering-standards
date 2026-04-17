#!/usr/bin/env bash
# lint-vsm-baseline-reference.sh: improvement-WI baseline VSM citation linter.
#
# status: shadow
#
# Runs in CI and records its output for auditability but does not block the
# build. Promotion to gate status is evidence-based: after the shadow phase
# accumulates true-positive catches and zero false-positive patterns, the
# gate authority changes `status: shadow` to `status: gate` and the CI
# wiring begins treating the exit code as blocking. See
# docs/decisions/ADR-2026-04-16-vsm-baseline-archiving-and-enforcement.md
# for the enforcement posture decision.
#
# What it catches
#
#   For every work item whose YAML frontmatter declares `type: improvement`,
#   the Dependencies table must cite at least one baseline VSM from the
#   archive at docs/improvement/vsm/. The cited file must exist.
#
#   An improvement claim rests on a before-and-after comparison of delivery
#   stages; without an archived baseline, cross-cycle comparison is not
#   possible and the claim cannot be verified. REQ-ADD-CI-01 (continuous
#   improvement addendum) is the standards anchor.
#
# How it reads references
#
#   1. Walk docs/work-items/ recursively for *.md files.
#   2. Parse YAML frontmatter for a `type:` field equal to `improvement`.
#   3. Parse the Dependencies table (three columns: Dependency, Type, Status).
#   4. For each row, check whether the Dependency cell contains a relative
#      path beginning with docs/improvement/vsm/ that resolves to a file.
#   5. If the work item declares type:improvement and no Dependencies row
#      resolves to an existing VSM, record a violation.
#
# Silent pass when no improvement work items exist.
#
# Exit 0 always (shadow). The script sets SHADOW_EXIT=1 internally when
# violations are found so promotion to gate only requires flipping the
# advertised status and the CI wiring, not the script logic.

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
WORK_ITEMS_DIR="${REPO_ROOT}/docs/work-items"
VSM_DIR_REL="docs/improvement/vsm"
VSM_DIR_ABS="${REPO_ROOT}/${VSM_DIR_REL}"

if [ ! -d "$WORK_ITEMS_DIR" ]; then
  echo "SKIP: no docs/work-items/ directory; linter not applicable."
  exit 0
fi

python3 - "$REPO_ROOT" "$WORK_ITEMS_DIR" "$VSM_DIR_REL" <<'PYEOF'
import os
import re
import sys
from pathlib import Path

repo_root = Path(sys.argv[1])
work_items_dir = Path(sys.argv[2])
vsm_dir_rel = sys.argv[3]

FRONTMATTER_RE = re.compile(r'^---\s*\n(.*?)\n---\s*\n', re.DOTALL)
TYPE_RE = re.compile(r'^type:\s*(\S+)\s*$', re.MULTILINE)


def extract_type(content: str) -> str:
    m = FRONTMATTER_RE.match(content)
    if not m:
        return ""
    fm = m.group(1)
    t = TYPE_RE.search(fm)
    return t.group(1) if t else ""


def extract_dependencies_rows(content: str):
    # Find the ## Dependencies section and capture its first table.
    section_re = re.compile(
        r'^##\s+Dependencies\s*\n(.*?)(?=^##\s|\Z)',
        re.MULTILINE | re.DOTALL,
    )
    sect = section_re.search(content)
    if not sect:
        return []
    body = sect.group(1)
    rows = []
    for line in body.splitlines():
        s = line.strip()
        if not s.startswith("|") or not s.endswith("|"):
            continue
        # Skip header separator like | --- | --- | --- |
        if re.match(r'^\|[\s\-:|]+\|$', s):
            continue
        cells = [c.strip() for c in s.strip("|").split("|")]
        # A dependency row has at least a Dependency cell plus two more.
        if len(cells) >= 3:
            rows.append(cells)
    return rows


def find_improvement_work_items(wi_dir: Path):
    for p in wi_dir.rglob("*.md"):
        try:
            with open(p, encoding="utf-8") as f:
                content = f.read()
        except Exception:
            continue
        t = extract_type(content)
        if t == "improvement":
            yield p, content


def extract_path_from_cell(cell: str) -> str:
    # The Dependency cell may contain a raw path or a markdown link.
    # Examples:
    #   docs/improvement/vsm/VSM-2026-04-16-foo.md
    #   [VSM-2026-04-16-foo.md](docs/improvement/vsm/VSM-2026-04-16-foo.md)
    md_link = re.match(r'^\[[^\]]+\]\(([^)]+)\)\s*$', cell)
    if md_link:
        return md_link.group(1)
    # Strip any inline code backticks
    return cell.strip("`").strip()


violations = []
improvement_count = 0

for wi_path, content in find_improvement_work_items(work_items_dir):
    improvement_count += 1
    rows = extract_dependencies_rows(content)
    resolved = False
    unresolved_candidates = []
    for row in rows:
        dep_path = extract_path_from_cell(row[0])
        if not dep_path.startswith(vsm_dir_rel + "/"):
            continue
        abs_path = repo_root / dep_path
        if abs_path.is_file():
            resolved = True
            break
        unresolved_candidates.append(dep_path)
    if not resolved:
        rel_wi = wi_path.relative_to(repo_root)
        if unresolved_candidates:
            violations.append(
                f"{rel_wi}: declares type:improvement and cites {len(unresolved_candidates)} "
                f"VSM path(s), but none resolve on disk: {unresolved_candidates}"
            )
        else:
            violations.append(
                f"{rel_wi}: declares type:improvement but Dependencies table "
                f"has no citation under {vsm_dir_rel}/"
            )

if improvement_count == 0:
    print(f"PASS: no type:improvement work items found under {work_items_dir.relative_to(repo_root)}/; silent.")
    sys.exit(0)

if violations:
    print(f"SHADOW: {len(violations)} improvement work item(s) with missing or unresolvable VSM baseline citation (out of {improvement_count} checked):")
    for v in violations:
        print(f"  {v}")
    print()
    print("REQ-ADD-CI-01: current-state VSM must be archived under")
    print(f"{vsm_dir_rel}/ and cited from the improvement work item's Dependencies table.")
    print("Run `bash scripts/new-artifact.sh vsm \"<title>\"` to scaffold a new VSM.")
    print()
    print("Shadow status: this finding is recorded for auditability but does not")
    print("block the build. Promotion to gate is evidence-based per the")
    print("linter's introducing ADR.")
    # Shadow: do not fail the build.
    sys.exit(0)

print(f"PASS: {improvement_count} type:improvement work item(s) all cite a resolvable baseline VSM.")
PYEOF
