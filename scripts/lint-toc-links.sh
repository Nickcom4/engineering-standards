#!/usr/bin/env bash
# ToC-to-heading consistency linter
# Verifies that every anchor link in a Table of Contents section
# resolves to an actual heading in the same document. Uses GitHub-
# flavored markdown slug generation rules.
#
# Exit 0 = pass. Exit 1 = broken ToC links found.

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"

python3 - "$REPO_ROOT" <<'PYEOF'
import os
import re
import sys
import unicodedata

repo_root = sys.argv[1]
violations = []


def gfm_slug(heading_text):
    """Generate a GitHub-flavored markdown anchor slug from heading text.

    GFM rules:
    1. Strip leading/trailing whitespace
    2. Lowercase
    3. Remove anything that is not a letter, number, space, or hyphen
    4. Replace spaces with hyphens
    """
    text = heading_text.strip()
    # Remove inline code backticks but keep their content
    text = text.replace("`", "")
    # Remove inline links: [text](url) -> text
    text = re.sub(r"\[([^\]]*)\]\([^)]*\)", r"\1", text)
    # Remove images: ![alt](url) -> alt
    text = re.sub(r"!\[([^\]]*)\]\([^)]*\)", r"\1", text)
    # Remove HTML tags
    text = re.sub(r"<[^>]+>", "", text)
    # Remove bold/italic markers
    text = text.replace("**", "").replace("__", "").replace("*", "").replace("_", " ")
    text = text.lower()
    # Keep only: word chars (letters, digits, underscore), spaces, hyphens
    # Unicode letters and digits are preserved
    slug = ""
    for ch in text:
        if ch.isalnum() or ch in (" ", "-"):
            slug += ch
    # Replace spaces with hyphens
    slug = slug.replace(" ", "-")
    # GFM does NOT collapse consecutive hyphens; " - " becomes "---"
    # Strip leading/trailing hyphens
    slug = slug.strip("-")
    return slug


def find_toc_and_check(filepath, content):
    """Find ToC section, extract anchor links, verify against headings."""
    lines = content.splitlines()
    file_violations = []

    # Find all headings and generate their slugs.
    # Track duplicates per GFM (foo, foo-1, foo-2, etc.)
    heading_slugs = set()
    slug_counts = {}
    in_fence = False

    for line in lines:
        if line.strip().startswith("```"):
            in_fence = not in_fence
            continue
        if in_fence:
            continue

        heading_match = re.match(r"^(#{1,6})\s+(.+)$", line)
        if heading_match:
            heading_text = heading_match.group(2)
            slug = gfm_slug(heading_text)
            if slug in slug_counts:
                slug_counts[slug] += 1
                heading_slugs.add(f"{slug}-{slug_counts[slug]}")
            else:
                slug_counts[slug] = 0
                heading_slugs.add(slug)

    # Find ToC section: look for a heading containing "Table of Contents"
    # or "Contents", then collect links until the next heading.
    toc_started = False
    toc_links = []
    in_fence = False

    for lineno, line in enumerate(lines, 1):
        if line.strip().startswith("```"):
            in_fence = not in_fence
            continue
        if in_fence:
            continue

        if re.match(r"^#{1,6}\s+.*(?:Table of Contents|Contents).*$", line, re.IGNORECASE):
            toc_started = True
            continue

        if toc_started:
            # End of ToC at next heading
            if re.match(r"^#{1,6}\s+", line):
                break

            # Extract anchor links: [text](#anchor)
            for match in re.finditer(r"\[([^\]]*)\]\(#([^)]*)\)", line):
                link_text = match.group(1)
                anchor = match.group(2)
                toc_links.append((lineno, link_text, anchor))

    # Verify each ToC link resolves to a heading
    for lineno, link_text, anchor in toc_links:
        if anchor not in heading_slugs:
            relpath = os.path.relpath(filepath, repo_root)
            file_violations.append(
                f"{relpath}:{lineno}: ToC link '#{anchor}' does not match any heading slug"
            )

    return file_violations


# Scan all markdown files
for dirpath, dirnames, filenames in os.walk(repo_root):
    dirnames[:] = [d for d in dirnames if not d.startswith(".") and d != "node_modules"]
    for fname in filenames:
        if not fname.endswith(".md"):
            continue
        filepath = os.path.join(dirpath, fname)
        with open(filepath, encoding="utf-8") as f:
            content = f.read()

        # Only check files that have a ToC section
        if not re.search(r"^#{1,6}\s+.*(?:Table of Contents|Contents)", content, re.MULTILINE | re.IGNORECASE):
            continue

        file_violations = find_toc_and_check(filepath, content)
        violations.extend(file_violations)

if violations:
    print(f"FAIL: Broken ToC links found ({len(violations)} violations):")
    for v in violations:
        print(f"  {v}")
    print()
    print("Fix: regenerate the ToC links to match the actual heading slugs.")
    sys.exit(1)
else:
    print("PASS: All ToC links resolve to valid heading slugs.")
    sys.exit(0)
PYEOF
