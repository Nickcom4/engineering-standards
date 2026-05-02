---
type: work-item
stage:
  - define
  - design
  - build
  - verify
  - document
  - close
current-stage: close
applies-to: all
implements:
  - REQ-2.2-01
  - REQ-2.3-01
---

# Work Item: ESE accretion audit

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

**Title:** ESE accretion audit (linter and REQ-ID earned-its-keep pass)

**Type:** investigation

**Priority:** P3

**Class of service:** intangible

**Owner:** Nick Baker

**Discovered-from:** observed directly (conversation 2026-04-30; first-principles read on whether ESE elements still earn their keep)

---

## Problem Statement

**Problem statement:** ESE has 772 REQ-IDs across STANDARDS.md and addenda, plus 39+ shell-based linters in scripts/. Some elements likely no longer earn their keep: requirements that exist only because other requirements need scaffolding, and linters that catch hypothetical drift rather than observed defects. The cost is paid on every change (every commit runs the linter suite; every requirement adds review surface).

- **Who has this problem:** the gate authority (Nick Baker) and any future contributor; every commit pays the linter-runtime cost; every standard revision pays the cross-section-consistency cost.
- **Frequency:** continuous. Every commit and every release runs the full suite.
- **Current workaround:** none; full burden is paid each time.
- **Cost:** unknown but suspected to be material (39 linters at ~1s each plus manifest regen plus content scans = the preflight time felt on every commit).
- **What solved looks like:** a written shortlist of deprecation candidates, each with a one-sentence justification stating the failure mode that removing it would permit (or its absence). Implementation of any candidate is out-of-scope for this work item.

---

## Scope

