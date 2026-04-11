---
type: adr
id: ADR-003
title: Order Sections by Work Phase
status: Accepted
date: 2026-03-19
deciders: Gate authority (see standards-application.md)
implements:
  - REQ-4.2-01
  - REQ-4.1-01
---

# ADR-003: Order Sections by Work Phase


## Context

Ordering sections by topic familiarity - methodology before scope, testing before architecture - means practitioners encounter build and test rules before understanding what they are building or why. Scope and product discipline is logically first: you define what you are building before deciding how to build or verify it. A standard ordered by familiarity trains practitioners to jump to implementation before establishing scope.

## Decision

Order sections to follow the chronological phase of work:

1. Scope (define what before how)
2. Methodology (the lifecycle)
3. Architecture (design before build)
4. Documentation (runs alongside all work)
5. Code (build and deploy)
6. Testing (verify)
7. Monitoring (operate)
8. Failure (learn)
9. Technology (adopt new tools)
10. Handoff (pass to others)

## Consequences

### Positive

- A new reader encounters requirements in the order they will apply them
- Scope comes first, preventing "build first, ask questions later"

### Negative

- Some readers want to jump directly to a section by topic. The ToC handles this.

## Alternatives Considered

### Alphabetical order

Rejected. Destroys logical flow entirely.

### Original topic-familiarity order

Rejected. Scope at the end meant the most important discipline was encountered last.

## Validation

After the first three external adoption reviews of ESE: no reviewer has filed an issue requesting a section reordering or reported confusion about why a section appears where it does. A single filed reordering issue signals a reconsideration is needed. Zero such issues is the pass condition. Trigger: after each external adoption review, check whether any issues reference section ordering.
