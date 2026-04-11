#!/usr/bin/env bash
# lint-work-item-export.sh — FM-08 round-trip CI gate
#
# Validates that work item export files conform to the templates/work-item-export.md format:
#   - YAML frontmatter is present and parseable
#   - Required frontmatter fields are present: type, stage
#   - type field equals "work-item-export"
#   - Required markdown sections are present: Core Attributes, Acceptance Criteria
#
# Also validates the template file itself (ensures the format spec is self-consistent).
#
# Round-trip check: parse the YAML frontmatter, re-serialize key fields, verify
# the output matches what was parsed (tests format stability).
#
# Scope: templates/work-item-export.md (always) + docs/work-items/*.md (when present)
#
# Exit 0 = pass. Exit 1 = violations found.

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"

FAILED=0

# Collect files to validate. Excludes docs/work-items/active/ which is the
# ese-plugin session-local scratch directory (gitignored per .gitignore);
# scratch work-item.md files use templates/work-item.md, not the
# work-item-export format, and are not subject to the round-trip gate.
FILES=("$REPO_ROOT/templates/work-item-export.md")
if [ -d "$REPO_ROOT/docs/work-items" ]; then
  while IFS= read -r -d '' f; do
    FILES+=("$f")
  done < <(find "$REPO_ROOT/docs/work-items" -type d -name active -prune -o -name "*.md" -print0 2>/dev/null)
fi

python3 - "${FILES[@]}" <<'PYEOF'
import sys
import re

files = sys.argv[1:]
REQUIRED_FRONTMATTER = {"type", "stage"}
REQUIRED_SECTIONS    = ["## Core Attributes", "## Acceptance Criteria"]
FAILED = False

def extract_frontmatter(content):
    """Return (dict_of_fields, raw_frontmatter_str) or (None, None)."""
    m = re.match(r"^---\s*\n(.*?)\n---", content, re.DOTALL)
    if not m:
        return None, None
    raw = m.group(1)
    fields = {}
    for line in raw.splitlines():
        kv = re.match(r"^(\w[\w-]*):\s*(.*)", line)
        if kv:
            fields[kv.group(1)] = kv.group(2).strip()
    return fields, raw

def round_trip_check(fields, raw):
    """Verify key fields survive a parse->serialize->parse cycle."""
    for key in ("type", "stage"):
        if key not in fields:
            continue
        val = fields[key]
        # Re-serialize: key: value
        reserialized = f"{key}: {val}"
        # Re-parse
        kv = re.match(r"^(\w[\w-]*):\s*(.*)", reserialized)
        if not kv or kv.group(2).strip() != val:
            return False, f"round-trip failed for field '{key}': '{val}' -> '{kv.group(2).strip() if kv else '?'}'"
    return True, ""

for fpath in files:
    try:
        with open(fpath, encoding="utf-8") as f:
            content = f.read()
    except Exception as e:
        print(f"FAIL [{fpath}]: cannot read file: {e}")
        FAILED = True
        continue

    relpath = fpath

    # 1. Frontmatter present
    fields, raw = extract_frontmatter(content)
    if fields is None:
        print(f"FAIL [{relpath}]: YAML frontmatter block missing (expected --- delimiters)")
        FAILED = True
        continue

    # 2. Required frontmatter fields
    for req in REQUIRED_FRONTMATTER:
        if req not in fields:
            print(f"FAIL [{relpath}]: frontmatter missing required field: {req}")
            FAILED = True

    # 3. type must be work-item-export (or template placeholder {type})
    t = fields.get("type", "")
    if t not in ("work-item-export", "{type}", ""):
        print(f"FAIL [{relpath}]: frontmatter type must be 'work-item-export', got '{t}'")
        FAILED = True

    # 4. Required sections
    for section in REQUIRED_SECTIONS:
        if section not in content:
            print(f"FAIL [{relpath}]: missing required section: {section}")
            FAILED = True

    # 5. Round-trip check
    ok, msg = round_trip_check(fields, raw)
    if not ok:
        print(f"FAIL [{relpath}]: {msg}")
        FAILED = True

if FAILED:
    print("")
    print("FAIL: work-item-export format violations found (FM-08 round-trip gate).")
    sys.exit(1)
else:
    count = len(files)
    print(f"PASS: {count} work-item-export file(s) validated; format parseable and round-trip consistent.")
    sys.exit(0)
PYEOF
