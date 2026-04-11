---
type: adr
id: ADR-2026-03-28
title: "Lightweight pre-intake items as compliant D0 capture for agent-originated signals"
status: Proposed
date: 2026-03-28
deciders: "Gate authority (see standards-application.md)"
stage:
  - design
applies-to: all
implements:
  - REQ-2.1-19
dfmea: ~
pfmea: ~
architecture-doc: ~
---

# ADR-022: Lightweight Pre-Intake Items as Compliant D0 Capture for Agent-Originated Signals

## Table of Contents

- [Context](#context)
- [Decision](#decision)
- [Consequences](#consequences)
- [Alternatives Considered](#alternatives-considered)
- [Validation](#validation)
- [Per-Document Impact Analysis](#per-document-impact-analysis)
- [Follow-on Requirements](#follow-on-requirements)
- [Implementation Checklist](#implementation-checklist)

---

## Context

ESE §2.1 DISCOVER D0 defines the capture stage target: "Record raw observation and source.
Target: under 2 minutes." D0 exists because the cost of capturing a signal is lower than
the cost of losing it. The full D1 triage decision (promote, investigate, park, discard)
follows D0 and is a separate step.

When engineering work involves AI agents (automated sessions processing signals faster than
a human operator can review them), a volume and speed problem emerges: the agent may observe
dozens of potential signals per session, far more than can be manually promoted to full work
items in real time. Two failure modes result:

**Failure mode A: Over-filing.** The agent creates a full work item for every observation,
triggering the full DEFINE checklist (acceptance criteria, scope, owner, priority). Full
work items require more than 2 minutes to file correctly. At high observation volume, the
agent's critical path is consumed by work item creation overhead. The work item backlog
fills with low-quality, premature items.

**Failure mode B: Under-filing.** The agent notes observations but does not file them
because the work item overhead is too high. Observations are lost.

Neither failure mode satisfies REQ-2.1-19 (every observed signal has a D0 intake log entry).

**The core question:** Must D0 capture be a full work item? Or can a compliant D0 record
be lighter than a full DEFINE-stage work item?

Reading §2.1 closely: D0 requires only "raw observation and source." D1 (triage) is what
requires the triage decision. The intake log `starters/intake-log.md` format is: date,
source, observation (one sentence). This is lighter than a full work item, by design.

The gap: for teams using a tracked work item system, the system
naturally replaces `starters/intake-log.md`. But if the tracked system's creation workflow
requires full DEFINE fields, D0 capture becomes D1+ work. The intake log template's
lightweight format is lost.

**Cost of doing nothing:** Teams using AI agents must either over-file (polluting the work
item backlog with premature items) or under-file (losing REQ-2.1-19 compliance). Neither is
sustainable at scale.

**Supersedes:** N/A (new guidance, not replacing an existing approach).

---

## Decision

A compliant D0 record does NOT require the full DEFINE checklist. A D0 record requires:
- The raw observation (one sentence minimum)
- The source (what session, process, or signal generated it)
- Captured in under 2 minutes

A "lightweight pre-intake item" satisfies D0 when it records the observation and source in
the tracked work item system, WITHOUT requiring the full DEFINE fields (acceptance criteria,
scope, owner, priority). The lightweight item is explicitly not a work item; it is a D0
capture record pending D1 triage.

Teams implementing this pattern must satisfy ALL of the following to claim REQ-2.1-19:

1. **Capture is fast:** The lightweight item creation path has no DEFINE gates (no AC
   required, no scope sections, no approval required). Target: under 30 seconds per item.

2. **Triage is scheduled:** The operator defines a triage cadence (recommended: daily
   review for items older than 4 hours, mandatory review before items expire). Triage
   cadence is documented in the project's `docs/standards-application.md`.

3. **Triage produces a D1 decision:** Each lightweight item is either promoted (becomes a
   full work item with DEFINE fields), parked (given a revisit date), or discarded (with
   reason recorded). No item remains untriaged indefinitely.

4. **Expiry is bounded:** Lightweight items that are not triaged within a defined window
   (recommended: 7 days) expire automatically. Expiry is not loss; it is the "discard"
   D1 decision applied by default. Teams must document their expiry window in
   `docs/standards-application.md`.

5. **Full work items remain gated:** The existence of lightweight items does NOT relax the
   DEFINE requirements for full work items. Every promoted lightweight item must satisfy
   the full §2.2 work item checklist before its D1 promotion is complete.

**What this ADR does NOT permit:**

- Creating lightweight items and never triaging them (no triage cadence = not compliant)
- Using lightweight items as a substitute for full work items (lightweight items are D0
  records, not D1 work items; the triage step is mandatory)
- Bypassing DEFINE gates on work items by routing all work through lightweight items

---

## Consequences

### Positive

- D0 capture by agents is fast enough to be practical: under 30 seconds per observation
- The DISCOVER stage is actually followed, not circumvented
- Volume of low-quality premature full work items drops significantly
- Teams with AI agents (automated sessions) have a compliant, workable D0 path

### Negative

- Requires a triage cadence. Teams that do not establish and follow the cadence will
  accumulate untriaged items and lose signals. The compliance obligation shifts from
  "file a full item immediately" to "file a lightweight item immediately AND triage it
  within the defined window."
- Teams must document the expiry window and triage cadence in `docs/standards-application.md`.
  This is an obligation, not optional.
- The boundary between "observation worth capturing" and "noise not worth capturing" is
  not defined by this ADR. Teams must exercise judgment. Over-capture is acceptable
  (items expire); under-capture is not (signals are lost).

---

## Alternatives Considered

| Alternative | Why rejected |
|---|---|
| Require full work items for every AI agent observation | D0 target of under 2 minutes is violated at scale. Agents produce signals faster than full items can be filed correctly. Result: over-filing of low-quality items or under-filing of signals. |
| Treat agent observations as informal notes (no tracking) | Violates REQ-2.1-19. Observations in informal notes are not in the tracked system and are not subject to triage. |
| Lower the DEFINE bar globally (fewer required fields) | Changes the quality of all work items, not just D0 captures. DEFINE gates exist for correctness. Weakening them to solve a D0 volume problem degrades the entire work item lifecycle. |
| Separate intake log file alongside the tracked system | Dual-system: intake log for D0, tracked system for D1+. Synchronization overhead. The lightweight item pattern is simpler: everything is in one tracked system, lightweight items are just a pre-intake state. |

---

## Validation

**Pass condition:** For any team adopting this pattern, all five are true: (1)
`docs/standards-application.md` documents the triage cadence and expiry window;
(2) lightweight items are created in under 30 seconds (time the creation path from
observation to record); (3) a triage session is conducted on schedule and each item
receives a documented D1 decision (promote / park / discard); (4) no lightweight item
remains in the system past its defined expiry without a documented reason for extension;
(5) promoted items satisfy full §2.2 checklist before their D1 triage is recorded as
complete.

**Trigger:** First team deployment of a tracked system that implements the lightweight item
pattern (e.g., a tracked system's lightweight item implementation).

**Failure condition:** Lightweight items accumulate past the defined expiry window without
triage decisions recorded. This indicates the triage cadence is not being followed and
REQ-2.1-19 is not satisfied despite the lightweight items existing.

---

## Per-Document Impact Analysis

| Document | Change required | Notes |
|---|---|---|
| `STANDARDS.md §2.1 DISCOVER` | No: confirmed. §2.1 already defines D0 as "raw observation and source" with no DEFINE field requirement | Confirmed no change required |
| `starters/intake-log.md` | No: confirmed. Intake log template already uses lightweight format consistent with this ADR | Confirmed no change required |
| `starters/standards-application.md` | Yes: add triage cadence and expiry window fields | Teams must document their cadence per decision item 2 and 4 |
| `docs/adoption.md` | Yes: add reference to this ADR in D0 capture guidance section | Practitioners need to find this pattern during adoption |
| `templates/work-item.md` | No: confirmed. This ADR does not change the DEFINE requirements for full work items | Confirmed no change required |

---

## Follow-on Requirements

**FMEA required:** No. This ADR documents an ESE standard clarification. It introduces no new component, no data mutation, and no external integration. It changes how D0 compliance is interpreted, not how systems are built.
**FMEA path:** N/A.

---

## Implementation Checklist

**Pre-BUILD controls (must be passing before implementation begins):**

No pre-BUILD controls required. This ADR is a standards clarification document, not a
software implementation. Teams adopting the lightweight item pattern implement it per their
tracked system's capabilities.

**Template and artifact revisions:**

| Artifact | Change needed | Work Item |
|---|---|---|
| `starters/standards-application.md` | Add triage cadence and expiry window fields to the standards-application template | TBD (file when implementing) |
| `docs/adoption.md` | Add reference to ADR-022 in D0 capture guidance | TBD |
