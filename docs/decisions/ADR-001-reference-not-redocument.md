---
type: adr
id: ADR-001
title: Reference External Standards Rather Than Redocument Them
status: Accepted
date: 2026-03-19
deciders: Gate authority (see standards-application.md)
implements:
  - REQ-4.2-01
  - REQ-4.1-01
---

# ADR-001: Reference External Standards Rather Than Redocument Them


## Context

The standard references OWASP ASVS, DORA, Google SRE, Twelve-Factor App, WCAG, OpenTelemetry, and others. Re-documenting these standards inline duplicates authoritative external sources and creates a maintenance liability: when the external standard updates, the inline copy becomes silently stale without any signal that it has diverged.

## Decision

Reference each external standard by name, version, and URL. State only the project-specific application or emphasis. Track versions in dependencies.md with review cadence.

## Consequences

### Positive

- No duplicate maintenance when external standards update
- Reader follows the authoritative source for full detail
- The standard stays focused on what is unique to this context

### Negative

- Reader must follow links for full understanding of some sections
- Offline reading requires pre-fetching referenced documents

## Alternatives Considered

### Inline all referenced standards

Rejected. The OWASP section alone would add hundreds of lines. Maintenance burden is unsustainable.

### Reference without version tracking

Rejected. Without pinned versions, changes in external standards go undetected. dependencies.md solves this.

## Validation

Enforcement mechanism: the annual review protocol is documented in dependencies.md header with a "Last annual review" date field. The compliance review in standards-application.md covers this file when conducted in January. Binary pass condition: the Last Reviewed dates in dependencies.md are updated at least once per calendar year, and no external reference URL is more than 13 months old without a review entry. A Last Reviewed date older than 13 months for any entry signals the review cadence was missed.
