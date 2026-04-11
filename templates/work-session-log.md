---
type: work-session-log
stage:
  - document
applies-to:
  - all
implements:
  - REQ-4.6-01
---

# Work Session: {YYYY-MM-DD} - {topic}

<a name="REQ-TPL-61"></a>
**REQ-TPL-61** `advisory` `continuous` `soft` `all`
Required by §4.6 for significant work sessions. The log is how future sessions resume context without re-discovering prior work.

> Required by [§4.6](../STANDARDS.md#46-work-session-logs) for significant work sessions. The log is how future sessions resume context without re-discovering prior work. Per [§2.3](../STANDARDS.md#23-definition-of-done): documentation updated is part of Definition of Done - the session log is that documentation.

**Project:** {project name}
**Duration:** {start time} - {end time}

---

## What Was Attempted

> [§4.6](../STANDARDS.md#46-work-session-logs): what you set out to do this session.

{What you set out to do}

---

## What Succeeded

> [§4.6](../STANDARDS.md#46-work-session-logs): with evidence - test output, deployed URL, command output. Per the Definition of Done ([§2.3](../STANDARDS.md#23-definition-of-done)): "compiles" is not done. Observable evidence is done.

{What was completed, with evidence}

---

## What Failed and Why

{What did not work, root cause if known. If a pattern is emerging, check the [anti-pattern registry](../STANDARDS.md#84-anti-pattern-registry).}

---

## Open Items

<a name="REQ-TPL-62"></a>
**REQ-TPL-62** `advisory` `continuous` `soft` `all`
§2.3: every open item must have a §2.2-compliant work item ID.

> [§2.3](../STANDARDS.md#23-definition-of-done): every open item must have a [§2.2](../STANDARDS.md#22-work-item-discipline)-compliant work item ID. If no work item exists, create one before closing the session log. Work left without a tracked work item is work at risk of being lost.

| Item | Work Item ID | Notes |
|------|-------------|-------|
| {description} | {§2.2 work item ID} | |

---

## Decisions Made

> [§4.2](../STANDARDS.md#42-adr-format): any significant architectural decision made this session needs an ADR, not just a session log entry.

| Decision | Rationale | ADR |
|----------|-----------|-----|
| {decision} | {why} | {ADR link if formal, or "informal - log only" if minor} |

---

## Next Session Starting Point

<a name="REQ-TPL-63"></a>
**REQ-TPL-63** `advisory` `continuous` `soft` `all`
§4.6: one paragraph - current state, what to do first, any blockers. The next session must be able to resume without asking what happened.

> [§4.6](../STANDARDS.md#46-work-session-logs): one paragraph - current state, what to do first, any blockers. The next session must be able to resume without asking what happened.

{Current state, what to do first, any blockers}
