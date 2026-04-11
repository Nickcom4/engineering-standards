#!/usr/bin/env bash
# Template-compliance linter (adopter starter)
#
# Verifies that every instance file declared in the project's template
# mapping config contains every non-optional ## section from its template.
# Instances may document intentional omissions with an inline
# <!-- omit-section: Name --> comment, or exempt the whole file from the
# check with <!-- template-compliance: historical-exempt --> (followed by
# a one-line rationale comment).
#
# This is the adopter-facing starter version of lint-template-compliance
# from the engineering-standards (ESE) repository. Adopters copy it once
# into their own scripts/ directory at adoption time and maintain the
# copy. The linter is parameterized via environment variables so it works
# against any repo layout:
#
#   PROJECT_ROOT          Your repo root. Default: git rev-parse or pwd.
#   ESE_ROOT              Where ESE is vendored (e.g. as a submodule).
#                         Default: ${PROJECT_ROOT}/.standards
#   LINTER_MAPPINGS_FILE  Your template-instance mapping config.
#                         Default: ${PROJECT_ROOT}/scripts/template-instance-mappings.txt
#
# The mapping file format is:
#
#   template-path | instance-glob | label
#
# where template-path may use ${ESE_ROOT} or ${PROJECT_ROOT} substitution
# to reference templates from the vendored ESE repo or your own local
# template directory, and instance-glob is a shell glob pattern resolved
# against PROJECT_ROOT (or absolute if prefixed with /).
#
# Example mapping lines:
#
#   ${ESE_ROOT}/templates/adr.md | docs/decisions/ADR-*.md | ADR
#   ${ESE_ROOT}/templates/fmea.md | docs/decisions/DFMEA-*.md | DFMEA
#   ${ESE_ROOT}/templates/fmea.md | docs/decisions/PFMEA-*.md | PFMEA
#   templates/my-custom.md | docs/custom/*.md | my custom type
#
# Exit 0 = all instances compliant. Exit 1 = drift detected.

set -euo pipefail

# -------------------------------------------------------------------------
# Resolve paths from environment with sensible defaults
# -------------------------------------------------------------------------
PROJECT_ROOT="${PROJECT_ROOT:-$(git rev-parse --show-toplevel 2>/dev/null || pwd)}"
ESE_ROOT="${ESE_ROOT:-${PROJECT_ROOT}/.standards}"
LINTER_MAPPINGS_FILE="${LINTER_MAPPINGS_FILE:-${PROJECT_ROOT}/scripts/template-instance-mappings.txt}"

if [ ! -f "$LINTER_MAPPINGS_FILE" ]; then
  echo "FAIL: mappings file not found at $LINTER_MAPPINGS_FILE"
  echo ""
  echo "Fix: copy starters/linters/template-instance-mappings.txt.starter"
  echo "to \$LINTER_MAPPINGS_FILE and edit the entries for your project."
  echo "Override location with the LINTER_MAPPINGS_FILE environment variable."
  exit 1
fi

# -------------------------------------------------------------------------
# Path substitution. Replaces ${ESE_ROOT} and ${PROJECT_ROOT} in a string
# with their resolved values.
# -------------------------------------------------------------------------
substitute_paths() {
  local s="$1"
  s="${s//\$\{ESE_ROOT\}/$ESE_ROOT}"
  s="${s//\$\{PROJECT_ROOT\}/$PROJECT_ROOT}"
  echo "$s"
}

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
      if (line ~ /^## Table of Contents[[:space:]]*$/) next
      if (line ~ /<!--[[:space:]]*optional[[:space:]]*-->/) next
      sub(/^## /, "", line)
      sub(/[[:space:]]*<!--.*-->[[:space:]]*$/, "", line)
      sub(/[[:space:]]+$/, "", line)
      print line
    }
  ' "$template"
}

# -------------------------------------------------------------------------
# Extract actual ## section headings from an instance file.
# Parallel to extract_required_sections but keeps all headings regardless
# of the optional marker.
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
EXEMPTED=0
VIOLATIONS=()

