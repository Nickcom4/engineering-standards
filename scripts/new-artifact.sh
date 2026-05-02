#!/usr/bin/env bash
# new-artifact.sh: scaffold a new instance of an ESE template
#
# Reads scripts/template-instance-mappings.txt to find the template and
# output directory for a given artifact type, copies the template,
# substitutes common placeholders (date, title, id, owner), and writes
# the result to a path derived from the instance glob.
#
# Usage:
#
#   scripts/new-artifact.sh TYPE "Title" [--output PATH] [--no-open]
#   scripts/new-artifact.sh --list
#   scripts/new-artifact.sh --help
#
# Examples:
#
#   scripts/new-artifact.sh adr "Deprecate old logger"
#     -> docs/decisions/ADR-2026-04-11-deprecate-old-logger.md
#
#   scripts/new-artifact.sh dfmea "New payment flow"
#     -> docs/decisions/DFMEA-2026-04-11-new-payment-flow.md
#
#   scripts/new-artifact.sh investigation "Why does the build flake"
#     -> docs/product/investigation-why-does-the-build-flake.md
#
# The TYPE argument matches against the LABEL field of each mapping line
# in scripts/template-instance-mappings.txt (case-insensitive). Run with
# --list to see every available type.
#
# Placeholder substitution:
#
#   YYYY-MM-DD  -> today's date
#   {Title}     -> the title argument
#   {title}     -> the title argument
#   {number}    -> date-slug (e.g., 2026-04-11-deprecate-old-logger)
#   {owner}     -> git config user.name (or "unknown" if unset)
#
# Other placeholders in the template are left in place for the user to
# fill in manually. This tool is a scaffold, not an artifact author.

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
MAPPINGS_FILE="$REPO_ROOT/scripts/template-instance-mappings.txt"

usage() {
  cat <<'USAGE'
Usage:
  new-artifact.sh TYPE "Title" [--output PATH] [--no-open]
  new-artifact.sh --list
  new-artifact.sh --help

Creates a new instance of an ESE template by copying the template,
substituting placeholders (date, title, id, owner), and writing to
a path derived from the template-instance-mappings.txt config.

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
  # Title -> lowercase, spaces to hyphens, strip non-alnum-hyphen, collapse hyphens
  printf '%s\n' "$1" \
    | tr '[:upper:]' '[:lower:]' \
    | sed -E 's/[^a-z0-9]+/-/g' \
    | sed -E 's/^-+|-+$//g' \
    | sed -E 's/--+/-/g'
}

# -------------------------------------------------------------------------
# Argument parsing
# -------------------------------------------------------------------------
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
  echo "FAIL: $MAPPINGS_FILE not found" >&2
  exit 1
fi

# -------------------------------------------------------------------------
# Parse mappings into three parallel arrays
# -------------------------------------------------------------------------
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

# -------------------------------------------------------------------------
# --list mode: show all available types
# -------------------------------------------------------------------------
if [ "$LIST" -eq 1 ]; then
  echo "Available artifact types (from scripts/template-instance-mappings.txt):"
  echo ""
  printf "  %-24s  %-45s  %s\n" "TYPE (label)" "TEMPLATE" "OUTPUT LOCATION"
  printf "  %-24s  %-45s  %s\n" "------------------------" "---------------------------------------------" "---------------"
  i=0
  while [ $i -lt ${#TEMPLATES[@]} ]; do
    printf "  %-24s  %-45s  %s\n" "${LABELS[$i]}" "${TEMPLATES[$i]}" "${GLOBS[$i]}"
    i=$((i + 1))
  done
  echo ""
  echo "Invoke with: new-artifact.sh TYPE \"Title\""
  echo "TYPE may be the label (case-insensitive) shown above."
  exit 0
fi

if [ -z "$TYPE" ] || [ -z "$TITLE" ]; then
  echo "FAIL: both TYPE and \"Title\" arguments are required." >&2
  echo ""
  usage >&2
  exit 2
fi

# -------------------------------------------------------------------------
# Match TYPE against labels (case-insensitive)
# -------------------------------------------------------------------------
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

# If no label match, try matching against template basename (e.g., "adr" matches templates/adr.md)
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
  echo ""
  echo "Run 'new-artifact.sh --list' to see available types." >&2
  exit 1
fi

TEMPLATE_REL="${TEMPLATES[$match_idx]}"
INSTANCE_GLOB="${GLOBS[$match_idx]}"
LABEL="${LABELS[$match_idx]}"
TEMPLATE_PATH="$REPO_ROOT/$TEMPLATE_REL"

if [ ! -f "$TEMPLATE_PATH" ]; then
  echo "FAIL: template file not found at $TEMPLATE_PATH" >&2
  exit 1
fi

# -------------------------------------------------------------------------
# Derive output path from the instance glob
# -------------------------------------------------------------------------
TODAY=$(date +%Y-%m-%d)
SLUG=$(slugify "$TITLE")

if [ -z "$SLUG" ]; then
  echo "FAIL: title produced an empty slug: '$TITLE'" >&2
  exit 1
fi

if [ -z "$OUTPUT_PATH" ]; then
  # Instance glob examples:
  #   docs/decisions/ADR-*.md       -> prefix "ADR-" + date + slug
  #   docs/decisions/DFMEA-*.md     -> prefix "DFMEA-" + date + slug
  #   docs/architecture/*.md        -> no prefix, just slug (no date)
  #   docs/work-sessions/*.md       -> no prefix, date + slug
  #   docs/product/prd-*.md         -> prefix "prd-" + slug (no date by convention)
  #   docs/standards-application.md -> literal path (no glob)

  instance_dir=$(dirname "$INSTANCE_GLOB")
  instance_file=$(basename "$INSTANCE_GLOB")

  if [[ "$instance_file" != *"*"* ]]; then
    # No glob star: the mapping is for a single fixed path, not a pattern
    echo "FAIL: mapping for '$LABEL' targets a single fixed path ($INSTANCE_GLOB), not a pattern." >&2
    echo "      Use --output PATH to specify an explicit destination for this type." >&2
    exit 1
  fi

  # Extract prefix and suffix around the *
  prefix="${instance_file%%\**}"
  suffix="${instance_file##*\*}"

  # Decide whether to include a date in the filename
  case "$prefix" in
    ADR-|DFMEA-|PFMEA-|post-mortem-|compliance-review-|VSM-)
      filename="${prefix}${TODAY}-${SLUG}${suffix}"
      ;;
    "")
      # No prefix: default to date + slug for session logs, raw slug otherwise
      case "$instance_dir" in
        */work-sessions) filename="${TODAY}-${SLUG}${suffix}" ;;
        *) filename="${SLUG}${suffix}" ;;
      esac
      ;;
    *)
      # Generic prefixed type (e.g., prd-, investigation-, capabilities-, slo-, tech-eval-)
      filename="${prefix}${SLUG}${suffix}"
      ;;
  esac

  OUTPUT_PATH="$REPO_ROOT/$instance_dir/$filename"
