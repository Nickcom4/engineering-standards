---
type: adr
id: ADR-2026-04-09-genuine-compliance-audit-remediation
title: "Genuine compliance audit remediation: deprecations, activation conditions, and agent guidance"
status: Accepted
date: 2026-04-09
deciders: "Nick Baker"
stage:
  - design
  - build
applies-to: all
implements:
  - REQ-4.2-01
  - REQ-2.1-03
dfmea: ~
pfmea: ~
architecture-doc: ~
---

# ADR-2026-04-09: Genuine Compliance Audit Remediation

## Table of Contents

- [Context](#context)
- [Decision](#decision)
- [Consequences](#consequences)
- [Alternatives Considered](#alternatives-considered)
- [Validation](#validation)

## Context

A genuine compliance audit of ESE against its own requirements (audit report and plan files removed after this ADR captured the decisions; see CHANGELOG v2.1.0 and the commit history on 2026-04-08 through 2026-04-09 for the underlying evidence) identified three systemic problems:

1. **Derivative sub-requirement bloat**: 58 requirements decomposed parent requirements into per-field children with no independent first-principles value, inflating the gate count without adding engineering value.
2. **Non-first-principles requirements**: 62 requirements existed as process ritual, meta-information, or theoretical padding without identifiable failure modes they prevent.
3. **Missing activation conditions**: approximately 80 conditional requirements in sections 5-9 did not state when they activate, forcing agents to evaluate and dismiss inapplicable requirements through judgment calls.

Additionally: 7 N/A designations in standards-application.md were questionable, 1 was incorrect, CI coverage was illusory (only approximately 15 of 357 declared gates had actual script enforcement), and 8 corpus files had structural violations.

## Decision

1. **Deprecate 141 requirements**: removed (non-first-principles), consolidated into parent requirements, or downgraded from gate to advisory. All deprecations follow the existing §4.9 immutability protocol (anchors retained, `deprecated:` tag added).
2. **Add Component Capabilities Declaration** to starters/standards-application.md: a checklist where projects declare which capabilities they have (runtime service, database, API, etc.).
3. **Add activation conditions** to 12 conditional subsections in sections 5-8, referencing the Component Capabilities Declaration.
4. **Add 5 new CI scripts** for previously ungated requirements.
5. **Add agent guidance** to CLAUDE.md covering FMEA triggers, close checklists, post-mortem triggers, and other consistently missed process steps.
6. **Correct N/A designations** in standards-application.md.

## Consequences

**Positive:**
- Approximately 20% reduction in gate-level requirements (120 fewer gates from active requirements)
- Agent-followability improved: conditional requirements become capability lookups instead of judgment calls
- CI coverage extended to 5 additional requirement categories
- Self-compliance improved: honest N/A designations, corpus violations fixed

**Negative:**
- Deprecated requirements remain visible in STANDARDS.md (per immutability); visual noise until next major version
- Activation conditions add structural complexity to subsection headers
- Component Capabilities Declaration adds one more section to the standards-application starter

**Risks:**
- Downstream adopters referencing deprecated REQ-IDs in their compliance tracking will need to update references
- The `deprecated:` tag convention is established (REQ-1.1-04, REQ-1.1-06 precedent) but this is the first bulk deprecation

## Alternatives Considered

1. **Do nothing**: Rejected. The audit identified genuine compliance gaps; self-compliance is a core ESE principle.
2. **Remove requirements entirely** (delete instead of deprecate): Rejected. §4.9 immutability requires retained anchors. Breaking changes to adopters who reference these IDs.
3. **Rewrite instead of deprecate**: Considered for derivative sub-requirements. Rejected as higher risk; deprecation is reversible, rewriting is not.
4. **Separate the work into smaller releases**: Considered. Rejected because the changes are interdependent (deprecations inform activation conditions; activation conditions require the Capabilities Declaration).

## Validation

- [ ] All locally-runnable CI checks pass after remediation
- [ ] Deprecated requirements retain anchors and have valid `deprecated:` tags
- [ ] Component Capabilities Declaration exists in starters/standards-application.md
- [ ] Activation conditions present in all 12 targeted subsections
- [ ] No typography violations (em dashes, en dashes, smart quotes)
- **Trigger:** Verify at next compliance review (next significant release)
