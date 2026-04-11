---
type: adr
id: ADR-010
title: Archived Document Handling Convention
status: Accepted
date: 2026-03-21
deciders: Gate authority (see standards-application.md)
implements:
  - REQ-4.2-01
  - REQ-4.1-01
---

# ADR-010: Archived Document Handling - docs/archive/ Convention

---

## Context

ESE had no guidance on what to do when a document is superseded. The §2.1
lifecycle ends at CLOSE for work items but does not address the document
lifecycle step of superseding or archiving. The repo-structure-template.md
had no archive directory.

Current ad-hoc practice: add frontmatter `status: archived` and leave files
in place alongside active documents. This makes navigation difficult - a
reader cannot distinguish active from superseded documents without opening
each file.

ESE §2.3 (New Person Readiness, in Definition of Done) asks "could someone find this feature?" -
co-located active and archived documents make this harder to satisfy.

Cost of doing nothing: navigation degrades as projects accumulate superseded
documents with no consistent handling.

---

## Decision

Three additive changes:

1. **repo-structure-template.md**: Add `docs/archive/` directory with naming
   convention `{original-name}-archived-{YYYY-MM-DD}.md`.

2. **§2.1 DOCUMENT step**: Add note - when a document is superseded, move it
   to `docs/archive/`, apply the three-field frontmatter schema, and update
   all cross-references to point to the new document.

3. **§4.1**: Add archived document frontmatter schema:
   ```yaml
   status: archived
   superseded-by: {relative path to active document}
   date-archived: {YYYY-MM-DD}
   ```


---

## Consequences

**Positive:**
- Active and archived documents are visually separated at directory level
- New readers can navigate docs/ without opening every file
- Naming convention preserves searchability (grep for original name still works)
- Frontmatter schema is machine-readable - tooling can detect archived docs

**Negative:**
- Projects with existing archived files in non-archive locations need
  migration (separate work item per project, pre-existing debt, does not block
  current work)
- Adds a directory to maintain

---

## Alternatives Considered

**Per-directory archive subdirectories** (e.g., `docs/product/archive/`,
`docs/architecture/archive/`): Rejected. A single `docs/archive/` is simpler
and more discoverable - one place to look rather than checking every
subdirectory.

**Add an ARCHIVE lifecycle step to §2.1**: Rejected. The lifecycle describes
work items, not documents. A note in the DOCUMENT step is sufficient and
less disruptive to the lifecycle flow.

---

## Validation

Practitioners moving superseded documents consistently use `docs/archive/`
with the three-field frontmatter schema. No active and archived documents
co-located in the same directory.
