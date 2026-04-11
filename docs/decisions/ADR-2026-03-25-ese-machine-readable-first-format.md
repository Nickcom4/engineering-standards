---
type: adr
id: ADR-2026-03-25-ese-machine-readable-first-format
title: "ESE Machine-Readable-First Format: Inline REQ-IDs Replace Separate Enforcement Spec"
status: Accepted
date: 2026-03-25
deciders: "Nick Baker"
implements:
  - REQ-4.2-01
  - REQ-4.9-03
  - REQ-4.9-07
  - REQ-4.9-12
  - REQ-1.5-01
  - REQ-1.5-02
  - REQ-1.5-03
  - REQ-4.2-10
  - REQ-4.2-11
  - REQ-ADD-AI-30
  - REQ-ADD-AI-31
  - REQ-ADD-AI-32
  - REQ-ADD-AI-33
  - REQ-ADD-AI-34
  - REQ-ADD-AI-35
dfmea: DFMEA-2026-03-25-ese-machine-readable-first-restructuring.md
pfmea: PFMEA-2026-03-26-ese-process-sequences.md
architecture-doc: ~
---

# ADR-2026-03-25: ESE Machine-Readable-First Format: Inline REQ-IDs Replace Separate Enforcement Spec

> Architectural Decision Record.
> This decision introduces a new component (REQ-ID inline anchor system),
> replaces an existing approach (separate maintained enforcement-spec.yml),
> and alters how enforcement tools communicate with the standard.

---

## Context

ESE v1.19.0 encodes requirements across three non-unified structures:

1. **§2.1 Per-Stage Operational Blocks** - stage-universal artifacts
2. **§2.2 type taxonomy** - type-conditional DESIGN gates and close conditions
3. **7 addenda** - context-conditional requirements stacking on each stage

No practitioner or tool can determine the complete artifact requirement set for a given work item type + addenda context without reading and synthesizing all three. Proof: a type=improvement work item on a web project with CI addendum active requires 12 requirements from 3 separate sections - zero are findable from any single source.

Additionally, the current machine-readable layer is `enforcement-spec.yml`: a hand-maintained YAML file with 31 gates derived from STANDARDS.md prose. This file:
- Covers approximately 10% of enforceable requirements (31 of ~300+)
- Must be manually kept in sync with STANDARDS.md - any prose edit risks divergence
- Was written as a draft referencing STANDARDS.md sections, not individual requirements
- Requires LLM inference at runtime to cover requirements not in the spec

The single-source-of-truth principle (ESE ADR-007, §4.7) prohibits maintaining a parallel file whose content is derived from another authoritative source. enforcement-spec.yml as a hand-maintained file violates this principle.

**Cost of doing nothing:** enforcement coverage remains at ~10%; dual-maintenance burden grows with every STANDARDS.md change; the deterministic enforcement tool cannot reach 99% coverage without per-requirement addressability in STANDARDS.md.

**Supersedes:** The approach of hand-maintaining `enforcement-spec.yml` as a parallel source. The file will become a generated build artifact. No prior ADR governs the enforcement-spec.yml format; this ADR establishes the architectural decision.

---

## Decision

**STANDARDS.md is restructured to be machine-readable-first.** Every discrete, binary, observable requirement in STANDARDS.md §1-§9 and all 7 addenda is expressed as an addressable unit with inline machine-readable metadata:

```
<a name="REQ-2.2-01"></a>
**REQ-2.2-01** `gate` `define` `hard` `all`
A work item title states what is wrong and what correct looks like.
```

**REQ-ID scheme:**
- Base sections: `REQ-{section}-{seq:02d}` e.g. `REQ-2.2-01`
- Addenda: `REQ-ADD-{CODE}-{seq:02d}` where codes are `WEB`, `AI`, `CI`, `EVT`, `MS`, `CTR`, `MT`
- IDs are immutable once published. Deprecated requirements retain their anchor and ID. A sixth optional token `deprecated:{superseding-REQ-ID}` is appended to the tag line (e.g. `deprecated:REQ-2.1-07`). For requirements with no direct successor, use `deprecated:none`. The statement line is replaced with a struck-through redirect. Deprecated gate requirements are omitted from the generated `enforcement-spec.yml`.

**Inline tag schema (positional):**

Gate requirements carry five tokens. Artifact and advisory requirements carry four.

