---
type: adr
id: ADR-020
title: "Dissolve §10 Into §2-§5, De-duplicate §2.6, Relocate §7.7 Context"
status: Accepted
date: 2026-03-24
deciders: "Gate authority (see standards-application.md)"
implements:
  - REQ-4.2-01
  - REQ-4.1-01
---

# ADR-020: Dissolve §10, De-duplicate §2.6, Relocate §7.7 Context

## Context

§10 (Implementation and Handoff) contains five subsections. Three overlap with earlier sections; two contain unique requirements placed after monitoring and failure learning, where practitioners encounter them too late.

- §10.2 (Required Before Any Merge) and §5.1 (Version Control Discipline) both contain pre-merge checklists. They are not identical: §5.1 is an author-side gate ("did I pass tests, get review, push?") while §10.2 is a reader-side readability test ("can a future implementor set up, understand, deploy using only the docs?"). Both are valuable, but a practitioner encountering two pre-merge sections does not know which to consult.
- §10.3 (Handoff Checklist) organizes requirements by domain (Code, Documentation, Infrastructure, Testing, Security). §2.3 (Definition of Done) covers the same requirements as a flat checklist. The domain-organized format is useful for verification; the flat format is useful for close gates.
- §10.4 (New Person Readiness Test) is a verification criterion, not a lifecycle phase. It belongs in §2.3 as a DoD item.
- §10.1 (Documentation Layers) and §10.5 (Minimum Security Baseline) are unique requirements currently encountered after §7 Monitoring and §8 Failure Learning. Both should apply before BUILD.

Separately, §2.6 contains a TIMWOODS waste taxonomy table duplicated in the continuous-improvement addendum. And §7.7 (Measurement Integrity) contains 320 words of statistical process control context around 3 gate sentences.

§9 (Technology Adoption) was considered for relocation but rejected: technology adoption is a cross-cutting concern that occurs at project start, during maintenance, and during incident response. It is not a phase. Moving it would renumber §4-§8, breaking every external reference for a marginal readability improvement the ToC already provides.

## Decision

**1. Dissolve §10.** No section renumbering; §1-§9 keep their numbers.

- §10.1 (Documentation Layers) moves to §4 (Documentation Standards) as a new subsection.
- §10.2 (Required Before Any Merge) merges into §5.1 as an additional paragraph preserving the readability-test framing ("a future implementor must be able to..."). One section, two perspectives.
- §10.3 (Handoff Checklist) merges into §2.3 as a domain-organized expansion of the Definition of Done. The five domain headings (Code, Documentation, Infrastructure, Testing, Security) become a named "Handoff Verification" subsection within §2.3, providing the domain-organized view that the flat DoD checklist lacks.
- §10.4 (New Person Readiness Test) becomes a DoD checklist item in §2.3 with a brief inline description of the five questions.
- §10.5 (Minimum Security Baseline) moves to §5 as a new subsection (§5.10).

**2. De-duplicate §2.6.** Replace the TIMWOODS table with a one-sentence pointer to the continuous-improvement addendum.

**3. Relocate §7.7 context.** Move the statistical process control explanation to docs/background.md. The three gate sentences remain inline: validate before trusting, distinguish signal from noise, measure capability.

**Not changed:** §9 position (cross-cutting, not a phase). PDCA bridge in §2.1 (64 words, not worth a cross-reference). Deming SoPK in §8.2 (inline context helps practitioners resist blame instinct). Cynefin in §1.5 (keep core paragraph, move only the reference citation sentence).

## Consequences

### Positive

- One pre-merge section (§5.1) with both author-gate and reader-readability perspectives
- One DoD (§2.3) with both flat checklist and domain-organized verification
- Security baseline and documentation layers appear before BUILD
- TIMWOODS duplication eliminated
- §1-§9 numbering preserved; no external reference breakage; minor version, not v2.0.0

### Negative

- §10 content distributed across four sections; a reader looking for "handoff" must now check §2.3, §4, and §5
- docs/background.md absorbs ~320 words of §7.7 context

## Alternatives Considered

### Relocate §9 and renumber §4-§8

Rejected. Technology adoption is cross-cutting, not a phase. The renumbering cost (updating 30+ files, all addenda, all templates, all external adopter references) exceeds the readability benefit. The ToC handles section discovery.

### Delete §10.3 entirely

Rejected. §10.3's domain-organized format (Code, Documentation, Infrastructure, Testing, Security) serves a verification purpose that §2.3's flat list does not. Merge, don't delete.

### Leave as-is

Rejected. Two pre-merge checklists, a handoff checklist redundant with the DoD, and security requirements appearing after monitoring are structural defects, not style preferences.

## Validation

**Pass condition:** Zero requirements appear in two places with different wording. Every practitioner-facing requirement in §10 is present in its new location, verified by diff.

**Trigger:** First compliance review after the restructure.

**Failure condition:** A requirement present in v1.x §10 is absent from the restructured version, or a practitioner cannot find a handoff-related requirement without consulting the ADR.
