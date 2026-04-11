#!/usr/bin/env bash
# lint-doc-references.sh: enforces discoverability cross-references.
#
# Catches the "added a new feature but forgot to document it in the
# canonical onboarding doc" class of drift that repeatedly surfaces
# during phase-closure audits.
#
# Three independent checks:
#
# Check A: every script in starters/tools/*.sh must be mentioned by
#   filename in starters/tools/README.md (catalog completeness).
#
# Check B: every script in starters/linters/*.sh must be mentioned by
#   filename in starters/linters/README.md (catalog completeness).
#
# Check C: every adopter-facing tool or linter in starters/tools/*.sh
#   or starters/linters/*.sh must be referenced from docs/adoption.md
#   (main adopter onboarding doc). Intentional omissions: add the
#   inline marker '<!-- doc-references: omit -->' to the file's header.
#
# Rules use plain filename match (not path match) so linked and unlinked
# references both count. False-positive escape hatch: the omit marker
# above skips check C for that specific file.
#
# Exit 0 = pass. Exit 1 = violations found.

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"

python3 - "$REPO_ROOT" <<'PYEOF'
import os
import re
import sys
from pathlib import Path

repo_root = Path(sys.argv[1])

violations = []

def has_omit_marker(filepath):
    """Check if file has an adoption-guide omit marker in its first 10 lines."""
    try:
        with open(filepath) as f:
            head = f.read(2000)
        return '<!-- doc-references: omit -->' in head or '# doc-references: omit' in head
    except Exception:
        return False

def referenced_in(haystack_path, needle):
    """Return True if needle (a filename) appears in the haystack file content."""
    try:
        with open(haystack_path) as f:
            content = f.read()
        return needle in content
    except Exception:
        return False

# ----------------------------------------------------------------------
# Check A: starters/tools catalog completeness
# ----------------------------------------------------------------------
tools_dir = repo_root / "starters/tools"
tools_readme = tools_dir / "README.md"
if tools_dir.is_dir() and tools_readme.is_file():
    for f in sorted(tools_dir.glob("*.sh")):
        name = f.name
        if has_omit_marker(f):
            continue
        if not referenced_in(tools_readme, name):
            rel = f.relative_to(repo_root)
            violations.append(
                f"Check A: {rel} not referenced in starters/tools/README.md catalog"
            )

# ----------------------------------------------------------------------
# Check B: starters/linters catalog completeness
# ----------------------------------------------------------------------
linters_dir = repo_root / "starters/linters"
linters_readme = linters_dir / "README.md"
if linters_dir.is_dir() and linters_readme.is_file():
    for f in sorted(linters_dir.glob("*.sh")):
        name = f.name
        if has_omit_marker(f):
            continue
        if not referenced_in(linters_readme, name):
            rel = f.relative_to(repo_root)
            violations.append(
                f"Check B: {rel} not referenced in starters/linters/README.md catalog"
            )

# ----------------------------------------------------------------------
# Check C: adopter-facing DIRECTORIES must be referenced from docs/adoption.md
#
# A script passes if either (a) its specific filename is in adoption.md,
# or (b) its parent directory path (e.g., 'starters/linters/') is in
# adoption.md. The group-reference-by-directory path is sufficient
# discoverability: adopters follow the dir link and see every script in
# the corresponding catalog README.
# ----------------------------------------------------------------------
adoption_md = repo_root / "docs/adoption.md"
if adoption_md.is_file():
    adopter_facing_dirs = [
        repo_root / "starters/tools",
        repo_root / "starters/linters",
    ]
    for d in adopter_facing_dirs:
        if not d.is_dir():
            continue
        # Check if the directory itself is referenced from adoption.md
        rel_dir = str(d.relative_to(repo_root)) + '/'
        dir_referenced = referenced_in(adoption_md, rel_dir)
        for f in sorted(d.glob("*.sh")):
            name = f.name
            if has_omit_marker(f):
                continue
            if dir_referenced or referenced_in(adoption_md, name):
                continue
            rel = f.relative_to(repo_root)
            violations.append(
                f"Check C: {rel} not referenced from docs/adoption.md "
                f"(neither filename nor parent dir '{rel_dir}' appears in the adoption guide; "
                f"add a reference OR mark with '<!-- doc-references: omit -->' if intentionally internal)"
            )

if violations:
    print("FAIL: doc-references violations:")
    for v in violations:
        print(f"  {v}")
    print()
    print("Fix:")
    print("  - Check A/B: add the missing filename to the catalog README.")
    print("  - Check C: add a reference in docs/adoption.md or add the omit marker.")
    sys.exit(1)

tools_count = len(list((repo_root / "starters/tools").glob("*.sh"))) if (repo_root / "starters/tools").is_dir() else 0
linters_count = len(list((repo_root / "starters/linters").glob("*.sh"))) if (repo_root / "starters/linters").is_dir() else 0
print(f"PASS: doc-references verified ({tools_count} tools, {linters_count} linters all cataloged and referenced from adoption.md).")
PYEOF
