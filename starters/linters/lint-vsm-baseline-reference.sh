#!/usr/bin/env bash
# lint-vsm-baseline-reference.sh (adopter starter): improvement-WI baseline
# VSM citation linter.
#
# status: shadow
#
# Runs in CI and records its output for auditability but does not block the
# build. Adopters who are ready to enforce can flip the status header from
# `shadow` to `gate` and wire the exit code as blocking in their CI; the
# script logic is the same in both modes. Promotion is an adopter decision
# based on accumulated true-positive catches in the shadow phase.
#
# What it catches
#
#   For every work item whose YAML frontmatter declares `type: improvement`,
#   the Dependencies table must cite at least one baseline VSM from the
#   configured archive directory. The cited file must exist.
#
#   REQ-ADD-CI-01 (continuous improvement addendum) requires the current-
#   state map to draw from at least 10 completed work items before
#   optimization. Without an archived baseline, cross-cycle comparison is
#   not possible and the improvement claim cannot be verified against a
#   prior measurement.
#
# Parameterization
#
#   PROJECT_ROOT     Your repo root. Default: git rev-parse or pwd.
#   WORK_ITEMS_DIR   Directory containing work-item *.md files.
#                    Default: ${PROJECT_ROOT}/docs/work-items
#   VSM_DIR          Directory containing baseline VSM archive.
#                    Default: ${PROJECT_ROOT}/docs/improvement/vsm
#
# Exit 0 always (shadow). Violations are printed but do not affect the exit
# code. Adopters promoting to gate should change the final sys.exit(0) at
# the shadow-violation path to sys.exit(1).

set -euo pipefail

PROJECT_ROOT="${PROJECT_ROOT:-$(git rev-parse --show-toplevel 2>/dev/null || pwd)}"
WORK_ITEMS_DIR="${WORK_ITEMS_DIR:-${PROJECT_ROOT}/docs/work-items}"
VSM_DIR="${VSM_DIR:-${PROJECT_ROOT}/docs/improvement/vsm}"

if [ ! -d "$WORK_ITEMS_DIR" ]; then
  echo "SKIP: WORK_ITEMS_DIR not found at $WORK_ITEMS_DIR; linter not applicable."
  exit 0
fi

# Compute the VSM directory relative to PROJECT_ROOT so Dependency cells
# containing relative paths can be matched. If VSM_DIR is outside
# PROJECT_ROOT the match falls through and the linter reports unresolvable
# citations; adopters with an unusual layout can edit the match logic.
case "$VSM_DIR" in
  "$PROJECT_ROOT"/*)
    VSM_DIR_REL="${VSM_DIR#$PROJECT_ROOT/}"
    ;;
  *)
    VSM_DIR_REL="$VSM_DIR"
    ;;
esac

python3 - "$PROJECT_ROOT" "$WORK_ITEMS_DIR" "$VSM_DIR_REL" <<'PYEOF'
import os
import re
import sys
from pathlib import Path

project_root = Path(sys.argv[1])
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
        if re.match(r'^\|[\s\-:|]+\|$', s):
            continue
        cells = [c.strip() for c in s.strip("|").split("|")]
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
    md_link = re.match(r'^\[[^\]]+\]\(([^)]+)\)\s*$', cell)
    if md_link:
        return md_link.group(1)
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
        abs_path = project_root / dep_path
        if abs_path.is_file():
            resolved = True
            break
        unresolved_candidates.append(dep_path)
    if not resolved:
        try:
            rel_wi = wi_path.relative_to(project_root)
        except ValueError:
            rel_wi = wi_path
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
    print(f"PASS: no type:improvement work items found under {work_items_dir}; silent.")
    sys.exit(0)

if violations:
    print(f"SHADOW: {len(violations)} improvement work item(s) with missing or unresolvable VSM baseline citation (out of {improvement_count} checked):")
    for v in violations:
        print(f"  {v}")
    print()
    print("REQ-ADD-CI-01: current-state VSM must be archived under")
    print(f"{vsm_dir_rel}/ and cited from the improvement work item's Dependencies table.")
    print()
    print("Shadow status: this finding is recorded for auditability but does not")
    print("block the build. Flip `status: shadow` to `status: gate` in this")
    print("script and adjust your CI wiring to promote.")
    sys.exit(0)

print(f"PASS: {improvement_count} type:improvement work item(s) all cite a resolvable baseline VSM.")
PYEOF