else
  # User-supplied output path: resolve relative to repo root if not absolute
  if [[ "$OUTPUT_PATH" != /* ]]; then
    OUTPUT_PATH="$REPO_ROOT/$OUTPUT_PATH"
  fi
fi

if [ -e "$OUTPUT_PATH" ]; then
  echo "FAIL: output file already exists at $OUTPUT_PATH" >&2
  echo "      Refusing to overwrite. Delete the file or use a different title." >&2
  exit 1
fi

mkdir -p "$(dirname "$OUTPUT_PATH")"

# -------------------------------------------------------------------------
# Copy template and substitute placeholders
# -------------------------------------------------------------------------
OWNER="$(git config user.name 2>/dev/null || echo 'unknown')"
ID_SLUG="${TODAY}-${SLUG}"

# Derive {type} placeholder from the matched label. For labels like "DFMEA"
# and "PFMEA", the uppercase form is the type. For labels like "ADR", the
# uppercase form is the type. For multi-word labels like "architecture doc",
# the type placeholder is not used in the template so the value does not
# matter, but we uppercase and strip spaces for consistency.
TYPE_UPPER=$(printf '%s\n' "$LABEL" | tr '[:lower:]' '[:upper:]' | tr -d ' ')

# Use python for safe substitution; avoid sed quoting issues with titles
python3 - "$TEMPLATE_PATH" "$OUTPUT_PATH" "$TITLE" "$TODAY" "$ID_SLUG" "$OWNER" "$TYPE_UPPER" <<'PYEOF'
import os
import re
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

# Rewrite relative-path links so they resolve from the instance location
# rather than the template location. Templates live at templates/ (depth 1);
# instances may live at any depth. A link written `../STANDARDS.md` from
# templates/ resolves to <repo>/STANDARDS.md, but the same string from
# docs/work-items/active/ resolves to docs/work-items/STANDARDS.md (broken).
# We resolve every relative link against the template's directory, then
# re-express it relative to the instance's directory.
template_dir = os.path.dirname(os.path.abspath(template_path))
instance_dir = os.path.dirname(os.path.abspath(output_path))

def rewrite_link(match):
    target = match.group(1)
    # Skip absolute URLs, mail, anchor-only refs, root-relative paths,
    # and any target containing an unfilled placeholder.
    if re.match(r'^(https?:|mailto:|#|/)', target):
        return match.group(0)
    if '{' in target or '}' in target:
        return match.group(0)
    if '#' in target:
        path_part, anchor = target.split('#', 1)
        anchor = '#' + anchor
    else:
        path_part = target
        anchor = ''
    if not path_part:
        return match.group(0)
    abs_target = os.path.normpath(os.path.join(template_dir, path_part))
    rel_target = os.path.relpath(abs_target, instance_dir)
    return f']({rel_target}{anchor})'

content = re.sub(r'\]\(([^)\s]+)\)', rewrite_link, content)

with open(output_path, 'w', encoding='utf-8') as f:
    f.write(content)
PYEOF

REL_OUTPUT="${OUTPUT_PATH#$REPO_ROOT/}"
echo "Created $REL_OUTPUT"
echo "  Type:     $LABEL"
echo "  Template: $TEMPLATE_REL"
echo "  Title:    $TITLE"
echo "  Date:     $TODAY"
echo "  Owner:    $OWNER"
echo ""
echo "Next steps:"
echo "  1. Edit the file and fill in remaining placeholders ({...})"
echo "  2. Run 'bash scripts/lint-template-compliance.sh' to verify section compliance"
echo "  3. Commit with a 'docs:' or 'feat:' type commit message"

if [ "$NO_OPEN" -eq 0 ] && [ -n "${EDITOR:-}" ]; then
  "$EDITOR" "$OUTPUT_PATH"
fi
