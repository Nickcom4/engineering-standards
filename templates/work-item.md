---
type: work-item
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

# Work Item: {Title}

<a name="REQ-TPL-53"></a>
**REQ-TPL-53** `advisory` `continuous` `soft` `all`
Required by §2.2 for every work item entering the delivery system.

> Required by [§2.2](../STANDARDS.md#22-work-item-discipline) for every work item entering the delivery system. A work item is one clearly bounded unit of work with 8 required attributes. This template captures all of them plus lifecycle fields required before close.
>
> **Where this fits:** This is the implementation ticket - one bounded unit of work against requirements that are already understood. It is not the place to discover or define what to build. If you are starting a new product or significant feature, the [§1.2 document progression](../STANDARDS.md#12-document-progression) comes first: problem research → capabilities → PRD → architecture. Those documents establish the requirements; this template tracks the work items that implement them. A work item whose acceptance criteria are still unclear is a signal that the upstream documents are not yet complete enough to start.
>
> **Template relationships by work item type:**
> - **type=investigation:** pair this ticket with [templates/investigation.md](investigation.md) as the structured working document where evidence, root cause, and implementation work items are recorded. This ticket is the queue entry; the investigation template is the workspace.
> - **type=feature (new product or significant capability):** the §1.2 progression should precede this ticket. Reference the PRD as a triggered-by dependency.
> - **type=bug, debt, improvement, prevention, countermeasure, security, component:** no upstream §1.2 documents required. This template is sufficient as the single artifact.
>
> **Before creating:** consult the [lessons-learned registry](../STANDARDS.md#83-lessons-learned-registry) and the [anti-pattern registry](../STANDARDS.md#84-anti-pattern-registry) for relevant entries.

---

## Core Attributes

<a name="REQ-TPL-54"></a>
**REQ-TPL-54** `advisory` `continuous` `soft` `all`
§2.2: all 8 fields are required at creation. A work item missing any attribute is not ready to enter the delivery system.

> [§2.2](../STANDARDS.md#22-work-item-discipline): all 8 fields are required at creation. A work item missing any attribute is not ready to enter the delivery system.

**Title:** {Unambiguous - states what is wrong and what correct looks like}

**Type:** {One of: feature | bug | debt | investigation | improvement | component | security | prevention | countermeasure - see [§2.2 type taxonomy](../STANDARDS.md#22-work-item-discipline)}

**Priority:** {P0 | P1 | P2 | P3 - based on user impact, per [§8.1](../STANDARDS.md#81-incident-taxonomy)}

**Class of service:** {expedite | fixed-date | standard | intangible - per [§2.2](../STANDARDS.md#22-work-item-discipline)}

**Owner:** {Named individual or team}

**Discovered-from:** {Source that surfaced this work item. Supports multiple source types:}
- Work item ID (e.g., `PROJ-123`) - provenance from another work item
- Document path (e.g., `docs/incidents/post-mortems/2026-03-24-outage.md`) - triggered by a post-mortem, A3, or FMEA
- `observed directly` - discovered through monitoring, user report, or session work

---

## Scope

> [§1.1](../STANDARDS.md#11-before-starting-any-significant-work): explicit scope boundaries. OUT of scope is equally important and often omitted.

**IN SCOPE:**
- {Explicit deliverable}

**OUT OF SCOPE:**
- {What will not be done}

---

## Acceptance Criteria

> [§2.2](../STANDARDS.md#22-work-item-discipline): observable, binary, and measurable. Not "should be" or "improve."
>
> Format: Given {context}, when {action}, then {observable result}.

- [ ] {AC item 1}
- [ ] {AC item 2}

---

## REQ-IDs Satisfied

> List the REQ-IDs from STANDARDS.md or addenda that this work item satisfies when done. This creates bidirectional traceability: from requirement to work item and from work item to requirement.

| REQ-ID | Requirement summary |
|---|---|
| {REQ-X.X-XX} | {one-sentence requirement from STANDARDS.md} |

---

## Dependencies

> [§2.2](../STANDARDS.md#22-work-item-discipline): identified before work begins. Distinguish blocking dependencies from informational links.

| Dependency | Type | Status |
|---|---|---|
| {Work item or artifact} | blocks / discovered-from / triggered-by | open / closed |

---

## Root Cause Check

<a name="REQ-TPL-55"></a>
**REQ-TPL-55** `advisory` `continuous` `soft` `all`
§2.2 root cause identification: a work item must either address a root cause directly or identify itself as a symptom fix.

> [§2.2](../STANDARDS.md#22-work-item-discipline) root cause identification: a work item must either address a root cause directly or identify itself as a symptom fix.

- [ ] **This addresses the root cause directly** (no annotation needed)
- [ ] **This is a symptom fix** - root cause tracked in: {work item ID}. Note: "symptom fix: root cause tracked in {ID}"
- [ ] **Root cause unknown** - this work item is scoped as an investigation (type=investigation) whose deliverable is root cause identification

---

## DESIGN Qualification Checklist

> [§2.1 DESIGN](../STANDARDS.md#21-the-lifecycle): run these checks before BUILD begins. Check all that apply.

**ADR triggers** ([§4.2](../STANDARDS.md#42-adr-format)):
- [ ] Introduces a new component? -> write ADR
- [ ] Replaces an existing approach? -> write ADR + update superseded ADR status
- [ ] Adds a new external dependency? -> write ADR (check [§9.1](../STANDARDS.md#91-evaluation-framework) adoption threshold)
- [ ] Changes how services communicate? -> write ADR
- [ ] None of the above apply

**FMEA triggers** ([§2.1 DESIGN](../STANDARDS.md#21-the-lifecycle), [templates/fmea.md](fmea.md)):
- [ ] Touches authentication? -> complete FMEA
- [ ] Touches payments? -> complete FMEA
- [ ] Touches data mutation (bulk ops, delete, schema migrations)? -> complete FMEA
- [ ] Touches external integrations (3rd-party APIs, webhooks, queues)? -> complete FMEA
- [ ] None of the above apply

**Residual triggers** (inversion of the default from silent-skip to explicit-justify; if answered "no," append a one-sentence justification naming the specific reason the category does not apply to this work):

- [ ] Residual FMEA: high-risk change with silent-failure mode, irreversibility, or blast radius not captured by the four named FMEA triggers above? -> complete FMEA. If no, one-sentence justification: {reason the four triggers above fully cover the risk surface, e.g., "pure documentation change with no runtime behavior" or "touches isolated test fixture with no production path"}.
- [ ] Residual A3: class of failure observed, not just an instance (prior incidents of the same shape, recurring pattern, or anti-pattern match)? -> write A3 ([§8.7](../STANDARDS.md#87-a3-structured-problem-solving)). If no, one-sentence justification: {reason this is a single instance rather than a class, e.g., "first observation; no prior incidents of this shape in lessons-learned or anti-pattern registries"}.

**Architecture doc check** ([§3.3](../STANDARDS.md#33-architecture-doc-backlog)):
- [ ] Does this change touch a component? If yes: does the component have an architecture doc? If no: file an issue for the architecture doc before proceeding.

**ADR path:** {link to ADR if written, or N/A}
**FMEA path:** {link to FMEA if completed, or N/A}
**Architecture doc path:** {link or N/A}

---

## VERIFY Answer

<a name="REQ-TPL-56"></a>
**REQ-TPL-56** `advisory` `continuous` `soft` `all`
§2.1 VERIFY: record what was specifically verified and the result. Required before CLOSE.

> [§2.1 VERIFY](../STANDARDS.md#21-the-lifecycle): record what was specifically verified and the result. Required before CLOSE.

**What was verified:**
{Specific tests run, outputs checked, environments tested}

**Result:**
{Pass/fail with evidence - test counts, screenshots, CI output}

**For improvement claims:** baseline was {value} measured by {method} on {date}; post-change measurement is {value}; the change exceeds normal process variation because {reasoning per §7.7}.

---

## MONITOR Answer

<a name="REQ-TPL-57"></a>
**REQ-TPL-57** `advisory` `continuous` `soft` `all`
§2.1 MONITOR: "How will we know if this breaks in 30 days?" Required before CLOSE.

> [§2.1 MONITOR](../STANDARDS.md#21-the-lifecycle): "How will we know if this breaks in 30 days?" Required before CLOSE.

**Detection mechanism:** {specific alert, dashboard, health check, or log query}

**Alert configured:** {yes - link to alert config | no - not applicable because {reason}}

**Who is notified:** {team or individual}

---

## Gate Evidence

> [§2.1 CLOSE](../STANDARDS.md#21-the-lifecycle): the specific artifacts proving the work is done.

| Evidence type | Artifact |
|---|---|
| Test output | {link or inline: pass/fail counts} |
| Screenshots | {link or inline} |
| CI pipeline | {link to passing pipeline} |
| Deployment verification | {environment, timestamp, smoke test result} |
| Other | {any additional evidence} |

---

## Type-Conditional Close Requirements

<a name="REQ-TPL-58"></a>
**REQ-TPL-58** `advisory` `continuous` `soft` `all`
§2.2 and §2.3: complete the section matching this work item's type. These are required in addition to the universal DoD checklist.

> [§2.2](../STANDARDS.md#22-work-item-discipline) and [§2.3](../STANDARDS.md#23-definition-of-done): complete the section matching this work item's type. These are required in addition to the universal DoD checklist.

### If type = bug

- [ ] Regression test added ([§6.1](../STANDARDS.md#61-test-layers))
- [ ] Post-mortem written if P0 or P1 ([§8.2](../STANDARDS.md#82-post-mortem-format)) - path: {link}
- [ ] Regression cases from post-mortem filed as work items ([§8.1](../STANDARDS.md#81-incident-taxonomy))

### If type = feature

- [ ] Applicable addenda requirements captured (see below)
- [ ] ADR written if qualifying change (see DESIGN checklist above)
- [ ] FMEA completed if high-risk (see DESIGN checklist above)

### If type = debt

- [ ] Source document (ADR, post-mortem, or code comment) updated to mark debt resolved ([§8.6](../STANDARDS.md#86-technical-debt-tracking))

### If type = investigation

- [ ] Root cause statement documented
- [ ] At least one implementation work item filed with discovered-from pointing to this investigation
- [ ] **Measurement-driven exception:** {yes/no} - if yes, prototype work item: {ID}

### If type = improvement

- [ ] Baseline measurement recorded in VERIFY section above
- [ ] A3 completed if recurring issue ([§8.7](../STANDARDS.md#87-a3-structured-problem-solving)) - path: {link}
- [ ] Measured improvement exceeds normal process variation

### If type = component

- [ ] Architecture doc complete and reviewed ([§3.1](../STANDARDS.md#31-component-architecture-template)) - path: {link}
- [ ] ADR written ([§4.2](../STANDARDS.md#42-adr-format)) - path: {link}

### If type = security

- [ ] FMEA completed ([§2.1 DESIGN](../STANDARDS.md#21-the-lifecycle)) - path: {link}
- [ ] Security regression tests added ([§6.5](../STANDARDS.md#65-security-regression-standard))
<a name="REQ-TPL-59"></a>
**REQ-TPL-59** `advisory` `continuous` `soft` `all`
[ ] Security review completed (§2.5).

- [ ] Security review completed ([§2.5](../STANDARDS.md#25-reliability-and-security-gates))

### If type = prevention

- [ ] Source post-mortem Prevention table Status updated to Closed

### If type = countermeasure

- [ ] Source A3 Countermeasures table updated to mark action closed

---

## Applicable Addenda

> [Addenda](../STANDARDS.md#addenda): for type=feature work items, identify applicable addenda at DEFINE and capture their requirements in acceptance criteria.

| Addendum | Applies? | Requirements captured in AC |
|----------|---------|-------------------------------|
| [AI and ML Systems](../docs/addenda/ai-ml.md) | yes / no | |
| [Web Applications](../docs/addenda/web-applications.md) | yes / no | |
| [Event-Driven Systems](../docs/addenda/event-driven.md) | yes / no | |
| [Multi-Service Architectures](../docs/addenda/multi-service.md) | yes / no | |
| [Multi-Team Organizations](../docs/addenda/multi-team.md) | yes / no | |
| [Containerized Systems](../docs/addenda/containerized-systems.md) | yes / no | |
| [Continuous Improvement](../docs/addenda/continuous-improvement.md) | yes / no | |

---

## Universal Definition of Done

> [§2.3](../STANDARDS.md#23-definition-of-done): all items must be checked before close, regardless of type.

- [ ] Acceptance criteria explicitly verified
- [ ] Tests written and passing per [§6.1](../STANDARDS.md#61-test-layers) test pyramid
- [ ] Documentation updated
<a name="REQ-TPL-60"></a>
**REQ-TPL-60** `advisory` `continuous` `soft` `all`
[ ] Gate evidence attached (above).

- [ ] Gate evidence attached (above)
- [ ] Monitoring in place (MONITOR answer above)
- [ ] Deployed to the live environment
- [ ] All relevant repositories pushed and verified up to date with remote
- [ ] Work item record accessible per [ADR-019](../docs/decisions/ADR-019-work-item-accessibility-requirement.md)
- [ ] New person readiness: someone new could find, understand, set up, debug, and extend this work

---

*Created by: {name}*
*Date: YYYY-MM-DD*
*Work item ID: {system-specific ID}*
