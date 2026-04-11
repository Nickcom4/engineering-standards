---
type: prd
stage:
  - define
applies-to:
  - feature
  - epic
implements:
  - REQ-1.2-01
---

# PRD: {Feature or Product Name}

> Product Requirements Document for {Feature or Product Name}. Produced at Step 3 of the [§1.2 Document Progression](../STANDARDS.md#12-document-progression). This document defines specific requirements, explicit scope, and binary acceptance criteria. It is the contract between product and engineering.
>
> Every requirement is observable (an outsider can verify it) and binary (it passes or it does not - no partial credit). Per [§2.2](../STANDARDS.md#22-work-item-discipline): a work item is not ready to enter active development until acceptance criteria are written and agreed on.
>
> Requires agreed capabilities ([§1.2 Step 2](../STANDARDS.md#12-document-progression)). Produces input for architecture and ADRs ([§1.2 Step 4](../STANDARDS.md#12-document-progression)).
>
<a name="REQ-TPL-38"></a>
**REQ-TPL-38** `advisory` `continuous` `soft` `all`
Before writing: verify every applicable section below against the standard.

> **Before writing:** verify every applicable section below against the standard. Enumerate the required content for each section before drafting. Writing against a checklist prevents rework from post-draft audits. Key sections to verify: [§1.1](../STANDARDS.md#11-before-starting-any-significant-work) scope and metrics, [§2.7](../STANDARDS.md#27-user-feedback) feedback mechanism, [§6.3](../STANDARDS.md#63-output-quality) output quality gates, [§7.1](../STANDARDS.md#71-service-health-checks) health checks, [§7.5](../STANDARDS.md#75-service-level-objectives) SLOs, [§5.10](../STANDARDS.md#510-minimum-security-baseline) security baseline, and applicable [Addenda](../STANDARDS.md#addenda).

---

## References

- Problem research: [{Problem Name}]({link})
- Capabilities: [{Capabilities doc}]({link})

---

## Scope

> [§1.1](../STANDARDS.md#11-before-starting-any-significant-work): state scope explicitly before writing a single requirement. OUT of scope is equally important and often omitted.

**IN scope:**
- {Explicit deliverable}

**OUT of scope:**
- {What will not be done - name it explicitly, even if obvious}

**FUTURE scope:**
- {Not now, not never - prevents false urgency from pulling it into this cycle}

---

## Functional Requirements

> [§2.2](../STANDARDS.md#22-work-item-discipline), [§2.3](../STANDARDS.md#23-definition-of-done): each requirement states what the system does, when, and with what result. Use Given/When/Then format - it forces specificity and makes verification binary.

| ID | Requirement | Acceptance criterion | Priority |
|----|-------------|---------------------|----------|
| F-1 | {What the system does} | Given {context}, when {action}, then {observable result} | Must / Should / Could |
| F-2 | | | |

**Priority definitions** - per [§2.2](../STANDARDS.md#22-work-item-discipline):
<a name="REQ-TPL-35"></a>
**REQ-TPL-35** `advisory` `continuous` `soft` `all`
Must - blocking; feature cannot ship without it.

- **Must** - blocking; feature cannot ship without it
- **Should** - strong expectation; requires explicit decision to defer
- **Could** - nice to have; deferred if time-constrained

---

## Non-Functional Requirements

<a name="REQ-TPL-36"></a>
**REQ-TPL-36** `advisory` `continuous` `soft` `all`
§6.3: every output type must be verified. §5.10: security controls required for any feature handling sensitive data or auth.

> [§6.3](../STANDARDS.md#63-output-quality): every output type must be verified. [§5.10](../STANDARDS.md#510-minimum-security-baseline): security controls required for any feature handling sensitive data or auth.

| ID | Requirement | Acceptance criterion | Notes |
|----|-------------|---------------------|-------|
| N-1 | Performance: {what} | {Measured how, numeric threshold, test method} | |
| N-2 | Availability: {what} | {SLO target - see [templates/slo.md](slo.md)} | For always-on features: complete an [SLO definition](slo.md) before shipping |
| N-3 | Security: {what} | {Specific control - see [§5.10](../STANDARDS.md#510-minimum-security-baseline)} | |
| N-4 | Accessibility: {what} | {WCAG 2.2 level - see [§6.3](../STANDARDS.md#63-output-quality)} | |

---

## Success Metrics

> [§1.1](../STANDARDS.md#11-before-starting-any-significant-work): specific, measurable, achievable, relevant, time-bounded. An unquantified success metric is an assumption.

| Metric | Baseline | Target | Measurement method | Achievable | Relevant | Evaluation date |
|--------|----------|--------|--------------------|-----------|---------|----------------|
| {What is measured} | {Current state} | {Threshold} | {How measured} | {Can the team influence this outcome?} | {Connected to the problem statement?} | YYYY-MM-DD |

---

## User Feedback

<a name="REQ-TPL-37"></a>
**REQ-TPL-37** `advisory` `continuous` `soft` `all`
§2.7: define before shipping. A system that cannot receive feedback from its users cannot improve.

> [§2.7](../STANDARDS.md#27-user-feedback): define before shipping. A system that cannot receive feedback from its users cannot improve.

- **How users report problems or requests:** {channel - support ticket, in-app form, email, etc.}
- **How reported items enter the work item system:** {process - auto-filed, triaged by team, etc.}
- **How users are notified when their feedback is acted on:** {mechanism - email, in-app notification, changelog, etc.}

---

## Failure Criteria

<a name="REQ-TPL-65"></a>
**REQ-TPL-65** `advisory` `continuous` `soft` `all`
§1.1: define before starting - not after the first incident. Per §5.7: rollback trigger must be pre-defined.

> [§1.1](../STANDARDS.md#11-before-starting-any-significant-work): define before starting - not after the first incident. Per [§5.7](../STANDARDS.md#57-deployment-strategies-and-release-safety): rollback trigger must be pre-defined.

- If {metric} worsens beyond {threshold}: {action - revert / escalate / pause rollout}
- If {condition}: escalate to {owner}

---

## Dependencies

> [§2.2](../STANDARDS.md#22-work-item-discipline): dependencies are identified before a work item is ready to start.

| Dependency | Owner | Status | Risk if delayed |
|-----------|-------|--------|----------------|
| {System, team, or decision this work depends on} | | Blocked / In progress / Done | |

---

## Open Questions and Blockers

| Question / Blocker | Impact on scope | Owner | Due |
|-------------------|----------------|-------|-----|
| | | | |

---

## Status Visibility

<a name="REQ-TPL-39"></a>
**REQ-TPL-39** `advisory` `continuous` `soft` `all`
§2.8: stakeholders waiting on this work must be able to determine current status without asking directly.

> [§2.8](../STANDARDS.md#28-status-visibility): stakeholders waiting on this work must be able to determine current status without asking directly.

**Who needs status updates:** {teams, users, or stakeholders}
**Update cadence and channel:** {how and how often}

---

## Phases (if applicable)

> [§1.3](../STANDARDS.md#13-roadmap-discipline): define each phase before starting Phase 1. A Phase 2 with no defined scope is a wish list, not a plan. Per [§2.6](../STANDARDS.md#26-flow-and-batch-size): deliver in the smallest increment that can be independently reviewed, tested, deployed, and reversed.

| Phase | Deliverables | Milestone condition | Decision point | Dependencies on prior phases |
|-------|-------------|--------------------| --------------|------------------------------|
| Phase 1 | | {Observable condition marking this phase complete} | {What is evaluated before Phase 2 proceeds} | None |
| Phase 2 | | | | Phase 1 milestone met |

---

## Applicable Addenda

> [Addenda](../STANDARDS.md#addenda): apply every addendum that matches this project's context - in addition to, not instead of, the universal standard. Confirm requirements from applicable addenda are captured in the NFRs above.

| Addendum | Applies? | Requirements captured in NFRs |
|----------|---------|-------------------------------|
| [AI and ML Systems](../docs/addenda/ai-ml.md) | yes / no | |
| [Web Applications](../docs/addenda/web-applications.md) | yes / no | |
| [Event-Driven Systems](../docs/addenda/event-driven.md) | yes / no | |
| [Multi-Service Architectures](../docs/addenda/multi-service.md) | yes / no | |
| [Multi-Team Organizations](../docs/addenda/multi-team.md) | yes / no | |
| [Containerized Systems](../docs/addenda/containerized-systems.md) | yes / no | |
| [Continuous Improvement](../docs/addenda/continuous-improvement.md) | yes / no | |

---

## Approval

<a name="REQ-TPL-40"></a>
**REQ-TPL-40** `advisory` `continuous` `soft` `all`
§1.4 gate authority: the PRD requires explicit approval before implementation begins.

> [§1.4](../STANDARDS.md#14-project-first-principles) gate authority: the PRD requires explicit approval before implementation begins. For single-operator projects: the gate authority approves the PRD as complete and ready for implementation. For multi-party teams: each stakeholder approves from their domain (product, engineering, design) - add a line per approver.

- [ ] Approved - {name, role, date}

<a name="REQ-TPL-41"></a>
**REQ-TPL-41** `advisory` `continuous` `soft` `all`
Prerequisite: All always-on availability requirements (N-x rows) must have linked SLO definitions before approval.

**Prerequisite:** All always-on availability requirements (N-x rows) must have linked [SLO definitions](slo.md) before approval.

---

## Next Step

If requirements are approved: write Architecture and ADRs. The PRD must be approved before DESIGN begins (before architecture docs and ADRs are written).
Templates: [templates/architecture-doc.md](architecture-doc.md), [templates/adr.md](adr.md).

If this feature touches authentication, payments, data mutation, or external integrations: also complete an FMEA at DESIGN stage before BUILD begins. Per [§2.1 DESIGN](../STANDARDS.md#21-the-lifecycle). Template: [templates/fmea.md](fmea.md).

---

*Completed by: {name}*
*Date: YYYY-MM-DD*
*Version: 0.1*
*Status: Draft | Under Review | Accepted*
*Project: {project name}*
