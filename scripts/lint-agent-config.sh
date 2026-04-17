#!/usr/bin/env bash
# lint-agent-config.sh (adopter starter): agent-assisted-development posture
# declaration linter.
#
# status: shadow
#
# Runs in CI and records its output for auditability but does not block the
# build. Adopters who are ready to enforce can flip the status header from
# `shadow` to `gate` and wire the exit code as blocking in their CI; the
# script logic is the same in both modes. Promotion is an adopter decision
# based on accumulated true-positive catches in the shadow phase.
#
# What it catches
#
#   Applies only when your project declares `addenda.agent-assisted-development:
#   true` in standards-application.md. When active, scans the configured
#   posture files (CLAUDE.md, AGENTS.md, .cursorrules, .agent.md by default)
#   for required posture statements and reports any that are absent.
#
#   The checks map to the REQ-ADD-AAD-NN requirements that govern the
#   posture-declaration surface:
#
#     Check 1  Posture file exists (REQ-ADD-AAD-01): at least one of the
#              configured posture files must exist at the project root.
#     Check 2  Agent-authority declaration (REQ-ADD-AAD-02): posture files
#              name whether agents hold commit authority and on which
#              branches agent-initiated commits land.
#     Check 3  Gate-authority review statement (REQ-ADD-AAD-03): posture
#              files name the review pathway for agent-initiated commits
#              reaching a protected branch.
#     Check 4  Approval-boundary statement (REQ-ADD-AAD-04): posture files
#              name the scope of approved agent actions (file types, command
#              categories, wildcard rationale).
#     Check 5  Credential-handling statement (REQ-ADD-AAD-07): posture files
#              name how agents receive and relinquish credentials.
#     Check 6  Revocation path statement (REQ-ADD-AAD-08): posture files
#              name the revocation path for trust incidents.
#
#   Detection is lexical: each check uses a small set of phrase patterns
#   that commonly appear in posture-declaration prose. False negatives
#   (posture declared in unusual wording) are expected in the shadow phase
#   and inform detection-pattern refinement before promotion.
#
# Parameterization
#
#   PROJECT_ROOT        Your repo root. Default: git rev-parse or pwd.
#   APPLICATION_FILE    Path to your project's standards-application.md.
#                       Default: ${PROJECT_ROOT}/docs/standards-application.md
#   POSTURE_FILES       Colon-separated list of posture-file paths relative
#                       to PROJECT_ROOT. Default: "AGENTS.md:CLAUDE.md:.cursorrules:.agent.md"
#                       The linter scans every listed file that exists. If
#                       none exist, Check 1 reports the absence.
#
# Exit 0 always (shadow). Violations are printed but do not affect the exit
# code. Adopters promoting to gate should change the final sys.exit(0) at
# the shadow-violation path to sys.exit(1).

set -uo pipefail

PROJECT_ROOT="${PROJECT_ROOT:-$(git rev-parse --show-toplevel 2>/dev/null || pwd)}"
APPLICATION_FILE="${APPLICATION_FILE:-${PROJECT_ROOT}/docs/standards-application.md}"
POSTURE_FILES="${POSTURE_FILES:-AGENTS.md:CLAUDE.md:.cursorrules:.agent.md}"

if [ ! -f "$APPLICATION_FILE" ]; then
  echo "SKIP: APPLICATION_FILE not found at $APPLICATION_FILE; linter not applicable."
  exit 0
fi

python3 - "$PROJECT_ROOT" "$APPLICATION_FILE" "$POSTURE_FILES" <<'PYEOF'
import os
import re
import sys
from pathlib import Path

project_root = Path(sys.argv[1])
application_file = Path(sys.argv[2])
posture_files_spec = sys.argv[3]

FRONTMATTER_RE = re.compile(r'^---\s*\n(.*?)\n---\s*\n', re.DOTALL)