```
<a name="REQ-2.2-01"></a>
**REQ-2.2-01** `gate` `define` `hard` `all` `per-item`
A work item title states what is wrong and what correct looks like.
```

| Position | Name | Valid values | Required for |
|---|---|---|---|
| 1 | `kind` | `gate` \| `artifact` \| `advisory` | all; see kind source note below |
| 2 | `scope` | `discover` \| `define` \| `design` \| `build` \| `verify` \| `document` \| `deploy` \| `monitor` \| `close` (from ESE §2.1) \| `commit` \| `session-start` \| `session-end` \| `continuous` (enforcement extensions) | all |
| 3 | `enforcement` | `hard` \| `soft` \| `none` | all; see enforcement source note below |
| 4 | `applies-when` | `all` \| `type:{name}` \| `addendum:{code}` \| compound expression (see grammar below) | all |
| 5 | `eval-scope` | `per-item` \| `per-section` \| `per-artifact` \| `per-commit` | `kind:gate` only |

The fifth token is a backward-compatible extension decided in B1. Requirements written with four tokens are valid; they are treated as `kind:artifact` or `kind:advisory`. No requirement requires re-writing solely to add this token unless it is `kind:gate`.

**Kind value source:** `gate` maps to ESE's consistent use of "gate" throughout §2.1, §2.3, §2.5 (conditions that block lifecycle progression when violated). `artifact` maps to §2.1 Per-Stage Operational Blocks (each stage produces named artifacts). `advisory` has no ESE §2.1 counterpart; it is an addition to allow informational tagging of guidance statements that warrant a stable REQ-ID but carry no enforcement consequence; analogous to a lint rule set to "info" severity.

**Enforcement value source:** `hard` maps to ESE's framing in the preamble ("gates that block progress when violated, not aspirational guidelines") and §3.2 Fail Fast principle ("surface problems immediately rather than allowing them to propagate silently"). `soft` maps to §2.5's risk-based approval model ("automated gates for routine changes"); a warning that does not block but surfaces a signal. `none` is an addition for informational tagging where a REQ-ID is useful for cross-reference but no runtime enforcement is intended. These three levels parallel common linting severity conventions (error/warning/off) but are defined by ESE semantics, not by any external linting standard.

**Scope value source:** Nine values map directly to ESE §2.1 lifecycle stages (STANDARDS.md line 149): `discover`, `define`, `design`, `build`, `verify`, `document`, `deploy`, `monitor`, `close`. Four are enforcement-system extensions with no ESE §2.1 counterpart: `commit` (pre-commit hook checks), `session-start` (session start protocol checks), `session-end` (session end protocol checks), `continuous` (always-active requirements not tied to a lifecycle transition). These four are required to express enforcement rules that activate outside the main lifecycle flow. They are ESE-system values, not ESE-standard lifecycle stages; any adopter enforcing requirements with these scope values must provide their own equivalent hooks.

**Eval-scope semantics:** `per-item` means the evaluator runs once per AC item (most granular, most expensive); `per-section` once per document section; `per-artifact` once per complete artifact; `per-commit` once per commit. At 300 gate requirements with an average of 4 AC items each, a full per-item compliance check triggers approximately 1200 evaluations. Implementation must support batching.

**enforcement-spec.yml becomes a generated build artifact.** A generator script reads all `kind:gate` REQ-IDs from STANDARDS.md and addenda and produces `enforcement-spec.yml` on every commit that modifies those files. The file is not maintained by humans; it is always current by construction.

**requirement-index.md becomes a generated view.** A generator produces domain-organized and type-organized views from structured requirements. Not maintained by humans.

**Single source of truth:** STANDARDS.md. One place to change any requirement. All downstream artifacts regenerate.

**ADR naming:** Sequential naming (`ADR-NNN`) is deprecated as a permissible option. Date-based (`ADR-YYYY-MM-DD-title.md`) is the sole convention for all new ADRs. ESE's own existing ADR-001 through ADR-021+ are legacy - retained, not renamed. This ADR follows the new convention.

**FMEA corrective design decisions (iteration 2, 2026-03-25):**

Four failure modes from FMEA-2026-03-25 remained above RPN 100 after initial review (FM-04: 210, FM-07: 252, FM-09: 128, FM-10: 192). Per ESE §2.1 DESIGN, high-RPN items require design changes before BUILD. The following decisions address each.

