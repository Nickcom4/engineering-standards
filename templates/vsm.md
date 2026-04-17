---
type: vsm
stage:
  - design
applies-to:
  - addendum:CI AND type:improvement
implements:
  - REQ-ADD-CI-01
---

# Value Stream Map: {Title}

<a name="REQ-TPL-66"></a>
**REQ-TPL-66** `advisory` `continuous` `soft` `addendum:CI`
Value stream map archives the current-state baseline for a delivery process before improvement work begins.

> Value stream map archives the current-state baseline for a delivery process before improvement work begins. Required by [REQ-ADD-CI-01](../docs/addenda/continuous-improvement.md) when `addendum:CI` is active and a `type:improvement` work item is filed. The map draws observations from at least 10 completed work items; memory and estimates are not acceptable. The archived map is the baseline against which the claimed improvement is later verified per [§7.7](../STANDARDS.md#77-measurement-system-analysis).
>
> **Where this fits:** the improvement work item cites this map as a baseline dependency. The linter verifies the citation resolves to a file in the `docs/improvement/vsm/` archive. Without an archived baseline, cross-cycle comparison is not possible and improvement claims cannot be falsified.

---

## Purpose and Context

<a name="REQ-TPL-67"></a>
**REQ-TPL-67** `advisory` `continuous` `soft` `addendum:CI`
The improvement arc and the trigger that motivated the map are stated before measurement begins.

> [REQ-ADD-CI-01](../docs/addenda/continuous-improvement.md): current-state value stream mapped before improvement.

**Improvement arc:** {description of the improvement initiative; link the work item once filed}

**Scope of the map:** {the delivery process being mapped; the boundary of included stages}

**Why now:** {what signal triggered this mapping; recurring delay, defect cluster, capacity complaint, throughput plateau}

**Representative work item class:** {which class of work items the measurements are drawn from}

---

## Current-State Map

> Each stage is a box; each handoff is an arrow. Record active time (work in progress), wait time (work sitting waiting), and first-pass yield (percentage proceeding to the next stage without rework).

| Stage | Active time (avg) | Wait time (avg) | First-pass yield | Ownership |
|-------|-------------------|-----------------|------------------|-----------|
| {stage name} | {duration} | {duration} | {percent} | {team or role} |

**Total lead time:** {sum of active time and wait time across all stages}

**Value-added time:** {sum of active time only}

**Value-added ratio:** {value-added divided by total; a 5 percent ratio identifies 95 percent of lead time as waste opportunity}

---

## Measured Observations

<a name="REQ-TPL-68"></a>
**REQ-TPL-68** `advisory` `continuous` `soft` `addendum:CI`
Observations are sourced from at least 10 completed work items with the measurement method named per item.

> [REQ-ADD-CI-01](../docs/addenda/continuous-improvement.md): active time and wait time values are sourced from data on at least 10 completed work items, not from memory or estimates.

| # | Work item or event | Measurement method | Observed value |
|---|---------------------|---------------------|----------------|
| 1 | {ID or descriptor} | {how measured; timestamp, log query, tracker field} | {value} |
| 2 | {ID or descriptor} | {how measured} | {value} |
| 3 | {ID or descriptor} | {how measured} | {value} |
| 4 | {ID or descriptor} | {how measured} | {value} |
| 5 | {ID or descriptor} | {how measured} | {value} |
| 6 | {ID or descriptor} | {how measured} | {value} |
| 7 | {ID or descriptor} | {how measured} | {value} |
| 8 | {ID or descriptor} | {how measured} | {value} |
| 9 | {ID or descriptor} | {how measured} | {value} |
| 10 | {ID or descriptor} | {how measured} | {value} |

**Observation count:** {total; must be 10 or more}

**Data source:** {tracker, logs, dashboard, or combination; named specifically so the measurement is reproducible}

---

## Bottleneck Identification

<a name="REQ-TPL-69"></a>
**REQ-TPL-69** `advisory` `continuous` `soft` `addendum:CI`
The three largest wait times are identified with stage name, measured duration, and the evidence that the stage binds throughput.

> [REQ-ADD-CI-01](../docs/addenda/continuous-improvement.md): the three largest wait times are identified by stage name and measured duration.

| Rank | Stage | Wait time | Evidence that this stage binds throughput |
|------|-------|-----------|-------------------------------------------|
| 1 | {stage name} | {duration} | {link or citation; why this limits overall flow, not just appears slow} |
| 2 | {stage name} | {duration} | {link or citation} |
| 3 | {stage name} | {duration} | {link or citation} |

**Primary constraint:** {the single binding bottleneck; must be a stage, a resource, or a review queue; not a generic label like "slowness" or "coordination"}

**Evidence the constraint binds:** {why this stage limits throughput; queue growth rate, utilization, or theory-of-constraints drum-buffer-rope pattern}

---

## Future-State Vision <!-- optional -->

> Sketch of the future state after the primary constraint is addressed. Optional at archive time; may be added when the improvement work item is defined.

{description of the future-state map or link to a diagram}

**Target wait-time reduction:** {from {baseline} to {target} at the primary constraint}

---

## Metadata

**Current-state as of:** YYYY-MM-DD

**Author:** {owner}

**Status:** {draft | complete | superseded}

**Supersedes:** {path to prior VSM if this replaces one; otherwise "none"}

**Improvement work items citing this map:** {list of work item IDs; populated as work items are filed against this baseline}

---

*Archive path: `docs/improvement/vsm/VSM-YYYY-MM-DD-<slug>.md`*
