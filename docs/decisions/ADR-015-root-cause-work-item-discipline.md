---
type: adr
id: ADR-015
title: Root Cause Identification in Work Item Discipline
status: Accepted
date: 2026-03-22
deciders: gate authority
section: "§2.2 Work Item Discipline"
implements:
  - REQ-4.2-01
  - REQ-2.2-02
---

# ADR-015: Root Cause Identification in Work Item Discipline

## Context

Work item backlogs frequently contain items that address symptoms without linking to the root cause being fixed. When a symptom recurs (which it will if the root cause is unresolved), a new symptom item is filed without connection to prior work. Over time, the backlog fills with independent-looking items that are all caused by the same underlying condition. Resolution of one item provides no signal that the root cause is handled.

ESE §2.2 already requires linked dependencies and a link to the discovering work item. Neither requirement explicitly forces practitioners to distinguish between root-cause fixes and symptom fixes. A team following the letter of §2.2 can file a well-formed symptom fix that links to nothing causal.

The cost of not requiring this distinction: recurrence patterns are invisible until multiple sessions produce the same fix; root-cause items are never filed; practitioners waste time on repeated symptom resolution.

**Constraint:** The requirement must not impose root cause analysis on every work item. Most bugs are their own root cause. The requirement applies when a practitioner knowingly addresses only a symptom; that choice must be made explicit and linked.

**Cost of doing nothing:** The recurrence pattern continues undetected. Each session re-discovers the same symptoms and files the same fixes.

## Decision

Add a **Root cause identification** requirement to §2.2 Work Item Discipline. A work item must either:

- Address a root cause directly (no annotation needed; most items satisfy this), or
- Explicitly identify itself as a symptom fix by labeling it as such and linking to the root-cause work item as a dependency.

When the root cause is unknown, the work item is scoped as an investigation with a root cause identification as its deliverable, not a fix.

This does not add a new field to every work item. It adds a required discipline when a practitioner chooses to fix a symptom without fixing the cause.

## Consequences

**Positive:**
- Recurrence patterns become visible: a series of symptom-fix items linked to one root-cause item shows accumulation
- Root-cause items are filed when discovered, not forgotten
- Practitioners are prompted to ask "is this the root cause or a symptom?" at item creation
- No overhead for items that are already root-cause fixes (the common case)

**Negative:**
- Requires practitioners to make a judgment call at creation time about root cause vs. symptom
- Some root causes are genuinely unknown at creation time (the investigation pattern handles this, but it requires a second work item when the root cause is found)

## Alternatives Considered

**Require root cause analysis on every work item:** Rejected. Most work items are root-cause fixes. Requiring analysis on all items adds overhead without value. The requirement is needed only when the practitioner is knowingly deferring root cause resolution.

**Add root cause as a required seventh field on every work item:** Rejected for the same reason. Optional-but-labeled is correct: most items need no annotation; only explicit symptom-fix deferrals require the link.

**Post-mortem requirement only (§8.2):** Rejected. §8.2 post-mortems are for significant incidents. The root-cause linking requirement applies to all work items, including minor bugs and one-off fixes that would not trigger a post-mortem. The gap is at §2.2 (item creation), not §8.2 (incident response).

## Validation

- After 5 sessions, check: are symptom-fix items filed with root-cause links? Are root-cause investigation items being filed when root cause is unknown?
- Indicator of success: a recurring symptom produces a traceable chain of symptom items linked to one open root-cause item, rather than a series of disconnected closures.
