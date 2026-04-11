---
type: investigation
stage:
  - discover
  - define
applies-to:
  - investigation
implements:
  - REQ-2.3-17
  - REQ-2.3-18
  - REQ-2.2-01
---

# Investigation: {Title}

<a name="REQ-TPL-26"></a>
**REQ-TPL-26** `advisory` `continuous` `soft` `all`
Required by §2.2 for work items with type=investigation.

> Required by [§2.2](../STANDARDS.md#22-work-item-discipline) for work items with type=investigation. An investigation's deliverable is a root cause identification or a decision, not a fix. The investigation is not closed until the root cause is documented and at least one implementation work item is filed.
>
> See also: [ADR-015](../docs/decisions/ADR-015-root-cause-work-item-discipline.md) (root cause identification in work item discipline).

**Work Item ID:** {ID}
**Date:** YYYY-MM-DD
**Owner:** {name}

---

## Investigation Question

> What are we trying to find out? State the question precisely. The investigation closes when this question has a documented answer.

{Specific question}

---

## Evidence Gathered

<a name="REQ-TPL-27"></a>
**REQ-TPL-27** `advisory` `continuous` `soft` `all`
Document each piece of evidence with its source. Per §2.1 DISCOVER: evidence required.

> Document each piece of evidence with its source. Per [§2.1 DISCOVER](../STANDARDS.md#21-the-lifecycle): evidence required.

| Date | Source | Finding |
|------|--------|---------|
| YYYY-MM-DD | {log, metric, user report, code review, experiment} | {what it shows} |

---

## Root Cause Statement

<a name="REQ-TPL-28"></a>
**REQ-TPL-28** `advisory` `continuous` `soft` `all`
Required before close. Per §2.2: when root cause is unknown, the investigation's deliverable IS root cause identification.

> Required before close. Per [§2.2](../STANDARDS.md#22-work-item-discipline): when root cause is unknown, the investigation's deliverable IS root cause identification.

**Root cause:** {specific, technical root cause - not "human error"}

**Contributing factors:** {what made this possible}

**Confidence:** {high - directly observed / medium - inferred from evidence / low - hypothesis requiring further investigation}

---

## Implementation Work Items

<a name="REQ-TPL-29"></a>
**REQ-TPL-29** `advisory` `continuous` `soft` `all`
Required before close: at least one implementation work item must be filed with discovered-from pointing to this investigation.

> Required before close: at least one implementation work item must be filed with discovered-from pointing to this investigation. Per [§2.2](../STANDARDS.md#22-work-item-discipline) type=investigation close conditions.

| Work Item ID | Title | Type | Status |
|---|---|---|---|
| {§2.2 work item with discovered-from: this investigation} | {what it fixes or implements} | {feature / bug / component / security / etc.} | Open / Closed |

> [ ] At least one implementation work item filed

---

## Measurement-Driven Exception

> [§1.2](../STANDARDS.md#12-document-progression): when an investigation's AC requires measured outcomes from a working implementation (the prototype IS the measurement instrument), implementation work may begin before the investigation closes. Scope the prototype specifically to produce measurement data, not as a production build.

- [ ] **Not applicable** - no prototype needed to answer the investigation question
- [ ] **Applicable** - prototype work item: {ID}. Prototype scope: {what it measures}. Investigation stays open until measurement is complete.

---

## Decision

- [ ] **Root cause identified** - implementation work items filed. Close investigation.
- [ ] **Inconclusive** - document what was learned, file follow-up investigation if needed. Close with "inconclusive: [what was learned, what remains unknown]."
- [ ] **Superseded** - a different investigation or work item resolved this. Close with reference to the superseding work.

---

*Completed by: {name}*
*Date: YYYY-MM-DD*
