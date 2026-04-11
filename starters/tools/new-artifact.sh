#!/usr/bin/env bash
# new-artifact.sh: scaffold a new instance of an ESE template (adopter starter)
#
# Reads a project-local template-instance-mappings.txt to find the
# template and output directory for a given artifact type, copies the
# template, substitutes common placeholders (date, title, id, owner,
# type), and writes the result to a path derived from the instance glob.
#
# This is the adopter-facing version of scripts/new-artifact.sh from
# the engineering-standards (ESE) repo. Copy it into your own scripts/
# directory at adoption and maintain the copy.
#
# Usage:
#
#   scripts/new-artifact.sh TYPE "Title" [--output PATH] [--no-open]
#   scripts/new-artifact.sh --list
#   scripts/new-artifact.sh --help
#
# Parameterization:
#
#   PROJECT_ROOT          Your repo root. Default: git rev-parse or pwd.
#   ESE_ROOT              Where ESE is vendored (for ${ESE_ROOT} path
#                         substitution in the mappings file).
#                         Default: ${PROJECT_ROOT}/.standards
#   LINTER_MAPPINGS_FILE  Your template-instance mapping config.
#                         Default: ${PROJECT_ROOT}/scripts/template-instance-mappings.txt
#   EDITOR                Editor to open the new file in (unless --no-open).
#
# Placeholder substitution:
#
#   YYYY-MM-DD                -> today's date
#   {Title}, {title}          -> provided title
#   {number}                  -> date-slug (e.g., 2026-04-11-my-decision)
#   {owner}                   -> git config user.name (or "unknown")
#   {type}                    -> uppercased label (ADR, DFMEA, PFMEA, ...)
#   {Feature or Process Name} -> provided title
#   {team/owner}              -> git config user.name
#   {who was involved}        -> git config user.name
#
# Remaining {...} placeholders in the template are left in place for
# the user to fill in manually. This tool is a scaffold, not an
# artifact author.

set -euo pipefail

PROJECT_ROOT="${PROJECT_ROOT:-$(git rev-parse --show-toplevel 2>/dev/null || pwd)}"
ESE_ROOT="${ESE_ROOT:-${PROJECT_ROOT}/.standards}"
MAPPINGS_FILE="${LINTER_MAPPINGS_FILE:-${PROJECT_ROOT}/scripts/template-instance-mappings.txt}"

usage() {
  cat <<'USAGE'
Usage:
  new-artifact.sh TYPE "Title" [--output PATH] [--no-open]
  new-artifact.sh --list
  new-artifact.sh --help

Creates a new instance of a template by copying it, substituting
placeholders (date, title, id, owner, type), and writing to a path
derived from the template-instance-mappings.txt config.

Options:
  --output PATH    Override the auto-generated output path
  --no-open        Do not open the new file in $EDITOR after creation
  --list           List all available artifact types and exit
  --help           Show this help and exit

Examples:
  new-artifact.sh adr "Deprecate old logger"
  new-artifact.sh dfmea "New payment flow"
  new-artifact.sh investigation "Why does the build flake"
USAGE
}

lowercase() {
  printf '%s\n' "$1" | tr '[:upper:]' '[:lower:]'
}

slugify() {
  printf '%s\n' "$1" \
    | tr '[:upper:]' '[:lower:]' \
    | sed -E 's/[^a-z0-9]+/-/g' \
    | sed -E 's/^-+|-+$//g' \
    | sed -E 's/--+/-/g'
}

substitute_paths() {
  local s="$1"
  s="${s//\$\{ESE_ROOT\}/$ESE_ROOT}"
  s="${s//\$\{PROJECT_ROOT\}/$PROJECT_ROOT}"
  echo "$s"
}

TYPE=""
TITLE=""
OUTPUT_PATH=""
NO_OPEN=0
LIST=0

while [ $# -gt 0 ]; do
  case "$1" in
    --help|-h) usage; exit 0 ;;
    --list) LIST=1; shift ;;
    --output) OUTPUT_PATH="$2"; shift 2 ;;
    --no-open) NO_OPEN=1; shift ;;
    -*) echo "Unknown flag: $1" >&2; usage >&2; exit 2 ;;
    *)
      if [ -z "$TYPE" ]; then TYPE="$1"
      elif [ -z "$TITLE" ]; then TITLE="$1"
      else echo "Unexpected argument: $1" >&2; usage >&2; exit 2
      fi
      shift
      ;;
  esac
