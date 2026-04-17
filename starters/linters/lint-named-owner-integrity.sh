#!/usr/bin/env bash
# lint-named-owner-integrity.sh (adopter starter): named-owner integrity linter.
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
#   Scans the configured normative artifact directories (ADRs, post-mortems,
#   A3s, investigations, PRDs, capabilities docs, FMEAs, architecture docs)
#   for occurrences of the owner name declared in the project's
#   standards-application.md YAML `owner.name`. The owner name is permitted
#   in the owner/deciders frontmatter of each artifact (that is the
#   artifact's own legitimate record of authorship); occurrences in the
#   artifact body are flagged.
#
#   ESE §2.4 requires every service in production to have a discoverable
#   named owner (REQ-2.4-01, P15). The ESE writing rule is: "no person
#   names in normative content. The named owner field in
#   standards-application.md is the only place for an operator name."
#   Named-owner integrity confirms the rule holds across the actual
#   artifact corpus, not just in theory.
#
#   Silent-passes when no owner is declared, when the declared name is
#   blank, or when no normative artifacts exist at the configured paths.
#
# Parameterization
#
#   PROJECT_ROOT        Your repo root. Default: git rev-parse or pwd.
#   APPLICATION_FILE    Path to your project's standards-application.md.
#                       Default: ${PROJECT_ROOT}/docs/standards-application.md.
#                       Set to the path your project uses (for example,
#                       ${PROJECT_ROOT}/standards-application.md at the
#                       project root) if your layout differs.
#   ARTIFACT_DIRS       Colon-separated list of normative-artifact
#                       directories to scan (paths relative to
#                       PROJECT_ROOT). Default covers the common ESE
#                       layout: "docs/decisions:docs/adrs:docs/incidents:docs/investigations:docs/product:docs/fmeas:docs/architecture:docs/architecture.md:docs/standards-application.md"
#                       Directories are scanned recursively for *.md
#                       files; single-file paths are scanned as-is.
#   MAX_FINDINGS        Maximum number of per-line findings printed.
#                       Defaults to 20. A trailer line reports the
#                       truncation.
#   PYTHON3             Python 3 interpreter. Default: python3.
#
# Exit 0 always (shadow). Violations are printed but do not affect the exit
# code. Adopters promoting to gate should change the final exit 0 at the
# shadow-violation path to exit 1.

set -uo pipefail

PROJECT_ROOT="${PROJECT_ROOT:-$(git rev-parse --show-toplevel 2>/dev/null || pwd)}"
APPLICATION_FILE="${APPLICATION_FILE:-${PROJECT_ROOT}/docs/standards-application.md}"
ARTIFACT_DIRS="${ARTIFACT_DIRS:-docs/decisions:docs/adrs:docs/incidents:docs/investigations:docs/product:docs/fmeas:docs/architecture:docs/architecture.md:docs/standards-application.md}"
MAX_FINDINGS="${MAX_FINDINGS:-20}"
PYTHON3="${PYTHON3:-python3}"

if [ ! -f "$APPLICATION_FILE" ]; then
  # No applicability doc; silent pass. Plugin-internal or bootstrap phase.
  exit 0
fi

"${PYTHON3}" - "$PROJECT_ROOT" "$APPLICATION_FILE" "$ARTIFACT_DIRS" "$MAX_FINDINGS" <<'PYEOF'
import os
import re
import sys
from pathlib import Path

project_root = Path(sys.argv[1])
application_file = Path(sys.argv[2])
artifact_dirs_spec = sys.argv[3]
try:
    max_findings = int(sys.argv[4])
except ValueError:
    max_findings = 20

FRONTMATTER_RE = re.compile(r"^---\s*\n(.*?)\n---\s*\n", re.DOTALL)


def read_owner_name(path: Path) -> str:
    try:
        text = path.read_text(encoding="utf-8")
    except Exception:
        return ""
    m = FRONTMATTER_RE.match(text)
    if not m:
        return ""
    fm = m.group(1)
    owner_block_re = re.compile(
        r"^owner:\s*\n((?:[ \t]+.*\n?)*)",
        re.MULTILINE,
    )
    block = owner_block_re.search(fm)
    if not block:
        return ""
    name_re = re.compile(r'^\s+name:\s*"?([^"\n]+?)"?\s*$', re.MULTILINE)
    name_match = name_re.search(block.group(1))
    if not name_match:
        return ""
    return name_match.group(1).strip()


owner_name = read_owner_name(application_file)
if not owner_name:
    # Owner not declared or blank; silent pass.
    sys.exit(0)


def resolve_candidates(spec: str):
    out = []
    for item in spec.split(":"):
        item = item.strip()
        if not item:
            continue
        path = project_root / item
        if path.is_file():
            out.append(path)
        elif path.is_dir():
            for p in path.rglob("*.md"):
                out.append(p)
    return sorted(set(out))


candidates = resolve_candidates(artifact_dirs_spec)
if not candidates:
    sys.exit(0)


findings = []
total = 0
for path in candidates:
    try:
        text = path.read_text(encoding="utf-8")
    except Exception:
        continue
    fm_match = FRONTMATTER_RE.match(text)
    body_offset = fm_match.end() if fm_match else 0
    body = text[body_offset:]
    if owner_name not in body:
        continue
    header_lines = text[:body_offset].count("\n") if fm_match else 0
    for idx, line in enumerate(body.splitlines(), start=1):
        if owner_name in line:
            real_line = header_lines + idx
            try:
                rel = path.relative_to(project_root)
            except ValueError:
                rel = path
            findings.append(f"{rel}:{real_line}: {line.strip()[:120]}")
            total += 1

if total == 0:
    print("PASS: lint-named-owner-integrity: no positional violations (status: shadow; silent pass)")
    sys.exit(0)

print(f"SHADOW: {total} occurrences of owner name '{owner_name}' in normative artifact bodies:")
for i, f in enumerate(findings):
    if max_findings > 0 and i >= max_findings:
        print(f"  ... output truncated at {max_findings} findings. Re-run with MAX_FINDINGS=0 for the full log.")
        break
    print(f"  {f}")
print()
print("Shadow status: findings recorded for auditability; does not block the build.")
print("ESE writing rule: no person names in normative content. The named owner field in")
print("standards-application.md is the only place for an operator name. Refactor each")
print("occurrence above or mark the artifact explicitly as historical.")
PYEOF
