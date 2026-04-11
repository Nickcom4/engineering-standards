---
type: adr
id: ADR-004
title: Ship First-Party Addenda for Common Scenarios
status: Accepted
date: 2026-03-19
deciders: Gate authority (see standards-application.md)
implements:
  - REQ-4.2-01
  - REQ-4.1-01
---

# ADR-004: Ship First-Party Addenda for Common Scenarios


## Context

ADR-002 establishes that scenario-specific content belongs in addenda, not STANDARDS.md. That leaves open the question of how addenda are delivered: do teams create them from scratch, or does the standard ship them?

The original approach was to prompt teams: "if you use event-driven architecture, create an addendum." This created two practical problems:

1. Teams are given no starting point. "Create an addendum for event-driven systems" gives no guidance on what the addendum should contain or what standard it should meet. Quality varies widely.

2. At enterprise scale, several of the deferred scenarios are not exceptions - they are defaults. Multi-service architectures, multi-team organizations, and containerized systems are the norm, not special cases. Deferring them with no content means the standard is incomplete for the context most enterprise teams operate in.

## Decision

Ship six first-party addenda in `docs/addenda/` covering the highest-value enterprise scenarios: multi-service architectures, multi-team organizations, web applications, containerized and orchestrated systems, AI and ML systems, and event-driven systems.

These addenda are part of the standard's repository, version-controlled alongside STANDARDS.md, and maintained on the same release cycle. They are not required for all projects - they apply only to projects that match the scenario. The standards application template identifies which addenda apply via a checklist.

Teams may create additional project-specific addenda for scenarios not covered (regulated industries, domain-specific requirements, etc.).

## Consequences

### Positive

- Teams get complete, consistent guidance for the most common enterprise scenarios
- Addenda are version-controlled and maintained - they evolve as external standards (WCAG, OWASP ASVS, etc.) evolve
- The principle/scenario boundary from ADR-002 is structurally enforced: STANDARDS.md grows only on principle-level decisions; addenda grow on scenario-specific ones

### Negative

- Each addendum must be maintained as its relevant external standards and best practices evolve
- The repository is larger; teams must evaluate which addenda apply to their context

## Alternatives Considered

### Defer all addenda to project teams

Rejected. Teams without a starting point produce inconsistent guidance or skip the addendum entirely. The scenario-specific gaps that ADR-002 deferred are then just... absent.

### Merge addendum content into STANDARDS.md with "if applicable" qualifiers

Rejected per ADR-002. The web application addendum alone adds 200+ lines relevant only to browser-rendered interfaces.

## Validation

At the first external adoption review: the adopter's standards-application.md records which addenda apply and at least one addendum was used to identify a requirement their project must meet. At the first adoption review: no significant enterprise scenario has been encountered that is absent from the six first-party addenda and would require a new one.
