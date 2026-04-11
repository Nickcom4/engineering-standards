#!/usr/bin/env bash
# lint-changelog-entries.sh: validates CHANGELOG.md structure and entries.
#
# Check 1 (advisory): warns on short [Unreleased] bullet entries that may
# lack rationale. Advisory only; does not affect exit code.
#
# Check 2 (hard gate): each ## [version] block (including [Unreleased])
# must have at most one of each Keep-a-Changelog subsection header:
# ### Added, Changed, Deprecated, Removed, Fixed, Security. Duplicate
# subsection headers within a single release block indicate that
# multiple commits accumulated without consolidating their subsection
# entries, which produces a confusing CHANGELOG that's hard to read.
#
# Exit 0 = pass. Exit 1 = violations found.

set -euo pipefail

# Check 1: short entries in [Unreleased] (advisory)
UNRELEASED=$(sed -n '/^## \[Unreleased\]/,/^## \[/p' CHANGELOG.md | { grep "^- " || true; } | head -20)

SHORT=0
if [ -n "$UNRELEASED" ]; then
    while IFS= read -r line; do
        words=$(echo "$line" | sed 's/^- //' | wc -w | tr -d ' ')
        if [ "$words" -lt 4 ]; then
            echo "WARN: Short changelog entry (${words} words): $line"
            SHORT=$((SHORT + 1))
        fi
    done <<< "$UNRELEASED"
    if [ "$SHORT" -gt 0 ]; then
        echo "WARN: $SHORT changelog entries may lack rationale (advisory)."
    fi
fi

# Check 2: subsection uniqueness per release block (hard gate)
python3 - <<'PYEOF'
import re, sys

with open('CHANGELOG.md') as f:
    content = f.read()

ALLOWED_SUBSECTIONS = {'Added', 'Changed', 'Deprecated', 'Removed', 'Fixed', 'Security'}

# Find all release blocks: ## [Unreleased] or ## [X.Y.Z] ... up to next ## [
release_headings = [(m.start(), m.group(0)) for m in re.finditer(r'^## \[[^\]]+\][^\n]*', content, re.MULTILINE)]

violations = []

for i, (start, heading) in enumerate(release_headings):
    end = release_headings[i + 1][0] if i + 1 < len(release_headings) else len(content)
    block = content[start:end]

    # Count subsection headers
    subs_found = re.findall(r'^### (\w+)', block, re.MULTILINE)
    counts = {}
    for s in subs_found:
        if s in ALLOWED_SUBSECTIONS:
            counts[s] = counts.get(s, 0) + 1

    for sub, n in counts.items():
        if n > 1:
            violations.append(f"{heading}: '### {sub}' appears {n} times (should appear at most once per release)")

if violations:
    print("FAIL: CHANGELOG.md subsection uniqueness violations:")
    for v in violations:
        print(f"  {v}")
    print()
    print("Fix: consolidate duplicate subsection headers within each release block.")
    print("Each release should have at most one ### Added, one ### Changed, etc.")
    sys.exit(1)

print("PASS: Changelog entries checked; subsection uniqueness verified.")
PYEOF
