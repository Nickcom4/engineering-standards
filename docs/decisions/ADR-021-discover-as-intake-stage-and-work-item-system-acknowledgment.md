---
type: adr
id: ADR-021
title: "DISCOVER Depth Model, Process Decision Tree, Lifecycle-Stage Activation Map, Directory Layout, Naming Conventions, and §2.2-Compliant System Acknowledgment"
status: Accepted
date: 2026-03-24
deciders: "Gate authority (see standards-application.md)"
implements:
  - REQ-4.2-01
  - REQ-2.2-06
---

# ADR-021: DISCOVER Depth Model, Process Decision Tree, Lifecycle-Stage Activation Map, Directory Layout, Naming Conventions, and §2.2-Compliant System Acknowledgment

---

## Table of Contents

- [Context](#context)
- [Decision](#decision)
  - [D1: DISCOVER depth model](#d1-discover-depth-model)
  - [D2: §2.2-compliant tracked systems](#d2-22-compliant-tracked-systems)
  - [D3: Process decision tree in §2.1](#d3-process-decision-tree-in-21)
  - [D4: Per-stage operational blocks](#d4-per-stage-operational-blocks)
  - [D5: adoption.md target state](#d5-adoptionmd-target-state)
  - [D6: DMAIC vocabulary bridge](#d6-dmaic-vocabulary-bridge)
  - [D7: §2.7 and DISCOVER bidirectional reference](#d7-27-and-discover-bidirectional-reference)
  - [D8: Compliance review addenda verification](#d8-compliance-review-addenda-verification)
  - [D9: templates/ + starters/ split, layout, and naming conventions](#d9-templates--starters-split-layout-and-naming-conventions)
  - [Template guide specification](#template-guide-specification)
- [Scalability](#scalability)
- [Consequences](#consequences)
- [Alternatives Considered](#alternatives-considered)
- [Validation](#validation)
- [Per-Document Impact Analysis](#per-document-impact-analysis)
- [Follow-on Requirements](#follow-on-requirements)

---

## Context

A 17-pass deep audit of every file in the ESE repository identified 14 structural gaps that produce one outcome: high cognitive load for practitioners operating the lifecycle. A practitioner receiving a signal must cross-reference thousands of words across §1.2, §1.5, §2.1, §2.2, §2.3, and applicable addenda to determine the correct process path, artifacts, and per-stage requirements. This cross-referencing happens for every signal, on every project.

The gaps cluster into five structural problems.

**Problem 1: DISCOVER is overloaded.** §2.1 DISCOVER conflates signal capture, problem confirmation, root cause characterization, and product scoping in a single paragraph. It has no named artifact, no depth model, and no exit states other than proceeding to DEFINE. A discarded or parked signal has no home. A bug requiring root cause analysis before AC can be written has no named path within DISCOVER. The §1.2 document progression is presented as a separate phase disconnected from the lifecycle, when problem research is the characterization work DISCOVER does for features and products.

**Problem 2: No routing mechanism exists.** The standard defines work item types, classes of service, domain applicability, the document progression, and seven addenda, but provides no decision tree that routes a signal through these dimensions.

**Problem 3: Lifecycle stages lack operational specificity.** Each §2.1 stage describes what must happen but does not name the artifact produced, the entry condition, or which addenda requirements activate at that stage.

**Problem 4: Markdown templates are implicitly universal.** §2.2 references `work-item-template.md` without acknowledging that a tracked work item system capturing all eight §2.2 attributes, lifecycle status, and gate evidence satisfies the requirement without markdown files.

**Problem 5: Lifecycle artifacts have no defined storage location.** The lifecycle produces 23 artifact types. The current directory template covers approximately half. FMEAs, tech evaluations, A3s, compliance reviews, SLO definitions, intake records, and work item exports have no defined home. The `examples/` directory is also misnamed: its contents are templates, not examples.

### Theoretical basis

**DMAIC (Six Sigma).** The improvement cycle maps to the ESE lifecycle with two unnamed stages: Analyze (root cause identification, implicit in type=investigation) and Measure (baseline, implicit in improvement-type DEFINE). A DMAIC vocabulary bridge parallels the existing PDCA bridge in §2.1. DMAIC Analyze = DISCOVER depth D2. (Grounds D1 depth model, D6 vocabulary bridge.)

**ISO 9001 §4.4.** Each process requires defined inputs, outputs, and criteria. ESE stages have implicit inputs and outputs that are not stated per-stage. Naming them closes the ISO process documentation gap. ISO 9001 and ISO 27001 are referenced in STANDARDS.md and ADR-011 but are not tracked in dependencies.md; this ADR adds them. (Grounds D4 per-stage Input/Artifact format.)

**5S, SMED, Standard Work.** 5S: Sort (no empty directories), Set in Order (every artifact has one home), Standardize (naming conventions), Sustain (compliance reviews verify). SMED: new contributor understands layout in under a minute. Standard Work: directory layout is the documented method, subject to systematic improvement. (Grounds D9 directory layout and naming.)

**Cynefin (§1.5).** The domain classification step in the decision tree operationalizes §1.5: Complex-domain signals enter probe-sense-respond, not the prescriptive lifecycle. (Grounds D3 Step 1.)

### Continuous-improvement addendum alignment

This ADR applies the CI addendum's principles throughout: 5S for directory layout (D9), SMED for contributor onboarding (D9), Standard Work for documented process method (D4, D9), waste identification for the cross-referencing problem, constraint identification for the routing gap (D3), per-decision failure mode analysis as informal FMEA. Two practices are consciously omitted: a formal baseline measurement of routing cognitive load (impractical for a documentation standard; validation criteria V7-V11 measure the after-state instead) and a formal SIPOC (the ADR Context section captures suppliers, inputs, process, outputs, and customers implicitly).

### Cognitive load comparison

*Before:* Cross-reference §1.5, §2.2, §1.2, §2.1, §2.3, and applicable addenda per signal. No routing mechanism, no per-stage artifact reference, no addenda activation map, no defined directory for half the artifact types.

*After:* Capture the signal (2 minutes), answer 5 routing questions (§2.1 decision tree), read Input/Artifact at each stage (one line), check activation map for addenda (one table lookup), store the artifact (directory named in repo-structure template). No cross-referencing required.

**Cost of doing nothing:** The cross-referencing cost is paid per signal, per practitioner, per project.

---

## Decision

Nine decisions. D1-D5 are structural process changes; D6-D8 are bridging and verification; D9 is directory layout, naming, and the `examples/` to `templates/` rename.

**Note on file paths:** Links in this ADR have been updated to post-D9 paths as part of implementation. Pre-implementation, all links used `examples/X-template.md` paths; post-implementation they use `templates/X.md` or `starters/X.md` per the D9 mapping table.

### D1: DISCOVER depth model

DISCOVER operates at three depth levels determined by what is already known about the signal.

| Depth | Name | Entry condition | Activities | Artifact | Exit gate |
|---|---|---|---|---|---|
| D0 | Capture | Signal observed | Record raw observation and source | Row appended to intake log ([intake-template.md](../../starters/intake-log.md) defines the log format; stored at `docs/intake-log.md` for non-tracked-system projects, or in the tracked system's intake queue) | Signal captured; triage scheduled. Target: under 2 minutes. |
| D1 | Triage | Intake log entry exists | Evidence check; duplicate check; consult lessons-learned (§8.3) and anti-pattern (§8.4) registries | Triage decision recorded on intake log entry | One of four exits: **promote** (confirmed, cause known) to DEFINE; **investigate** (suspected, unconfirmed) to type=investigation; **park** (real but not now) with revisit trigger; **discard** (not real or duplicate) with reason |
| D2 | Characterize | Signal promoted but insufficient information to write observable AC | Root cause analysis for defects (5 Whys, fishbone, existing FMEA review); problem research for features (who has the problem, frequency, current approach, cost, solved state); baseline measurement for improvements; risk analysis for security | For defects: [investigation-template.md](../../templates/investigation.md) (started at D2, continues as the paired document for the type=investigation work item through DEFINE and beyond; one continuous artifact). For features/products: [problem-research-template.md](../../templates/problem-research.md). For improvements: baseline recorded in work item. | Root cause identified, OR problem characterized enough to write observable AC, OR baseline measured |

D0 and D1 apply to every signal. D2 applies when the signal is confirmed but AC cannot yet be written. Common D2 triggers: bug with unknown root cause, feature where the problem space is not yet characterized, improvement where the baseline has not been measured.

**Expedite and P0 work.** For active outages (expedite class of service), the sequence is: fix first, then back-fill. The intake record and work item are created retroactively after resolution. D0 and D1 are documented after the fact, not before. This matches how post-mortems work: the incident occurs first, then is documented.

**§1.2 document progression mapping.** The document progression is not a separate phase. It spans DISCOVER, DEFINE, and DESIGN for complex products:

| §1.2 Step | Lifecycle stage | Artifact |
|---|---|---|
| Step 1: Problem research | DISCOVER D2 | [problem-research-template.md](../../templates/problem-research.md) |
| Step 2: Capabilities | Bridge: late DISCOVER / early DEFINE | [capabilities-template.md](../../templates/capabilities.md) |
| Step 3: PRD | DEFINE | [prd-template.md](../../templates/prd.md); gate authority approval required before DESIGN |
| Step 4: Architecture + ADRs | DESIGN | [architecture-doc-template.md](../../templates/architecture-doc.md), [adr-template.md](../../templates/adr.md) |
| Step 5: Implementation | BUILD through CLOSE | Remainder of §2.1 lifecycle |

A bug fix enters at DISCOVER D0 and proceeds to DEFINE after triage, skipping §1.2. A routine feature with understood requirements enters at D0 and goes directly to DEFINE after D1. A new product starts at D2 (problem research) and follows the full §1.2 progression.

**problem-research-template.md reframing.** The template gains a dual-role note: full depth for §1.2 Step 1 product work; abbreviated (Problem Statement and Decision sections only) for feature-level DISCOVER D2 characterization.

**§2.7 expansion** from three required elements to five:

1. How signals are captured (intake record format and filing location)
2. Where intake records accumulate before triage (the intake channel)
3. The triage cadence (how frequently intake records are reviewed)
4. How confirmed problems are promoted to §2.2 work items
5. How users are notified when their feedback is acted on

**STANDARDS.md §2.1 congruence fixes required by D1:**
- "Every piece of work follows this sequence without exception" must change to "Every piece of work that enters the delivery system follows this sequence." Signals discarded or parked at DISCOVER do not enter the delivery system.
- "Before creating the work item, consult the registries" must shift to D1 triage timing.
- The PDCA bridge ("Plan = DISCOVER + DEFINE + DESIGN") must note that signals not proceeding to DEFINE are evaluated but not planned work.
- §2.2 discovery source types must include "promoted from intake log entry [date]" as a pattern.
- §1.2 bug-fix language must change from "goes directly to implementation" to "enters at DISCOVER and proceeds to DEFINE after triage."
- §2.7 closing sentence ("User feedback is evidence for the DISCOVER step") must become the opening framing, not a closing note, and §2.1 DISCOVER must reference §2.7 as the signal source.

**Failure modes:** Practitioner assigns wrong depth (mitigation: decision tree routes based on observable conditions; depth can be escalated). Intake records accumulate without triage (mitigation: triage cadence is a required §2.7 element). D2 characterization loops without converging (mitigation: investigation template forces convergence through required root cause statement and decision section).

### D2: §2.2-compliant tracked systems

A §2.2-compliant tracked work item system captures all eight required attributes (title, AC, dependencies, owner, discovery source, priority, class of service, type), maintains lifecycle status, and attaches gate evidence in a reviewable form. Such a system satisfies the work item record requirement. `work-item-template.md` serves two purposes: projects without a tracked system, and the ADR-019 export format for private systems.

For projects using a compliant tracked system: structured lifecycle data is canonical in the tracked system; narrative artifacts (ADRs, post-mortems, session logs) are canonical in the repository, linked by work item ID; private systems commit a generated export at close per ADR-019; publicly accessible systems satisfy ADR-019 by default.

**Failure modes:** Team claims compliance without all 8 attributes (mitigation: compliance review checks all attributes). Exports drift from live record (mitigation: exports are generated from tracked system data at close, not maintained manually).

### D3: Process decision tree in §2.1

Five routing steps placed in §2.1 before the lifecycle diagram. Steps are ordered so the most consequential question runs first: domain classification eliminates the entire lifecycle if the answer is Complex; urgency changes flow policy before anything else; scope determines depth; type and addenda refine from there.

**Step 1 - Domain (§1.5).** Can you write AC before starting? Does the approach depend on experiments? Complex: probe-sense-respond. Complicated: continue.

**Step 2 - Urgency (§2.2 class of service).** Expedite: resolve first, back-fill after. Fixed-date: track countdown. Standard/Intangible: normal flow.

**Step 3 - Scope (DISCOVER depth).** New product/major feature: D2 then §1.2 progression before DEFINE. Routine feature or known-cause defect: D0-D1 then DEFINE. Unknown-cause defect: D0-D1-D2 then DEFINE. Investigation: D2 is the primary work.

**Step 4 - Type (§2.2).** Assign one of 9 types. Type determines lifecycle gates and close conditions.

**Step 5 - Addenda overlay.** Check each applicable addendum. Requirements stack. Activation map (D5) shows per-stage requirements.

The concise tree (~20 lines) lives in §2.1 at point of use. Extended reference (edge cases, template guide, activation map) lives in adoption.md. The practitioner does not leave STANDARDS.md for routing.

**Edge cases (adoption.md extended reference):**
- Reclassification mid-lifecycle: re-run Steps 4-5; new gates apply forward only.
- Multiple addenda stacking: requirements are additive at each stage.
- Complex to Complicated transition: work enters full lifecycle at DEFINE; probe cycle session logs become DISCOVER evidence.
- Compressed triage for expedite: D0/D1 back-filled after resolution.
- Measurement-driven investigation (§1.2): BUILD may precede investigation close; investigation stays at D2 until measurement complete.

**Failure modes:** Wrong routing (mitigation: questions are binary/observable; routes correctable without irreversible commitment). Tree becomes stale (mitigation: Template-Standard Drift anti-pattern requires same-commit updates). Practitioners skip tree (mitigation: tree is at the top of §2.1; compliance reviews check routing).

### D4: Per-stage operational blocks

Each §2.1 lifecycle stage gains a structured block with three sections: Input (entry
condition), Artifacts (nested with labels and template links citing governing sections), and
Addenda (applicable addendum requirements with links to specific addendum sections). A
practitioner at any stage sees everything needed without leaving §2.1.

The full per-stage blocks are specified in the D1 depth table (for DISCOVER) and the table
below (for DEFINE through CLOSE). All template links use post-D9 paths (`templates/`).
All addenda links point to specific sections within each addendum file. All governing-section
links point to STANDARDS.md sections.

| Stage | Input | Artifacts (nested, labeled, linked) | Addenda at this stage (linked) |
|---|---|---|---|
| **DISCOVER** | Signal from [§2.7](#27-user-feedback) | See D1 depth table: D0 → [intake log](../../templates/intake-log.md); D1 → triage decision; D2 → [investigation](../../templates/investigation.md) or [problem research](../../templates/problem-research.md) | [CI](../addenda/continuous-improvement.md): Gemba, SIPOC, waste audit, constraint ID, Kaizen pre-work. [AI/ML](../addenda/ai-ml.md): incident taxonomy ext. |
| **DEFINE** | Confirmed problem; enough to write AC | All: [work item](../../templates/work-item.md) per [§2.2](#22-work-item-discipline). Investigation: + [investigation](../../templates/investigation.md) (continued from D2). §1.2 products: + [PRD](../../templates/prd.md) per [§1.2](#12-document-progression) | [CI](../addenda/continuous-improvement.md): QFD. [Multi-Team](../addenda/multi-team.md): RFC before WI |
| **DESIGN** | Work item with AC | Per [qualification checklist](../../templates/work-item.md): new component/replaced/new dep/changed comm → [ADR](../../templates/adr.md) per [§4.2](#42-adr-format); auth/payments/data mutation/ext integrations → [FMEA](../../templates/fmea.md) per [§2.1](#21-the-lifecycle); new component → [architecture doc](../../templates/architecture-doc.md) per [§3.1](#31-component-architecture-template). [§2.2 type table](#22-work-item-discipline) may add gates | [CI](../addenda/continuous-improvement.md): DoE, DBR, Heijunka, SMED. [AI/ML](../addenda/ai-ml.md): autonomy, hallucination. [Web](../addenda/web-applications.md): browser matrix, headers, a11y. [Event-Driven](../addenda/event-driven.md): schema, idempotency, backpressure, DLQ, ordering. [Multi-Service](../addenda/multi-service.md): API contract, circuit breaker, distributed txn. [Multi-Team](../addenda/multi-team.md): agreements. [Containerized](../addenda/containerized-systems.md): hardening, limits |
| **BUILD** | DESIGN complete | Code + tests per [§6](#6-testing-and-output-quality). No template. | [CI](../addenda/continuous-improvement.md): Kaizen exec. [AI/ML](../addenda/ai-ml.md): versioning, governance. [Containerized](../addenda/containerized-systems.md): image build |
| **VERIFY** | BUILD complete | [Work item](../../templates/work-item.md) VERIFY field. Doc-only: [§2.1 checklist](#21-the-lifecycle) | [CI](../addenda/continuous-improvement.md): SPC, capability, before/after, SMED. [AI/ML](../addenda/ai-ml.md): eval harness (CI), bias. [Web](../addenda/web-applications.md): Vitals, Lighthouse, viewport, a11y, XSS/CSRF. [Event-Driven](../addenda/event-driven.md): schema compat. [Multi-Service](../addenda/multi-service.md): contract tests, tracing, deployability. [Multi-Team](../addenda/multi-team.md): integration test, agreement verify, escalation |
| **DOCUMENT** | VERIFY passed | As applicable: [session log](../../templates/work-session-log.md) per [§4.6](#46-work-session-logs); [runbook](../../templates/runbook.md) per [§4.8](#48-documentation-layers); [deployment](../../templates/deployment.md) per [§4.1](#41-what-must-be-documented); [setup](../../templates/setup.md) per [§4.1](#41-what-must-be-documented) | [AI/ML](../addenda/ai-ml.md): model card. [Event-Driven](../addenda/event-driven.md): arch doc adds. [Multi-Service](../addenda/multi-service.md): arch doc adds |
| **DEPLOY** | DOCUMENT complete; rollout + rollback per [§5.7](#57-deployment-strategies-and-release-safety) | [Deployment](../../templates/deployment.md) executed | [AI/ML](../addenda/ai-ml.md): model promotion. [Web](../addenda/web-applications.md): browser verify. [Containerized](../addenda/containerized-systems.md): rollout, probes |
| **MONITOR** | DEPLOY complete; smoke test passed | [Work item](../../templates/work-item.md) MONITOR field; [SLO](../../templates/slo.md) per [§7.5](#75-service-level-objectives) if new | [CI](../addenda/continuous-improvement.md): capability, control charts. [AI/ML](../addenda/ai-ml.md): quality, confidence, drift. [Web](../addenda/web-applications.md): Vitals ongoing. [Event-Driven](../addenda/event-driven.md): lag, DLQ, violations |
| **CLOSE** | All [§2.3 DoD](#23-definition-of-done) + [type-conditional](#23-definition-of-done) met | [Work item](../../templates/work-item.md) Gate Evidence; private systems: [export](../../templates/work-item-export.md) per [ADR-019](ADR-019-work-item-accessibility-requirement.md) | [CI](../addenda/continuous-improvement.md): Kaizen post-event |

Each addendum gains one cross-reference sentence pointing to the per-stage blocks in §2.1.

**Failure modes:** Blocks become stale (mitigation: Template-Standard Drift anti-pattern).
Blocks add approximately 90 lines to §2.1 (assessment: eliminates all cross-referencing;
every answer is at point of use).

### D5: adoption.md target state

adoption.md is restructured from a flat 7-section setup guide into a 3-part practitioner
journey. This section specifies what adoption.md looks like after implementation. Content
from D3 (edge cases), the template guide specification, and D4 (cross-cutting summary) all
land here. A reviewer can read this section and know exactly what adoption.md will contain.

```
# Adopting and Operating Excellence Standards - Engineering

> How to bring these standards into your project, and the operational
> reference for template routing and lifecycle addenda activation.

## Table of Contents
(all sections listed)

## Part 1: Adoption (one-time setup)

  ### What You Get
  - STANDARDS.md: 9 sections
  - templates/: 15 reusable templates (multi-instance; was examples/; split per D9)
  - starters/: 8 one-time setup files (copy at adoption, maintain)
  - docs/addenda/: 7 extensions
  - docs/decisions/: ADRs behind the standard
  - Note: STANDARDS.md has 34 relative-path dependencies; full repo required

  ### Maturity Model Positioning
  (unchanged)

  ### How to Adopt
  (submodule setup, fork, copy guidance - unchanged)

  ### First Steps After Adoption
  1. Copy starters/ files to create initial project files (standards-application,
     repo structure, registries, intake log, setup, deployment, runbook)
  2. Set up repo structure per starters/repo-structure.md
  3. Identify applicable addenda; consult the §2.1 per-stage blocks for
     when each addendum's requirements activate
  4. Define your intake channel and triage cadence (§2.7)
  5. File issues for every gap
  6. Define compliance review cadence
  7. Process your first signal through the §2.1 decision tree

  ### Pre-Existing Projects
  (unchanged)

## Part 2: Operating the Lifecycle (daily reference)

  ### Decision Tree Extended Reference
  The concise decision tree lives in §2.1 (5 routing questions). This section
  covers the edge cases that don't fit in the concise form:
  - Reclassification mid-lifecycle
  - Multiple addenda stacking
  - Complex to Complicated transition
  - Compressed triage for expedite
  - Measurement-driven investigation

  ### Template Use Guide
  All 23 templates organized by 6 process phases:
  Phase 1: Project initialization
  Phase 2: Problem discovery and scoping (§1.2)
  Phase 3: Delivery lifecycle (§2.1)
  Phase 4: Learning from failure (§8)
  Phase 5: Technology adoption (§9.1)
  Phase 6: Ongoing compliance
  (Full tables specified in the Template Guide Specification section of this ADR)

  ### Cross-Cutting Activation Summary
  Compact 9x7 table for a different question than the per-stage blocks answer.
  Per-stage blocks (§2.1) answer: "I'm at VERIFY; what addenda apply?" (row view).
  This table answers: "Where does the Web addendum apply across the lifecycle?"
  (column view). Used during compliance reviews and initial addenda assessment.
  Derived from the §2.1 per-stage blocks; not a second source of truth.
  Carries maintenance note: "Derived from §2.1 blocks. Update both in same commit."

## Part 3: Improvement and Reference

  ### Connecting to Continuous Improvement
  When delivery health declines (§7.4) or patterns recur (§8.4):
  - Throughput stalls → waste audit (CI addendum)
  - Systemic problem identified → A3 (§8.7)
  - Before any improvement initiative → VSM (CI addendum)
  - Time-boxed bounded improvement → Kaizen event (CI addendum)
  The §2.1 per-stage blocks show where CI tools activate in the lifecycle.

  ### Feedback and Contributions
  (unchanged)
```

**Key changes from current adoption.md:**
- Title updated to reflect dual role
- First Steps gains 2 items: intake channel/triage cadence and first-signal routing
- "What Your Project Produces" partial artifact table eliminated; replaced by Part 2
  Template Use Guide (complete, no stale duplicate)
- Part 2 is the most-used section: template routing, edge cases, cross-cutting summary
- Part 3 bridges operating to improving with named CI addendum entry points
- Growth: 146 to ~250 lines. ToC handles navigation.

### D6: DMAIC vocabulary bridge

One paragraph after the existing PDCA bridge in §2.1:

> This lifecycle also maps to the DMAIC cycle used in Six Sigma: Define = DISCOVER + DEFINE; Measure = baseline measurement in DEFINE (for improvement-type work items) and metric verification in VERIFY; Analyze = DISCOVER depth D2 (root cause characterization and problem research) and DESIGN qualification; Improve = BUILD; Control = MONITOR + CLOSE + lessons-learned and anti-pattern registries. Teams familiar with DMAIC can use this mapping to connect the lifecycle to their existing improvement vocabulary.

### D7: §2.7 and DISCOVER bidirectional reference

§2.7 gains: "User feedback is the primary signal source for the DISCOVER step (§2.1). Without a functioning intake and triage process, there is no reliable path from observation to confirmed work item."

§2.1 DISCOVER gains: "Signals arrive through the project's §2.7 feedback channel."

### D8: Compliance review addenda verification

The compliance-review template "Applicable Addenda Reviewed" section gains a third column: "Per-stage requirements verified (see activation map in §2.1)." Sign-off is blocked until per-stage addenda requirements are verified against the §2.1 activation map. Additional rows required: §2.1 DISCOVER depth model applied, decision tree consulted, §2.7 intake channel and triage cadence defined.

### D9: `templates/` + `starters/` split, layout, and naming conventions

#### Split `examples/` into `templates/` and `starters/`

The current `examples/` directory conflates two fundamentally different usage patterns under
one inaccurate name. The files serve two purposes:

- **Templates** - files used repeatedly throughout the lifecycle to create new instances. You
  create ADR-001, ADR-002, ADR-003 from the ADR template. A post-mortem template produces one
  file per incident. Templates stay in the submodule as reusable references.
- **Starters** - files copied once at adoption to bootstrap the project, then maintained.
  You never create a second standards-application.md. You never create a second
  lessons-learned registry. Starters are seeds, not molds.

Split `examples/` into two directories at the repository root (same depth; no breaking
path-depth change). Drop `-template` suffix from all files in both directories (directory
name provides context). Registry starter files keep `-registry` (descriptive, not redundant).

**templates/** (15 files - create many instances; referenced from submodule throughout lifecycle):

| Current path | New path |
|---|---|
| `templates/adr.md` | `templates/adr.md` |
| `templates/a3.md` | `templates/a3.md` |
| `templates/architecture-doc.md` | `templates/architecture-doc.md` |
| `templates/capabilities.md` | `templates/capabilities.md` |
| `templates/compliance-review.md` | `templates/compliance-review.md` |
| `templates/fmea.md` | `templates/fmea.md` |
| `templates/investigation.md` | `templates/investigation.md` |
| `templates/post-mortem.md` | `templates/post-mortem.md` |
| `templates/prd.md` | `templates/prd.md` |
| `templates/problem-research.md` | `templates/problem-research.md` |
| `templates/slo.md` | `templates/slo.md` |
| `templates/tech-eval.md` | `templates/tech-eval.md` |
| `templates/work-item.md` | `templates/work-item.md` |
| `templates/work-item-export.md` | `templates/work-item-export.md` |
| `templates/work-session-log.md` | `templates/work-session-log.md` |

**starters/** (8 files - copy once at adoption; fill in and maintain):

| Current path | New path |
|---|---|
| `starters/standards-application.md` | `starters/standards-application.md` |
| `starters/repo-structure.md` | `starters/repo-structure.md` |
| `starters/deployment.md` | `starters/deployment.md` |
| `starters/runbook.md` | `starters/runbook.md` |
| `starters/setup.md` | `starters/setup.md` |
| `starters/lessons-learned-registry.md` | `starters/lessons-learned-registry.md` |
| `starters/anti-pattern-registry.md` | `starters/anti-pattern-registry.md` |
| *(new)* | `starters/intake-log.md` |

**Categorization rationale:** templates/ contains files that produce MULTIPLE instances over
a project's lifetime (ADR per decision, post-mortem per incident, work item per task).
starters/ contains files that produce ONE instance per project and are then maintained
(standards-application created at adoption, registries seeded once and appended to, setup and
runbook created once per project). Edge cases (deployment, runbook, setup) are categorized as
starters because: most projects create one of each, the adoption guide's First Steps directs
their creation, and multi-service projects that need multiples can still reference the starter
format.

Mechanical impact: 150+ link changes across 30+ files (each link targets either `templates/`
or `starters/` depending on which file it references). Executable as a single atomic commit.

#### Project directory layout (6 directories + 4 top-level files)

```
docs/
  decisions/                 # ADRs, FMEAs, tech evaluations
  architecture/              # Component architecture documents
  product/                   # §1.2 progression
    problem-research/
    capabilities/
    prd/
  incidents/                 # Post-mortems, A3s, lessons-learned, anti-patterns
    post-mortems/
  work-sessions/             # Session logs
  archive/                   # Superseded documents (ADR-010)
  setup.md
  deployment.md
  runbook.md                 # Includes SLO definitions
  standards-application.md
```

Conditional (created only when applicable): `work-items/` (ADR-019 exports), `intake-log.md` (non-tracked-system projects), `compliance-review-YYYY-MM-DD.md` (periodic reviews).

**Grouping rationale:** decisions/ groups all DESIGN-phase decision artifacts (ADRs + FMEAs + tech evaluations); architecture/ separates how-it-works from why-we-decided; product/ groups §1.2 progression artifacts with shared naming across subdirectories; incidents/ groups all failure-learning artifacts (post-mortems, A3s, registries); work-sessions/ is separate from incidents/ (routine records vs. failure documentation).

SLOs live in runbook.md (same audience); escalate to `docs/slos/` at volume. Compliance reviews live alongside standards-application.md; escalate to `docs/reviews/` at volume. Intake records live in the tracked system for compliant systems; `docs/intake-log.md` (append-only log) for non-tracked systems.

#### Naming conventions

**Universal rules:** kebab-case filenames; ISO 8601 date prefixes; `.md` extension; typed prefix on artifacts sharing a directory (`ADR-`, `FMEA-`, `EVAL-`, `A3-`).

**Numbering scheme.** Date-based is the default because it scales from solo to enterprise without migration:

- **Date-based** (sole convention): `{PREFIX}-YYYY-MM-DD-{title}.md`. No coordination at any team size; sorts chronologically; a solo project that grows never renumbers.
- ~~Sequential~~ (deprecated): `{PREFIX}-{NNN}-{title}.md`. Requires central number assignment; incurs migration cost at scale. Do not use for new projects. Existing projects already using sequential may retain it without migration.

The typed prefix and kebab-case title are universal. The numbering scheme is date-based; document it in standards-application.md.

**Per-directory conventions:**

| Directory | Convention | Example |
|---|---|---|
| `docs/decisions/` ADRs | `ADR-{id}-{title}.md` | `ADR-2026-03-24-section-order.md` |
| `docs/decisions/` FMEAs | `FMEA-{id}-{title}.md` | `FMEA-2026-03-24-payment-tokens.md` |
| `docs/decisions/` evaluations | `EVAL-{id}-{title}.md` | `EVAL-2026-03-24-message-broker.md` |
| `docs/architecture/` | `{component-name}.md` | `api-gateway.md` |
| `docs/product/` subdirs | `{product-or-feature}.md` | `notification-system.md` |
| `docs/incidents/post-mortems/` | `YYYY-MM-DD-{title}.md` | `2026-03-15-payment-api-timeout.md` |
| `docs/incidents/` A3s | `A3-YYYY-MM-DD-{title}.md` | `A3-2026-03-20-deployment-bottleneck.md` |
| `docs/incidents/` registries | Fixed: `lessons-learned.md`, `anti-patterns.md` | |
| `docs/work-sessions/` | `YYYY-MM-DD-{topic}.md` | `2026-03-24-deep-audit.md` |
| `docs/archive/` | `{original-name}-archived-YYYY-MM-DD.md` | `capabilities-v1-archived-2026-03-20.md` |
| `docs/` compliance reviews | `compliance-review-YYYY-MM-DD.md` | |
| `docs/` intake log | `intake-log.md` | |
| `docs/work-items/` exports | `{system-id}-{title}.md` | `-fix-token-expiry.md` |

Single-product repos may use flat files in `docs/product/` instead of subdirectories.

**Cross-reference rules:** relative paths (never absolute); work item IDs from tracked system in narrative artifacts; relative file paths in work items; shared naming across `docs/product/` subdirectories links the same product's §1.2 progression; date prefixes enable chronological `ls` sort.

**Failure modes:** Convention not followed (mitigation: compliance review checks; CI can enforce prefix patterns). Directory drifts from template (mitigation: compliance review; Template-Standard Drift anti-pattern). Ad-hoc directories created (mitigation: layout covers all artifact types; ad-hoc directories signal a template gap).

### Template guide specification

This specification defines the content for adoption.md Part 2. All 23 files (15 templates + 8 starters) mapped by process phase. The Directory column tells practitioners where to find the file.

**Phase 1: Project initialization** (once; all starters/)

| File | Directory | Trigger |
|---|---|---|
| standards-application | starters/ | Adopting ESE (§1.4, ADR-011) |
| repo-structure | starters/ | Setting up project directory (§4.1) |
| deployment | starters/ | First deployment procedure (§4.1) |
| runbook | starters/ | First always-on service (§4.8) |
| setup | starters/ | First setup guide (§4.1) |
| lessons-learned-registry | starters/ | Project start; add entries after post-mortems (§8.3) |
| anti-pattern-registry | starters/ | Project start; add entries when patterns recur (§8.4) |
| intake-log | starters/ | Project start; append rows per signal (§2.1 DISCOVER) |

**Phase 2: Problem discovery and scoping** (§1.2; significant new products/features; skipped for bugs and routine work; all templates/)

| §1.2 Step | File | Directory | Gate |
|---|---|---|---|
| Step 1 | problem-research (also DISCOVER D2 abbreviated) | templates/ | Gate authority confirms problem characterized |
| Step 2 | capabilities | templates/ | Gate authority approves capability list |
| Step 3 | prd | templates/ | Gate authority approves; SLOs linked |
| Step 4 | architecture-doc, adr | templates/ | Docs reviewed; ADRs accepted |

**Phase 3: Delivery lifecycle** (§2.1; per work item; all templates/ except starters noted)

| Stage | File | Directory | Trigger |
|---|---|---|---|
| DISCOVER D0/D1 | intake-log | starters/ | Every signal; append row |
| DEFINE | work-item | templates/ | Every promoted signal; 8 §2.2 attributes |
| DEFINE (investigation) | investigation | templates/ | Paired with type=investigation; continuous from D2 |
| DESIGN (qualifying) | adr | templates/ | New component, replaced approach, new dep, changed comm |
| DESIGN (high-risk) | fmea | templates/ | Auth, payments, data mutation, external integrations |
| DESIGN (new component) | architecture-doc | templates/ | New system component |
| VERIFY | work-item VERIFY field | templates/ | Record what was verified and result |
| DOCUMENT | work-session-log | templates/ | Every significant session |
| DOCUMENT | runbook | starters/ | Always-on services (created at adoption, updated here) |
| DOCUMENT | deployment | starters/ | Deployment changes (created at adoption, updated here) |
| DOCUMENT | setup | starters/ | New deps/config (created at adoption, updated here) |
| DEPLOY | deployment | starters/ | Per §5.7; rollout + rollback |
| MONITOR | work-item MONITOR field | templates/ | Detection mechanism |
| MONITOR | slo | templates/ | New SLO for always-on capability |
| CLOSE | work-item Gate Evidence | templates/ | Artifacts proving work done |
| CLOSE (private) | work-item-export | templates/ | ADR-019; generated from tracked system |

**Phase 4: Learning from failure** (§8)

| File | Directory | Trigger |
|---|---|---|
| post-mortem | templates/ | P0/P1 incident (§8.2); P2 discretionary |
| a3 | templates/ | Recurring quality issue, bottleneck, process inefficiency (§8.7) |
| lessons-learned-registry | starters/ | After every post-mortem; append entries (§8.3) |
| anti-pattern-registry | starters/ | Pattern promotion; append entries (§8.4) |

**Phase 5: Technology adoption** (§9.1)

| File | Directory | Trigger |
|---|---|---|
| tech-eval | templates/ | New package, service, or behavior-category version change |

**Phase 6: Ongoing compliance**

| File | Directory | Trigger |
|---|---|---|
| compliance-review | templates/ | Periodic review (ADR-011); at minimum annually |

---

## Scalability

Items that work at current scale but require monitoring.

| Item | Trigger for action | Action |
|---|---|---|
| STANDARDS.md line count (~984 after implementation; §2.1 ~173 lines) | Any section exceeds ~150 lines or total exceeds 950 | Cascade oversized section to sub-document per §4.7. §2.1 is the first candidate: per-stage blocks could move to `docs/lifecycle-reference.md` with a summary link. |
| Activation map in §2.1 (9 x 7) | Addenda count exceeds 10 | Cascade from §2.1 to dedicated `docs/activation-map.md`; §2.1 retains a summary reference |
| CHANGELOG.md | Major version release (v2.0.0) | Archive prior major version entries to `docs/archive/` |
| adoption.md (~250 after implementation) | Total exceeds 400 lines | Split Part 2 to `docs/operations-guide.md` |
| Compliance review template rows | Accept; template's purpose IS exhaustive coverage | |
| File count (15 templates + 8 starters = 23) | Either directory exceeds 20 files | Subdirectories within `templates/` by purpose (delivery/, learning/, adoption/) |

---

## Consequences

### Positive

- DISCOVER is artifact-supported with variable depth. No lifecycle stages added or removed.
- §1.2 maps across lifecycle stages (DISCOVER D2 to DEFINE to DESIGN), not disconnected.
- problem-research template serves dual roles at different depths. One template, scaled.
- Every signal has a capture artifact and four named triage exit states.
- Expedite work back-fills, matching how incidents are actually handled.
- Decision tree in §2.1 replaces cross-referencing with five routing questions.
- Every stage has a structured block (Input, Artifacts, Addenda) with all links at point of use.
- §2.2-compliant tracked systems explicitly recognized; duplicate records eliminated.
- Addenda requirements embedded in per-stage blocks; cross-cutting summary in adoption.md for compliance reviews.
- DMAIC and PDCA vocabulary bridges both present.
- Compliance reviews verify addenda per stage, not just per addendum.
- Every artifact has one defined storage location (5S Set in Order).
- Naming conventions with typed prefixes and date-based default scale from solo to enterprise.
- 6-directory purpose-based layout (not 13 lifecycle-stage directories). Under-one-minute comprehension.
- `templates/` + `starters/` split distinguishes multi-instance reusable files from one-time adoption files. No redundant `-template` suffix in either.
- adoption.md restructured as 3-part practitioner journey with CI addendum connection.

### Negative

- §2.1 grows by ~130 lines (per-stage blocks + decision tree + depth model + DMAIC). §2.7 expands from 3 to 5 elements.
- adoption.md grows by ~104 lines and transitions to dual-purpose document.
- `templates/` + `starters/` split: 150+ link changes across 30+ files (mechanical, atomic). Each link must target the correct directory.
- Submodule adopters see path change at next update (`.standards/examples/` to `.standards/templates/` or `.standards/starters/`).
- DISCOVER depth levels add conceptual complexity (mitigated: decision tree routes automatically).
- DESIGN, DOCUMENT, and MONITOR have conditional artifact references.
- Per-stage blocks and adoption.md cross-cutting summary require same-commit maintenance discipline.
- ISO 9001 and ISO 27001 added to dependencies.md (two new annual review items).

---

## Alternatives Considered

**Keep DISCOVER as a single paragraph.** Rejected: conflates four jobs, has no artifact, cannot route or close signals.

**ANALYZE as a tenth lifecycle stage.** Rejected: forces every work item through analysis even when root cause is obvious; breaks PDCA mapping; analysis IS what DISCOVER D2 does.

**DISCOVER D3 "Scope" as a fourth depth level.** Self-rejected: §1.2 Steps 2-3 are DEFINE work, Step 4 is DESIGN. The progression spans multiple stages and is mapped as a cross-lifecycle table.

**Decision tree in adoption.md.** Self-rejected: adoption.md is a setup guide; the tree is used on every signal. Concise tree in §2.1; extended reference in adoption.md.

**Per-addendum activation tables.** Rejected: 7 synchronized copies violate DRY and Template-Standard Drift anti-pattern.

**Separate activation map table as the source of truth.** Rejected: addenda requirements belong in the per-stage blocks where practitioners use them. A separate table creates a second source that must be synchronized. The cross-cutting summary in adoption.md is derived from (not a source for) the per-stage blocks.

**13-directory lifecycle-stage layout.** Self-rejected: 5S Sort (empty directories), Set in Order (too many to scan), SMED (over one minute to comprehend).

**Keep `examples/` as a single directory.** Rejected: name is inaccurate (§3.2 Least Surprise); conflates multi-instance templates with one-time starters; `-template` suffix is redundant (DRY, §3.2 KISS).

**Single `templates/` directory for all files (no starters/ split).** Rejected: conflates two different usage patterns. A practitioner at adoption needs to know "which files do I copy once?" vs. "which files do I use repeatedly?" The directory name answers this immediately.

**Move templates to `docs/templates/`.** Rejected: changes path depth for all 150+ links; major breaking change for submodule adopters. Templates and starters are toolkit resources, not documentation about the standard.

**Sequential numbering as default.** Rejected: requires coordination; creates migration debt when solo project scales to distributed team. Date-based works at all scales without migration.

**Universal markdown work-item-template.** Rejected: creates duplicate records that drift. Retained for non-tracked projects and ADR-019 export.

**Dynamic per-update export.** Rejected: git noise. Export on close captures the complete record.

**Bidirectional tracked-system/GitHub-Issues sync.** Rejected: allows modification outside enforcement layer. One-way push evaluated separately.

---

## Validation

### Pre-deployment

| ID | Criterion | Binary test |
|---|---|---|
| V1 | Template coverage | All 23 templates in adoption.md guide; zero unmapped |
| V2 | Stage coverage | All 9 §2.1 stages have Input + Artifact lines |
| V3 | Activation map coverage | Every addendum requirement mapped to a stage; zero unmapped |
| V4 | Decision tree completeness | All 5 edge cases addressed in adoption.md |
| V5 | Directory coverage | All 23 artifact types have a storage location in repo-structure template |
| V6 | Naming convention coverage | All artifact types have a convention in repo-structure template |
| V6a | Split completeness | Zero `examples/` link references in any `.md` file outside this ADR (ADR-021 prose references to the prior `examples/` directory are accepted as migration documentation); zero `-template` filenames in `templates/` or `starters/` (excluding `-registry`); every file in the correct directory per categorization |

### Post-deployment (first adoption review)

| ID | Criterion | Binary test |
|---|---|---|
| V7 | Routing effectiveness | Practitioner identifies correct DISCOVER depth, type, and addenda for 3 test scenarios from §2.1 tree alone |
| V8 | Artifact discoverability | Practitioner identifies correct artifact from stage description Artifact line without cross-referencing |
| V9 | Tracked system acknowledgment | Project using compliant system demonstrates compliance without markdown work item files |
| V10 | Addenda activation | Reviewer verifies per-stage compliance from activation map alone |
| V11 | Storage discoverability | Practitioner identifies correct storage location from repo-structure template without asking |
| V12 | adoption.md structure | Part 1 (Adoption), Part 2 (Operating), Part 3 (Improvement) all present with their specified subsections per D5 |

**Trigger:** First adoption review or compliance review after acceptance.

**Failure condition:** Practitioners still cross-reference multiple sections for routing, artifacts, storage, or addenda requirements.

---

## Per-Document Impact Analysis

### STANDARDS.md (834 lines; projected ~984)

Changes: §1.2 cross-lifecycle mapping table (~8 lines); §2.1 decision tree (~20 lines) + depth model (~12 lines) + per-stage operational blocks with nested artifacts and addenda (~90 lines) + DMAIC bridge (~6 lines) + type-conditional cross-refs (~2 lines); §2.2 compliant system paragraph (~6 lines); §2.7 expansion to 5 elements + DISCOVER reference (~6 lines). All `examples/` links change to `templates/` or `starters/` with suffix removal per D9. Total §2.1 growth: approximately 130 lines. Total STANDARDS.md growth: approximately 150 lines (834 to ~984).

Congruence fixes required: "without exception" language (signals can be discarded); registry consultation timing (shifts to D1); PDCA mapping note (DISCOVER can end without DEFINE); §2.2 discovery source pattern (intake log entry); §1.2 bug-fix entry point (DISCOVER D0, not "directly to implementation"); §2.7 framing (signal source opening, not closing note).

§4.7 check: ~984 lines exceeds the 950-line scalability trigger. However, the per-stage blocks are operational lookup content (not prose to read end-to-end) that eliminates the need to cross-reference six other documents. Net reading effort decreases significantly despite line growth. §2.1 itself reaches ~173 lines, exceeding the 150-line section threshold. Evaluate at implementation whether the per-stage blocks should cascade to a sub-document (`docs/lifecycle-reference.md`) with a summary link in §2.1. This is the first scalability trigger likely to fire.

### adoption.md (146 lines; projected ~250)

Restructured as a 3-part practitioner journey: Part 1 Adoption (existing content reorganized; first steps expanded with intake channel, triage cadence, first-signal guidance), Part 2 Operating the Lifecycle (decision tree extended reference with edge cases, template guide; activation map lives in §2.1 per D5 but Part 2 references it), Part 3 Improvement and Reference (CI addendum connection with named entry points: waste audit, A3, VSM, Kaizen; "What Your Project Produces" partial table replaced with template guide reference). Title updated to "Adopting and Operating Excellence Standards - Engineering." All `examples/` links change.

### README.md (83 lines; projected ~86)

`examples/` split to `templates/` (15) + `starters/` (8); intake-log added to starters; structure tree updated; adoption.md description updated for dual role.

### requirement-index.md (232 lines; projected ~244)

§2.7 entry updated (5 elements); new entries: DISCOVER depth model, intake log, compliant systems, DMAIC bridge, addenda activation map, compliance review per-stage verification. "Evidence required before work item creation" rephrased for two-stage DISCOVER/DEFINE flow. Process Routing sub-section within Methodology. All `examples/` links change.

### standards-application.md (187 lines; projected ~199)

§2.7 section expanded (intake channel, triage cadence for ESE). Naming convention documented (ESE uses sequential, accepted per D9 alternative). Intake log N/A noted. §2.2-compliant system noted (private tracked system, ADR-019 export pending). All `examples/` links change.

### dependencies.md (31 lines; projected ~35)

ADD: ISO 9001 (2015 revision; referenced in §1, §2.1 PDCA, ADR-011, ADR-021) and ISO 27001 (2022 revision; referenced in ADR-011). No entry for DMAIC (methodology vocabulary, not versioned standard; same as PDCA).

### starters/repo-structure.md (165 lines; projected ~205)

Full D9 layout with naming conventions, grouping rationale, conditional directories, numbering scheme options, cross-reference rules. Adoption checklist gains intake channel, triage cadence, naming scheme items. Stale §10.1 reference fixed to §4.8.

### templates/compliance-review.md (193 lines; projected ~201)

D8 third column in addenda section. New §2 rows: DISCOVER depth applied, decision tree consulted, §2.7 intake channel defined, triage cadence defined, §2.2-compliant system check.

### starters/intake-log.md (new; ~30 lines)

Log-format starter file. Table: Date, Signal, Source, Triage Decision, Outcome. Triage options: promote (work item ID), investigate (investigation ID), park (revisit trigger), discard (reason). Note: for tracked systems, intake records live in the tracked system.

### templates/problem-research.md (~60 lines; +3)

Dual-role note: full depth for §1.2 Step 1; abbreviated (Problem Statement + Decision) for DISCOVER D2 feature characterization.

### docs/addenda/*.md (7 files; +1 line each)

Cross-reference sentence pointing to the §2.1 per-stage blocks as the source of truth for lifecycle-stage activation of each addendum's requirements.

---

## Follow-on Requirements

**FMEA required:** No.

**Supersedes:** N/A

| # | Deliverable | Location | Depends on |
|---|---|---|---|
| 1 | Split `examples/` into `templates/` (15 files) + `starters/` (8 files); drop `-template` suffix | Root + all 30+ files | None (first) |
| 2 | intake-log.md | starters/ | #1 |
| 3 | §2.1: decision tree, depth model, per-stage blocks with nested artifacts and addenda (D4), DMAIC bridge, type-conditional refs, congruence fixes | STANDARDS.md | #2 |
| 4 | §1.2: cross-lifecycle mapping table, bug-fix language fix | STANDARDS.md | None |
| 5 | §2.7: expand to 5 elements, DISCOVER reference, framing fix | STANDARDS.md | None |
| 6 | §2.2: compliant system paragraph, discovery source pattern | STANDARDS.md | None |
| 7 | 3-part restructure per D5: template guide, edge cases, CI connection, cross-cutting activation summary (derived from §2.1 per-stage blocks) | docs/adoption.md | #2 |
| 8 | D9 layout, naming conventions, checklist, §10.1 fix | starters/repo-structure.md | #1 |
| 9 | Dual-role note | templates/problem-research.md | #1 |
| 10 | Cross-reference sentence pointing to §2.1 per-stage blocks | docs/addenda/*.md (7 files) | #3 |
| 11 | Addenda verification column, new rows | templates/compliance-review.md | #3 |
| 12 | Count + structure tree + adoption.md description | README.md | #2 |
| 13 | New entries, rephrased entries, process routing sub-section | docs/requirement-index.md | #3, #5, #6 |
| 14 | §2.7 expansion, naming convention, intake/export notes | docs/standards-application.md | #5, #8 |
| 15 | ISO 9001 + ISO 27001 entries | dependencies.md | None |
| 16 | CHANGELOG entry | CHANGELOG.md | All above |
| 17 | Committed export auto-generation on close | Tracked separately | N/A |
| 18 | One-way tracked-system-to-public-mirror evaluation | Tracked separately | N/A |

---

## Implementation Checklist

> **For the implementing agent session:** Read this checklist, not the full ADR. Each row is
> one work item. Create work items in order (dependencies are listed). Verify after each step. Run the
> final validation suite (V1-V12) after all work items are closed.

| # | Work Item title | Acceptance criteria | Verify |
|---|---|---|---|
| 1 | Split `examples/` into `templates/` (15) + `starters/` (8); drop `-template` suffix; update all links in all files | Zero `examples/` refs in any .md file; zero `-template` filenames (excluding `-registry`); every file in correct directory; CI link check passes | `grep -r 'examples/' --include='*.md' \| grep -v '.git'` returns 0; `ls templates/ starters/` matches D9 tables |
| 2 | Create `starters/intake-log.md` (log-format starter for DISCOVER D0/D1) | File exists; contains Date/Signal/Source/Triage/Outcome table; references §2.1 and §2.7 | `ls starters/intake-log.md`; read file confirms table format |
| 3 | STANDARDS.md §2.1: add decision tree (concise 5 steps), DISCOVER depth model (D0-D2 table), per-stage blocks (D4 table with nested artifacts + addenda links), DMAIC bridge, type-conditional cross-refs at DESIGN and CLOSE, congruence fixes (F1-F6) | Decision tree present before lifecycle diagram; D0-D2 table present; all 9 stages have Input/Artifact/Addenda; DMAIC paragraph after PDCA; "without exception" qualified; registry timing at D1; PDCA note added; discovery source includes intake log; §1.2 bug-fix says "enters at DISCOVER"; §2.7 framing is opening not closing | `grep 'D0.*Capture' STANDARDS.md`; `grep 'DMAIC' STANDARDS.md`; count 9 Input lines |
| 4 | STANDARDS.md §1.2: add cross-lifecycle mapping table (Steps 1-5 to DISCOVER/DEFINE/DESIGN); fix bug-fix entry point language | Table present after "Not every project needs every step"; language says "enters at DISCOVER" | `grep 'DISCOVER D2' STANDARDS.md` in §1.2 context |
| 5 | STANDARDS.md §2.7: expand to 5 elements; add DISCOVER cross-reference; reframe as signal source opening | 5 numbered elements present; opens with signal source framing; references §2.1 DISCOVER | Count elements in §2.7 |
| 6 | STANDARDS.md §2.2: add §2.2-compliant system paragraph; add "promoted from intake log" discovery source pattern | Paragraph present after "Blank template" line; intake log pattern in discovery source list | `grep 'compliant tracked' STANDARDS.md`; `grep 'intake log' STANDARDS.md` in §2.2 |
| 7 | adoption.md: 3-part restructure per D5 (template guide, edge cases, CI connection, cross-cutting summary) | Part 1/2/3 structure present; template guide has 23 files across 6 phases; edge cases section has 5 cases; CI section has 4 entry points; cross-cutting 9x7 summary present; "What Your Project Produces" table replaced with template guide reference | Verify ToC has Part 1/2/3; count templates in guide |
| 8 | `starters/repo-structure.md`: D9 layout with naming conventions, grouping rationale, conditional directories, checklist updates, §10.1 fix | 6-directory layout present; naming convention table present; date-based default stated; adoption checklist includes intake channel + triage cadence + naming scheme; §10.1 reference changed to §4.8 | `grep '§4.8' starters/repo-structure.md`; verify naming table |
| 9 | `templates/problem-research.md`: dual-role note | Note present in header acknowledging DISCOVER D2 use; abbreviated sections named | `grep 'D2' templates/problem-research.md` |
| 10 | `docs/addenda/*.md` (7 files): cross-reference sentence to §2.1 per-stage blocks | Each addendum has one sentence referencing §2.1 per-stage blocks | `grep -l 'per-stage' docs/addenda/*.md \| wc -l` returns 7 |
| 11 | `templates/compliance-review.md`: D8 addenda verification column + new §2 rows | Third column "Per-stage requirements verified" present in addenda section; rows for DISCOVER depth, decision tree, intake channel, triage cadence, §2.2-compliant system present | Verify column header; count new rows |
| 12 | README.md: structure tree updated for templates/ + starters/ split; adoption.md description updated | Structure tree shows `templates/` (15) and `starters/` (8); adoption.md description mentions operational reference | `grep 'templates/' README.md`; `grep 'starters/' README.md` |
| 13 | `docs/requirement-index.md`: new entries + rephrased entries + process routing sub-section | Entries for DISCOVER depth, intake log, §2.2-compliant systems, DMAIC bridge, addenda activation, compliance per-stage verification present; "Evidence required" rephrased for DISCOVER/DEFINE two-stage flow; Process Routing sub-section within Methodology | Count new entries |
| 14 | `docs/standards-application.md`: §2.7 expansion + naming convention + intake/export notes | §2.7 has 5 elements with ESE-specific values; naming convention documented as sequential; intake log N/A noted; §2.2-compliant system + ADR-019 export noted | Verify 5 elements; verify naming convention statement |
| 15 | `dependencies.md`: ISO 9001 + ISO 27001 entries | Both entries present with version, URL, last reviewed date, and usage notes | `grep 'ISO 9001' dependencies.md`; `grep 'ISO 27001' dependencies.md` |
| 16 | CHANGELOG.md entry for implementation version | Entry present with all changes listed | Verify version entry exists |

**Final validation (run after all work items closed):**

| V# | Check | Command or method |
|---|---|---|
| V1 | All 23 files mapped in adoption.md template guide | Count files in guide; verify = 23 |
| V2 | All 9 §2.1 stages have Input + Artifact + Addenda | Count stages with all 3 sections |
| V3 | Every addendum requirement appears in §2.1 per-stage blocks | Audit each addendum against blocks |
| V4 | All 5 edge cases in adoption.md | Count edge cases in Part 2 |
| V5 | All 23 artifact types have storage location in repo-structure | Audit artifact list against layout |
| V6 | All artifact types have naming convention | Audit naming table |
| V6a | Zero `examples/` link refs (outside ADR-021); zero `-template` filenames | `grep -r 'examples/' --include='*.md' \| grep -v '.git\|ADR-021'` returns 0; `ls templates/ starters/` matches D9 tables |
| V7-V11 | Post-deployment criteria | Deferred to first adoption review |
| V12 | adoption.md 3-part structure | Verify Part 1/2/3 headings present |
| CI | All CI checks pass | Run em dash scan, ADR frontmatter, link check, CHANGELOG structure |

> ADR-021 status changes from Proposed to Accepted when the gate authority approves.
> Implementation begins only after acceptance. All work items filed with `--deps discovered-from:ADR-021`.
