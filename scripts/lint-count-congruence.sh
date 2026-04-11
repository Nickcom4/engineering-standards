#!/usr/bin/env bash
# Count congruence linter
# Asserts that every claim of the form "N <thing>" in living documents
# matches the authoritative generator for that thing. Complements
# lint-stale-counts.sh (which only checks REQ-ID counts) by also checking
# gate counts, CI check counts, and script counts.
#
# Sources of truth:
#   Gates:       gate_count field in enforcement-spec.yml
#   CI checks:   count of "# Check N" markers in .github/workflows/ci.yml
#   Scripts:     count of *.sh files in scripts/
#
# Living documents scanned: CLAUDE.md, README.md, docs/standards-application.md,
# docs/architecture/ese-machine-readable-enforcement-system.md
#
# Historical snapshots (work-sessions, work-items, compliance-review-YYYY-MM-DD,
# CHANGELOG.md historical entries) are intentionally excluded.
#
# Exit 0 = pass. Exit 1 = drift found.

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"

# -------------------------------------------------------------------------
# Authoritative sources
# -------------------------------------------------------------------------
ACTUAL_GATES=""
if [ -f "$REPO_ROOT/enforcement-spec.yml" ]; then
  ACTUAL_GATES=$(awk -F': ' '/^gate_count:/ {gsub(/"/,"",$2); gsub(/ /,"",$2); print $2; exit}' "$REPO_ROOT/enforcement-spec.yml")
fi

ACTUAL_CHECKS=""
if [ -f "$REPO_ROOT/.github/workflows/ci.yml" ]; then
  ACTUAL_CHECKS=$(grep -c "^      # Check [0-9]" "$REPO_ROOT/.github/workflows/ci.yml" || echo 0)
fi

ACTUAL_SCRIPTS=$(ls "$REPO_ROOT"/scripts/*.sh 2>/dev/null | wc -l | tr -d ' ')

if [ -z "$ACTUAL_GATES" ] || [ -z "$ACTUAL_CHECKS" ] || [ -z "$ACTUAL_SCRIPTS" ]; then
  echo "SKIP: missing authoritative source (enforcement-spec.yml, ci.yml, or scripts/)."
  exit 0
fi

# -------------------------------------------------------------------------
# Files to scan
# -------------------------------------------------------------------------
FILES=(
  "$REPO_ROOT/CLAUDE.md"
  "$REPO_ROOT/README.md"
  "$REPO_ROOT/docs/standards-application.md"
  "$REPO_ROOT/docs/architecture/ese-machine-readable-enforcement-system.md"
)

VIOLATIONS=()

for file in "${FILES[@]}"; do
  [ -f "$file" ] || continue
  relpath="${file#$REPO_ROOT/}"
  lineno=0
  in_fence=0
  while IFS= read -r line; do
    lineno=$((lineno + 1))

    # Track code fences
    if [[ "$line" =~ ^\`\`\` ]]; then
      in_fence=$((1 - in_fence))
      continue
    fi
    [ "$in_fence" -eq 1 ] && continue

    # Skip tables separator lines
    [[ "$line" =~ ^\|[-\ ]+\|$ ]] && continue

    # Historical context skip: lines that clearly talk about past state
    if [[ "$line" =~ was\ |from\ |previously|grew\ from|iteration|prior\ |earlier ]]; then
      continue
    fi

    # --- Gate count ---
    # Match patterns like "N gates", "N machine-readable gates", "N declared gates"
    if [[ "$line" =~ ([0-9]+)\ (machine-readable\ |declared\ )?gates? ]]; then
      num="${BASH_REMATCH[1]}"
      # Only flag if number is in a realistic gate-count range (100-9999)
      if [ "$num" -ge 100 ] && [ "$num" -le 9999 ] && [ "$num" != "$ACTUAL_GATES" ]; then
        VIOLATIONS+=("$relpath:$lineno: gates claim $num but enforcement-spec.yml gate_count is $ACTUAL_GATES")
      fi
    fi

    # --- CI check count ---
    # Match patterns like "N CI checks", "N checks"
    if [[ "$line" =~ ([0-9]+)\ (CI\ )?checks? ]]; then
      num="${BASH_REMATCH[1]}"
      # Only flag if in realistic range (10-999); skips small numbers that
      # appear in ordinary prose like "2 checks were added".
      if [ "$num" -ge 10 ] && [ "$num" -le 999 ] && [ "$num" != "$ACTUAL_CHECKS" ]; then
        VIOLATIONS+=("$relpath:$lineno: checks claim $num but ci.yml has $ACTUAL_CHECKS # Check markers")
      fi
    fi

    # --- Script count ---
    # Match patterns like "N CI scripts", "N bash scripts", "N scripts in scripts/"
    if [[ "$line" =~ ([0-9]+)\ (CI\ |bash\ )?scripts? ]]; then
      num="${BASH_REMATCH[1]}"
      if [ "$num" -ge 10 ] && [ "$num" -le 999 ] && [ "$num" != "$ACTUAL_SCRIPTS" ]; then
        VIOLATIONS+=("$relpath:$lineno: scripts claim $num but ls scripts/*.sh is $ACTUAL_SCRIPTS")
      fi
    fi
  done < "$file"
done

if [ ${#VIOLATIONS[@]} -gt 0 ]; then
  echo "FAIL: Count drift detected in living documents."
  echo ""
  for v in "${VIOLATIONS[@]}"; do
    echo "  $v"
  done
  echo ""
  echo "Authoritative sources:"
  echo "  Gates:   $ACTUAL_GATES (enforcement-spec.yml gate_count)"
  echo "  Checks:  $ACTUAL_CHECKS (.github/workflows/ci.yml # Check N markers)"
  echo "  Scripts: $ACTUAL_SCRIPTS (ls scripts/*.sh)"
  echo ""
  echo "Fix: update the stale claim to match the authoritative source,"
  echo "or if the context is historical, rephrase to 'at that time N' or"
  echo "similar so future audits do not re-flag it."
  exit 1
fi

echo "PASS: Gate count ($ACTUAL_GATES), CI check count ($ACTUAL_CHECKS), script count ($ACTUAL_SCRIPTS) congruent across living documents."