def extract_addendum_flag(text: str) -> bool:
    m = FRONTMATTER_RE.match(text)
    if not m:
        return False
    fm = m.group(1)
    addenda_re = re.compile(
        r'^addenda:\s*\n((?:[ \t]+.*\n?)*)',
        re.MULTILINE,
    )
    addenda_block = addenda_re.search(fm)
    if not addenda_block:
        return False
    block = addenda_block.group(1)
    flag_re = re.compile(
        r'^\s+agent-assisted-development:\s*(true|false)\b',
        re.MULTILINE,
    )
    m2 = flag_re.search(block)
    if not m2:
        return False
    return m2.group(1) == "true"


try:
    with open(application_file, encoding="utf-8") as f:
        app_text = f.read()
except Exception as exc:
    print(f"SKIP: could not read {application_file}: {exc}")
    sys.exit(0)

if not extract_addendum_flag(app_text):
    print("PASS: agent-assisted-development is not declared true in standards-application.md; silent.")
    sys.exit(0)

candidates = [p.strip() for p in posture_files_spec.split(":") if p.strip()]
existing = []
for rel in candidates:
    abs_path = project_root / rel
    if abs_path.is_file():
        existing.append((rel, abs_path))

if not existing:
    print(
        "SHADOW: agent-assisted-development: true but no posture file found under "
        f"{project_root} (searched: {candidates})."
    )
    print("REQ-ADD-AAD-01: at least one posture file must exist at the project root.")
    print()
    print("Shadow status: finding recorded; does not block the build.")
    sys.exit(0)

corpus = ""
for rel, abs_path in existing:
    try:
        with open(abs_path, encoding="utf-8") as f:
            corpus += f"\n\n[[ {rel} ]]\n\n" + f.read()
    except Exception as exc:
        print(f"SHADOW: could not read {rel}: {exc}")

corpus_lower = corpus.lower()

checks = [
    (
        "Check 2 (REQ-ADD-AAD-02): agent-authority declaration",
        [
            "commit authority",
            "agents have commit",
            "agents do not push",
            "never push",
            "agent-initiated commit",
            "agent initiated commit",
            "agent commits",
        ],
    ),
    (
        "Check 3 (REQ-ADD-AAD-03): gate-authority review pathway",
        [
            "gate authority",
            "gate-authority",
            "human review",
            "human gate",
            "protected branch",
            "pull request",
            "pr review",
            "explicit review",
            "explicit instruction",
        ],
    ),
    (
        "Check 4 (REQ-ADD-AAD-04): approval-boundary statement",
        [
            "approval boundary",
            "approval scope",
            "file types",
            "command categor",
            "allowlist",
            "blocklist",
            "scope of",
            "allowed action",
            "permitted to",
            "must not",
            "never",
        ],
    ),
    (
        "Check 5 (REQ-ADD-AAD-07): credential-handling statement",
        [
            "credential",
            "secret",
            "token",
            "session-scoped",
            "session scoped",
            "api key",
            ".env",
        ],
    ),
    (
        "Check 6 (REQ-ADD-AAD-08): revocation-path statement",
        [
            "revoc",
            "revoke",
            "kill switch",
            "branch protection",
            "disable agent",
            "revocation path",
        ],
    ),
]

violations = []
for label, patterns in checks:
    if not any(p in corpus_lower for p in patterns):
        violations.append(label)

if not violations:
    print(
        f"PASS: all 6 posture-declaration checks present in {len(existing)} posture file(s): "
        + ", ".join(rel for rel, _ in existing)
    )
    sys.exit(0)

print(
    f"SHADOW: {len(violations)} posture-declaration check(s) did not match against "
    f"{len(existing)} posture file(s) ({', '.join(rel for rel, _ in existing)}):"
)
for v in violations:
    print(f"  {v}")
print()
print("Detection is lexical: the linter matched a small set of phrase patterns")
print("that commonly appear in posture declarations. A posture that is actually")
print("declared but worded differently is a false positive; a posture genuinely")
print("absent is a true positive. The shadow phase is where detection patterns")
print("are refined before promotion to gate.")
print()
print("Shadow status: finding recorded; does not block the build.")
PYEOF
