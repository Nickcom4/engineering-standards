---
type: work-item-export
stage:
  - close
applies-to:
  - all
implements:
  - REQ-2.2-07
  - REQ-2.2-03
---

# Work Item Export: {ID}

<a name="REQ-TPL-52"></a>
**REQ-TPL-52** `advisory` `continuous` `soft` `all`
Required by ADR-019 for projects using a private work item system.

> Required by [ADR-019](../docs/decisions/ADR-019-work-item-accessibility-requirement.md) for projects using a private work item system. Export closed work item records to a committed location in the project repository at close time. This template defines the minimum required fields for an exported record.
>
> Projects using a publicly accessible work item system (GitHub Issues, shared project-management tool) satisfy the accessibility requirement by default and do not need to use this template.

---

## Core Attributes

| Field | Value |
|---|---|
| **Work Item ID** | {system-specific ID} |
| **Title** | {unambiguous title} |
| **Type** | {feature / bug / debt / investigation / improvement / component / security / prevention / countermeasure} |
| **Priority** | {P0 / P1 / P2 / P3} |
| **Class of Service** | {expedite / fixed-date / standard / intangible} |
| **Owner** | {name} |
| **Discovery Source** | {work item ID / document path / observed directly} |
| **Created** | {YYYY-MM-DD} |
| **Closed** | {YYYY-MM-DD} |
| **Close Reason** | {observable evidence of completion} |

---

## Acceptance Criteria

{Copy of the original acceptance criteria as written at DEFINE stage}

---

## Scope

**IN SCOPE:**
{Copy from work item}

**OUT OF SCOPE:**
{Copy from work item}

---

## VERIFY Answer

{What was specifically verified and the result}

---

## MONITOR Answer

{How breakage will be detected in 30 days: specific alert, dashboard, or detection mechanism}

---

## Gate Evidence

| Evidence type | Artifact |
|---|---|
| {Test output / Screenshot / CI pipeline / Deployment verification / Other} | {link or description} |

---

## Dependencies

| Dependency | Type | Status at close |
|---|---|---|
| {Work item or artifact} | {blocks / discovered-from / triggered-by} | {open / closed} |

---

*Exported by: {name}*
*Export date: YYYY-MM-DD*
*Source system: {name of work item system}*
