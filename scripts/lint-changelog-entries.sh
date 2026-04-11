#!/usr/bin/env bash
set -euo pipefail

# Extract bullet entries from the [Unreleased] section. An empty [Unreleased]
# section is the normal post-release state; grep returning no matches (exit 1)
# must not abort the linter under pipefail, so the grep is guarded with || true.
UNRELEASED=$(sed -n '/^## \[Unreleased\]/,/^## \[/p' CHANGELOG.md | { grep "^- " || true; } | head -20)

if [ -z "$UNRELEASED" ]; then
  echo "PASS: No unreleased entries to check."
  exit 0
fi

SHORT=0
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

echo "PASS: Changelog entries checked."
