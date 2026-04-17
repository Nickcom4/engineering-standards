# ESE Agent Context

> **Scope:** Engineering-standards repo. Loaded by Claude Code when working from this directory.
> **Gate authority:** Nick Baker. All changes to STANDARDS.md, addenda, and ADRs require explicit human review.

---

## Table of Contents

- [About This Repo](#about-this-repo)
- [Hard Gates](#hard-gates)
- [Writing Standards](#writing-standards)
- [Commit Discipline](#commit-discipline)
- [Document Standards](#document-standards)
- [Content Boundaries](#content-boundaries)
- [Numeric Thresholds](#numeric-thresholds)
- [Agent Guidance (from audit)](#agent-guidance-from-audit)
- [Before Every Commit](#before-every-commit)

---

## About This Repo

Excellence Standards - Engineering (ESE) is a universal, domain-agnostic, stack-agnostic engineering standard. It defines software delivery gates across 9 sections with 771 machine-readable requirements. ESE applies its own standard to itself. Every change must pass 38 CI checks and maintain self-compliance.

**Key paths:**

| Path | Purpose |
|------|---------|
| `STANDARDS.md` | The authoritative standard (normative) |
| `docs/addenda/*.md` | Domain-specific extensions (normative) |
| `templates/*.md` | Multi-instance templates (normative) |
| `starters/*.md` | One-time adoption files (normative) |
| `docs/decisions/*.md` | ADRs (prescriptive) |
| `docs/standards-application.md` | ESE applying its own standard to itself |
| `CHANGELOG.md` | Version history (update with every change) |
| `enforcement-spec.yml` | 320 machine-readable gates (auto-generated) |
| `scripts/` | CI validation scripts and git hooks |

---

## Hard Gates

These are non-negotiable. Violating any of these blocks the change.

1. **Never add Co-Authored-By trailers or AI attribution to commits.** Commits are authored by the human gate authority. The `scripts/commit-msg` hook enforces this.
2. **Never push to origin without explicit instruction from Nick.** Changes stay local until reviewed.
3. **Always update CHANGELOG.md** for any change to STANDARDS.md, addenda, ADRs, templates, starters, or scripts.
4. **Always run CI checks** before considering work complete. At minimum: `bash scripts/validate-req-ids.sh && bash scripts/lint-req-tags.sh && bash scripts/generate-req-manifest.sh verify && bash scripts/generate-enforcement-spec.sh verify && bash scripts/generate-req-index.sh verify && bash scripts/lint-stale-counts.sh`.
5. **Always regenerate manifests** after changing STANDARDS.md or addenda: `bash scripts/generate-req-manifest.sh generate && bash scripts/generate-enforcement-spec.sh generate && bash scripts/generate-req-index.sh generate`.
6. **Atomic commits.** One logical change per commit. Commit message format: `type: description` or `type(scope): description`. Body explains why, not what.
7. **Never push a release without explicit gate authority instruction.** Per [ADR-2026-04-14](docs/decisions/ADR-2026-04-14-automate-release-mechanics-at-close-push-remains-gate-authority-only.md), local release mechanics (moving `[Unreleased]` to a versioned heading, bumping `Standard version applied:`, committing, applying a `vX.Y.Z` tag locally) are automated at CLOSE when preflight is green and the bump is patch or minor; major bumps and the externally-visible `git push` remain gate-authority-only. Until the ese-plugin lifecycle implements the automation, release ceremonies continue to be executed manually by the gate authority; decision points 2 (thematic-completion trigger), 3 (deterministic semver table), and 6 (breaking-change pre-release notice) of [ADR-2026-04-11](docs/decisions/ADR-2026-04-11-release-trigger-policy.md) remain in force.

---

## Writing Standards

All prose written in this repo must comply with these rules:

1. **No Unicode em dashes (U+2014) or en dashes (U+2013).** Use semicolons, colons, parentheses, or restructured sentences instead. CI Check 1 enforces this.
2. **No ASCII double-hyphen sentence dashes** (space-hyphen-hyphen-space pattern). Same replacements as above.
3. **No smart quotes or other AI-generated typographic characters.** Use straight quotes only: `"` and `'`.
4. **Plain hyphens only** for compound words and CLI flags.

---

## Commit Discipline

- **Message format:** `type: description` where type is `feat`, `fix`, `docs`, `refactor`, or `chore`. Body explains WHY.
- **No Co-Authored-By trailers.** No AI attribution lines. No "Generated with" lines.
- **CHANGELOG entry required** for any normative or prescriptive change. Entry goes under `## [Unreleased]` with a `### Added`, `### Changed`, or `### Fixed` subsection.
- **One logical change per commit.** Do not bundle unrelated changes.
- **Pre-commit hooks will run automatically.** Do not skip them. If they fail, fix the issue and commit again (new commit, not amend).

---

## Document Standards

When creating or modifying any document in this repo, apply ESE §4:

1. **Table of Contents** (§4.4): Required for documents with more than 3 sections. ToC entries must link to actual headings.
2. **ADR format** (§4.2): Required frontmatter: `type`, `id`, `title`, `status`, `date`. Required sections: Context, Decision, Consequences, Alternatives (with rejection rationale), Validation (binary criteria + event trigger).
3. **Work session logs** (§4.6): Required sections: what was attempted, what succeeded, what failed, what was left open, decisions made.
4. **Document length** (§4.7): Evaluate sections exceeding ~500 words for extraction. Evaluate documents exceeding ~2000 words for cascade.
5. **Frontmatter**: All ADRs and FMEAs require YAML frontmatter.

---

## Content Boundaries

ESE is a universal standard. Content must be domain-agnostic and implementation-free.

1. **No adopter-specific references in normative or prescriptive docs.** Do not reference specific repos, projects, or implementations (e.g., specific project codenames, framework names, or personal tooling) in STANDARDS.md, addenda, templates, starters, ADRs, architecture docs, or product docs. Use generic terms: "tracked work item system", "implementing system", "adopting project".
2. **No person names in normative docs.** Person names belong only in `docs/standards-application.md` (named owner per §2.4) and git history.
3. **No tool-specific prescriptions.** State what must be true, not which tool to use. Reference tools as examples only (e.g., "The specific convention (e.g., Conventional Commits) is a project decision").
4. **Work session logs are historical.** They may contain adopter-specific references as historical context. Do not retroactively sanitize them.
5. **vault-* IDs** (tracked-system work item IDs) belong only in CHANGELOG.md, work session logs, and commit messages. They must not appear in STANDARDS.md, addenda, templates, or starters.

---

## Numeric Thresholds

When introducing or modifying any numeric threshold in STANDARDS.md:

1. **State the generating principle first.** The principle is the requirement; the number is a calibration point.
2. **Provide the number as a default calibration** that projects may adjust with documented rationale.
3. **Note the derivation source** (e.g., "from statistical process control theory", "from Miller, 1956").

---

## Agent Guidance (from audit)

These entries address requirements that agents consistently miss. Each maps to specific REQ-IDs identified in the genuine compliance audit.

### FMEA triggers
When adding a new feature that handles user data, authentication, or financial transactions, create both a DFMEA and PFMEA using templates/fmea.md. (REQ-2.1-37 through -43)

### Work item close checklist
Before closing a work item: (1) verify MONITOR answer is written, (2) verify CLOSE answer is written, (3) export work item record to docs/work-items/ if the project uses a private tracked system. (REQ-2.1-09, -10, -16, -34, REQ-2.2-07)

### Post-mortem triggers
After resolving any P0/P1 bug or any bug that affected users, create a post-mortem using templates/post-mortem.md. After each post-mortem, add an entry to docs/incidents/lessons-learned.md. (REQ-8.2-01, -03, REQ-8.3-02)

### Anti-pattern registry
After 2+ incidents of the same class (same type of bug, same process failure), add an entry to docs/incidents/anti-patterns.md. (REQ-8.4-01, -02)

### Metric verification
Before citing a metric in any document, verify: definition is confirmed, signal vs noise distinguished, source is authoritative, calibration is current. (REQ-7.7-01 through -05)

### Session logs
At end of significant work sessions (>1 hour or multiple commits), create a log entry using templates/work-session-log.md. (REQ-4.6-01, -04)

### Technology adoption
Before adopting a new language, framework, or major dependency, create a tech eval using templates/tech-eval.md. (REQ-9.1-01, -02)

### ADR validation
Every ADR validation section must have at least one yes/no criterion and a calendar or event trigger for when to check it. (REQ-4.2-07)

### Testing gaps
Maintain a testing gaps table in docs/standards-application.md per REQ-6.2-01.

### Breaking changes
Before merging changes that affect the REQ-ID schema, enforcement-spec.yml format, or any interface consumed by adopters, list affected downstream repos or consumers. (REQ-5.3-01, -02, REQ-5.8)

### New artifacts from templates
When creating a new instance of any ESE template (ADR, FMEA, investigation, PRD, capabilities, problem research, compliance review, work item export), use `bash scripts/new-artifact.sh TYPE "Title"` rather than hand-copying the template. The tool reads `scripts/template-instance-mappings.txt`, creates the file at the correct path, pre-fills placeholders (date, title, id-slug, owner from git config, type), and leaves remaining `{...}` placeholders for manual editing. Run `bash scripts/new-artifact.sh --list` to see all available types. This addresses the copy-paste friction that was the root cause of template drift in adopter projects. (Phase D of the template-compliance framework; REQ-4.1-02 gates the resulting artifact.)

### Standards-application frontmatter edits
`docs/standards-application.md` carries a machine-readable YAML frontmatter block (`ese-version`, `owner`, `compliance-review`, `capabilities`, `addenda`, `template-compliance`, `fmea`). When changing any applicability claim (a capability Yes/No, an addendum Yes/No, an FMEA threshold, the verification mode, the owner, the compliance review dates, or the ESE version pin), update BOTH the YAML block AND the corresponding prose section: Component Capabilities Declaration table, Applicable Addenda table, FMEA Thresholds prose, §4.1 Verification Mode prose, Named Owner prose, or the footer lines. `scripts/lint-standards-application-frontmatter.sh` (CI Check 34) enforces YAML ↔ prose consistency and will fail the commit if they drift. Release ceremony commits must bump `ese-version` and `last-updated` in the YAML, not just the prose footer; the Tier 3 check compares `ese-version` against the latest CHANGELOG version heading.

---

## Before Every Commit

Run this checklist for EVERY commit. Do not skip items. Do not approximate. Each item is a grep or command with an expected result. If any item fails, fix it before committing.

### Content verification (run on every modified file)

```bash
# 1. Em dashes / en dashes / double-hyphen dashes
# Expected: PASS (zero violations)
python3 -c "..." # (the full em-dash scan from CI Check 1)

# 2. Smart quotes
# Expected: zero output
grep -rP '[\x{201C}\x{201D}\x{2018}\x{2019}]' --include="*.md" . | grep -v ".git"

# 3. Tool-specific terms in ALL non-session-log files
# Expected: zero output (except standards-application.md §2.7 system name)
# Customize this grep with your project-specific codenames that must not appear in normative docs.
# Example: grep -rni 'project_codename\|tooling_codename' --include="*.md" . | grep -v ".git" | grep -v "work-sessions"

# 4. Absolute paths in all non-session-log files
# Expected: zero output
grep -rn '~/repos/\|/Users/' --include="*.md" . | grep -v ".git" | grep -v "work-sessions" | grep -v CHANGELOG

# 5. vault-IDs in normative docs
# Expected: zero output
grep -rn 'vault-' STANDARDS.md docs/addenda/*.md templates/*.md starters/*.md 2>/dev/null

# 6. Person names in normative docs
# Expected: zero output
grep -rni 'nick baker' STANDARDS.md docs/addenda/*.md templates/*.md starters/*.md 2>/dev/null
```

### Structural verification

7. **CHANGELOG entry exists** for this change. Every commit touching STANDARDS.md, addenda, ADRs, templates, starters, scripts, or root-level docs requires a CHANGELOG entry under `## [Unreleased]`.
8. **If a new external reference was added to STANDARDS.md** (a named person, framework, or theory with a date), verify it appears in `dependencies.md`.
9. **If repo structure changed** (files added, moved, deleted, or directories created/removed), verify `README.md` Structure section matches actual layout.
10. **If standards-application.md claims were affected**, update the claim and the "Last updated" date.
11. **If a document was created or modified**, verify it has a Table of Contents if it has more than 3 `##` sections.
12. **If a ToC exists**, verify every entry links to a heading that actually exists in the document.
13. **If YAML frontmatter exists**, verify it parses correctly (no inline values on the same line as list markers).

### CI verification

```bash
# 14. Regenerate manifests if STANDARDS.md or addenda changed
bash scripts/generate-req-manifest.sh generate
bash scripts/generate-enforcement-spec.sh generate
bash scripts/generate-req-index.sh generate

# 15. Run full CI suite
bash scripts/validate-req-ids.sh
bash scripts/lint-req-tags.sh
bash scripts/lint-section-anchors.sh
bash scripts/generate-enforcement-spec.sh verify
bash scripts/generate-req-manifest.sh verify
bash scripts/generate-req-index.sh verify
bash scripts/lint-stale-counts.sh
bash scripts/lint-obligations.sh
bash scripts/lint-self-compliance.sh
bash scripts/lint-broken-tables.sh
bash scripts/lint-table-format.sh
bash scripts/lint-fmea-consistency.sh
bash scripts/lint-fmea-controls.sh
bash scripts/lint-adr-lifecycle-refs.sh
bash scripts/lint-work-item-export.sh
bash scripts/lint-readme-structure.sh
bash scripts/lint-toc-links.sh
bash scripts/lint-adr-triggers.sh
bash scripts/lint-adr-validation.sh
bash scripts/lint-changelog-entries.sh
bash scripts/lint-fmea-completeness.sh
bash scripts/lint-session-artifacts.sh
bash scripts/lint-orphan-scripts.sh
bash scripts/lint-count-congruence.sh
bash scripts/lint-changelog-tags.sh
bash scripts/lint-orphan-adrs.sh
bash scripts/lint-template-compliance.sh
bash scripts/lint-fmea-congruence.sh
bash scripts/lint-standards-application-frontmatter.sh
bash scripts/lint-doc-references.sh
bash scripts/lint-release-existence.sh
bash scripts/lint-vsm-baseline-reference.sh
bash scripts/lint-agent-config.sh
```

**Fastest path:** instead of running every script above individually, use `bash scripts/preflight.sh`. That single command runs the full linter suite, the three manifest verifies, the typographic scan, and the content-boundary scans, and prints one pass/fail summary. It is the recommended entry point before any commit; the per-script list above remains for debugging an individual failure.

### Commit message verification

16. **No Co-Authored-By trailers.** No AI attribution. No "Generated with" lines.
17. **Format:** `type: description`. Body explains why.
18. **Do not push** unless Nick explicitly asks.
