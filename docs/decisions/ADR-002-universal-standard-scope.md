---
type: adr
id: ADR-002
title: Universal Standard Scope - Principles Only, Addenda for Scenarios
status: Accepted
date: 2026-03-19
deciders: Gate authority (see standards-application.md)
implements:
  - REQ-4.2-01
  - REQ-4.1-01
---

# ADR-002: Universal Standard Scope - Principles Only, Addenda for Scenarios


## Context

A universal engineering standard faces a defining tension: the more scenarios it covers, the less universal it becomes. Many legitimate engineering requirements were evaluated for inclusion - AI-specific guidance, container standards, multi-team coordination patterns, browser-specific requirements. Each is a real engineering concern. But a standard that covers all of them is not universal; it is a collection of technology-specific checklists that most teams will read as partially applicable.

Without a clear rule for what belongs in the standard versus what belongs in an addendum, the standard grows to cover every technology, architecture pattern, and team structure - becoming unmaintainable and unreadable for any project that does not use all of them.

## Decision

STANDARDS.md contains only **principles that apply regardless of technology stack, team size, or project domain.** This document is complete for the principles it establishes. It is not exhaustive for every possible scenario, and it is not intended to be.

**What belongs in STANDARDS.md:**
Any requirement that a competent team on any project - a solo developer building a CLI tool, a large organization running distributed services - should follow without qualification.

**What belongs in a scenario-specific addendum:**
Any requirement that only applies when a specific technology, architecture pattern, or organizational structure is in use.

**On threshold numbers:** Technology-specific threshold targets (Lighthouse scores, WCAG conformance levels, CVSSv3 cutoffs) belong in the standards application document, because the right target varies by project context. Universal practice guidance numbers that apply regardless of technology - such as when a repeated task becomes toil - may remain in STANDARDS.md when they are evidence-backed and universally applicable.

**AI content as the prime example:** AI-specific guidance - hallucination containment, autonomy boundaries, evaluation harnesses, model cards, data governance - is legitimate engineering content. But it only applies to projects that build on or serve machine learning models. Including it in STANDARDS.md signals that the standard is technology-specific and adds noise for teams that have no AI component. AI content is excluded from STANDARDS.md and provided as a first-party addendum (`docs/addenda/ai-ml.md`).

For how scenario-specific content is delivered to teams, see ADR-004.

## Consequences

### Positive

- STANDARDS.md is readable and applicable to any project without qualification
- Scenario-specific concerns are not lost - they live in first-party addenda and the standards application template
- Clear rule for contributors deciding whether to add something

### Negative

- Understanding the full requirements for a complex project requires reading STANDARDS.md plus any applicable addenda
- The line between principle-level and scenario-specific is sometimes a judgment call and requires applying the universality test explicitly

## Alternatives Considered

### Include everything with "if applicable" qualifiers

Rejected. Conditional requirements are not requirements. A standard full of "if you're using containers..." or "if you have multiple teams..." is not a standard - it is a checklist that readers selectively apply, which means the gates do not actually block.

### No scenario-specific content anywhere

Rejected. Enterprise teams deploying containers, coordinating across teams, and building AI systems need real guidance. "Apply the universal principles and figure out the rest yourself" is not adequate. First-party addenda fill this gap without contaminating the universal standard.

## Validation

At the first external adoption review: no adopter has encountered a requirement that applies universally to their project but is absent from STANDARDS.md (confirmed by reviewing their standards-application.md gap table). At the first adoption review: no addendum requirement has been flagged as impractical and retroactively removed without going through ADR-005's practicality test.