*FM-04: Additive-only anchor constraint:*
REQ-ID anchors (`<a name="REQ-...">`) are inserted inline with existing text without modifying or removing any existing element. Section heading anchors (`#21-the-lifecycle`, etc.) are preserved exactly as they are throughout migration. No existing anchor is renamed, moved, or deleted during any B3-B12 migration work item. A linter check verifies section heading anchors are unchanged after each migration commit. Violation: a commit that removes or renames a section heading anchor is rejected.

*FM-07: Section atomicity:*
Each migration work item (B3-B12) covers exactly one STANDARDS.md top-level section. A section is either fully migrated (every discrete requirement carries a REQ-ID) or untouched (no REQ-IDs in that section). A partially-migrated section state (some requirements with REQ-IDs, others without, within the same section) is a gate violation. CI rejects a commit where any section contains a mix of REQ-ID and non-REQ-ID requirements. Partial migration work items do not close; a section work item closes only when the entire section passes the mixed-state check.

*FM-09: Schema append-only backward compatibility:*
The tag schema is append-only and backward-compatible. New tag positions are added only after the current last position; no existing position is renumbered, removed, or given a different meaning. Existing requirements with N positions remain valid when the current schema has more than N positions; omitted trailing positions are treated as absent (no enforcement for that dimension). A tool reading a requirement with fewer positions than the current schema never rejects the requirement solely on position count. This rule applies to all future ESE versions; any ESE release that changes an existing tag position's meaning rather than appending a new one is a breaking change and requires a new major version with a migration path.

*FM-10: Prose-line ceiling on STANDARDS.md (revised session 43):*
A CI gate counts prose lines in STANDARDS.md, excluding REQ-ID blocks (the 3-line anchor + tag + statement units defined in §4.9.1). Prose content must not exceed 1200 lines. REQ-ID blocks are structured reference data that practitioners scan by ID, not narrative content read end-to-end; including them in the total-line count produced a false constraint during B3-B11 migration (245 REQ-IDs at 4 lines each would add ~980 lines, forcing ~330 lines of prose cascade just to fit the number, defeating the readability goal). The gate counts prose only. Cascade target: `docs/req-schema.md` for reference material (framework mappings, grammar tables, extended examples). The gate is a hard block on prose growth; REQ-ID block growth is unconstrained because it does not affect prose readability.

**FMEA corrective design decisions (iteration 3, 2026-03-25):**

Five further failure modes required ADR design decisions after iteration 2 review: FM-01, FM-02, FM-03, FM-06 (severity >= 9 items requiring action regardless of RPN), and FM-08 (Severity 8, RPN 96, close to threshold). The high-severity threshold in the FMEA was also lowered from 9 to 8; all Severity >= 8 items now require explicit ADR design decisions.

*FM-01: Unique REQ-ID validator as hard-block pre-merge CI gate:*
A unique REQ-ID validator is a required CI pre-merge hard-block gate, active from B3. The validator scans STANDARDS.md and all addendum files for duplicate `<a name="REQ-...">` anchors and rejects the merge if any collision is found. This gate cannot be bypassed and is not advisory. A bypass requires removing the gate from CI configuration, which is itself a gate violation.

*FM-02: Tag schema linter on every STANDARDS.md commit:*
The tag schema linter runs as a CI pre-merge gate on every commit that modifies STANDARDS.md or any addendum file. It does not run only at enforcement-spec.yml generation time. The linter validates: (a) all required tag positions are present; (b) each position carries only a valid enum value; (c) position 5 (eval-scope) is present on every `kind:gate` requirement and absent on `kind:artifact` and `kind:advisory` requirements. Commits with invalid tag values are rejected before merge.

*FM-03: enforcement-spec.yml deletion at B3 and generator-as-CI-gate:*
Two decisions: (a) The existing hand-maintained `enforcement-spec.yml` is deleted in the B3 work item commit (first migration work item). From B3 onward, the file is generated-only; no hand-edited version exists. (b) The enforcement-spec.yml generator runs as a CI gate on every commit that modifies STANDARDS.md or any addendum file. The generated output is committed alongside the triggering change. A commit that modifies STANDARDS.md without a corresponding enforcement-spec.yml update fails CI.

