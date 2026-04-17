# Architecture: ESE Machine-Readable Enforcement System

> Required by [§3.1](../../STANDARDS.md#31-component-architecture-template) for new components.
> This document covers: (1) machine-readable STANDARDS.md format, (2) enforcement-spec.yml
> generator, (3) portable work item data store model.
> See also: [DFMEA-2026-03-25-ese-machine-readable-first-restructuring.md](../decisions/DFMEA-2026-03-25-ese-machine-readable-first-restructuring.md)

**Component:** ESE Machine-Readable Enforcement System
**Version:** 0.1 (design; not yet built)
**Date:** 2026-03-25
**Owner:** gate authority

---


## Table of Contents

- [Purpose](#purpose)
- [Intended Goals (measurable)](#intended-goals-measurable)
- [Current State vs. Intended State](#current-state-vs-intended-state)
- [Components](#components)
- [Interface Diagram](#interface-diagram)
- [Data Flows](#data-flows)
- [Failure Modes](#failure-modes)
- [Boundaries](#boundaries)
- [Dependencies](#dependencies)
- [Open Decisions](#open-decisions)

## Purpose

Enable any agent (human or machine) to determine the complete compliance requirement set for any work item scenario without cross-section inference, and to track work item history portably across any team, any work item system, and any number of domain transitions.

---

## Intended Goals (measurable)

- **Requirement addressability:** 100% of gate requirements have a unique REQ-ID and inline metadata. Measured by: `generate-req-manifest.sh verify` returns zero drift.
- **Enforcement coverage:** enforcement-spec.yml contains all `kind:gate` requirements from STANDARDS.md and addenda. Measured by: `generate-enforcement-spec.sh verify` returns PASS.
- **Format correctness:** zero REQ-ID tag schema violations. Measured by: `lint-req-tags.sh` returns PASS.

---

## Current State vs. Intended State

| Dimension | Current | Target | Gap | Work Item ID |
|-----------|---------|--------|-----|-------------|
| Machine-readable format | Complete (764 REQ-IDs, 320 gates) | Complete | None | - |
| enforcement-spec.yml | Generated, CI-verified | Generated, CI-verified | None | - |
| Portable work item data store | Under investigation | Format selected, round-trip tested | Format not selected | lifecycle container model investigation |

---

## Components

### Component 1: Machine-Readable STANDARDS.md

**What it is:** STANDARDS.md restructured so every discrete requirement is an addressable unit with inline metadata. The document remains human-readable prose; requirements are embedded as structured blocks within the narrative.

**Requirement unit format:**
```
<a name="REQ-2.2-01"></a>
**REQ-2.2-01** `gate` `define` `hard` `all`
A work item title states what is wrong and what correct looks like.
```

**Tag schema (positional, all four required):**
1. `kind`: `gate` | `artifact` | `advisory`
2. `scope`: ESE lifecycle stage name - `discover` | `define` | `design` | `build` | `verify` | `document` | `deploy` | `monitor` | `close` | `commit` | `session-start` | `session-end` | `continuous`
3. `enforcement`: `hard` | `soft` | `none`
4. `applies-when`: `all` | `type:{name}` | `addendum:{code}` | compound expression

**REQ-ID scheme:**
- Base sections §1-§9: `REQ-{section}-{seq:02d}` e.g. `REQ-2.2-01`
- Addenda: `REQ-ADD-{CODE}-{seq:02d}` where codes are `WEB`, `AI`, `CI`, `EVT`, `MS`, `CTR`, `MT`
- IDs are immutable once published. Deprecated requirements retain their ID with `deprecated: true` tag.

**Prose vs. requirement distinction:**
- Requirement block: `<a name>` anchor + bold REQ-ID + inline tags + one binary observable sentence
- Narrative prose: surrounding text without REQ-IDs - principles, rationale, context, examples
- A practitioner reading prose gets the why; a tool parsing REQ-IDs gets the what

**Failure modes:** FM-01 (collisions), FM-02 (wrong tags), FM-05 (ambiguous applies-when), FM-09 (ID reuse), FM-10 (file length). Controls: see FMEA.

---

### Component 2: enforcement-spec.yml Generator

**What it is:** A script that reads all `kind:gate` REQ-IDs from STANDARDS.md and the 7 addenda and produces `enforcement-spec.yml` as a build artifact.

**Inputs:** STANDARDS.md, docs/addenda/*.md
**Output:** docs/enforcement-spec.yml (generated; not committed to git as a maintained file)
**Trigger:** CI gate on every STANDARDS.md or addenda commit

**Output schema (per gate):**
```yaml
- req-id: REQ-2.2-01
 source: "§2.2"
 kind: gate
 scope: define
 enforcement: hard
 applies-when: all
 statement: "A work item title states what is wrong and what correct looks like."
 anchor: "#REQ-2.2-01"
```

**Coverage:** 313 gates generated from `kind:gate` REQ-IDs across STANDARDS.md and addenda. Target of 300+ gates achieved.

**AI/ML component (enforcement analyzer Mode 2, planned):** LLM would supplement the deterministic generator for complex conditions requiring natural language evaluation. Mode 2 rules would default to soft-block until verified F1 ≥ 0.85. Hard-block requires explicit gate authority promotion. Autonomy level: Assisted (human approves before activation). See AI/ML addendum requirements in FMEA. Currently not implemented; `generate-mode2-candidates.sh` identifies candidate rules but no Mode 2 entries exist in enforcement-spec.yml.

**Failure modes:** FM-03 (divergence), FM-06 (LLM rules activate unreviewed). Controls: generator runs on every commit; stale spec is CI failure; LLM rules gated behind approval.

---

### Component 3: Portable Work Item Data Store

**What it is:** A format and protocol for storing work item lifecycle records in a way that is portable across domain transitions, importable into the tracked work item system on re-entry, and readable by teams without that system.

**Status:** Under investigation (lifecycle container model). Format not yet selected.

**Candidates under evaluation:**
- JSONL: zero infrastructure, git-native, no structured querying
- SQLite/libSQL: embedded, queryable with sqlite3/standard SQL, binary git diff
- Turso (libSQL cloud): runtime-compatible, distributed, embedded export mode
- Postgres: requires infrastructure, not portable

**Requirements the format must satisfy:**
- Portable: travels as a committed file with the repo
- Importable: tracked system reads it on re-entry without transformation
- Queryable: "all work items satisfying REQ-2.2-01" answerable with standard tooling
- Scalable: handles 50k+/year records without degrading performance
- System-agnostic: works with any work item system; IDs are system-native

**Record structure (system-agnostic; format TBD):**
```
id: system-native ID (#1047, WI-4523, ENG-1047)
type: ESE type (feature, bug, investigation, ...)
title: work item title
req-ids: [REQ-2.2-01, REQ-4.2-03, ...] # requirements satisfied
ac: acceptance criteria text
closed: ISO date
gate-evidence: evidence summary
committed-artifacts: [relative paths to ADRs, FMEAs, post-mortems]
domain-period: {entered: date, exited: date} # supports multi-transition history
```

**Re-entry protocol (provisional):**
1. Repo enters domain: tracked system reads portable record file, imports history
2. New work appends to data store with domain-period tracking
3. Repo exits domain: tracked system exports updated portable record file, commits to repo
4. Repeat for each domain transition - history is additive

**File-when-produced protocol (provisional):**
- DEFINE: initial record created (id, type, title, ac, req-ids)
- CLOSE: record completed (gate-evidence, committed-artifacts, closed date)
- Domain exit: portable format committed to repo

**Failure modes:** FM-08 (format incompatible with tracked system import). Control: import round-trip test required before format is finalized.

---

## Interface Diagram

```
STANDARDS.md (machine-readable-first)
 |
 |-- kind:gate REQ-IDs --> [Generator] --> enforcement-spec.yml (build artifact)
 | |
 | Enforcement Analyzer
 | (reads spec, generates runtime gates)
 |-- kind:artifact REQ-IDs --> [Tool] --> requirements-matrix view
 |
 |-- all REQ-IDs + anchors --> [Human] --> direct URL navigation
 STANDARDS.md#REQ-2.2-01

Work Item Lifecycle
 |
 |-- DEFINE --> data store record created (id, type, ac, req-ids)
 |-- CLOSE --> data store record completed (gate-evidence, artifacts)
 |-- Domain exit --> portable format committed to repo
 |-- Domain entry --> tracked system imports portable format, resumes
```

---

## Dependencies

| Dependency | Version | Purpose |
|---|---|---|
| STANDARDS.md | Post-migration | Source of truth for all REQ-IDs |
| Tracked work item system | Current | Data store host while in domain |
| Data store format | TBD | Portable work item records |
| CI pipeline | Existing | Runs generator + linter on STANDARDS.md commits |

---

## Data Flows

1. **Standards authoring flow:** Author edits STANDARDS.md or addenda -> CI runs `generate-enforcement-spec.sh` -> enforcement-spec.yml regenerated -> `verify` mode confirms no drift
2. **Requirement validation flow:** CI runs `validate-req-ids.sh` + `lint-req-tags.sh` -> all 764 REQ-IDs validated for uniqueness and tag schema conformance
3. **Work item export flow:** Tracked system exports closed work item -> `work-item-export.md` template applied -> committed to `docs/work-items/` -> `lint-work-item-export.sh` validates format

---

## Failure Modes

| Failure | Impact | Mitigation | Recovery |
|---------|--------|------------|----------|
| FM-01: REQ-ID collision | Two requirements share an ID; enforcement rules misfire | `validate-req-ids.sh` CI check (uniqueness scan) | Fix duplicate, regenerate manifests |
| FM-02: Wrong tags on REQ-ID | Gate enforced at wrong scope or enforcement level | `lint-req-tags.sh` CI check (tag schema validation) | Correct tags, regenerate spec |
| FM-03: enforcement-spec.yml divergence | Spec does not match STANDARDS.md source | `generate-enforcement-spec.sh verify` CI check | Regenerate with `generate` mode |
| FM-05: Ambiguous applies-when | Unclear which projects a requirement activates for | Manual review during authoring | Clarify applies-when expression |
| FM-08: Portable format incompatible | Work item records cannot round-trip between systems | Import round-trip test (planned) | Select compatible format |
| FM-09: ID reuse after deprecation | Deprecated ID reused for new requirement | `validate-req-ids.sh` enforces global uniqueness | Assign new ID |

---

## Boundaries

What this component does NOT do:
- Does not enforce requirements at runtime (enforcement is CI-time only)
- Does not prescribe which CI system to use (any system that runs bash scripts is compatible)
- Does not generate or interpret Mode 2 (LLM-assisted) rules without explicit gate authority promotion
- Does not manage work item lifecycle state (the tracked work item system owns lifecycle)
- Does not replace human review for STANDARDS.md changes (gate authority review is always required)

---

## Open Decisions

| Decision | Owner | Work Item |
|---|---|---|
| Data store format (JSONL vs SQLite vs libSQL/Turso) | gate authority | lifecycle container model investigation |
| Artifact storage model (10-15 artifacts per work item: data store vs. committed markdown) | gate authority | lifecycle container model investigation |
| applies-when formal grammar | TBD at B1 (format definition work item) | B1 |
| STANDARDS.md line count ceiling before §4.7 cascade triggers | TBD at B1 | B1 |

---

*Date: 2026-03-25*
*Status: Draft - open decisions must be resolved before BUILD*
