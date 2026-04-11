---
type: adr
id: ADR-011
title: Four Structural Improvements Toward ISO-Equivalent Rigor
status: Accepted
date: 2026-03-21
deciders: Gate authority (see standards-application.md)
implements:
  - REQ-4.2-01
  - REQ-4.1-01
---

# ADR-011: Four Structural Improvements Toward ISO-Equivalent Rigor

---

## Context

This engineering standard was assessed against ISO 9001 (Quality Management
Systems), ISO 27001 (Information Security Management Systems), NIST AI RMF
1.0, and SOC 2 to determine whether a separate "specifications package"
should be generated, and to identify structural gaps between this standard
and mature standards frameworks.

**Finding:** This standard is a hybrid - part software delivery methodology,
part auditable standard. It is well-designed for its primary context.
Comparison with ISO frameworks revealed four structural gaps that prevent
it from achieving ISO-equivalent rigor.

Cost of doing nothing: compliance drift goes undetected between reviews;
practitioners cannot demonstrate compliance to external parties; security
and testing requirements are scattered across sections making audits slow
and incomplete.

---

## Decision

**No separate auto-generated specifications package.** The enhanced
`standards-application-template.md` (Gap 1 below) is the correct vehicle.

**Four structural gaps to close:**

### Gap 1: Evidence-Based Compliance Tracking - IMPLEMENTED

Current `standards-application-template.md` tracked gaps (what is missing).
ISO 27001's Statement of Applicability tracks evidence (what exists and
proves compliance). Added Evidence and Last verified columns to all five
compliance-tracking tables.

### Gap 2: Periodic Review Cadence - IMPLEMENTED

No defined audit frequency existed. ISO 9001 §9.2 requires internal audits
on a planned schedule. Added compliance review date fields to
standards-application-template.md and created compliance-review-template.md.

### Gap 3: Scope Statement - IMPLEMENTED

This standard does not state what it covers and what contexts require
supplementary frameworks. Practitioners may believe compliance makes a
project "audit-ready" for external certification when it does not. A scope
statement should be added to §1 clarifying what this standard provides and
what it does not (external certification, formal risk registers, physical
security controls, etc.).

### Gap 4: Domain-Organized Requirement Index - IMPLEMENTED

Requirements are organized by lifecycle phase. A practitioner auditing
security compliance must read §2.5, §5.8, §6.5, §5.10, and each applicable
addendum - there is no single-location view. A `docs/requirement-index.md`
organized by domain (security, documentation, testing, monitoring,
methodology) would make compliance checking faster and more complete.
Analogous to ISO 27001 Annex A.

---

## Consequences

**Positive:**
- Evidence-based tracking makes compliance demonstrable, not just trackable
- Periodic review catches drift that was previously invisible
- Scope statement (when added) prevents overclaiming compliance
- Domain index (when added) makes compliance checking faster

**Negative:**
- standards-application-template.md is more complex (evidence columns)
- Periodic review adds operational overhead per project
- Requirement index must be maintained when STANDARDS.md changes

---

## Alternatives Considered

**Auto-generated specifications package**: Rejected. Cannot generate
project-specific content (ADRs, runbooks, SLOs) at the standard level.
Coupling would create synchronization maintenance burden.

**Full ISO 9001/27001 certification path**: Out of scope for this standard.
Projects seeking certification should treat this standard as a foundation
and supplement with the framework appropriate to their certification target.

**No changes**: Rejected. The four gaps produce real problems: compliance
drift, false audit-readiness assumptions, slow security compliance checking.

---

## Validation

**Pass condition:** All four gaps are implemented and their deliverables remain current across subsequent releases.

**Trigger:** First compliance review after each major version.

**Status as of 2026-03-24 (v1.15.0):**
- Gap 1: ✓ Evidence columns present in standards-application-template.md and in use by ESE's own standards-application.md
- Gap 2: ✓ ESE completed its first compliance review 2026-03-24 (covering v1.7.0 through v1.15.0); compliance-review-template.md in use; review cadence defined in docs/standards-application.md
- Gap 3: ✓ §1 scope statement is present and accurate
- Gap 4: ✓ docs/requirement-index.md covers all STANDARDS.md sections by domain

**Failure condition:** A requirement present in STANDARDS.md is absent from requirement-index.md, or a compliance review template row is missing for a current STANDARDS.md section, or a project applying ESE cannot complete a compliance review because the template is incomplete.
