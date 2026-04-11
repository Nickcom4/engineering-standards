---
type: fmea
fmea-type: {type}
id: {type}-{number}
title: "{type}: {Title}"
status: Draft
date: YYYY-MM-DD
owner: "{owner}"
adr: ~
stage:
  - design
applies-to:
  - feature
  - component
  - security
implements:
  - REQ-2.1-04
  - REQ-2.1-35
  - REQ-2.1-37
  - REQ-2.1-38
  - REQ-2.1-39
  - REQ-2.1-41
  - REQ-2.1-42
  - REQ-2.1-43
  - REQ-2.1-46
  - REQ-2.1-47
  - REQ-4.9-12
---

# {type}: {Title}

<a name="REQ-TPL-25"></a>
**REQ-TPL-25** `artifact` `design` `hard` `type:feature AND type:security`
An FMEA exists for qualifying changes with all required sections: FM table, RPN tracking, controls summary, high-severity table, and iteration narrative.

> **Required by [§2.1 DESIGN](../STANDARDS.md#21-the-lifecycle)** for features touching
> authentication, payments, data mutation, or external integrations. DFMEA analyzes
> component failure modes. PFMEA analyzes delivery process sequence failure modes.
> Both apply at the same qualifying triggers. Complete before BUILD begins.

**Feature/Process:** {Title}\
**FMEA Type:** {type} (DFMEA for component design failure modes; PFMEA for process sequence failure modes)\
**Author:** {owner}\
**Date:** YYYY-MM-DD\
**Reviewed by:** (reviewer name / date)\
**RPN Threshold:** (project-defined threshold; ESE default is 75 per REQ-2.1-41)

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
**RPN** = S x O x D. **Threshold: {75}.** **Severity threshold: {7}.**

## Failure Mode Analysis

> **DFMEA:** enumerate each component or function. For each, list what could fail.
> **PFMEA:** enumerate each process step or transition. Failure mode categories:
> step skipped, step out of order, output insufficient for next step, recursive loop never exits.

| FM# | {Component/Step} | Failure Mode | Effect | Root Cause | Current Controls | S | O | D | RPN | Action Required | Status |
|---|---|---|---|---|---|---|---|---|---|---|---|
| FM-01 | {name} | {what fails} | {user/system impact} | {why it can occur} | {existing controls} | | | | | {action or "Controlled: REQ-XXX"} | {stable/active/open} |

> For every action that is not "Controlled" or "Accept," create a work item with
> discovered-from pointing to this FMEA before BUILD begins (REQ-2.1-38).

---

## High-Severity Failure Modes (Severity >= 7)

> Per REQ-2.1-17: Severity >= 7 requires review regardless of RPN.
> List all FMs with S >= 7 and their required actions.

| FM# | Severity | RPN | Action | Status |
|---|---|---|---|---|
| FM-XX | S | RPN | {action} | Addressed / Open |

---

## RPN Tracking Table

> Per REQ-2.1-42: after corrective action, rescore with control in place.
> One column per iteration. Bold the iteration where RPN changed.

| FM# | Iter 1 | Iter 2 | ... | Resolution |
|---|---|---|---|---|
| FM-01 | {initial RPN} | {post-action RPN} | | {what resolved it} |

---

## Controls Summary

> Per REQ-2.1-37: every above-threshold FM has a named control.
> Per REQ-2.1-38: every named control has implementation evidence or a tracked work item.
> Unchecked items must have a deferral rationale or tracked work item reference.

- [ ] {Control name}: {what it does} ({implementation status or work item ID})

---

## Iteration Narrative

> Document what changed and why at each iteration. Per REQ-2.1-43: all data within
> this FMEA is internally consistent at close.

**Iteration 1 ({date}):** {what was analyzed, how many FMs found, how many above threshold}

**Iteration 2 ({date}):** {what corrective actions were implemented, RPN changes}

---

## Applicable Addenda

> If the feature or process falls under any ESE addendum, list the addendum-specific
> requirements that apply to this FMEA.

| Addendum | Applicable? | Requirements activated |
|---|---|---|
| AI/ML | yes / no | {list requirements} |
| Continuous Improvement | yes / no | {list requirements} |
| {other} | yes / no | |

---

## Review Checklist

Before marking this FMEA iteration complete (REQ-2.1-37, REQ-2.1-38, REQ-2.1-43):

- [ ] All components/steps involved are listed
- [ ] RPN threshold defined before scoring began (REQ-2.1-41)
- [ ] Every Severity >= 8 FM has a specific, assigned action
- [ ] Every FM above RPN threshold has a named control in Controls Summary (REQ-2.1-37)
- [ ] Every named control has implementation evidence or tracked work item (REQ-2.1-38)
- [ ] All non-Accept actions have work item IDs
- [ ] Post-action FMs rescored with controls in place (REQ-2.1-42)
- [ ] All count references, RPN values, and status claims are internally consistent (REQ-2.1-43)
- [ ] RPN Tracking Table updated with current iteration column
- [ ] Iteration Narrative entry written for this iteration
- [ ] No hardcoded counts that will go stale (use relative references)

**Completed by:** {name}
**Date:** {YYYY-MM-DD}
**Status:** {Iteration N complete. Summary of current state.}
