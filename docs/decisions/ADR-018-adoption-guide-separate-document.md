---
type: adr
id: ADR-018
title: "Adoption Guide Lives in docs/adoption.md, Not Inline in STANDARDS.md"
status: Accepted
date: 2026-03-24
deciders: "Gate authority (see standards-application.md)"
implements:
  - REQ-4.2-01
  - REQ-4.1-01
---

# ADR-018: Adoption Guide Lives in docs/adoption.md, Not Inline in STANDARDS.md

## Context

[ADR-007](ADR-007-single-source-of-truth-standards-md.md) was written in March 2026 during initial release work. Its decision: "No separate getting-started guide exists." It argued that orientation content should stay inline in STANDARDS.md, citing the DRY principle: a separate guide would duplicate the template reference table already present throughout the standard.

ADR-007 included an explicit validation criterion: "If a separate guide is requested by any adopter, the introduction is insufficient and needs revision." That trigger fired. In v1.2.0, `docs/adoption.md` was created to cover: how to add the repo as a git submodule, what the first steps are, what artifacts a project produces, and how to adopt into a pre-existing codebase. The introduction alone was not sufficient.

After v1.2.0, ADR-007 was never updated. Its statement "No separate getting-started guide exists" is factually wrong. STANDARDS.md retained a "Two levels of documentation" block in its introduction that duplicates the content now in `docs/adoption.md`. This is the DRY violation ADR-007 was written to prevent, but caused by the ADR no longer matching reality.

**Cost of doing nothing:** ADR-007 is a documented decision that contradicts reality. Practitioners reading it get false information. The STANDARDS.md introduction carries redundant content that drifts from adoption.md over time.

## Decision

1. Supersede ADR-007 with this ADR. The correct structure is: `docs/adoption.md` is the standalone adoption guide. STANDARDS.md is the standard itself.

2. Remove the "Two levels of documentation" block from the STANDARDS.md introduction. This block duplicates adoption.md's "First Steps After Adoption" and "What Your Project Produces" sections. Replace it with a single sentence pointing to adoption.md for adoption guidance, retaining the existing "Where to start" pointer.

3. ADR-007 status is updated to "Superseded by ADR-018."

**What does not change:** the content of adoption.md; the "Where to start" line already present in STANDARDS.md; the "Every project that adopts these standards maintains its own application document" sentence; all other introduction content.

## Consequences

### Positive

- ADR-007 no longer contains a false statement
- STANDARDS.md introduction is shorter and contains no duplicate guidance
- Single source of truth for adoption guidance is adoption.md; STANDARDS.md is the standard
- DRY is restored: adoption guidance exists in one place

### Negative

- STANDARDS.md is slightly less self-contained; a first-time reader must follow a link to adoption.md for setup guidance (this was already true given the "Where to start" pointer; removing the "Two levels" block changes nothing material for that reader)
- New contributors who do not read the ADR history will not see that this was once inline

## Alternatives Considered

### Keep adoption guidance inline in STANDARDS.md, merge adoption.md back

Rejected. adoption.md has grown to seven sections covering submodule setup, maturity model positioning, pre-existing project guidance, and a feedback channel. Merging this back into STANDARDS.md would make the introduction carry adoption-guide weight, making the standard harder to read end-to-end for practitioners already familiar with setup.

### Keep both: leave "Two levels" in STANDARDS.md and keep adoption.md

Rejected. This is the current state and it is the problem: two sources of the same truth that will drift from each other. ADR-007's original DRY rationale is correct; the mistake was not updating the ADR when the separate guide was created.

### Create a getting-started section in STANDARDS.md, deprecate adoption.md

Rejected. The same content in the same place under a different name is not a fix. adoption.md as a separate file is easier to link to from README.md and external documentation.

## Validation

**Pass condition:** The STANDARDS.md introduction successfully orients a first-time reader to adoption.md (they find what they need in adoption.md without requesting additional guidance), and adoption.md is the only location for adoption step-by-step instructions.

**Trigger:** First external adoption review after this ADR is accepted.

**Failure condition:** An adopter files an issue or requests guidance that would have been answered by the removed "Two levels" block and that is not present in adoption.md. If this occurs, the content should be added to adoption.md, not restored to STANDARDS.md.