while IFS= read -r raw_line; do
  # Strip leading/trailing whitespace
  line="${raw_line#"${raw_line%%[![:space:]]*}"}"
  line="${line%"${line##*[![:space:]]}"}"
  # Skip comments and blanks
  [ -z "$line" ] && continue
  [[ "$line" == \#* ]] && continue

  # Split on ' | '
  template_ref="${line%% | *}"
  rest="${line#* | }"
  glob_ref="${rest%% | *}"
  label="${rest#* | }"

  # Trim fields
  template_ref="${template_ref%"${template_ref##*[![:space:]]}"}"
  glob_ref="${glob_ref#"${glob_ref%%[![:space:]]*}"}"
  glob_ref="${glob_ref%"${glob_ref##*[![:space:]]}"}"
  label="${label#"${label%%[![:space:]]*}"}"
  label="${label%"${label##*[![:space:]]}"}"

  # Substitute path variables and resolve to absolute
  template_path=$(substitute_paths "$template_ref")
  if [[ "$template_path" != /* ]]; then
    template_path="$PROJECT_ROOT/$template_path"
  fi

  glob_resolved=$(substitute_paths "$glob_ref")
  if [[ "$glob_resolved" != /* ]]; then
    glob_resolved="$PROJECT_ROOT/$glob_resolved"
  fi

  if [ ! -f "$template_path" ]; then
    VIOLATIONS+=("mapping error: template $template_ref not found (resolved to $template_path)")
    continue
  fi

  TOTAL_MAPPINGS=$((TOTAL_MAPPINGS + 1))

  # Extract required sections
  required_sections=()
  while IFS= read -r section; do
    [ -n "$section" ] && required_sections+=("$section")
  done < <(extract_required_sections "$template_path")

  # Expand the glob
  instance_files=()
  shopt -s nullglob 2>/dev/null || true
  for f in $glob_resolved; do
    [ -f "$f" ] && instance_files+=("$f")
  done
  shopt -u nullglob 2>/dev/null || true

  # Exclude the template file itself. Guard array expansion for
  # bash 3.2 + set -u compatibility (empty arrays would otherwise
  # trip "unbound variable" under strict mode).
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
    instance_rel="${instance#$PROJECT_ROOT/}"

    # Historical-exempt opt-out
    if grep -q "<!-- template-compliance: historical-exempt -->" "$instance"; then
      EXEMPTED=$((EXEMPTED + 1))
      continue
    fi

    instance_sections_str=$(extract_instance_sections "$instance")

    for section in "${required_sections[@]}"; do
      if printf '%s\n' "$instance_sections_str" | grep -qFx "$section"; then
        continue
      fi
      if grep -qF "<!-- omit-section: $section -->" "$instance"; then
        continue
      fi
      VIOLATIONS+=("$instance_rel: missing required section '## $section' (from $template_ref)")
    done
  done

done < "$LINTER_MAPPINGS_FILE"

if [ ${#VIOLATIONS[@]} -gt 0 ]; then
  echo "FAIL: Template-compliance drift detected:"
  echo ""
  for v in "${VIOLATIONS[@]}"; do
    echo "  $v"
  done
  echo ""
  echo "Summary: $TOTAL_MAPPINGS mappings, $TOTAL_INSTANCES instances scanned, $EXEMPTED historical-exempt, ${#VIOLATIONS[@]} violations."
  echo ""
  echo "Fix: add the missing section to the instance, or document an"
  echo "intentional omission with <!-- omit-section: Name --> inline."
  echo "If the template section is genuinely optional across all adopters,"
  echo "propose an upstream change to mark it <!-- optional --> in the"
  echo "ESE template. If the whole instance predates template evolution"
  echo "and is frozen historical content, mark it exempt with"
  echo "<!-- template-compliance: historical-exempt --> and a rationale."
  exit 1
fi

if [ "$EXEMPTED" -gt 0 ]; then
  echo "PASS: $TOTAL_INSTANCES instances across $TOTAL_MAPPINGS mappings all satisfy template-required sections ($EXEMPTED historical-exempt)."
else
  echo "PASS: $TOTAL_INSTANCES instances across $TOTAL_MAPPINGS mappings all satisfy template-required sections."
fi
