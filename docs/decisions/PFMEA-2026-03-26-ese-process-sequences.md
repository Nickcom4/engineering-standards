---
type: fmea
fmea-type: PFMEA
id: PFMEA-2026-03-26-ese-process-sequences
title: "PFMEA: ESE Process Sequences"
status: Iteration 10
date: 2026-03-26
owner: Nick Baker
adr: ADR-2026-03-25-ese-machine-readable-first-format
implements:
  - REQ-2.1-35
  - REQ-2.1-37
  - REQ-2.1-41
  - REQ-2.1-42
  - REQ-2.1-43
---

# PFMEA: ESE Process Sequences

> Process FMEA analyzing every sequential flow in ESE for failure modes.
> DFMEA analyzes *what can fail in a component*. This PFMEA analyzes *what can fail in the process of following ESE*.
> Failure mode categories: step skipped, step out of order, output insufficient for next step, recursive loop never exits.

---

**Feature/Process:** ESE delivery process sequences\
**FMEA Type:** PFMEA (process)\
**Author:** Nick Baker (session 44)\
**Date:** 2026-03-26\
**Reviewed by:** Nick Baker / 2026-03-26\
**RPN Threshold:** 75

---

## Table of Contents

- [Rating Scales](#rating-scales)
- [Failure Mode Analysis](#failure-mode-analysis)
- [P1: Work Item Lifecycle (§2.1)](#p1-work-item-lifecycle-21)
- [P2: DISCOVER Depth Levels (§2.1)](#p2-discover-depth-levels-21)
- [P3: Process Decision Tree (§2.1)](#p3-process-decision-tree-21)
- [P4: Document Progression (§1.2)](#p4-document-progression-12)
- [P5: Adoption Path (adoption.md)](#p5-adoption-path-adoptionmd)
- [P6: Incident Response (§8.1-§8.2)](#p6-incident-response-81-82)
- [P7: FMEA-to-Control Loop (§2.1 DESIGN)](#p7-fmea-to-control-loop-21-design)
- [P8: Improvement Cycle (§2.1 + CI addendum)](#p8-improvement-cycle-21--ci-addendum)
- [P9: Mode 2 Enforcement Rule Promotion](#p9-mode-2-enforcement-rule-promotion)
- [RPN Summary](#rpn-summary)
- [Controls Summary](#controls-summary)
- [High-Severity Failure Modes (Severity >= 7)](#high-severity-failure-modes-severity--7)
- [RPN Tracking Table](#rpn-tracking-table)
- [Iteration Narrative](#iteration-narrative)
- [Applicable Addenda](#applicable-addenda)
- [Review Checklist](#review-checklist)

---

## Rating Scales

| Score | Severity (S) | Occurrence (O) | Detectability (D) |
|---|---|---|---|
| 1-2 | Negligible: no delivery impact | Remote: automated enforcement in place | Almost certain: gate blocks progression |
| 3-4 | Low: minor inefficiency, workaround | Low: strong controls, edge cases only | High: CI or pre-commit catches |
| 5-6 | Moderate: partial output, recoverable | Moderate: depends on human judgment | Moderate: caught within work period |
| 7-8 | High: step skipped, rework required | High: depends on human memory | Low: only next-session or audit catches |
| 9-10 | Critical: defective output to users | Near certain: no control exists | Cannot detect: silent failure |

**D: lower is better** (1 = always caught, 10 = never caught).
**RPN** = S x O x D. **Threshold: 75.** **Severity threshold: 7.**

## Failure Mode Analysis

### Process Inventory

Eight sequential processes identified in STANDARDS.md:

| # | Process | ESE section | Steps | Recursive? |
|---|---|---|---|---|
| P1 | Work item lifecycle | §2.1 | DISCOVER-DEFINE-DESIGN-BUILD-VERIFY-DOCUMENT-DEPLOY-MONITOR-CLOSE | Yes (re-entry triggers) |
| P2 | DISCOVER depth levels | §2.1 | D0 Capture -> D1 Triage -> D2 Characterize (conditional) | No |
| P3 | Process decision tree | §2.1 | Domain -> Urgency -> Scope -> Type -> Addenda overlay | No |
| P4 | Document progression | §1.2 | Problem research -> Capabilities -> PRD -> Architecture/ADRs | No |
| P5 | Adoption path | adoption.md | 7 first steps -> ongoing compliance -> periodic review | Periodic |
| P6 | Incident response | §8.1-§8.2 | Detect -> Respond -> Post-mortem -> Prevention -> Verify prevention | Yes (recurrence) |
| P7 | FMEA-to-control loop | §2.1 DESIGN | Identify FM -> Score -> Design change -> Revalidate -> Accept | Yes (iterate until RPN < threshold) |
| P8 | Improvement cycle | §2.1 + CI addendum | Baseline -> Implement -> Measure -> Compare to variation -> Accept/reject | Yes (iterate if noise) |

---

## P1: Work Item Lifecycle (§2.1)

**Sequence:** DISCOVER -> DEFINE -> DESIGN -> BUILD -> VERIFY -> DOCUMENT -> DEPLOY -> MONITOR -> CLOSE

| FM# | Step/Transition | Failure Mode | Effect | Root Cause | Current Controls | S | O | D | RPN | Action Required | Status |
|---|---|---|---|---|---|---|---|---|---|---|---|
| PF-01 | DEFINE skipped | BUILD begins without AC | Rework when done-state is ambiguous | Manual process step | REQ-2.1-02 (AC before implementation) | 8 | 3 | 2 | 48 | Controlled: REQ-2.1-02 | stable |
| PF-02 | DESIGN skipped | BUILD without ADR/FMEA for qualifying change | Unanalyzed failure modes reach production | Manual process step | REQ-2.1-03, REQ-2.1-04 (ADR/DFMEA) | 9 | 3 | 2 | 54 | Controlled: REQ-2.1-03, REQ-2.1-04 | stable |
| PF-03 | VERIFY skipped | DEPLOY without test evidence | Defects reach production | Manual process step | REQ-2.1-06, REQ-2.1-15 (unit+integration pass) | 9 | 2 | 2 | 36 | Controlled: REQ-2.1-06, REQ-2.1-15 | stable |
| PF-04 | DOCUMENT skipped | CLOSE without documentation | Next person cannot maintain | Manual process step | REQ-2.1-08 (doc before close) | 7 | 4 | 2 | 56 | Controlled: REQ-2.1-08 | stable |
| PF-05 | MONITOR skipped | CLOSE without alerting | Silent failure in 30 days | Manual process step | REQ-2.1-10, REQ-2.1-34 (monitor answer + who notified) | 8 | 3 | 2 | 48 | Controlled: REQ-2.1-10, REQ-2.1-34 | stable |
| PF-06 | Re-entry not triggered | BUILD continues despite DEFINE gap | Wrong feature built | Manual process step | REQ-2.1-24 (re-entry BUILD to DEFINE) | 8 | 3 | 2 | 48 | Controlled: REQ-2.1-24 (re-entry gate). Residual risk: detection depends on practitioner recognizing the gap. O reducible by automated AC-completeness check at BUILD entry. | stable |
| PF-07 | Re-entry not recorded | Return to earlier stage without documenting what was missing | Same gap recurs in future work items | Manual process step | REQ-2.1-27 (re-entry recording) | 6 | 3 | 2 | 36 | Controlled: REQ-2.1-27 (recording) + REQ-2.1-44 (registry consult evidence) | stable |
| PF-08 | PFMEA not reviewed at DESIGN | Process failure modes not analyzed for qualifying change | Process gaps invisible | Process step has no automated enforcement | REQ-2.1-35 (PFMEA reviewed) | 8 | 4 | 2 | 64 | Controlled: REQ-2.1-35 (PFMEA review). O will decrease as adoption matures. | stable |
| PF-09 | Lifecycle applied to Complex domain work | Rigid process on probe-sense-respond work | False certainty, wasted effort | Manual process step | REQ-2.1-14 step 1 (domain check) | 7 | 3 | 3 | 63 | Controlled: REQ-2.1-14 | stable |
| PF-35 | CLOSE | Parent work item closed before all constituent work items are complete | Incomplete work treated as done; remaining items lost from active tracking | Manual process step | REQ-2.3-01 (AC verified) applies but was not enforced against constituent completion. | 9 | 3 | 2 | 54 | Controlled: REQ-2.3-29 (parent close requires constituent completion) | stable |
| PF-36 | CLOSE | Work item closed with incomplete acceptance criteria rationalized as deferred | Remaining AC items never completed; normalizes partial closure | Manual process step | No existing REQ-ID | 8 | 3 | 2 | 48 | Controlled: REQ-2.3-30 (no partial AC satisfaction without tracked deps) | stable |

## P2: DISCOVER Depth Levels (§2.1)

**Sequence:** Signal -> D0 Capture -> D1 Triage -> D2 Characterize (conditional) -> DEFINE

| FM# | Step/Transition | Failure Mode | Effect | Root Cause | Current Controls | S | O | D | RPN | Action Required | Status |
|---|---|---|---|---|---|---|---|---|---|---|---|
| PF-10 | D0 skipped | Signal not recorded | Lost observation, no audit trail | Process step has no automated enforcement | REQ-2.1-19 (D0 intake entry) | 6 | 4 | 3 | 72 | Controlled: REQ-2.1-19 | stable |
| PF-11 | D1 registry consult skipped | Known issue not recognized from lessons-learned | Repeated investigation of solved problem | Process step has no automated enforcement | REQ-2.1-20 (evidence+duplicate+registry check) | 7 | 3 | 2 | 42 | Controlled: REQ-2.1-44 (registry consult must record which entries consulted) | stable |
| PF-12 | D1 exits wrong path | Signal promoted when it should be parked or discarded | Unnecessary work enters pipeline | Manual process step | REQ-2.1-21 (exactly one of four exits) | 5 | 3 | 4 | 60 | Controlled: REQ-2.1-21 | stable |
| PF-13 | D2 skipped when needed | DEFINE attempted without sufficient understanding | Poor AC, rework | Manual process step | REQ-2.1-22 (D2 characterization artifact) | 7 | 3 | 2 | 42 | Controlled: REQ-2.1-22 | stable |
| PF-14 | Expedite backfill never done | D0/D1 documentation permanently missing | Audit trail gap | Manual process step | REQ-2.1-23 (expedite backfill) | 6 | 3 | 2 | 36 | Controlled: REQ-2.1-45 (expedite close requires backfill verification) | stable |

## P3: Process Decision Tree (§2.1)

**Sequence:** Domain -> Urgency -> Scope -> Type -> Addenda overlay

| FM# | Step/Transition | Failure Mode | Effect | Root Cause | Current Controls | S | O | D | RPN | Action Required | Status |
|---|---|---|---|---|---|---|---|---|---|---|---|
| PF-15 | Steps answered out of order | Type assigned before domain check | ESE applied to Complex domain work | Manual process step | REQ-2.1-14 (answered in order) | 7 | 2 | 3 | 42 | Controlled: REQ-2.1-14 | stable |
| PF-16 | Addenda overlay step skipped | Applicable addendum requirements not stacked | Missing requirements at each stage | Process step has no automated enforcement | REQ-2.1-14 step 5 | 8 | 3 | 2 | 48 | Controlled: REQ-2.1-14, REQ-ADO-19 | stable |
| PF-17 | Wrong type assigned | Incorrect lifecycle gates activate | Missing or unnecessary artifacts | Manual process step | REQ-2.2-03 (type assigned) | 7 | 2 | 3 | 42 | Controlled: REQ-2.2-03 | stable |

## P4: Document Progression (§1.2)

**Sequence:** Problem research -> Capabilities -> PRD -> Architecture/ADRs

| FM# | Step/Transition | Failure Mode | Effect | Root Cause | Current Controls | S | O | D | RPN | Action Required | Status |
|---|---|---|---|---|---|---|---|---|---|---|---|
| PF-18 | PRD before problem research | Solution designed without understanding the problem | Wrong feature built | Manual process step | REQ-1.2-01 (progression followed in order) | 9 | 2 | 2 | 36 | Controlled: REQ-1.2-01 | stable |
| PF-19 | Architecture before PRD approval | Technical design without agreed requirements | Rework when PRD changes | Manual process step | REQ-1.2-01 | 8 | 3 | 3 | 72 | Controlled: REQ-1.2-01 | stable |
| PF-20 | Gate approval skipped | Document produced but gate not passed | Draft treated as final | Process step has no automated enforcement | §1.2 completion gates (prose, no REQ-ID) | 8 | 3 | 2 | 48 | Controlled: REQ-1.2-07 (gate passed before next step begins) | stable |

## P5: Adoption Path (adoption.md)

**Sequence:** Copy starters -> Set up repo structure -> Identify addenda -> Define intake -> Complete checklist -> Ongoing compliance

| FM# | Step/Transition | Failure Mode | Effect | Root Cause | Current Controls | S | O | D | RPN | Action Required | Status |
|---|---|---|---|---|---|---|---|---|---|---|---|
| PF-21 | Templates copied but not customized | Generic content in standards-application.md | False compliance; auditor sees templates not project-specific content | Manual process step | REQ-ADO-03 (first steps in order) | 6 | 3 | 3 | 54 | Controlled: REQ-ADO-17 (placeholder content replaced before first compliance review) | stable |
| PF-22 | Ongoing compliance review never happens | Initial adoption done but project drifts | Silent non-compliance | Manual process step | REQ-ADO-11 (ongoing requirements) | 7 | 3 | 2 | 42 | Controlled: REQ-ADO-18 (compliance review at defined cadence, no skip without exception) | stable |
| PF-23 | Addenda not re-evaluated when project scope changes | New context not covered | Missing requirements at each stage | Process step has no automated enforcement | REQ-2.1-14 step 5 | 7 | 3 | 3 | 63 | Controlled: REQ-ADO-19 (addenda re-evaluated on scope change) | stable |
| PF-39 | Ongoing compliance | Project's own artifacts violate the standards it adopted | Standard lacks credibility; adopters see inconsistency | No self-compliance enforcement mechanism | REQ-2.1-51 (self-compliance) | 9 | 2 | 2 | 36 | Controlled: REQ-2.1-51. Compliance review template applied to own repo. | stable |
| PF-40 | Standard update | New requirement added without stating whether existing artifacts must be retroactively updated | Ambiguity about what is compliant | No effective scope declaration required | REQ-2.1-52 (effective scope) | 7 | 2 | 2 | 28 | Controlled: REQ-2.1-52 requires each requirement to state prospective/retroactive/continuous scope | stable |

## P6: Incident Response (§8.1-§8.2)

**Sequence:** Detect -> Respond -> Post-mortem -> Prevention actions -> Verify prevention -> Close

| FM# | Step/Transition | Failure Mode | Effect | Root Cause | Current Controls | S | O | D | RPN | Action Required | Status |
|---|---|---|---|---|---|---|---|---|---|---|---|
| PF-24 | Post-mortem not written for P0/P1 | Root cause not analyzed | Recurrence | Process step has no automated enforcement | REQ-2.3-16 (P0/P1 post-mortem) | 9 | 3 | 2 | 54 | Controlled: REQ-2.3-16 | stable |
| PF-25 | Prevention actions filed but never executed | Post-mortem table shows actions, no work items closed | False sense of prevention | Manual process step | REQ-2.3-23 (prevention table updated at close) | 8 | 3 | 2 | 48 | Controlled: REQ-8.2-10 (prevention action has tracked type=prevention work item) | stable |
| PF-26 | Prevention executed but not verified | Fix deployed but no evidence it prevents the original failure | Unverified prevention | Manual process step | No REQ-ID | 8 | 3 | 3 | 72 | Controlled: REQ-8.2-11 (prevention work item includes evidence it prevents original failure) | stable |
| PF-27 | Bug recurs after prevention | Process loop did not close | PFMEA failure mode per REQ-2.1-36 | Process step has no automated enforcement | REQ-2.1-36 (PFMEA update on recurrence) | 9 | 3 | 2 | 54 | Controlled: REQ-2.1-36 | stable |

## P7: FMEA-to-Control Loop (§2.1 DESIGN)

**Sequence:** Identify failure modes -> Score S/O/D -> RPN > threshold? -> Design change -> Rescore -> Accept

| FM# | Step/Transition | Failure Mode | Effect | Root Cause | Current Controls | S | O | D | RPN | Action Required | Status |
|---|---|---|---|---|---|---|---|---|---|---|---|
| PF-28 | RPN threshold not defined | No clear accept/reject criterion | Subjective FMEA acceptance | Manual process step | No REQ-ID for threshold definition | 7 | 2 | 2 | 28 | Controlled: REQ-2.1-41 (RPN threshold defined before scoring begins) | stable |
| PF-29 | Design change not rescored | FMEA shows original RPN, not post-control RPN | False risk level | Process step has no automated enforcement | No REQ-ID | 7 | 2 | 2 | 28 | Controlled: REQ-2.1-42 (rescore after corrective action implemented) | stable |
| PF-30 | FMEA iteration loop never exits | Endless redesign cycle | Blocked delivery | No explicit exit criterion beyond RPN threshold | REQ-2.1-41 (threshold defined) | 6 | 2 | 2 | 24 | Controlled: REQ-2.1-41 defines exit (all FMs below threshold). Residual: if threshold is unreachable, escalate to gate authority. | stable |
| PF-31 | DFMEA done but PFMEA skipped | Component analyzed but process not | Process failures invisible | Process step has no automated enforcement | REQ-2.1-35 (PFMEA reviewed) | 8 | 3 | 2 | 48 | Controlled (new) | stable |
| PF-37 | Any step | Documentation references hardcoded values (counts, version numbers, file paths) that change when underlying data changes | Stale claims in DFMEA, ADR, CHANGELOG, session logs - auditor reads incorrect state | Manual process step | No existing control. T7 manifest auto-regenerates its OWN data but does not check references TO its data in other docs. | 7 | 3 | 1 | 21 | Controlled: lint-stale-counts.sh CI Check 9 + relative references in DFMEA | stable |
| PF-38 | FMEA update | FMEA iteration updates miss stale references in other sections of the same document (RPN tracking table, Controls Summary, status line) | Partial update creates internal inconsistency within one document | Manual process step | No existing control. Manual review is the only detection. | 7 | 3 | 2 | 42 | Controlled: REQ-2.1-43 (FMEA internal consistency at close) + lint-fmea-completeness.sh | stable |

## P8: Improvement Cycle (§2.1 + CI addendum)

**Sequence:** Baseline measurement -> Implement change -> Measure result -> Compare to variation -> Accept or iterate

| FM# | Step/Transition | Failure Mode | Effect | Root Cause | Current Controls | S | O | D | RPN | Action Required | Status |
|---|---|---|---|---|---|---|---|---|---|---|---|
| PF-32 | Baseline not recorded | No comparison possible | Improvement claim without evidence | Manual process step | REQ-2.3-19 (baseline before BUILD) | 8 | 3 | 2 | 48 | Controlled: REQ-2.3-19 | stable |
| PF-33 | Result not compared to variation | Noise declared as improvement | False improvement claim | Manual process step | REQ-2.3-20 (exceeds variation) | 7 | 3 | 2 | 42 | Controlled: REQ-2.3-20 | stable |
| PF-34 | Improvement iteration loop never exits | Perpetual measurement without accepting | Blocked delivery | No defined maximum iterations or time-box | REQ-2.3-20 (exceeds variation) | 5 | 2 | 2 | 20 | Controlled: REQ-2.3-20 defines exit (result exceeds variation). If not achieved, the hypothesis is wrong; close as unsuccessful with documented finding. | stable |

---

## P9: Mode 2 Enforcement Rule Promotion

**Sequence:** Generate Mode 2 candidates -> Review candidates -> Run 2 independent evaluations -> Record F1 scores -> Promote inert -> active

| FM# | Step/Transition | Failure Mode | Effect | Root Cause | Current Controls | S | O | D | RPN | Action Required | Status |
|---|---|---|---|---|---|---|---|---|---|---|---|
| PF-41 | Review | Mode 2 candidates generated but promotion evaluation never initiated | Inert rules accumulate; unclassified obligations remain uncovered indefinitely | No scheduled review trigger | REQ-8.3-01 (lessons-learned registry consult); periodic compliance review per §8.3 | 4 | 4 | 4 | 64 | Controlled: periodic compliance review surfaces stale candidates. | stable |
| PF-42 | Promotion | Mode 2 rule promoted without 2 independent evaluation runs | Rule activates with insufficient evidence; quality uncertain | Manual process discipline | REQ-ADD-AI-31 (2 runs required gate) + REQ-ADD-AI-32 (each F1 >= 0.85) | 8 | 2 | 2 | 32 | Controlled: REQ-ADD-AI-31 and REQ-ADD-AI-32 are hard gates at VERIFY stage. | stable |

---





































































































## RPN Summary

**Threshold:** RPN >= 75 requires action. Severity >= 7 requires review regardless of RPN.

All failure modes below RPN threshold. Highest: 72.

## Controls Summary

> Auto-generated from source FM tables by `generate-fmea-views.sh`.

- [x] REQ-1.2-01: controls PF-18, PF-19
- [x] REQ-1.2-07: controls PF-20
- [x] REQ-2.1-02: controls PF-01
- [x] REQ-2.1-03: controls PF-02
- [x] REQ-2.1-04: controls PF-02
- [x] REQ-2.1-06: controls PF-03
- [x] REQ-2.1-08: controls PF-04
- [x] REQ-2.1-10: controls PF-05
- [x] REQ-2.1-14: controls PF-09, PF-15
- [x] REQ-2.1-15: controls PF-03
- [x] REQ-2.1-19: controls PF-10
- [x] REQ-2.1-21: controls PF-12
- [x] REQ-2.1-22: controls PF-13
- [x] REQ-2.1-24: controls PF-06
- [x] REQ-2.1-27: controls PF-07
- [x] REQ-2.1-34: controls PF-05
- [x] REQ-2.1-35: controls PF-08
- [x] REQ-2.1-36: controls PF-27
- [x] REQ-2.1-41: controls PF-28
- [x] REQ-2.1-42: controls PF-29
- [x] REQ-2.1-43: controls PF-38
- [x] REQ-2.1-44: controls PF-07, PF-11
- [x] REQ-2.1-45: controls PF-14
- [x] REQ-2.2-03: controls PF-17
- [x] REQ-2.3-16: controls PF-24
- [x] REQ-2.3-19: controls PF-32
- [x] REQ-2.3-20: controls PF-33
- [x] REQ-2.3-29: controls PF-35
- [x] REQ-2.3-30: controls PF-36
- [x] REQ-8.2-10: controls PF-25
- [x] REQ-8.2-11: controls PF-26
- [x] REQ-ADO-17: controls PF-21
- [x] REQ-ADO-18: controls PF-22
- [x] REQ-ADO-19: controls PF-23
- [x] lint-fmea-completeness.sh: controls PF-38
- [x] lint-stale-counts.sh: controls PF-37

## High-Severity Failure Modes (Severity >= 7)

> Per REQ-2.1-17: Severity >= 7 requires review regardless of RPN.

| FM# | Severity | RPN | Action | Status |
|---|---|---|---|---|
| PF-01 | 8 | 48 | REQ-2.1-02 | stable |
| PF-02 | 9 | 54 | REQ-2.1-03, REQ-2.1-04 | stable |
| PF-03 | 9 | 36 | REQ-2.1-06, REQ-2.1-15 | stable |
| PF-04 | 7 | 56 | REQ-2.1-08 | stable |
| PF-05 | 8 | 48 | REQ-2.1-10, REQ-2.1-34 | stable |
| PF-06 | 8 | 48 | REQ-2.1-24 | stable |
| PF-08 | 8 | 64 | REQ-2.1-35 | stable |
| PF-09 | 7 | 63 | REQ-2.1-14 | stable |
| PF-11 | 7 | 42 | REQ-2.1-44 | stable |
| PF-13 | 7 | 42 | REQ-2.1-22 | stable |
| PF-15 | 7 | 42 | REQ-2.1-14 | stable |
| PF-16 | 8 | 48 | REQ-2.1-14 | stable |
| PF-17 | 7 | 42 | REQ-2.2-03 | stable |
| PF-18 | 9 | 36 | REQ-1.2-01 | stable |
| PF-19 | 8 | 72 | REQ-1.2-01 | stable |
| PF-20 | 8 | 48 | REQ-1.2-07 | stable |
| PF-22 | 7 | 42 | Controlled: REQ-ADO-18 (compliance review at defin | stable |
| PF-23 | 7 | 63 | Controlled: REQ-ADO-19 (addenda re-evaluated on sc | stable |
| PF-24 | 9 | 54 | REQ-2.3-16 | stable |
| PF-25 | 8 | 48 | REQ-8.2-10 | stable |
| PF-26 | 8 | 72 | REQ-8.2-11 | stable |
| PF-27 | 9 | 54 | REQ-2.1-36 | stable |
| PF-28 | 7 | 28 | REQ-2.1-41 | stable |
| PF-29 | 7 | 28 | REQ-2.1-42 | stable |
| PF-31 | 8 | 48 | Controlled (new) | stable |
| PF-32 | 8 | 48 | REQ-2.3-19 | stable |
| PF-33 | 7 | 42 | REQ-2.3-20 | stable |
| PF-35 | 9 | 54 | REQ-2.3-29 | stable |
| PF-36 | 8 | 48 | REQ-2.3-30 | stable |
| PF-37 | 7 | 21 | lint-stale-counts.sh | stable |
| PF-38 | 7 | 42 | REQ-2.1-43, lint-fmea-completeness.sh | stable |
| PF-39 | 9 | 36 | REQ-2.1-51 | stable |
| PF-40 | 7 | 28 | REQ-2.1-52 | stable |
| PF-42 | 8 | 32 | Controlled: REQ-ADD-AI-31 and REQ-ADD-AI-32 are ha | stable |

## RPN Tracking Table

Derived views (High-Severity table, RPN Summary) are auto-generated by `scripts/generate-fmea-views.sh`. Per-FM RPN history is tracked in the main FM tables via the iteration narrative below.

## Iteration Narrative

### Iteration History

| Iteration | Date | Changes | FMs above threshold |
|---|---|---|---|
| 1 | 2026-03-26 | Initial: 34 FMs across 8 processes | 12 |
| 2 | 2026-03-26 | PF-35 (parent close) and PF-36 (partial AC) added | 14 |
| 3 | 2026-03-26 | PF-37 (stale counts, RPN 392) and PF-38 (internal consistency) added; PF-35/36 rewritten tool-agnostic | 16 |
| 4 | 2026-03-26 | All 16 corrective actions implemented as REQ-IDs | 0 (all controlled at >= 100) |
| 5 | 2026-03-26 | Threshold reduced from 100 to 75; 7 FMs newly above; all already controlled; PF-06 and PF-16 residual risk noted; REQ-2.1-46, REQ-2.1-47, REQ-4.9-12 added | 0 (all 23 controlled) |
| 6 | 2026-03-26 | RPN Summary cleaned (5 below-threshold FMs removed); "Pi session" tool-specific language removed from 7 docs; template implements field expanded | 0 (all 23 controlled) |
| 7 | 2026-03-26 | All FMs rescored with controls in place (REQ-2.1-42). Severity threshold reduced from 8 to 7. RPN threshold remains 75. Post-control highest RPN: PF-23 at 63. All 38 FMs now below 75. | 0 |
| 8 | 2026-03-26 | generate-fmea-views.sh auto-generates High-Severity and RPN Summary from source FM tables. lint-fmea-consistency.sh CI Check 10 validates. Derived views never stale again. Severity threshold header updated to 7. | 0 |
| 9 | 2026-03-26 | PF-30/34 controls identified (exit criteria). PF-39 (self-compliance, RPN 81) and PF-40 (effective scope, RPN 112) added. REQ-2.1-51, REQ-2.1-52 added. CI addendum FMEA lessons updated. | 0 |
| 10 | 2026-03-26 | P9 Mode 2 enforcement rule promotion process added. PF-41 (candidates never evaluated, RPN 64) and PF-42 (promoted without 2 runs, RPN 32) added. REQ-ADD-AI-31, REQ-ADD-AI-32 control PF-42. AI/ML addendum now applicable (Mode 2 uses LLM inference). 42 FMs total, all below RPN 75. | 0 |

## Applicable Addenda

| Addendum | Applicable? | Requirements activated |
|---|---|---|
| Continuous Improvement | yes | FMEA in Practice (DFMEA + PFMEA guidance), Kaizen event measurement |
| AI/ML | yes | LLM-Generated Enforcement Rules (P9): REQ-ADD-AI-30 through REQ-ADD-AI-35 govern Mode 2 candidate generation, evaluation, and promotion. |
| Multi-Team | no | N/A (single-owner standard) |

---

## Review Checklist

> Auto-generated values from source FM tables.

- [x] All process steps listed (38 FMs)
- [x] RPN threshold defined (75)
- [x] Every Severity >= 7 FM has assigned action (31 FMs)
- [x] All FMs below RPN threshold (0 above)
- [x] No FMs with status 'open' or 'review' (0 remaining)
- [x] Post-action FMs rescored (REQ-2.1-42)
- [x] No hardcoded counts (relative references used)
- [x] Derived views auto-generated (generate-fmea-views.sh)

*Status: Iteration 8 (2026-03-26). 38 FMs across 8 processes. RPN threshold 75, severity threshold 7. All FMs rescored. Derived views (High-Severity, RPN Summary) now auto-generated from source FM tables via generate-fmea-views.sh. lint-fmea-consistency.sh CI Check 10. All FMs below threshold.*
