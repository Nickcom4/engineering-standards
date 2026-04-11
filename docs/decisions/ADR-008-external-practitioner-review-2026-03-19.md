---
type: adr
id: ADR-008
title: External Practitioner Review - What Was Incorporated and Why
status: Accepted
date: 2026-03-19
deciders: Gate authority (see standards-application.md)
implements:
  - REQ-4.2-01
  - REQ-4.1-01
---

# ADR-008: External Practitioner Review - What Was Incorporated and Why


## Context

An external practitioner with enterprise architecture and systems engineering experience reviewed ESE and provided feedback on eight potential gaps. Each item was evaluated against ADR-002 (universal principles only, not scenario-specific) and ADR-005 (practical - would every competent team do this consistently?).

## Decision

One item was incorporated. Seven were not.

**Incorporated: system-level disaster recovery documentation (§5.6)**

§5.6 already required that infrastructure be reproducible from the repository. It did not require documenting or testing the actual recovery path. A sentence was added requiring always-on services to document restore steps, a system-level Recovery Time Objective, and a tested recovery path on a defined cadence. This extends the existing principle rather than introducing a new one, and is consistent with the RTO/RPO pattern already required for databases in §4.8.

## Consequences

### Positive

- §5.6 is more complete for always-on services - reproducibility was required, but the documented and tested recovery path was not.

### Negative

- None identified. The addition is one sentence that extends existing language.

## Alternatives Considered

### ISO document control / uncontrolled copy notation

ESE is not an ISO 9001 quality management system. The CHANGELOG and version tags already handle document control for a software engineering context. Teams under ISO certification are governed by regulatory addenda.

### "Where" element in the problem statement

Already covered. The existing "Who has this problem?" prompt includes "specific user type, role, or context." Context covers environment and dependencies. A separate "Where" field would collect the same information under a different label.

### Current State / Optimal State / Recommended State progression

A structured AS-IS/TO-BE methodology from enterprise architecture. Fails ADR-005: most software teams will not perform formal optimal state analysis consistently. The §1.2 progression (problem research through PRD) achieves the same structured thinking without requiring state modeling terminology.

### Weakest link as a standalone design principle

Already covered by §3.2 "Design for Failure" - "assume every dependency will be unavailable at some point." The failure modes table required in the architecture template is the evaluation the coworker describes. Adding it as a separate principle would duplicate an existing one.

### Interoperability and compatibility matrices

Already addressed through the setup.md requirement in §4.1 (documenting prerequisites), §5.9 (Twelve-Factor App and environment parity), and the Web Applications addendum (browser compatibility).

### UI/UX graphic standards

Design system concern, not an engineering principle. §6.3 covers output quality and accessibility gates. Specific graphic standards belong in a project design system, not a universal engineering standard.

### Naming convention prescription

§3.2 requires a documented naming standard enforced by tooling. Prescribing a specific convention violates ADR-002 - the choice is technology-specific and a project decision.

## Validation

Does §5.6 now require always-on services to document and test their recovery path? Yes. Do the seven rejected items remain unaddressed? Intentionally - each is either already covered elsewhere in ESE or fails the universality or practicality test.
