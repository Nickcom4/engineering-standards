# Changelog

All notable changes to this standard are documented here. Follows [Semantic Versioning](https://semver.org).

---

## [Unreleased]

### Fixed
- `starters/standards-application.md` prose: replaced remaining placeholder values in the Component Capabilities Declaration table (`Yes/No` cells now default to `No`), the Applicable Addenda table (markdown-link labels simplified to plain text, default `no`), the FMEA Thresholds section (`{75 or project-specific value with rationale}` now renders as concrete `75`, same for severity), and the footer (`{version}` becomes `{X.Y.Z}` to match the YAML placeholder convention, `{date}` becomes `YYYY-MM-DD` for new-artifact.sh substitution, `{frequency}` becomes `every-significant-release` as a concrete default). Added a new `## §4.1 Template Compliance Verification Mode` section with `automated` mode and `scripts/lint-template-compliance.sh` as evidence, matching the ESE instance's corresponding section. Added "adopter action" callouts under each table explaining what to change and linking to the enforcement linter. These were all audit-found Step-2 closure gaps: the YAML schema was added in commit efee832 but the prose sections below still carried the pre-Step-2 placeholder forms that caused `lint-standards-application-frontmatter.sh` Tier 2 to fail on a naively-substituted adopter instance
- `scripts/lint-standards-application-frontmatter.sh` and `starters/linters/lint-standards-application-frontmatter.sh`: `parse_md_table` helper now strips markdown link syntax (`[Label](url)` -> `Label`) from cell values before matching against the label lookup tables. The Applicable Addenda table in the starter (and in some adopter instances) uses linked labels for cross-referencing the addendum docs; the prior parser saw `[Multi-Service Architectures](../docs/addenda/multi-service.md)` as the literal cell value and failed to match against the plain-text label `Multi-Service Architectures`. Discovered when running the adopter-facing smoke test on a fresh ese-starter instance
- `scripts/lint-changelog-tags.sh` and `starters/linters/lint-changelog-tags.sh`: bash 3.2 + `set -u` empty-array bug. When a project's CHANGELOG has zero versioned headings (e.g., a new starter-scaffolded project that has not yet cut its first release), the `CHANGELOG_VERSIONS` array expansion raised `unbound variable` and aborted the linter. Guarded the two loop expansions with explicit `[ ${#CHANGELOG_VERSIONS[@]} -gt 0 ]` length checks, mirroring the same fix applied to `lint-template-compliance.sh` in v2.4.0. Discovered while running the ese-starter repo's vendored copy of the linter against its initial CHANGELOG
- `scripts/new-artifact.sh` and `starters/tools/new-artifact.sh`: replaced a Unicode em dash (U+2014) in the header comment with a colon. The em dash was introduced in Phase D of v2.5.0 and slipped past CI Check 1 because the scan is scoped to `.md` files. Both the internal and adopter-starter copies of the script are fixed

### Added
- `starters/linters/lint-standards-application-frontmatter.sh`: adopter-portable version of the applicability frontmatter linter, the 8th script in the `starters/linters/` pack. Parameterized via `PROJECT_ROOT`, `ESE_ROOT`, `APPLICATION_FILE`, `CHANGELOG_PATH`, and `CI_WORKFLOW` env vars with sensible defaults. The most important difference from the internal ESE version: `CHANGELOG_PATH` defaults to `$ESE_ROOT/CHANGELOG.md` (the vendored submodule's changelog, NOT the adopter's own project changelog) because `ese-version` pins the ESE version not the adopter's own version. Without this parameterization, adopters would have their Tier 3a check comparing `ese-version` against their own CHANGELOG's latest heading, which has no ESE version entries and fails trivially. Tier 1 (presence, types, enums, ISO date format, numeric range), Tier 2 (YAML vs prose table consistency for capabilities, addenda, FMEA thresholds, verification mode, owner name, footer lines), and Tier 3 (evidence path existence and CI wiring, addendum REQ activation cross-check) mirror the internal version. Smoke-tested against engineering-standards itself with `ESE_ROOT=. CHANGELOG_PATH=CHANGELOG.md`; passes cleanly. `starters/linters/README.md` catalog table gains a row for the new linter. This unblocks the Step 3 ese-starter new repo which will vendor this linter from day one
- `starters/standards-application.md`: YAML applicability frontmatter schema propagated from `docs/standards-application.md` into the adopter-facing starter. The starter now ships with the same 12-field schema (`ese-version`, `last-updated`, `owner`, `compliance-review`, `capabilities`, `addenda`, `template-compliance`, `fmea`) where adopter-specific values appear as `{placeholder}` form and ESE-recommended defaults are populated in place: FMEA thresholds 75/7, compliance-review cadence `every-significant-release`, template-compliance mode `automated` with `scripts/lint-template-compliance.sh` as evidence. Boolean fields (`capabilities.*`, `addenda.*`) default to `false` (conservative opt-in; adopters explicitly declare every capability and addendum they turn on). Every field has an inline YAML comment explaining what it means and how to fill it, so adopters have field-by-field guidance without jumping to the instance file. The existing starter metadata (`type: starter`, `purpose`, `frequency`) is preserved at the top of the block with a "remove when copying" comment so the `starters/` classification convention stays consistent across all 8 starter files. The intro paragraph below the frontmatter now references the linter and explains that prose sections must stay consistent with the YAML block. Closes the Step-2 gap from the applicability-frontmatter arc: adopters who vendor this starter get the schema for free and can run the validator from day one. `scripts/lint-self-compliance.sh` still passes (the ESE instance has every starter `##` section). `scripts/lint-template-compliance.sh` still passes (37 instances across 13 mappings; no section drift)
- `docs/standards-application.md`: YAML frontmatter block that makes the document's applicability claims machine-readable. Fields: `ese-version` (semver pin matched against latest CHANGELOG heading), `last-updated`, `owner` (name + contact), `compliance-review` (cadence enum + last-review-date + next-review-trigger), `capabilities` (all 11 Component Capabilities Declaration booleans), `addenda` (all 7 addenda booleans), `template-compliance` (mode enum + evidence path), `fmea` (rpn-threshold + severity-threshold). Prose sections remain the human-readable rationale; the frontmatter is the machine-readable summary that future tools (upgrade-task generator, skill router, applicability reports) can consume without parsing prose. This is the structural improvement ESE needs in its own self-application doc before a starter project template can demonstrate the same pattern to adopters
- `scripts/lint-standards-application-frontmatter.sh` as CI Check 34: three-tier validator. Tier 1 verifies frontmatter presence, field types, enum membership (cadence, template-compliance mode), ISO date formats, and numeric range for FMEA thresholds. Tier 2 verifies internal consistency between the YAML block and the prose tables in the same file: Component Capabilities Declaration table cells must match `capabilities.*`, Applicable Addenda table cells must match `addenda.*`, FMEA Thresholds prose must match `fmea.rpn-threshold`/`severity-threshold`, §4.1 Verification Mode prose must match `template-compliance.mode` and cite the `template-compliance.evidence` path, and the footer "Standard version applied"/"Last updated" lines must match `ese-version`/`last-updated`. "Yes"/"No" prose cells are normalized to booleans during comparison so the prose stays human-readable and the YAML stays strict. Tier 3 verifies claim-vs-reality across the repo: `ese-version` equals the latest non-[Unreleased] CHANGELOG heading; `owner.name` does not appear in any normative doc (STANDARDS.md, addenda, templates, starters); `template-compliance.evidence` script exists on disk and its basename appears in `.github/workflows/ci.yml`; and for each addendum declared `false`, no `REQ-ADD-<TOKEN>-NN` ID (AI, MS, MT, WEB, CTR, EVT, CI) appears anywhere in `docs/standards-application.md` itself (addendum REQs should not be positively cited when the addendum is inactive). Tested against five negative mutations and all five were caught (capability drift, ese-version drift, missing required field, bad enum, inactive addendum REQ citation). Wired as CI Check 34, into `scripts/pre-commit` when standards-application.md is staged, into CLAUDE.md "Before Every Commit" local suite, and into `docs/setup.md`

### Changed
- `scripts/lint-fmea-congruence.sh`: the ESE default FMEA thresholds (RPN=75, severity=7) are now read from the new `fmea:` block in `docs/standards-application.md` frontmatter, making standards-application.md the single source of truth for project-wide FMEA thresholds (REQ-2.1-48). The linter falls back to the ESE hardcoded defaults if the frontmatter is missing or lacks the fmea block. Adopter projects that vendor this linter via the starter pack inherit the same pattern: change thresholds once in standards-application.md and every FMEA linter observes the change
- CI pipeline count: 33 → 34 (new standards-application frontmatter linter as Check 34)
- `CLAUDE.md` "About This Repo" and `README.md` Structure section: CI check count updated 33 → 34 to match

### Fixed
- `scripts/lint-standards-application-frontmatter.sh`: minimal YAML parser now strips trailing inline comments (`field: value  # comment`) from scalar values before type detection. The Step 1 parser (commit `f34d3ea`) compared raw regex capture groups against bool and int literals, which worked on `docs/standards-application.md` because that file's frontmatter has no inline comments, but failed against the new `starters/standards-application.md` whose fields carry per-line documentation. Ten unit tests cover quoted/unquoted, bool/int/string, hash-inside-quote (`"quoted # not a comment"` preserved), and trailing-whitespace-before-hash cases; all pass. Regression: the instance file still parses identically
- `scripts/lint-work-item-export.sh`: excludes `docs/work-items/active/` from the recursive scan so the ese-plugin session-local scratch file (which uses `templates/work-item.md` format, not the export format) does not fail the FM-08 round-trip gate. Matches the `.gitignore` pattern added for the same directory. Regression: a bad file at the top level of `docs/work-items/` is still caught (type mismatch + missing sections verified)
- `.gitignore`: added `docs/work-items/active/` (ese-plugin session-local scratch dir) alongside the existing `.ese-session-state.json` entry. The ese-plugin lifecycle chain writes a work-item.md here while a work item progresses through DEFINE -> BUILD -> VERIFY -> CLOSE; ESE's own convention per ADR-019 is that `docs/work-items/` holds exported closed work items only, so the active scratch stays out of the tree
- `starters/standards-application.md` date placeholders: changed `last-updated: "{YYYY-MM-DD}"` and `compliance-review.last-review-date: "{YYYY-MM-DD}"` to bare `"YYYY-MM-DD"` (no curly braces). Reason: `scripts/new-artifact.sh` does `content.replace('YYYY-MM-DD', today)` as a substring substitution at scaffold time, which turned the braced form into `"{2026-05-01}"` (curly braces preserved around the substituted date) and produced a value that failed the linter's Tier 1 ISO date format regex. Bare `"YYYY-MM-DD"` is the pre-existing ESE convention for date placeholders (used 6 times in the starter's own prose tables) and substitutes cleanly to today's date at scaffold time. Smoke-tested end-to-end: scaffolded starter + manual placeholder fill + Tier 1 validator yields a file whose `last-updated` and `last-review-date` are both valid ISO dates. Audit-discovered gap during Step 2 closure

## [2.5.0] - 2026-04-11

**Theme:** Adopter template-compliance framework closure: obligation layer (REQ-4.1-02/03), scaffolding tool (new-artifact.sh for internal and adopter use), expanded adopter linter pack (7 portable drift linters), Phase A cleanup (4 redundant per-template linters retired), and integration of the template-compliance REQs across the compliance-review template, adoption checklist, standards-application, and agent context.

### Added
- `starters/tools/` directory (new starter subcategory): adopter-facing workflow tools. `starters/tools/new-artifact.sh` is the parameterized adopter-portable version of `scripts/new-artifact.sh`, accepting `PROJECT_ROOT`, `ESE_ROOT`, and `LINTER_MAPPINGS_FILE` env vars with sensible defaults. Shares `scripts/template-instance-mappings.txt` with the template-compliance linter so one config file drives both where new instances go and what sections they must contain. Tested end-to-end in an isolated adopter setup: `--list`, ADR scaffold, DFMEA scaffold, correct `{type}` substitution, correct filename derivation (date-prefix or no-prefix based on instance glob). `starters/tools/README.md` documents the adoption protocol, parameterization, placeholder reference, and the shared-mapping relationship with the linter pack. `docs/adoption.md` First Steps After Adoption, Step 1 now mentions the tool pack alongside the linter pack
- `scripts/new-artifact.sh`: scaffolding tool for new instances of ESE templates (Phase D of the template-compliance framework). Reads `scripts/template-instance-mappings.txt` to look up the template and output directory for a given artifact type, copies the template, substitutes common placeholders (`YYYY-MM-DD` → today, `{Title}`/`{title}` → provided title, `{number}` → date-slug, `{owner}` → git user.name, `{type}` → label uppercased, `{Feature or Process Name}` → title), and writes the result to a date-prefixed path derived from the instance glob. Supports `--list` to enumerate available types, `--output PATH` to override destination, `--no-open` to skip auto-opening in `$EDITOR`. Usage: `bash scripts/new-artifact.sh adr "Deprecate old logger"` creates `docs/decisions/ADR-2026-04-11-deprecate-old-logger.md` pre-filled. Addresses the copy-paste friction root cause for template adoption identified in the original Phase C/D framing
- Added `new-artifact.sh` to `scripts/lint-orphan-scripts.sh` ALLOWLIST with rationale: scaffolding tool invoked manually by users, not a gate
- `STANDARDS.md` §4.1: new **REQ-4.1-02** (gate) and **REQ-4.1-03** (artifact) closing Phase C of the template-compliance framework. REQ-4.1-02 obligates every documented artifact created from a template to contain every non-optional section from its template or document each omission inline. REQ-4.1-03 obligates projects to choose and document their verification mode (automated check or compliance review activity) in standards-application.md. This is the adopter-facing obligation layer that v2.4.0's Phase B starter pack and v2.5.0's `docs/adoption.md` integration enable: ESE now both REQUIRES template compliance (Phase C) and PROVIDES the portable linter to satisfy the requirement (Phase B). Supporting prose added to §4.1 explaining the generating principle: a template with drifting instances is indistinguishable from no template at all. REQ-4.1-02 is `kind:gate` and adds 1 to the enforcement-spec gate count; REQ-4.1-03 is `kind:artifact`. Total REQ count 734 → 736; active REQ-IDs 600 → 602; gates 312 → 313

### Removed
- `scripts/lint-fmea-template.sh`, `scripts/lint-arch-doc.sh`, `scripts/lint-standards-application.sh`, `scripts/lint-template-drift.sh`: retired 4 per-template section-check linters whose entire function is now subsumed by `scripts/lint-template-compliance.sh`. The generic linter's mapping file covers each of the four scopes they handled (FMEAs, architecture docs, standards-application starter instance, and the 3 starter→instance mappings). The fifth per-template linter, `lint-session-artifacts.sh`, is retained because it accepts historical heading variants ("What Was Done", "Actions", etc.) that the generic linter does not. This closes the Phase A deferred cleanup item
- 4 CI check slots (old Checks 15, 22, 27, 31) removed from `.github/workflows/ci.yml`; remaining checks renumbered 1-33 so slots are contiguous. Quality gate summary line updated to list the 33 current checks
- 4 entries removed from CLAUDE.md "Before Every Commit" local suite
- 2 entries removed from `docs/setup.md` local run list (replaced with the generic linter and related additions)

### Changed
- CI pipeline count: 37 → 33 (4 retired per-template linters, no functional loss since the generic `lint-template-compliance.sh` covers all 4 scopes)
- `CLAUDE.md` "About This Repo" and `README.md` Structure section: CI check count updated 37 → 33 to match
- `scripts/lint-template-compliance.sh` header comment: updated to note the 4 retired linters and that `lint-session-artifacts.sh` remains in place for its historical-variant handling

### Added
- `docs/adoption.md`: wired the `starters/linters/` pack into the main adoption guide. "First Steps After Adoption" step 1 now tells adopters to vendor linters from `starters/linters/` alongside the required starter files, with a pointer to `starters/linters/README.md` for the adoption protocol. "Staying Current" gained a "check for new linters" note so adopters review `starters/linters/README.md` for additions on every ESE version bump. Closes the Phase B deferred item from commit 3c43655: "Wire the starter into docs/adoption.md version update protocol so adopters are told to run it on every ESE submodule bump"
- `starters/linters/` expanded with 6 additional portable linters, completing the port of ESE's drift-detection suite to adopter-facing form. Adopters can now vendor any of the seven linters individually:
  - `starters/linters/lint-fmea-congruence.sh`: parameterized version of `scripts/lint-fmea-congruence.sh`. Accepts `PROJECT_ROOT`, `FMEA_DIR`, `RPN_THRESHOLD`, `SEV_THRESHOLD` env vars. Catches FMEAs whose declared state overstates the actual state
  - `starters/linters/lint-orphan-adrs.sh`: parameterized version of `scripts/lint-orphan-adrs.sh`. Auto-detects agent context files (CLAUDE.md, AGENTS.md, .cursorrules, .agent.md) and the search corpus from the project layout. Advisory exit code
  - `starters/linters/lint-changelog-tags.sh`: parameterized version of `scripts/lint-changelog-tags.sh`. Accepts `CHANGELOG_TAGS_FLOOR` for projects with inconsistently-tagged historical releases
  - `starters/linters/lint-orphan-scripts.sh`: parameterized version of `scripts/lint-orphan-scripts.sh`. Auto-detects agent context file; `ORPHAN_ALLOWLIST` env var allows per-project helper exemptions
  - `starters/linters/lint-readme-structure.sh`: parameterized version of `scripts/lint-readme-structure.sh` (bidirectional). Accepts `README_EXCLUDE` env var for per-project exclusion customization
  - `starters/linters/lint-count-congruence.sh`: parameterized version of `scripts/lint-count-congruence.sh`. Each of the three count types (gates, CI checks, scripts) is independently toggleable by setting the corresponding source path env var to an empty string. Adopters without an enforcement-spec-style generator skip the gate check and still get the CI check + script count coverage