*FM-06: Mode 2 (LLM-generated) rules inert-by-default:*
Mode 2 (LLM-generated) rules are inert-by-default in the generated enforcement-spec.yml. An inert rule carries `status: inert` in the generated file and produces no enforcement actions. Promotion from `status: inert` to `status: active` requires a separate commit with a recorded gate authority approval. No inert rule may be promoted to active without an approval record in the project audit trail. The inert field is machine-readable; a tool reading the spec skips inert rules silently.

*FM-08: Portable work item format backward compatibility and round-trip gate:*
Two decisions: (a) The portable work item record format is append-only and backward-compatible. New fields are optional; existing importers ignore unknown fields without error. An importer that encounters a record from a future format version treats unknown fields as absent and processes known fields normally. (b) The import round-trip test (export a set of records, import them into a fresh data store, query the result and confirm it matches the original) is a required CI gate for and cannot be deferred. does not close without this gate passing.

**Post-quality pass results (iteration 6, session 43, 2026-03-25):**

Full-corpus quality pass and §4.9.7 pre-classification completed in session 43 with results that validate and refine the design decisions above:

*FM-13 resolution (addenda ~122 ambiguous obligations):*
Classification of all 7 addenda against §4.9.7 produced: T1=42, T2=28, T3=18, T4=35, total 88 REQ-IDs. Only 3 non-binary [NB] statements found (ai-ml fallback path vagueness, event-driven idempotency strategy vagueness, containerized minimal base image lacking threshold). The original estimate of "~122 ambiguous obligations" was based on obligation keyword count, not actual ambiguity. After quality improvement passes (sessions 42-43), the vast majority of addenda obligations are already binary/observable. FM-13 RPN reduced from 252 to 54. 3 NB statements require targeted rewrite before REQ-ADD IDs are assigned in B12.

*Line budget confirmation:*
Classification map estimates 245 total REQ-IDs (157 base + 88 addenda). At 3 lines per requirement unit, base section migration (B3-B11) adds ~471 lines to STANDARDS.md. Current STANDARDS.md is 1022 lines. Cascade strategy confirmed: ~170+ lines of reference material (PDCA/DMAIC mappings, design principles list, PEG grammar tables, external standard details) move to docs/req-schema.md during migration. Additional ~123 lines of T4 narrative cascade to keep under 1200 REQ-4.9-02 ceiling.

*Quality convergence data:*
All corpus documents at F1 7/7 on 7 quality criteria (binary testability, lifecycle coverage, terminology consistency, rationale presence, cross-reference resolution, scope clarity, adoption path clarity). No further quality iteration required before B3 migration begins.

**Corpus-wide elemental unbundling results (iteration 9, session 44, 2026-03-26):**

Session 44 completed the corpus-wide elemental REQ-ID pass ( EPIC, 14 children, all closed). Results:

*REQ-ID growth:* 429 (session 43 end) to 685 (session 44 end). 256 new elemental REQ-IDs from unbundling bundled statements and adding missing gates.

*STANDARDS.md unbundling:* 30 bundled REQ-IDs in §1+§3-§9 split into elemental IDs. §2 gained 23 new elemental IDs (D0/D1/D2 discover depth, re-entry triggers, edge case AC, type-conditional close conditions, Definition of Ready, ownership transfer). §2 bundled REQ-IDs (REQ-2.1-13, REQ-2.2-01, REQ-2.2-06, REQ-2.2-10, REQ-2.3-09, REQ-2.1-10, REQ-2.8-01) also unbundled.

*Addenda unbundling:* All 7 addenda bundled REQ-IDs split into elemental. Total addenda REQ-IDs grew from 88 to 159+.

*Starters unbundling:* REQ-STR-17 (10 sections in one), REQ-STR-10 (6 layers), REQ-STR-12 (4 db items), REQ-STR-13 (5 ops items), REQ-STR-04 (5 README items), REQ-STR-06 (4 setup items), REQ-STR-07 (4 deploy items) all split into elemental IDs.

*T7 integrity manifest:* Implemented as scripts/generate-req-manifest.sh (generate/verify modes) + CI Check 7 + pre-commit hook. 556 blocks tracked. Commit 7337bd1.

*FM-07 resolved:* RPN reduced from 90 to 6. Migration complete; no partial-state risk remains.

*Runtime WIP gate fix:* fixed a session tracking defect in the work item system (WIP count never decreased on work item close).

**FMEA corrective design decisions (iteration 4, 2026-03-25):**

Three new failure modes identified during FMEA iteration 4 review: FM-11 (RPN 336), FM-12 (RPN 360), FM-13 (RPN 252). All exceed RPN 100. Required corrective decisions:

*FM-11: ADR template implementation checklist section:*
The ADR template (`templates/adr.md`) is updated with an "Implementation Checklist" section after Follow-on Requirements. This section maps the ADR's decisions to concrete deliverables with work item references, AC summaries, and dependency ordering. The purpose: an accepted ADR without an implementation path produces a decision that is never executed. The checklist makes ADR-to-work-item traceability mandatory. This template change must be committed before B3 begins because every migration work item is traced back to this ADR's checklist.

*FM-12: Template and starter YAML frontmatter with REQ-ID references:*
All 15 templates and all 8 starters are updated with YAML frontmatter before their respective migration work items (B13 templates, B14 starters). Currently 14 of 15 templates and 8 of 8 starters have no frontmatter. Required frontmatter fields: templates get `stage` (lifecycle stages this template applies at), `applies-to` (work item types), and `implements` (list of REQ-IDs this template satisfies); starters get `purpose` and `one-time-or-recurring`. The two highest-impact templates (templates/adr.md and templates/work-item.md) are updated first as pre-BUILD controls, because downstream migration work items produce ADRs and work items that reference these templates. work-item.md also gains a `req-ids` field in the body for practitioners to record which REQ-IDs each work item satisfies.

*FM-13: Addenda requirement clarification pass before REQ-ID assignment:*
The 7 addenda contain approximately 122 obligation statements, many of which are not binary or observable in their current form (e.g., "Never treat AI output as ground truth" cannot be checked by a linter). B12 (addenda migration) is expanded to include a requirement clarification pass before any REQ-ADD-{CODE} IDs are assigned. Each obligation statement is classified per §4.9.7 (Type 1 gate, Type 2 artifact, Type 3 advisory, Type 4 narrative) and rewritten to binary/observable form if Type 1 or Type 2. Statements that cannot be made binary remain as Type 3 (advisory, enforcement: soft) or Type 4 (narrative, no REQ-ID). Human review of all rewritten requirements is required before REQ-ADD IDs are assigned. This prevents the enforcement-spec.yml from containing gates that no tool can evaluate.

---

## Consequences

### Positive

- **Single source of truth:** changing a requirement in STANDARDS.md is the only action needed; all derived artifacts regenerate automatically
- **Full coverage:** enforcement-spec.yml can cover 300+ requirements vs. current 31 ceiling; coverage is bounded only by how many REQ-IDs are written
- **Bidirectional traceability:** given a REQ-ID, navigate directly to the requirement in STANDARDS.md via URL fragment; given STANDARDS.md text, find the REQ-ID inline
- **No inference required:** a tool reading STANDARDS.md can extract type+addenda-specific requirement sets from tag values alone
- **Human readable:** named anchors are invisible in rendered markdown; bold REQ-IDs and inline backtick tags are visible but compact; prose narrative is unchanged
- **Eliminates dual-maintenance:** enforcement-spec.yml hand-maintenance was a growing burden with every STANDARDS.md change

### Negative

- **Migration cost:** all 66 numbered subsections of §1-§9, all 7 addenda, all 15 templates, all 8 starters require restructuring. Estimated: significant multi-session effort
- **Tooling required for full benefit:** extracting type+addenda-specific requirement sets requires a parser; practitioners without the parser still benefit from human-readable REQ-IDs but must manually cross-reference tags
- **Breaking change for adopters with section-anchor tooling:** projects referencing `#22-work-item-discipline` section anchors are unaffected (section headings unchanged); projects with custom tooling referencing STANDARDS.md line numbers may need updates
- **applies-when grammar (B1 decision):** compound expressions use PEG (Parsing Expression Grammar) notation. PEG is unambiguous by construction: ordered choice eliminates the ambiguity that EBNF requires a precedence table to resolve. AND binds before OR through separate `and-expr`/`or-expr` productions; NOT is right-recursive. The grammar maps directly to a recursive-descent parser with one function per rule; no additional design decisions are needed. Full grammar in `docs/product/sec-4-9-requirement-format-draft.md` §4.9.4; will move to STANDARDS.md §4.9 on acceptance.
- **STANDARDS.md line count growth (migration math):** adding ~300 requirement units at 3 lines each adds approximately 900 lines. STANDARDS.md currently has ~900 lines; the post-migration total will be approximately 1800 lines, breaching the FMEA FM-10 ceiling of 1200 lines by 50%. The 1200-line ceiling cannot be satisfied as post-migration cleanup. Each section work item (B3-B12) must include a line-count gate check and cascade step as part of its AC before the work item closes. Reference material (valid-values tables, grammar, extended examples) cascades to `docs/req-schema.md` (created during B3-B12 as needed); normative requirement statements remain in STANDARDS.md.