done

if [ ! -f "$MAPPINGS_FILE" ]; then
  echo "FAIL: mappings file not found at $MAPPINGS_FILE" >&2
  echo "" >&2
  echo "Fix: copy starters/linters/template-instance-mappings.txt.starter" >&2
  echo "to \$LINTER_MAPPINGS_FILE and edit the entries for your project." >&2
  exit 1
fi

TEMPLATES=()
GLOBS=()
LABELS=()

while IFS= read -r raw_line; do
  line="${raw_line#"${raw_line%%[![:space:]]*}"}"
  line="${line%"${line##*[![:space:]]}"}"
  [ -z "$line" ] && continue
  [[ "$line" == \#* ]] && continue

  t="${line%% | *}"
  rest="${line#* | }"
  g="${rest%% | *}"
  l="${rest#* | }"

  t="${t%"${t##*[![:space:]]}"}"
  g="${g#"${g%%[![:space:]]*}"}"
  g="${g%"${g##*[![:space:]]}"}"
  l="${l#"${l%%[![:space:]]*}"}"
  l="${l%"${l##*[![:space:]]}"}"

  TEMPLATES+=("$t")
  GLOBS+=("$g")
  LABELS+=("$l")
done < "$MAPPINGS_FILE"

if [ "$LIST" -eq 1 ]; then
  echo "Available artifact types (from $MAPPINGS_FILE):"
  echo ""
  printf "  %-24s  %-50s  %s\n" "TYPE (label)" "TEMPLATE" "OUTPUT LOCATION"
  printf "  %-24s  %-50s  %s\n" "------------------------" "--------------------------------------------------" "---------------"
  i=0
  while [ $i -lt ${#TEMPLATES[@]} ]; do
    printf "  %-24s  %-50s  %s\n" "${LABELS[$i]}" "${TEMPLATES[$i]}" "${GLOBS[$i]}"
    i=$((i + 1))
  done
  echo ""
  echo "Invoke with: new-artifact.sh TYPE \"Title\""
  exit 0
fi

if [ -z "$TYPE" ] || [ -z "$TITLE" ]; then
  echo "FAIL: both TYPE and \"Title\" arguments are required." >&2
  echo ""
  usage >&2
  exit 2
fi

TYPE_LOWER=$(lowercase "$TYPE")
match_idx=-1
i=0
while [ $i -lt ${#TEMPLATES[@]} ]; do
  label_lower=$(lowercase "${LABELS[$i]}")
  if [ "$label_lower" = "$TYPE_LOWER" ]; then
    match_idx=$i
    break
  fi
  i=$((i + 1))
done

if [ "$match_idx" -eq -1 ]; then
  i=0
  while [ $i -lt ${#TEMPLATES[@]} ]; do
    t_base=$(basename "${TEMPLATES[$i]}" .md)
    t_base_lower=$(lowercase "$t_base")
    if [ "$t_base_lower" = "$TYPE_LOWER" ]; then
      match_idx=$i
      break
    fi
    i=$((i + 1))
  done
fi

if [ "$match_idx" -eq -1 ]; then
  echo "FAIL: no mapping found for type '$TYPE'." >&2
  echo "" >&2
  echo "Run 'new-artifact.sh --list' to see available types." >&2
  exit 1
fi

TEMPLATE_REF="${TEMPLATES[$match_idx]}"
INSTANCE_GLOB_REF="${GLOBS[$match_idx]}"
LABEL="${LABELS[$match_idx]}"

# Substitute path variables and resolve to absolute
TEMPLATE_PATH=$(substitute_paths "$TEMPLATE_REF")
if [[ "$TEMPLATE_PATH" != /* ]]; then
  TEMPLATE_PATH="$PROJECT_ROOT/$TEMPLATE_PATH"
fi

INSTANCE_GLOB=$(substitute_paths "$INSTANCE_GLOB_REF")
if [[ "$INSTANCE_GLOB" != /* ]]; then
  INSTANCE_GLOB="$PROJECT_ROOT/$INSTANCE_GLOB"
fi

if [ ! -f "$TEMPLATE_PATH" ]; then
  echo "FAIL: template file not found at $TEMPLATE_PATH" >&2
  exit 1
fi

TODAY=$(date +%Y-%m-%d)
SLUG=$(slugify "$TITLE")

if [ -z "$SLUG" ]; then
  echo "FAIL: title produced an empty slug: '$TITLE'" >&2
  exit 1
fi

if [ -z "$OUTPUT_PATH" ]; then
  instance_dir=$(dirname "$INSTANCE_GLOB")
  instance_file=$(basename "$INSTANCE_GLOB")

  if [[ "$instance_file" != *"*"* ]]; then
    echo "FAIL: mapping for '$LABEL' targets a single fixed path ($INSTANCE_GLOB_REF), not a pattern." >&2
    echo "      Use --output PATH to specify an explicit destination for this type." >&2
    exit 1
  fi

  prefix="${instance_file%%\**}"
  suffix="${instance_file##*\*}"

  case "$prefix" in
    ADR-|DFMEA-|PFMEA-|post-mortem-|compliance-review-)
      filename="${prefix}${TODAY}-${SLUG}${suffix}"
      ;;
    "")
      case "$instance_dir" in
        */work-sessions) filename="${TODAY}-${SLUG}${suffix}" ;;
        *) filename="${SLUG}${suffix}" ;;
      esac
      ;;
    *)
      filename="${prefix}${SLUG}${suffix}"
      ;;
  esac

  OUTPUT_PATH="$instance_dir/$filename"
else
  if [[ "$OUTPUT_PATH" != /* ]]; then
    OUTPUT_PATH="$PROJECT_ROOT/$OUTPUT_PATH"
  fi
fi

if [ -e "$OUTPUT_PATH" ]; then
  echo "FAIL: output file already exists at $OUTPUT_PATH" >&2
  echo "      Refusing to overwrite. Delete the file or use a different title." >&2
  exit 1
fi

mkdir -p "$(dirname "$OUTPUT_PATH")"

OWNER="$(git config user.name 2>/dev/null || echo 'unknown')"
ID_SLUG="${TODAY}-${SLUG}"
TYPE_UPPER=$(printf '%s\n' "$LABEL" | tr '[:lower:]' '[:upper:]' | tr -d ' ')

python3 - "$TEMPLATE_PATH" "$OUTPUT_PATH" "$TITLE" "$TODAY" "$ID_SLUG" "$OWNER" "$TYPE_UPPER" <<'PYEOF'
import sys

template_path, output_path, title, today, id_slug, owner, type_upper = sys.argv[1:8]

with open(template_path, encoding='utf-8') as f:
    content = f.read()

content = content.replace('YYYY-MM-DD', today)
content = content.replace('{type}', type_upper)
content = content.replace('{Title}', title)
content = content.replace('{title}', title)
content = content.replace('{number}', id_slug)
content = content.replace('{ID}', id_slug)
content = content.replace('{owner}', owner)
content = content.replace('{team/owner}', owner)
content = content.replace('{who was involved}', owner)
content = content.replace('{Feature or Process Name}', title)
content = content.replace('{Feature or Product Name}', title)
content = content.replace('{Problem Name}', title)
content = content.replace('{Project Name}', title)

with open(output_path, 'w', encoding='utf-8') as f:
    f.write(content)
PYEOF

REL_OUTPUT="${OUTPUT_PATH#$PROJECT_ROOT/}"
echo "Created $REL_OUTPUT"
echo "  Type:     $LABEL"
echo "  Template: $TEMPLATE_REF"
echo "  Title:    $TITLE"
echo "  Date:     $TODAY"
echo "  Owner:    $OWNER"
echo ""
echo "Next steps:"
echo "  1. Edit the file and fill in remaining placeholders ({...})"
echo "  2. Run your template-compliance linter to verify section compliance"
echo "  3. Commit with a 'docs:' or 'feat:' type commit message"

if [ "$NO_OPEN" -eq 0 ] && [ -n "${EDITOR:-}" ]; then
  "$EDITOR" "$OUTPUT_PATH"
fi
