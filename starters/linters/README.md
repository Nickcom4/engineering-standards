# ESE linter starter pack

Portable versions of the ESE internal linters, parameterized for adopter use. Copy the scripts you want once at adoption time, configure them for your project layout, and wire them into your CI pipeline.

## Table of Contents

- [What is in this directory](#what-is-in-this-directory)
- [When to use these](#when-to-use-these)
- [Adoption protocol](#adoption-protocol)
- [Parameterization](#parameterization)
- [Wiring into your CI](#wiring-into-your-ci)
- [Upgrading](#upgrading)

## What is in this directory

Each linter in this pack is a standalone bash script that catches a specific class of drift between documentation, generators, and on-disk state. They are functionally equivalent to the ESE-internal linters under `scripts/` but parameterized so they work against any repo layout.

| Script | What it catches | ESE internal counterpart |
|---|---|---|
| `lint-template-compliance.sh` | Instances that do not contain every non-optional `##` section from their template (e.g., an ADR missing the Context section, a work-session log missing "What Failed") | `scripts/lint-template-compliance.sh` |
| `template-instance-mappings.txt.starter` | Example config for `lint-template-compliance.sh` showing how to map your artifact types to ESE templates | `scripts/template-instance-mappings.txt` |
| `lint-fmea-congruence.sh` | FMEAs whose declared state overstates the actual state: status "Complete" with uncontrolled above-threshold FMs, RPN Tracking Table columns short of the declared iteration, main-table RPN mismatched with the latest tracking value, and `[x]` controls without a verification token | `scripts/lint-fmea-congruence.sh` |
| `lint-orphan-adrs.sh` | Accepted or Proposed ADRs not referenced from any living document. Advisory (warns, does not block) so a terminal ADR can be acknowledged with a `cross-reference-free: intentional` frontmatter line | `scripts/lint-orphan-adrs.sh` |
| `lint-changelog-tags.sh` | CHANGELOG versioned headings without matching git tags, and git tags without CHANGELOG headings. Supports a `CHANGELOG_TAGS_FLOOR` environment variable for projects with inconsistently-tagged historical releases | `scripts/lint-changelog-tags.sh` |
| `lint-orphan-scripts.sh` | Lint/validate/generate scripts in `scripts/` that are not wired into BOTH the CI workflow AND the project agent context file (CLAUDE.md, AGENTS.md, or similar). Auto-detects the agent context file; allowlist is overrideable | `scripts/lint-orphan-scripts.sh` |
| `lint-readme-structure.sh` | Bidirectional README Structure drift: every listed path exists on disk (forward) AND every top-level file or directory is listed in README Structure or in the exclusion list (reverse) | `scripts/lint-readme-structure.sh` |
| `lint-count-congruence.sh` | "N gates/checks/scripts" claims in living documents that no longer match their authoritative generator (enforcement-spec gate count, CI workflow check markers, `scripts/*.sh` count). Each check is independently toggleable by setting the relevant source path to an empty string | `scripts/lint-count-congruence.sh` |
| `lint-standards-application-frontmatter.sh` | `docs/standards-application.md` YAML applicability frontmatter drift. Three tiers: (Tier 1) presence, types, enums, ISO date formats, numeric range for FMEA thresholds. (Tier 2) YAML ↔ prose consistency: Component Capabilities Declaration table, Applicable Addenda table, FMEA Thresholds prose, §4.1 Verification Mode prose, owner citation, footer version/date lines. (Tier 3) claim-vs-reality: `ese-version` pin matches the vendored ESE submodule's `CHANGELOG.md` latest heading (NOT your own project changelog), `template-compliance.evidence` script exists and is wired into CI, addendum REQs not positively cited when the addendum is declared inactive. Parameterized via `PROJECT_ROOT`, `ESE_ROOT`, `APPLICATION_FILE`, `CHANGELOG_PATH`, `CI_WORKFLOW` | `scripts/lint-standards-application-frontmatter.sh` |
| `lint-vsm-baseline-reference.sh` | Improvement work items (`type: improvement` in YAML frontmatter) whose Dependencies table does not cite a resolvable baseline VSM under the configured archive directory. Anchors REQ-ADD-CI-01 (continuous-improvement addendum). Ships with `# status: shadow` in the header; records findings for auditability without blocking the build until the adopter promotes by flipping the status and wiring the exit code. Parameterized via `PROJECT_ROOT`, `WORK_ITEMS_DIR`, `VSM_DIR` | `scripts/lint-vsm-baseline-reference.sh` |
| `lint-agent-config.sh` | Agent-assisted-development posture files (CLAUDE.md, AGENTS.md, .cursorrules, .agent.md by default) missing one of six required posture statements: posture-file existence, agent-authority declaration, gate-authority review pathway, approval-boundary statement, credential-handling statement, revocation-path statement. Applies only when `standards-application.md` declares `addenda.agent-assisted-development: true`; silent-passes otherwise. Anchors REQ-ADD-AAD-01..-08 (agent-assisted-development addendum). Detection is lexical with a small set of phrase patterns; refinement happens in the shadow phase before promotion to gate. Ships with `# status: shadow` in the header; records findings for auditability without blocking the build. Parameterized via `PROJECT_ROOT`, `APPLICATION_FILE`, `POSTURE_FILES` | `scripts/lint-agent-config.sh` |
| `lint-named-owner-integrity.sh` | Occurrences of the declared owner name (sourced from `standards-application.md` YAML `owner.name`) in normative artifact bodies (ADRs, post-mortems, A3s, investigations, PRDs, capabilities docs, FMEAs, architecture docs). Owner/deciders frontmatter within each artifact is legitimate and excluded; body occurrences are flagged. Silent-passes when no owner is declared, when the declared name is blank, or when no normative artifacts exist at the configured paths. Anchors REQ-2.4-01 (P15: every service has a discoverable named owner) paired with the ESE writing rule that the named-owner field is the only place for an operator name. Ships with `# status: shadow` in the header; records findings for auditability without blocking the build. Parameterized via `PROJECT_ROOT`, `APPLICATION_FILE`, `ARTIFACT_DIRS`, `MAX_FINDINGS` | None yet; ESE-internal mirror deferred pending gate-authority decision on the 27 pre-existing positional violations |

Eleven drift-detection linters are available in this pack. Ten map 1:1 to an ESE-internal counterpart under `scripts/` (parameterized for adopter reuse); one (`lint-named-owner-integrity.sh`) ships first in the starter pack, with the ESE-internal mirror deferred pending a separate gate-authority decision on pre-existing positional violations in ESE's own corpus. You do not need to vendor all eleven; adopt individually as your project produces the artifact types each one covers.

## When to use these

Adopt a linter from this pack when you already have at least one living instance of the artifact type it checks. For example:

- If your project produces ADRs, adopt `lint-template-compliance.sh` with the `adr` mapping to catch ADRs that drift from the current template.
- If you produce FMEAs, adopt it with the `fmea` mapping(s).
- If you have no living instances yet, defer adoption; the linter will pass trivially and the configuration overhead has no current benefit.

The goal of this pack is to give every adopter the same drift-detection surface that ESE uses on itself, so that quality, reliability, and congruence improve uniformly across all projects that adopt ESE.

## Adoption protocol

One-time setup per project:

1. **Vendor ESE as a git submodule** at a stable path (recommended: `.standards/`).

   ```
   git submodule add https://github.com/Nickcom4/engineering-standards .standards
   ```

2. **Copy the linter and its config starter** into your repo. The canonical destination is `scripts/` at your project root.

   ```
   cp .standards/starters/linters/lint-template-compliance.sh scripts/
   cp .standards/starters/linters/template-instance-mappings.txt.starter scripts/template-instance-mappings.txt
   chmod +x scripts/lint-template-compliance.sh
   ```

3. **Edit `scripts/template-instance-mappings.txt`** to match your project layout. Delete the example mappings for artifact types you do not produce; add project-local mappings for any templates that are specific to your project.

4. **Verify it runs** against your current state:

   ```
   bash scripts/lint-template-compliance.sh
   ```

   On first run you will likely see drift. For each violation:
   - Add the missing section to the instance, OR
   - Document the intentional omission inline in the instance with `<!-- omit-section: Name -->`, OR
   - If the whole instance is a frozen historical artifact, mark it exempt with `<!-- template-compliance: historical-exempt -->` followed by a one-line rationale comment.

5. **Wire into your CI pipeline.** See [Wiring into your CI](#wiring-into-your-ci) below.

6. **Commit the linter, the config, and any instance fixes** in the same commit. Reference this starter pack in your CHANGELOG entry so the audit trail is clear.

## Parameterization

`lint-template-compliance.sh` reads three environment variables with sensible defaults:

| Variable | Default | Purpose |
|---|---|---|
| `PROJECT_ROOT` | `git rev-parse --show-toplevel` (or `pwd` if not in git) | Your repo root. Instance globs are resolved against this unless they are absolute. |
| `ESE_ROOT` | `${PROJECT_ROOT}/.standards` | Where ESE is vendored. The `${ESE_ROOT}` token in the mappings file expands to this value. Override if you vendor ESE at a non-default path. |
| `LINTER_MAPPINGS_FILE` | `${PROJECT_ROOT}/scripts/template-instance-mappings.txt` | Path to the mapping config. Override if you keep the config elsewhere. |

All three can be set inline when running the linter:

```
ESE_ROOT=./vendor/ese bash scripts/lint-template-compliance.sh
```

## Wiring into your CI

The linter exits 0 on pass and 1 on failure, so it can be used as a standard CI gate. Minimum wiring (GitHub Actions):

```yaml
- name: Template compliance
  run: bash scripts/lint-template-compliance.sh
```

For pre-commit integration (catching drift before the commit lands), add a line to your pre-commit hook:

```
bash "$(git rev-parse --show-toplevel)"/scripts/lint-template-compliance.sh
```

The linter is fast (reads each instance file once) and has no external dependencies beyond `bash`, `awk`, and `grep`, so it is safe to run on every commit.

## Upgrading

When ESE releases a new version, the template section requirements may change (new required section added, an existing section marked optional, etc.). To upgrade:

1. Bump your ESE submodule to the new version.
2. Re-run `bash scripts/lint-template-compliance.sh` to see any new violations.
3. If a template added a required section, add it to your instances (or mark it omitted if it does not apply).
4. If ESE shipped an updated version of `lint-template-compliance.sh` itself, diff your copy against `${ESE_ROOT}/starters/linters/lint-template-compliance.sh` and port any improvements you want. Your copy is yours to own; upstream improvements are opt-in.

See `docs/adoption.md` in the ESE repo for the full version update protocol.
