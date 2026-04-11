# Research: Iterative/Experimental Loops in §1.2 Document Progression

**Date:** 2026-03-23
**Status:** Complete; recommendation below; implementation work item filed

---

## Table of Contents

- [Problem](#problem)
- [Where §1.2 Breaks Down](#where-12-breaks-down)
- [Framework Review](#framework-review)
- [Analysis](#analysis)
- [Proposed §1.2 Clarification](#proposed-12-clarification)
- [Distributable Repo Rule Check](#distributable-repo-rule-check)
- [Recommendation](#recommendation)

---

## Problem

ESE §1.2 defines a linear document progression:

1. Problem research
2. Capabilities
3. PRD
4. Architecture and ADRs
5. Implementation

The implicit assumption is that enough is knowable before BUILD begins to fully specify what to build. This assumption holds for most engineering work in the Complicated domain (per §1.5).

It does not hold for a specific class of investigation: **measurement-driven investigations**, where the investigation's acceptance criterion requires measuring actual outcomes from a working prototype, and the investigation cannot conclude without building that prototype first.

---

## Where §1.2 Breaks Down

The current model has a recognized fast-path: "A bug fix skips to step 5." It does not have a recognized path for:

- Investigations whose acceptance criterion requires measured outcomes
- Prototypes built specifically to answer a research question, where analysis alone cannot produce the answer
- Cases where BUILD must precede the conclusion of the parent investigation

Without a recognized pattern, practitioners encounter two failure modes:
1. **Under-applying the standard:** treating any investigation as a license to skip §1.2 entirely, losing the discipline that applies to the Complicated portions of the work
2. **Over-applying the standard:** blocking all BUILD until the investigation is complete, making completion impossible because completion requires BUILD

---

## Framework Review

### Six Sigma DMAIC

DMAIC explicitly structures investigation before improvement:

| Phase | Purpose |
|---|---|
| **Define** | Scope the problem and the investigation |
| **Measure** | Set up measurement systems and collect baseline data |
| **Analyze** | Find root causes from measurement data |
| **Improve** | Develop and test solutions |
| **Control** | Standardize and sustain improvements |

The Measure phase is critical: it explicitly recognizes that **setting up a valid measurement system is design work that precedes analysis**. Measurement infrastructure is built before the root cause is known. DMAIC does not require analysis to complete before building the measurement system. Measurement system design is a required DEFINE/MEASURE artifact.

### ISO 9001 / PDCA

PDCA (Plan-Do-Check-Act) maps to iterative investigation:

| Phase | Purpose | Iterative use |
|---|---|---|
| **Plan** | Scope the investigation; define what will be measured | Determine what prototype to build |
| **Do** | Build the measurement instrument | Implement the prototype |
| **Check** | Measure outcomes and analyze results | Evaluate what was learned |
| **Act** | Apply what was learned | Update the standard, process, or design |

The "Do" phase in PDCA is explicitly a small, controlled action designed to generate data for "Check." ISO 9001 Clause 9.1 requires organizations to plan what to monitor and how, before monitoring begins. Planning measurement methods may involve building measurement infrastructure.

Both frameworks recognize: some investigations require implementation to generate the evidence needed to conclude them.

---

## Analysis

Linear §1.2 assumes:

```
Investigate -> Decide -> Build
```

Measurement-driven investigations require:

```
Scope investigation -> Build measurement instrument -> Measure -> Conclude investigation -> Build production version
```

This is not a deviation from quality discipline. It IS quality discipline. The alternative (building without measurement) produces lower-quality outcomes. The prototype is not a production shortcut; it is a measurement instrument whose purpose is to close the investigation with evidence.

The key constraint: the prototype must be **scoped specifically to produce measurement data**, not built as if it were the production implementation. This scoping is what separates rigorous measurement-driven investigation from undisciplined "build and see."

---

## Proposed §1.2 Clarification

The following text should be added to §1.2 after the existing fast-path paragraph ("Not every project needs every step..."):

> **Measurement-driven investigations:** When an investigation's acceptance criterion requires measured outcomes from a working implementation (the prototype is the measurement instrument and the investigation cannot conclude without it), the implementation work may begin before the investigation work item is closed. Scope the implementation specifically to produce the measurement data needed, not as a production build. The investigation work item stays open until measurement is complete. File a separate implementation work item for the prototype with a dependency on the parent investigation. This pattern is equivalent to the Measure phase of DMAIC (Define-Measure-Analyze-Improve-Control), where measurement system setup is defined work that precedes analysis.

**What this does:**
- Provides a named, recognized pattern for measurement-driven investigation
- Preserves investigation-before-production discipline
- Requires explicit scoping of the prototype as a measurement instrument
- Aligns with established DMAIC and PDCA frameworks

**What this does not do:**
- Create a license to skip §1.2 for investigations generally
- Exempt the prototype from the BUILD lifecycle (tests, AC, and documentation apply to the implementation work item)
- Allow the investigation to close without measured outcomes

---

## Distributable Repo Rule Check

Proposed text contains: no personal names, no internal work item IDs, no private system references, no strategic vision or faith content. Safe for distributed repo.

---

## Recommendation

Add the proposed §1.2 clarification to STANDARDS.md. The change is one paragraph, non-breaking (existing projects unaffected), and resolves a genuine gap in the standard's coverage of investigation-type work.
