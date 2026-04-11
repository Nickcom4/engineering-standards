---
type: starter
purpose: "Capture incoming signals at DISCOVER D0"
frequency: recurring
---

# Intake Log

<a name="REQ-STR-02"></a>
**REQ-STR-02** `advisory` `continuous` `soft` `all`
Required by §2.1 (DISCOVER D0/D1) and §2.7.

> Required by [§2.1](../STANDARDS.md#21-the-lifecycle) (DISCOVER D0/D1) and [§2.7](../STANDARDS.md#27-user-feedback).
> Append one row per signal. Triage each entry at your project's defined cadence (see §2.7 element 3).
>
> **For projects using a compliant tracked work item system:** intake records live in the tracked system's intake queue. Use this file only if your project does not have a compliant tracked system.

## Log

| Date | Signal | Source | Triage Decision | Outcome |
|------|--------|--------|----------------|---------|
| YYYY-MM-DD | {raw observation - one sentence} | {GitHub issue / user report / audit / monitoring alert / retrospective / other} | promote / investigate / park / discard | {work item ID / investigation ID / revisit date / reason discarded} |

## Triage Decisions

| Decision | When to use | Next action |
|----------|-------------|-------------|
| **promote** | Signal is confirmed and root cause is known; AC can be written | Create §2.2 work item; enter at DEFINE |
| **investigate** | Signal is suspected but unconfirmed, or root cause is unknown | Create type=investigation work item; pair with [investigation template](../templates/investigation.md) |
| **park** | Signal is real but not actionable now | Record revisit trigger (date, event, or condition); revisit at that point |
| **discard** | Signal is not real, not reproducible, or a duplicate | Record reason; link to existing work item if duplicate |

## Notes

- D0 (Capture): Record the raw signal immediately. Target: under 2 minutes. No triage at this step.
- D1 (Triage): Review accumulated entries at your defined cadence. Apply one triage decision per entry.
- D2 (Characterize): For signals that are promoted but lack enough information to write observable AC, run root cause analysis (defects) or problem research (features) before creating the work item.
- Expedite class signals (active outages): resolve first, back-fill this log after resolution.
