#!/usr/bin/env python3
"""
Generate docs/requirement-index.md from REQ-ID tags.
Organized by lifecycle scope, then by applies-when group.
Usage: python3 _generate_req_index.py <repo_root> <file1> [file2 ...]
Outputs the generated markdown to stdout.
"""
import sys
import re
import os

repo_root = sys.argv[1]
files = sys.argv[2:]

FENCE = "```"

SCOPE_ORDER = [
    ("discover",      "Discover"),
    ("define",        "Define"),
    ("design",        "Design"),
    ("build",         "Build"),
    ("verify",        "Verify"),
    ("document",      "Document"),
    ("deploy",        "Deploy"),
    ("monitor",       "Monitor"),
    ("close",         "Close"),
    ("commit",        "Commit (pre-commit hooks)"),
    ("session-start", "Session Start"),
    ("session-end",   "Session End"),
    ("continuous",    "Continuous"),
]

APPLIES_ORDER = [
    ("all",            "All work items"),
    ("type:bug",       "type: bug"),
    ("type:feature",   "type: feature"),
    ("type:epic",      "type: epic"),
    ("type:task",      "type: task"),
    ("type:chore",     "type: chore"),
    ("type:component", "type: component"),
    ("type:security",  "type: security"),
    ("addendum:CI",    "Addendum: Continuous Improvement"),
    ("addendum:MT",    "Addendum: Multi-Team"),
    ("addendum:WEB",   "Addendum: Web Applications"),
    ("addendum:EVT",   "Addendum: Event-Driven"),
    ("addendum:AI",    "Addendum: AI/ML"),
    ("addendum:CTR",   "Addendum: Containerized Systems"),
    ("addendum:MS",    "Addendum: Multi-Service"),
]

reqs = []

for filepath in files:
    relpath = os.path.relpath(filepath, repo_root)
    try:
        with open(filepath, encoding="utf-8") as f:
            lines = f.readlines()
    except Exception:
        continue

    in_fence = False
    i = 0
    while i < len(lines):
        line = lines[i].rstrip("\n")
        if line.startswith(FENCE):
            in_fence = not in_fence
            i += 1
            continue
        if in_fence:
            i += 1
            continue

        anchor = re.match(r'<a name="(REQ-[^"]+)"></a>', line)
        if anchor:
            req_id = anchor.group(1)
            tag_line = lines[i+1].rstrip("\n") if i+1 < len(lines) else ""
            stmt_line = lines[i+2].rstrip("\n") if i+2 < len(lines) else ""

            tags = re.findall(r'`([^`]+)`', tag_line)
            # Skip deprecated
            if any(t.startswith("deprecated:") for t in tags):
                i += 3
                continue

            kind    = tags[0] if len(tags) > 0 else ""
            scope   = tags[1] if len(tags) > 1 else ""
            enf     = tags[2] if len(tags) > 2 else ""
            applies = tags[3] if len(tags) > 3 else "all"

            # Clean statement
            stmt = re.sub(r'~~.*?~~', '', stmt_line).strip()
            stmt = re.sub(r'^\*+|\*+$', '', stmt).strip()

            reqs.append({
                "id": req_id,
                "kind": kind,
                "scope": scope,
                "enforcement": enf,
                "applies": applies,
                "stmt": stmt,
                "file": relpath,
            })
            i += 3
            continue
        i += 1

total = len(reqs)

# Convert repo-root-relative paths to docs-relative paths for links,
# since the output file lives in docs/.
for r in reqs:
    fpath = r["file"]
    if fpath.startswith("docs/"):
        r["link"] = fpath[len("docs/"):]
    else:
        r["link"] = "../" + fpath

# Build scope -> applies -> [reqs] index
index = {}
for r in reqs:
    index.setdefault(r["scope"], {}).setdefault(r["applies"], []).append(r)

out = []
out.append("# Requirement Index")
out.append("")
out.append("> Auto-generated from REQ-ID tags by `scripts/generate-req-index.sh`. Do not edit by hand.")
out.append(f"> Source: {total} active REQ-IDs across the corpus (STANDARDS.md, 7 addenda, templates, starters, adoption.md).")
out.append("> Organized by lifecycle scope, then by applies-when group.")
out.append("> Enforcement: **hard** = blocks; *soft* = warns; none = informational.")
out.append("")
out.append("---")
out.append("")
out.append("## Table of Contents")
out.append("")
known_scopes = set(index.keys())
for scope_key, scope_label in SCOPE_ORDER:
    if scope_key in known_scopes:
        anchor = re.sub(r'[^a-z0-9-]', '', scope_label.lower().replace(" ", "-"))
        out.append(f"- [{scope_label}](#{anchor})")
out.append("")
out.append("---")
out.append("")

for scope_key, scope_label in SCOPE_ORDER:
    if scope_key not in index:
        continue
    scope_data = index[scope_key]
    scope_total = sum(len(v) for v in scope_data.values())

    out.append(f"## {scope_label}")
    out.append("")
    out.append(f"*{scope_total} requirements.*")
    out.append("")

    seen = set()
    applies_groups = []
    for a_key, a_label in APPLIES_ORDER:
        if a_key in scope_data:
            applies_groups.append((a_key, a_label))
            seen.add(a_key)
    for a_key in sorted(scope_data.keys()):
        if a_key not in seen:
            applies_groups.append((a_key, a_key))

    for a_key, a_label in applies_groups:
        group_reqs = scope_data.get(a_key, [])
        if not group_reqs:
            continue
        out.append(f"### {a_label}")
        out.append("")
        out.append("| REQ-ID | Enforcement | Statement | Source |")
        out.append("|---|---|---|---|")
        for r in sorted(group_reqs, key=lambda x: x["id"]):
            enf = r["enforcement"]
            enf_fmt = f"**{enf}**" if enf == "hard" else (f"*{enf}*" if enf == "soft" else enf)
            stmt = r["stmt"][:120] + ("..." if len(r["stmt"]) > 120 else "")
            out.append(f"| `{r['id']}` | {enf_fmt} | {stmt} | [{r['file']}]({r['link']}) |")
        out.append("")

print("\n".join(out))
