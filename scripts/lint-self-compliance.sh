#!/usr/bin/env bash
# Self-compliance linter (REQ-2.1-51)
# Verifies this repo complies with its own standards.
# Every check here is something the adoption compliance checklist
# requires of downstream projects.
#
# Exit 0 = pass. Exit 1 = violations found.

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
VIOLATIONS=()

# 1. standards-application.md has all sections from starter
STARTER_SECTIONS=$(grep "^## " "$REPO_ROOT/starters/standards-application.md" | sort)
INSTANCE_SECTIONS=$(grep "^## " "$REPO_ROOT/docs/standards-application.md" | sort)
while IFS= read -r section; do
  if ! echo "$INSTANCE_SECTIONS" | grep -qF "$section"; then
    VIOLATIONS+=("docs/standards-application.md missing starter section: $section")
  fi
done <<< "$STARTER_SECTIONS"

# 2. Required files exist
for f in README.md CHANGELOG.md .gitignore docs/setup.md docs/standards-application.md; do
  [ -f "$REPO_ROOT/$f" ] || VIOLATIONS+=("Missing required file: $f")
done

# 3. docs/decisions/ has at least one ADR
ADR_COUNT=$(find "$REPO_ROOT/docs/decisions" -name 'ADR-*.md' 2>/dev/null | wc -l | tr -d ' ')
[ "$ADR_COUNT" -gt 0 ] || VIOLATIONS+=("No ADRs in docs/decisions/")

# 4. Incident registries exist
[ -f "$REPO_ROOT/docs/incidents/lessons-learned.md" ] || VIOLATIONS+=("Missing: docs/incidents/lessons-learned.md")
[ -f "$REPO_ROOT/docs/incidents/anti-patterns.md" ] || VIOLATIONS+=("Missing: docs/incidents/anti-patterns.md")

# 5. CI pipeline exists
[ -f "$REPO_ROOT/.github/workflows/ci.yml" ] || VIOLATIONS+=("Missing: .github/workflows/ci.yml")

# 6. CHANGELOG has entries (not just [Unreleased])
CHANGELOG_VERSIONS=$(grep -c "^## \[" "$REPO_ROOT/CHANGELOG.md" 2>/dev/null || echo 0)
[ "$CHANGELOG_VERSIONS" -gt 1 ] || VIOLATIONS+=("CHANGELOG.md has no version entries beyond [Unreleased]")

# 7. standards-application.md has non-placeholder content
PLACEHOLDER_COUNT=$(grep -c '{' "$REPO_ROOT/docs/standards-application.md" || true)
if [ "$PLACEHOLDER_COUNT" -gt 5 ] 2>/dev/null; then
  VIOLATIONS+=("docs/standards-application.md has $PLACEHOLDER_COUNT placeholder markers")
fi

# 8. ADR frontmatter compliance
for adr in "$REPO_ROOT"/docs/decisions/ADR-*.md "$REPO_ROOT"/docs/decisions/DFMEA-*.md "$REPO_ROOT"/docs/decisions/PFMEA-*.md; do
  [ -f "$adr" ] || continue
  basename_adr=$(basename "$adr")
  for field in "type:" "id:" "title:" "status:" "date:"; do
    if ! grep -q "^$field" "$adr"; then
      VIOLATIONS+=("$basename_adr: missing required frontmatter field '$field'")
    fi
  done
done

# 8b. ADR 'implements' field (BLOCKING: backlog resolved 2026-03-26)
# All 22 ADRs now have implements field; any new ADR without it is a violation.
for adr in "$REPO_ROOT"/docs/decisions/ADR-*.md; do
  [ -f "$adr" ] || continue
  if ! grep -q "^implements:" "$adr"; then
    VIOLATIONS+=("$(basename "$adr"): missing 'implements' frontmatter field (REQ-4.2-01 traceability)")
  fi
done

# 9. No placeholder content in docs/standards-application.md first principles
PRINCIPLE_COUNT=$(grep -c '^\*\*' "$REPO_ROOT/docs/standards-application.md" 2>/dev/null || echo 0)
if [ "$PRINCIPLE_COUNT" -lt 8 ] 2>/dev/null; then
  VIOLATIONS+=("docs/standards-application.md: only $PRINCIPLE_COUNT first principles answered (need 8)")
fi

# 10. docs/archive/ directory exists
[ -d "$REPO_ROOT/docs/archive" ] || VIOLATIONS+=("Missing required directory: docs/archive/")

if [ ${#VIOLATIONS[@]} -gt 0 ]; then
  echo "FAIL: Self-compliance violations (REQ-2.1-51):"
  for v in "${VIOLATIONS[@]}"; do
    echo "  $v"
  done
  exit 1
else
  echo "PASS: Repository complies with its own standards."
  exit 0
fi
