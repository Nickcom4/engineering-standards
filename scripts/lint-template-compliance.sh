#!/usr/bin/env bash
# Generic template-compliance linter
#
# Reads scripts/template-instance-mappings.txt and verifies that every
# instance file matching a mapping glob contains every non-optional
# ## section declared in its template. Instances may document an
# intentional omission with an inline <!-- omit-section: Name -->
# comment (existing convention from lint-template-drift.sh).
#
# Template sections are considered required by default. A section is
# optional if its heading line in the template ends with the marker:
#   <!-- optional -->
# Example:
#   ## Implementation Checklist <!-- optional -->
#
# "Table of Contents" is structural, not a content section, and is
# always skipped regardless of the optional marker.
#
# This linter subsumes the section-checking role of the former
# lint-fmea-template, lint-arch-doc, lint-standards-application, and
# lint-template-drift scripts (all four retired in v2.5.0 since their
# section-compliance logic is fully covered here via the mapping file).
# lint-session-artifacts remains in place because it accepts historical
# heading variants that this linter does not.
#
# Exit 0 = all instances compliant. Exit 1 = drift detected.

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
MAPPINGS_FILE="$REPO_ROOT/scripts/template-instance-mappings.txt"

if [ ! -f "$MAPPINGS_FILE" ]; then
  echo "FAIL: $MAPPINGS_FILE not found."
  exit 1
fi

# -------------------------------------------------------------------------
# Extract required sections from a template file.
# Reads ## headings; skips "Table of Contents" and any heading whose
# line ends with <!-- optional -->. Strips any trailing HTML comment.
# Emits one section name per line.
# -------------------------------------------------------------------------
extract_required_sections() {
  local template="$1"
  awk '
    /^## / {
      line = $0
      # Skip structural Table of Contents
      if (line ~ /^## Table of Contents[[:space:]]*$/) next
      # Skip optional sections
      if (line ~ /<!--[[:space:]]*optional[[:space:]]*-->/) next
      # Strip leading "## "
      sub(/^## /, "", line)
      # Strip any trailing HTML comment
      sub(/[[:space:]]*<!--.*-->[[:space:]]*$/, "", line)
      # Strip trailing whitespace
      sub(/[[:space:]]+$/, "", line)
      print line
    }
  ' "$template"
}

# -------------------------------------------------------------------------
# Extract actual ## section headings from an instance file.
# Parallel to extract_required_sections but keeps Table of Contents
# and all headings regardless of optional marker (instances may have
# sections the template does not; we only check required-from-template
# membership).
# -------------------------------------------------------------------------
extract_instance_sections() {
  local instance="$1"
  awk '
    /^## / {
      line = $0
      sub(/^## /, "", line)
      sub(/[[:space:]]*<!--.*-->[[:space:]]*$/, "", line)
      sub(/[[:space:]]+$/, "", line)
      print line
    }
  ' "$instance"
}

# -------------------------------------------------------------------------
# Parse mappings and check each instance
# -------------------------------------------------------------------------
TOTAL_INSTANCES=0
TOTAL_MAPPINGS=0
VIOLATIONS=()

while IFS= read -r raw_line; do
  # Strip leading/trailing whitespace
  line="${raw_line#"${raw_line%%[![:space:]]*}"}"
  line="${line%"${line##*[![:space:]]}"}"
  # Skip comments and blanks
  [ -z "$line" ] && continue
  [[ "$line" == \#* ]] && continue

  # Split on ' | '
  template_rel="${line%% | *}"
  rest="${line#* | }"
  glob="${rest%% | *}"
  label="${rest#* | }"

  # Trim each field
  template_rel="${template_rel%"${template_rel##*[![:space:]]}"}"
  glob="${glob#"${glob%%[![:space:]]*}"}"
  glob="${glob%"${glob##*[![:space:]]}"}"
  label="${label#"${label%%[![:space:]]*}"}"
  label="${label%"${label##*[![:space:]]}"}"

  template_path="$REPO_ROOT/$template_rel"
  if [ ! -f "$template_path" ]; then
    VIOLATIONS+=("mapping error: template $template_rel not found")
    continue
  fi

  TOTAL_MAPPINGS=$((TOTAL_MAPPINGS + 1))

  # Extract required sections for this template
  required_sections=()
  while IFS= read -r section; do
    [ -n "$section" ] && required_sections+=("$section")
  done < <(extract_required_sections "$template_path")

  # Expand the glob to actual instance files
  instance_files=()
  # Use shell globbing; nullglob emulation with a guard
  shopt -s nullglob 2>/dev/null || true
  for f in $REPO_ROOT/$glob; do
    [ -f "$f" ] && instance_files+=("$f")
  done
  shopt -u nullglob 2>/dev/null || true

  # Skip the template file itself if it matches its own glob.
  # Guard array expansion for bash 3.2 + set -u compatibility.
  filtered=()
  if [ ${#instance_files[@]} -gt 0 ]; then
    for inst in "${instance_files[@]}"; do
      if [ "$inst" != "$template_path" ]; then
        filtered+=("$inst")
      fi
    done
  fi
  instance_files=()
  if [ ${#filtered[@]} -gt 0 ]; then
    for f in "${filtered[@]}"; do
      instance_files+=("$f")
    done
  fi

  [ ${#instance_files[@]} -eq 0 ] && continue

  for instance in "${instance_files[@]}"; do
    TOTAL_INSTANCES=$((TOTAL_INSTANCES + 1))
    instance_rel="${instance#$REPO_ROOT/}"

    # Historical-exempt opt-out. An instance may mark itself as a frozen
    # historical artifact that should not be checked against template
    # evolution. Use sparingly; the marker must include a one-line
    # rationale on the following comment line.
    #
    # Example at top of file:
    #   <!-- template-compliance: historical-exempt -->
    #   <!-- Reason: product doc from v1.x era, written before
    #        templates/prd.md was expanded; decisions captured in
    #        ADR-YYYY-MM-DD; do not retroactively restructure. -->
    if grep -q "<!-- template-compliance: historical-exempt -->" "$instance"; then
      continue
    fi

    # Extract this instance's actual section headings once
    instance_sections_str=$(extract_instance_sections "$instance")

    for section in "${required_sections[@]}"; do
      # Check for the section in the instance's headings (exact line match after normalization)
      if printf '%s\n' "$instance_sections_str" | grep -qFx "$section"; then
        continue
      fi
      # Check for documented omission
      if grep -qF "<!-- omit-section: $section -->" "$instance"; then
        continue
      fi
      VIOLATIONS+=("$instance_rel: missing required section '## $section' (from $template_rel)")
    done
  done

done < "$MAPPINGS_FILE"

if [ ${#VIOLATIONS[@]} -gt 0 ]; then
  echo "FAIL: Template-compliance drift detected:"
  echo ""
  for v in "${VIOLATIONS[@]}"; do
    echo "  $v"
  done
  echo ""
  echo "Summary: $TOTAL_MAPPINGS mappings checked, $TOTAL_INSTANCES instances scanned, ${#VIOLATIONS[@]} violations."
  echo ""
  echo "Fix: add the missing section to the instance, or document the"
  echo "intentional omission with <!-- omit-section: Name --> inline in"
  echo "the instance file. If the template section is genuinely optional,"
  echo "mark it in the template with <!-- optional --> on the heading line."
  exit 1
fi

echo "PASS: $TOTAL_INSTANCES instances across $TOTAL_MAPPINGS mappings all satisfy template-required sections."
