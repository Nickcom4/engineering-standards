---
type: adr
id: ADR-006
title: Move Inline Templates to Separate Example Files
status: Accepted
date: 2026-03-19
deciders: Gate authority (see standards-application.md)
implements:
  - REQ-4.2-01
  - REQ-4.1-01
---

# ADR-006: Move Inline Templates to Separate Example Files


## Context

STANDARDS.md contained three inline templates as code blocks: the component architecture template (Section 3.1), the ADR format (Section 4.2), and the post-mortem format (Section 8.2). A fourth template - the standards application template - already existed as a separate file (`starters/standards-application.md`).

The implicit distinction was: "blank forms to copy" live as separate files; "reference formats to follow" stay inline. This distinction was never documented and had two practical problems:

1. The inline templates violate the document's own cascade rule (Section 4.7): the Section 3.1 code block plus its "where applicable" list obscures the surrounding content. Readers wanting design principles (Section 3.2) have to scroll past substantial template content.

2. Teams creating their first architecture document or post-mortem want a blank file to copy, not a format to manually transcribe from a code block. The standards-application-template pattern is more usable.

## Decision

Move all three inline templates to `templates/` + `starters/` as standalone blank files (subsequently split per ADR-021 D9). Replace each inline code block with a brief summary of required sections and a link to the template file. Apply the same pattern consistently across all templates.

The "where applicable" considerations in Section 3.1 move into the architecture template file as clearly marked optional sections, keeping the standard's required-sections prose lean.

## Consequences

### Positive

- STANDARDS.md is leaner and easier to read through
- Templates are immediately usable (copy the file, fill in the blanks)
- Section 4.7 is now self-consistent - the standard applies its own cascade rule to itself
- All four templates follow the same pattern

### Negative

- Templates are now in two places conceptually: the standard describes the requirement, `templates/` or `starters/` provides the blank. Reader must follow a link to see the full format.
- Slight added friction for someone who wants to understand the format without creating a document

## Alternatives Considered

### Keep all templates inline

Rejected. Section 3.1 in particular obscures the flow of Section 3. The standard's own Section 4.7 says to cascade when a section grows to obscure surrounding context.

### Keep ADR template inline, move only architecture and post-mortem

Rejected on consistency grounds. Section 4.4 and 4.7 both require consistent treatment. All three are the same kind of thing.

## Validation

Three binary signals, each assessed at first external adoption review: (1) No issue filed requesting restoration of any inline template code block (if an adopter files such a request, the migration did not improve usability). (2) At least one adopter has copied a template file from templates/ or starters/ as their starting artifact (confirmed by any project that creates, for example, a standards-application.md using the template). (3) No broken-link issue filed for any template reference in STANDARDS.md (confirms the link-not-inline approach works for navigation). All three passing is the validation condition.
