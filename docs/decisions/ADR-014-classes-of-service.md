---
type: adr
id: ADR-014
title: Classes of Service in Section 2.2
date: 2026-03-22
status: Accepted
accepted: 2026-03-22
deciders: gate authority
tags: [methodology, flow, lean, work-item-discipline]
implements:
  - REQ-4.2-01
  - REQ-2.2-17
---

# ADR-014: Classes of Service in Section 2.2

## Context

ESE §2.2 requires work items to have "priority based on user impact." It does not
define what this means or how to translate it into flow decisions. ESE §8.1 defines
P0-P4 severity levels for incident classification. In practice, P0-P4 severity labels
are also applied to work items in development queues, conflating two distinct axes:

- **Severity** (§8.1): how bad is this incident? Measures impact of a failure that has
  already occurred. Drives incident response pace.
- **Cost of delay**: how expensive is waiting to start this work? Drives flow policy:
  whether the work interrupts other work, needs countdown tracking, moves in order, or
  requires reserved capacity.

These axes are orthogonal. A P2 severity bug with a client commitment deadline has a
fixed-date cost-of-delay profile (binary catastrophe at the deadline), and severity
alone does not surface this. A P0 production outage has expedite cost of delay
(immediately accelerating), and severity alone does not specify that WIP limits should
be suspended.

The result: teams use severity labels for scheduling decisions they are not designed to
support, and work with dramatically different urgency profiles (expedite vs. intangible)
sits in the same queue under the same policies.

**Cost of doing nothing:** Work with different cost-of-delay profiles is treated
identically except by severity. Fixed-date work misses deadlines because countdown
tracking is not required. Intangible work is perpetually deprioritized because no
capacity is reserved. Expedite work waits in queues because teams do not know to
suspend WIP limits.

## Decision

Add classes of service to **§2.2 Work Item Discipline** as a paragraph following the
work item attribute list. Add a brief reference in §2.6 on how expedite and intangible
classes interact with WIP limits.

Four classes cover most software delivery work:

1. **Expedite:** immediate start, suspends WIP limits, one at a time
2. **Fixed-date:** countdown tracking, escalation when buffer exhausted
3. **Standard:** FIFO within class, respects WIP limits
4. **Intangible:** reserved capacity, never allowed to starve

The paragraph explicitly distinguishes classes of service from P0-P4 severity (§8.1).
P0-P4 remains for incident classification. A mapping note explains the relationship:
P0/P1 incidents typically map to expedite class; severity and class of service are
generally set independently, with the convention that P0/P1 incidents should be
classified expedite rather than standard or intangible.

**ESE framing:** Principle stated: different cost-of-delay profiles require different
flow policies. The specific percentages of reserved capacity for intangible work, and
the specific WIP limit suspension rules for expedite work, are project decisions
documented in each project's standards-application document.

## Consequences

**Positive:**
- Work items have a named, actionable flow policy in addition to a severity label
- Fixed-date work is tracked against its deadline by requirement, not by habit
- Intangible work cannot be starved; reserved capacity is required
- Teams understand why WIP limits behave differently for expedite work
- The P0-P4 / class-of-service distinction is explicit, ending conflation

**Negative:**
- Work item creation requires one additional classification decision
- Teams unfamiliar with cost-of-delay thinking need to learn the concept
- Over-using expedite class is a real risk; the "one at a time" constraint is the
  only backstop

**Trade-off accepted:** The classification cost is low; the benefit of correct flow
behavior per work type is high. The single-expedite constraint prevents abuse.

## Alternatives Considered

**Add to §8.1 incident taxonomy:** Rejected. §8.1 governs incident response. Classes
of service apply to all work items, not only incidents. Placing CoS in §8.1 would imply
it is incident-specific.

**Add to §2.6 Flow and Batch Size:** Considered. §2.6 covers WIP limits and batch size,
which interact with CoS. Rejected as primary placement because CoS is a property of
individual work items (defined at creation time) while §2.6 governs process-level flow
behavior. Work item attributes belong in §2.2.

**Add as new §2.9:** Considered. A dedicated section would allow more depth. Rejected
because the concept is tightly coupled to §2.2 work item attributes and §2.6 flow
behavior; splitting it into a third section adds navigation cost without adding clarity.
A paragraph in §2.2 plus a cross-reference in §2.6 achieves the same coverage.

**Redefine P0-P4 as classes of service:** Rejected. P0-P4 is already in use across
projects and tooling. Redefining existing terms creates migration cost and confusion
during the transition. Adding classes of service as an independent axis preserves
backward compatibility.

## Validation

At the first adoption review: at least one project using ESE has documented its reserved capacity percentage for intangible work in its standards-application document. At the first fixed-date work item missed after adoption: the post-mortem or retrospective note confirms whether countdown tracking was in place (if countdown tracking absence is cited as a contributing factor, that is a negative signal for this change).
