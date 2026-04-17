# Addendum: Continuous Improvement

<a name="REQ-ADD-CI-41"></a>
**REQ-ADD-CI-41** `advisory` `continuous` `soft` `addendum:CI` `deprecated:non-first-principles`
~~Deprecated: meta-info, not a requirement.~~

> Extends [Excellence Standards - Engineering](../../STANDARDS.md). Apply when a project has recurring quality issues of the same class, delivery throughput consistently below required rate ([§2.6](../../STANDARDS.md#26-flow-and-batch-size)), or is targeting a defined sigma-level quality improvement goal. Also apply when a post-mortem ([§8.2](../../STANDARDS.md#82-post-mortem-format)) identifies a systemic process problem rather than a one-time correctable failure.

> When this addendum's requirements appear in the [§2.1 per-stage blocks](../../STANDARDS.md#per-stage-operational-blocks), those entries are authoritative; update both in the same commit. The lifecycle table below is the authoritative activation guide within this addendum.

---

## Lifecycle Stage Activation

<a name="REQ-ADD-CI-52"></a>
**REQ-ADD-CI-52** `advisory` `continuous` `soft` `addendum:CI` `deprecated:non-first-principles`
~~Deprecated: meta-info.~~

Which methods apply at each ESE stage. An improvement initiative is not the same as a feature; it has its own lifecycle. Methods listed as "required" must produce their output before the stage closes.

| ESE Stage | Required | Apply when triggered | Output required to advance |
|---|---|---|---|
| Before DEFINE | Gemba (observe current state before scoping); SIPOC (scope the improvement problem) | Any improvement initiative | Written observations from actual artifacts; SIPOC with named suppliers, outputs, and customers |
| DEFINE | QFD (when user needs have not yet been translated into AC) | User feedback is the input signal | House of Quality with tech specs mapped to user needs; specs become §1.1 success metrics |
| DESIGN | FMEA (required: auth, payments, data mutation, external integrations) | VSM if throughput problem is driving the design; Constraint Identification if flow is a design variable | FMEA complete with Severity 9-10 actions assigned; VSM current-state map if triggered |
| BUILD | None | SMED if feedback loop is slow enough to impede iteration | Setup time within thresholds (15 min local, 10 min CI, 30 min deploy) if SMED was triggered |
| VERIFY | Process Capability (confirm claimed improvement exceeds process noise); DoE (if multiple variables changed simultaneously) | Always for improvement work items | Before/after measurement; DoE variable attribution if multiple changes were made |
| MONITOR (ongoing) | Process Capability (update control chart each review period) | Heijunka (track delivery variance); DBR (if constraint shifts) | Control chart current; delivery cadence standard deviation trending |
| Post-mortem and improvement trigger | Gemba (before forming any hypothesis) | VSM (if throughput is the problem); Kaizen event (if scope is bounded and fixable in 3-5 days); A3 (if root cause is unclear) | Current-state map or direct observations before improvement hypothesis is written |

---

## Quick Reference

**I see a symptom. What method should I start with?**

Navigate to the matching row. Follow the method sequence left to right.

| Symptom or situation | First | Then | Then |
|---|---|---|---|
| Throughput is below required rate and I do not know why | [SIPOC](#sipoc) | [Gemba](#gemba) | [Value Stream Mapping](#value-stream-mapping) |
| I know where the bottleneck is and want to fix it | [Constraint Identification Methods](#constraint-identification-methods) | [Drum-Buffer-Rope](#drum-buffer-rope) | None |
| Delivery is inconsistent: sometimes fast, sometimes slow | [Process Capability Measurement](#process-capability-measurement) | [Heijunka](#heijunka) | None |
| I have a scoped problem and want to fix it fast | [Kaizen Events](#kaizen-events) | None | None |
| Team reports friction but cannot identify its source | [Waste Audit Methods](#waste-audit-methods) | [Gemba](#gemba) | None |
| Building something that could fail badly if I miss a failure mode | [FMEA in Practice](#fmea-in-practice) | None | None |
| Users need something and I am not sure what to build | [Quality Function Deployment](#quality-function-deployment) | None | None |
| Making multiple changes and cannot tell which one is working | [Design of Experiments](#design-of-experiments) | None | None |
| Setup or CI is slow and discouraging fast iteration | [SMED for Software](#smed-for-software) | None | None |
| Starting any improvement initiative | [SIPOC](#sipoc) | [Gemba](#gemba) | method appropriate to the symptom above |

---

## Table of Contents

- [Value Stream Mapping](#value-stream-mapping)
- [Kaizen Events](#kaizen-events)
- [Process Capability Measurement](#process-capability-measurement)
- [FMEA in Practice](#fmea-in-practice)
- [Waste Audit Methods](#waste-audit-methods)
- [Constraint Identification Methods](#constraint-identification-methods)
- [Drum-Buffer-Rope](#drum-buffer-rope)
- [Heijunka](#heijunka)
- [SMED for Software](#smed-for-software)
- [Design of Experiments](#design-of-experiments)
- [Gemba](#gemba)
- [Quality Function Deployment](#quality-function-deployment)
- [SIPOC](#sipoc)
- [Testing Gap Audit Additions](#testing-gap-audit-additions)

---

## Value Stream Mapping

Value Stream Mapping (VSM) is a structured method for identifying where time is spent in the delivery system: where work moves, where it waits, and where rework occurs. VSM is the primary diagnostic before any throughput improvement initiative. Investing in improvements before identifying the value stream wastes effort: local efficiency gains accumulate outside the constraint and do not increase total throughput.

**Lifecycle stages:** DESIGN (when a throughput problem drives the design or delivery health metrics have worsened over two consecutive review periods); post-mortem and improvement trigger (primary diagnostic before any throughput improvement initiative).

**When to apply:** before starting any significant delivery system improvement initiative; when DORA metrics or work item cycle time ([§7.4](../../STANDARDS.md#74-delivery-health)) have worsened over two consecutive review periods; when the team is debating what to improve and no current-state map exists.

**What to map:** the complete flow of a representative work item from initial discovery to production deployment. Capture each stage (Discovery, Define, Design, Build, Review, Test, Deploy, Monitor), the average time spent in each stage, and (critically) the average wait time between stages. Wait time between stages is almost always larger than active time within stages and is where the most leverage for improvement exists.

**Minimum execution steps:**

1. **Select a representative work item class:** standard-class features of typical size. Map the current state from the last 10-20 completed items, not from memory or aspiration.
2. **Map current state:** each stage as a box, each handoff as an arrow. Record: average active time (work actually in progress), average wait time (work sitting waiting to start), and a quality indicator (percentage that proceed to the next stage without rework).
3. **Calculate total lead time and value-added time:** total lead time is the sum of all active and wait times; value-added time is the sum of active times only. The ratio reveals utilization. A 5% ratio (1 day of active work in a 20-day lead time) is not unusual and identifies 95% of lead time as waste opportunity.
4. **Identify the three largest wait times:** these are the highest-leverage improvement candidates. Map future state showing those waits removed or reduced.
5. **File a work item for each improvement action** with a measurable before/after target: not "reduce wait time" but "reduce PR review wait from 1.5 days to 4 hours measured over next 20 PRs."

<a name="REQ-ADD-CI-01"></a>
**REQ-ADD-CI-01** `gate` `design` `hard` `addendum:CI` `per-item`
Value stream mapping produces a current-state map with active time and wait time sourced from at least 10 completed work items.

<a name="REQ-ADD-CI-06"></a>
**REQ-ADD-CI-06** `gate` `design` `hard` `addendum:CI` `per-item` `deprecated:REQ-ADD-CI-01`
~~Deprecated: consolidated into REQ-ADD-CI-01.~~

<a name="REQ-ADD-CI-07"></a>
**REQ-ADD-CI-07** `gate` `design` `hard` `addendum:CI` `per-item`
At least one improvement work item is filed with a measurable before/after target.

**Output:** a current-state map, a future-state map, and a set of improvement work items with measurable targets. Do not begin improvement work without current-state measurement; the current state is the baseline for verifying that improvements have effect.

**Acceptance criteria (all must be true to advance):**

<a name="REQ-ADD-CI-11"></a>
**REQ-ADD-CI-11** `gate` `verify` `hard` `addendum:CI` `per-item` `deprecated:REQ-ADD-CI-01`
~~Deprecated: consolidated into REQ-ADD-CI-01.~~

- The current-state map records active time and wait time for every delivery stage.
- Active time and wait time values are sourced from data on at least 10 completed work items, not from memory or estimates.
<a name="REQ-ADD-CI-12"></a>
**REQ-ADD-CI-12** `gate` `verify` `hard` `addendum:CI` `per-item` `deprecated:non-first-principles`
~~Deprecated: parent CI-06 being consolidated; deprecated.~~

- The three largest wait times are identified by stage name and measured duration.
- At least one improvement work item is filed with a measurable before/after target tied to the largest wait time.

### Lean Methodology Grounding

> **Activates at:** DESIGN and post-mortem (methodology applies whenever a VSM is constructed).

The Lean tradition (Taiichi Ohno; Womack and Jones; Rother and Shook) treats VSM as an application of the Theory of Constraints (Goldratt): at any point in time, total throughput is set by the slowest stage in the stream, and improvements outside that stage do not increase throughput. The consequences of ignoring this are practical, not rhetorical. Investing in a stage that is not the constraint makes work pile up faster at the constraint and makes the effective delivery rate lower, not higher. The methodology below exists so the bottleneck is named before any improvement action is taken.

**Walk the stream (Gemba).** The canonical Lean practice is `genchi genbutsu`: go and see, not "go and hear about." A VSM built from memory, self-report, or aggregated dashboards systematically under-counts wait time: the stages where work sits are the stages no one narrates, because no one is acting on it there. The methodology-faithful method:

- For a software delivery stream, walk the actual artifacts: the last N completed work items (10 minimum per [REQ-ADD-CI-01](#value-stream-mapping)), tracing each from D0 capture through production deployment. Record the timestamps at each state transition as they exist in the system of record (version control, task system, deploy log), not as estimates.
- Where the system of record does not capture a transition (for example, the time a work item sat waiting for review before a reviewer opened it), record that absence explicitly. An unmeasured stage is a stage you will not improve; the measurement gap itself is a VSM finding.
- Record ownership per stage. A stage with no single owning role accumulates wait time proportionally to the number of handoffs inside it, and the methodology is explicit that fixing that stage starts with naming the role that owns it, not with optimizing the mechanics.

**Identify the constraint before hypothesizing the cause.** The stage with the largest wait time is not necessarily the stage that is slow; it may be the stage after the true constraint, where work accumulates. Constraint identification is a structured activity (see [Constraint Identification Methods](#constraint-identification-methods)), not an inference from the largest cell in the map. A VSM that lists three candidate bottlenecks without evidence for which one is the true constraint has done half the work.

<a name="REQ-ADD-CI-64"></a>
**REQ-ADD-CI-64** `gate` `design` `hard` `addendum:CI` `per-item`
Before the first improvement work item is filed against a value stream, the bottleneck stage is named explicitly and backed by evidence (measurement from the current-state map, not inference from the largest wait cell).

**Commit to a single measurable change before re-mapping.** Lean improvement cycles (`kaizen`) are iterative and small. Mapping the whole stream, committing to six parallel improvements, and re-mapping six weeks later produces a VSM that cannot attribute delta to cause. The methodology-faithful sequence is: one change targeted at the identified bottleneck, measured against the declared before/after target from [REQ-ADD-CI-07](#value-stream-mapping), re-map before the next change begins.

<a name="REQ-ADD-CI-65"></a>
**REQ-ADD-CI-65** `gate` `verify` `hard` `addendum:CI` `per-item`
Before a countermeasure to the named bottleneck is implemented, the pre-intervention baseline measurement is recorded (which metric, what value, sourced from which completed work items) so that post-intervention comparison is observable.

**Re-measure on an event trigger, not a calendar window.** "Check in three months" is a calendar trigger and tends to drift when calendars get busy. The methodology-faithful trigger is event-based: re-measure when N completed work items have traversed the modified stage since the change landed, where N is set to the same floor as the baseline (10 per [REQ-ADD-CI-01](#value-stream-mapping)). If N items have not traversed the stage in the expected window, that absence is itself a finding about throughput.

<a name="REQ-ADD-CI-66"></a>
**REQ-ADD-CI-66** `gate` `monitor` `hard` `addendum:CI` `per-item`
After a bottleneck countermeasure lands, re-measurement is scheduled on an event trigger (N completed work items traversing the modified stage, matching the baseline-sample floor), not a calendar window.

**Relationship to the VSM artifact discipline.** The methodology described here is the `how` of producing a VSM. The [VSM template](../../templates/vsm.md) shipped in v2.10.0 is the `what`: the required sections (Purpose and Context, Current-State Map with active/wait/yield/ownership per stage, Measured Observations from 10+ items per REQ-ADD-CI-01, Bottleneck Identification with evidence for the three largest wait times, Metadata with current-state-as-of date, author, status, supersedes) carry the output of the methodology into a reviewable artifact. Adopter repositories using the methodology without the template produce a VSM whose shape cannot be enforced by `scripts/lint-vsm-baseline-reference.sh`; adopter repositories using the template without the methodology produce a shape whose content is not grounded in current state. Both are required.

---

## Kaizen Events

A Kaizen event is a structured, time-boxed improvement workshop: a cross-functional team focuses on a specific, scoped problem for 3-5 working days and leaves with implemented and measured improvements, not a plan to implement later. Kaizen events are distinct from ongoing continuous improvement (daily incremental improvement) and from project-based improvement work. Their defining characteristic is intensity and completeness within the event window.

**Lifecycle stages:** Post-mortem and improvement trigger (when a well-bounded process problem has been identified via VSM or post-mortem and the improvement can be designed, implemented, and measured within 3-5 days).

**When to apply:** when a well-bounded process problem has been identified (via VSM or post-mortem) and the improvement can be designed, implemented, and measured within 3-5 days; when the team has tried incremental improvement and the problem persists.

**When not to apply:** when the problem is not well-bounded (use VSM first to scope it); when the improvement requires infrastructure changes that take weeks (Kaizen addresses process, not platform); when the root cause is unclear (use post-mortem [§8.2](../../STANDARDS.md#82-post-mortem-format) or A3 [§8.7](../../STANDARDS.md#87-a3-structured-problem-solving) first).

**Minimum execution steps (3-5 day event):**

1. **Pre-work (1 week before):** define the specific problem, current-state metrics, target state metrics, and team composition. Minimum team: the people who do the work, at least one person from an adjacent process, and a facilitator. Collect current-state data before the event starts; do not spend event time on measurement setup.
2. **Day 1:** confirm current state; root cause analysis (Five Whys, fishbone diagram); agree on target state and improvement hypothesis.
3. **Days 2-3:** design and implement improvements. In a software context, this means code changes, process changes, tooling changes, or documentation changes, whichever removes the identified waste or defect source.
4. **Day 4:** test improvements under realistic conditions; measure outcome against target.
5. **Day 5:** document the new standard, train affected team members, confirm monitoring is in place, and identify any follow-up work items. If target was not met, document what was learned and file the next iteration as a work item.

**Measurement requirement:** the event must produce a before/after measurement of the target metric. An event that produces a plan but no measurement is not a completed Kaizen event; it is a planning meeting. Record both the baseline and post-event measurement in the team's lessons-learned registry ([§8.3](../../STANDARDS.md#83-lessons-learned-registry)).

**User feedback connection ([§2.7](../../STANDARDS.md#27-user-feedback)):** Kaizen events that improve user-facing behavior must close the §2.7 feedback loop. When an improvement changes something users experience (faster response, changed workflow, removed friction), notify affected users through whatever channel §2.7 defines for the project. The improvement is not complete until the users who provided the feedback know the feedback was acted on. Additionally, §2.7 user feedback is a valid source for scoping Kaizen events: recurring user reports about the same friction point are a signal that a Kaizen event is warranted, not just individual bug fixes.


<a name="REQ-ADD-CI-02"></a>
**REQ-ADD-CI-02** `gate` `verify` `hard` `addendum:CI` `per-item`
Kaizen event produces a before/after measurement of the target metric.

<a name="REQ-ADD-CI-61"></a>
**REQ-ADD-CI-61** `gate` `close` `hard` `addendum:CI` `per-item`
Kaizen events that improve user-facing behavior close the §2.7 feedback loop by notifying affected users.

<a name="REQ-ADD-CI-08"></a>
**REQ-ADD-CI-08** `gate` `verify` `hard` `addendum:CI` `per-item`
No measurement improvement without data.
**Acceptance criteria (all must be true to advance):**

- The pre-event baseline metric is recorded before the event begins.
<a name="REQ-ADD-CI-13"></a>
**REQ-ADD-CI-13** `gate` `verify` `hard` `addendum:CI` `per-item`
The improvement is implemented (not planned) by the end of the event.

- The improvement is implemented (not planned) by the end of the event.
- A post-event measurement of the same metric is taken using the same measurement method as the baseline.
<a name="REQ-ADD-CI-14"></a>
**REQ-ADD-CI-14** `gate` `verify` `hard` `addendum:CI` `per-item`
The result (target met or missed, with the actual measured value) is recorded in the lessons-learned registry.

- The result (target met or missed, with the actual measured value) is recorded in the lessons-learned registry.

---

<a name="REQ-ADD-CI-03"></a>
**REQ-ADD-CI-03** `gate` `verify` `hard` `addendum:CI AND type:improvement` `per-item`
Improvement claims are verified by process capability measurement: the claimed improvement exceeds normal process variation (common cause vs special cause distinction made before declaring improvement verified).

## Process Capability Measurement

Process capability measures how consistently a process meets its quality targets, not just whether it passed or failed on a given day. Two processes with the same average performance can have radically different capability: one may pass the target 95% of the time with low variance; another may pass 95% of the time but with high variance that produces occasional large failures. Threshold-only monitoring (alert: yes/no) cannot distinguish between them. Process capability measurement makes the distinction visible.

**Lifecycle stages:** VERIFY (required for improvement work items: confirms the claimed improvement exceeds process noise and is not a temporary fluctuation); MONITOR (ongoing: update the control chart each review period to detect process shifts).

**When to apply:** when a process has a defined quality target and enough historical data to measure variation (minimum 20-25 data points); when delivery health worsens over multiple review periods despite no obvious root cause; when verifying that an improvement actually changed the process and was not a temporary fluctuation.

**Core concept:** a stable, predictable process produces outputs within a predictable range. The range can be measured. When a new measurement falls outside that predictable range (a "signal"), something changed. When a measurement falls inside the range but near the boundary, that is common cause variation: not a signal, not evidence that action is needed. Responding to common cause variation as though it were a signal is tampering: it increases variation rather than reducing it. The correct response to common cause variation is process improvement; the correct response to special cause variation is root cause investigation.

**Minimum execution steps:**

1. **Define the quality target and the metric.** Examples: PR review completion within 2 business days, VERIFY stage first-pass yield above 85%, deployment frequency at least twice per week.
2. **Collect baseline data** for 20+ consecutive measurement periods. Plot data points over time.
3. **Calculate the mean and control limits.** Upper and lower control limits (UCL and LCL) are typically set at 3 standard deviations from the mean. Points outside these limits indicate special cause variation requiring investigation. Points within limits indicate common cause variation requiring process improvement.
4. **Identify the signal type before responding:**
   - Outside control limits: investigate the specific cause (what changed for that measurement?)
   - Trend of 7+ consecutive points in one direction: the process is shifting; investigate.
   - Within limits and no trend: stable process; improvement requires changing the process, not responding to individual measurements.
5. **After implementing an improvement, restart the baseline.** The old control limits no longer apply to the new process. Collect new data and recalculate.

**Specific metrics to apply this to:**
- Work item cycle time by class of service (claimed to closed with evidence)
- VERIFY first-pass yield (VERIFY runs that pass on first attempt vs. those requiring rework)
- Deployment frequency and change failure rate (DORA metrics per [§7.4](../../STANDARDS.md#74-delivery-health))
- PR review lead time

**Acceptance criteria (all must be true to advance):**

<a name="REQ-ADD-CI-15"></a>
**REQ-ADD-CI-15** `advisory` `verify` `soft` `addendum:CI`
At least 20 consecutive data points are plotted in chronological order.

- At least 20 consecutive data points are plotted in chronological order.
- UCL and LCL are calculated from the data at 3 standard deviations from the mean.
<a name="REQ-ADD-CI-16"></a>
**REQ-ADD-CI-16** `gate` `verify` `hard` `addendum:CI` `per-item`
The team has documented in writing whether the current state is special cause (specific cause investigated and recorded) or common cause (process change planned or in progress).

- The team has documented in writing whether the current state is special cause (specific cause investigated and recorded) or common cause (process change planned or in progress).
- After any improvement, a new baseline is started and the old control limits are retired.

---

## FMEA in Practice

<a name="REQ-ADD-CI-42"></a>
**REQ-ADD-CI-42** `advisory` `continuous` `soft` `addendum:CI` `deprecated:non-first-principles`
~~Deprecated: meta-info.~~

Failure Mode and Effects Analysis (FMEA) is required by [§2.1](../../STANDARDS.md#21-the-lifecycle) for features touching authentication, payments, data mutation, or external integrations. The formal template is at [templates/fmea.md](../../templates/fmea.md). This section provides guidance on using FMEA effectively in a software delivery context.

**Two types of FMEA apply at the same triggers:**

- **DFMEA (Design FMEA):** analyzes the component being changed. Failure modes are component-level: "what can fail in this feature." This is the traditional FMEA described in the steps below.
- **PFMEA (Process FMEA):** analyzes the delivery process for this change. Failure modes are process-level: step skipped, step done out of order, step output insufficient for next step input, recursive loop (e.g., post-mortem-to-prevention-to-verification) that never exits. The PFMEA is a living project document reviewed at each qualifying change (same model as architecture docs). For recurring bugs, the recurrence itself is a PFMEA failure mode.

**Lifecycle stages:** DESIGN (both DFMEA and PFMEA review required before BUILD begins for qualifying changes; both must be updated if the design or process changes before BUILD is complete).

**The purpose of FMEA is not documentation.** It is a structured forcing function that surfaces failure modes before they reach users. An FMEA completed in 30 minutes with no discussion is not an FMEA; it is a form. An effective FMEA surfaces at least one failure mode the team had not previously considered.

**Minimum execution steps (90-minute working session):**

1. **List all functions the feature performs:** the user-facing functions, not the code paths. Target 5-15 functions. Example: "user submits payment," "token expiry is enforced," "third-party webhook is received and validated."
2. **For each function, ask:** "In what way could this function fail to deliver its intended result?" Write one failure mode per row. Example: "token expiry check does not fire when clock skew between services exceeds 30 seconds."
3. **Score each failure mode on three dimensions** (1-10 each): Severity (how bad if it reaches the user), Occurrence (how likely before controls), Detectability (how hard to catch before user impact, where 10 = undetectable). RPN = S x O x D.
4. **Flag all rows with Severity at or above the severity threshold regardless of RPN** (default: 7; see REQ-2.1-48). A low-probability failure with high severity may have a low RPN but still requires review.
5. **For all RPN at or above the RPN threshold** (default: 75; see REQ-2.1-48)**:** assign an owner and a specific action (design change, new test, additional monitoring). "Under review" is not an action.
6. **File the FMEA with the ADR or design document.** If the design changes before BUILD is complete, update the FMEA before continuing.

**Additional guidance:**

**Define thresholds before scoring.** The RPN threshold and severity threshold must be set before any failure mode is scored (REQ-2.1-41). ESE defaults: RPN 75, severity 7. Projects override in their standards-application document with rationale (REQ-2.1-48).

**Identify failure modes at the right granularity.** Too high ("the feature fails") produces no actionable insight. Too low ("this line of code throws an exception") is impractical. Target function-level failure modes for DFMEA; target process-step-transition failure modes for PFMEA.

**Score conservatively.** When uncertain about Severity, Occurrence, or Detectability, round up, not down. The purpose of scoring is to prioritize, not to achieve the lowest possible RPN.

**Rescore after every corrective action.** When a control is implemented, update S, O, and D to reflect the control's effect (REQ-2.1-42). Severity rarely changes; Occurrence decreases with prevention controls; Detectability decreases with detection controls. The RPN tracking table shows pre- and post-control scores.

**Record current controls honestly.** "Code review" is not a control unless specifically designed to catch that error class. Be specific: "automated test covering token expiry edge case" is a control; "review" is not.

**Controls must reference specific requirements.** Every controlled FM's Action column must name the specific REQ-ID or CI gate that provides the control. "Controlled" without a reference is not traceable.

**No hardcoded counts in FMEAs.** Use relative references ("see req-manifest.sha256 for current count") instead of hardcoding numbers that go stale when underlying data changes.

**Use the compact rating scale format.** A single table with all three dimensions (S, O, D) is more readable than three separate tables. The FMEA template provides this format.

**Derived sections are generated, not maintained.** High-Severity table, RPN Summary, Controls Summary, and Review Checklist are all derived from the source FM tables. Maintaining them manually causes staleness. Auto-generate them or validate consistency before close (REQ-2.1-49, REQ-ADD-CI-62).

**First-principles language only.** FMEA failure mode descriptions, actions, and controls use tool-agnostic language (REQ-4.9-12). Example: "work item closed before constituents complete" not "{tool-specific-term} closed before children done."

**Acceptance criteria (all must be true to advance):**

<a name="REQ-ADD-CI-17"></a>
**REQ-ADD-CI-17** `gate` `verify` `hard` `addendum:CI` `per-item`
Every user-facing function has at least one failure mode documented.

- Every user-facing function has at least one failure mode documented.
- All Severity 9-10 failure modes have a design change or additional control assigned and tracked in a work item.
<a name="REQ-ADD-CI-18"></a>
**REQ-ADD-CI-18** `gate` `verify` `hard` `addendum:CI` `per-item`
All RPN 100+ failure modes have a named owner and a specific action (not "under review").

- All RPN 100+ failure modes have a named owner and a specific action (not "under review").
- The FMEA reflects the current design: no design changes have occurred after the FMEA was completed without a corresponding FMEA update.

<a name="REQ-ADD-CI-62"></a>
**REQ-ADD-CI-62** `gate` `verify` `hard` `addendum:CI` `per-item`
FMEA derived sections (High-Severity table, RPN Summary, Controls Summary, Review Checklist) are consistent with source FM tables at close.

<a name="REQ-ADD-CI-63"></a>
**REQ-ADD-CI-63** `advisory` `design` `soft` `addendum:CI` `deprecated:non-first-principles`
~~Deprecated: advisory about tooling.~~

---

## Waste Audit Methods

The 8 Wastes (TIMWOODS) are defined in [§2.6](../../STANDARDS.md#26-flow-and-batch-size). This section provides structured methods for identifying which wastes dominate a given delivery system.

**Lifecycle stages:** Before DEFINE (before scoping any improvement initiative; establishes which waste categories are systemic before defining what to fix); post-mortem and improvement trigger (when team members report friction without a clear source).

<a name="REQ-ADD-CI-43"></a>
**REQ-ADD-CI-43** `advisory` `continuous` `soft` `addendum:CI` `deprecated:non-first-principles`
~~Deprecated: meta-info.~~

**When to run a waste audit:** when delivery throughput has stalled despite the team working at capacity; after a VSM reveals more wait time than active time; when team members report friction but cannot identify its source.

**Minimum execution steps:**

1. Select 5 recently closed work items and trace each one through its complete lifecycle, recording: stages visited (including any visited more than once, indicating rework), wait times at each stage, information that was missing and caused delays or rework, and team members involved at each stage.
2. After tracing all 5 items, catalog every recurrence. Patterns appearing in 3 or more of the 5 items are systemic wastes, not one-off anomalies.
3. Match each systemic pattern to a named TIMWOODS category.
4. Conduct structured interviews with at least 5 practitioners using these three questions: (a) "What regularly slows you down that is not the actual work?" (b) "What do you do that you think does not need to be done?" (c) "What do you spend time finding, fixing, or explaining that should not require that effort?"
5. Catalog interview responses and identify patterns across team members. Map responses to TIMWOODS categories.
6. Produce a prioritized list of waste categories with specific examples and a frequency count.
7. File the top 1-3 patterns as work items with measurable improvement targets and route each into A3 problem solving ([§8.7](../../STANDARDS.md#87-a3-structured-problem-solving)) or a Kaizen event.

**Method: walk the work item.**
Select 5 recently closed work items and trace each one through its complete lifecycle. For each item, record:
- Which stages were visited (and which were visited more than once, indicating rework)
- Where the item waited and for how long
- What information was missing that caused delays or rework
- Which team members were involved at each stage

After tracing 5 items, catalog the recurrences. Patterns that appear in 3 or more of the 5 items are systemic wastes, not one-off anomalies. Match each pattern to a TIMWOODS category. Prioritize by frequency and time consumed.

**Method: ask the people doing the work.**
The people closest to the work know where the waste is. A structured conversation with three questions surfaces most of it:
1. "What regularly slows you down that is not the actual work?"
2. "What do you do that you think does not need to be done?"
3. "What do you spend time finding, fixing, or explaining that should not require that effort?"

Responses map predictably to TIMWOODS categories. Catalog responses and look for patterns across team members.

**Output:** a prioritized list of waste categories with specific examples and a frequency count. Feed the top 1-3 items into A3 problem solving ([§8.7](../../STANDARDS.md#87-a3-structured-problem-solving)) or a Kaizen event. Waste audits are inputs to improvement, not outputs; an audit without a follow-on action plan produces no improvement.

**Acceptance criteria (all must be true to advance):**

<a name="REQ-ADD-CI-19"></a>
**REQ-ADD-CI-19** `advisory` `verify` `soft` `addendum:CI`
Five work items have been traced and all stages are documented for each.

<a name="REQ-ADD-CI-54"></a>
**REQ-ADD-CI-54** `gate` `verify` `hard` `addendum:CI` `per-item` `deprecated:non-first-principles`
~~Deprecated: parent CI-19 being downgraded; deprecated.~~

<a name="REQ-ADD-CI-55"></a>
**REQ-ADD-CI-55** `gate` `verify` `hard` `addendum:CI` `per-item` `deprecated:non-first-principles`
~~Deprecated: parent CI-19 being downgraded; deprecated.~~

<a name="REQ-ADD-CI-56"></a>
**REQ-ADD-CI-56** `gate` `verify` `hard` `addendum:CI` `per-item` `deprecated:non-first-principles`
~~Deprecated: parent CI-19 being downgraded; deprecated.~~

- Five work items have been traced and all stages, wait times, rework loops, and team members involved are documented for each.
- At least 5 practitioners have been interviewed using the three standard questions.
<a name="REQ-ADD-CI-20"></a>
**REQ-ADD-CI-20** `gate` `verify` `hard` `addendum:CI` `per-item`
Every recurring pattern is matched to a named TIMWOODS category.

- Every recurring pattern is matched to a named TIMWOODS category.
- The top 1-3 waste patterns by frequency are identified.
<a name="REQ-ADD-CI-21"></a>
**REQ-ADD-CI-21** `gate` `verify` `hard` `addendum:CI` `per-item`
Each top pattern is filed as a work item with a measurable improvement target.

- Each top pattern is filed as a work item with a measurable improvement target.

---

## Constraint Identification Methods

[§2.6](../../STANDARDS.md#26-flow-and-batch-size) requires identifying the binding system constraint before investing in delivery improvements. The Theory of Constraints five focusing steps apply. This section provides methods for identifying the constraint in a software delivery system.

<a name="REQ-ADD-CI-44"></a>
**REQ-ADD-CI-44** `advisory` `continuous` `soft` `addendum:CI` `deprecated:non-first-principles`
~~Deprecated: meta-info.~~

**Lifecycle stages:** DESIGN (when flow is a design variable or throughput is the problem driving the design); post-mortem and improvement trigger (required before investing in delivery improvements; without a named constraint, improvement effort is speculative).

**The constraint is the step or resource that limits total throughput when everything else is working normally.** In a software delivery system, common constraints are: the review/approval step (work queues waiting for review), the deployment pipeline (builds are slow or infrequent), a specific person whose attention is required for progress (key-person constraint), or a shared resource (one staging environment serializing integration tests).

**Minimum execution steps (one measurement period):**

1. For each delivery stage, count: (a) items currently waiting to enter the stage and (b) items that completed the stage in the last measurement period.
2. The stage with the longest average wait time is the primary constraint candidate.
3. Ask two practitioners at that stage: "Do you ever have nothing to work on?" If yes, the constraint is upstream: work is not arriving fast enough. If no, this stage is likely the constraint.
4. Confirm over two consecutive measurement periods before declaring the constraint. A one-period spike is not a constraint; a persistent queue is.

**Method: queue mapping.**
For each stage in the delivery system, measure the current queue depth (work items waiting to enter that stage) and the average time an item waits in the queue. The stage with the longest average queue wait is a strong candidate for the constraint. Run this measurement for two consecutive review periods to distinguish the persistent constraint from a temporary queue spike.

**Method: idle time analysis.**
If work is always waiting at stage X but practitioners at stage X are not always busy, the constraint is upstream (work is not arriving fast enough). If work is always waiting at stage X and practitioners at stage X are always busy, stage X is likely the constraint. If work flows through stage X quickly but then waits at stage Y, stage Y is likely the constraint.

**Method: utilization check.**
Measure each stage's utilization: what percentage of available time is spent on active throughput work vs. waiting, rework, coordination, or overhead. Very high utilization (90%+) at one stage while other stages are below 70% identifies the constraint. Note: high utilization is a symptom of the constraint, not its cause. The goal is not to reduce utilization but to identify where to focus improvement.

**After identifying the constraint:**
1. Exploit it fully: remove all non-essential work from the constraint's queue; ensure the constraint is never idle for avoidable reasons.
2. Subordinate everything else to the constraint: adjust WIP limits, batch sizes, and prioritization rules so other stages feed the constraint at the rate it can absorb work.
3. Elevate the constraint if throughput is still insufficient: invest in additional capacity or process improvement specifically at the constraint.
4. Return to step 1 once the constraint moves: the new constraint is somewhere else in the system.

**Acceptance criteria (all must be true to advance):**

<a name="REQ-ADD-CI-22"></a>
**REQ-ADD-CI-22** `gate` `verify` `hard` `addendum:CI` `per-item`
A single stage is identified as the constraint by name.

- A single stage is identified as the constraint by name.
- The identification is confirmed across two consecutive measurement periods (not a single-period observation).
<a name="REQ-ADD-CI-23"></a>
**REQ-ADD-CI-23** `gate` `verify` `hard` `addendum:CI` `per-item`
Subordination actions (adjusted WIP limits or prioritization rules) are in place and documented.

- Subordination actions (adjusted WIP limits or prioritization rules) are in place and documented.
- The constraint's queue depth is being measured and recorded each review period.

---

## Drum-Buffer-Rope

Drum-buffer-rope (DBR) is the Theory of Constraints scheduling mechanism for protecting a delivery system's constraint from starvation and from being overwhelmed. It applies after the constraint has been identified using the five focusing steps referenced in [§2.6](../../STANDARDS.md#26-flow-and-batch-size) and the Constraint Identification Methods section above. DBR does not replace WIP limits; it provides the specific synchronization logic that makes WIP limits work in constraint-aware systems.

<a name="REQ-ADD-CI-45"></a>
**REQ-ADD-CI-45** `advisory` `continuous` `soft` `addendum:CI` `deprecated:non-first-principles`
~~Deprecated: meta-info.~~

**Lifecycle stages:** MONITOR (ongoing, once the constraint is identified and DBR is active: buffer level reviewed each measurement period); DESIGN (when constraint-aware scheduling is a required design property of the delivery system).

<a name="REQ-ADD-CI-46"></a>
**REQ-ADD-CI-46** `advisory` `continuous` `soft` `addendum:CI` `deprecated:non-first-principles`
~~Deprecated: meta-info.~~

**When to apply:** after the binding system constraint has been identified; when the constraint is being starved (it frequently has nothing to work on) or overwhelmed (work piles up faster than it can be processed); when WIP limits are set but delivery still feels unsynchronized. DBR is not useful when the constraint has not been identified: without knowing the drum, you cannot set the buffer or the rope.

**Connection to ESE §2.6:** The WIP limits in §2.6 define the maximum work in progress across the delivery system. DBR defines where within that limit work should be pulled from and where it should be protected. DBR makes §2.6 WIP limits operationally effective by tying them to the constraint rate rather than setting them by judgment alone.

**The three components:**

**Drum:** the constraint: the step or resource that limits total throughput. The drum sets the pace for the entire delivery system. No other step should produce faster than the drum can absorb; doing so creates inventory (unfinished work piling up before the constraint) without increasing total output. Identify the drum from queue mapping or idle-time analysis (see Constraint Identification Methods above).

**Buffer:** a protected inventory of ready-to-work items kept immediately upstream of the constraint. The buffer ensures the constraint is never idle because upstream delays temporarily reduced supply. The buffer size is not arbitrary: it should be large enough to cover the maximum expected supply disruption upstream of the constraint, and no larger. An oversized buffer is inventory waste (§2.6 TIMWOODS); an undersized buffer starves the constraint. Start with a buffer equal to roughly one-third of total system lead time and adjust based on observed constraint starvation frequency.

**Rope:** the signal that controls work intake at the beginning of the delivery pipeline. Work is only pulled into the system when the buffer consumes from the upstream end. The rope prevents overproduction: it ties the input rate to the constraint rate rather than to the capacity of the first step, which is almost always higher than the constraint rate. In practice, the rope is a WIP limit on work entering the pipeline, set so that the flow arriving at the buffer matches the buffer's planned consumption rate.

**Minimum execution steps:**

1. Confirm the drum (the constraint): which stage consistently has the longest queue?
2. Set a buffer: a defined set of fully-scoped, ready-to-start work items kept upstream of the constraint. "Ready to start" means all DEFINE work is complete and the item can be claimed without a discovery session.
3. Set the rope: limit new work entering the pipeline (moving from backlog to in-flight) to match the constraint's throughput. When the buffer drops below the target size, pull one item from the backlog to refill it; do not batch-pull.
4. Monitor the buffer level. A consistently depleted buffer means the rope is too tight or the constraint rate has been underestimated. A consistently full buffer means the rope is set correctly or the upstream supply chain is faster than believed.

**Acceptance criteria (all must be true to advance):**

<a name="REQ-ADD-CI-24"></a>
**REQ-ADD-CI-24** `gate` `verify` `hard` `addendum:CI` `per-item` `deprecated:REQ-ADD-CI-22`
~~Deprecated: consolidated into REQ-ADD-CI-22.~~

- The drum is named and documented (the specific stage identified as the constraint).
- The buffer target size is set and the buffer is stocked with DEFINE-complete items.
<a name="REQ-ADD-CI-25"></a>
**REQ-ADD-CI-25** `gate` `verify` `hard` `addendum:CI` `per-item`
The rope limit is enforced: new pipeline intake is gated on buffer consumption, not on available capacity at the first stage.

- The rope limit is enforced: new pipeline intake is gated on buffer consumption, not on available capacity at the first stage.
- Buffer level is reviewed and recorded each measurement period.

---

## Heijunka

Heijunka (from Japanese: "production leveling") is the practice of smoothing work intake to avoid the overload-then-idle cycles that characterize batch-driven delivery. In software delivery, batch patterns appear as: holding features until a sprint boundary, shipping multiple changes at once at release time, processing all user feedback requests in one weekly batch, or front-loading the pipeline early in a cycle and having nothing left to ship at the end. Each of these patterns increases batch size, raises deployment risk, reduces feedback frequency, and produces periods of overload followed by periods of underutilization.

<a name="REQ-ADD-CI-47"></a>
**REQ-ADD-CI-47** `advisory` `continuous` `soft` `addendum:CI` `deprecated:non-first-principles`
~~Deprecated: meta-info.~~

**Lifecycle stages:** MONITOR (ongoing: tracking delivery variance and confirming leveling practices are reducing standard deviation over time); BUILD (when leveling intake is required to prevent overload-then-idle cycles during active delivery).

**When to apply:** when delivery cadence is irregular (some periods have many deployments, others have none); when deployment risk is high because each deployment is large; when team members report being overloaded at cycle boundaries and underutilized mid-cycle; when user feedback is processed in batches rather than continuously.

**Connection to ESE §2.6 and §5.7:** §2.6 requires small batch sizes and WIP limits. Heijunka is the demand-side practice that makes small batches sustainable: by leveling the intake rate, it prevents the pressure to batch that arises when demand arrives unevenly. §5.7 (Deployment Strategies and Release Safety) defines safe deployment strategies (canary, blue-green, feature flags). Heijunka enables more frequent use of these strategies by ensuring deployments are small and frequent enough to use them; a large batched release is incompatible with canary deployment in practice even if the tooling supports it.

**Minimum execution steps:**

1. Export deployment dates and deployment sizes (items per deployment or lines changed) for the last 30 deployments.
2. Calculate: mean deployments per week, standard deviation of deployments per week, mean items per deployment, standard deviation of items per deployment.
3. If the coefficient of variation (standard deviation / mean) for items per deployment exceeds 1.0, batching is the dominant pattern and is the primary target.
4. Set an intake limit: a maximum number of new items entering the pipeline per week, equal to the constraint's throughput (from DBR or constraint identification). Post this limit where work is pulled from the backlog.
5. Apply one leveling approach from the section below that matches the dominant batch pattern.
6. Measure again after 30 deployments. The initiative is working if the standard deviation of items per deployment decreases.

**Leveling approaches for software delivery:**

**Continuous deployment over batch releases:** Instead of accumulating completed features until a release date, deploy each feature as soon as it passes VERIFY. Each deployment is smaller, easier to roll back, and easier to monitor. The prerequisite is a reliable CI/CD pipeline (§5.5) and a fast feedback mechanism (§7.1). If these do not exist, build them before trying to increase deployment frequency; deploying more often with a fragile pipeline increases risk rather than reducing it.

**Intake limits over batch processing:** Instead of processing all user feedback, all support requests, or all backlog items in scheduled sessions, set a defined number of new items that enter the delivery pipeline each day or week. This prevents demand spikes from overwhelming the team and creates a predictable flow. The intake limit is the rope in a DBR system (see above).

**Demand shaping:** When demand consistently exceeds capacity at certain times, actively shift demand. Common methods: notify users of standard processing times so they space requests; batch requests that arrive in bursts into a queue with a defined processing cadence; reserve capacity for unexpected high-priority items so the arrival of an expedite item does not disrupt the entire pipeline. Demand shaping is not about refusing work; it is about receiving it at a rate the system can absorb without creating overload-then-idle cycles.

**Acceptance criteria (all must be true to advance):**

<a name="REQ-ADD-CI-26"></a>
**REQ-ADD-CI-26** `advisory` `verify` `soft` `addendum:CI`
Baseline standard deviation of items per deployment is measured over at least 30 deployments and recorded.

- Baseline standard deviation of items per deployment is measured over at least 30 deployments and recorded.
- One leveling practice is implemented and documented.
<a name="REQ-ADD-CI-27"></a>
**REQ-ADD-CI-27** `gate` `verify` `hard` `addendum:CI` `per-item` `deprecated:non-first-principles`
~~Deprecated: parent CI-26 being downgraded; deprecated.~~

- A follow-on measurement is taken after at least 30 more deployments.
- The follow-on standard deviation is lower than the baseline standard deviation.

---

## SMED for Software

<a name="REQ-ADD-CI-40"></a>
**REQ-ADD-CI-40** `advisory` `build` `soft` `addendum:CI`
Setup times are measured and targeted for reduction: local dev environment under 15 minutes, CI pipeline under 10 minutes, deployment under 30 minutes.

Single-Minute Exchange of Die (SMED) is a method for measuring and systematically reducing setup time: the time required to prepare a system, environment, or process before productive work can begin. In software delivery, setup time is not a manufacturing concept but it is a real cost: the time from "I need to start work" to "I am producing output" is setup time. Long setup times reduce effective capacity, discourage short feedback cycles, and are a primary driver of large batch sizes (teams batch work to amortize setup cost rather than starting frequently). Fast feedback is waste elimination, not a development convenience.

**Lifecycle stages:** BUILD (when the feedback loop is slow enough to impede iteration, triggering SMED to reduce setup cost before it compounds into batch pressure); VERIFY (confirming that setup times are within defined thresholds before the stage closes).

**When to apply:** when local environment setup takes more than 15 minutes; when CI pipeline feedback takes more than 10 minutes; when deployment to any environment takes more than 30 minutes; when onboarding a new contributor takes more than one day to reach a working local environment. Any setup time that discourages frequent starts is a SMED target.

**Connection to ESE:** SMED addresses two specific ESE requirements. §5.1 (Version Control Discipline) states: "Time from clone to a working local environment matters: if setup is slow enough to discourage new contributors, the setup documentation or tooling needs improvement." That is a SMED requirement. §5.5 (Continuous Integration and Delivery) requires CI pipelines that run on every proposed change; slow CI pipelines reduce the value of that gate by discouraging frequent integration. SMED applied to CI pipeline duration directly supports the §5.5 intent.

**Minimum execution steps:**

1. **Identify the setup events to measure.** Common setup events in software delivery: clone-to-running (time from fresh clone to first passing test run), environment setup (time to configure a new developer machine or CI environment), CI pipeline duration (time from push to green or red result), deployment duration (time from merge to production availability), and test suite duration (time for full test suite to complete).

2. **Measure the current baseline.** Time each event precisely, not from memory. Use CI timestamps for pipeline duration; use terminal timing for clone-to-running; use deployment logs for deployment duration. Record the median and 95th percentile, not only the average. Slow outliers are often the events that discourage frequent use.

3. **Separate internal from external setup time.** Internal setup is time that cannot be overlapped with other work (the pipeline must be idle). External setup is time that could be overlapped (documentation reading, waiting for a service to start). Reclassifying external setup as overlappable is often the fastest win without changing any tooling.

4. **Target the largest time consumers first.** Compile times, dependency installation, database seed population, and full integration test suites are common largest consumers. Each can be addressed with caching, parallelization, or scope reduction (running only affected tests).

5. **Measure again after each change.** A SMED initiative is complete when the target threshold is met and the new baseline is documented in the project's standards-application.md or setup documentation.

**Acceptance criteria (all must be true to advance):**

<a name="REQ-ADD-CI-28"></a>
**REQ-ADD-CI-28** `gate` `verify` `hard` `addendum:CI` `per-item`
Median and 95th percentile are recorded for all identified setup event types.

- Median and 95th percentile are recorded for all identified setup event types.
- The largest time-consuming setup event is at or below its defined threshold (15 minutes for local, 10 minutes for CI, 30 minutes for deploy).
<a name="REQ-ADD-CI-29"></a>
**REQ-ADD-CI-29** `gate` `verify` `hard` `addendum:CI` `per-item`
The new baseline is documented in the project's setup documentation or standards-application.md.

- The new baseline is documented in the project's setup documentation or standards-application.md.

---

## Design of Experiments

Design of Experiments (DoE) is a structured approach to identifying which variables actually drive output variation, rather than optimizing one variable at a time while leaving others uncontrolled. In software delivery and ML systems, the common failure mode is varying one parameter (batch size, learning rate, cache timeout) while leaving others fixed and concluding which change caused improvement, when in fact the response is driven by an interaction between multiple variables. DoE makes those interactions visible.

<a name="REQ-ADD-CI-48"></a>
**REQ-ADD-CI-48** `advisory` `continuous` `soft` `addendum:CI` `deprecated:non-first-principles`
~~Deprecated: meta-info.~~

**Lifecycle stages:** VERIFY (required when multiple variables changed simultaneously: DoE attributes the claimed improvement to specific variables, satisfying the VERIFY requirement that a change be verifiable and reproducible); DESIGN (when planning multi-variable changes that must each be individually verifiable at VERIFY time).

**When to apply:** when multiple variables are suspected of influencing an outcome and their interactions are unknown; when running A/B tests with more than one variable; when tuning ML/AI system hyperparameters (learning rate, batch size, model depth interact non-linearly); when performance optimization involves multiple configuration parameters (cache size, thread pool size, connection limits); when process changes involve more than one variable (batch size and WIP limit both changed in the same sprint). DoE applies directly to the §2.1 VERIFY requirement: when a claimed improvement involves multiple simultaneous changes, DoE is the method for attributing improvement to specific variables rather than asserting correlation from uncontrolled data.

**Minimum execution steps (2-4 variables):**

1. List all variables suspected of influencing the outcome. Assign each a low and high value (2-level design). Example: learning rate {0.001, 0.01}, batch size {32, 128}.
2. Select a design type based on variable count and experiment cost:
   - 2-4 variables, cheap experiments: full factorial (2^n runs, so 4, 8, or 16 experiments)
   - 5-7 variables, or expensive experiments: fractional factorial (half or quarter of full factorial)
   - 8+ variables, very expensive experiments: Plackett-Burman screening (identify which variables matter, then run factorial on those)
3. Define the response variable and how it will be measured **before** running any experiments. Record this definition; do not adjust it after seeing results.
4. Run experiments in random order to prevent confounding with time trends.
5. Calculate the main effect of each variable: (mean response at high level) minus (mean response at low level). The variable with the largest absolute main effect is the primary driver.
<a name="REQ-ADD-CI-49"></a>
**REQ-ADD-CI-49** `advisory` `continuous` `soft` `addendum:CI` `deprecated:non-first-principles`
~~Deprecated: guidance, not a requirement.~~

6. Set the primary driver to its optimal level and run a confirmation experiment. The confirmation result must be consistent with the model prediction. If it is not, an interaction effect or uncontrolled variable is present; expand the design to include the interaction term.

**Basic design types:**

- **Full factorial:** all combinations of all variable levels are tested. Provides complete information about main effects and all interactions. Practical when the number of variables is small (2-4) and experiments are cheap (automated tests, simulation). Example: test all combinations of 2 learning rates x 2 batch sizes x 2 regularization values = 8 experiments.

- **Fractional factorial:** a carefully chosen subset of the full factorial. Sacrifices the ability to distinguish some higher-order interactions in exchange for dramatically fewer experiments. Appropriate when experiments are expensive (long training runs, manual deployments) and first-order effects dominate. Example: 16 experiments instead of 64 for a 6-variable system.

- **Screening design (Plackett-Burman):** tests many variables quickly to identify which ones matter at all. Appropriate as a first step when 5 or more variables are suspected. Variables identified as significant in screening are then studied more carefully in a follow-on factorial.

**Connection to §2.1 VERIFY:**

The ESE VERIFY step requires confirming that a claimed improvement exceeds normal process variation. When multiple changes are made simultaneously, VERIFY cannot attribute the improvement to a specific cause. DoE makes multi-variable improvements verifiable by attributing effect to specific variables. Without it, a system that improves when three things change simultaneously does not satisfy the VERIFY requirement, because the change that caused improvement remains unknown and cannot be reliably reproduced or extended.

**Acceptance criteria (all must be true to advance):**

<a name="REQ-ADD-CI-30"></a>
**REQ-ADD-CI-30** `gate` `verify` `hard` `addendum:CI` `per-item` `deprecated:non-first-principles`
~~Deprecated: DoE method prescription.~~

- All planned experimental runs are executed in random order.
- The response variable and measurement method are defined and recorded before any run is executed.
<a name="REQ-ADD-CI-31"></a>
**REQ-ADD-CI-31** `gate` `verify` `hard` `addendum:CI` `per-item` `deprecated:non-first-principles`
~~Deprecated: DoE method prescription.~~

- Main effects are calculated for each variable.
- The primary driver is identified by name and effect magnitude.
<a name="REQ-ADD-CI-32"></a>
**REQ-ADD-CI-32** `gate` `verify` `hard` `addendum:CI` `per-item` `deprecated:non-first-principles`
~~Deprecated: DoE method prescription.~~

- A confirmation experiment is run and its result is consistent with the model prediction. If confirmation fails, the design is expanded and the full sequence restarts.

---

<a name="REQ-ADD-CI-04"></a>
**REQ-ADD-CI-04** `gate` `discover` `hard` `addendum:CI` `per-item`
Gemba (direct observation of current state from actual artifacts) is completed before any improvement hypothesis is formed.

<a name="REQ-ADD-CI-09"></a>
**REQ-ADD-CI-09** `gate` `discover` `hard` `addendum:CI` `per-item`
Observations are written, not inferred.

## Gemba

Gemba (from Japanese: "the actual place") is the practice of observing work directly where it happens, not from reports, summaries, or memory. In manufacturing, Gemba means walking the factory floor. In software delivery, it means reading the actual logs, watching the actual dashboards, reviewing the actual deployment runs, and observing the actual user session data, before any improvement initiative begins. Reports about the process are often filtered, summarized, or out of date; the actual artifacts are the ground truth.

**Lifecycle stages:** Before DEFINE (required before any VSM, Kaizen event, or A3 structured problem solving; observations from actual artifacts must precede any improvement hypothesis); post-mortem and improvement trigger (before forming any hypothesis about a failure mode or systemic problem).

**When to apply:** before starting any VSM, Kaizen event, or A3 structured problem solving; before writing improvement hypotheses; before claiming to understand a failure mode; when metrics are declining and the cause is unclear. Any improvement initiative that begins without direct observation of the current state is operating from assumptions, not evidence.

**Connection to ESE §7 monitoring:** §7 requires health checks, dashboards, audit logs, and telemetry. Gemba is how practitioners use those artifacts. A monitoring dashboard that is never read by the people making improvement decisions is not serving its purpose. The §7 monitoring infrastructure is the Gemba walk mechanism for always-on services: practitioners review it directly before any significant change. An improvement hypothesis formed without reviewing current monitoring data is not grounded in the actual system state.

**Minimum execution steps (two-hour observation session):**

1. **Open the production log viewer** (or CI artifact store). Pull the log for one representative completed work item from start to finish: from first commit to deploy confirmation. Read the actual log entries, not a summary or alert rollup.
2. **Open the §7 monitoring dashboard.** Record the current values of latency, error rate, and queue depth for the service being improved. Write these numbers down with a timestamp.
3. **Pull the last 5 CI/CD pipeline runs.** For each run, record the duration of each stage and note any manual interventions or retries.
4. **Review 5 recent support tickets or §2.7 user feedback items.** Note recurring phrases or recurring points of failure.
5. **Write one paragraph of observations per artifact type** (logs, dashboard, pipeline, feedback). Each paragraph states what you saw, not what you inferred. Include the timestamp of each artifact reviewed.
6. Stop. The Gemba walk is complete when all four artifact types have written observations. Do not begin the VSM, Kaizen pre-work, or A3 current-state section until this is written.

**What to observe in software context:**

- **Production logs:** read the actual log output for a representative work item or user session. Not a log summary or error rate metric; the actual structured log entries from start to finish. What information is present? What is missing? Where does the log go silent in ways that would make debugging a failure difficult?

- **Monitoring dashboards:** review the §7 dashboards for the service being improved. Is latency increasing, stable, or spiking? Are error rates trending? Where are the queues building? The dashboard at observation time is the current-state baseline.

- **Deployment runs:** review the CI/CD pipeline output from the last 5-10 deployments. Where does the pipeline spend the most time? Which steps fail and recover? Which fail and require manual intervention?

- **User sessions (if available):** review session recordings, support tickets, or direct user feedback from the §2.7 feedback mechanism. What are users actually doing? Where do they get stuck or drop off?

**Acceptance criteria (all must be true to advance):**

<a name="REQ-ADD-CI-33"></a>
**REQ-ADD-CI-33** `gate` `verify` `hard` `addendum:CI` `per-item`
Written observations from direct production log review (not a summary or alert rollup) are recorded with a timestamp.

- Written observations from direct production log review (not a summary or alert rollup) are recorded with a timestamp.
- Current values of latency, error rate, and queue depth from the §7 monitoring dashboard are recorded with a timestamp.
<a name="REQ-ADD-CI-34"></a>
**REQ-ADD-CI-34** `advisory` `verify` `soft` `addendum:CI`
Written observations from the last 5 CI/CD pipeline runs are recorded, including stage durations and any manual interventions.

- Written observations from the last 5 CI/CD pipeline runs are recorded, including stage durations and any manual interventions.
- Written observations from 5 recent support tickets or user feedback items are recorded.
<a name="REQ-ADD-CI-35"></a>
**REQ-ADD-CI-35** `gate` `verify` `hard` `addendum:CI` `per-item`
No VSM, Kaizen pre-work, or A3 current-state section has been started before all four observation sets are written.

- No VSM, Kaizen pre-work, or A3 current-state section has been started before all four observation sets are written.

---

## Quality Function Deployment

Quality Function Deployment (QFD) is a structured method for translating user needs (Voice of Customer) into specific, prioritized technical specifications before design begins. It prevents the common failure mode where engineering teams build to internal standards that do not correspond to what users actually need or value. The primary tool is a House of Quality matrix that makes tradeoffs explicit and visible before any implementation decision is made.

<a name="REQ-ADD-CI-50"></a>
**REQ-ADD-CI-50** `advisory` `continuous` `soft` `addendum:CI` `deprecated:non-first-principles`
~~Deprecated: meta-info.~~

**Lifecycle stages:** DEFINE (required when user needs have not yet been translated into acceptance criteria; user feedback gathered through §2.7 enters the House of Quality and exits as measurable §1.1 success metrics).

**When to apply:** before designing a new capability or significant feature; when multiple competing design approaches exist; when user needs have been gathered but not yet translated into requirements; when the team disagrees about what to prioritize. QFD is especially useful when user needs are discovered through the §2.7 feedback mechanism and need to be converted into concrete acceptance criteria for §1.1.

**Connection to ESE:** QFD is the translation layer between §2.7 (User Feedback: the input signal from users) and §1.1 (Before Starting Any Significant Work: the success metrics that define done). User needs gathered through §2.7 enter the House of Quality as customer requirements; the output is a set of prioritized technical specifications that can be stated as measurable §1.1 success metrics.

**Minimum execution steps (one working session):**

1. **Collect user needs from §2.7 feedback.** Write each need in the user's own words: not engineering language. Target 5-10 needs. Example: "I need to import my existing data without re-entering it manually," not "support bulk import."
2. **Score each need 1-5 for importance.** Ask users directly or rank by frequency of feedback. Record the score.
3. **Brainstorm technical specifications** that could address these needs. Write each as a measurable statement. "Fast" is not a spec; "response time under 200ms at p95" is a spec.
4. **Fill the relationship matrix:** for each (need, spec) pair, mark Strong (spec directly delivers this need), Weak (spec partially contributes), or None.
5. **Remove any spec with no Strong or Weak relationships.** It is not delivering user value and does not belong in scope.
<a name="REQ-ADD-CI-51"></a>
**REQ-ADD-CI-51** `advisory` `continuous` `soft` `addendum:CI` `deprecated:non-first-principles`
~~Deprecated: guidance, not a requirement.~~

6. **Mark conflicts:** when two specs trade off against each other (for example, lower response time conflicts with larger batch processing), mark the conflict explicitly. Each conflict is a design decision that must be resolved before BUILD begins.
7. **The specs with the most Strong relationships to high-importance needs become the §1.1 success metrics** for this feature.

**Simplified House of Quality template:**

| Customer Need (What) | Importance (1-5) | Tech Spec A | Tech Spec B | Tech Spec C | Conflict |
|---|---|---|---|---|---|
| {User need 1 in plain language} | {1-5} | {Strong/Weak/None} | | | |
| {User need 2} | {1-5} | | {Strong/Weak/None} | | |

Column definitions:
- **Customer Need:** what the user is trying to accomplish, stated in the user's language (not engineering language)
- **Importance:** how important this need is to the user (1 = minor convenience, 5 = core job requirement)
- **Tech Spec:** a specific, measurable technical specification (e.g., response time under 200ms, supports batch import of 1000 items)
- **Relationship:** Strong (the spec directly delivers this need), Weak (the spec partially contributes), None (unrelated)
- **Conflict:** mark when two specs trade off against each other; these conflicts require explicit design decisions before implementation

**Acceptance criteria (all must be true to advance):**

<a name="REQ-ADD-CI-36"></a>
**REQ-ADD-CI-36** `gate` `verify` `hard` `addendum:CI` `per-item`
Every customer need has at least one Strong or Weak relationship to a tech spec.

- Every customer need has at least one Strong or Weak relationship to a tech spec.
- Every tech spec maps to at least one customer need; specs with no relationships have been removed from scope.
<a name="REQ-ADD-CI-37"></a>
**REQ-ADD-CI-37** `gate` `verify` `hard` `addendum:CI` `per-item`
All conflicts between specs are explicitly marked and each conflict has a recorded resolution decision.

- All conflicts between specs are explicitly marked and each conflict has a recorded resolution decision.
- The surviving specs are written as measurable §1.1 success metrics.

---

<a name="REQ-ADD-CI-05"></a>
**REQ-ADD-CI-05** `artifact` `define` `hard` `addendum:CI`
SIPOC Suppliers are identified before scoping any improvement initiative.

<a name="REQ-ADD-CI-57"></a>
**REQ-ADD-CI-57** `artifact` `define` `hard` `addendum:CI` `deprecated:REQ-ADD-CI-05`
~~Deprecated: consolidated into REQ-ADD-CI-05.~~

<a name="REQ-ADD-CI-58"></a>
**REQ-ADD-CI-58** `artifact` `define` `hard` `addendum:CI` `deprecated:REQ-ADD-CI-05`
~~Deprecated: consolidated into REQ-ADD-CI-05.~~

<a name="REQ-ADD-CI-59"></a>
**REQ-ADD-CI-59** `artifact` `define` `hard` `addendum:CI` `deprecated:REQ-ADD-CI-05`
~~Deprecated: consolidated into REQ-ADD-CI-05.~~

<a name="REQ-ADD-CI-60"></a>
**REQ-ADD-CI-60** `artifact` `define` `hard` `addendum:CI` `deprecated:REQ-ADD-CI-05`
~~Deprecated: consolidated into REQ-ADD-CI-05.~~

<a name="REQ-ADD-CI-10"></a>
**REQ-ADD-CI-10** `artifact` `define` `hard` `addendum:CI` `deprecated:REQ-ADD-CI-05`
~~Deprecated: consolidated into REQ-ADD-CI-05.~~

## SIPOC

SIPOC (Suppliers, Inputs, Process, Outputs, Customers) is a one-page process scope definition that establishes the boundaries of a process before any improvement work begins. Without a SIPOC, improvement initiatives frequently drift in scope, address the wrong part of the process, or produce improvements at one stage that create new problems at the stage they did not map. SIPOC is the scoping gate that must be completed before Value Stream Mapping or a Kaizen event begins.

**Lifecycle stages:** Before DEFINE (required before any VSM or Kaizen event; SIPOC is the IN SCOPE / OUT OF SCOPE statement for the improvement initiative itself, equivalent to the §1.1 scope structure applied to improvement work).

**When to apply:** before any VSM or Kaizen event; when starting a new delivery process; when the team cannot agree on where a process starts and ends; when an improvement initiative has previously drifted in scope.

<a name="REQ-ADD-CI-53"></a>
**REQ-ADD-CI-53** `advisory` `continuous` `soft` `addendum:CI` `deprecated:non-first-principles`
~~Deprecated: meta-info.~~

**Connection to ESE:** SIPOC defines explicit scope boundaries, directly equivalent to the IN SCOPE / OUT OF SCOPE / FUTURE SCOPE structure in §1.1. A SIPOC completed before a VSM or Kaizen event is the §1.1 scope statement for the improvement work itself. Without it, the improvement process violates the same scope discipline required of the features it is improving.

**SIPOC template:**

| Suppliers | Inputs | Process | Outputs | Customers |
|---|---|---|---|---|
| Who provides what the process needs | What enters the process | The process steps (3-7 steps; not detailed sub-steps) | What the process produces | Who receives the outputs |
| {Team, system, or person} | {Work item, data, artifact, decision} | {Step 1} | {Artifact, decision, deployed feature} | {Team, user, or system} |
| | | {Step 2} | | |
| | | {Step 3-7} | | |

**Minimum execution steps:**

1. Fill in the Outputs column first: write what this process produces as concrete, named artifacts or decisions. Do not use vague labels like "results" or "deliverables."
2. Fill in the Customers column: name every team, user, or system that receives each output.
3. Fill in the Inputs column: write what must exist or arrive for the process to begin.
4. Fill in the Suppliers column: name who or what provides each input.
5. Fill in the Process column last: write 3-7 high-level steps only. If more than 7 steps appear, consolidate; sub-steps indicate you are mapping an activity, not a process boundary.
6. Verify that every column has named, specific entries with no blanks.
7. State explicitly, in writing, what is outside the Suppliers-to-Customers boundary for this initiative. Any team member who proposes expanding the scope during the VSM or Kaizen event is referred to this written boundary; new scope is filed as a separate work item.

**Acceptance criteria (all must be true to advance):**

<a name="REQ-ADD-CI-38"></a>
**REQ-ADD-CI-38** `gate` `verify` `hard` `addendum:CI` `per-item`
All five columns have named, specific entries with no blanks and no "TBD" values.

- All five columns have named, specific entries with no blanks and no "TBD" values.
- The Process column has between 3 and 7 high-level steps (not sub-steps).
<a name="REQ-ADD-CI-39"></a>
**REQ-ADD-CI-39** `gate` `verify` `hard` `addendum:CI` `per-item`
What is outside the Suppliers-to-Customers boundary is stated explicitly in writing and agreed to by the team.

- What is outside the Suppliers-to-Customers boundary is stated explicitly in writing and agreed to by the team.

---

## Testing Gap Audit Additions

When using this addendum, extend the [§6.2](../../STANDARDS.md#62-testing-gap-audit) Testing Gap Audit table with the following improvement-process-specific gaps:

| Gap | Typical impact | Priority |
|---|---|---|
| No current-state baseline before improvement initiative | Cannot distinguish improvement from noise | P1 |
| No defined success metric for improvement work items | Improvement cannot be verified as complete | P1 |
| FMEA not updated after significant architectural change | New failure modes unanalyzed | P1 |
| No measurement of rework rate per delivery stage | Hidden factory invisible; stage metrics misleadingly positive | P2 |
| Process capability not tracked over time | Common cause vs. special cause indistinguishable | P2 |
| Kaizen events completed without post-event measurement | Cannot confirm improvement occurred | P2 |
| Waste audit results not filed as work items | Identified waste accumulates; no accountability | P2 |