---

## Alternatives Considered

### Separate maintained requirements-matrix.yaml

Maintain a YAML file mapping type × addenda → required artifacts per stage, alongside enforcement-spec.yml. Rejected: creates three sources of truth (STANDARDS.md + enforcement-spec + requirements-matrix). Every requirement change touches three files. ESE's own §4.7 and ADR-007 prohibit this. The maintenance burden compounds with every STANDARDS.md edit.

### Machine-readable index only (no STANDARDS.md restructuring)

Add a `docs/requirement-index.yaml` mapping REQ-IDs to STANDARDS.md sections without changing STANDARDS.md prose. Rejected: does not solve the inline addressability problem; a tool still cannot navigate from REQ-ID to the exact requirement text without section-level search and inference. The index would be a maintained parallel file - same dual-maintenance problem.

### LLM-only enforcement (no structured format)

Let the enforcement tool use LLM inference for all gate evaluation, reading STANDARDS.md prose directly. Rejected: fails open when LLM unavailable; probabilistic rather than deterministic; cannot be validated with a linter; coverage is bounded by LLM reliability not by specification completeness. Deterministic enforcement is required for the 300+ hard-block gates.

### Separate spec file with generator (keep STANDARDS.md unchanged)

Generate enforcement-spec.yml from STANDARDS.md using NLP extraction rather than structured tags. Rejected: NLP extraction is probabilistic; requires LLM inference; cannot achieve 99% coverage reliably; any STANDARDS.md edit may silently change extracted requirements without detection. Structured tags in STANDARDS.md are the only approach that makes extraction deterministic.

---

## Per-Document Impact Analysis

