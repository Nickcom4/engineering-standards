# Problem Research: ESE Machine-Readable-First Restructuring

> **Use:** §1.2 Step 1 (full depth) for the ESE machine-readable-first restructuring epic.
> Gate: gate authority confirms problem is characterized before capabilities work begins.
> Companion investigation: [investigation-ese-machine-readable-lifecycle-model.md](investigation-ese-machine-readable-lifecycle-model.md)

---


## Table of Contents

- [Problem Statement](#problem-statement)
- [Existing Landscape](#existing-landscape)
- [Evidence](#evidence)
- [First Principles Check](#first-principles-check)
- [Open Questions](#open-questions)
- [Decision](#decision)
- [Next Step](#next-step)

## Problem Statement

**Who has this problem?**
Every practitioner and automated tool that uses ESE v1.19.0 to govern work - the current sole operator and any team adopting ESE as a distributable standard. Automated enforcement tools that attempt to enforce ESE requirements machine-side have this problem acutely: they cannot determine compliance without prose inference.

**How frequently does it occur?**
Every work item creation. Every compliance check. Every attempt to route a work item through the correct lifecycle stages. Frequency: 100% of ESE usage - the inference requirement is structural, not occasional.

**What do they currently do instead?**
Practitioners read §2.1, then §2.2 type row, then each applicable addendum - synthesizing the complete artifact set mentally. Automated tools either: (a) enforce only the subset of requirements that are unambiguous enough to encode without inference (current runtime enforcement: ~31 of 300+ potential gates), or (b) rely on LLM inference at runtime (probabilistic, fails-open when unavailable).

**What is the cost of the current approach?**
- Gate coverage: ~10% of enforceable ESE requirements (confirmed by deterministic enforcement tool analysis)
- Work items close without required artifacts because practitioners miss cross-section requirements
- enforcement-spec.yml (31 gates) must be hand-maintained separately from STANDARDS.md; any STANDARDS.md change requires a parallel update - dual-maintenance that will diverge
- docs/work-items/ (established ADR-021) has never been implemented because the structure was underspecified; ADR-019 accessibility obligation remains unfulfilled two sessions after the ADR was written
- Scale target (30+ repos/week, 2k+ commits/day) is unreachable with LLM-inference-dependent enforcement

**What does solved look like - concretely?**
A practitioner opening STANDARDS.md to look up requirements for a type=security work item on a containerized web project can find the complete artifact list - including base, type-conditional, and addenda requirements - from one location without reading three separate sections. An automated tool reading STANDARDS.md can generate a complete enforcement spec covering 300+ requirements with zero LLM inference. A repo changing ownership carries its complete work item history in a portable format importable by any compliant system.

---

## Existing Landscape

**What alternatives or partial solutions already exist?**

- `docs/requirement-index.md`: organized by domain (security, testing, etc.), not by work item type + addenda context. Does not answer "what does type=security + containerized require at DESIGN?" Partial - covers some cross-referencing but not the type×addenda intersection.
- `enforcement-spec.yml`: 31 hand-maintained gates. Covers ~10% of enforceable requirements. Requires parallel maintenance with STANDARDS.md. Does not cover artifact requirements, only gate requirements.
- spec-kit `RequirementsTracer`: places REQ-IDs in the requirements document and traces to implementation. The bidirectional pattern is directly applicable; spec-kit's sequential REQ-001 naming is less suited to a 9-section standard than ESE's hierarchical REQ-{section}-{seq} scheme.
- NIST SP 800-53 / ISO 27001: both use numbered requirements with explicit applicability conditions inline. Demonstrate that formal standards can be machine-parseable while remaining human-readable.

**What has been tried before?**
- Session 40 (2026-03-24): Deterministic enforcement tool design identified enforcement-spec.yml as the machine layer; draft at a local draft enforcement-spec.yml. Approach: separate YAML file derived from STANDARDS.md prose. Problem: dual-maintenance, incomplete (75 of 300+ requirements), diverges immediately on any STANDARDS.md edit.
- ADR-021 (2026-03-24): established docs/work-items/ structure. Never implemented. Standards-application.md acknowledges "planned but not yet implemented."

**Could this be solved without restructuring STANDARDS.md?**
Partially - enforcement-spec.yml + requirements-matrix.yaml could cover the machine layer without touching STANDARDS.md. Rejected: creates three maintained sources of truth (STANDARDS.md + enforcement-spec + requirements-matrix). ESE's own §4.7 and ADR-007 prohibit this. The maintenance burden compounds with every STANDARDS.md edit. The correct solution embeds the machine-readable structure in STANDARDS.md itself.

---

## Evidence

| Source | Finding | Date |
|--------|---------|------|
| Direct read: §2.1, §2.2, 7 addenda | type=improvement + web + CI: 12 requirements across 3 sources, zero from single source | 2026-03-25 |
| work item count | 2,196 work items in ~2 weeks solo | 2026-03-25 |
| standards-application.md line 143 | ADR-019 export "planned but not yet implemented" | 2026-03-25 |
| enforcement-spec-draft.yml | 75 gates of 300+ potential; hand-maintained; draft only | 2026-03-25 |
| Deterministic enforcement tool analysis | Deterministic enforcement tool blocked on enforcement-spec.yml; 99% coverage requires machine-readable spec | 2026-03-25 |
| Operator statement | 30+ repos/week, 2k+ commits/day target; teams will not adopt the tracked work item system | 2026-03-25 |

**Evidence quality check:**
- [x] Direct observation (reading STANDARDS.md sections and cross-referencing)
- [x] Frequency estimated from data (2,196 work items count, target scale from operator)
- [x] Cost quantified: 10% gate coverage, zero docs/work-items/ implementation
- [x] Solved state observable: one location answers type+addenda questions; tool generates 300+ gates with no inference

---

## First Principles Check

**What is this fundamentally trying to do?**
Make the rules of the standard explicit enough that any agent (human or machine) can determine compliance for any work item scenario without ambiguity or inference.

**What constraints cannot change?**
- STANDARDS.md must remain human-readable - it is a distributable standard, not a machine-only artifact
- The standard must work for teams using any work item system (GitHub Issues, Linear, Jira, or other tracked systems)
- Generated outputs (enforcement-spec.yml, requirement-index.md) may exist but cannot be the authoritative source
- The Distributable Repo Rule: no private system names, no internal IDs, no Nick-specific tooling in the standard itself

**What is the simplest solution that meets the requirement?**
Embed machine-readable structure directly in STANDARDS.md: inline REQ-IDs as named HTML anchors, inline tags encoding kind/scope/enforcement/applies-when, one requirement per addressable unit. Generated outputs derive from this. No separate maintained files. Single source.

---

## Open Questions

| Question | Who can answer | Priority |
|----------|---------------|----------|
| Data store format for portable work item records (JSONL vs SQLite vs libSQL/Turso) | lifecycle container model investigation | P1 |
| Artifact storage model: which of 10-15 per-work-item artifacts embed in data store vs. committed markdown | lifecycle container model investigation | P1 |
| Re-entry protocol when repo returns to tracked system domain | lifecycle container model + tracked system architecture | P2 |
| Export granularity rule at 50k+/year volume | lifecycle container model investigation | P1 |
| FMEA: high-RPN failure modes for restructuring STANDARDS.md | FMEA document (required at DESIGN) | P1 |

---

## Decision

- [x] **Proceed** - evidence supports restructuring. Epic filed. Work items in progress: lifecycle model investigation, lifecycle container model, enforcement-spec + anchors + 5 gaps, re-entry triggers, edge case AC, B1-B17 (implementation work items, pending filing).

**Rationale:** The problem is structural, confirmed by direct source reading, with concrete evidence (12-requirement cross-section proof). The solution direction (machine-readable-first STANDARDS.md) is the simplest approach satisfying all constraints. Alternatives (separate maintained files) violate ESE's own single-source-of-truth principle. Proceeding to capabilities document.

---

## Next Step

Write capabilities document: `docs/product/capabilities-ese-machine-readable-first.md`

---

*Date: 2026-03-25*
