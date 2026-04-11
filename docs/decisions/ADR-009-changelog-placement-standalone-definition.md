---
type: adr
id: ADR-009
title: Define Standalone Document and Reorder §4.3 Changelog Placement Rules
status: Accepted
date: 2026-03-21
deciders: Gate authority (see standards-application.md)
implements:
  - REQ-4.2-01
  - REQ-4.3-01
  - REQ-4.3-02
  - REQ-4.3-03
---

# ADR-009: Define "Standalone Document" and Reorder §4.3 Changelog Placement Rules

---

## Context

§4.3 states two changelog placement rules - standalone documents carry an
inline changelog; repositories use CHANGELOG.md at the root. The term
"standalone document" was undefined, causing practitioners to apply inline
changelogs to individual files inside git repositories (the wrong behavior).

Observed misinterpretation in multiple sessions: `prd.md`, `capabilities.md`,
and other files inside repos were given inline changelogs instead of using
the repo-level CHANGELOG.md.

Additionally, the rules were stated in the wrong order: the standalone rule
appeared first, making it feel like the default case. The repo rule is the
common case for all practitioners working in a git repository.

Cost of doing nothing: practitioners continue applying inline changelogs to
repo files, producing inconsistent documentation across projects.

---

## Decision

Three changes to §4.3:

1. **Add definition**: "A standalone document is one distributed and consumed
   independently - not as part of a repository alongside other files and code.
   Examples: an RFC, a specification distributed as a single file. A document
   that lives in a git repository alongside other files is not standalone,
   regardless of its length or importance."

2. **Reorder**: Repo-level rule stated first (common case). Standalone rule
   stated second (exception).

3. **Add example**: "If you are unsure which applies: if your document lives
   in a git repository, use CHANGELOG.md at the repo root."


---

## Consequences

**Positive:**
- Eliminates the misinterpretation that caused per-file inline changelogs
- Repo rule is now prominent as the common case
- Definition makes the boundary testable: "is this in a git repo?" is a
  binary question

**Negative:**
- Minor text addition to §4.3 - reviewed and approved before merge

---

## Alternatives Considered

**Add an example only, no definition**: Rejected. An example without a
definition leaves the boundary implicit and subject to re-interpretation.

**Add definition only, no reorder**: Rejected. Stating the exception before
the common case would persist even with a definition.

---

## Validation

Practitioners apply inline changelogs only to genuinely standalone documents
(distributed independently, not part of a repo). Files inside any repo use
CHANGELOG.md at the root without exception.
