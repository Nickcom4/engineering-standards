---
type: post-mortem
stage:
  - close
applies-to:
  - all
implements:
  - REQ-8.2-01
  - REQ-8.1-01
---

# Post-Mortem: {title}

<a name="REQ-TPL-30"></a>
**REQ-TPL-30** `advisory` `continuous` `soft` `all`
Required by §8.2 for every P0 and P1 incident. P2 at team discretion.

> Required by [§8.2](../STANDARDS.md#82-post-mortem-format) for every P0 and P1 incident. P2 at team discretion. Post-mortems are blameless: the question is not who made a mistake, but what conditions allowed it to reach production. Every post-mortem produces at least one regression test and at least one entry in the lessons-learned registry.

**Date**: YYYY-MM-DD\
**Severity**: P0 / P1 / P2\
**Duration**: {how long the incident lasted}

---

## Incident Classification

> [§8.1](../STANDARDS.md#81-incident-taxonomy): classify before writing. Classification supports pattern detection across incidents.

- [ ] Software defect (logic error, race condition, null handling)
- [ ] Data integrity (corruption, loss, stale state)
- [ ] Infrastructure failure (dependency outage, resource exhaustion)
- [ ] Security incident (unauthorized access, data exposure, credential misuse)
- [ ] Configuration error (wrong environment, missing variable, version mismatch)
- [ ] Behavioral regression (a change made things worse in a way tests did not catch)
- [ ] Other: {describe}

---

## Timeline

> [§8.2](../STANDARDS.md#82-post-mortem-format): chronological. Include detection time - if more than 10 minutes after the incident started, file a monitoring gap issue.

- HH:MM: {event}
- HH:MM: {detected - note how long after incident started}
- HH:MM: {resolved}

---

## Root Cause

> [§8.2](../STANDARDS.md#82-post-mortem-format): technical and specific. "Human error" is not a root cause - it is the symptom. What system condition made the error possible?

**Technical root cause:** {specific, not vague}

**Contributing factors:** {what made this possible - gaps in tests, monitoring, process, or design}

---

## Impact

> [§8.2](../STANDARDS.md#82-post-mortem-format): quantified. Who was affected, what was unavailable, for how long, what was the downstream consequence.

Who and what was affected, for how long, quantified where possible.

---

## Detection

> [§8.2](../STANDARDS.md#82-post-mortem-format): how was this discovered and how long after it started? If more than 10 minutes, file a monitoring gap issue immediately.

How was this discovered? How long after it started?

> If detection took more than 10 minutes: [ ] Monitoring gap issue filed - {issue ID}

---

## Resolution

> [§8.2](../STANDARDS.md#82-post-mortem-format): what specifically fixed it? Enough detail that a future responder could reproduce the resolution.

What fixed it?

---

## Systemic Issue Assessment

> [§8.7](../STANDARDS.md#87-a3-structured-problem-solving): determine whether this incident represents a systemic process problem or a one-time correctable failure.

Does this incident represent a systemic process problem (recurring pattern, process gap, delivery bottleneck) rather than a one-time correctable failure?

- [ ] **No** - one-time correctable failure. Proceed to Prevention work items below.
- [ ] **Yes** - systemic process problem. File an A3 before or alongside prevention work items. Template: [templates/a3.md](a3.md). A3 path: {link}

---

## Regression Cases

<a name="REQ-TPL-31"></a>
**REQ-TPL-31** `advisory` `continuous` `soft` `all`
§8.1: every incident must produce one or more regression cases that would have caught it earlier.

> [§8.1](../STANDARDS.md#81-incident-taxonomy): every incident must produce one or more regression cases that would have caught it earlier. Each regression case must be a [§2.2](../STANDARDS.md#22-work-item-discipline) work item with type=bug and discovered-from pointing to this post-mortem.

| Regression test description | Work Item ID | Test file path (when implemented) |
|---|---|---|
| {Test that would have caught this failure earlier} | {§2.2 work item ID} | {path to test file} |

> [ ] At least one regression case work item filed

---

## Prevention

<a name="REQ-TPL-32"></a>
**REQ-TPL-32** `advisory` `continuous` `soft` `all`
§8.2: each action must become a §2.2-compliant work item with type=prevention and discovered-from pointing to this post-mortem document path.

> [§8.2](../STANDARDS.md#82-post-mortem-format): each action must become a [§2.2](../STANDARDS.md#22-work-item-discipline)-compliant work item with type=prevention and discovered-from pointing to this post-mortem document path. Prevention actions without work item IDs do not get done.

| Action | Work Item ID | Status | Owner | Due |
|--------|-------------|--------|-------|-----|
| {Specific preventive action} | {§2.2 work item with type=prevention, discovered-from: [path to this post-mortem]} | Open / Closed | | |

---

## FMEA Update Check

> [§2.1 DESIGN](../STANDARDS.md#21-the-lifecycle): the FMEA is a living document. If this incident revealed a failure mode not present in an existing FMEA, update it.

- [ ] **Not applicable** - no FMEA exists for the affected component
- [ ] **No new failure modes** - existing FMEA already covers this failure
- [ ] **FMEA updated** - added missed failure mode to FMEA at: {path}

---

## Lessons Learned

> [§8.2](../STANDARDS.md#82-post-mortem-format): what assumption was wrong? What should every future implementor know? Add each lesson to the [lessons-learned registry](../STANDARDS.md#83-lessons-learned-registry) after this post-mortem is accepted.

What assumption was wrong?

What should every future implementor know?

> [ ] Each lesson added to the lessons-learned registry - per [§8.3](../STANDARDS.md#83-lessons-learned-registry)
> [ ] Reviewed for anti-pattern promotion - per [§8.4](../STANDARDS.md#84-anti-pattern-registry). If this failure pattern has appeared before, name it and add it to the anti-pattern registry.

---

## Security Supplement

<a name="REQ-TPL-33"></a>
**REQ-TPL-33** `advisory` `continuous` `soft` `all`
Complete this section if the incident involved data exposure, credential misuse, or unauthorized access - required by §8.2 and §5.10.

> Complete this section if the incident involved data exposure, credential misuse, or unauthorized access - required by [§8.2](../STANDARDS.md#82-post-mortem-format) and [§5.10](../STANDARDS.md#510-minimum-security-baseline).

- [ ] Applicable - complete below
- [ ] Not applicable

Containment steps taken:

Credential rotation performed:

Exposure window:

User-impact assessment:
