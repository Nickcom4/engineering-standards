---
type: fmea
id: DFMEA-2026-03-25-ese-machine-readable-first-restructuring
title: "DFMEA: ESE Machine-Readable-First Restructuring"
status: Complete: iteration 13
fmea-type: DFMEA
implements:
  - REQ-2.1-04
  - REQ-2.1-37
  - REQ-2.1-41
  - REQ-2.1-42
  - REQ-2.1-43
date: 2026-03-25
owner: "Nick Baker"
adr: ADR-2026-03-25-ese-machine-readable-first-format
pfmea: PFMEA-2026-03-26-ese-process-sequences.md
---

# DFMEA: ESE Machine-Readable-First Restructuring

> Required by [§2.1 DESIGN](../../STANDARDS.md#21-the-lifecycle): this change mutates STANDARDS.md
> (the authoritative standard read by enforcement tools and all adopters) and introduces
> automated rule generation from a structured format (external integration pattern).
> Complete before BUILD begins. High-RPN failure modes require design changes or controls.

**Feature:** ESE machine-readable-first restructuring\
**Date:** 2026-03-25\
**Owner:** Nick Baker\
**Status:** Updated 2026-03-25 (session 42): FM-05, FM-09, FM-10 controls revised per B1 decisions. Pre-BUILD controls pending. DESIGN review required before first migration work item (B3) begins.

---

## Table of Contents

- [Rating Scales](#rating-scales)
- [Failure Mode Analysis](#failure-mode-analysis)
- [High-RPN Failure Modes (RPN ≥ 100) - Required Actions Before BUILD](#high-rpn-failure-modes-rpn--100---required-actions-before-build)
- [Iteration Narrative](#iteration-narrative)
- [RPN Tracking Table](#rpn-tracking-table)
- [High-Severity Failure Modes (Severity >= 7)](#high-severity-failure-modes-severity--7)
- [Controls Summary](#controls-summary)
- [Applicable Addenda](#applicable-addenda)
- [Review Checklist](#review-checklist)

---

## Rating Scales

| Score | Severity (S) | Occurrence (O) | Detectability (D) |
|---|---|---|---|
| 1-2 | Negligible: no user impact | Remote: unlikely conditions | Almost certain: tests/monitoring catch it |
| 3-4 | Low: minor, workaround exists | Low: edge cases only | High: likely caught in review |
| 5-6 | Moderate: partial loss, recoverable | Moderate: normal operation, no controls | Moderate: may reach users |
| 7-8 | High: major unavailable, data risk | High: likely without mitigation | Low: unlikely caught before users |
| 9-10 | Critical: data loss, unauthorized access | Near certain: inevitable without action | Cannot detect: no mechanism exists |

**D: lower is better** (1 = always caught, 10 = never caught).
**RPN** = S x O x D. **Threshold: 75.** **Severity threshold: 7.**

## Failure Mode Analysis

| # | Failure Mode | Effect | S | O | D | RPN | Action Required | Status |
|---|---|---|---|---|---|---|---|---|
| FM-01 | REQ-ID collisions (two requirements share same ID) | Enforcement tools enforce wrong requirement | 9 | 3 | 1 | **27** | T1 unique REQ-ID validator: hard-block pre-commit + CI gate (iter 3, implemented iter 8 commit c047cf0). | stable |
| FM-02 | Tag schema misapplied (wrong scope or enforcement level) | Gate fires at wrong stage, or hard gate deployed as advisory | 8 | 3 | 2 | **48** | T2 tag schema linter: pre-commit + CI gate on every STANDARDS.md commit; validates all 5 positions (iter 3, implemented iter 8 commit c047cf0). | stable |
| FM-03 | Generated enforcement-spec.yml diverges from STANDARDS.md | Mixed enforcement state invisible to practitioners | 9 | 4 | 1 | **36** | Delete existing enforcement-spec.yml at B3; generator runs as CI gate on every STANDARDS.md commit (iter 3). | stable |
| FM-04 | Restructuring breaks adopter tooling (section anchors) | Adopter CI breaks on ESE submodule upgrade | 7 | 2 | 3 | **42** | Additive-only anchors; section heading linter verifies no removals (iter 2). | stable |
| FM-05 | Format ambiguous at edge cases (compound applies-when) | Tools parse applies-when differently | 8 | 2 | 2 | **32** | PEG grammar (B1); unambiguous by construction (iter 2). | stable |
| FM-06 | LLM-generated rules activate before validation | False blocks or silent passes | 9 | 3 | 1 | **27** | Mode 2 rules inert-by-default; promotion requires gate authority approval (iter 3). | stable |
| FM-07 | Migration incomplete (some sections have REQ-IDs, others not) | Partial machine-readable state; tools assume full coverage | 6 | 1 | 1 | **6** | Section atomicity (iter 2); classification map (iter 7); corpus-wide unbundling complete (iter 9, session 44): all REQ-IDs assigned (see req-manifest.sha256 for current count), T7 manifest gate. | stable |
| FM-08 | Portable data store format incompatible with import | Work item history lost on repo return | 8 | 2 | 2 | **32** | Append-only backward-compat; round-trip CI gate for (iter 3). | stable |
| FM-09 | REQ-IDs change meaning across ESE versions | Tools enforce different behavior across versions | 8 | 2 | 3 | **48** | Schema append-only; IDs immutable; deprecated token preserves anchor (iter 2). | stable |
| FM-10 | STANDARDS.md grows unmanageable | Readability degrades; adoption friction | 6 | 3 | 2 | **36** | Prose-line ceiling (REQ-4.9-02) removed per Nick Baker decision (, this session): ceiling was arbitrary. Control is now §4.7 qualitative test exclusively ('can be read end to end in a single sitting'). REQ-4.9-02 deprecated. PDCA/DMAIC content returned from req-schema.md to STANDARDS.md. | stable |
| FM-11 | ADR template lacks implementation checklist | Decisions made but not executed | 7 | 2 | 2 | **28** | Implementation Checklist section added to templates/adr.md (iter 5). | stable |
| FM-12 | Templates/starters lack frontmatter and REQ-ID refs | Template compliance unverifiable | 8 | 2 | 2 | **32** | All 23 templates/starters have YAML frontmatter (iter 5). | stable |
| FM-13 | Addenda requirements ambiguous or non-binary | Unenforceable gates in enforcement-spec.yml | 9 | 1 | 2 | **18** | Classification map + 3 NB rewrites; zero NB remain (iter 6-7). | stable |
| FM-14 | REQ-IDs assigned before CI tooling active | Collisions/malformed tags ship undetected | 7 | 2 | 1 | **14** | T1+T2 implemented as pre-commit + CI gates (iter 8 commit c047cf0). Caught 4 real issues on first run. | stable |
| FM-15 | Mode 2 F1 threshold insufficient for rule quality | False-blocking or false-passing gates reach practitioners after promotion | 8 | 2 | 2 | **32** | REQ-ADD-AI-31 (2 independent runs required) + REQ-ADD-AI-32 (each run F1 >= 0.85 independently) reduce O and D; threshold set before evaluation (REQ-ADD-AI-30) prevents post-hoc manipulation (iter 13). | stable |
| FM-16 | Mode 2 promotion commit missing required evidence | Rule activates without verifiable quality evidence; audit trail incomplete | 7 | 3 | 3 | **63** | REQ-ADD-AI-33 through REQ-ADD-AI-35 require F1 scores, labeled set refs, and threshold confirmation in promotion commit (iter 13). Residual: no CI gate enforces commit message content; detectability D=3 (commit review catches it). | stable |

---

## High-RPN Failure Modes (RPN ≥ 100) - Required Actions Before BUILD

## Iteration Narrative

**FMEA iteration 8 result (2026-03-25, session 43):** FM-14 resolved: T1 (unique REQ-ID validator) and T2 (tag schema linter) implemented as pre-commit hooks and CI gates (commit c047cf0). RPN 392 to 14. Linter caught 4 real tag errors on first run, all fixed. **All 14 failure modes now below RPN 100.** Highest: FM-07 at 90 (partial migration state; resolves as remaining REQ-IDs are assigned). Prior iteration 7: FM-13 reduced to 18 (NB rewrites), FM-07 raised to 90 (partial state), FM-10 stable at 36, FM-14 identified at 392.

**FMEA iteration 9 result (2026-03-26, session 44):** FM-07 resolved: corpus-wide elemental REQ-ID pass complete ( EPIC, 14 children). Total REQ-IDs grew from 429 (iteration 8) to full corpus coverage. See req-manifest.sha256 for current count. All bundled REQ-IDs in STANDARDS.md (47), 7 addenda (23), starters (7), and templates (5) unbundled into elemental single-obligation IDs. T7 integrity manifest implemented (generate-req-manifest.sh + CI Check 7 + pre-commit; commit 7337bd1). FM-07 RPN 90 to 9 (Occurrence 1: migration complete; Detectability 1: T7 manifest catches any divergence). **All 14 failure modes below RPN 100. Highest: FM-07 at 9 (stable).**

**DFMEA iteration 13 result (2026-03-26, this session):** Mode 2 implementation adds 2 new failure modes. FM-15 (Mode 2 F1 threshold insufficient, S=8 O=2 D=2, RPN 32): controlled by REQ-ADD-AI-30/-31/-32 (threshold before eval; 2 independent runs each F1 >= 0.85). FM-16 (Mode 2 promotion missing evidence, S=7 O=3 D=3, RPN 63): controlled by REQ-ADD-AI-33/-34/-35 (promotion commit content requirements). Both below RPN 75 threshold. FM-16 has residual D=3 (no CI gate on commit message content). **16 FMs total, all below RPN 75. Highest: FM-16 at 63.**

**DFMEA iteration 10 result (2026-03-26, session 44 continued):** DFMEA/PFMEA type distinction added to ESE as first principle. REQ-2.1-35 (PFMEA review at qualifying changes) and REQ-2.1-36 (recurring bug PFMEA update) added. DFMEA file renamed from FMEA- to DFMEA- prefix with all 6 references updated. premature close identified as PFMEA failure: tracking work item closed before B15 and B17 complete. Reopened. REQ-ID count increased (see req-manifest.sha256). T7 pre-commit changed from verify-only to auto-regenerate-and-stage.

## RPN Tracking Table

| # | Iter 1 | Iter 2 | Iter 3 | Iter 4 | Iter 5 | Iter 6 | Iter 7 | Iter 8 | Iter 9 | Iter 10 | Iter 11 | Iter 12 | Iter 13 | Resolution |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| FM-01 | 81 | 81 | **27** | 27 | 27 | 27 | 27 | 27 | 27 | 27 | 27 | 27 | 27 | Hard-block CI gate (iter 3) |
| FM-02 | 160 | 96 | **48** | 48 | 48 | 48 | 48 | 48 | 48 | 48 | 48 | 48 | 48 | Source docs + linter (iter 2+3) |
| FM-03 | 72 | 72 | **36** | 36 | 36 | 36 | 36 | 36 | 36 | 36 | 36 | 36 | 36 | Delete at B3; generator-as-gate (iter 3) |
| FM-04 | 210 | **42** | 42 | 42 | 42 | 42 | 42 | 42 | 42 | 42 | 42 | 42 | 42 | Additive-only anchors (iter 2) |
| FM-05 | 96 | **32** | 32 | 32 | 32 | 32 | 32 | 32 | 32 | 32 | 32 | 32 | 32 | PEG grammar (B1) |
| FM-06 | 54 | 54 | **27** | 27 | 27 | 27 | 27 | 27 | 27 | 27 | 27 | 27 | 27 | Inert-by-default (iter 3) |
| FM-07 | 252 | **54** | 54 | 54 | 54 | 54 | **90** | 90 | **6** | 6 | 6 | 6 | 6 | Resolved iter 9: corpus-wide unbundling complete, T7 manifest |
| FM-08 | 96 | 96 | **32** | 32 | 32 | 32 | 32 | 32 | 32 | 32 | 32 | 32 | 32 | Backward-compat + round-trip (iter 3) |
| FM-09 | 128 | **48** | 48 | 48 | 48 | 48 | 48 | 48 | 48 | 48 | 48 | 48 | 48 | Schema append-only (iter 2) |
| FM-10 | 192 | **48** | 48 | 48 | 48 | 48 | **36** | 36 | 36 | 36 | 36 | 36 | 36 | Prose-line ceiling (iter 2 + iter 7 revision) |
| FM-11 | - | - | - | 336 | **28** | 28 | 28 | 28 | 28 | 28 | 28 | 28 | 28 | ADR template checklist (iter 5) |
| FM-12 | - | - | - | 360 | **32** | 32 | 32 | 32 | 32 | 32 | 32 | 32 | 32 | Template/starter frontmatter (iter 5) |
| FM-13 | - | - | - | 252 | 252 | **54** | **18** | 18 | 18 | 18 | 18 | 18 | 18 | Classification + NB rewrites (iter 6+7) |
| FM-14 | - | - | - | - | - | - | 392 | **14** | 14 | 14 | 14 | 14 | 14 | T1+T2 pre-commit + CI gates (iter 8) |
| FM-15 | - | - | - | - | - | - | - | - | - | - | - | - | **32** | Mode 2 F1 threshold insufficient; REQ-ADD-AI-31, REQ-ADD-AI-32 controls (iter 13) |
| FM-16 | - | - | - | - | - | - | - | - | - | - | - | - | **63** | Mode 2 promotion missing evidence; REQ-ADD-AI-33, REQ-ADD-AI-34, REQ-ADD-AI-35 controls (iter 13) |

---

## High-Severity Failure Modes (Severity >= 7)

> Per REQ-2.1-17: Severity >= 7 requires review regardless of RPN.

| FM# | Severity | RPN | Action | Status |
|---|---|---|---|---|
| FM-01 | 9 | 27 | T1 unique REQ-ID validator: hard-block pre-commit  | stable |
| FM-02 | 8 | 48 | T2 tag schema linter: pre-commit + CI gate on ever | stable |
| FM-03 | 9 | 36 | Delete existing enforcement-spec.yml at B3; genera | stable |
| FM-04 | 7 | 42 | Additive-only anchors; section heading linter veri | stable |
| FM-05 | 8 | 32 | PEG grammar (B1); unambiguous by construction (ite | stable |
| FM-06 | 9 | 27 | Mode 2 rules inert-by-default; promotion requires  | stable |
| FM-08 | 8 | 32 | Append-only backward-compat; round-trip CI gate fo | stable |
| FM-09 | 8 | 48 | Schema append-only; IDs immutable; deprecated toke | stable |
| FM-11 | 7 | 28 | Implementation Checklist section added to template | stable |
| FM-12 | 8 | 32 | All 23 templates/starters have YAML frontmatter (i | stable |
| FM-13 | 9 | 18 | Classification map + 3 NB rewrites; zero NB remain | stable |
| FM-14 | 7 | 14 | T1+T2 implemented as pre-commit + CI gates (iter 8 | stable |
| FM-15 | 8 | 32 | REQ-ADD-AI-31 (2 independent runs required) + REQ- | stable |
| FM-16 | 7 | 63 | REQ-ADD-AI-33 through REQ-ADD-AI-35 require F1 sco | stable |

## Controls Summary

Before BUILD on any migration work item (B3-B12) begins:
- [x] Unique REQ-ID validator (T1): hard-block pre-commit hook + CI gate; scripts/validate-req-ids.sh scans STANDARDS.md and all addenda for duplicate anchors outside code blocks (commit c047cf0)
- [x] Tag schema linter (T2): pre-commit hook + CI gate; scripts/lint-req-tags.sh validates all 5 positions, enum values, eval-scope on kind:gate (commit c047cf0)
- [x] T7 REQ-ID integrity manifest: pre-commit auto-regenerates req-manifest.sha256 on every commit touching REQ-ID files; CI Check 7 verifies; full corpus (count in req-manifest.sha256) (scripts/generate-req-manifest.sh + CI Check 7)
- [x] T7 auto-regenerate: pre-commit generates manifest and stages it automatically instead of verify-only (scripts/pre-commit + scripts/generate-req-manifest.sh)
- [x] DRY corpus file list: scripts/ese-corpus-files.sh is single source of truth for all scanning scripts (scripts/ese-corpus-files.sh)
- [x] Mixed-section CI gate (T3, lint-obligations.sh): scans for obligation keywords not within 10 lines of a REQ-ID anchor; wired to CI Check 12 and scripts/pre-commit
- N/A: STANDARDS.md prose-line-count CI gate (T4, REQ-4.9-02): removed per Nick Baker decision. The 1200-line ceiling was arbitrary. §4.7 qualitative test is the correct control. lint-prose-line-count.sh deleted.
- [x] Section heading anchor linter (T5, lint-section-anchors.sh): extracts 183 heading slugs from STANDARDS.md + 7 addenda; compares against docs/section-anchors-baseline.txt baseline; exits 1 if any removed/renamed; wired to CI Check 16 and scripts/pre-commit
- [x] enforcement-spec.yml generator (T6, generate-enforcement-spec.sh): reads all non-deprecated kind:gate REQ-IDs from corpus; generates enforcement-spec.yml with current gate count (see gate_count in enforcement-spec.yml; lint-count-congruence gates this claim); CI Check 16 verifies freshness; pre-commit auto-regenerates
- [x] Existing hand-maintained enforcement-spec.yml deleted: N/A, never existed in this repo
- [x] REQ-ID count parity (T7b): pre-commit + CI Check 8 verifies manifest block count equals unique anchor count across full corpus (scripts/pre-commit)
- [x] applies-when formal grammar documented in §4.x: complete (enforced by scripts/validate-req-ids.sh)
- [x] ADR template (templates/adr.md) updated with Implementation Checklist section (FM-11): complete (iteration 5)
- [x] work-item template (templates/work-item.md) updated with `req-ids` field: complete (iteration 5)
- [x] All 15 templates under `templates/*.md` have YAML frontmatter: `stage`, `applies-to`, `implements` (FM-12): complete (iteration 5; verified by `lint-template-compliance.sh` CI Check 36)
- [x] All 8 starters under `starters/*.md` have YAML frontmatter: `purpose`, `frequency` (FM-12): complete (iteration 5; verified by `lint-template-compliance.sh` CI Check 36)
- [x] All 7 addenda requirements reviewed and clarified to binary/observable form before REQ-ADD IDs assigned (FM-13): classification map complete; all addenda unbundled; full corpus coverage (verified via scripts/lint-template-compliance.sh)

Before closing (data store):
- [x] Import round-trip CI gate (FM-08, lint-work-item-export.sh): validates templates/work-item-export.md and docs/work-items/*.md format; parses YAML frontmatter, checks required fields, verifies round-trip parse consistency; CI Check 21 + pre-commit. broader design work (directory structure at scale) remains open as a separate work item.

Before any LLM-generated gate activates:
- [x] Gate authority approval standard defined: configuring F1 threshold before evaluation satisfies gate authority requirement per ai-ml.md REQ-ADD-AI-30. Threshold = F1 >= 0.85 per run (Nick Baker, 2026-03-26).
- [x] Mode 2 rules are status: inert by default: generate-mode2-candidates.sh produces enforcement-spec-mode2-candidates.yml with all rules status: inert; promotion requires 2 independent runs each F1 >= 0.85 per REQ-ADD-AI-31, REQ-ADD-AI-32, REQ-ADD-AI-33.

---

## Applicable Addenda

### AI/ML Addendum Requirements (active for the enforcement analyzer)

Per [AI/ML addendum](../addenda/ai-ml.md) DESIGN requirements:

**Autonomy boundary for enforcement-spec.yml generator:**
The generator reads structured requirements (deterministic) and outputs YAML - this is **Informational** (output reviewed by human before activation). The enforcement analyzer Mode 2 (LLM-generated gates) is **Automated** level - requires defined rollback, monitoring, and anomaly detection. FM-06 above addresses this.

**Hallucination containment for Mode 2:**
LLM-generated enforcement rules are structured output (YAML conforming to enforcement-spec schema). Validation: run generated rules through schema parser before any rule activates. Invalid structured output is a known output state, not an exception. Invalid rules are discarded, not silently activated.

**Acceptable error rate:**
A falsely-blocking gate (blocks legitimate work) has higher cost than a falsely-passing gate (misses a violation). Mode 2 rules default to `enforcement: soft` (warning without blocking) until verified F1 >= 0.85 on labeled examples. `enforcement: hard` (blocking) requires explicit human promotion.

---

## Review Checklist

> Auto-generated values from source FM tables.

- [x] All components listed (14 FMs)
- [x] RPN threshold defined (75)
- [x] Every Severity >= 7 FM has assigned action (12 FMs)
- [x] All FMs below RPN threshold (0 above)
- [x] No FMs with status 'open' or 'review' (0 remaining)
- [x] Post-action FMs rescored (REQ-2.1-42)
- [x] No hardcoded counts (relative references used)
- [x] Derived views auto-generated (generate-fmea-views.sh)

*Completed by: Nick Baker (session)*
**DFMEA iteration 11 result (2026-03-26, session 44):** RPN threshold reduced from 100 to 75. All 14 DFMEA failure modes remain below 75. Highest: FM-02 and FM-09 at 48. No new corrective actions required.

**DFMEA iteration 12 result (2026-03-26, session 44):** High-severity threshold reduced from 8 to 7. FM-04 (S=7), FM-10 (S=6), FM-14 (S=7) newly require review. All three already have controls and RPNs well below 75. No new corrective actions required.

*Date: 2026-03-26*
*Status: DFMEA iteration 13 complete (2026-03-26). 16 FMs total. FM-15 (RPN 32) and FM-16 (RPN 63) added for Mode 2 risks. All 16 FMs below RPN 75. Severity threshold 7. Highest: FM-16 at 63.*
