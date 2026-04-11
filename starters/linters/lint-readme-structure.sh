#!/usr/bin/env bash
# README structure linter (adopter starter)
#
# Bidirectional check:
#   Forward (README -> disk): every file and directory listed in the
#     README's Structure section actually exists on disk.
#   Reverse (disk -> README): every top-level file and directory in
#     the repo root is either listed in README Structure OR in the
#     exclusion list (env var or defaults).
#
# Parameterization:
#
#   PROJECT_ROOT            Your repo root. Default: git rev-parse or pwd.
#   README_FILE             Default: ${PROJECT_ROOT}/README.md
#   README_EXCLUDE          Space-separated list of top-level files/dirs
#                           to exclude from the reverse check. Default:
#                           README.md .git .gitignore .github .DS_Store
#                           (plus common generated artifacts).
#
# Exit 0 = pass. Exit 1 = violations.

set -euo pipefail

PROJECT_ROOT="${PROJECT_ROOT:-$(git rev-parse --show-toplevel 2>/dev/null || pwd)}"
README_FILE="${README_FILE:-${PROJECT_ROOT}/README.md}"

if [ ! -f "$README_FILE" ]; then
  echo "SKIP: README not found at $README_FILE"
  exit 0
fi

EXCLUDE_DEFAULT="README.md .git .gitignore .github .DS_Store node_modules .venv .env dist build target"
READMEEXCLUDE="${README_EXCLUDE:-$EXCLUDE_DEFAULT}"

python3 - "$PROJECT_ROOT" "$README_FILE" "$READMEEXCLUDE" <<'PYEOF'
import sys
import os
import re

repo_root = sys.argv[1]
readme_path = sys.argv[2]
exclude_list = set(sys.argv[3].split())

with open(readme_path, encoding='utf-8') as f:
    content = f.read()

structure_match = re.search(
    r'^## Structure\s*\n.*?```\n(.*?)```',
    content,
    re.MULTILINE | re.DOTALL,
)

if not structure_match:
    print('SKIP: No Structure code block found in README')
    sys.exit(0)

block = structure_match.group(1)
forward_violations = []
listed_top_level = set()
dir_stack = []

for line in block.splitlines():
    stripped = line.strip()
    if not stripped:
        continue
    leading = len(line) - len(line.lstrip())
    indent = leading // 2
    parts = re.split(r'\s{2,}', stripped, maxsplit=1)
    path_part = parts[0].strip()
    if not path_part:
        continue

    while dir_stack and dir_stack[-1][0] >= indent:
        dir_stack.pop()
    if indent == 0:
        listed_top_level.add(path_part.rstrip('/'))
    parent = os.path.join(repo_root, *[d[1] for d in dir_stack])
    full_path = os.path.join(parent, path_part.rstrip('/'))
    is_dir = path_part.endswith('/')
    if is_dir:
        if not os.path.isdir(full_path):
            forward_violations.append(f"Directory listed but not found: {path_part}")
        dir_stack.append((indent, path_part.rstrip('/')))
    else:
        if not os.path.isfile(full_path):
            forward_violations.append(f"File listed but not found: {path_part}")

reverse_violations = []
for name in sorted(os.listdir(repo_root)):
    if name in exclude_list:
        continue
    if name in listed_top_level:
        continue
    full = os.path.join(repo_root, name)
    kind = 'dir' if os.path.isdir(full) else 'file'
    reverse_violations.append(f"Top-level {kind} '{name}' not in README Structure and not excluded")

if forward_violations or reverse_violations:
    if forward_violations:
        print('FAIL: README Structure references missing paths (forward):')
        for v in forward_violations:
            print(f"  {v}")
        print()
    if reverse_violations:
        print('FAIL: README Structure missing entries for on-disk items (reverse):')
        for v in reverse_violations:
            print(f"  {v}")
        print()
        print('Fix: add the entry to README Structure or add the name to')
        print('README_EXCLUDE (environment variable, space-separated).')
    sys.exit(1)

print('PASS: README Structure matches disk in both directions.')
PYEOF
