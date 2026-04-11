---
type: adr
id: ADR-007
title: Single Source of Truth - Orientation Content in STANDARDS.md
status: Superseded by ADR-018
date: 2026-03-19
deciders: Gate authority (see standards-application.md)
implements:
  - REQ-4.2-01
  - REQ-4.1-01
---

# ADR-007: Single Source of Truth - Orientation Content in STANDARDS.md

> **Superseded by [ADR-018](ADR-018-adoption-guide-separate-document.md) (2026-03-24).** ADR-007's validation criterion fired: the STANDARDS.md introduction alone was insufficient, and `docs/adoption.md` was created in v1.2.0. ADR-007's statement "No separate getting-started guide exists" is therefore factually wrong. ADR-018 documents the correct structure and supersedes this decision. The history below is preserved for context.

## Context

When adding orientation content to ESE - how to apply the standard, document flow for new vs. pre-existing projects, gate authority - the question was where it should live.

Two options were evaluated. The wrong option was drafted first: a separate `docs/getting-started.md`. On review it violated DRY: it contained a consolidated template reference table that duplicated template links already appearing inline throughout STANDARDS.md. When a template is added or changed, both files would require updating. After removing that duplication, the guide's remaining unique content (new vs. pre-existing adoption paths, gate authority clarification, scope-matched documentation guidance) was not large enough to justify a separate document.

The correct answer is the one that is consistent with ESE's own principles: single source of truth.

## Decision

STANDARDS.md is the single source of truth for all ESE content, including orientation. No separate getting-started guide exists.

Orientation content is folded into STANDARDS.md directly:
- Adoption guidance (new project, pre-existing project, scope-matched documentation) lives in the introduction
- Gate authority clarification lives in [§1.4](../../STANDARDS.md#14-project-first-principles), item 4
- Template links appear inline at the section that requires each template
- The `templates/` and `starters/` directories are the authoritative list of available templates (split per ADR-021 D9; was `examples/`)

## Consequences

### Positive

- Single source of truth - one document to read, one to maintain, no drift
- DRY: template links exist exactly once, at the point of requirement
- Orientation is encountered in context, not in a prerequisite document a reader might skip
- Consistent with the principles ESE itself establishes

### Negative

- STANDARDS.md carries the full weight of both orientation and reference. The introduction must be clear enough to orient a first-time reader without a separate guide to supplement it.
- No consolidated template table. Readers wanting an overview of all templates navigate `templates/` or `starters/` directly.

## Alternatives Considered

### Separate `docs/getting-started.md`

Drafted and rejected. Contained a template reference table that duplicated inline links already present throughout STANDARDS.md - a direct DRY violation. Removing the duplication left a thin document whose remaining unique content fit naturally into STANDARDS.md's intro and §1.4. The maintenance cost of keeping two documents in sync outweighed any navigational benefit.

## Validation

At first external adoption review: the adopter completed standards-application.md setup without requesting a separate guide or asking what to start with (meaning the STANDARDS.md introduction provided sufficient orientation). Binary pass: adopter reached a working standards-application.md without escalating "where do I start?" If a separate guide is requested by any adopter, the introduction is insufficient and needs revision. Trigger: after first external adoption, review whether any support questions were about orientation.
