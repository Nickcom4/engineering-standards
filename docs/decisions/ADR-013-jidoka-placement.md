---
type: adr
id: ADR-013
title: Jidoka Principle Placement in Section 6.4
date: 2026-03-22
status: Accepted
accepted: 2026-03-22
deciders: gate authority
tags: [testing, output-quality, lean, process-discipline]
implements:
  - REQ-4.2-01
  - REQ-4.1-01
---

# ADR-013: Jidoka Principle Placement in Section 6.4

## Context

ESE §5.5 requires a CI pipeline that fails visibly on any error. ESE §6.4 states that
no feature is done until it fully meets its acceptance criteria. Neither section states
the principle behind these requirements: when a defect is detected, work stops until
the defect is resolved. Without this principle named, practitioners may treat gate
failures as obstacles to manage around under schedule pressure rather than as mandatory
stops with shared authority.

The Jidoka principle (from Lean manufacturing, also called autonomation or
"stop-and-fix") establishes: no defect passes to the next stage; every worker and
every automated gate holds the authority and obligation to stop the line when a defect
is detected. In software delivery, this principle explains why CI gates exist, why
peer review is mandatory, and why schedule pressure does not override either.

**Cost of doing nothing:** Practitioners understand the mechanical requirements (CI
must pass, features must be complete) but not the underlying principle. Under pressure,
gates become obstacles to route around rather than stops with a reason.

## Decision

Add a Jidoka paragraph to **§6.4 No Half-Finished Features**.

**Placement rationale:** §6.4 governs output quality at stage boundaries. It already
states what the output state must be; the Jidoka paragraph states what to do when the
output is not yet in that state (stop and fix, not pass and defer). The two are
complementary within the same section. Expanding §6.4 is more coherent than splitting
the principle into a different lifecycle phase or a new standalone section.

**Content:** The paragraph names three things: (1) work stops when a defect is
detected, regardless of source; (2) passing defects downstream always costs more than
stopping; (3) authority to stop is shared by team members and automated gates alike.

## Consequences

**Positive:**
- The principle behind CI gates and peer review is named, not just the mechanical
  requirement
- Schedule pressure is explicitly addressed: it does not override the stop requirement
- Authority to stop is shared; practitioners know they hold it, not only tools
- The section becomes more complete: it now states both the required output state
  (§6.4 existing) and the required behavior when the output is not yet there (new)

**Negative:**
- §6.4 grows longer; a second paragraph may reduce the impact of either
- Readers scanning for testing requirements may miss a principle placed in §6

**Trade-off accepted:** The coherence benefit (principle and its consequence in one
section) outweighs the length cost. §6.4 remains a single focused topic.

## Alternatives Considered

**Add to §2.1 BUILD step:** Considered. The principle governs behavior during BUILD.
Rejected because the BUILD step description is currently one sentence; expanding it
significantly would unbalance the lifecycle table. The principle also applies at review,
deployment, and any other detection point, not only during initial build.

**Add as new §6.6:** Considered. A dedicated section makes the principle independently
referenceable. Rejected because it would create a one-paragraph section with no
sub-structure, and §6.4 already contains the closest conceptual home (the output state
requirement that Jidoka enforces).

**Add to §5.5 CI pipeline:** Rejected. §5.5 is about infrastructure requirements for
the pipeline. The Jidoka principle applies to human team members as well as automated
gates; placing it in §5.5 would imply it only applies to automated systems.

## Validation

At the first post-mortem filed after adoption: the post-mortem does not describe a defect knowingly carried forward under schedule pressure without a tracked work item (if it does, the Jidoka paragraph did not change the behavior it targets). At the first adoption review: at least one project referencing ESE has cited the Jidoka paragraph (or the stop-and-fix principle) as the basis for a team norm or a code review decision.