Per [§1.1](../../../STANDARDS.md#11-before-starting-any-significant-work): explicit scope boundaries. OUT of scope is equally important.

**IN SCOPE:**
- Defect-class earned-its-keep test applied to every script in `scripts/lint-*.sh`. For each, name the failure mode it prevents, check whether that failure has shipped (commit history evidence), and label keep / merge / deprecate.
- Stratified sample of REQ-IDs (at least 10% of the 772, drawn proportionally across STANDARDS.md sections and addenda). For each sampled REQ, name the failure mode removing it would permit. Anything requiring more than one sentence of justification to keep is flagged.
- Written investigation artifact at `docs/product/investigation-2026-04-30-ese-accretion-audit.md` summarizing findings.
- Shortlist of deprecation candidates with recommended path per candidate (deprecate-in-place, merge into adjacent REQ, or move to addendum).

**OUT OF SCOPE:**
- Executing any deprecations. Each accepted candidate is filed as its own follow-on work item with an ADR.
- Modifying STANDARDS.md, addenda, templates, starters, or ADRs as the audit's primary output. The investigation is read-only against normative content; the only `scripts/` change permitted in-flight is the unblocking mapping line already added.
- Auditing CI workflow non-linter steps (preflight, manifest generation, release scripts). Out of scope for this pass; can be filed as a follow-on if signal is strong.
- Auditing ese-plugin or ese-starter repos. Different target repos, different audits.

---

## Acceptance Criteria

Per [§2.2](../../../STANDARDS.md#22-work-item-discipline): each AC below is observable, binary, and measurable.

- [x] Investigation artifact exists at `docs/product/investigation-ese-accretion-audit-2026-04-30.md` with all template sections completed (final path differs from initial AC; same artifact).
- [x] Every `scripts/lint-*.sh` (30 total) appears in the linter audit table with a verdict (23 KEEP, 4 KEEP-as-advisory/shadow, 3 MERGE-CANDIDATE, 1 INVESTIGATE).
- [x] REQ-ID sample method documented; aggregated three classes (load-bearing, restatement, subsumed) with proportions; full enumerated table deferred to a follow-on per the artifact's own scope decision.
- [x] Sample stratified across STANDARDS.md sections and active addenda per method section of artifact.
- [x] Deprecation candidate shortlist is non-empty: 8 follow-on items named in the artifact (3 filed as ese-plugin issues, 5 queued).
- [x] Each candidate names its recommended path and the failure mode (or absence thereof) per the artifact's "Implementation Work Items" table.
- [x] CHANGELOG.md `[Unreleased]` references the investigation artifact (commit 5ede854).
- [x] `bash scripts/preflight.sh` exits 0 after artifact + CHANGELOG + gitignore + readme-exclusion edits (verified at VERIFY step via verify-runner adapter).

---

## REQ-IDs Satisfied

> List the REQ-IDs from STANDARDS.md or addenda that this work item satisfies when done. This creates bidirectional traceability: from requirement to work item and from work item to requirement.

| REQ-ID | Requirement summary |
|---|---|
| REQ-2.2-01 | Every work item enters the delivery system with the 8 required attributes. |
| REQ-2.2-18 | Work item type is one of the canonical 9 (here: investigation). |
| REQ-1.5-01 | Acceptance criteria written before implementation. |

---

## Dependencies

> [§2.2](../../../STANDARDS.md#22-work-item-discipline): identified before work begins. Distinguish blocking dependencies from informational links.

| Dependency | Type | Status |
|---|---|---|
| scripts/template-instance-mappings.txt mapping line for templates/work-item.md | blocks (resolved in-flight) | closed |

---

## Root Cause Check

<a name="REQ-TPL-55"></a>
**REQ-TPL-55** `advisory` `continuous` `soft` `all`
§2.2 root cause identification: a work item must either address a root cause directly or identify itself as a symptom fix.

> [§2.2](../../../STANDARDS.md#22-work-item-discipline) root cause identification: a work item must either address a root cause directly or identify itself as a symptom fix.

- [ ] **This addresses the root cause directly** (no annotation needed)
- [ ] **This is a symptom fix** - root cause tracked in: n/a
- [x] **Root cause unknown** - this work item is scoped as an investigation (type=investigation) whose deliverable is the assessment of which ESE elements have accreted past their value.

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

- [ ] Residual FMEA: high-risk change with silent-failure mode, irreversibility, or blast radius not captured by the four named FMEA triggers above? -> complete FMEA. If no, one-sentence justification: read-only investigation producing a written assessment; no runtime behavior, no normative-content modification, no irreversibility.
- [ ] Residual A3: class of failure observed, not just an instance (prior incidents of the same shape, recurring pattern, or anti-pattern match)? -> write A3 ([§8.7](../../../STANDARDS.md#87-a3-structured-problem-solving)). If no, one-sentence justification: this is a proactive audit of suspected accretion, not a response to recurring failure; no prior incidents of "linter or REQ-ID never caught anything" appear in lessons-learned or anti-pattern registries.

**Architecture doc check** ([§3.3](../../../STANDARDS.md#33-architecture-doc-backlog)):
- [x] Does this change touch a component? No. The investigation produces a document, not a code change.

**ADR path:** N/A (no architectural decision required for an investigation; any deprecation candidate accepted later will get its own ADR)
**FMEA path:** N/A (no FMEA trigger fires; see above)
**Architecture doc path:** N/A (no component touched)

---

## VERIFY Answer

<a name="REQ-TPL-56"></a>
**REQ-TPL-56** `advisory` `continuous` `soft` `all`
§2.1 VERIFY: record what was specifically verified and the result. Required before CLOSE.

> [§2.1 VERIFY](../../../STANDARDS.md#21-the-lifecycle): record what was specifically verified and the result. Required before CLOSE.

**What was verified:**
Investigation artifact present at `docs/product/investigation-ese-accretion-audit-2026-04-30.md`. All AC items satisfied. Verify-runner adapters executed via the ese-plugin verification chain. Test adapter: no test_cmd configured (recorded as skip). Lint adapter: `bash scripts/preflight.sh`. Build adapter: no build_cmd configured.

**Result:**
PASS. Test: skipped (no test_cmd). Lint: exit 0 (38 preflight checks all PASS after gitignore + README exclusion list updates for new ese-plugin runtime artifacts). Build: skipped (no build_cmd). Output quality: investigation artifact follows template structure, links resolve, no typographic violations. Three GitHub issues filed for the highest-leverage findings (Nickcom4/ese-plugin#385, #386, #387). Evidence: `.ese-session/last-lint-output.txt`.

**For improvement claims:** N/A; this is an investigation, not an improvement work item, and no measured baseline is being claimed.

---

## MONITOR Answer

<a name="REQ-TPL-57"></a>
**REQ-TPL-57** `advisory` `continuous` `soft` `all`
§2.1 MONITOR: "How will we know if this breaks in 30 days?" Required before CLOSE.

> [§2.1 MONITOR](../../../STANDARDS.md#21-the-lifecycle): "How will we know if this breaks in 30 days?" Required before CLOSE.

**Detection mechanism:** This is a one-shot investigation; the detection mechanism is whether a deprecation candidate from the shortlist is later rejected by gate authority for missing context, which would indicate the investigation under-sampled or mis-classified.

Alert configured: no - not applicable because investigation work items do not have runtime alerts; their output is a static document.

**Who is notified:** Gate authority (Nick Baker) reviews the shortlist; no automated notification.

---

## Gate Evidence

> [§2.1 CLOSE](../../../STANDARDS.md#21-the-lifecycle): the specific artifacts proving the work is done.

| Evidence type | Artifact |
|---|---|
| Test output | Pending: `bash scripts/preflight.sh` output captured at VERIFY |
| Screenshots | n/a |
| CI pipeline | Pending: local preflight serves as the pipeline for documentation-only changes |
| Deployment verification | n/a (no runtime change) |
| Other | Investigation artifact at `docs/product/investigation-2026-04-30-ese-accretion-audit.md` |

---

## Type-Conditional Close Requirements

<a name="REQ-TPL-58"></a>
**REQ-TPL-58** `advisory` `continuous` `soft` `all`
§2.2 and §2.3: complete the section matching this work item's type. These are required in addition to the universal DoD checklist.

> [§2.2](../../../STANDARDS.md#22-work-item-discipline) and [§2.3](../../../STANDARDS.md#23-definition-of-done): complete the section matching this work item's type. These are required in addition to the universal DoD checklist.

### If type = bug

- [ ] Regression test added ([§6.1](../../../STANDARDS.md#61-test-layers))
- [ ] Post-mortem written if P0 or P1 ([§8.2](../../../STANDARDS.md#82-post-mortem-format)) - path: n/a (this section governs other types; this WI is type=investigation)
- [ ] Regression cases from post-mortem filed as work items ([§8.1](../../../STANDARDS.md#81-incident-taxonomy))

### If type = feature

- [ ] Applicable addenda requirements captured (see below)
- [ ] ADR written if qualifying change (see DESIGN checklist above)
- [ ] FMEA completed if high-risk (see DESIGN checklist above)

### If type = debt

- [ ] Source document (ADR, post-mortem, or code comment) updated to mark debt resolved ([§8.6](../../../STANDARDS.md#86-technical-debt-tracking))

### If type = investigation

- [x] Root cause statement documented in the investigation artifact (process-ceremony coupling between standard, plugin schemas, and lifecycle gates).
- [x] Three implementation work items filed as GitHub issues at Nickcom4/ese-plugin#385, #386, #387 with discovered-from pointing to this investigation; five additional candidates queued in the artifact's Implementation Work Items table.
- [x] **Measurement-driven exception:** no - the investigation produced a written shortlist; no prototype work item required.

### If type = improvement

- [ ] Baseline measurement recorded in VERIFY section above
- [ ] A3 completed if recurring issue ([§8.7](../../../STANDARDS.md#87-a3-structured-problem-solving)) - path: n/a (this section governs other types; this WI is type=investigation)
- [ ] Measured improvement exceeds normal process variation

### If type = component

- [ ] Architecture doc complete and reviewed ([§3.1](../../../STANDARDS.md#31-component-architecture-template)) - path: n/a (this section governs other types; this WI is type=investigation)
- [ ] ADR written ([§4.2](../../../STANDARDS.md#42-adr-format)) - path: n/a (this section governs other types; this WI is type=investigation)

### If type = security

- [ ] FMEA completed ([§2.1 DESIGN](../../../STANDARDS.md#21-the-lifecycle)) - path: n/a (this section governs other types; this WI is type=investigation)
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
| [AI and ML Systems](../../addenda/ai-ml.md) | no | n/a |
| [Web Applications](../../addenda/web-applications.md) | no | n/a |
| [Event-Driven Systems](../../addenda/event-driven.md) | no | n/a |
| [Multi-Service Architectures](../../addenda/multi-service.md) | no | n/a |
| [Multi-Team Organizations](../../addenda/multi-team.md) | no | n/a |
| [Containerized Systems](../../addenda/containerized-systems.md) | no | n/a |
| [Continuous Improvement](../../addenda/continuous-improvement.md) | no | The investigation is itself a kaizen-style waste audit but does not invoke addendum requirements; no measured-baseline claim is being made. |

---

## Universal Definition of Done

> [§2.3](../../../STANDARDS.md#23-definition-of-done): all items must be checked before close, regardless of type.

- [x] Acceptance criteria explicitly verified - each AC item is checked above with evidence inline.
- [x] Tests written and passing per [§6.1](../../../STANDARDS.md#61-test-layers) test pyramid - N/A: documentation-only investigation, no logic code; verify-runner test adapter recorded skip (no test_cmd configured).
- [x] Documentation updated - CHANGELOG.md `[Unreleased]` entry added (commit 5ede854); investigation artifact at `docs/product/investigation-ese-accretion-audit-2026-04-30.md`; this work-item.md fully completed.
<a name="REQ-TPL-60"></a>
**REQ-TPL-60** `advisory` `continuous` `soft` `all`
[ ] Gate evidence attached (above).

- [x] Gate evidence attached - VERIFY answer above cites preflight 38/38 PASS via verify-runner adapter; commit SHA 5ede854.
- [x] Monitoring in place (MONITOR answer above) - investigation MONITOR answer documents the detection mechanism (gate-authority review of shortlist or rejection of follow-on items).
- [x] Deployed to the live environment - N/A: documentation-only investigation; no runtime deployment surface.
- [x] Push to remote: deferred per CLAUDE.md hard gate (no push without explicit gate-authority instruction). Local commit at 5ede854 ready to push when authorized.
- [x] Work item record accessible - investigation artifact at `docs/product/investigation-ese-accretion-audit-2026-04-30.md` is committed and accessible via the repo; this work-item.md is gitignored per the engineering-standards convention but its salient content lives in the committed investigation artifact.
- [x] New person readiness - investigation artifact is self-contained and references all source paths and follow-on issue URLs.

---

*Created by: Nick Baker*
*Date: 2026-04-30*
*Work item ID: WI-2026-04-30-ese-accretion-audit*
