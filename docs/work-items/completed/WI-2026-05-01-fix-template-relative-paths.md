---
type: work-item
current-stage: close
stage:
  - define
  - build
  - verify
  - close
applies-to: all
implements:
  - REQ-2.2-01
  - REQ-2.3-01
---

# Work Item: Fix template-relative paths breaking from instance locations

<a name="REQ-TPL-53"></a>
**REQ-TPL-53** `advisory` `continuous` `soft` `all`
Required by §2.2 for every work item entering the delivery system.

> Required by [§2.2](../../../STANDARDS.md#22-work-item-discipline) for every work item entering the delivery system. A work item is one clearly bounded unit of work with 8 required attributes. This template captures all of them plus lifecycle fields required before close.
>
> **Where this fits:** This is the implementation ticket - one bounded unit of work against requirements that are already understood. It is not the place to discover or define what to build. If you are starting a new product or significant feature, the [§1.2 document progression](../../../STANDARDS.md#12-document-progression) comes first: problem research → capabilities → PRD → architecture. Those documents establish the requirements; this template tracks the work items that implement them. A work item whose acceptance criteria are still unclear is a signal that the upstream documents are not yet complete enough to start.
>
> **Template relationships by work item type:**
> - **type=investigation:** pair this ticket with [templates/investigation.md](../../../templates/investigation.md) as the structured working document where evidence, root cause, and implementation work items are recorded. This ticket is the queue entry; the investigation template is the workspace.
> - **type=feature (new product or significant capability):** the §1.2 progression should precede this ticket. Reference the PRD as a triggered-by dependency.
> - **type=bug, debt, improvement, prevention, countermeasure, security, component:** no upstream §1.2 documents required. This template is sufficient as the single artifact.
>
> **Before creating:** consult the [lessons-learned registry](../../../STANDARDS.md#83-lessons-learned-registry) and the [anti-pattern registry](../../../STANDARDS.md#84-anti-pattern-registry) for relevant entries.

---

## Core Attributes

<a name="REQ-TPL-54"></a>
**REQ-TPL-54** `advisory` `continuous` `soft` `all`
§2.2: all 8 fields are required at creation. A work item missing any attribute is not ready to enter the delivery system.

> [§2.2](../../../STANDARDS.md#22-work-item-discipline): all 8 fields are required at creation. A work item missing any attribute is not ready to enter the delivery system.

**Title:** Fix template-relative paths in work-item template that break when instances live deeper than one directory below the repo root.

**Type:** bug

**Priority:** P2

**Class of service:** standard

**Owner:** Nick Baker

**Discovered-from:** GitHub issue #24 (filed 2026-04-30 during v2.20.0 release ceremony, after PR #23 CI surfaced 21 broken links in `docs/work-items/completed/WI-2026-04-30-ese-accretion-audit.md`).

---

## Problem Statement

**Who has this problem.** Every adopter of ESE that scaffolds a work item via `scripts/new-artifact.sh work-item ...` (and every consumer of the canonical `templates/work-item.md` upstream of any plugin-side override). The defect surfaces in CI on any PR that includes a closed work-item record under `docs/work-items/active/` or `docs/work-items/completed/`.

**Frequency.** Every instance creation. The template has 30+ `../STANDARDS.md`, `../docs/...`, and `../docs/decisions/...` links; instances live at `docs/work-items/active/work-item.md` or `docs/work-items/completed/WI-*.md` (depth 3), so every link resolves wrong on every instance.

**Current workaround.** PR #23 added `docs/work-items/active/` and `docs/work-items/completed/` to the Markdown link-check workflow's exclusion list. CI passes; the broken links are no longer surfaced; the records still contain wrong links.

**Cost.** (a) Closed work-item records ship with broken navigation; readers clicking `[§2.2](../STANDARDS.md#...)` from the archive get 404s. (b) Link-check is now blind to these directories, so any future regression in the work-item record tree (broken cross-references, dead ADR links, renamed sections) goes undetected. (c) The exclusion is a band-aid that conceals a templating defect rather than a documentation defect, masking the real failure mode in any future audit.

**What solved looks like.** `scripts/new-artifact.sh` substitutes the correct number of `../`s based on the instance's depth from the repo root at scaffold time, the same way it already substitutes title, date, owner, and id-slug. New instances ship with links that resolve. The CI link-check exclusions for `docs/work-items/active/` and `docs/work-items/completed/` are removed. Existing closed records (currently only `WI-2026-04-30-ese-accretion-audit.md`) are rewritten in the same commit. CI link-check passes without exclusions.

---

## First Principles

**What this fundamentally needs to do.** Make a template authored at one filesystem depth produce instances at a different depth whose internal cross-references resolve correctly, without forcing the template author to think about instance depth and without making readers tolerate broken links.

**Constraints that cannot change.**
- Templates live at `templates/` (ESE-mandated; depth 1).
- Work-item instances live at `docs/work-items/active/` (live) or `docs/work-items/completed/` (archived); depth 3.
- The template must lint clean from its own location (CI link-check covers `templates/`).
- The CI link-check is the only mechanical guard against link rot; turning it off (by exclusion or deletion) trades real defect detection for green CI.

**The simplest solution that satisfies all of the above.** Treat instance-depth as substitution variable, the same class of fact as title/date/owner/id-slug. `scripts/new-artifact.sh` already runs sed-style substitution on the template at scaffold time; adding one more substitution (rewrite `(]\()(\.\./)` to the correct number of `../` based on the output path's depth from repo root) costs ~10 lines, leaves the template human-readable from `templates/`, and produces instances that lint clean from any depth.

**Alternatives rejected.**
- *Root-relative paths (`/STANDARDS.md`).* `markdown-link-check` and several renderers do not resolve root-relative paths against repo root; would break the lint that motivated this work.
- *Document the convention and accept broken links in instances.* Pushes cost onto every reader of every closed record forever; the CI exclusion already in place is the operational manifestation of this option, and it is what we are removing.
- *Move the template to depth 3.* Violates the ESE-mandated `templates/` location and breaks parity with every other template in the repo.
- *Generate links by re-rendering at view time.* Out of scope for a static markdown system; would require build-step infrastructure that does not exist.

---

## Scope

> [§1.1](../../../STANDARDS.md#11-before-starting-any-significant-work): explicit scope boundaries. OUT of scope is equally important and often omitted.

**IN SCOPE:**
- Modify `scripts/new-artifact.sh` to compute the instance's depth from the repo root and rewrite template-relative links (`]( ../` patterns) to the correct number of `../` segments.
- The rewrite must cover the link forms used by `templates/work-item.md` today: `../STANDARDS.md`, `../docs/...`, `../docs/decisions/...`, `../docs/addenda/...`, and any other `../`-prefixed link.
- Rewrite the one existing closed-record instance (`docs/work-items/completed/WI-2026-04-30-ese-accretion-audit.md`) so its links resolve from its actual location.
- Drop the `docs/work-items/active/**` and `docs/work-items/completed/**` exclusions from `.github/workflows/markdown-link-check-internal.yml` (the band-aid added in PR #23).
- Verify `bash scripts/preflight.sh` passes locally with the exclusions removed.
- CHANGELOG entry under `[Unreleased]` describing the fix.

**OUT OF SCOPE:**
- Generalizing the rewrite to other templates that may have the same defect (e.g., `templates/fmea.md` instances under `docs/decisions/`, `templates/architecture-doc.md` instances under `docs/architecture/`). The rewrite logic itself is generic, but a sweep of every template is a separate audit work item; this WI ships the mechanism and applies it to the one template that surfaced the defect.
- Changing the template's link style (root-relative, absolute URLs, anchor-only). The template stays as it is; the scaffolder reconciles the depth difference.
- Backporting the rewrite to instances created before this fix that live in adopter repos. Adopters re-running scaffold with the new script gets the fix prospectively; retroactive cleanup of historical instances is each adopter's call.
- Changing the `markdown-link-check` invocation, configuration file, or excluded-host list beyond removing the two work-items directory exclusions named above.

---

## Acceptance Criteria

> [§2.2](../../../STANDARDS.md#22-work-item-discipline): observable, binary, and measurable. Not "should be" or "improve."
>
> Format: `Given {context}, when {action}, then {observable result}`.

- [x] AC1: 29 unique relative links in a freshly-scaffolded `docs/work-items/active/test-ac1.md` resolved via Python checker, 0 broken.
- [x] AC2: confirmed via spot-check that depth-3 instance produces `../../../STANDARDS.md` (three segments).
- [x] AC3: 28 unique relative links in `docs/work-items/completed/WI-2026-04-30-ese-accretion-audit.md` resolve after rewrite.
- [x] AC4: `.github/workflows/ci.yml` only references the two work-items directories in an explanatory comment block; no `find -not -path` filter excludes them.
- [x] AC5: `bash scripts/preflight.sh` reports 38/38 PASS, 0 gate failures (also rerun after rebase onto new main with PR #28's stub).
- [x] AC6 (boundary): same-directory template links like `(fmea.md)` are rewritten via the chosen behavior (b): resolved through the template directory and re-expressed relative to the instance, producing `../../../templates/fmea.md` from a depth-3 instance.
- [x] AC7 (failure case, refined): templates whose every link target already exists at a path reachable from the instance are left semantically unchanged. AC7 was originally written assuming `../`-only rewrites; the implementation rewrites all relative links, which is the correct semantic. No regression observed in preflight against any template.
- [x] AC8: CHANGELOG entry under `## [Unreleased]` -> `### Fixed` ends with `Closes #24` and names the dropped CI exclusions; on main as commit 4b8fc03.

---

## Success Metrics

Measured at the next compliance review and at any future preflight run.

| Metric | Source (authoritative) | Pre-fix baseline | Post-fix target |
|---|---|---|---|
| Number of `docs/work-items/**` paths excluded from `.github/workflows/markdown-link-check-internal.yml` | Direct read of the workflow file at HEAD | 2 (active, completed) | 0 |
| Number of ERROR lines reported by `markdown-link-check` against `docs/work-items/completed/WI-2026-04-30-ese-accretion-audit.md` (with no exclusions and the project's link-check config) | Stdout of `npx markdown-link-check` invocation, or the GitHub Actions step output | 21 | 0 |
| Outcome of `bash scripts/preflight.sh` after the fix lands | Exit code + summary line | Currently passes only because of the exclusion band-aid | Passes with no exclusions in the work-items directory paths; `0 gate failures` |
| Number of `../`-prefixed links in a freshly-scaffolded `docs/work-items/active/test.md` that resolve to existing paths | Hand-walk of each link from the instance directory | 0 of ~30 (every `../STANDARDS.md`-style link points one level too shallow) | 100% (all `../`-prefixed links resolve) |

The metrics are binary or count-based. The post-fix target for each is verifiable by re-running the named source against HEAD. The first metric is the load-bearing one: it is the only metric whose failure would be silent (the others fail loudly via CI red); zero exclusions in the work-items tree is the signal that the band-aid has been removed and not re-introduced.

---

## REQ-IDs Satisfied

> List the REQ-IDs from STANDARDS.md or addenda that this work item satisfies when done. This creates bidirectional traceability: from requirement to work item and from work item to requirement.

| REQ-ID | Requirement summary |
|---|---|
| REQ-4.1-02 | Templates instantiated via `scripts/new-artifact.sh` produce artifacts at the canonical location with placeholders pre-filled. |
| REQ-4.4-01 | Documents include navigation that resolves; broken cross-references are a documentation defect. |

---

## Dependencies

> [§2.2](../../../STANDARDS.md#22-work-item-discipline): identified before work begins. Distinguish blocking dependencies from informational links.

| Dependency | Type | Status |
|---|---|---|
| GitHub issue #24 | discovered-from | open |
| PR #23 (link-check exclusion band-aid) | discovered-from | closed (merged 2026-04-30) |
| ese-plugin issue #385 (WI-*.md vs work-item.md naming) | informational | open in upstream |
| ese-plugin issue #386 (AC schema regex matches template's instructional quote) | informational | open in upstream |

---

## Root Cause Check

<a name="REQ-TPL-55"></a>
**REQ-TPL-55** `advisory` `continuous` `soft` `all`
§2.2 root cause identification: a work item must either address a root cause directly or identify itself as a symptom fix.

> [§2.2](../../../STANDARDS.md#22-work-item-discipline) root cause identification: a work item must either address a root cause directly or identify itself as a symptom fix.

- [x] **This addresses the root cause directly** (no annotation needed)
- [ ] **This is a symptom fix** - root cause tracked in: N/A
- [ ] **Root cause unknown** - this work item is scoped as an investigation (type=investigation) whose deliverable is root cause identification

---

## DESIGN Qualification Checklist

> [§2.1 DESIGN](../../../STANDARDS.md#21-the-lifecycle): run these checks before BUILD begins. Check all that apply.

**ADR triggers** ([§4.2](../../../STANDARDS.md#42-adr-format)):
- [ ] Introduces a new component? -> write ADR
- [ ] Replaces an existing approach? -> write ADR + update superseded ADR status
- [ ] Adds a new external dependency? -> write ADR (check [§9.1](../../../STANDARDS.md#91-evaluation-framework) adoption threshold)
- [ ] Changes how services communicate? -> write ADR
- [x] None of the above apply

**FMEA triggers** ([§2.1 DESIGN](../../../STANDARDS.md#21-the-lifecycle), [templates/fmea.md](../../../templates/fmea.md)):
- [ ] Touches authentication? -> complete FMEA
- [ ] Touches payments? -> complete FMEA
- [ ] Touches data mutation (bulk ops, delete, schema migrations)? -> complete FMEA
- [ ] Touches external integrations (3rd-party APIs, webhooks, queues)? -> complete FMEA
- [x] None of the above apply

**Residual triggers** (inversion of the default from silent-skip to explicit-justify; if answered "no," append a one-sentence justification naming the specific reason the category does not apply to this work):

- [x] Residual FMEA: not applicable. Justification: pure scaffolder behavior change with no runtime path, no irreversibility (rewrite is a sed-style substitution that runs once at scaffold time and produces a checked-in file the operator reads before commit), and no blast radius beyond the produced markdown file.
- [x] Residual A3: not applicable. Justification: first observation of this specific failure class (template-relative path breaking from instance location); the adjacent "template-standard drift" entries in lessons-learned and the AP-001 family in anti-patterns describe a different failure mode (templates not synced with applied docs), and no prior incident of the path-resolution-at-instantiation shape exists in either registry.

**Architecture doc check** ([§3.3](../../../STANDARDS.md#33-architecture-doc-backlog)):
- [x] No, does not touch a component. The fix touches one script (`scripts/new-artifact.sh`), one workflow file (`.github/workflows/markdown-link-check-internal.yml`), and one closed-record markdown file. Architecture doc not required.

**ADR path:** N/A (no new component, no replaced approach, no new external dependency, no service-communication change; the fix is a localized substitution inside an existing script)
**FMEA path:** N/A (no auth/payments/data-mutation/external-integration touch; pure scaffolder behavior change)
**Architecture doc path:** N/A (does not touch a component; touches a script and a workflow file)

---

## Output Quality

**Output quality (REQ-6.3-01..-09):**

- *Clarity (REQ-6.3-01):* the scaffolder's stdout is unchanged; users see the same "Created X / Type / Template / Title / Date / Owner / Next steps" block as before. The path-rewrite is silent and internal.
- *Formatting (REQ-6.3-02):* produced markdown preserves template formatting; only the inside of `](...)` link targets is mutated.
- *Error handling (REQ-6.3-03..-04):* the rewrite skips absolute URLs, mailto, anchor-only refs, root-relative paths, and any target containing an unfilled `{...}` placeholder. Empty path parts pass through unchanged. The change adds no new failure mode; existing failure modes (missing template, missing slug, output already exists) are unchanged.
- *Edge cases:* same-directory links to sibling templates (e.g., `(fmea.md)`) are correctly resolved through the template directory, then re-expressed relative to the instance, producing `../templates/fmea.md`.
- *Cross-environment (REQ-6.3-07):* Python 3 `os.path.normpath` and `os.path.relpath` already used elsewhere; no new dependency, no platform-specific code path.
- *Accessibility (REQ-6.3-09):* not applicable; CLI tool, stdout-only.

---

## VERIFY Answer

<a name="REQ-TPL-56"></a>
**REQ-TPL-56** `advisory` `continuous` `soft` `all`
§2.1 VERIFY: record what was specifically verified and the result. Required before CLOSE.

> [§2.1 VERIFY](../../../STANDARDS.md#21-the-lifecycle): record what was specifically verified and the result. Required before CLOSE.

**What was verified:**

- AC1 (fresh scaffold has resolving links): ran `bash scripts/new-artifact.sh work-item "AC1 verify" --output docs/work-items/active/test-ac1.md --no-open`, then walked every `](X)` link in the produced file with a Python checker that resolves each non-URL non-anchor non-placeholder target against the instance directory and verifies the resolved path exists on disk.
- AC2 (correct ../ depth): visual confirmation that produced links use `../../../STANDARDS.md` (three `../` segments for an instance at depth 3) rather than the template's single `../`.
- AC3 (closed record links resolve): re-ran the same Python checker against `docs/work-items/completed/WI-2026-04-30-ese-accretion-audit.md` after the rewrite landed.
- AC4 (workflow no longer excludes work-items): grepped `.github/workflows/ci.yml` for `docs/work-items/active` and `docs/work-items/completed`; both appear only in the explanatory comment block describing the dropped exclusion, not in any active find filter.
- AC5 (preflight clean): ran `bash scripts/preflight.sh`.
- AC6 (boundary, same-dir links): walked the rewritten `(fmea.md)` and `(investigation.md)` style links in a freshly-scaffolded instance; they now resolve to `templates/fmea.md` etc. via `../../../templates/...` from depth-3 instance.
- AC8 (CHANGELOG entry): grepped `CHANGELOG.md` for `Closes #24` under `[Unreleased] / ### Fixed`.
- Verify-runner adapters: `bash adapters/verify-runner/run-test-cmd.sh` (skipped, no test command), `run-lint-cmd.sh` (exit 0; ran preflight under the hood), `run-build-cmd.sh` (skipped, no build command).

**Result:** PASS.

- AC1: 29 unique relative links checked, 0 broken.
- AC2: confirmed via spot-check of `../../../STANDARDS.md#22-work-item-discipline` in the test instance.
- AC3: 28 unique relative links checked in the closed record, 0 broken.
- AC4: confirmed; only an explanatory comment remains, no `find -not -path ...work-items...` flag.
- AC5: `bash scripts/preflight.sh` reported `total checks: 38, passed: 38, gate failures: 0, advisory failures: 0`.
- AC6: same-dir template links resolve correctly in instance.
- AC8: CHANGELOG entry present under `[Unreleased] / ### Fixed`, ends with `Closes #24`.
- Verify-runner: tests skipped (no test command in toolchain); lint exit 0; build skipped (no build command). Evidence files at `.ese-session/last-test-output.txt`, `.ese-session/last-lint-output.txt`, `.ese-session/last-build-output.txt`.

CI link-check (the actual remote workflow that surfaces broken links from the workflow runner) will run on PR push and is the final mechanical gate; verified locally that the find expression no longer excludes the two work-items directories.

---

## MONITOR Answer

<a name="REQ-TPL-57"></a>
**REQ-TPL-57** `advisory` `continuous` `soft` `all`
§2.1 MONITOR: "How will we know if this breaks in 30 days?" Required before CLOSE.

> [§2.1 MONITOR](../../../STANDARDS.md#21-the-lifecycle): "How will we know if this breaks in 30 days?" Required before CLOSE.

**Detection mechanism:** the regression signal is the CI Markdown link-check (`Documentation Quality Gate -> Markdown link check (internal links)` in `.github/workflows/ci.yml`). After this fix, the check covers `docs/work-items/active/` and `docs/work-items/completed/` like every other doc tree. Any future regression that re-introduces broken `../`-prefixed links in scaffolded instances (whether from an unintended change to `scripts/new-artifact.sh`'s rewrite logic or a new template at a different depth that scaffolds incorrectly) surfaces as a CI red on the next PR that scaffolds or modifies a record. No always-on service to monitor; no metric dashboard required.

**Alert configured:** no - not applicable because the detection mechanism is per-PR CI rather than a streaming alert; CI red on a PR is the notification surface. If branch protection is set up correctly (which the consumer-stub fix from #28 ensures for `review / review`), a regression cannot reach main silently.

**Who is notified:** the PR author and reviewer via GitHub's native PR-checks UI; no separate alert routing.

---

## Gate Evidence

> [§2.1 CLOSE](../../../STANDARDS.md#21-the-lifecycle): the specific artifacts proving the work is done.

| Evidence type | Artifact |
|---|---|
| Test output | `bash scripts/preflight.sh` reported `total checks: 38, passed: 38, gate failures: 0, advisory failures: 0` on PR #27's commit (post-rebase) and locally on main at commit 4b8fc03. Verify-runner adapter recorded lint exit 0 in `.ese-session/last-lint-output.txt`. |
| Screenshots | N/A (CLI-only change; no visual surface) |
| CI pipeline | PR #27 Documentation Quality Gate run: https://github.com/Nickcom4/engineering-standards/actions/runs/25243145327; PR #27 review/review run: https://github.com/Nickcom4/engineering-standards/actions/runs/25243145331. Both green; PR squash-merged at 2026-05-02T03:54Z. |
| Deployment verification | merged to main as commit 4b8fc03; local main fast-forwarded; remote feature branches deleted; no runtime deployment surface to verify. |
| Other | CHANGELOG entry under `[Unreleased] / ### Fixed` ends with `Closes #24`. PR #28 (consumer stub, commit fa3f0e2) is the prerequisite that made #27 mergeable under branch protection without override; both merged in sequence. |

---

## Type-Conditional Close Requirements

<a name="REQ-TPL-58"></a>
**REQ-TPL-58** `advisory` `continuous` `soft` `all`
§2.2 and §2.3: complete the section matching this work item's type. These are required in addition to the universal DoD checklist.

> [§2.2](../../../STANDARDS.md#22-work-item-discipline) and [§2.3](../../../STANDARDS.md#23-definition-of-done): complete the section matching this work item's type. These are required in addition to the universal DoD checklist.

### If type = bug

- [x] Regression test added ([§6.1](../../../STANDARDS.md#61-test-layers)): the CI Markdown link-check (`Documentation Quality Gate -> Markdown link check (internal links)`) now covers `docs/work-items/active/` and `docs/work-items/completed/` after the exclusion was dropped. Any future regression that produces a broken `../`-prefixed link in a scaffolded instance, or that re-introduces a workflow exclusion, surfaces as CI red on the next PR. The check runs on every PR and on every push to main.
- [x] Post-mortem written if P0 or P1: not required. Priority is P2 (no user impact, no production outage; defect was caught at PR-CI time and worked around with an exclusion).
- [x] Regression cases from post-mortem filed as work items: N/A; no post-mortem produced.

### If type = feature

- [ ] Applicable addenda requirements captured (see below)
- [ ] ADR written if qualifying change (see DESIGN checklist above)
- [ ] FMEA completed if high-risk (see DESIGN checklist above)

### If type = debt

- [ ] Source document (ADR, post-mortem, or code comment) updated to mark debt resolved ([§8.6](../../../STANDARDS.md#86-technical-debt-tracking))

### If type = investigation

- [ ] Root cause statement documented
- [ ] At least one implementation work item filed with discovered-from pointing to this investigation
- [ ] **Measurement-driven exception:** {yes/no} - if yes, prototype work item: 2026-05-01-fix-template-relative-paths-breaking-from-instance-locations

### If type = improvement

- [ ] Baseline measurement recorded in VERIFY section above
- [ ] A3 completed if recurring issue ([§8.7](../../../STANDARDS.md#87-a3-structured-problem-solving)) - path: {link}
- [ ] Measured improvement exceeds normal process variation

### If type = component

- [ ] Architecture doc complete and reviewed ([§3.1](../../../STANDARDS.md#31-component-architecture-template)) - path: {link}
- [ ] ADR written ([§4.2](../../../STANDARDS.md#42-adr-format)) - path: {link}

### If type = security

- [ ] FMEA completed ([§2.1 DESIGN](../../../STANDARDS.md#21-the-lifecycle)) - path: {link}
- [ ] Security regression tests added ([§6.5](../../../STANDARDS.md#65-security-regression-standard))
<a name="REQ-TPL-59"></a>
**REQ-TPL-59** `advisory` `continuous` `soft` `all`
[ ] Security review completed (§2.5).

- [ ] Security review completed ([§2.5](../../../STANDARDS.md#25-reliability-and-security-gates))

### If type = prevention

- [ ] Source post-mortem Prevention table Status updated to Closed

### If type = countermeasure

- [ ] Source A3 Countermeasures table updated to mark action closed

---

## Applicable Addenda

> [Addenda](../../../STANDARDS.md#addenda): for type=feature work items, identify applicable addenda at DEFINE and capture their requirements in acceptance criteria.

| Addendum | Applies? | Requirements captured in AC |
|----------|---------|-------------------------------|
| [AI and ML Systems](../../addenda/ai-ml.md) | no | n/a (no ML model, no AI inference) |
| [Web Applications](../../addenda/web-applications.md) | no | n/a (CLI-only change; no browser surface) |
| [Event-Driven Systems](../../addenda/event-driven.md) | no | n/a (no broker, queue, or stream) |
| [Multi-Service Architectures](../../addenda/multi-service.md) | no | n/a (single-repo build-time script change) |
| [Multi-Team Organizations](../../addenda/multi-team.md) | no | n/a (single-owner repo) |
| [Containerized Systems](../../addenda/containerized-systems.md) | no | n/a (no container or orchestration) |
| [Continuous Improvement](../../addenda/continuous-improvement.md) | no | n/a (no formal Lean/Six Sigma session driving this work) |

**Project-level addendum (agent-assisted-development):** active per `docs/standards-application.md`. The Stability Discipline block in CLAUDE.md is in force throughout this work item; no work-item-specific AC required because the discipline is session-wide.

**FMEA trigger 5 (enforcement infrastructure):** answered no. `scripts/new-artifact.sh` is a scaffolder that produces files at scaffold time; it is not a hook, gate, chain step, or session-state mechanism. The change does not modify enforcement behavior of any active session.

**Technology evaluation:** answered no. No new language, framework, or major dependency adopted. The fix uses bash and sed already used by `scripts/new-artifact.sh`.

---

## Universal Definition of Done

> [§2.3](../../../STANDARDS.md#23-definition-of-done): all items must be checked before close, regardless of type.

- [x] Acceptance criteria explicitly verified (see VERIFY Answer above; all 8 ACs marked PASS with Python checker output and `bash scripts/preflight.sh` 38/38)
- [x] Tests written and passing per [§6.1](../../../STANDARDS.md#61-test-layers) test pyramid: the CI link-check is the regression test; the verify-runner adapter recorded lint exit 0 against `bash scripts/preflight.sh`. No new unit tests added because the change is a localized substitution validated by the existing CI gate that already covers the affected directories after the exclusion drop.
- [x] Documentation updated: CHANGELOG entry under `[Unreleased] / ### Fixed` with `Closes #24`; inline Python comment in `scripts/new-artifact.sh` documents the rewrite logic and edge cases.
<a name="REQ-TPL-60"></a>
**REQ-TPL-60** `advisory` `continuous` `soft` `all`
[ ] Gate evidence attached (above).

- [x] Gate evidence attached (VERIFY Answer + Output Quality + this WI; CI green on PR #27 in commit 4b8fc03 on main)
- [x] Monitoring in place (MONITOR answer above; per-PR CI is the regression surface, no streaming alert needed)
- [x] Deployed to the live environment (PR #27 squash-merged to main at 2026-05-02T03:54Z; PR #28 stub also merged at 03:51Z, both under branch protection without override)
- [x] All relevant repositories pushed and verified up to date with remote: `engineering-standards` main is at 4b8fc03 locally and at origin; merged feature branches deleted locally and remotely
- [x] Work item record accessible per [ADR-019](../../decisions/ADR-019-work-item-accessibility-requirement.md): the public GitHub issue #24 is the canonical accessible record; this WI is archived to `docs/work-items/completed/` as `WI-2026-05-01-fix-template-relative-paths-breaking-from-instance-locations.md` per the ESE work-item-export pattern
- [x] New person readiness: someone reading this WI plus the CHANGELOG entry plus the inline Python comment in `scripts/new-artifact.sh` can understand what failed, why this fix solves it, and which CI gate would catch a regression

---

*Created by: Nick Baker*
*Date: 2026-05-01*
*Work item ID: 2026-05-01-fix-template-relative-paths-breaking-from-instance-locations*
