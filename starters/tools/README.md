# ESE tool starter pack

Portable helper tools for working with ESE templates. Copy once at adoption, maintain the copy. Unlike the linters in `starters/linters/`, these are developer-facing workflow tools rather than CI gates.

## Table of Contents

- [What is in this directory](#what-is-in-this-directory)
- [Adoption protocol](#adoption-protocol)
- [Parameterization](#parameterization)
- [Placeholder substitution reference](#placeholder-substitution-reference)
- [Relationship to the linter pack](#relationship-to-the-linter-pack)

## What is in this directory

| Script | Purpose | ESE internal counterpart |
|---|---|---|
| `new-artifact.sh` | Scaffold a new instance of an ESE template (ADR, FMEA, investigation, PRD, etc.) with placeholders pre-filled. Reads your project's `template-instance-mappings.txt` to know where to put the new file | `scripts/new-artifact.sh` |

More tools will be added as adopter feedback identifies workflow gaps.

## Adoption protocol

One-time setup per project. This assumes you have already vendored ESE as a submodule and copied `starters/linters/template-instance-mappings.txt.starter` to `scripts/template-instance-mappings.txt` per the linter pack adoption protocol.

1. **Copy the tool** into your repo:

   ```
   cp .standards/starters/tools/new-artifact.sh scripts/
   chmod +x scripts/new-artifact.sh
   ```

2. **Verify it can see your mappings**:

   ```
   bash scripts/new-artifact.sh --list
   ```

   You should see every artifact type you configured in `scripts/template-instance-mappings.txt`.

3. **Scaffold an artifact** to test the end-to-end flow:

   ```
   bash scripts/new-artifact.sh adr "Test scaffolding"
   ```

   The tool creates a pre-filled file in the location declared by your mapping (for example, `docs/decisions/ADR-YYYY-MM-DD-test-scaffolding.md`), substitutes placeholders, and optionally opens it in your editor. Delete the test file when you are satisfied.

## Parameterization

`new-artifact.sh` reads four environment variables with sensible defaults:

| Variable | Default | Purpose |
|---|---|---|
| `PROJECT_ROOT` | `git rev-parse --show-toplevel` (or `pwd` if not in git) | Your repo root. Output paths resolve against this. |
| `ESE_ROOT` | `${PROJECT_ROOT}/.standards` | Where ESE is vendored. The `${ESE_ROOT}` token in the mappings file expands to this value. |
| `LINTER_MAPPINGS_FILE` | `${PROJECT_ROOT}/scripts/template-instance-mappings.txt` | Path to the mapping config. Shared with `lint-template-compliance.sh`. |
| `EDITOR` | unset | If set, the new file opens in that editor after creation (unless `--no-open` is passed). |

## Placeholder substitution reference

When creating a new instance, the tool substitutes these placeholders in the template text:

| Placeholder | Replaced with |
|---|---|
| `YYYY-MM-DD` | Today's date |
| `{Title}`, `{title}` | The title argument |
| `{number}` | Date-slug (for example, `2026-04-11-deprecate-old-logger`) |
| `{owner}` | `git config user.name` (fallback: `unknown`) |
| `{type}` | Label uppercased with spaces stripped (`ADR`, `DFMEA`, `PFMEA`, ...) |
| `{Feature or Process Name}` | The title argument (FMEA template compatibility) |
| `{team/owner}` | `git config user.name` |
| `{who was involved}` | `git config user.name` |

Any other `{...}` placeholders in the template are left in place for the user to fill in manually. This tool is a scaffold, not an artifact author.

## Relationship to the linter pack

The scaffolding tool and the template-compliance linter share the same configuration file (`template-instance-mappings.txt`). Single-source-of-truth pattern:

1. `new-artifact.sh` reads the mappings to know **where** to put new instances.
2. `lint-template-compliance.sh` reads the mappings to know **what sections** each instance must contain.

Adding a new artifact type is one line in the mappings file; both tools pick it up automatically. Removing an artifact type is also one line.
