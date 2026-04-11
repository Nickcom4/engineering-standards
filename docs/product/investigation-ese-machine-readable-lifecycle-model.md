# Investigation: ESE Three-Layer Inference Gap and Machine-Readable Lifecycle Model

> Required by [§2.2](../../STANDARDS.md#22-work-item-discipline) for type=investigation.
> See also: [ADR-015](../decisions/ADR-015-root-cause-work-item-discipline.md).

**Date:** 2026-03-25
**Owner:** gate authority

---


## Table of Contents

- [Investigation Question](#investigation-question)
- [Evidence Gathered](#evidence-gathered)
- [Root Cause Statement](#root-cause-statement)
- [Full Lifecycle Loop (source: STANDARDS.md direct read)](#full-lifecycle-loop-source-standardsmd-direct-read)
- [Three-Layer Inference Problem - Concrete Proof](#three-layer-inference-problem---concrete-proof)
- [Template and Starter Classification](#template-and-starter-classification)
- [Decisions Reached](#decisions-reached)
- [Implementation Work Items](#implementation-work-items)
- [Measurement-Driven Exception](#measurement-driven-exception)
- [Decision](#decision)

## Investigation Question

What minimum structural changes to ESE - covering §2.1 Per-Stage Operational Blocks, §2.2 type taxonomy, and all 7 addenda - make the complete per-work-item artifact requirement set deterministic without cross-section inference, and what lifecycle container model, directory structure, naming convention, and file-when-produced protocol implements this at 10k-100k+ items/year for any team using any work item system?

---

## Evidence Gathered

| Date | Source | Finding |
|------|--------|---------|
| 2026-03-25 | Direct read: §2.1 Per-Stage table, §2.2 type taxonomy, all 7 addenda | A practitioner or machine determining artifacts for type=improvement + web + CI requires reading 3 separate sections; no single location answers the question. 12 requirements found; zero from a single source. |
| 2026-03-25 | Direct read: starters/intake-log.md, §8.2, §8.3, §8.4, §8.7, §9.1 | The lifecycle is not DISCOVER-to-CLOSE alone. Full loop: signal → intake-log → triage → work item → 9 stages → close → post-mortem/a3 → registries → new prevention/countermeasure items → back to intake. |
| 2026-03-25 | Direct read: docs/standards-application.md line 143 | ADR-019 export obligation "planned but not yet implemented." docs/work-items/ established in ADR-021 but never created. |
| 2026-03-25 | work item count | 2,196 work items in ~2 weeks solo. Implies 50k+/year solo, 250k+/year small team. Flat docs/work-items/ directory unusable at this volume. |
| 2026-03-25 | Operator context | Target scale: 30+ repos/week, 2k+ commits/day per repo. Teams inheriting repos will not use the tracked work item system. Repos re-enter and leave domain repeatedly. |
| 2026-03-25 | Direct read: spec-kit SKILL.md, stages/01-SPECIFY.md | spec-kit places REQ-IDs in the requirements document itself (bidirectional traceability). ESE currently places req-ids only in enforcement-spec.yml (one-directional). |
| 2026-03-25 | Direct read: docs/requirement-index.md | Existing domain-organized index. Not organized by work item type + addenda context. Does not answer "what does type=improvement + web require at DESIGN?" |
| 2026-03-25 | Direct read: ADR-021 naming conventions | Sequential ADR naming is "accepted alternative." ESE's own docs use sequential (ADR-001 through ADR-021+) while stating date-based is "default for new projects." Inconsistency in ESE's own application of its standard. |

---

## Root Cause Statement

**Root cause:** STANDARDS.md was written for sequential human reading, not for lookup or machine evaluation. Requirements are embedded in narrative prose with no addressable identifiers. Three separate structures (§2.1 Per-Stage, §2.2 type taxonomy, 7 addenda) each carry partial requirement information with no machine-readable join key. A practitioner or tool must read all three, infer the intersection for a specific type+addenda context, and synthesize a complete artifact list - with no validation that the synthesis is correct.

**Contributing factors:**
1. §2.1 Per-Stage table lists universal stage artifacts but omits type-conditional artifacts (A3, post-mortem, tech-eval)
2. §2.2 type taxonomy lists type-conditional artifacts but does not reference stage-timing or addenda requirements
3. Addenda list context-conditional requirements per stage but are authoritatively referenced from §2.1 (circular) with no independent addressability
4. docs/work-items/ was established (ADR-021) but never implemented, and ADR-019's "at close time" export model forfeits all in-flight artifacts on abandonment
5. ADR-021 flat-file naming embeds private system IDs in public repo paths, violating the distributable standard principle
6. No REQ-IDs exist in STANDARDS.md - individual requirements are unreferenceable without section-level inference

**Confidence:** High - directly observed via structured reading of all three layers with concrete cross-section proof (12 requirements for type=improvement + web + CI, zero answerable from a single source).

---

## Full Lifecycle Loop (source: STANDARDS.md direct read)

```
SIGNAL
 |
 v
intake-log.md [DISCOVER D0/D1]
 |-- park --> revisit trigger
 |-- discard --> reason logged
 |-- investigate --> type=investigation work item + investigation.md [D2]
 |-- promote
 |
 v
 D2 needed? --> investigation.md OR problem-research.md (abbreviated)
 §1.2 significant feature? --> problem-research.md (full)
 --> capabilities.md
 --> prd.md
 |
 v
 DEFINE: work-item.md
 |
 v
 DESIGN [conditional per §2.2 type + §9.1]:
 adr.md (qualifying change)
 fmea.md (auth / payments / data / external)
 architecture-doc.md (new component)
 tech-eval.md (new technology §9.1)
 a3.md (type=improvement, recurring §8.7)
 [7 addenda requirements activate per §2.1 table]
 |
 v
 BUILD --> VERIFY --> DOCUMENT --> DEPLOY --> MONITOR --> CLOSE
 | |
 work-session-log.md work-item export
 runbook.md (update) (data store record)
 deployment.md (update)
 [AI: model card]
 [EVT/MS: arch additions]
 |
 v
 POST-LIFECYCLE FEEDBACK LOOP:
 type=bug P0/P1 --> post-mortem.md
 --> lessons-learned-registry.md (append)
 --> anti-pattern-registry.md (if pattern promoted)
 --> new type=prevention work items --------+
 type=improvement recurring --> a3.md |
 --> new type=countermeasure items ---------+
 debt surfaced --> new type=debt items ------------------+
 |
 back to DEFINE <-----------+
```

---

## Three-Layer Inference Problem - Concrete Proof

Question: *What artifacts does type=improvement + web + CI addenda require at DESIGN?*

| Requirement | Source | Findable from §2.1 alone? | Findable from §2.2 alone? |
|---|---|---|---|
| investigation.md or problem-research.md | §2.1 DISCOVER | yes | no |
| work-item.md | §2.1 DEFINE | yes | no |
| a3.md if recurring | §2.2 improvement row | **no** | yes |
| baseline measurement before BUILD | §2.2 improvement row | **no** | yes |
| browser matrix, a11y | Web addendum DESIGN | **no** | **no** |
| DoE, SMED | CI addendum DESIGN | **no** | **no** |
| Vitals, Lighthouse, viewport | Web addendum VERIFY | **no** | **no** |
| SPC, before/after | CI addendum VERIFY | **no** | **no** |
| browser verify post-deploy | Web addendum DEPLOY | **no** | **no** |
| Vitals + control charts | Web + CI MONITOR | **no** | **no** |
| measured improvement exceeds variation | §2.3 type-conditional | **no** | partial |
| work-session-log.md | §2.1 DOCUMENT | yes | no |

Result: 12 requirements. 3 sources required. Zero answerable from any single source.

---

## Template and Starter Classification

### §2.1 Per-Stage (universal or conditional within stage)

| Template/Starter | Stage | Role |
|---|---|---|
| `intake-log.md` | DISCOVER D0/D1 | Pre-work-item; project-level signal capture |
| `investigation.md` | DISCOVER D2, DEFINE | D2 workspace + type=investigation artifact |
| `problem-research.md` | DISCOVER D2, §1.2 | D2 abbreviated OR §1.2 Step 1 full |
| `work-item.md` | DEFINE, VERIFY, MONITOR, CLOSE | Lifecycle container |
| `adr.md` | DESIGN | Qualifying architectural change |
| `fmea.md` | DESIGN | Auth/payments/data/external risk |
| `architecture-doc.md` | DESIGN, §1.2 Step 4 | New component or §1.2 architecture |
| `work-session-log.md` | DOCUMENT | Per session; may span multiple work items |
| `runbook.md` | DOCUMENT | Starter + update per always-on feature |
| `deployment.md` | DOCUMENT, DEPLOY | Starter + update per deployment |
| `slo.md` | MONITOR | New SLO only |
| `work-item-export.md` | CLOSE | Private systems; superseded by data store |

### §2.2 Type-Conditional (not in Per-Stage base; activated by type)

| Template | Section | Trigger |
|---|---|---|
| `capabilities.md` | §1.2 Step 2 | Significant feature; upstream of lifecycle |
| `prd.md` | §1.2 Step 3 | Significant feature; upstream |
| `tech-eval.md` | §9.1 | New technology adoption |
| `a3.md` | §8.7 | type=improvement, recurring issue |
| `post-mortem.md` | §8.2 | type=bug P0/P1 |
| `compliance-review.md` | Periodic | Not per-work-item |

### Starters (one-time project initialization; some dual-role)

| Starter | Notes |
|---|---|
| `standards-application.md` | Project setup; evolves with project |
| `repo-structure.md` | One-time setup |
| `setup.md` | One-time setup |
| `lessons-learned-registry.md` | Fed by all post-mortems; ongoing accumulation |
| `anti-pattern-registry.md` | Promoted from lessons-learned; ongoing |
| `intake-log.md` | Also Per-Stage (dual role) |
| `runbook.md` | Also Per-Stage (dual role) |
| `deployment.md` | Also Per-Stage (dual role) |

---

## Decisions Reached

**Decision: Machine-readable-first STANDARDS.md as single source of truth.**

STANDARDS.md is restructured so each requirement is a discrete, addressable unit with inline machine-readable tags. Generated outputs (enforcement-spec.yml, requirement-index.md) replace hand-maintained parallel files. REQ-IDs are the universal cross-system identifiers. The three-layer inference problem is resolved by embedding all requirement context in the structured unit, not by creating a separate requirements-matrix.yaml.

**Approved decisions (D1-D12):** See session log
`docs/work-sessions/2026-03-25-ese-machine-readable-first-investigation.md`

**Open - lifecycle container model scope:**
- Data store selection for work item records (JSONL vs SQLite vs libSQL/Turso vs Postgres vs Mnesia)
- Artifact storage model for 10-15 artifacts per complex work item
- Re-entry protocol when repo returns to the tracked system's domain
- Export granularity rule at realistic volumes

---

## Implementation Work Items

| Title | Type | Status |
|---|---|---|
| ESE machine-readable lifecycle model epic | epic | Open |
| Lifecycle container structure, naming, file-when-produced | feature | Open |
| enforcement-spec.yml + REQ-ID anchors + 5 ESE gaps | feature | Open |
| §2.1 re-entry triggers | feature | Open |
| §2.2 edge case AC requirement | feature | Open |
| Implementation work items B1-B17 (pending filing) | feature | Pending |

> [ ] At least one implementation work item filed - B1-B17 pending approval and filing

---

## Measurement-Driven Exception

- [x] **Applicable** - the data store selection requires a proof-of-concept to validate that the chosen format handles the target volume (50k+/year) and re-entry reconstruction correctly before the architecture is finalized. The lifecycle container model investigation stays open until measurement is complete.

---

## Decision

- [ ] **Root cause identified** - implementation work items filed. Close investigation.

Root cause is identified and documented above. Implementation work items B1-B17 are pending gate authority approval and filing. The data store investigation remains open. This investigation closes when B1-B17 are filed and gate authority approval is recorded.

---

*Date: 2026-03-25*
