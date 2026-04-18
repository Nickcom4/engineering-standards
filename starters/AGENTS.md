# Agent Context (CLAUDE.md / AGENTS.md)

> This repo applies the [Excellence Standards - Engineering (ESE)](.standards/STANDARDS.md), vendored as a git submodule at `.standards/`. These instructions apply to any AI coding agent working in this repository.

## Table of Contents

- [Bootstrap (first-time setup)](#bootstrap-first-time-setup)
- [The single most important rule](#the-single-most-important-rule)
- [ESE Plugin (if installed)](#ese-plugin-if-installed)
- [How to create new ESE artifacts](#how-to-create-new-ese-artifacts)
- [How to edit existing artifacts](#how-to-edit-existing-artifacts)
- [Pre-commit checks](#pre-commit-checks)
- [Continuous integration](#continuous-integration)
- [Writing standards](#writing-standards)
- [Commit discipline](#commit-discipline)
- [Release discipline](#release-discipline)
- [Upgrading from a newer ese-starter](#upgrading-from-a-newer-ese-starter)
- [Bumping the ESE submodule](#bumping-the-ese-submodule)
- [Where the normative standard lives](#where-the-normative-standard-lives)

## Bootstrap (first-time setup)

**Before doing any other work, check whether this project needs bootstrapping.** Run this check:

```
grep -q '{Project Name}\|{X\.Y\.Z}\|"YYYY-MM-DD"' docs/standards-application.md 2>/dev/null && echo "NEEDS BOOTSTRAP" || echo "Already bootstrapped"
```

If the output is `NEEDS BOOTSTRAP`, the project has unfilled ESE placeholders. Run the bootstrap script before doing anything else:

**If you are in a fresh ese-starter clone** (the repo already has scripts/, docs/, .standards/):

```
bash scripts/bootstrap.sh --name "PROJECT NAME" --owner "OWNER" --contact "CONTACT"
```

**If you are adopting ESE into an existing project** (run this from the ese-starter directory, targeting the other repo):

```
bash scripts/bootstrap.sh --target /path/to/your-project --name "PROJECT NAME" --owner "OWNER" --contact "CONTACT"
```

The script fills all mechanical placeholders (dates, ESE version, owner, contact, project name), installs the pre-commit hook, and runs the linter suite. After bootstrap, all 12 linters pass.

**What to customize after bootstrap** (these require project-specific knowledge the script cannot infer):

1. `docs/standards-application.md`: fill in the 8 project first principles, set capability booleans (`has-runtime-service`, `contains-logic-code`, etc.) to `true` for capabilities your project actually has, and set addenda booleans to `true` for applicable contexts
2. `docs/setup.md`: replace the remaining `{placeholder}` fields with your actual setup steps, prerequisites, and environment variables
3. `docs/deployment.md`: fill in if your project deploys to production (skip if it does not)
4. `docs/runbook.md`: fill in if your project runs a persistent service (skip if it does not)

## The single most important rule

**Use `bash scripts/new-artifact.sh TYPE "Title"` to create any new artifact from an ESE template. Do not hand-copy templates.**

This is the one convention that, if violated, produces artifacts that will fail `lint-template-compliance.sh` on the next commit. The scaffolding tool reads the ESE template from `.standards/templates/`, pre-fills placeholders, and writes to the correct path per `scripts/template-instance-mappings.txt`. Hand-copying drops sections, renames headings, or puts the file in the wrong location.

Run `bash scripts/new-artifact.sh --list` to see every available type.

## ESE Plugin (if installed)

When the `ese-plugin` is installed as a Claude Code plugin, it provides lifecycle skills that operationalize ESE. The plugin turns the standard's requirements into an interactive workflow that routes you through each lifecycle stage.

**Mandatory directive:** on every user message, BEFORE any other tool call, invoke `ese-plugin:work-item-lifecycle` using the Skill tool. This is not optional. Every user message is a work request until proven otherwise.

The lifecycle skill handles stage routing automatically. It determines where you are in the DISCOVER-DEFINE-DESIGN-BUILD-VERIFY-DOCUMENT-DEPLOY-MONITOR-CLOSE lifecycle and dispatches to the correct procedure for each stage. You do not need to pick the right chain yourself.

The plugin and the static scripts are complementary, not redundant. The plugin handles workflow routing, stage gates, and process decisions. The scripts (`new-artifact.sh`, `verify.sh`, the `lint-*.sh` suite) handle artifact scaffolding and validation. Use both: the plugin tells you what to do; the scripts create and check the artifacts.

**Rationalization prevention:** these thoughts mean you are about to skip the lifecycle invocation. Stop and invoke it.

| Thought | Reality |
|---|---|
| "This is just a simple question" | Every message is work. Invoke `work-item-lifecycle`. |
| "I need more context first" | The lifecycle skill tells you HOW to gather context. Invoke it first. |
| "ESE is overkill for this" | The skill has quick-exit paths for small changes. Let it decide, not you. |
| "Let me explore the codebase first" | The lifecycle determines how to explore. Invoke before exploring. |

## How to create new ESE artifacts

| When you need | Run |
|---|---|
| A new Architectural Decision Record | `bash scripts/new-artifact.sh adr "Short decision name"` |
| A new DFMEA (design failure mode analysis) | `bash scripts/new-artifact.sh dfmea "Feature name"` |
| A new PFMEA (process failure mode analysis) | `bash scripts/new-artifact.sh pfmea "Process name"` |
| A new investigation for an unknown-cause defect | `bash scripts/new-artifact.sh investigation "Brief problem"` |
| A new PRD for a feature | `bash scripts/new-artifact.sh prd "Feature name"` |
| A new product capabilities doc | `bash scripts/new-artifact.sh capabilities "Capability name"` |
| A new problem research doc | `bash scripts/new-artifact.sh problem-research "Problem name"` |
| A new work-session log (for significant sessions) | `bash scripts/new-artifact.sh work-session-log "Session focus"` |
| A new post-mortem (after P0/P1 resolution) | `bash scripts/new-artifact.sh post-mortem "Incident name"` |
| A new compliance review (on cadence) | `bash scripts/new-artifact.sh compliance-review "Review period"` |
| A new work item export (at CLOSE per ADR-019) | `bash scripts/new-artifact.sh work-item-export "Work item ID"` |

After the tool creates the file, edit it to fill in remaining placeholders (those the tool cannot infer, like owner details, body content, and evaluation criteria). Then run `bash scripts/lint-template-compliance.sh` before committing.

## How to edit existing artifacts

**`docs/standards-application.md` (the project applicability document):** edit the YAML frontmatter at the top AND the corresponding prose section in the same commit. They must stay consistent. The `lint-standards-application-frontmatter.sh` linter enforces this at commit time.

- Capability change (e.g., the project gains a runtime service): update `capabilities.has-runtime-service: true` in YAML AND the Component Capabilities Declaration table's Present? cell to Yes.
- Addendum adoption: update `addenda.X: true` in YAML AND the Applicable Addenda table's Applies? cell to yes.
- FMEA threshold change: update `fmea.rpn-threshold` / `fmea.severity-threshold` in YAML AND the FMEA Thresholds prose section.
- Compliance review performed: bump `compliance-review.last-review-date` AND the footer `*Last compliance review:*` line.
- Submodule bumped: bump `ese-version` AND the footer `*Standard version applied:*` line.

**Other living documents** (`docs/setup.md`, `docs/deployment.md`, `docs/runbook.md`, `docs/intake-log.md`, `docs/incidents/lessons-learned.md`, `docs/incidents/anti-patterns.md`): edit directly. These are starter forms from `.standards/starters/` and their shape is enforced by `lint-template-compliance.sh`, which checks that each instance has every non-optional `##` section from its starter.

**ADRs, FMEAs, investigations, PRDs, and other template-based artifacts:** edit only the body content; preserve the heading shape defined by the template. If a heading is missing, `lint-template-compliance.sh` fails. If a heading no longer applies to this specific instance, mark it with `<!-- omit-section: Name -->` inline with a one-line rationale.

## Pre-commit checks

The `scripts/pre-commit` hook runs automatically on every `git commit` (if installed). It runs the relevant subset of the 12 vendored linters based on which files are staged. If a linter fails, the commit is blocked until you fix the violation.

To run the full linter suite manually, use the verification wrapper:

```
bash scripts/verify.sh
```

This runs every `scripts/lint-*.sh` in sequence and prints a pass/fail summary. Supports `--quiet` and `--json` output modes. Gate failures set the exit code; advisory linters do not.

You can also run any individual linter:

```
bash scripts/lint-standards-application-frontmatter.sh
bash scripts/lint-template-compliance.sh
bash scripts/lint-fmea-congruence.sh
bash scripts/lint-orphan-adrs.sh
bash scripts/lint-changelog-tags.sh
bash scripts/lint-orphan-scripts.sh
bash scripts/lint-readme-structure.sh
bash scripts/lint-count-congruence.sh
bash scripts/lint-release-existence.sh
bash scripts/lint-vsm-baseline-reference.sh
bash scripts/lint-agent-config.sh
bash scripts/lint-named-owner-integrity.sh
```

To install the pre-commit hook (required once per checkout):

```
ln -sf ../../scripts/pre-commit .git/hooks/pre-commit
```

## Continuous integration

Every bootstrapped repo inherits `.github/workflows/ci.yml`, a GitHub Actions workflow that runs the full ESE linter suite on every pull request and on every push to `main`. The workflow invokes `bash scripts/verify.sh` as a single step; `verify.sh` auto-discovers every `scripts/lint-*.sh` and runs them in sequence, so any linter vendored into `scripts/` (or newly added by an ese-starter upgrade) is picked up automatically, without editing the workflow file.

The workflow checks out the repository with `fetch-depth: 0` so the full tag history is available to `lint-changelog-tags.sh`; a shallow clone would mask tag-to-CHANGELOG mismatches. It also checks out the `.standards/` submodule (which vendors templates, addenda, and the normative `STANDARDS.md` at a pinned commit) and reports the pinned tag or commit in the job log for audit.

**Interpreting failures.** When the quality-gate job fails, open the failing step. Each linter prints one of: a `PASS` line, a skipped message (when the linter's preconditions are not met in this repo), or a detailed failure with the specific file and line that drove the failure. Fix the underlying file and push again. Do not modify the linter to make the failure go away; the vendored linters are upgraded through ese-starter, not per-repo.

**Extending without breaking the gate.** If your project needs a project-specific check that is not part of the ESE linter suite, add it as its own workflow step *after* the `verify.sh` step, not in place of it. Do not edit the vendored linters or delete steps from the workflow; both are overwritten by `bash scripts/bootstrap.sh --upgrade` when a new ese-starter release lands. If a vendored linter is not appropriate for your project, downgrade it to advisory via the `ADVISORY` array inside `scripts/verify.sh` instead of removing it from the workflow.

## Writing standards

These rules apply to every markdown file in this repo (and are enforced by the ESE content-boundary conventions):

1. **No Unicode em dashes (U+2014) or en dashes (U+2013).** Use semicolons, colons, parentheses, or restructured sentences. CI catches these.
2. **No ASCII double-hyphen sentence dashes** (space-hyphen-hyphen-space pattern). Same replacements.
3. **No smart quotes.** Use straight quotes only: `"` and `'`.
4. **No person names in normative content.** The named owner field in `docs/standards-application.md` is the only place for an operator name.
5. **No absolute paths in living documents.** Use relative paths from the repo root.
6. **Plain hyphens only** for compound words and CLI flags.

## Commit discipline

1. **Commit message format:** `type: description` or `type(scope): description`. Types: `feat`, `fix`, `docs`, `refactor`, `chore`, `test`. Body explains WHY.
2. **No AI attribution in commits.** No `Co-Authored-By` trailers, no "Generated with" lines. The human gate authority authors commits.
3. **One logical change per commit.** Do not bundle unrelated changes.
4. **Do not skip hooks.** If a linter fails, fix the issue and create a NEW commit (not `--amend`).
5. **CHANGELOG entry** required for any significant change.
6. **Do not push without explicit authorization** unless the project's own policy permits routine pushes.

## Release discipline

Projects following ESE use [Semantic Versioning](https://semver.org). Bootstrap creates a `CHANGELOG.md` with an `[Unreleased]` block; the `lint-changelog-tags.sh` linter validates that every version heading in the CHANGELOG has a matching git tag and vice versa.

**Cutting a release:**

1. Move entries from `[Unreleased]` into a new `## [X.Y.Z] - YYYY-MM-DD` heading.
2. Commit: `git commit -m "chore: cut vX.Y.Z release"`.
3. Tag: `git tag -a vX.Y.Z -m "vX.Y.Z"`.
4. Verify: `bash scripts/verify.sh` (lint-changelog-tags.sh confirms tag-to-CHANGELOG congruence).

Tag congruence is enforced by CI, not by the pre-commit hook (the tag cannot exist before the commit it annotates).

The gate authority (not an agent) decides when to cut a release. Agents may propose a release but must not execute one without explicit instruction.

**Version bump rules** (per [Semantic Versioning](https://semver.org)):

| Bump | When |
|------|------|
| **Major** (X) | Breaking changes to public interfaces or behavior |
| **Minor** (Y) | New functionality, backward-compatible |
| **Patch** (Z) | Bug fixes, documentation corrections, internal refactors with no behavior change |

**Release trigger policy** (REQ-4.3-06): if this project publishes versioned releases, document the release trigger policy in an ADR. Use `bash scripts/new-artifact.sh adr "Release trigger policy"` to scaffold one. The ADR states (a) what conditions cut a new version, (b) who authorizes the cut, and (c) how patch, minor, and major bumps are assigned. The ESE reference policy lives at `.standards/docs/decisions/ADR-2026-04-11-release-trigger-policy.md`.

## Upgrading from a newer ese-starter

The `.standards/` submodule tracks ESE itself (the normative standard). But vendored scripts, CI config, the pre-commit hook, and this CLAUDE.md file come from **ese-starter** and have no automatic update channel. When ese-starter ships improvements (new linter behavior, release forcing functions, pre-commit fixes), existing adopters must upgrade manually.

To upgrade an existing ESE-adopting repo to the latest ese-starter:

```
bash <PATH-TO-ESE-STARTER>/scripts/bootstrap.sh --upgrade --target .
```

This re-copies scripts/, .github/, CLAUDE.md, and the pre-commit hook from ese-starter. It does NOT touch docs/, CHANGELOG.md, or the .standards submodule. After copying, it runs `verify.sh` and warns if no versioned releases exist.

Review the diff (`git diff`) before committing. If you added project-specific sections to CLAUDE.md, re-apply them from git history.

## Bumping the ESE submodule

When Dependabot opens a PR to bump `.standards/`:

1. **Preview what changed** by running `bash scripts/catchup.sh` with the submodule already bumped in the PR branch. This shows a oneline commit log and bucketed file-change summary scoped to adopter-relevant paths (STANDARDS.md, addenda, templates, starter scripts, CHANGELOG). Much faster than reading the raw diff.
2. **Read the diff** in `.standards/CHANGELOG.md` between the old and new ESE tags. Check for new required sections in templates or new REQ-IDs in `STANDARDS.md`.
3. **Run the drift detector**: `bash scripts/upgrade-check.sh`. This reports (a) submodule pin delta against origin, (b) declared `ese-version` field vs pinned submodule tag, (c) per-file drift between your vendored `scripts/lint-*.sh` / `scripts/new-artifact.sh` / `scripts/template-instance-mappings.txt` / `docs/standards-application.md` and their upstream counterparts. Any Dimension 3 drift is a file you need to either re-copy from upstream or explicitly keep customized.
4. **Let CI run** on the Dependabot branch. If `lint-template-compliance.sh` fails, the templates changed and your existing instances need updating. The failure message names the specific files and sections.
5. **Fix any drift** by editing the affected instances (add the new section, or mark it omitted), re-copying vendored files if upstream moved, and/or updating `ese-version` in `docs/standards-application.md`. Push to the Dependabot branch.
6. **Bump `ese-version` in `docs/standards-application.md`** to match the new submodule tag. The field appears in the YAML frontmatter at the top of the file AND in the footer `*Standard version applied:*` line. `lint-standards-application-frontmatter.sh` Tier 3a enforces this match.
7. **Re-run `bash scripts/verify.sh`** locally to confirm the full linter suite passes against the bumped state before merging.
8. **Merge the PR** once CI passes.

Never merge a Dependabot submodule bump with CI failing.

## Where the normative standard lives

- [`.standards/STANDARDS.md`](.standards/STANDARDS.md): the nine-section standard. Read-only; updates via Dependabot.
- [`.standards/docs/addenda/`](.standards/docs/addenda/): domain-specific extensions (AI, web, multi-service, multi-team, containerized, event-driven, continuous improvement).
- [`.standards/templates/`](.standards/templates/): templates for every artifact type. Accessed via `scripts/new-artifact.sh`.
- [`.standards/docs/adoption.md`](.standards/docs/adoption.md): the adoption guide and operational reference.
- [`.standards/docs/decisions/`](.standards/docs/decisions/): ESE's own ADRs. Useful background when a behavior seems surprising.

**When a question is "what does ESE require of this artifact":** the answer lives in the submodule.
**When a question is "what has this project committed to":** the answer lives in `docs/standards-application.md` in this repo.