- Tested each new starter in an isolated simulated adopter project (fresh `/tmp` git repo with minimal README, CHANGELOG, ci.yml, AGENTS.md, one script, one ADR, one v0.1.0 tag). All four runnable linters behaved correctly: `lint-orphan-scripts` flagged the newly-copied scripts as unwired (expected post-adoption state), `lint-changelog-tags` PASS against the 0.1.0 tag, `lint-readme-structure` FAIL on reverse check for unlisted directories (expected minimal-README state), `lint-orphan-adrs` WARN (advisory) for the solitary ADR with no cross-references
- `starters/linters/README.md`: table of all seven linters updated with their what-it-catches descriptions and ESE internal counterparts

### Changed
- `README.md` Structure section: listed all seven linters under `starters/linters/` instead of only the first one

## [2.4.0] - 2026-04-11

**Theme:** Template-compliance framework (generic internal linter, adopter-portable starter pack) and FMEA congruence linter to catch FMEAs whose declared state overstates the actual state.

### Added
- `scripts/lint-fmea-congruence.sh` as CI Check 37: FMEA congruence linter. Catches a specific class of FMEA drift where the document's declared state overstates the actual state. Four checks: (1) status-threshold congruence: if status is "Complete" or "Closed", every FM above RPN or Severity threshold must have a stated control (in Action column or Controls Summary); (2) iteration column coverage: if status/narrative references iteration N, the RPN Tracking Table must have at least N Iter columns; (3) current-RPN congruence: the bolded current RPN in the main FM table must equal the latest non-dash Iter column value in the RPN Tracking Table for that FM; (4) control verification: every `[x]` control in Controls Summary must have a verification token (script path with or without `scripts/` prefix, commit SHA, vault-ID, REQ-ID, ADR reference, CI Check number, template/starter/docs path, or explicit `N/A`). Complements the existing FMEA linters (consistency, controls, completeness, template) which each check narrower slices
- `starters/linters/` directory: adopter-facing linter starter pack. This is Phase B of the template-compliance work from the Phase A internal linter. Adopters vendor individual scripts into their own projects at adoption time, configure via a starter mapping file, and wire into their own CI. The linters are parameterized to work against any repo layout via `PROJECT_ROOT`, `ESE_ROOT`, and `LINTER_MAPPINGS_FILE` environment variables with sensible defaults
- `starters/linters/lint-template-compliance.sh`: portable template-compliance linter. Functionally equivalent to `scripts/lint-template-compliance.sh` but parameterized. Reads template references from the vendored ESE submodule (`${ESE_ROOT}/templates/*.md`) or the adopter's own local templates, resolves instance globs relative to `${PROJECT_ROOT}`, supports both the `<!-- omit-section: Name -->` per-section and `<!-- template-compliance: historical-exempt -->` whole-file opt-out markers. Tested end-to-end in an isolated adopter project layout (5 scenarios: drift detection, drift fix, omit-section, historical-exempt, ESE_ROOT env override); all pass
- `starters/linters/template-instance-mappings.txt.starter`: example mapping config with entries for every ESE template that has an instance-glob pattern (adr, fmea, architecture-doc, work-session-log, post-mortem, work-item, compliance-review, product-layer templates, a3, slo, tech-eval, and starter-driven living documents). Adopters copy this to `scripts/template-instance-mappings.txt` and edit for their project layout
- `starters/linters/README.md`: adoption protocol and parameterization guide. Documents the one-time-copy pattern, the env var interface, CI wiring examples, and the upgrade protocol when ESE bumps a template
- `scripts/template-instance-mappings.txt`: added 4 mappings for product-layer templates that were missed in the initial Phase A pass (`templates/capabilities.md` -> `docs/product/capabilities-*.md`; `templates/prd.md` -> `docs/product/prd-*.md`; `templates/investigation.md` -> `docs/product/investigation-*.md`; `templates/problem-research.md` -> `docs/product/problem-research-*.md`). These are the §1.2 product-layer templates that have living instances in `docs/product/` from ESE's own machine-readable-first restructuring work. After this correction, internal template-compliance coverage is 10 of 15 templates (the remaining 5 (a3, post-mortem, slo, tech-eval, work-item) have zero instances in ESE and can only be covered by Phase B adopter-facing linters)
- `scripts/lint-template-compliance.sh`: new `<!-- template-compliance: historical-exempt -->` opt-out mechanism. Instances that predate a template restructuring and are frozen as historical artifacts per the content-boundary convention can skip the section-compliance check by adding the marker at the top of the file with a one-line reason comment beneath it. Mirrors the existing `<!-- omit-section: Name -->` pattern but exempts the whole file rather than one section
- `scripts/lint-template-compliance.sh` as CI Check 36: generic template-instance compliance linter. Reads `scripts/template-instance-mappings.txt` (one line per `template | instance-glob | label` mapping) and verifies that every instance file contains every non-optional `##` section from its template. Covers ADRs, FMEAs (DFMEA and PFMEA variants), architecture docs, work item exports, compliance reviews, and starter-driven living docs (standards-application, deployment, setup). Optional sections in templates are marked with `<!-- optional -->` on the heading line; instances document intentional omissions with `<!-- omit-section: Name -->` inline. Config-driven so adding a new template-instance mapping requires a one-line edit to the mappings file, no code change
- `scripts/template-instance-mappings.txt`: registry of template-to-instance mappings consumed by `lint-template-compliance.sh`
- `templates/adr.md`: marked three scaffolding sections optional (`Per-Document Impact Analysis`, `Follow-on Requirements`, `Implementation Checklist`) via `<!-- optional -->` heading marker. These sections are conditionally required (per REQ-4.2-10 for impact analysis; per auth/payments/data/external trigger for follow-on FMEA; per "has an implementation path" for checklist) and not every ADR needs them
- `templates/architecture-doc.md`: marked ten sections optional (`Architecture Diagram`, `External Dependencies`, `Design Principles Applied`, `Team and Ownership Alignment`, `Architectural Decisions`, `Risk Analysis`, `Security`, `Future Implementor Notes`, `Fault Tree Analysis and Reliability (always-on services with SLOs)`, `Optional Sections`). The core required sections are Purpose, Intended Goals, Current State vs Intended State, Data Flows, Failure Modes, and Boundaries; the rest depend on what the component is

### Fixed
- `docs/decisions/DFMEA-2026-03-25-ese-machine-readable-first-restructuring.md`: three congruence drifts caught by the new FMEA congruence linter. (a) RPN Tracking Table extended from 10 Iter columns to 13 columns to cover the status-declared iteration 13; FMs added in iter 13 (FM-15 and FM-16) now have their RPN values in a proper Iter 13 column instead of being stashed in the Resolution column. (b) Existing FM rows carried forward unchanged values to the new Iter 11, 12, 13 columns (no score changes in those iterations for FM-01 through FM-14). (c) Two FM-12 Controls Summary entries ("All 15 templates have YAML frontmatter", "All 8 starters have YAML frontmatter") gained explicit verification tokens pointing to `templates/*.md`, `starters/*.md`, and CI Check 36 (`lint-template-compliance.sh`)
- `scripts/lint-template-compliance.sh`: fixed bash 3.2 + `set -u` empty-array bug. When an instance glob matched zero files, the script aborted with "unbound variable" at the `"${instance_files[@]}"` expansion. Guarded the array expansion with an explicit length check. The same fix is in the starter version; the bug was discovered during starter testing in an isolated adopter layout
- `docs/product/capabilities-ese-machine-readable-first.md` and `docs/product/prd-ese-machine-readable-first.md`: added `<!-- template-compliance: historical-exempt -->` markers with rationale comments. Both documents are v1.x-era product artifacts written before `templates/capabilities.md` and `templates/prd.md` were expanded to their current forms. The decisions they drove shipped with ADR-2026-03-25-ese-machine-readable-first-format and the v2.0.0 restructuring release. Frozen as historical artifacts per the content-boundary convention. The `investigation` and `problem-research` instances in the same directory were found to match their current templates cleanly and required no exemption
- `docs/decisions/ADR-2026-04-09-genuine-compliance-audit-remediation.md` and `docs/decisions/ADR-2026-04-11-release-trigger-policy.md`: renamed `## Alternatives` heading to `## Alternatives Considered` to match `templates/adr.md` section name used by the other 22 ADRs in the corpus (caught by the new generic template compliance linter on first run)
- `docs/deployment.md`: renamed `## Rollback Trigger (REQ-STR-43)` heading to `## Rollback Trigger` (moved the REQ-ID reference into the section body as a callout) so the heading matches `starters/deployment.md`. ToC entry updated. The parenthetical REQ-ID in the heading was causing the template-compliance linter to report a false section-missing violation
- `docs/compliance-review-2026-03-26.md`: added five `<!-- omit-section: -->` markers for sections that the current compliance-review template requires but this historical 2026-03-26 review (written against the earlier template) consolidated. The review is a historical snapshot of ESE v2.0.0 and is intentionally not retroactively restructured per the content-boundary convention for historical artifacts

## [2.3.0] - 2026-04-11

**Theme:** Drift-detection linter suite (4 new CI checks + 1 pre-commit hook enhancement + bidirectional extension of an existing linter) + stale-count linter scope extension. Follow-up to the v2.2.0 self-audit, hardening the repo against the specific drift classes that audit uncovered.

### Added
- `scripts/lint-orphan-scripts.sh` as CI Check 32: detects `lint-*.sh` or `validate-*.sh` scripts in `scripts/` that are not wired into both `.github/workflows/ci.yml` AND the CLAUDE.md "Before Every Commit" local suite. Catches the pattern from the v2.1.0→v2.2.0 window where 6 scripts lived unwired for an entire release and required a manual audit to discover. Allowlist exempts helpers (`ese-corpus-files.sh`) and non-gating generators (`generate-mode2-candidates.sh`, `generate-fmea-views.sh`) with one-line rationale per entry
- `scripts/lint-count-congruence.sh` as CI Check 33: asserts that every "N gates", "N checks", and "N scripts" claim in living documents (CLAUDE.md, README.md, docs/standards-application.md, docs/architecture/) matches the authoritative generator: `gate_count` field in `enforcement-spec.yml` for gates, count of `# Check N` markers in `.github/workflows/ci.yml` for checks, and `ls scripts/*.sh` for scripts. Complements `lint-stale-counts.sh` (which covers REQ-ID counts) to close the remaining machine-derivable count drift surface. Caught 2 stale script count references in docs/standards-application.md on first run; replaced with relative language to avoid churn when scripts are added
- `scripts/pre-commit`: release ceremony integrity check. When a staged `CHANGELOG.md` diff adds a new versioned heading (line matching `## [X.Y.Z] - YYYY-MM-DD`), the hook now requires `docs/standards-application.md` to also be staged in the same commit. Per ADR-2026-04-11, release ceremony commits must atomically move the CHANGELOG heading AND bump the standards-application.md "Standard version applied:" / "Last updated:" fields. Catches a ceremony split across commits or a forgotten dependent update before the commit lands
- `scripts/lint-orphan-adrs.sh` as advisory CI Check 35: detects Accepted or Proposed ADRs that are not referenced from any living document (STANDARDS.md, CLAUDE.md, README.md, CHANGELOG.md, standards-application.md, adoption.md, background.md, addenda, architecture docs, templates, starters, or other ADRs). Advisory only: an orphan ADR may be terminal by design, in which case adding `cross-reference-free: intentional` to its frontmatter acknowledges the orphan status. Searches for three identifier forms per ADR (full basename, frontmatter `id:` field, and short prefix like `ADR-010` or `ADR-2026-04-09`) since most references use the short forms. Current repo state: 24 Accepted ADRs, all referenced at least once
- `scripts/lint-changelog-tags.sh` as CI Check 34: verifies every versioned heading in `CHANGELOG.md` (at or after the tagging-era consistency floor of v2.1.0) has a matching annotated git tag, and every `vX.Y.Z` tag has a matching CHANGELOG heading. Catches release ceremony commits that forget to tag and stray tags with no CHANGELOG entry. Pre-v2.1.0 CHANGELOG versions are intentionally exempt: historical tagging was inconsistent (v1.7.0, v1.8.0 tagged; v1.9.0 through v2.0.0 untagged), and retroactive tagging is not historically recoverable. Floor is explicit and documented in the script so a future policy change can move it forward (never backward)

### Changed
- `scripts/lint-readme-structure.sh` (CI Check 23): extended from forward-only (README→disk) to bidirectional. The reverse check (disk→README) asserts that every top-level file or directory in the repo root is either listed in README.md Structure OR appears in the `README_STRUCTURE_EXCLUDE` set with a one-line rationale comment. Catches the case where a new top-level directory is added to the repo but README is not updated. Exclusion list covers: README.md itself (recursive), generated artifacts (enforcement-spec.yml, req-manifest.sha256, enforcement-spec-mode2-candidates.yml), operator configuration (.git, .gitignore, .DS_Store, .github), and gitignored runtime state (.ese-session-state.json, .gate-manifest.json)

### Fixed
- `docs/standards-application.md`: replaced two hardcoded "29 CI scripts" / "29 bash scripts" references with relative language ("CI scripts under `scripts/`" and "All bash scripts under `scripts/`") to avoid churn each time a new script is added. Count of scripts is now tracked only by the `lint-count-congruence` generator-side, not duplicated in prose. Caught by the new `lint-count-congruence.sh` on first run
- `scripts/lint-stale-counts.sh`: extended scan scope to include root-level living documents (CLAUDE.md, README.md, dependencies.md) and living docs under docs/ (standards-application.md, background.md, setup.md, deployment.md) that were previously unchecked. Also extended the regex to catch "N requirement(s)" and "N machine-readable requirement(s)" phrasings alongside the existing "N REQ-ID", "N total", and "N unique" patterns. Root cause: CLAUDE.md "About This Repo" said "733 machine-readable requirements" after REQ-4.3-06 took the count to 734, and the stale-count linter did not catch it because (a) CLAUDE.md was not in scope and (b) the regex did not match the "machine-readable requirements" phrasing. Post-v2.2.0 self-audit caught the drift manually
- `CLAUDE.md` "About This Repo": corrected stale REQ count from 733 to 734 (the drift caught by the extended linter above)

## [2.2.0] - 2026-04-11

**Theme:** CI expansion to 31 checks, release trigger policy (ADR-2026-04-11 + REQ-4.3-06), and living-document drift remediation accumulated since v2.1.0.

