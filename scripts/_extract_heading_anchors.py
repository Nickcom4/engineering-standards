#!/usr/bin/env python3
"""Extract GitHub-style heading anchors from markdown files.
Prints one anchor per line in the format: filepath#slug
Usage: python3 _extract_heading_anchors.py file1.md file2.md ...
"""
import re
import sys


def slugify(heading: str) -> str:
    """GitHub-style heading slug: lowercase, non-alphanumeric removed (except hyphens/spaces)."""
    h = heading.lstrip('#').strip()
    h = h.lower()
    # Drop characters that are not alphanumeric, space, or hyphen
    h = re.sub(r'[^\w\s-]', '', h)
    h = re.sub(r'\s+', '-', h)
    h = re.sub(r'-+', '-', h)
    return h.strip('-')


for fpath in sys.argv[1:]:
    try:
        with open(fpath) as f:
            lines = f.readlines()
    except (OSError, IOError):
        continue

    in_fence = False
    for line in lines:
        stripped = line.strip()
        if stripped.startswith('```'):
            in_fence = not in_fence
        if not in_fence and stripped.startswith('#'):
            slug = slugify(stripped)
            if slug:
                print(f"{fpath}#{slug}")
