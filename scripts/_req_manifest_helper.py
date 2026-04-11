#!/usr/bin/env python3
"""
T7: REQ-ID block extractor for generate-req-manifest.sh
Usage: _req_manifest_helper.py <repo_root> <file1> [file2 ...]
Outputs: REQ-ID|sha256hex|relative-path, one per line, sorted by REQ-ID.
"""
import sys
import re
import hashlib

repo_root = sys.argv[1]
files = sys.argv[2:]
FENCE = "```"

results = []

for filepath in files:
    relpath = filepath.replace(repo_root + "/", "")
    with open(filepath, encoding="utf-8") as fh:
        lines = fh.readlines()

    in_fence = False
    i = 0
    while i < len(lines):
        line = lines[i].rstrip("\n")

        # Track fenced code blocks
        if line.startswith(FENCE):
            in_fence = not in_fence
            i += 1
            continue
        if in_fence:
            i += 1
            continue

        # Look for anchor line
        anchor_match = re.match(r'<a name="(REQ-[^"]+)"></a>', line)
        if anchor_match:
            req_id = anchor_match.group(1)
            anchor_line = line

            # Next line: tag line (**REQ-ID** ...)
            tag_line = lines[i + 1].rstrip("\n") if i + 1 < len(lines) else ""

            # Line after tag: statement
            statement_line = lines[i + 2].rstrip("\n") if i + 2 < len(lines) else ""

            block = "\n".join([anchor_line, tag_line, statement_line])
            digest = hashlib.sha256(block.encode("utf-8")).hexdigest()
            results.append(f"{req_id}|{digest}|{relpath}")
            i += 3
            continue

        i += 1

# Sort by REQ-ID for stable output
results.sort(key=lambda x: x.split("|")[0])
print("\n".join(results))