> Required by [REQ-4.2-10](../../STANDARDS.md#req-4210) for ADRs modifying existing components, APIs, interfaces, or standards.

| Document | Change required | Notes |
|---|---|---|
| STANDARDS.md | Yes: §4.9 machine-readable format section added; REQ-IDs throughout §1-§9; REQ-4.9-02 deprecated; §1.5 external imposition guidance added; §4.2 per-document impact analysis requirement added | Primary artifact of this ADR |
| docs/addenda/ai-ml.md | Yes: LLM-Generated Enforcement Rules section added (REQ-ADD-AI-30 through -35) | Required for Mode 2 standard |
| docs/addenda/containerized-systems.md | Yes: REQ-ADD-CTR-XX IDs added | Migration |
| docs/addenda/continuous-improvement.md | Yes: REQ-ADD-CI-XX IDs added | Migration |
| docs/addenda/event-driven.md | Yes: REQ-ADD-EVT-XX IDs added | Migration |
| docs/addenda/multi-service.md | Yes: REQ-ADD-MS-XX IDs added | Migration |
| docs/addenda/multi-team.md | Yes: REQ-ADD-MT-XX IDs added | Migration |
| docs/addenda/web-applications.md | Yes: REQ-ADD-WEB-XX IDs added | Migration |
| docs/adoption.md | Yes: REQ-ADO-XX IDs added | Migration |
| templates/adr.md | Yes: dfmea/pfmea/architecture-doc frontmatter fields added; Per-Document Impact Analysis section added; Implementation Checklist section added | FM-11, FM-12, REQ-4.2-10 |
| templates/fmea.md | Yes: YAML frontmatter added | FM-12 |
| templates/work-item.md | Yes: req-ids field added; YAML frontmatter added | FM-12 |
| Remaining 12 templates | Yes: YAML frontmatter added to all | FM-12 |
| All 8 starters | Yes: YAML frontmatter added to all | FM-12 |
| enforcement-spec.yml | Yes: new generated artifact (T6); 357 gates; status/mode fields added for Mode 2 | Generated, not maintained |
| enforcement-spec-mode2-candidates.yml | Yes: new generated artifact for Mode 2 candidate rules (all status: inert) | Generated by generate-mode2-candidates.sh |
| docs/requirement-index.md | Yes: replaced manually-maintained domain index with generated scope/applies-when index (B15) | Generated by generate-req-index.sh |
| docs/req-schema.md | Yes: deleted (cascade reversed per Nick Baker decision) | |
| req-manifest.sha256 | Yes: new generated artifact (T7); one SHA-256 block per REQ-ID | Generated, not maintained |

---

## Validation

**Pass condition:** A tool reading STANDARDS.md and all 7 addenda produces enforcement-spec.yml covering 300+ gates. Running the 12-requirement proof for type=improvement + web + CI against restructured STANDARDS.md returns all 12 requirements from structured tag parsing alone, with no prose reading required.

**Trigger:** Completion of B3-B12 (§1-§9 migration) and B12 (addenda migration). First full enforcement-spec.yml generation from restructured source.

**Failure condition:** After full migration, the generator produces fewer than 250 gates (indicating requirements were not correctly structured); OR a tool must read prose to determine any of the 12 proof requirements (indicating applies-when tags are insufficient).

**Validation result (2026-03-26):** PASS. Trigger satisfied: B3-B12 complete, enforcement-spec.yml generated from restructured source. Pass condition met: generate-enforcement-spec.sh produces 361 gates (exceeds 300 floor). The type=improvement + addendum:WEB + addendum:CI proof returns 553 matching requirements from structured tag parsing alone with zero prose reading required. Failure condition NOT triggered: 361 > 250 and all requirements resolved from applies-when tags. ADR fully implemented.

---

## Follow-on Requirements

**FMEA required:** Yes
**DFMEA:** [DFMEA-2026-03-25-ese-machine-readable-first-restructuring.md](DFMEA-2026-03-25-ese-machine-readable-first-restructuring.md)  -  analyzes what can fail in the restructured format components
**PFMEA:** [PFMEA-2026-03-26-ese-process-sequences.md](PFMEA-2026-03-26-ese-process-sequences.md)  -  analyzes what can fail in the process of following ESE

---

## Implementation Checklist

> This section does not exist in the current ADR template (templates/adr.md). Its absence is a gap: ADRs that make architectural decisions without specifying how to implement them produce decisions that are accepted but not executed. A work item to add this section to the ADR template is required (see FM-11 in FMEA).

**Pre-BUILD CI tooling (must be passing before B3):**

| # | Deliverable | Maps to | AC |
|---|---|---|---|
| T1 | Unique REQ-ID validator | FM-01 | **DONE** (session 43, commit c047cf0). scripts/validate-req-ids.sh + CI Check 5 + pre-commit. |
| T2 | Tag schema linter | FM-02 | **DONE** (session 43, commit c047cf0). scripts/lint-req-tags.sh + CI Check 6 + pre-commit. |
| T3 | Obligation linter (lint-obligations.sh) | FM-07 | **DONE** (, commit ad545e6). CI Check 12 + pre-commit. Warns on unclassified obligations. |
| T4 | STANDARDS.md prose-line-count gate | FM-10 | **N/A**. Ceiling was arbitrary; removed per Nick Baker decision. REQ-4.9-02 deprecated. lint-prose-line-count.sh deleted. §4.7 qualitative test is the control. |
| T5 | Section heading anchor linter | FM-04 | **DONE** (, commit 1119aa2). scripts/lint-section-anchors.sh + 183-anchor baseline + CI Check 16 + pre-commit. |
| T6 | enforcement-spec.yml generator | FM-03 | **DONE**. scripts/generate-enforcement-spec.sh generates enforcement-spec.yml with 361 hard gates from kind:gate REQ-IDs. CI Check 20 + pre-commit auto-regenerate. |
| T7 | REQ-ID integrity manifest | FM-03, FM-09 | **DONE** (session 44, commit 7337bd1). scripts/generate-req-manifest.sh + CI Check 7 + pre-commit. 733 blocks (req-manifest.sha256). |

**Section migration (B3-B16, sequential after T1-T6 passing):**

| # | Scope | Notes |
|---|---|---|
| B3 | §1 migration + delete existing enforcement-spec.yml | **DONE** (commit a405e40). 10 requirement units (REQ-1.1-01 through REQ-1.4-01). enforcement-spec.yml was not present in this repo (N/A). |
| B4 | §2 migration (includes re-entry triggers + edge case AC) | **DONE** (session 44). 23 new elemental REQ-IDs. |
| B5-B11 | §3-§9 migration | **DONE** (session 44). All sections unbundled. |
| B12 | 7 addenda migration (REQ-ADD-{CODE}-{seq}) | **DONE** (session 44 children). All 7 addenda unbundled. |
| B13 | 15 templates: YAML frontmatter with `stage`, `applies-to`, `implements` (REQ-ID list) | **DONE** (session 43+44). All 15 have frontmatter + implements fields. |
| B14 | 8 starters: YAML frontmatter with `purpose`, `one-time-or-recurring` | **DONE** (session 43). All 8 have frontmatter. REQ-STR unbundled in session 44. |
| B15 | requirement-index.md generator | **DONE**. scripts/generate-req-index.sh generates docs/requirement-index.md organized by lifecycle scope and applies-when. 727 active REQ-IDs. CI Check 19 verifies freshness. Pre-commit auto-regenerates on corpus changes. |
| B16 | adoption.md update for new structure | **DONE** (session 44). 31 [pending] entries assigned. 0 pending remain. |

**Addenda clarification (required before B12, maps to FM-13):**

| # | Addendum | Code | Current obligation statements | Action |
|---|---|---|---|---|
| A1 | ai-ml.md | AI | ~27 | Classify per §4.9.7; rewrite Type 1/2 to binary form; human review |
| A2 | continuous-improvement.md | CI | ~16 | Same |
| A3 | web-applications.md | WEB | ~16 | Same |
| A4 | event-driven.md | EVT | ~17 | Same |
| A5 | multi-service.md | MS | ~17 | Same |
| A6 | multi-team.md | MT | ~16 | Same |
| A7 | containerized-systems.md | CTR | ~13 | Same |

Total: ~122 obligation statements across 7 addenda. After clarification, each earns a REQ-ADD-{CODE}-{seq} ID or stays as prose.

**Template and starter revisions (cross-cutting, maps to FM-11 and FM-12):**

| Artifact | Change needed | Maps to |
|---|---|---|
| templates/adr.md | Add Implementation Checklist section; add YAML `stage`, `applies-to`, `implements` | FM-11, FM-12 |
| templates/fmea.md | Add YAML frontmatter: type, id, title, status, date, owner, adr | FM-12 |
| templates/work-item.md | Add `req-ids` field in body; add YAML frontmatter | FM-12 |
| Remaining 12 templates | Add YAML frontmatter: `stage`, `applies-to`, `implements` (REQ-ID list) | FM-12 |
| All 8 starters | Add YAML frontmatter: `purpose`, `one-time-or-recurring` | FM-12 |

**Data store (, independent track):**

| Deliverable | Maps to | AC |
|---|---|---|
| Round-trip CI gate | FM-08 | **DONE**. lint-work-item-export.sh validates work-item-export.md format: frontmatter present, required fields, round-trip parse consistency. CI Check 21 + pre-commit. broader design work (directory structure at scale) is a separate open work item. |

**CI addendum DESIGN requirements (DoE, SMED):**

*Design of Experiments:* The key variables in the machine-readable format design are: (1) tag schema complexity (2-tag vs. 4-tag), (2) REQ-ID granularity (section-level vs. requirement-level), (3) applies-when syntax (simple vs. compound). These interact: a 2-tag schema with simple applies-when is unambiguous but incomplete; a 4-tag schema with compound applies-when is complete but complex. DoE is not practical here as physical experiments - the decision is made by reasoning about coverage vs. parse complexity tradeoffs documented in this ADR and the FMEA. Variables assessed: tag schema = 4-tag (complete); REQ-ID granularity = requirement-level (bidirectional traceability requires it); applies-when syntax = compound expressions with formal grammar (B1 deliverable).

*SMED:* The setup time concerns for this migration are:
- Time to apply the new format to one STANDARDS.md section: target < 2 hours per section (B3-B11 scope)
- CI pipeline feedback for REQ-ID validation: target < 5 minutes (unique ID validator + tag linter)
- Migration verification per section: grep-based, < 1 minute per section

Current baseline (before migration): no CI validation on STANDARDS.md structure. Setup time for applying format: B1 is complete; the format spec and tag schema are defined. SMED measurement: run B3 (§1 migration) as the proof-of-concept timing measurement against the target of under 2 hours; use that to reforecast B4-B11.
