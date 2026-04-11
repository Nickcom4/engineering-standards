---
type: adr
id: ADR-017
title: Cynefin Scope Boundary in §1
status: Accepted
date: 2026-03-23
deciders: Gate authority (see standards-application.md)
implements:
  - REQ-4.2-01
  - REQ-4.1-01
---

# ADR-017: Cynefin Scope Boundary in §1


## Context

This standard applies prescriptive practices: a defined lifecycle, required artifacts, and quality gates that block progress when violated. These work well when the path from problem to solution is knowable through expert analysis before execution begins (the Complicated domain in the Cynefin framework). They can be counterproductive when applied to work where cause and effect are only apparent in retrospect and no amount of up-front analysis determines the correct approach (the Complex domain).

Without an explicit scope statement, practitioners face two failure modes: (1) rigidly applying the full lifecycle and all gates to genuinely exploratory work, which constrains the experimentation needed to discover what works; (2) dismissing the standard entirely for AI or novel-architecture work, losing the discipline that does apply to the Complicated elements of that work.

ADR-011 Gap 3 explicitly called for a scope statement clarifying what this standard provides and what contexts require supplementary approaches. Cynefin provides widely-used vocabulary for this distinction.

Cost of doing nothing: practitioners misapply the standard in both directions without a boundary they can reference.


## Decision

Add a new §1.5 Domain Applicability to STANDARDS.md stating that this standard is calibrated for the Complicated domain. The Complex domain is identified as outside the prescriptive scope of ESE's lifecycle and gates. Documentation and learning practices (session logs, post-mortems, lessons-learned registry) apply to Complex work. The full lifecycle and gates do not apply until work transitions from Complex to Complicated.

The section cites Snowden and Boone (2007) as the source vocabulary without replicating the full Cynefin model. Only two domains (Complicated and Complex) are described; the others are not included.


## Consequences

### Positive

- Practitioners have a named, citable basis for adapting ESE when facing genuinely novel problems
- ESE is not incorrectly dismissed for AI and ML work that has Complicated elements
- Satisfies ADR-011 Gap 3: scope statement clarifying what ESE provides and what lies beyond it
- Consistent with the existing ISO 9001 and CMMI scope framing already in the standard

### Negative

- The Complicated vs. Complex distinction requires practitioner judgment; it cannot be automated
- A practitioner could misuse the Complex-domain designation to avoid process discipline on work that is actually Complicated. No gate can prevent this - it relies on honest self-assessment.
- Adding a named external framework (Cynefin) to §1 requires maintaining the dependency entry in dependencies.md as the reference ages


## Alternatives Considered

### No scope statement

Rejected. ADR-011 Gap 3 identified this as a structural gap. Leaving practitioners without a scope boundary produces the two failure modes described in Context.

### Separate addendum rather than §1 core

Rejected per ADR-004. Addenda are for scenario-specific requirements that apply only to projects matching a particular context. A scope limitation that affects all ESE adopters belongs in §1, not in an addendum. Placing it in an addendum means it is read only by practitioners who self-identify as needing it, which is circular.

### Different vocabulary (exploratory vs. predictable) without citing Cynefin

Rejected per ADR-005 (Practical Over Theoretical). Cynefin is the most widely-used practitioner vocabulary for this domain distinction. Inventing alternative terminology would be less communicable and less likely to connect with practitioners' existing knowledge.

### Include all five Cynefin domains

Rejected. The AC for this work item explicitly requires that the section not replicate the full Cynefin model - scope statement only. The Complicated and Complex domains are the relevant ones for this standard's applicability question. Adding the full model adds complexity without proportionate value.


## Validation

**Pass condition:** At the first adoption review, practitioners are able to identify which parts of their work fall in the Complicated domain (full ESE applies) vs. the Complex domain (documentation practices apply, lifecycle adapted). No adopter has reported using the Complex-domain designation to avoid ESE requirements on work that was actually Complicated.

**Trigger:** First external adoption review after publication.

**Failure condition:** Adopters report either (a) that the scope statement is so broad it lets practitioners opt out of ESE requirements they should follow, or (b) that the scope statement is unclear and does not help them calibrate application.