### Added
- `STANDARDS.md` §4.3: new **REQ-4.3-06** generalizing the release trigger policy requirement to all adopters. Projects that publish versioned releases must document a release trigger policy covering (a) cut conditions, (b) authorization, and (c) patch/minor/major bump assignment. Activation: the project publishes versioned releases. REQ kind is `artifact` (not `gate`) so no new enforcement-spec entry; total REQ count 733 → 734, active REQ-IDs 599 → 600, gates unchanged at 312. Supporting prose added to §4.3 explaining the generating principle (unwritten cadences are indistinguishable from random cadences from a consumer's perspective). This is the adopter-facing generalization of ESE's own policy in ADR-2026-04-11
- `docs/decisions/ADR-2026-04-11-release-trigger-policy.md`: ESE release trigger policy (gate-authority cuts on thematic completion; deterministic semver assignment by affected interfaces; agents may propose but not execute release cuts). Closes the gap identified in the 2026-04-11 self-audit where no written rule answered "when does `[Unreleased]` become a release." README Versioning section gained a one-line pointer; CLAUDE.md Hard Gates gained item 7 mirroring the policy for agent sessions
- `.gitignore`: ese-plugin runtime state file (`.ese-session-state.json`) to prevent accidental commits of session-local work item state
- CI pipeline expanded from 25 to 31 checks: wired 6 previously-orphaned lint scripts (`lint-adr-validation`, `lint-arch-doc`, `lint-changelog-entries`, `lint-fmea-completeness`, `lint-session-artifacts`, `lint-standards-application`) into `.github/workflows/ci.yml` as Checks 26-31 and added them to the CLAUDE.md "Before Every Commit" local suite. These scripts were added in v2.1.0 as "5 new CI scripts" but never wired into the pipeline; they now gate PRs and pushes
- `scripts/lint-template-drift.sh`: CI linter that detects when starter files have sections missing from their corresponding instance files; prevents the documented "Template-Standard Drift" anti-pattern (CI Check 22)
- Documented omission mechanism (`<!-- omit-section: Name -->`) for instance files to mark intentionally skipped starter sections
- `scripts/lint-readme-structure.sh`: CI linter that verifies every path listed in README.md's Structure section exists on disk (CI Check 23)
- `scripts/lint-toc-links.sh`: CI linter that verifies every ToC anchor link resolves to an actual heading using GFM slug rules (CI Check 24)
- `scripts/lint-adr-triggers.sh`: advisory CI check that warns when accepted ADRs have validation triggers with no recorded result after 90 days (CI Check 25)

### Removed
- `docs/superpowers/` directory and all contents (4 files: audit plans 2026-04-08 and 2026-04-09, audit design spec, audit report). The audit decisions are captured in ADR-2026-04-09 and CHANGELOG v2.1.0; the underlying evidence is in the git history. README Structure section updated to match; ADR-2026-04-09 Context updated to point at CHANGELOG + commit history instead of the removed report file

### Fixed
- **Phase C closure**: genuine audit of Phase C found three gaps. (1) `templates/compliance-review.md` §4 Documentation Standards assessment table had no row for REQ-4.1-02 (template compliance) or REQ-4.1-03 (verification mode); added two rows so compliance reviewers systematically check the new REQs. (2) `docs/standards-application.md` had no statement of how ESE itself satisfies REQ-4.1-03 (verification mode choice); added a "§4.1 Template Compliance Verification Mode" section declaring automated verification via `scripts/lint-template-compliance.sh` wired as CI Check 32, plus the ToC entry. (3) `docs/adoption.md` compliance checklist Group 1 had no rows for REQ-4.1-02 or REQ-4.1-03; added rows 1.6 and 1.7 so adopters have binary compliance items for the new REQs. (4) `CLAUDE.md` Agent Guidance section had no mention of `scripts/new-artifact.sh`; added a "New artifacts from templates" entry so future agent sessions use the scaffolding tool instead of hand-copying templates
- **Phase D closure**: genuine audit of Phase D found a real bug. The ADR template heading used `{number}` which substitutes to the full date-slug (`# ADR-2026-04-11-test-slug: Title`), but the established convention across all 24 existing ADRs is date-only (`# ADR-2026-04-11: Title`). Fixed the template heading to use `YYYY-MM-DD` (which substitutes to today's date only). Also found that 5 template types (PRD, capabilities, problem-research, compliance-review, work-item-export) used placeholders the scaffolding tool did not substitute (`{Feature or Product Name}`, `{Problem Name}`, `{Project Name}`, `{ID}`). Added all 4 substitutions to both `scripts/new-artifact.sh` and `starters/tools/new-artifact.sh`. Re-tested all 5 previously-untested template types; all now scaffold cleanly with zero unsubstituted placeholders. Caught by checking test output manually; no linter was catching these bugs because placeholder substitution is not machine-checkable without knowing the template conventions
- `templates/fmea.md`: normalized frontmatter placeholders to match the ADR template convention. Changed `id: FMEA-YYYY-MM-DD-{title}` → `id: {type}-{number}`, `fmea-type: DFMEA | PFMEA` → `fmea-type: {type}`, `title: "FMEA: {Feature or Process Name}"` → `title: "{type}: {Title}"`, and the H1 heading and Feature/Process byline similarly. Enables `scripts/new-artifact.sh` to generate FMEA instances with correct id/title/type without producing titles containing spaces (discovered during scaffold testing: the old `{title}` placeholder was being substituted with the raw title into an id field, producing `FMEA-2026-04-11-Payment processor v2`)
- `scripts/pre-commit`: replaced the removed `lint-fmea-template.sh` reference with `lint-template-compliance.sh` (the generic linter that subsumed it) and added `lint-fmea-congruence.sh` to the FMEA-staged pre-commit branch so FMEA edits now trigger all three gate checks locally
- `CLAUDE.md` and `docs/architecture/ese-machine-readable-enforcement-system.md`: updated stale REQ-ID counts (734 → 736) and gate counts (312 → 313) after REQ-4.1-02 and REQ-4.1-03 were added. Caught by `lint-stale-counts.sh` and `lint-count-congruence.sh` on first run
- `docs/decisions/DFMEA-2026-03-25-ese-machine-readable-first-restructuring.md`: replaced hardcoded "312 gates" in the Controls Summary T6 entry with relative language ("current gate count; lint-count-congruence gates this claim") so this line no longer drifts with every new gate
- `scripts/lint-changelog-entries.sh`: fixed crash-on-empty-`[Unreleased]` bug. The script used `set -euo pipefail` with an unguarded `grep "^- "` in a pipeline; when `[Unreleased]` had no bullet entries (the normal post-release state immediately after a ceremony commit), grep exited 1 and pipefail aborted the linter with a non-zero status. Discovered the first time the linter ran against an empty `[Unreleased]` section during the v2.2.0 release ceremony; without this fix every release ceremony commit would have failed CI. Fix guards the grep with `{ grep ... || true; }` so an empty section is treated as a PASS rather than a pipeline failure
- `docs/architecture/ese-machine-readable-enforcement-system.md`: updated 2 stale REQ-ID count references from 733 to 734 after REQ-4.3-06 was added
- `docs/decisions/ADR-2026-03-25-ese-machine-readable-first-format.md`: replaced hardcoded "733 REQ-ID blocks" in Per-Document Impact table with relative "one SHA-256 block per REQ-ID" (historical ADR; the specific count at time of writing is no longer load-bearing and caused drift with every new REQ-ID)
- CLAUDE.md "About This Repo" and README.md Structure section: corrected stale CI check counts from 25 to 31 after wiring the 6 previously-orphaned lint scripts
- CLAUDE.md key-paths table: corrected stale `enforcement-spec.yml` gate count from 362 to 312 (matches the current generated spec; same stale value that was fixed in the DFMEA Controls Summary earlier in this unreleased window but missed in CLAUDE.md)
- Added documented omissions to `docs/deployment.md` for Post-Deployment Verification and Monitoring After Deploy (not applicable to a documentation-only repo)
- Added documented omissions to `docs/setup.md` for Clone and Run, Environment Variables, Common Setup Failures, and Verify Your Setup (sections renamed or not applicable)
- Fixed 4 broken ToC anchor links: CLAUDE.md (renamed heading), event-driven.md and web-applications.md (GFM slug mismatch from " - " in headings)
- Fixed 7 stale "Section 10" references in docs/background.md; remapped to current sections (5.7, 5.10, 3.2)
- Updated docs/setup.md CI scripts list from 10 to 20 scripts (complete local CI suite)
- Updated dependencies.md last annual review date to 2026-04-09
- Updated CLAUDE.md "Before Every Commit" CI suite from 15 to 20 scripts
- Fixed DFMEA Controls Summary stale gate count (350 to 312)
- Fixed adoption.md cross-cutting activation table: 9 missing items added to match §2.1 per-stage blocks (constraint ID, SMED, viewport, agreement verify, confidence, violations, health probes, incident taxonomy extension, RFC before work item)
- Fixed adoption.md compliance checklist first principles count (8 to 7; REQ-1.4-05 deprecated)
- Fixed standards-application.md script counts (27 to 29)
- Fixed compliance-review-2026-03-26.md: corrected 5 major section headings, added note about subsection mapping errors
- Removed deprecated REQ-2.1-14 from templates/compliance-review.md
- Fixed architecture doc: clarified Mode 2 enforcement analyzer is planned (not current), updated coverage from aspirational "300+ target" to actual 312 gates
- README.md Structure section updated to reflect actual directory layout: added scripts/, .github/, docs/architecture/, docs/archive/, docs/product/, docs/superpowers/, and individual docs/ files that were missing
- Architecture doc (ese-machine-readable-enforcement-system.md) updated with 5 missing template sections: Goals, Current State, Data Flows, Failure Modes, Boundaries
- Added missing `deciders` frontmatter field to ADR-012 through ADR-016
- Broadened lint-session-artifacts.sh patterns to accept historical heading variants ("What Was Done", "What Is Still Open", "Actions", etc.) alongside canonical template headings; reduced false warnings from 62 to 0
- Added "What Failed" sections to 11 historical work session logs that had no failure record
- Added 18 context filters to lint-obligations.sh for definitional, meta-specification, and template guidance prose that uses obligation keywords in non-obligation contexts; reduced false warnings from 19 to 0
- Rephrased STANDARDS.md §5.7 rollback trigger elaboration to reference REQ-5.7-02 directly, resolving the remaining unclassified obligation

## [2.1.0] - 2026-04-09

### Changed
- Deprecated 141 requirements per genuine compliance audit: 67 in STANDARDS.md (sections 1-9), 74 across 6 addenda; categories: removed (non-first-principles), consolidated (derivative sub-requirements merged into parents), downgraded (gate to advisory)
- Updated 8 N/A designations in standards-application.md based on audit findings (1 incorrect, 7 questionable); added sections for section 5.3 multi-repo coordination and section 5.8 API versioning
- Added activation conditions to 12 conditional subsections in sections 5-8, referencing Component Capabilities Declaration

### Added
- Component Capabilities Declaration section in starters/standards-application.md for activation condition lookups
- 5 new CI scripts: lint-standards-application, lint-arch-doc, lint-session-artifacts, lint-changelog-entries, lint-adr-validation
- Agent guidance section in CLAUDE.md covering FMEA triggers, close checklists, post-mortem triggers, anti-pattern registry maintenance, metric verification, session logs, technology adoption, ADR validation, testing gaps, and breaking change analysis
- ADR-2026-04-09 documenting the genuine compliance audit remediation decision

### Fixed
- 5 content boundary violations in product docs (person names, vault-IDs removed)
- 2 missing Tables of Contents in product research docs
- 1 broken ToC link in investigation doc

### Fixed

**Replace all tool-specific terminology with ESE universal terms across entire repo**

- Tool-specific work-item-system terminology replaced with "work item" (56 replacements across 21 files: 7 ADRs, 9 product/architecture/compliance docs, CHANGELOG, CLAUDE.md, work-item export, standards-application.md).
- Runtime-specific references (4 remaining in product doc, architecture doc, ADR, compliance review) replaced with generic "runtime enforcement" / "runtime system".
- background.md research table genericized from tool-specific heading to "Runtime principle".
- System name retained only as the §2.7-required declaration in standards-application.md parentheticals. All CLI command references removed.
- CHANGELOG self-references cleaned: entries describing past fixes no longer contain the tool names they describe removing.
- "the enforcement analyzer" (implementation tool name) replaced with "enforcement analyzer" / "deterministic enforcement tool" across 5 prescriptive docs (3 product docs, 1 ADR, 1 DFMEA, 1 architecture doc; 10 references total).
- "the runtime enforcement tool" replaced with "runtime enforcement" in 1 product doc.

**Replace vague CLAUDE.md checklist with explicit verification gate**

- "Before Finishing Any Task" (6 vague bullets) replaced with "Before Every Commit" (18 specific items with exact grep commands and expected outputs). Root cause of repeated compliance misses during this session: the checklist said what categories to check without specifying how.
- Global CLAUDE.md (~/operator configuration/AGENTS.md) updated with matching 9-item global checklist.

**Update root-level docs to reflect current state**

- README.md: added maintainer and status (REQ-STR-34, REQ-STR-37); added CLAUDE.md and docs/work-items/ to structure; corrected requirement-index.md description; updated decisions/ description from stale "ADR-001 through ADR-020" to current.
- dependencies.md: added Miller (1956) and Parkinson (1955) as tracked external references (both newly cited in STANDARDS.md §2.8 and §9.1 threshold grounding).

**Final sweep: deployment.md absolute path, continuous-improvement.md counter-example, CLAUDE.md path**

- deployment.md: hardcoded `~/repos/engineering-standards/` and person name replaced with generic equivalents.
- continuous-improvement.md: tool-specific counter-example replaced with generic placeholder.
- CLAUDE.md: absolute path replaced with relative reference.

**Remove non-standard docs/research/ directory; rename vault-ID file**

- 4 research docs moved to docs/product/ per §1.2 document progression. docs/research/ removed (not in standard repo layout).
--sec-4-9-draft.md renamed to sec-4-9-requirement-format-draft.md (no vault-IDs in filenames).

**Remove resolved debt from technical debt table**

- Cleared work-item-export row from standards-application.md debt table. Resolved debt is not debt.

**Resolve work-item-export technical debt (ADR-019 obligation)**

- `docs/work-items/` directory created; first export committed: `2026-04-08-ese-self-compliance-audit.md` documenting the comprehensive self-compliance audit session (7 commits, ~930 issues resolved).
- `docs/standards-application.md` updated: debt table entry marked resolved; §2.2 user feedback section updated from "planned but not yet implemented" to active.
- Work-item-export lint validates 2 files (template + first export): PASS.

### Changed

**Resolve remaining deferred audit items: file moves, ADR rename, standards-application refresh**

- ADR-022 renamed to ADR-2026-03-28-lightweight-pre-intake-items.md (date-based naming per convention; frontmatter id updated).
- 2 research docs moved from docs/work-sessions/ to docs/research/ (misplaced; not session logs).
- docs/standards-application.md refreshed: typographic check gap resolved (2026-04-08), work-item-export added to technical debt table (P3, open), last updated and compliance review dates updated to 2026-04-08.
- .gate-manifest.json: implementation-specific language replaced with generic equivalents (gitignored; local only).
- Work session logs accepted as-is per owner decision (retroactive structural edits are revisionist).

### Added

**Genuine compliance audit: section 3-4 findings (73 REQ-IDs)**

- Appended 73 rows to `docs/superpowers/specs/2026-04-08-ese-compliance-audit-report.md` covering all REQ-IDs in sections 3 (Architecture/Design) and 4 (Documentation Standards).
- 3 deprecated requirements identified (REQ-4.9-02, REQ-4.9-10, REQ-4.9-11). 29 of 73 REQ-IDs have enforcement-spec.yml gates.
- Key findings: section 3.4 (Conway's Law) is weak/conditional for solo projects; section 4.5 (Code Documentation) is conditional on having application code; section 4.8 documentation layers are heavily conditional on project type.

**CLAUDE.md: project-level agent context for ESE compliance**

- `CLAUDE.md` at repo root: defines hard gates, writing standards, commit discipline, document standards, content boundaries, and numeric threshold rules for Claude Code sessions. Ensures AI agents operating in this repo comply with ESE requirements.
- Covers: no AI attribution in commits, no typographic dashes, no adopter-specific references in normative docs, CHANGELOG required, atomic commits, CI checks before completion, vault-ID scope rules.

### Fixed

**Comprehensive self-compliance audit: ~850 broken links, normative doc pollution, structural violations**

Corpus-wide audit against all applicable ESE requirements. Findings and resolutions:

- **728 broken links in docs/requirement-index.md:** Generator script (`scripts/_generate_req_index.py`) produced root-relative paths instead of paths relative to `docs/`. Fixed the generator and regenerated.
- **51 broken links in ADR-021:** Root-relative paths to templates and addenda corrected to directory-relative.
- **14 broken template cross-references:** 7 templates linked to `*-template.md` filenames that do not exist (actual files have no `-template` suffix). All corrected.
- **5 broken STANDARDS.md depth links:** 3 subdirectory docs and 2 CHANGELOG entries used wrong `../` depth. Corrected.
- **1 broken ADR-011 link** in adoption.md (filename had changed). Corrected.
- **Tracked-system-specific leakage in normative docs:** tracked system named in STANDARDS.md §2.2 terminology note; tracked-system references in 3 templates (adr.md, compliance-review.md, work-item.md); vault-ID HTML comments in all 7 addenda. All replaced with generic "work item" language or removed.
- **Codename leakage in CHANGELOG:** "Hive" and "Amoeba" project codenames replaced with generic references.
- **13 malformed YAML frontmatters in templates:** `implements:` field parsed as string instead of list. All 13 corrected to valid YAML list syntax.
- **7 missing Tables of Contents (REQ-4.4-01):** Added to 5 starters (standards-application.md, runbook.md, deployment.md, setup.md, repo-structure.md) and 2 FMEA docs (DFMEA, PFMEA).
- **3 broken/stale ToC entries:** setup.md (heading renamed), background.md (missing entry for §7.7), CLAUDE.md (self-referential dash pattern). All corrected.
- **background.md section title:** "a reliable runtime ecosystem/the implementation language" heading renamed to "Runtime architecture principles mapping" (content retained as example source).
- **PRD hardcoded path:** `~/repos/engineering-standards/` replaced with `./`.
- **Research doc broken link:** Root-relative path corrected.

### Fixed

**Remove adopter-specific implementation references from normative documents**

- 17 references to a specific adopter repository ("an adopter project") replaced with generic "tracked work item system" or "tracked system" language across 7 normative documents: 2 ADRs, 1 architecture doc, 4 product docs.
- Generating principle: ESE is a universal, domain-agnostic standard; normative documents must not name-drop specific adopter implementations. 13 work session logs retain historical references (session logs are historical records per §4.6; rewriting them would be revisionist).
- STANDARDS.md, addenda, templates, and starters already had zero adopter-specific references.

### Added

**commit-msg hook: reject AI co-authorship trailers and attribution lines**

- `scripts/commit-msg`: new git hook rejecting commits containing `Co-Authored-By` trailers referencing AI tools (Claude, GPT, Copilot, Gemini) or `Generated with/by` AI attribution lines. Generating principle: commit authorship must accurately reflect the human accountable for the change; AI-inserted trailers misrepresent authorship and bypass the named gate authority (§1.4).
- `docs/setup.md`: updated hook installation instructions to include `commit-msg` alongside `pre-commit`. Added troubleshooting entry for AI attribution rejections.

### Changed

**First-principle grounding for all numeric thresholds; foundational theories added to introduction**

- STANDARDS.md introduction: added "Theoretical foundations" paragraph naming the five generating theories (Deming SoPK, Theory of Constraints, Conway's Law, DORA research, SRE reliability engineering) and the principle that numeric defaults are calibration points, not definitions.
- §1.1: replaced fixed ">4 hours" with principle-based criterion (cost of restarting after wrong approach exceeds cost of upfront definition) with "roughly a half-day" as default calibration.
- §2.5: added statistical process control derivation for "two consecutive review periods" (minimum evidence to distinguish signal from noise). Toil threshold reframed as cumulative-cost-exceeds-automation-cost principle with 3 recurrences / 30 min/week as default calibration.
- §2.8: scale trigger reframed around working memory capacity (Miller, 1956) with "roughly 10 concurrent items" as default calibration.
- §4.7: document length thresholds reframed around working memory and single-sitting readability; word counts repositioned as evaluation triggers with explicit "the word count is not the gate; the readability test is."
- §5.1: branch lifetime reframed around divergence-based integration risk; "one to two days" repositioned as default calibration.
- §7.5: error budget escalation reframed from fixed "50%" to rate-based principle (extrapolated consumption would exhaust budget before period end).
- §8.2: detection latency reframed from fixed "10 minutes" to principle-based (detection must outpace damage accumulation).
- §9.1: research and PoC time-boxes grounded in Parkinson's Law with explicit "adjust based on criticality and reversibility."
- REQ-2.5-02, REQ-2.5-03, REQ-4.7-01, REQ-4.7-02, REQ-5.1-07, REQ-7.5-02 statements updated to match. Manifests regenerated.

### Fixed

**Resolve all em-dash and double-hyphen sentence dash violations across corpus**

- 14 Unicode em dashes (U+2014) replaced in STANDARDS.md and CHANGELOG.md with parentheses, semicolons, or restructured prose.
- ~50 ASCII double-hyphen sentence dashes replaced across 11 files: STANDARDS.md, CHANGELOG.md, ai-ml.md, containerized-systems.md, multi-service.md, adoption.md, ADR-022, ADR-2026-03-25, and 3 work session logs.
- Replacement strategy: parenthetical sets for inline asides, semicolons for contrastive clauses, colons for label-detail patterns, periods for sentence breaks.
- CI Check 1 (em dash scan) now passes on main. Manifests (req-manifest.sha256, enforcement-spec.yml, requirement-index.md) regenerated.

### Changed

**Definitional gap closures: qualifying changes, significant work, SMART scope, FMEA rescoring, §2.8 scale trigger, §4.3 prose (ese-compliance-review 2026-03-31)**

Six gaps identified during an ESE compliance review (2026-03-31) where undefined application criteria were producing over-application of the standard:

- §1.1: "Significant work" defined as >4h estimated, >1 phase, or blocks another open work item. Below all three thresholds, acceptance criteria sufficient; full §1.1 problem statement not required.
- §2.1 DESIGN: "Qualifying changes" for PFMEA defined as phase definition changes, tool/API surface changes, inter-service communication changes. Explicitly excludes prompt/copy updates, test additions, internal refactors, log format changes, dependency upgrades with no surface change.
- REQ-2.1-48: Rescoring scope added. Full rescore required only for Severity ≥ 7 OR RPN ≥ 75. Below both thresholds, log with detection controls only.
- REQ-1.1-12: SMART metrics scope added. REQ-1.1-07 through REQ-1.1-12 apply to significant work items only (as defined above). Not required for chores, test additions, refactors, or documentation updates.
- §2.8: Scale trigger added. Advisory for single-operator projects with <10 concurrent items; load-bearing at 10+ concurrent items, multiple stakeholders, or multi-domain portfolios.
- §4.3: Prose trimmed ~60%. Redundant restatement of changelog entry format removed; requirements REQ-4.3-01 through REQ-4.3-05 unchanged.

### Changed

**Add D2 artifact pre-check to DESIGN qualification checklist; add REQ-2.1-54**

- STANDARDS.md §2.1 DESIGN checklist: new first bullet "D2 artifact read?" requires citing the D2 characterization artifact path in the ADR Context section before writing any ADR or architecture document, or stating "D2: not required" with rationale.
- REQ-2.1-54 added: `gate` `design` `hard` `type:feature OR type:component`. D2 artifact cited or explicitly stated not required before DESIGN begins.
- Root cause: ADRs 020-025 were written without reading the D2 characterization artifact; cascade broke at D2 -> DESIGN (session 62).

### Changed

**ADR-2026-03-25-ese-machine-readable-first-format: Accepted**

- Status changed from Proposed to Accepted by Nick Baker (2026-03-26).
- 732 REQ-IDs across the corpus. 361 hard gates in enforcement-spec.yml. 21 CI checks.
- DFMEA iteration 13 (16 FMs, all below RPN 75). PFMEA iteration 10 (42 FMs, all below RPN 75).
- All implementation checklist items resolved: T1-T3 done, T4 N/A, T5-T7 done, B3-B16 done, T6 done, FM-08 round-trip done, Mode 2 candidate generator done gaps resolved.

**Fix 3 REQ-ID sub-clause violations; DFMEA/PFMEA rescored; ADR Per-Document Impact Analysis added**

- REQ-1.5-02: semicolon removed; split into REQ-1.5-02 (exemption statement) + REQ-1.5-03 (tool behavior statement).
- REQ-4.2-10: or-clause removed; split into REQ-4.2-10 (section existence) + REQ-4.2-11 (entry content requirement).
- REQ-ADD-AI-33: three bundled items split into REQ-ADD-AI-33/-34/-35; scope corrected from close to commit.
- DFMEA: FM-15 (Mode 2 F1 threshold insufficient, RPN 32) and FM-16 (promotion missing evidence, RPN 63) added. Iteration 13. 16 FMs, all below RPN 75. Highest: FM-16 at 63.
- PFMEA: PF-41 (candidates never evaluated, RPN 64) and PF-42 (promoted without 2 runs, RPN 32) added. P9 Mode 2 Enforcement Rule Promotion process added. Iteration 10. AI/ML addendum now applicable. 42 FMs total, all below RPN 75.
- ADR-2026-03-25: Per-Document Impact Analysis section added (19 documents listed); implements list updated with 11 new REQ-IDs.
- 732 REQ-IDs total. 361 gates in enforcement-spec.yml.

**the enforcement analyzer Mode 2 candidate generator ( complete)**

- scripts/generate-mode2-candidates.sh + _generate_mode2_candidates.py: reads unclassified obligations from lint-obligations.sh, calls Groq LLM, generates candidate gate rules as status: inert in enforcement-spec-mode2-candidates.yml.
- enforcement-spec.yml: all Mode 1 gates now carry status: active and mode: deterministic fields.
- DFMEA FM-06 Mode 2 controls updated from future-scope to [x] DONE.
- Promotion standard: 2 independent G-Eval runs each F1 >= 0.85, commit with scores and pre-eval threshold confirmation (REQ-ADD-AI-31, -32, -33).

**resolve 4 ESE gaps for machine-derived enforcement**

- §1.5: External imposition guidance  -  ESE-derived enforcement may apply to unadopted repos in Complicated-domain sessions; Complex-domain exempt; project carve-outs honored. REQ-1.5-01, REQ-1.5-02.
- §4.2: Per-Document Impact Analysis required for ADRs modifying existing components/APIs/interfaces/standards. REQ-4.2-10. templates/adr.md updated with Per-Document Impact Analysis section.
- ai-ml.md: LLM-Generated Enforcement Rules section added. Gate authority delegation: configuring F1 threshold satisfies approval requirement. Quality standard: minimum 2 independent G-Eval runs each achieving F1 >= 0.85 before promotion from inert to active. REQ-ADD-AI-30, REQ-ADD-AI-31, REQ-ADD-AI-32, REQ-ADD-AI-33.
- Gap 4 (enforcement-spec.yml): already resolved by T6.
- Nick Baker approval recorded in work item comment (2026-03-26).
- 728 REQ-IDs total (was 721). enforcement-spec.yml now has 357 gates (was 350).

**FM-08 round-trip CI gate for work item export format**

- scripts/lint-work-item-export.sh: validates templates/work-item-export.md and docs/work-items/*.md; checks YAML frontmatter, required fields, round-trip parse consistency.
- ci.yml Check 21: runs on every commit.
- scripts/pre-commit: runs always (not gated on STANDARDS.md change).
- DFMEA FM-08 Controls Summary: updated from future-scope to [x] DONE.
- ADR-2026-03-25 data store row: updated to DONE.

**T6: enforcement-spec.yml generator from kind:gate REQ-IDs**

- scripts/generate-enforcement-spec.sh + _generate_enforcement_spec.py: reads all non-deprecated kind:gate REQ-IDs; generates enforcement-spec.yml with 350 hard gates.
- enforcement-spec.yml: committed at repo root; fields per gate: id, scope, enforcement, applies_when, eval_scope, statement, source.
- ci.yml Check 20: verifies spec freshness on every corpus commit.
- scripts/pre-commit: auto-regenerates and stages enforcement-spec.yml on corpus changes.
- DFMEA Controls Summary: T6 updated from future-scope to [x] DONE.
- ADR-2026-03-25 checklist: T6 marked DONE.

**B15: Generated requirement index by lifecycle scope and applies-when**

- scripts/generate-req-index.sh: generates docs/requirement-index.md from REQ-ID tags; 716 active REQ-IDs across 13 lifecycle scopes.
- scripts/_generate_req_index.py: Python helper for index generation.
- docs/requirement-index.md: replaced manually-maintained domain index with generated scope/applies-when index.
- ci.yml Check 19: verifies index is current on every corpus commit.
- scripts/pre-commit: auto-regenerates and stages index on corpus changes.
- ADR-2026-03-25 checklist: B15 marked DONE.
- DFMEA Controls Summary: T6, and Mode 2 items clarified as explicitly future-scope (not ambiguous open items).

**ADR lifecycle document cross-reference fields and CI gate**

- templates/adr.md: added optional frontmatter fields dfmea, pfmea, architecture-doc with populate-when guidance.
- ADR-2026-03-25: dfmea and pfmea fields populated; Follow-on Requirements links to both DFMEA and PFMEA.
- DFMEA-2026-03-25: pfmea field added linking to PFMEA-2026-03-26.
- REQ-4.2-08: when ADR dfmea field is populated, the named file exists and its adr field references this ADR.
- REQ-4.2-09: when ADR pfmea field is populated, the named file exists and its adr field references this ADR.
- scripts/lint-adr-lifecycle-refs.sh: verifies all ADR dfmea/pfmea cross-references are consistent.
- ci.yml Check 18: calls lint-adr-lifecycle-refs.sh.
- scripts/pre-commit: calls lint-adr-lifecycle-refs.sh in STANDARDS.md block.

**FMEA controls implementation verification gate**

- REQ-2.1-53: every checked [x] Controls Summary entry that names a script must have that script present in scripts/ and wired to ci.yml.
- scripts/lint-fmea-controls.sh: new script implementing REQ-2.1-53.
- ci.yml Check 17: calls lint-fmea-controls.sh.
- scripts/pre-commit: calls lint-fmea-controls.sh in FMEA trigger block.

**Remove arbitrary prose-line ceiling; reverse req-schema.md cascade**

- STANDARDS.md §2.1: PDCA and DMAIC lifecycle mapping tables restored inline (removed from docs/req-schema.md)
- REQ-4.9-02 deprecated: the 1200-line prose ceiling was arbitrary (inherited from an earlier total-line ceiling without re-derivation). Document length now governed by §4.7 qualitative test exclusively.
- REQ-4.9-10, REQ-4.9-11 deprecated: both referenced the removed prose-line gate.
- scripts/lint-prose-line-count.sh and scripts/_count_prose_lines.py deleted.
- docs/req-schema.md: deleted; file no longer needed now that ceiling is removed and content has returned to STANDARDS.md.
- DFMEA FM-10 and Controls Summary updated: T4 N/A, §4.7 is the control.
- ADR-2026-03-25 implementation checklist: T4 marked N/A.

---

## [2.0.0] - 2026-03-26

Machine-readable-first ESE. Every obligation in every file is individually addressable by REQ-ID for automated compliance checking.

### Added

**PFMEA: ESE Process Sequences**

- docs/decisions/PFMEA-2026-03-26-ese-process-sequences.md: 8 sequential processes, 34 failure modes, 12 above RPN 100 threshold

**DFMEA/PFMEA type distinction**

- STANDARDS.md §2.1 DESIGN: both DFMEA and PFMEA required at same qualifying triggers
- REQ-2.1-35: PFMEA reviewed at qualifying changes
- REQ-2.1-36: recurring bugs update PFMEA
- CI addendum FMEA in Practice: DFMEA/PFMEA guidance added
- templates/fmea.md: fmea-type field (DFMEA | PFMEA) added

**T7b REQ-ID count parity check**

- CI Check 8: manifest block count must equal unique anchor count across corpus
- Pre-commit: same parity check before commit

**DRY corpus file list**

- scripts/ese-corpus-files.sh: single source of truth for all 4 scanning scripts

**Corpus-wide elemental REQ-ID pass ( EPIC, 14 children)**

- All 82 bundled REQ-IDs unbundled into elemental single-obligation IDs across: STANDARDS.md (47 -> 138 elemental), 7 addenda (23 -> 64 elemental), 3 starters (13 -> 52 elemental)
- REQ-ID count: 429 (v1.19.0) -> 687 (v2.0.0)

**§2 machine-readable-first**

- 23 new elemental REQ-IDs in §2: D0/D1/D2 DISCOVER depth gates, re-entry triggers, edge case AC, type-conditional close conditions for all 9 types, Definition of Ready, ownership transfer, backlog hygiene

### Added

**§2 machine-readable-first migration: 23 new elemental REQ-IDs**

§2.1 DISCOVER depth gates:
- REQ-2.1-19: D0 intake log entry for every signal
- REQ-2.1-20: D1 triage evidence check, duplicate check, registry consult
- REQ-2.1-21: D1 triage exits one of four decisions
- REQ-2.1-22: D2 characterization artifact
- REQ-2.1-23: Expedite signals fix-first, back-fill D0/D1

§2.1 Re-entry triggers:
- REQ-2.1-24: BUILD discovers DEFINE incomplete, returns to DEFINE
- REQ-2.1-25: VERIFY reveals DESIGN wrong, returns to DESIGN
- REQ-2.1-26: DEPLOY reveals VERIFY incomplete, returns to VERIFY
- REQ-2.1-27: Re-entry triggers recorded (what and why)

§2.2 AC quality and readiness:
- REQ-2.2-08: AC observable, binary, measurable
- REQ-2.2-09: Feature AC requires failure/boundary/error case
- REQ-2.2-10: Definition of Ready (AC agreed, deps identified, scoped, context sufficient)
- REQ-2.2-11: Backlog hygiene (deprioritized items recommitted or closed)

§2.3 Type-conditional close conditions (all types now gated individually):
- REQ-2.3-16: Bug P0/P1 post-mortem
- REQ-2.3-17: Investigation root cause documented
- REQ-2.3-18: Investigation implementation work item filed
- REQ-2.3-19: Improvement baseline before BUILD
- REQ-2.3-20: Improvement measured result exceeds variation
- REQ-2.3-21: Component architecture doc complete
- REQ-2.3-22: Debt source doc updated
- REQ-2.3-23: Prevention post-mortem table updated
- REQ-2.3-24: Countermeasure A3 table updated

§2.4 Ownership:
- REQ-2.4-03: Ownership transfer recorded in runbook and standards-application

Compliance review template updated: all §2 rows now reference REQ-IDs (68 rows with individual IDs replacing 24 section-level rows).

### Changed

**Deprecate sequential ADR/FMEA/EVAL naming; date-based is the sole convention**

- `starters/repo-structure.md`: Numbering scheme table changed from "date-based (default) / sequential (alternative)" to "date-based (sole convention) / sequential (deprecated, do not use for new projects)"; per-directory ADR example removes sequential variant; adoption checklist item updated from "date-based or sequential" to "date-based (sole convention)"
- `docs/decisions/ADR-021`: D9 naming conventions section updated  -  sequential marked deprecated; date-based stated as the sole convention for new projects
- `docs/standards-application.md`: ESE's own ADRs (ADR-001 through ADR-021) documented as legacy sequential (retained as-is); all new ADRs in ESE use date-based from this point; pre-existing em dash on line 135 fixed

### Added

**T7 REQ-ID integrity manifest**

- `scripts/generate-req-manifest.sh` generates `req-manifest.sha256` with one `REQ-ID|sha256hex|file` line per REQ-ID block (331 blocks across STANDARDS.md and 7 addenda)
- `scripts/_req_manifest_helper.py` Python helper for block extraction and hashing (avoids shell heredoc limitations)
- CI gate: `generate-req-manifest.sh verify` step added to `.github/workflows/ci.yml` as Check 7. Fails if manifest diverges from current STANDARDS.md / addenda
- Pre-commit hook extended: T7 verify runs on every commit touching STANDARDS.md or addenda alongside T1 and T2
- Manual test confirmed: editing a REQ-ID block hash in the manifest causes verify to fail with diff output

### Fixed

**Fix 4 broken cross-references in starters and addenda**

- `starters/repo-structure.md`: corrected link `standards-application-template.md` to `standards-application.md` (file exists at that path)
- `starters/standards-application.md`: corrected SLO template link `slo-template.md` to `../templates/slo.md` (correct relative path from starters/)
- `docs/addenda/ai-ml.md`: replaced ghost reference `Section 10.5 of the universal standard` with `[§5.10](STANDARDS.md#510-minimum-security-baseline)` (data retention lives in §5.10 Minimum Security Baseline)
- `docs/addenda/multi-team.md`: replaced ghost reference `Section 10.1 template` with `[§4.8](STANDARDS.md#48-documentation-layers)` and starter link `starters/runbook.md` (on-call runbook is §4.8 Documentation Layers)

### Added

**Full-corpus quality pass: STANDARDS.md, addenda, adoption.md ( Phase 1)**

G-Eval quality evaluation applied to all ESE documents. Improvements per document:

*STANDARDS.md:*
- §2.2: Terminology note: "work item," "issue," and "ticket" are used interchangeably throughout; all refer to a §2.2-compliant tracked unit of work
- §3.1: "Where applicable" replaced with explicit applicability criteria per component characteristic (stateful, SLO-bound, trust-boundary-crossing, data-sensitive, i18n-requiring)
- §4.7: Document cascade thresholds made concrete: section exceeds 500 words = evaluate for extraction; document exceeds 2,000 words with search-required navigation = cascade
- §5.2: "Periodically" defined for vulnerability exception reviews (minimum quarterly) and license audits (minimum annually)
- §6.1: "Logic" defined as branching, looping, computation, state transformation, error handling, or any behavior where different inputs produce different outputs; pure pass-through functions exempt
- §7.7: "Validate before trusting" now defines validation as three specific steps: confirm measurement definition, confirm authoritative data source, run calibration test on known data

*event-driven.md, web-applications.md, multi-team.md:*
- Lifecycle Stage Mapping table added to each addendum (matching containerized-systems.md pattern); practitioners see at a glance which requirements activate at each ESE lifecycle stage without cross-referencing §2.1

*docs/adoption.md:*
- Part 4: Compliance Verification added with Adoption Compliance Checklist (Groups 1-5: Project Foundation, Work Item System, Delivery Lifecycle, Quality Gates, Learning Infrastructure) and Ongoing Compliance Requirements table
- Each checklist item is binary/observable, cites governing ESE section and evidence artifact, and has a REQ-ID placeholder ready for B3-B12 assignment
- Enables auditors to verify project compliance and practitioners to self-certify against specific requirements

Baseline F1 scores before this pass: STANDARDS.md 5/7, event-driven.md 5/7, web-applications.md 5/7, multi-team.md 6/7. Post-improvement scores: all 7/7. Documents already at 7/7: ai-ml.md, continuous-improvement.md, multi-service.md, containerized-systems.md. All addenda now have lifecycle stage mapping tables.

**STANDARDS.md §4.9: Machine-Readable Requirement Format**

New section §4.9 defines the canonical format for expressing enforceable requirements inline in STANDARDS.md and its addenda. Enables linters, generators, and enforcement tools to parse, validate, and cross-reference gates without reading surrounding prose.

Eight subsections:
- **§4.9.1 Requirement Unit Format:** three-line unit (anchor + bold REQ-ID + tag tokens + one binary observable statement)
- **§4.9.2 Inline Tag Schema:** four required positional tokens (`kind`, `scope`, `enforcement`, `applies-when`) plus a fifth (`eval-scope`) required when `kind` is `gate`; full valid-values tables with ESE traceability
- **§4.9.3 Eval-Scope (5th Token):** `per-item`, `per-section`, `per-artifact`, `per-commit` semantics
- **§4.9.4 Applies-When Grammar:** formal PEG grammar for compound `applies-when` expressions; unambiguous by construction; maps to a recursive-descent parser
- **§4.9.5 REQ-ID Scheme:** `REQ-{section}-{seq:02d}` for base requirements; `REQ-ADD-{CODE}-{seq:02d}` for addenda (codes: `WEB`, `AI`, `CI`, `EVT`, `MS`, `CTR`, `MT`)
- **§4.9.6 Immutability Rule:** IDs immutable once published under a versioned CHANGELOG heading; deprecated IDs retain anchor with `deprecated:{superseding-REQ-ID}` token
- **§4.9.7 Prose vs. Requirement Distinction:** four-type taxonomy (gate, artifact, advisory, narrative); tiebreaker: assign REQ-ID when ambiguous; linter keyword scan for unclassified obligations
- **§4.9.8 Line Count Ceiling:** two embedded gate requirements  -  §4.9 ceiling 150 lines (REQ-4.9-01), STANDARDS.md ceiling 1200 lines (REQ-4.9-02); cascade target `docs/req-schema.md`

Architectural decision: [ADR-2026-03-25-ese-machine-readable-first-format.md](docs/decisions/ADR-2026-03-25-ese-machine-readable-first-format.md). FMEA (5 iterations, 13 failure modes): [DFMEA-2026-03-25-ese-machine-readable-first-restructuring.md](docs/decisions/DFMEA-2026-03-25-ese-machine-readable-first-restructuring.md). FM-13 (addenda ~122 ambiguous obligations, RPN 252) remains open; resolves during B12 addenda migration.

**web-applications.md: i18n/l10n section, binary accessibility requirements, inline URL context, and performance minimum documented set**

Four targeted improvements to `docs/addenda/web-applications.md`:

- **Internationalization and Localization section** added between Browser Support and Security Headers. Covers: when the section applies (multi-language, roadmap within 12 months, or locale-sensitive data display), what must be externalized (strings, date/time/number/currency formats, plural forms, units), the hard-coded concatenation prohibition, testing requirements (non-English smoke test, German-proxy length test, RTL rendering, format switching), and translation management (source-controlled locale files updated with the code change, visible fallback for missing keys). Testing Gap Audit table gains a P2 row for missing locale smoke test.
- **Accessibility requirements made measurable**: keyboard navigation bullet now specifies Tab key and Shift+Tab, Enter or Space operability, and the no-keyboard-trap condition. Focus management bullet now specifies 3:1 contrast for focus indicators, reading-order focus sequence, and prohibition on unexpected focus movement. Screen reader bullet now specifies programmatically associated labels and ARIA live regions.
- **WCAG 2.2 inline context added**: one sentence explaining the four WCAG principles and the Level AA success-criteria scope, plus the automated-plus-manual testing approach, so practitioners know what to audit without visiting the specification.
- **securityheaders.com inline context added** and URL converted to a hyperlink: one sentence explaining the A-F grading and the listed header findings, with a B-or-higher launch target.
- **Performance targets minimum documented set specified**: the "document in project application doc" directive now explicitly names LCP, INP, and CLS thresholds plus all four Lighthouse categories as the minimum required entries in the project's application document.

**event-driven.md: security section, schema evolution patterns, and inline pattern context**

Three targeted improvements to `docs/addenda/event-driven.md`:

- **Security (Required) section** added between Backpressure and Exactly-Once Semantics. Covers: authentication (mTLS, SASL/SCRAM, API keys, IAM; anonymous connections prohibited), authorization (least-privilege ACLs per producer and consumer, enforced in the broker), credential management (secrets manager required, rotation on schedule and on compromise, zero-downtime rotation pattern), and encryption in transit (TLS required; at-rest encryption check for PII/regulated data).
- **Schema evolution rules** added to Event Schema and Contracts. Named patterns: add fields only; never remove or rename a field in place (deprecation cycle required); never change a field type or semantics; consumers must ignore unknown fields (tolerant reader pattern). Each rule explains what breaks and why.
- **Inline one-sentence context** added for patterns referenced by name only: schema registry defined at first use; offset defined in Architecture Documentation Additions; upcasting defined in Event Sourcing; tolerant reader defined at introduction.

**ESE machine-readable-first investigation and §1.2 design artifacts**

Pre-implementation design chain for the machine-readable-first lifecycle model. No STANDARDS.md content changed; these are investigation, §1.2 document progression, and architectural design artifacts committed 2026-03-25.

- `docs/product/investigation-ese-machine-readable-lifecycle-model.md`: three-layer inference proof showing why the current ESE structure requires cross-section inference that machines cannot perform without human guidance. Full lifecycle loop documented: STANDARDS.md as source of truth, enforcement-spec.yml as derived machine-readable artifact, evaluation oracle consuming the spec.
- `docs/product/problem-research-ese-machine-readable-first.md` (§1.2 Step 1): problem research for the machine-readable-first restructuring. Who has the problem, current state, cost of no action, solved-looks-like.
- `docs/product/capabilities-ese-machine-readable-first.md` (§1.2 Step 2): 11 capabilities including C-3 (automated compliance checking), C-5 (enforcement-spec.yml generation), C-10 (REQ-ID anchor navigation), C-11 (§1.2 enforcement gate for automated systems).
- `docs/product/prd-ese-machine-readable-first.md` (§1.2 Step 3): product requirements document. Functional requirements, acceptance criteria, out-of-scope boundaries, phased delivery.
- `docs/decisions/ADR-2026-03-25-ese-machine-readable-first-format.md`: format decisions D1-D9. Key: D1 STANDARDS.md is single source of truth (no parallel spec file); D2-D4 REQ-ID format and inline tag schema; D5 date-based ADR naming; D6 three-tier accessibility model; D9 enforcement-spec.yml is generated not maintained.
- `docs/decisions/DFMEA-2026-03-25-ese-machine-readable-first-restructuring.md`: failure mode analysis for the restructuring. High-RPN failure modes: REQ-ID drift, tag schema bloat, prose-vs-requirement boundary ambiguity.
- `docs/architecture/ese-machine-readable-enforcement-system.md`: architecture document. Three-layer model, inference elimination strategy, component boundaries, failure modes.

---

## [1.19.0] - 2026-03-24

### Added

**Compliance review template audit: 22 missing rows added across §2, §3, §4, §5, §7, §8, §9**

- `templates/compliance-review.md` §2: 8 new rows covering previously unchecked §2.2 requirements (backlog review, definition of ready), §2.3 type-conditional close requirements, §2.3 handoff verification, §2.4 ownership transfer documentation, §2.5 toil tracking, and §2.6 delivery rate awareness plus constraint identification.
- `templates/compliance-review.md` §3: 1 new row for §3.4 team-architecture alignment (independent deployability, independent testability, team cognitive load).
- `templates/compliance-review.md` §4: 1 new row for §4.1 archived document metadata requirement (status: archived, superseded-by, date-archived frontmatter).
- `templates/compliance-review.md` §5: 5 new rows covering §5.3 (multi-repository coordination), §5.4 (restart safety and timeout/backoff requirements), §5.6 (infrastructure as code and RTO), §5.8 (API versioning and deprecation), §5.9 (Twelve-Factor App compliance). Prior template covered only §5.1, §5.2, §5.5, §5.7, §5.10 of the 10-subsection §5.
- `templates/compliance-review.md` §7: 5 new rows covering §7.2 (monitoring dashboard), §7.3 (audit trail), §7.4 work item cycle time, §7.4 compound yield, and §7.6 (observability: traces, metrics, structured logs). The DORA-only §7.4 row was supplemented with the two additional §7.4 requirements. Prior template covered only §7.1, §7.4 (DORA only), §7.5, §7.7 of the 7-subsection §7.
- `templates/compliance-review.md` §8: 1 new row for §8.1 incident taxonomy (classify before post-mortem; regression case required for every incident).
- `templates/compliance-review.md` §9: 1 new row for §9.3 external standards dependency tracking.

**Adoption version upgrade procedure**

- `docs/adoption.md` Part 1: **Staying Current** subsection added immediately after the submodule update code block. Four required elements: (a) read CHANGELOG after upgrading to identify changed templates, (b) run a compliance review using templates/compliance-review.md as the authoritative all-sections audit, (c) explicit statement that all template-based artifacts need auditing not only standards-application.md, (d) reference to Template-Standard Drift anti-pattern in docs/incidents/anti-patterns.md.

### Fixed

- `templates/compliance-review.md`: broken relative link in document header corrected: `standards-application-template.md` updated to `../starters/standards-application.md` (introduced by ADR-021 examples/ split).
- `templates/compliance-review.md`: broken relative link in Applicable Addenda section corrected: `../../STANDARDS.md` updated to `../STANDARDS.md` (wrong depth introduced in ADR-021 D8).

---

## [1.18.0] - 2026-03-24

### Added

**ADR-021: DISCOVER depth model, process decision tree, per-stage blocks, directory layout, and naming conventions**

- `STANDARDS.md` §2.1: **Process Decision Tree** (5-step routing: domain, urgency, scope, type, addenda) added before lifecycle diagram. Concise form at point of use; edge cases in `docs/adoption.md` Part 2.
- `STANDARDS.md` §2.1: **DISCOVER depth model** (D0 Capture, D1 Triage, D2 Characterize) added as structured table within DISCOVER stage description. D0 and D1 apply to all signals; D2 applies when AC cannot yet be written. Each depth has defined entry condition, activities, artifact, and exit. Registry consultation (§8.3, §8.4) shifted to D1 triage step.
- `STANDARDS.md` §2.1: **Per-stage operational blocks**  -  9-stage table (DISCOVER through CLOSE) with Input, Artifacts, and Addenda columns. All 7 addenda mapped to their activating stages with template links. Each addendum also contains a cross-reference to this table as the source of truth.
- `STANDARDS.md` §2.1: **DMAIC vocabulary bridge** paragraph after PDCA mapping. Define = DISCOVER + DEFINE; Measure = baseline in DEFINE + metric verification in VERIFY; Analyze = DISCOVER D2 + DESIGN qualification; Improve = BUILD; Control = MONITOR + CLOSE + registries.
- `STANDARDS.md` §1.2: **Cross-lifecycle mapping table** (§1.2 Steps 1-5 mapped to DISCOVER/DEFINE/DESIGN/BUILD-CLOSE lifecycle stages).
- `STANDARDS.md` §2.2: **Compliant tracked work item systems** paragraph  -  a tracked system capturing all 8 attributes, lifecycle status, and gate evidence satisfies the work item record requirement. ADR-019 export obligation for private systems. **Intake log discovery source pattern** added: "promoted from intake log entry [date]" as 5th discovery source type.
- `STANDARDS.md` §2.7: Expanded from 3 to **5 required elements**: signal capture format, intake channel, triage cadence, promotion path to work items, user notification. Reframed as signal source opening (user feedback is the primary DISCOVER input).
- `starters/intake-log.md`: **New file**  -  log-format starter for DISCOVER D0/D1 signal capture. Date/Signal/Source/Triage Decision/Outcome table; triage options (promote/investigate/park/discard); §2.1 and §2.7 references; D0/D1/D2 notes; expedite back-fill note.
- `docs/adoption.md`: **3-part practitioner journey restructure**  -  Part 1: Adoption (7 First Steps including intake channel, triage cadence, first-signal routing); Part 2: Operating the Lifecycle (decision tree edge cases, 23-file template guide across 6 phases, 9x7 cross-cutting activation summary derived from §2.1); Part 3: Improvement and Reference (CI addendum connection with 4 named entry points, Feedback). Title updated to "Adopting and Operating Excellence Standards - Engineering."
- `starters/repo-structure.md`: **Naming conventions section** with per-directory convention table (typed prefixes, date-based numbering default, sequential alternative); conditional directories table; 3 new adoption checklist items (naming scheme, intake channel, triage cadence).
- `templates/problem-research.md`: **Dual-role note**  -  full depth for §1.2 Step 1 complex products; abbreviated (Problem Statement + Decision only) for DISCOVER D2 feature characterization.
- `docs/addenda/*.md` (7 files): **Cross-reference sentence** added to each addendum pointing to §2.1 per-stage blocks as source of truth for lifecycle-stage activation.
- `templates/compliance-review.md`: **Per-stage requirements verified** column added to Applicable Addenda section; 5 new §2 rows: DISCOVER depth model, decision tree, intake channel, triage cadence, §2.2-compliant system.
- `dependencies.md`: **ISO 9001** (2015) and **ISO 27001** (2022) entries added  -  both cited in §1 scope statement; ISO 9001 §4.4 grounds per-stage Input/Artifact/Addenda format.

### Changed

- `examples/` directory split into `templates/` (15 reusable templates) + `starters/` (8 one-time adoption files). All `-template` suffixes dropped. All 150+ links across 30+ files updated. `examples/` directory removed.
- `STANDARDS.md` §2.1: "Every piece of work follows this sequence without exception" qualified to "Every piece of work that enters the delivery system follows this sequence." Signals discarded or parked at DISCOVER do not follow the sequence.
- `STANDARDS.md` §2.1: PDCA mapping note added  -  "A signal that does not proceed to DEFINE is evaluated, not planned work."
- `STANDARDS.md` §1.2: Bug-fix entry point language changed from "goes directly to implementation" to "enters at DISCOVER and proceeds to DEFINE after triage."
- `docs/requirement-index.md`: Process Routing sub-section added within Methodology; 6 new entries (DISCOVER depth, intake log, decision tree, per-stage blocks, compliant system, DMAIC); §2.7 entry updated to 5 elements; Evidence required entry rephrased for two-stage DISCOVER/DEFINE flow.
- `docs/standards-application.md`: §2.7 expanded to 5 elements with ESE-specific values; Naming Conventions section added (sequential numbering, intake log N/A); §2.2-compliant system and ADR-019 export status noted.
- `README.md`: Structure tree updated to show `templates/` (15 files) and `starters/` (8 files including intake-log.md); adoption.md description updated to "Adoption guide and operational reference."
- `docs/incidents/anti-patterns.md`: Template-Standard Drift entry updated  -  "templates/ or starters/" replacing "examples/".
- `docs/incidents/lessons-learned.md`: "templates/ or starters/" replacing "examples/" in the lesson about new template navigation.

---

## [1.17.0] - 2026-03-24

### Added
- `STANDARDS.md` §1.2: **Completion gates** paragraph added after the fast-path note. States that each step is complete when its template gate is satisfied, not when a document exists. Names the gate for each step: problem research (proceed/no-proceed decision), capabilities (gate authority approval), PRD (gate authority approval before DESIGN), architecture (all qualifying ADRs accepted and FMEA complete). Closes the gap where a practitioner could not tell when a document progression step was done enough to advance.
- `STANDARDS.md` §1.3: **Measurable milestone** bullet extended with a binary-verifiability test and a concrete weak-vs-strong example. Weak: "core features are working." Strong: "all P1 PRD requirements pass acceptance testing in staging and P95 latency is at or below the §7.5 SLO target." Test: could someone who did not build this phase verify it independently?
- `STANDARDS.md` §1.5: **Practical classification** paragraph added after the domain applicability text. Two-question heuristic: (1) can you write acceptance criteria before you start? (2) does the correct approach depend on what experiments reveal? Yes to (1) and no to (2) = Complicated, ESE in full. The paragraph includes the signal that work has crossed from Complex to Complicated: you can now write AC you are confident will not change based on what you discover next.
- `templates/work-item.md`: **Where this fits** and **Template relationships by type** sections added to the header. Clarifies the work item is the implementation ticket - not the place to discover or define requirements. Explains the §1.2 document progression precedes this template for new products/features. Maps each work item type to its template relationship: type=investigation pairs with investigation-template.md; type=feature may reference a PRD as triggered-by; other types (bug, debt, improvement, prevention, countermeasure, security, component) use this template as the sole artifact.

### Fixed
- `README.md` "What This Is Not": removed redundant `(but see [adoption guide](docs/adoption.md))` parenthetical. The "How to Adopt" section immediately below is the correct location for this reference; the parenthetical created two mentions within six lines.

---

## [1.16.0] - 2026-03-24

### Fixed
- `STANDARDS.md` §2.2 type table: investigation row now references §1.2 measurement-driven exception and links to `templates/investigation.md`. Template existed since v1.15.0 but was unreachable via standard navigation.
- `STANDARDS.md` §2.2 work item accessibility: added link to `templates/work-item-export.md` as the export format template for private-system teams. Template existed since v1.15.0 but was unreachable.
- `docs/adoption.md` "What You Get": section count corrected from 10 to 9 (§10 dissolved in v1.14.0 ADR-020; "handoff" was listed as a section that no longer exists); template count corrected from 19 to 22 (three templates added in v1.15.0); relative-path dependency count corrected from 25 to 32 (verified by grep; count had been stale since v1.9.0).
- `README.md` structure tree: template count corrected from 19 to 22; `work-item-template.md`, `investigation-template.md`, and `work-item-export-template.md` (all added v1.15.0) added to the listing.
- `docs/requirement-index.md` §2.3 entry: DoD criterion count corrected from 8 to 9 (new person readiness was moved from §10.4 to §2.3 in v1.14.0 ADR-020 but the index count was never updated).
- `docs/standards-application.md`: Added four sections required by the template but absent from the applied document: §2.7 User Feedback Mechanism, §8.5 Incident Communication Channel, §8.6 Technical Debt Tracking, Active Improvement Initiatives. New Person Readiness date updated from 2026-03-21 to 2026-03-24. Branch protection gap tracking note updated.
- `templates/compliance-review.md`: Added 14 missing rows across five sections. §1 now includes §1.5 (domain applicability). §2 now includes §2.1 DISCOVER registry consultation, §2.1 DESIGN FMEA trigger, §2.2 work item type field, §2.2 discovery source, §2.5 security review gate, §2.6 WIP/batch, §2.8 status visibility. §4 now includes §4.4 (ToC), §4.6 (work session logs), §4.7 (document cascade), §4.8 (documentation layers, moved from §10.1 ADR-020). §5 now includes §5.10 (minimum security baseline, moved from §10.5 ADR-020). §2.3 DoD description updated to "(9 criteria including new person readiness and work item accessibility)".
- `templates/adr.md`: Clarified frontmatter guidance - "Fill in all five fields" corrected to "The five CI-required fields are: type, id, title, status, date. The deciders field is recommended but not enforced by CI."
- `docs/decisions/ADR-011`: Validation section modernized to structured pass/trigger/failure format per §4.2. Gap 2 ("at least one project has completed a compliance review") updated to confirmed satisfied as of 2026-03-24.
- `docs/incidents/lessons-learned.md`: Added four entries from 2026-03-23 and 2026-03-24 compliance review sessions covering: template-standard drift (compliance-review-template.md missing rows), standards-application.md missing template-required sections, and unreferenced orphan templates.

### Added
- `docs/requirement-index.md`: Two new Methodology entries: "Consult lessons-learned and anti-pattern registries before creating a work item; when relevant entry found, note it and check scope/AC/design" (§2.1 DISCOVER); "FMEA required before BUILD for features touching authentication, payments, data mutation, or external integrations" (§2.1 DESIGN). Two new Documentation entries for `investigation-template.md` and `work-item-export-template.md`.
- `docs/incidents/anti-patterns.md`: "Template-Standard Drift" anti-pattern added. Pattern: updating STANDARDS.md or a template without updating the documents that apply them (compliance-review-template.md rows, standards-application.md sections, README.md listing). Found in 2+ compliance review cycles, qualifying for promotion per §8.4(c).

### Changed
- `STANDARDS.md` §2.1 DISCOVER: added guidance on what to do when a relevant lessons-learned or anti-pattern entry is found during the required registry consultation (note it in discovered-from field; check whether it informs scope, AC, or design; confirm the proposed approach does not repeat a named anti-pattern).
- `STANDARDS.md` §8.4: anti-pattern promotion threshold expanded from "(a) 2+ post-mortems OR (b) single P0 systemic" to add "(c) compliance review surfaces the same named pattern across 2+ review cycles." Aligns the standard with how ESE itself uses its own anti-pattern registry.
- `STANDARDS.md` §2.4: "the change is recorded" now specifies where: "in the runbook's named owner field and in the project's standards-application document."
- `STANDARDS.md` §6.1: regression test retirement "documented justification" now specifies where: "recorded both in the work item that authorizes the retirement and as a code comment at the test's former location."
- `docs/standards-application.md`: Standard version updated to 1.16.0; compliance review coverage updated to v1.7.0 through v1.15.0.

---

## [1.15.0] - 2026-03-24

### Added
- `STANDARDS.md` §2.2: Work item type field added as 8th required attribute. 9-type taxonomy (feature, bug, debt, investigation, improvement, component, security, prevention, countermeasure) with conditional DESIGN gates and close conditions per type.
- `STANDARDS.md` §2.2: Discovery source relationship types (discovered-from, triggered-by, blocking-dep, observed directly) replacing single "discovering work item" field.
- `STANDARDS.md` §2.3: Type-conditional Definition of Done tier. Universal checklist unchanged; type-specific close requirements added for all 9 types (bug requires regression test, P0/P1 bug requires post-mortem, investigation requires root cause + implementation work item, etc.).
- `STANDARDS.md` §2.1 DISCOVER: lessons-learned registry (§8.3) and anti-pattern registry (§8.4) consultation now required before work item creation.
- `STANDARDS.md` §2.1 DESIGN: qualification checklist format with ADR/FMEA/architecture-doc binary checks. Architecture doc existence check added per §3.3.
- `STANDARDS.md` §2.1 VERIFY: record VERIFY answer in work item field required before CLOSE.
- `STANDARDS.md` §2.1 DEPLOY: explicit §5.7 rollout strategy and rollback trigger pre-deployment reference.
- `STANDARDS.md` §2.1 MONITOR: record MONITOR answer in work item field required before CLOSE.
- `STANDARDS.md` §2.1 DEFINE: baseline measurement required for improvement-type work items.
- `STANDARDS.md` §8.4: quantified anti-pattern promotion threshold (2+ post-mortems with same pattern, or single P0 with systemic contributing factor).
- `STANDARDS.md` §8.6: source document update required when debt work item closes.
- `STANDARDS.md` §9.1: adoption threshold defined (new package/service or behavior-category version change; stable-API bumps are §5.2 dependency updates).
- `templates/work-item.md`: new template with all 8 §2.2 attributes, DESIGN qualification checklist, VERIFY/MONITOR answer fields, gate evidence section, type-conditional close requirements for all 9 types, applicable addenda section, universal DoD checklist.
- `templates/investigation.md`: new template for type=investigation work items with root cause statement, implementation work items, measurement-driven exception field.
- `templates/work-item-export.md`: new template for ADR-019 private-system export format.

### Changed
- `STANDARDS.md` §1.2: clarified bug-fix skips document progression (steps 1-4) not §2.1 lifecycle.
- `STANDARDS.md` §2.2: root-cause requirement explicitly applies at all severity levels independently of post-mortem.
- `STANDARDS.md` §2.3: "tests written and passing" expanded to reference full §6.1 test pyramid (unit, integration, system, regression for bugs).
- `templates/post-mortem.md`: added Systemic Issue Assessment (A3 trigger), Regression Cases section (§8.1), FMEA Update Check, Prevention table with Work Item ID + Status columns and §2.2 work item creation instruction.
- `templates/a3.md`: added Work Item ID column to Countermeasures table with §2.2 filing instruction; added lessons-learned registry prompt to Follow-Up.
- `templates/fmea.md`: renamed Action Required to Action Required / Work Item ID; added §2.2 work item creation instruction; added review checklist item for work item IDs.
- `templates/architecture-doc.md`: added Work Item ID column to gap table; added Risk Analysis section with FMEA/FTA cross-references.
- `templates/adr.md`: added Supersedes field; added Follow-on Requirements section with FMEA trigger check.
- `templates/prd.md`: approval gates before DESIGN; SLO prerequisite for always-on availability requirements.
- `templates/problem-research.md`: Proceed decision creates §2.2 work item.
- `starters/standards-application.md`: added Active Improvement Initiatives section; Delivery Health Metrics table gains Trend column with two-period-decline trigger; testing gaps table includes addenda merge instruction.
- `templates/work-session-log.md`: open items require §2.2-compliant work item IDs.
- `templates/compliance-review.md`: added Document Verification section with §2.1 VERIFY checklist; sign-off blocked until gaps have work item IDs; §6 section has addenda testing check.
- `docs/requirement-index.md`: updated attribute count from 7 to 8; added work item type requirement.
- `docs/standards-application.md`: added §4.3 Changelog Compliance section; version updated to 1.15.0.

---

## [1.14.0] - 2026-03-24

### Changed (structural, per ADR-020)
- `STANDARDS.md`: §10 (Implementation and Handoff) dissolved. All requirements redistributed:
  - §10.1 (Documentation Layers) moved to §4.8
  - §10.2 (Required Before Any Merge) merged into §5.1 as a "Readability test" paragraph preserving the reader-perspective framing distinct from the author-side pre-merge checklist
  - §10.3 (Handoff Checklist) merged into §2.3 as "Handoff verification" with domain-organized headings (Code, Documentation, Infrastructure, Testing, Security)
  - §10.4 (New Person Readiness Test) merged into §2.3 as a Definition of Done checklist item
  - §10.5 (Minimum Security Baseline) moved to §5.10
- `STANDARDS.md` §2.6: TIMWOODS waste taxonomy table removed (DRY violation with continuous-improvement addendum). Replaced with one-sentence pointer to the addendum's Waste Audit Methods section.
- `STANDARDS.md` §7.7: Statistical process control context (320 words) relocated to docs/background.md. Three gate sentences remain inline: validate before trusting, distinguish signal from noise, measure process capability.
- `STANDARDS.md`: Section count reduced from 10 to 9. §1-§9 numbering preserved; no renumbering cascade.
- `STANDARDS.md`: Line count reduced from 835 to 790.
- `docs/decisions/ADR-020-standards-restructure-and-simplification.md`: Status changed from Proposed to Accepted.
- All cross-references updated: requirement-index.md, 7 templates (runbook, architecture-doc, prd, setup, post-mortem, repo-structure, tech-eval, standards-application, compliance-review), 3 ADRs (008, 010, 011, 019), dependencies.md, continuous-improvement addendum. §10.x anchors replaced with new locations (§4.8, §5.1, §5.10, §2.3).
- `README.md`: Section count updated from 10 to 9.
- `templates/compliance-review.md`: §10 section replaced with dissolution note pointing to new locations.

---

## [1.13.0] - 2026-03-24

### Fixed
- Addenda tables: all 5 files listing addenda now show all 7. `starters/standards-application.md` was missing Event-Driven and Continuous Improvement. `docs/standards-application.md` was missing Continuous Improvement. `templates/prd.md` was missing Containerized and Continuous Improvement. `templates/compliance-review.md` was missing 4 of 7 (Multi-Service, Multi-Team, Containerized, Continuous Improvement). `docs/adoption.md` "First Steps" was missing Continuous Improvement.
- Broken relative links in 4 work session logs: `../templates/work-session-log.md` corrected to `../../templates/work-session-log.md` (from `docs/work-sessions/`, `../` resolves to `docs/`, not the repo root). `../STANDARDS.md` corrected to `../../STANDARDS.md` in one log.
- `docs/requirement-index.md`: 9 missing section entries added. §1.1 (problem statement, success metrics, failure criteria), §1.3 (phase definitions), §1.4 (project first principles), §1.5 (domain applicability), §5.3 (multi-repository coordination), §8.7 (A3 structured problem solving), and new Implementation and Handoff domain with §10.1, §10.2, §10.3, §10.4. Index now covers all 55 subsections in STANDARDS.md.
- `STANDARDS.md` §4.1 documentation table: `docs/setup.md` and `docs/deployment.md` rows now link to their templates (setup-template.md, deployment-template.md). Compliance review row added linking to compliance-review-template.md. These 3 templates existed but were unreferenced from the standard that requires them.
- `starters/standards-application.md`: §2.7 User Feedback Mechanism section added (3 required elements per §2.7). §8.6 Technical Debt Tracking section added with work-item-level tracking table.
- `templates/prd.md`: Success Metrics table expanded with Achievable and Relevant columns. §1.1 requires all five SMART dimensions; the template previously prompted for only three (Specific, Measurable, Time-bounded).

---

## [1.12.0] - 2026-03-24

### Changed
- `docs/addenda/ai-ml.md` Evaluation Harness: threshold requirement strengthened from descriptive to gate. Three changes: (1) evaluation harness now explicitly required in CI pipeline on every proposed change, not just "before shipping"; (2) threshold must be committed to the repository before evaluation begins, in a named file, using either an absolute floor or a relative decline ceiling; setting thresholds after seeing results is named as theater; (3) CI must fail (not warn) when the threshold is breached - a pipeline that reports a breach but still produces a deployable artifact is not gated. Per.
- `docs/addenda/ai-ml.md` Testing Gap Audit: "No evaluation threshold in CI" row updated to specify both missing threshold and CI-warns-instead-of-fails as the P0 gap condition.

### Fixed (structural)
- `background/research.md` moved to `docs/background.md`. `background/` was a non-conformant root directory: the repo-structure-template requires all documentation in `docs/`. The file is the research corpus for why each STANDARDS.md section exists and what was evaluated. References in `docs/standards-application.md` (2 occurrences), `docs/work-sessions/2026-03-19-final-audit-and-completion.md` (1), and `README.md` (structure inventory) updated.
- `README.md` structure tree: ADR range updated from ADR-001 through ADR-017 to ADR-001 through ADR-019 (two new ADRs this session). `docs/background.md` added to structure tree.
- `docs/.DS_Store` was present on disk but was never tracked in git (`.gitignore` `.DS_Store` rule was in effect). No action required; verified clean.

---

## [1.11.0] - 2026-03-24

### Added
- `STANDARDS.md` §2.2: "Work item accessibility" paragraph added after the backlog hygiene paragraph. Work item records are now a required audit artifact: the system must be accessible to authorized reviewers for the life of the project. Projects using private systems must export closed work item records to a committed location in the repository at close time. Per ADR-019.
- `STANDARDS.md` §2.3: Eighth Definition of Done criterion added: "Work item record accessible: stored in a system accessible to authorized reviewers, or exported to the repository at close." Per ADR-019.
- `docs/decisions/ADR-019-work-item-accessibility-requirement.md`: Decision to add accessibility requirement. Context covers the specific §2.1/§2.2/§2.3 gaps a private work item system creates. Decision covers both the principle and the fallback (export to repository). Alternatives: require public system (too prescriptive), unconditional repo storage (redundant for public systems), mandated format (deferred as tooling detail). Validation: first adoption review where a reviewer lacks access to the team's work item system.
- `docs/requirement-index.md`: Two new Methodology entries for §2.2 work item accessibility and §2.3 updated DoD criterion count (7 to 8).

---

## [1.10.0] - 2026-03-24

### Changed
- `STANDARDS.md` intro: "Two levels of documentation" block removed. This block duplicated the content of `docs/adoption.md` "First Steps After Adoption" and "What Your Project Produces" sections. The "Where to start" line is retained as a single pointer to adoption.md. Per ADR-018.
- `docs/decisions/ADR-007-single-source-of-truth-standards-md.md`: Status updated to "Superseded by ADR-018." Supersession note added to the document body. ADR-007's validation criterion fired when docs/adoption.md was created in v1.2.0; the ADR was never updated at that time.

### Added
- `docs/decisions/ADR-018-adoption-guide-separate-document.md`: New ADR documenting that docs/adoption.md is the correct and intended home for adoption guidance. Supersedes ADR-007. Context covers why the original ADR-007 decision was correct at the time but was overtaken by the creation of adoption.md. Decision: separate adoption guide is the right structure; STANDARDS.md carries the standard, adoption.md carries the setup guidance.

---

## [1.9.0] - 2026-03-24

### Added
- `templates/adr.md`: YAML frontmatter block added (`type`, `id`, `title`, `status`, `date`, `deciders`). The CI gate (Check 2) enforces these fields on all `docs/decisions/*.md` files; the template previously used inline bold metadata, causing any ADR created from it to fail CI immediately.
- `templates/architecture-doc.md`: "Fault Tree Analysis and Reliability" section added for always-on services with defined SLOs. §3.1 requires FTA (top-down failure tree through AND/OR logic gates) and a reliability block diagram (component availability table, single points of failure, combined availability) before BUILD for this class of component. The template had no placeholder for either.
- `starters/standards-application.md`: "Incident Communication Channel" section added. §8.5 requires every project to define its user communication channel before the first incident occurs; the template had no prompt for this.
- `templates/compliance-review.md`: Eight missing rows added across four sections: §2.2 class of service requirement, §2.2 root cause / symptom-fix link requirement (both added v1.5.0/v1.6.0), §6.4 stop-the-line Jidoka requirement (added v1.4.0), §6.5 security regression standard, §7.7 measurement system validation and common vs. special cause distinction (added v1.3.0), §8.5 incident communication channel, §8.6 technical debt tracking, §8.7 A3 for non-incident improvement (added v1.7.0). The compliance review template was not updated when these sections were added, creating a gap where a passing compliance review could miss eight requirements.
- `templates/prd.md`: FMEA trigger added to "Next Step" section. §2.1 DESIGN requires an FMEA before BUILD for features touching authentication, payments, data mutation, or external integrations; the template's next-step guidance only referenced architecture docs and ADRs, leaving practitioners without a prompt.
- `docs/standards-application.md`: Testing gaps table updated. "No automated link validation" gap marked resolved (CI Check 3, 2026-03-23). "No automated typographic indicator check" gap updated to reflect partial resolution (CI Check 1 covers Unicode dashes; ASCII double-hyphen sentence dashes remain an open sub-gap). Branch protection gap added as a new open row (P2: CI gates are advisory only; merges not blocked until GitHub branch protection is configured).

### Fixed
- `README.md`: ADR range updated from "ADR-001 through ADR-011" to "ADR-001 through ADR-017" (17 ADRs now exist). Template count updated from 17 to 19 (fmea-template.md and a3-template.md, both added v1.7.0, were not listed or counted). Addenda list updated with continuous-improvement.md (added v1.7.0, was absent from the structure tree).
- `docs/adoption.md`: Template count updated from 17 to 19. Addenda count and parenthetical list updated from 6 to 7 (continuous improvement added). Relative-path dependency count updated from 20 to 25 (count went stale when new templates and addenda were added post v1.1.0).
- `docs/standards-application.md`: "Last updated" date corrected from 2026-03-23 to 2026-03-24.
- `.github/workflows/ci.yml`: Em dash scan extended to detect ASCII double-hyphen sentence dashes (two hyphens flanked by spaces, in prose context). §2.1 VERIFY prohibits em dashes, en dashes, and double hyphens used as sentence dashes; the CI previously checked only the Unicode forms. The updated check skips YAML frontmatter, code fences, indented code blocks, and table rows to avoid false positives on structural uses of hyphens.
- `docs/work-sessions/research-iterative-investigation-loops.md`, `research-agree-vs-approve-prd-template.md`, `2026-03-23-ese-bead-audit-and-v1.7.0-release.md`, `2026-03-23-ese-quality-framework-expansion.md`, `2026-03-23-ese-release-readiness-final.md`, `2026-03-24-ese-compliance-and-ci-addendum.md`: ASCII double-hyphen sentence dashes replaced with appropriate punctuation (semicolons, colons, parentheses). These files were missed by the v1.8.0 double-hyphen sweep, which covered active content files but not work session logs.

---

## [1.8.0] - 2026-03-24

### Added
- `docs/adoption.md`: Table of Contents added listing all 7 top-level sections with anchor links. ESE §4.4 requires a ToC for any document with more than three sections; adoption.md had 7 sections and no ToC.
- `dependencies.md`: Theory of Constraints (Goldratt, 1984) entry added. STANDARDS.md §2.6 cited '(Goldratt, 1984)' with no URL and no dependency tracker entry, violating ESE §9.3. Entry includes URL, publication date, and usage notes.
- `docs/addenda/continuous-improvement.md`: Quality Function Deployment (QFD) section added. Covers purpose, when to apply, simplified House of Quality template with relationship matrix, and connection to ESE §1.1 success metrics and §2.7 user feedback. QFD is the translation layer between user needs (§2.7 input) and measurable acceptance criteria (§1.1 output).
- `docs/addenda/continuous-improvement.md`: SIPOC section added. Covers purpose, when to apply (before VSM or Kaizen events), one-page SIPOC template (Suppliers, Inputs, Process, Outputs, Customers), and connection to ESE §1.1 explicit scope boundaries. SIPOC is the §1.1 scope statement for improvement work itself.
- `docs/addenda/continuous-improvement.md`: Design of Experiments (DoE) section added. Covers purpose, when to apply (multi-variable systems, A/B tests, ML hyperparameter tuning), three basic design types (full factorial, fractional factorial, screening/Plackett-Burman), and explicit connection to §2.1 VERIFY requirement that multi-variable improvements must attribute effect to specific causes.
- `docs/addenda/continuous-improvement.md`: Gemba section added. Covers purpose, when to apply (before any improvement initiative), what to observe in software context (production logs, monitoring dashboards, deployment runs, user sessions), and connection to ESE §7 monitoring infrastructure as the Gemba walk mechanism.
- `docs/addenda/continuous-improvement.md`: Drum-Buffer-Rope section added. Covers purpose, when to apply (after constraint identified), the three components (drum as constraint, buffer as protected upstream inventory, rope as intake control), practical implementation steps, and connection to ESE §2.6 WIP limits as the constraint-aware synchronization layer.
- `docs/addenda/continuous-improvement.md`: Heijunka section added. Covers purpose, when to apply (irregular cadence, large batch releases, overload-then-idle cycles), three leveling approaches for software (continuous deployment, intake limits, demand shaping), measurement approach (deployment frequency variance), and connection to ESE §2.6 small batches and §5.7 deployment strategies.
- `docs/addenda/continuous-improvement.md`: SMED for Software section added. Covers purpose, when to apply (setup time thresholds: local setup over 15 min, CI feedback over 10 min, deployment over 30 min), 5-step measurement approach, and connection to ESE §10.2 (clone-to-running time) and §5.5 (CI pipeline feedback value).
- `docs/addenda/continuous-improvement.md`: Kaizen Events section extended with §2.7 user feedback connection. Kaizen events improving user-facing behavior must close the §2.7 feedback loop by notifying affected users. §2.7 user feedback is also named as a valid source for identifying Kaizen event targets.

### Fixed
- `docs/decisions/ADR-007-single-source-of-truth-standards-md.md`: broken relative link fixed. `../STANDARDS.md` corrected to `../../STANDARDS.md` (from `docs/decisions/`, `../` resolves to `docs/`, not the repo root where STANDARDS.md lives).
- `STANDARDS.md` §2.6: bare '(Goldratt, 1984)' citation updated to include URL and 'tracked in dependencies.md' link, matching the citation pattern used for Conway's Law and Hyrum's Law.
- `STANDARDS.md`, `docs/addenda/continuous-improvement.md`, `docs/decisions/ADR-006/007/012/013/014/015`, `templates/a3.md`, `CHANGELOG.md`, `docs/adoption.md`: 43 double-hyphen sentence dashes replaced with commas, semicolons, colons, or parentheses. ESE §2.1 VERIFY prohibits double hyphens used as sentence dashes; the standard violated its own gate at scale. All violations introduced during the v1.7.0 quality framework expansion.

---

## [1.7.0] - 2026-03-23

### Changed
- `templates/prd.md`: Agreement section renamed to Approval. Multi-party sign-off lines replaced with a single `Approved - {name, role, date}` line with a note covering both single-operator and multi-party use cases. "Agreed" is consensus language; "Approved" is gate authority language matching ESE §1.4. Next Step line updated from "agreed on" to "approved".
- `templates/capabilities.md`: Same Agreement-to-Approval change applied. Framing updated to match ESE §1.4 gate authority language.

### Added
- `.github/workflows/ci.yml`: CI quality gate for pull requests. Checks: (1) em dash scan across all markdown files (fails on any U+2014 or U+2013 character); (2) ADR frontmatter validation (confirms all docs/decisions/*.md files have required YAML fields: type, id, title, status, date); (3) internal markdown link validation (confirms all relative links in .md files resolve); (4) CHANGELOG structure check (confirms CHANGELOG.md exists and has version entries). Merge is blocked if any check fails. Satisfies ESE §5.5 CI requirement for the documentation repository.
- `docs/addenda/continuous-improvement.md`: new first-party addendum for projects with recurring quality issues, throughput below required rate, or sigma-level quality targets. Sections: Value Stream Mapping (method and steps), Kaizen Events (structure and measurement requirement), Process Capability Measurement (control chart basics, signal vs. noise, metric recommendations), FMEA in Practice (guidance on effective application beyond form-filling), Waste Audit Methods (walk-the-work-item and team conversation methods), Constraint Identification Methods (queue mapping, idle time analysis, utilization check), and Testing Gap Audit Additions (5 improvement-specific gaps). Addendum resolves dangling references in §2.6 and §7.4 ('see continuous-improvement addendum').
- `STANDARDS.md` §1.2: Measurement-driven investigations paragraph added after the fast-path note. Defines the recognized pattern for investigations whose acceptance criterion requires measured outcomes from a working prototype (the prototype IS the measurement instrument). Investigation work item stays open until measurement is complete; implementation work item is filed separately with a dependency on the parent investigation. Aligned with DMAIC Measure phase. Resolves the 'build to learn vs. learn to build' tension for this class of work without creating a general exemption from §1.2.
- `STANDARDS.md` Addenda table: Continuous Improvement addendum added with Apply-when condition.
- `docs/adoption.md`: Maturity Model Positioning section added between "What You Get" and "How to Adopt". Adopting ESE positions engineering processes at approximately CMMI Level 3 (Defined): documented, standardized, consistently applied processes. Level 4 (statistical process control) described as the next horizon; §7.7 Measurement Integrity provides the vocabulary foundation for it. CMMI added to dependencies.md.
- `STANDARDS.md` §3.1: FTA (Fault Tree Analysis) and reliability block diagrams added as required analyses for always-on services with defined SLOs. FTA works top-down from the undesired system-level failure through AND/OR logic gates to identify failure combinations; complements the bottom-up FMEA added to §2.1. Reliability block diagrams identify single points of failure and quantify component reliability impact on overall SLO compliance. ADR-016 updated to remove stale '(ADR forthcoming)' reference.
- `STANDARDS.md` §2.1 DESIGN: FMEA requirement added for features touching authentication, payments, data mutation, or external integrations. High-RPN failure modes and any Severity 9-10 failure mode require design changes or additional controls before BUILD begins. References new templates/fmea.md. Per ADR-016.
- `docs/decisions/ADR-016-fmea-design-requirement.md`: new ADR documenting the decision to require FMEA in the DESIGN step, with alternatives considered (no FMEA, generic checklist, FMEA for all features, optional guidance) and event-triggered validation criteria.
- `templates/fmea.md`: new FMEA template with Severity/Occurrence/Detectability rating scales, FMEA table with all required columns, and a complete worked example for a password reset authentication feature showing token entropy (RPN 216), token reuse (RPN 160), expiry enforcement (RPN 84), and rate limiting (RPN 180).
- `STANDARDS.md` §1.1: 'cost of current approach' bullet expanded to include Cost of Quality framing. Covers cost of poor quality (rework, incidents, support time, tech debt interest) and cost of good quality (testing, reviews, automation, process discipline). Total quality cost framing: the lowest-cost approach minimizes total cost, not quality investment alone.
- `STANDARDS.md` §8.6: Cost of Quality prioritization sentence added after 'Debt that is never reviewed grows silently until it causes an incident.' Directs teams to compare ongoing cost of carrying debt against resolution cost before prioritizing paydown.
- `STANDARDS.md` §8.2: Deming System of Profound Knowledge (SoPK) paragraph added after the blameless framing sentence. Covers all four SoPK components: appreciation for a system (failures are systemic, not individual), knowledge of variation (common vs special cause requires different responses), theory of knowledge (prevention actions are predictions that must be verified), and psychology (blameless environment is a prerequisite for accurate information, not a courtesy). Deming SoPK added to dependencies.md.
- `STANDARDS.md` §1.5 Domain Applicability (new subsection): Cynefin scope boundary added. ESE is calibrated for the Complicated domain; the Complex domain (novel AI architectures, emergent behavior, genuinely new problem spaces) requires probe-sense-respond and is outside ESE's prescriptive scope. Documentation and learning practices (§4.6, §8.2, §8.3) apply to Complex work; full lifecycle and gates apply when work transitions to Complicated. Snowden and Boone (2007) cited; added to dependencies.md. Per ADR-017.
- `docs/decisions/ADR-017-cynefin-scope-boundary.md`: new ADR documenting the decision to add §1.5, alternatives considered (no scope statement, separate addendum, different vocabulary, full five-domain model), and validation criteria.
- `STANDARDS.md` §3.2: 5S (Sort, Set in Order, Shine, Standardize, Sustain) added as a design principle for codebase hygiene. Software-specific meaning for each S: Sort removes dead code and stale branches; Set in Order enforces consistent project structure; Shine requires zero unexplained warnings and linting violations; Standardize uses linters and pre-commit hooks to enforce rules mechanically; Sustain uses automated gates to prevent regression to a prior state. Complements the existing Consistent Formatting principle with a broader codebase-hygiene framing.
- `STANDARDS.md` §8.7 A3 Structured Problem Solving: new subsection added as the tool for non-incident improvement problems (recurring quality issues, bottlenecks, process inefficiencies). Positioned explicitly as complement to §8.2 post-mortem, not a replacement. References new templates/a3.md.
- `templates/a3.md`: new A3 template with sections: Context, Current State, Root Cause Analysis (Five Whys), Target State, Countermeasures, Implementation Plan, and Follow-Up including verification and lessons-registry link.
- `STANDARDS.md` §7.4 work item cycle time: paragraph added defining cycle time (claimed to closed with evidence) as a required tracked metric. Distinguished from DORA lead time for changes, which measures code commit to deployment. Cycle time captures DEFINE, DESIGN, VERIFY, and DOCUMENT stages invisible to DORA.
- `STANDARDS.md` §7.4 hidden factory and compound yield: paragraph added requiring measurement of first-pass yield across delivery stages. Defines the hidden factory as rework within stages that does not appear as a formal failure but consumes capacity and explains the gap between stage-level metrics and production quality.
- `STANDARDS.md` §2.6 waste identification: paragraph and table added naming all 8 Lean software delivery wastes (TIMWOODS: Transportation, Inventory, Motion, Waiting, Overproduction, Overprocessing, Defects, Skills underutilization) with one software-specific example per waste. Waste audit defined as a recommended practice when delivery health declines. References §2.5 for toil (not duplicated) and the continuous-improvement addendum for structured audit methods.
- `STANDARDS.md` §2.6 constraint identification: paragraph added requiring teams to identify the binding system constraint before investing in any delivery improvement. Names the five focusing steps (Goldratt, 1984). References continuous-improvement addendum for methods.
- `STANDARDS.md` §2.6 delivery rate awareness: paragraph added requiring teams to compare required delivery rate against actual throughput before capacity and prioritization decisions. No calculation method prescribed.
- `STANDARDS.md` §2.1 VERIFY: added variance awareness requirement. When a claimed outcome is an improvement, VERIFY must confirm the change exceeds normal process variation, not just show a directional result. References §7.7 for method selection. No specific statistical test prescribed.
- `STANDARDS.md` §4 Standard Work principle: paragraph added to §4 introduction framing operational documentation (runbooks, deployment procedures, checklists) as Lean Standard Work: the current best-known method, not a static artifact. Explicitly links improvement of operational docs to the §8.3 lessons-learned cycle as the improvement mechanism.
- `STANDARDS.md` §2.1 PDCA vocabulary bridge: one paragraph added naming the Plan-Do-Check-Act mapping (Plan=DISCOVER/DEFINE/DESIGN, Do=BUILD, Check=VERIFY, Act=DOCUMENT/DEPLOY/MONITOR/CLOSE). No new requirements introduced. Vocabulary only, enabling practitioners from Lean, Six Sigma, and ISO backgrounds to connect the ESE lifecycle to their existing quality vocabulary.
- `docs/addenda/multi-team.md`: Testing Gap Audit Additions table added: RFC coverage test, on-call escalation path test, working agreement verification, cross-team dependency integration test, and independent deployability test. All five other first-party addenda had this table; multi-team was the only one missing it.
- `docs/adoption.md`: Feedback and Contributions section added. Defines GitHub Issues as the feedback channel for external adopters: reports, gaps, questions, and structural change proposals. Satisfies ESE §2.7 (every project must define how users report problems or requests).

### Fixed
- `README.md`: Current version updated from stale `1.2.0` to `1.6.2`.
- `docs/decisions/ADR-002-universal-standard-scope.md`: Validation criterion rewritten from time-bounded and subjective ("In six months of adoption: are teams finding...") to event-triggered and binary (confirmed at first adoption review). The prior criterion could not be answered with a binary pass/fail.
- `docs/decisions/ADR-004-first-party-addenda.md`: Validation criterion rewritten from time-bounded and subjective ("In six months: are teams using the addenda?") to event-triggered and binary (first adoption review trigger, binary pass condition). Same problem as ADR-002.
- `docs/decisions/ADR-005-practical-over-theoretical.md`: Validation criterion rewritten from time-bounded and subjective ("After one year of adoption: are teams following the standard as written?") to event-triggered and binary (first compliance review + first adoption review). Calendar window and subjective framing both removed.
- `docs/decisions/ADR-012-measurement-integrity-principles.md`: Validation criterion triggers changed from "after 90 days" / "after 180 days" to event-triggered ("at the first adoption review"; "at the first P1 or P0 incident post-mortem"). Binary pass conditions preserved.
- `docs/decisions/ADR-013-jidoka-placement.md`: Validation criterion triggers changed from "after 90 days" (twice) to event-triggered ("at the first post-mortem filed after adoption"; "at the first adoption review"). Binary pass conditions preserved.
- `docs/decisions/ADR-014-classes-of-service.md`: Validation criterion triggers changed from "after 90 days" (twice) to event-triggered ("at the first adoption review"; "at the first fixed-date work item missed after adoption"). Binary pass conditions preserved.

---

## [1.6.2] - 2026-03-23

### Fixed
- `docs/decisions/ADR-012-measurement-integrity-principles.md`: frontmatter status corrected from `proposed` to `Accepted` (effective 2026-03-22, merged in v1.3.0).
- `docs/decisions/ADR-013-jidoka-placement.md`: frontmatter status corrected from `proposed` to `Accepted` (effective 2026-03-22, merged in v1.4.0).
- `docs/decisions/ADR-014-classes-of-service.md`: frontmatter status corrected from `proposed` to `Accepted` (effective 2026-03-22, merged in v1.5.0).
- `docs/decisions/ADR-001 through ADR-011`: YAML frontmatter added to all 11 early ADRs; previously used inline bold metadata inconsistent with ADR-012 through ADR-015 format.
- `dependencies.md`: added Conway's Law and Hyrum's Law. Both are referenced in STANDARDS.md (§3.4, §5.8) with URLs but were absent from the dependency tracker, creating undetectable drift.
- `docs/requirement-index.md`: added two missing §2.2 entries for root cause identification requirement (added to STANDARDS.md in v1.6.0 but index was not updated; ADR-011 Gap 4 now complete).
- `docs/standards-application.md`: updated version to 1.6.2; compliance review date to 2026-03-23; gap-tracking section corrected per §9.2 intent (removed ADR inventory count, which belongs in docs/decisions/ not a gap tracker).
- `docs/adoption.md`: stale version example (v1.2.0) replaced with generic placeholder; pre-existing em dash in title fixed.
- `CHANGELOG.md` v1.5.0 entry: attribute count corrected from '5 to 6' to '6 to 7' (class of service is the 7th attribute).
- All `.md` files: 43 em dashes replaced with hyphens across 20 files including STANDARDS.md title, all 6 addenda, ADR-009/010/011, templates, work sessions. ESE violated its own §2.1 VERIFY checklist at scale.

### Changed
- `docs/decisions/ADR-003-section-order-by-work-phase.md`: Validation criterion rewritten from subjective ('does it flow naturally?') to binary adoption-triggered signal (zero section-reordering issues in first three adoption reviews).
- `docs/decisions/ADR-006-inline-vs-separate-templates.md`: Validation criterion rewritten to three binary signals each tied to first adoption review.
- `docs/decisions/ADR-007-single-source-of-truth-standards-md.md`: Validation criterion rewritten to binary adoption-triggered signal (adopter reached standards-application.md without requesting a separate guide).

---

## [1.6.1] - 2026-03-22

### Changed
- `templates/prd.md`: added pre-writing verification note: enumerate required sections against the standard before drafting. Prevents post-draft audit rework. References key sections (§1.1, §2.7, §6.3, §7.1, §7.5, §10.5, Addenda).

---

## [1.6.0] - 2026-03-22

### Added
- `STANDARDS.md` §2.2 root cause identification requirement: a work item must either address a root cause directly or identify itself as a symptom fix with a link to the root-cause work item as a dependency. A symptom fix without a root-cause link creates recurrence. When root cause is unknown, scope the item as an investigation. Per ADR-015.
- `docs/decisions/ADR-015-root-cause-work-item-discipline.md`: placement decision (§2.2), rejection of requiring root cause analysis on every item, rejection of root cause as a required 7th field.

---

## [1.5.0] - 2026-03-22

### Added
- `STANDARDS.md` §2.2 classes of service: four work item flow classes (expedite, fixed-date, standard, intangible) each with a defined cost-of-delay profile and flow policy. Added because P0-P4 severity (§8.1) was being used for scheduling decisions it was not designed for, causing fixed-date work to miss deadlines, intangible work to be perpetually displaced, and expedite work to wait in normal queues. Classes of service and P0-P4 severity are now explicitly orthogonal axes. Per ADR-014.
- `STANDARDS.md` §2.6 cross-reference: WIP limit interaction with expedite (suspends limit) and intangible (reserved capacity) classes.
- `docs/decisions/ADR-014-classes-of-service.md`: placement decision (§2.2 vs §2.6 vs §8.1 vs new §2.9) and rejection of redefining P0-P4.
- `docs/requirement-index.md`: five new methodology entries for class of service requirements; corrected pre-existing count of work item attributes from 6 to 7 (class of service is the 7th attribute; the index previously showed an incorrect count of 6 that pre-dated the addition of class of service).

---

## [1.4.0] - 2026-03-22

### Added
- `STANDARDS.md` §6.4 Jidoka paragraph: when a defect is detected, work stops until resolved; defects do not pass downstream regardless of schedule pressure; authority to stop is shared by every team member and automated gate. Added because §6.4 and §5.5 stated the mechanical requirements (no half-finished features, CI must pass) without the principle behind them, leaving practitioners without a named reason to resist schedule pressure to carry defects forward. Per ADR-013.
- `docs/decisions/ADR-013-jidoka-placement.md`: placement decision for Jidoka paragraph in §6.4 vs §2.1 BUILD vs new §6.6.
- `docs/requirement-index.md`: two new testing entries for §6.4 Jidoka requirements.

---

## [1.3.0] - 2026-03-22

### Added
- `STANDARDS.md` §7.7 Measurement Integrity: three required principles for all monitoring and observability work: validate measurement systems before trusting metrics (MSA principle); distinguish common cause from special cause variation before responding to signals (SPC principle); measure process capability, not only threshold breaches. Added because existing §7 requirements could be satisfied using metrics that do not accurately represent system behavior, producing responses to phantom signals while real degradation goes undetected. Closes this gap and adds the vocabulary of tampering and process capability to the standard's monitoring requirements. Applies to all §7 metrics: health checks, delivery health, SLOs, observability telemetry. Per ADR-012.
- `docs/decisions/ADR-012-measurement-integrity-principles.md`: decision to add §7.7, rationale for new section (not §7.4 expansion), and rejection of prescribing specific methods (SPC charts, Cp/Cpk) in core standard.
- `docs/requirement-index.md`: three new monitoring entries for §7.7 measurement integrity requirements.

---

## [1.2.0] - 2026-03-21

### Added
- ADR-009: changelog placement - "standalone document" defined, repo rule reordered first, clarifying example added.
- ADR-010: archived document handling - docs/archive/ convention, supersession note, frontmatter schema.
- ADR-011: four structural improvements toward ISO-equivalent rigor (evidence tracking, audit cadence, scope statement, domain index). All 4 gaps implemented.
- `STANDARDS.md` §1: scope statement added - what this standard covers and does not cover (formal risk assessment, external certification, regulated industries).
- `docs/requirement-index.md`: domain-organized view of all requirements (security, documentation, testing, monitoring, methodology, architecture, deployment, incident response, technology adoption, AI/ML, event-driven). Per ADR-011 Gap 4.
- `starters/standards-application.md`: Evidence and Last verified columns added to all 5 compliance-tracking tables (architecture docs, health checks, SLOs, testing gaps, tech decisions). Transforms gap tracker into Statement of Compliance per ADR-011 Gap 1.

### Added
- `docs/adoption.md`: how to bring these standards into a project - submodule setup, first steps, what your project produces.
- `starters/deployment.md`: deployment procedure, rollout strategy, rollback trigger, post-deployment verification. Per §4.1 and §5.7.
- `starters/setup.md`: prerequisites, clone-and-run, environment variables, common failures. Per §4.1 and §10.4.
- `templates/compliance-review.md`: structured internal audit for periodic ESE compliance reviews. Per ADR-011 Gap 2.

### Changed
- `STANDARDS.md` §4.3: "standalone document" defined; repo rule reordered first (common case); clarifying example added. Per ADR-009.
- `STANDARDS.md` §2.1 DOCUMENT step: supersession note added - move superseded docs to docs/archive/. Per ADR-010.
- `STANDARDS.md` §4.1: archived document frontmatter schema (status, superseded-by, date-archived). Per ADR-010.
- `STANDARDS.md` intro: adoption guide reference added to "Where to start" section.
- `starters/standards-application.md`: Evidence and Last verified columns on all 5 compliance tables; compliance review date fields at bottom.
- `templates/prd.md`: User Feedback section (§2.7), Applicable Addenda acknowledgment, SLO definition prompt on N-2.
- `starters/repo-structure.md`: docs/archive/ directory and File Purposes entry.
- `templates/problem-research.md`: "Could this be solved without new code?" prompt in Existing Landscape.
- `templates/capabilities.md`: Phase column replaces Status in Explicitly NOT Included table.

### Removed
- `docs/research/` directory - research findings are internal working documents, moved to private location. ADRs in `docs/decisions/` capture the distributable decisions.

---

## [1.1.3] - 2026-03-20

### Added
- `docs/standards-application.md`: ESE applying its own standard to itself. First principles, owner, gap status, applicable addenda (none), new person readiness check.
- `docs/work-sessions/`: directory created. Two existing session logs migrated from vault to ESE repo in proper template format. Today's session log written.
- `.gitignore`: OS files, editor configs, build artifacts excluded.
- docs/incidents/lessons-learned.md: entry for CHANGELOG entries written from memory instead of from git log.

---

## [1.1.2] - 2026-03-19

### Added
- §5.6: system-level disaster recovery documentation requirement for always-on services. §5.6 already required infrastructure reproducibility from the repository; this adds the explicit requirement to document the restore procedure, define a system-level Recovery Time Objective, and verify the recovery path on a tested cadence.
- docs/decisions/ADR-008: external practitioner review evaluation - what was incorporated (DR documentation), what was not (seven items), and the rationale for each. Alternatives considered cover ISO document control, Current/Optimal/Recommended State framework, weakest link principle, interoperability matrices, UI/UX standards, naming prescription, and compatibility matrices.
- background/research.md: maintenance convention (ADRs are the required artifact per §4.2; research.md is supplementary) and excluded items list referencing ADR-008.
- docs/incidents: lessons-learned and anti-patterns entries for committing a STANDARDS.md change without its ADR.

---

## [1.1.1] - 2026-03-19

### Fixed
- Renamed `starters/project-application.md` (formerly `standards-application.md`) to `starters/standards-application.md`. The live filename (`docs/standards-application.md`), the template's own title ("Engineering Standards Application"), and README all used "standards application" while the template filename used "project application." All references updated throughout STANDARDS.md, addenda, ADRs, and repo-structure-template.md. (Note: file subsequently moved from `examples/` to `starters/` per ADR-021 D9.)

---

## [1.1.0] - 2026-03-19

### Added

**New templates (templates/ and starters/):**
- `problem-research-template.md` - Step 1 of the §1.2 document progression. Covers problem statement, evidence quality check, first principles check, and decision record.
- `capabilities-template.md` - Step 2. Observable user abilities with explicit exclusions and agreement gate.
- `prd-template.md` - Step 3. Scope, functional and non-functional requirements, success metrics, failure criteria, and phases.
- `repo-structure-template.md` - Canonical directory layout for a compliant repo, with adoption checklist for new and pre-existing projects.

**New decisions:**
- `docs/decisions/ADR-007-single-source-of-truth-standards-md.md` - Documents the decision to keep all orientation content inline in STANDARDS.md rather than a separate getting-started guide. Rationale: DRY principle; a separate guide would duplicate the template reference table already inline throughout the standard.

**New incident registries:**
- `docs/incidents/lessons-learned.md` - ESE-specific lessons from the first work session on this standard: §2.1 DEFINE wording implicitly excluded documentation work; §2.1 VERIFY was undefined for documentation-only changes.
- `docs/incidents/anti-patterns.md` - ESE-specific anti-pattern: writing lifecycle gates in code-only terms, silently exempting documentation and configuration work.

### Changed

**STANDARDS.md:**
- Intro: added "Where to start" section distinguishing project-level setup (application document, repo structure) from per-deliverable documentation (§1.2 progression). Structured as indented bullet lists for readability.
- §1.2: each of the five document progression steps now links directly to its template.
- §1.4 item 4 (gate authority): added clarification that for ESE-governed projects, ESE compliance is the gate; for ESE itself, the standard's owner is the gate authority.
- §2.1 DEFINE: reworded from "before touching code" to "before starting any implementation work - code, documentation, configuration, or infrastructure." Closes the implicit exemption for documentation work.
- §2.1 VERIFY: added a seven-item documentation-only verification checklist covering internal links, formatting defects, typographic indicators, cross-reference hygiene, sentence integrity, template-to-standard alignment, and changelog. Resolves.
- §4.1: added reference to `starters/repo-structure.md` for standard repo layout.
- §8.3: added note on promoting lessons to the anti-pattern registry when they recur.
- §8.4: added cross-reference back to §8.3.
- §9.1: fixed sentence fragment in opening line.
- §9.2: reduced redundant [ADR] link repetition.
- All internal cross-references converted from plain text to hyperlinks throughout. Every mention of "Section X," "runbook," "ADR," "application document," "architecture doc," and similar navigational terms now links to the relevant section.
- All AI-generated typographic characters removed across the entire repository: em dashes (--), en dashes, and double hyphens used as sentence dashes replaced with single hyphens.

**Templates (templates/ and starters/):** All ten existing templates updated with comprehensive per-section inline backlinks to their governing STANDARDS.md sections, and expanded to cover all requirements stated in those sections. Specific additions:
- `architecture-doc-template.md`: added design principles alignment table, Conway's Law team alignment check, ADR reference table, security section.
- `runbook-template.md`: added deployment section with rollout strategy and rollback trigger, monitoring and alerts section, SLO reference, named owner field.
- `post-mortem-template.md`: added incident classification per §8.1, registry update prompts per §8.3 and §8.4.
- `standards-application-template.md`: added roadmap section (§1.3), named owner (§2.4), SLO definitions (§7.5), delivery health metrics (§7.4), new person readiness check (§10.4).
- `adr-template.md`: added inline backlinks to §4.2 and §2.1 for each required section.

### Fixed
- Addenda table in STANDARDS.md was corrupted by a bulk text replacement that appended partial duplicate lines after the last row. Truncated to the correct final row.
- §8.4 contained a duplicate sentence added during cross-referencing. Removed.
- §9.1 opening was a sentence fragment ("Before adopting any new technology, framework, or external service."). Fixed.

---

## [1.0.0] - 2026-03-19

Initial release.

**Unbundle all bundled REQ-IDs across 7 addenda ( children)**

- continuous-improvement.md: REQ-ADD-CI-19 (4 elemental) + CI-05 (5 SIPOC) + CI-61 (Kaizen feedback)
- ai-ml.md: REQ-ADD-AI-04 (4 containment) + AI-06 (4 governance) + AI-07 (4 monitoring)
- multi-team.md: REQ-ADD-MT-01 (3) + MT-02 (9 agreement topics) + MT-04 (6 release plan) + MT-06 (4 compat) + MT-08 (5 on-call)
- multi-service.md: REQ-ADD-MS-10 (4 arch doc items)
- event-driven.md: REQ-ADD-EVT-17 (4 sourcing items)
- containerized-systems.md: REQ-ADD-CTR-02 (3 probes) + CTR-04 (4 security context)
- web-applications.md: REQ-ADD-WEB-01 (4 vitals) + WEB-05 (5 a11y) + WEB-08 (4 l10n) + WEB-04 (5 headers)
