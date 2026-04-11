---
type: adr
id: ADR-005
title: Practical Over Theoretical
status: Accepted
date: 2026-03-19
deciders: Gate authority (see standards-application.md)
implements:
  - REQ-4.2-01
  - REQ-4.1-01
---

# ADR-005: Practical Over Theoretical


## Context

Some engineering requirements sound rigorous but would not be followed in practice. Examples: "review dependencies immediately when a referenced standard releases a major version" (nobody monitors 14 standards for releases), "write a post-mortem for every significant error" (with "significant" undefined, either everything gets a post-mortem or nothing does), and multi-step numbered processes for simple tasks (teams will just do the task).

A standard that contains requirements people ignore trains them to ignore requirements.

## Decision

Every requirement in the standard must pass a practicality test: **would a competent team of any size actually do this consistently?** If not, either soften it to what they would do, tie it to a specific trigger (severity level, risk level, cadence), or remove it.

Specific applications of this principle:
- Absolute requirements ("every", "always", "never") are reserved for things that genuinely have no exceptions
- Cadence-based reviews (annual, per-cycle) replace "immediately" triggers that depend on external awareness
- Post-mortems tied to severity levels, not undefined "significance"
- Architecture checklist items qualified with "where applicable" rather than required for every component regardless of complexity
- Two-sentence sections merged into the relevant checklist rather than standing alone

## Consequences

### Positive

- Requirements that exist in the standard are requirements that get followed
- No training effect of "we skip that one"
- The standard stays credible with practitioners

### Negative

- Some edge cases may not be caught between annual reviews (e.g., a critical OWASP release mid-year). Mitigation: the annual review is the minimum; teams aware of a change can act sooner.

## Alternatives Considered

### Keep rigorous requirements and rely on team discipline

Rejected. Requirements that are routinely skipped erode trust in the entire standard. If a team learns that some requirements are safely ignorable, every requirement becomes negotiable.

### Remove all specific guidance and state only abstract principles

Rejected. A standard that says "be practical" without concrete examples provides no actionable guidance. The standard needs enough specificity to be useful, bounded by the practicality test.

## Validation

At the first internal compliance review after a new requirement is added: no requirement was added that a competent team on a small project would not actually follow consistently (confirmed by checking that the requirement passes the practicality test in the Decision section). At the first adoption review: no adopter has reported maintaining an informal list of requirements they routinely skip.
