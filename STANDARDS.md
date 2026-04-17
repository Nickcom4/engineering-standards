---
version: 2.0.0
---

# Excellence Standards - Engineering

> The standard is not "does it work." The standard is: is it provably correct, consistently reproducible, fully documented, monitored for drift, and ready for someone else to maintain without asking you a question?

These standards apply to all software projects regardless of domain, team size, or technology stack. They are gates that block progress when violated, not aspirational guidelines. This document is complete for the principles it establishes. It is not exhaustive for every possible scenario, and it is not intended to be.

**Theoretical foundations.** Every requirement in this standard traces to one or more of these timeless engineering principles, not to current convention or fashion: (1) Deming's System of Profound Knowledge (appreciation for a system, knowledge of variation, theory of knowledge, psychology of safety); (2) Theory of Constraints (throughput is limited by the bottleneck, not by average capacity; Goldratt, 1984); (3) Conway's Law (system structure mirrors organizational communication structure; Conway, 1968); (4) the DORA research program (delivery performance is measurable and improvable through specific capabilities); (5) SRE reliability engineering (design for failure, error budgets, observability as a prerequisite for operation). Where a requirement includes a numeric threshold, the generating principle and the derivation are stated inline. Numeric defaults are calibration points that projects may adjust with documented rationale in their standards-application document; the principle behind the threshold is the requirement, not the number itself. See [docs/background.md](docs/background.md) for the full research corpus.

Every project that adopts these standards maintains its own application document capturing current state, component gaps, and project-specific constraints. See [starters/standards-application.md](starters/standards-application.md) for a blank template. For scenario-specific extensions covering common enterprise contexts, see the [Addenda](#addenda) section.

**Where to start:** see [docs/adoption.md](docs/adoption.md) for how to bring these standards into your project: submodule setup, first steps, what your project produces, and how to adopt into a pre-existing codebase. Per [ADR-018](docs/decisions/ADR-018-adoption-guide-separate-document.md).

---

## Table of Contents

- [1. Scope and Product Discipline](#1-scope-and-product-discipline)
- [2. Methodology](#2-methodology)
- [3. Architecture and Design](#3-architecture-and-design)
- [4. Documentation Standards](#4-documentation-standards)
- [5. Code and Deployability](#5-code-and-deployability)
- [6. Testing and Output Quality](#6-testing-and-output-quality)
- [7. Monitoring and Observability](#7-monitoring-and-observability)
- [8. Learning from Failure](#8-learning-from-failure)
- [9. Technology Adoption](#9-technology-adoption)
- [Addenda](#addenda)

This document references external standards that are version-tracked in [dependencies.md](dependencies.md).

---

## 1. Scope and Product Discipline

This standard defines software delivery requirements: process, documentation, quality, testing, monitoring, and incident response. It is built to a rigor equivalent to ISO 9001 and ISO 27001 for self-verification purposes. It does not define: formal risk assessment frameworks, operating evidence requirements for external certification, physical security controls, or controls for regulated industries (PCI DSS, HIPAA, SOC 2). Projects seeking external attestation should treat this standard as a foundation and supplement it with the framework appropriate to their certification target.

Scope is established before any design or implementation begins. Unscoped work produces unclear deliverables, unclosable work items, and unstoppable scope creep.

### 1.1 Before Starting Any Significant Work

**"Significant work" defined:** A work item is significant (requiring a full problem statement, scope boundaries, and success metrics before design begins) when it meets any of the following: (1) the cost of restarting after a wrong approach would materially exceed the cost of upfront problem definition (most teams find this crossover at roughly a half-day of effort; calibrate to your context), (2) spans more than one lifecycle phase, or (3) its incompletion would block another open work item. The generating principle: invest in clarity when the cost of ambiguity exceeds the cost of definition. Below all three thresholds, acceptance criteria are sufficient; a full §1.1 problem statement is not required.

**Problem statement (not the solution):**
- Who has this problem?
- How frequently does it occur?
- What do they currently do instead?
- What is the cost of the current approach? Consider both the cost of poor quality (rework, incidents, support time, and the ongoing interest on unresolved technical debt) and the cost of good quality (testing, reviews, automation, and process discipline). The lowest-cost approach is not necessarily the one that invests least in quality; it is the one that minimizes total quality cost.
- What does solved look like - concretely?

**First principles check:**
- What is this fundamentally trying to do?
- What constraints cannot change?
- What is the simplest solution that meets the requirement?

**Explicit scope boundaries:**
- IN scope: {explicit list}
- OUT of scope: {explicit list - this is equally important and often omitted}
- FUTURE scope: {not now, not never - prevents false urgency}

**Success metrics** - each metric must be specific (names what is being measured), measurable (has a numeric threshold or binary pass/fail), achievable (the team can influence the outcome), relevant (connected to the problem statement above), and time-bounded (states when it will be measured):

<a name="REQ-1.1-06"></a>
**REQ-1.1-06** `gate` `define` `hard` `all` `per-item` `deprecated:REQ-1.1-07`
~~Deprecated: superseded by REQ-1.1-07 through REQ-1.1-12 (elemental SMART criteria).~~

<a name="REQ-1.1-07"></a>
**REQ-1.1-07** `gate` `define` `hard` `all` `per-item` `deprecated:REQ-1.1-08`
~~Deprecated: consolidated into REQ-1.1-08 (measurability subsumes specificity).~~

<a name="REQ-1.1-08"></a>
**REQ-1.1-08** `gate` `define` `hard` `all` `per-item`
Each success metric has a numeric threshold or binary pass/fail condition.

<a name="REQ-1.1-09"></a>
**REQ-1.1-09** `advisory` `define` `soft` `all`
Each success metric is achievable: the team can influence the outcome.

<a name="REQ-1.1-10"></a>
**REQ-1.1-10** `gate` `define` `hard` `all` `per-item` `deprecated:REQ-1.1-02`
~~Deprecated: consolidated into REQ-1.1-02 (relevance enforced by problem-statement check).~~

<a name="REQ-1.1-11"></a>
**REQ-1.1-11** `gate` `define` `hard` `all` `per-item`
Each success metric states when it will be measured.

<a name="REQ-1.1-12"></a>
**REQ-1.1-12** `gate` `define` `hard` `all` `per-item`
Each success metric states the measurement method.
- {What is measured, target threshold, measurement method, evaluation date}

**SMART metrics scope:** REQ-1.1-07 through REQ-1.1-12 apply to any work item for which a §1.1 problem statement is required (significant work as defined above). They do not apply to chore items, test additions, internal refactors, or documentation updates where acceptance criteria are the sufficient completeness gate. Applying SMART criteria to every signal regardless of type adds documentation overhead without proportional signal clarity.

**Failure criteria** (when to stop or roll back):
- If {metric} worsens beyond {threshold}, revert or escalate

<a name="REQ-1.1-01"></a>
**REQ-1.1-01** `gate` `define` `hard` `all` `per-item`
A problem statement is documented before design or implementation begins.

<a name="REQ-1.1-13"></a>
**REQ-1.1-13** `gate` `define` `hard` `all` `per-item`
The problem statement identifies who has the problem.

<a name="REQ-1.1-14"></a>
**REQ-1.1-14** `advisory` `define` `soft` `all`
The problem statement states how frequently the problem occurs.

<a name="REQ-1.1-15"></a>
**REQ-1.1-15** `gate` `define` `hard` `all` `per-item`
The problem statement describes the current approach or workaround.

<a name="REQ-1.1-16"></a>
**REQ-1.1-16** `advisory` `define` `soft` `all`
The problem statement quantifies the cost of the current state.

<a name="REQ-1.1-17"></a>
**REQ-1.1-17** `gate` `define` `hard` `all` `per-item`
The problem statement describes what solved looks like.

<a name="REQ-1.1-02"></a>
**REQ-1.1-02** `gate` `define` `hard` `all` `per-item`
A first principles check (3 questions: fundamentally doing, constraints, simplest solution) is completed before design begins.

<a name="REQ-1.1-03"></a>
**REQ-1.1-03** `gate` `define` `hard` `all` `per-item`
Explicit IN scope and OUT of scope lists are present in the work item or scoping document.

<a name="REQ-1.1-04"></a>
**REQ-1.1-04** `gate` `define` `hard` `all` `per-item` `deprecated:REQ-1.1-07`
~~Deprecated: superseded by REQ-1.1-07 through REQ-1.1-12 (elemental metric criteria).~~

<a name="REQ-1.1-05"></a>
**REQ-1.1-05** `artifact` `define` `hard` `all`
Failure criteria with specific metric thresholds and rollback actions are defined before implementation begins.

### 1.2 Document Progression

For complex products, write a capabilities document before the Product Requirements Document (PRD). A capabilities document describes what users will be able to do in plain, observable terms - no implementation details. This prevents the PRD from becoming an implementation spec in disguise. The natural progression:

1. **Problem research** - who has the problem, what exists today, what does solved look like. Template: [templates/problem-research.md](templates/problem-research.md)
2. **Capabilities / abilities** - what will users be able to do? (observable, not technical). Template: [templates/capabilities.md](templates/capabilities.md)
3. **PRD** - specific requirements, scope, acceptance criteria, out-of-scope. Template: [templates/prd.md](templates/prd.md)
4. **Architecture and ADRs** - how to build it, what tradeoffs were accepted. Templates: [templates/architecture-doc.md](templates/architecture-doc.md), [templates/adr.md](templates/adr.md)
5. **Implementation** - the lifecycle from [Section 2](#2-methodology)

Not every project needs every step. A bug fix enters at DISCOVER and proceeds to DEFINE after triage - it does not use the document progression (steps 1-4 above), but the [§2.1 work item lifecycle](#21-the-lifecycle) (DISCOVER, DEFINE, BUILD, VERIFY, DOCUMENT, DEPLOY, MONITOR, CLOSE) still applies in full. A new product starts at step 1.

**Lifecycle stage mapping.** The document progression spans the first three lifecycle stages:

| §1.2 Step | Lifecycle stage | Artifact |
|---|---|---|
| Step 1: Problem research | DISCOVER D2 (characterize) | [templates/problem-research.md](templates/problem-research.md) |
| Step 2: Capabilities | Bridge: late DISCOVER / early DEFINE | [templates/capabilities.md](templates/capabilities.md) |
| Step 3: PRD | DEFINE | [templates/prd.md](templates/prd.md); gate authority approval required before DESIGN |
| Step 4: Architecture + ADRs | DESIGN | [templates/architecture-doc.md](templates/architecture-doc.md), [templates/adr.md](templates/adr.md) |
| Step 5: Implementation | BUILD through CLOSE | Remainder of §2.1 lifecycle |

<a name="REQ-1.2-04"></a>
**REQ-1.2-04** `gate` `define` `hard` `type:feature` `per-item`
Each §1.2 step is complete when its gate is satisfied, not merely when a document exists.

<a name="REQ-1.2-05"></a>
**REQ-1.2-05** `gate` `define` `hard` `type:feature` `per-item`
Producing a document without passing its gate is not completing the step.

**Completion gates:** Each step is complete when its gate is satisfied, not merely when a document exists. Each template carries an explicit gate: problem research has a proceed/no-proceed decision; capabilities and PRD both require gate authority approval before the next step begins; architecture is complete when all qualifying ADRs are accepted and any required FMEA is done. Producing a document without passing its gate is not completing the step - it is creating a draft that has not yet been agreed on.

**Measurement-driven investigations:** When an investigation's acceptance criterion requires measured outcomes from a working implementation (the prototype is the measurement instrument and the investigation cannot conclude without it), the implementation work may begin before the investigation work item is closed. Scope the implementation specifically to produce the measurement data needed, not as a production build. The investigation work item stays open until measurement is complete. File a separate implementation work item for the prototype with a dependency on the parent investigation. This pattern is equivalent to the Measure phase of DMAIC (Define-Measure-Analyze-Improve-Control), where measurement system setup is defined work that precedes analysis.

<a name="REQ-1.2-01"></a>
**REQ-1.2-01** `gate` `define` `hard` `type:feature` `per-item`
The §1.2 document progression (problem research, capabilities, PRD, architecture) is followed in order for new products and significant features.

<a name="REQ-1.2-06"></a>
**REQ-1.2-06** `gate` `define` `hard` `type:feature` `per-item`
Each step's gate is satisfied before the next step begins.

<a name="REQ-1.2-02"></a>
**REQ-1.2-02** `artifact` `define` `hard` `type:feature` `deprecated:non-first-principles`
~~Deprecated: not all products need a capabilities doc; gate-not-document principle in REQ-1.2-04 covers intent.~~

<a name="REQ-1.2-07"></a>
**REQ-1.2-07** `gate` `define` `hard` `all` `per-item`
Each document in the §1.2 progression has its gate passed (approval, proceed/no-proceed decision) before the next document begins.

<a name="REQ-1.2-03"></a>
**REQ-1.2-03** `gate` `define` `hard` `type:feature` `per-item`
Each §1.2 step is complete when its gate is satisfied, not merely when a document exists.

### 1.3 Roadmap Discipline

For any project with more than one planned release, define what is in each phase before starting Phase 1. A "Phase 2" with no defined scope is a wish list, not a plan.

Each phase defines:
- **What is included** - explicit deliverables, not vague themes
- **What is explicitly excluded** - prevents scope from expanding silently into the next phase
<a name="REQ-1.3-02"></a>
**REQ-1.3-02** `gate` `define` `hard` `all` `per-item`
Each phase's measurable milestone is binary verifiable: it either passes or does not, with no judgment required.

- **Measurable milestone** - the specific, observable condition that marks the phase as complete. The test: could someone who did not build this phase verify it independently, without asking the team? Weak: "core features are working." Strong: "all P1 PRD requirements pass acceptance testing in the staging environment and P95 latency is at or below the §7.5 SLO target." The difference is binary verifiability - a milestone either passes or it does not, with no judgment required about whether it is "working enough."
- **Dependencies on prior phases** - what must be true before this phase can start
- **Decision point** - what will be evaluated at the end of this phase to determine whether the next phase proceeds, pivots, or stops
- **Effort awareness** - before committing to a timeline, the team must have a credible understanding of the effort required. The specific estimation technique (time-based, relative sizing, probabilistic forecasting, or another method) is a project decision. Committing to a deadline without understanding the effort is not a plan - it is a guess with a date on it

<a name="REQ-1.3-01"></a>
**REQ-1.3-01** `artifact` `define` `hard` `all`
Each planned phase defines what is included.

<a name="REQ-1.3-03"></a>
**REQ-1.3-03** `artifact` `define` `hard` `all`
Each planned phase defines what is excluded.

<a name="REQ-1.3-04"></a>
**REQ-1.3-04** `artifact` `define` `hard` `all`
Each planned phase defines a binary measurable milestone.

<a name="REQ-1.3-05"></a>
**REQ-1.3-05** `artifact` `define` `hard` `all` `deprecated:non-first-principles`
~~Deprecated: trivial or obvious; covered implicitly by REQ-1.3-06 go/no-go.~~

<a name="REQ-1.3-06"></a>
**REQ-1.3-06** `artifact` `define` `hard` `all`
Each planned phase defines a decision point for evaluating whether to continue.

<a name="REQ-1.3-07"></a>
**REQ-1.3-07** `artifact` `define` `hard` `all` `deprecated:non-first-principles`
~~Deprecated: vague with no verifiable standard.~~

### 1.4 Project First Principles

Every project defines its own non-negotiable constraints. These live in the project's own [application document](starters/standards-application.md), not here. They are reviewed at the start of every work session.

Template for a project's first principles:

1. **Scope statement** - what this system IS and IS NOT in one sentence
2. **Source of truth** - for tasks, for knowledge, for state: name the specific tool or file
3. **Verifiability standard** - what done requires as evidence
4. **Gate authority** - if the gate does not pass, the work is not done. For projects governed by ESE, ESE compliance is the gate: a practitioner following ESE does not require human sign-off on every change. Human approval is still required for the specific high-stakes action types named in item 6. For ESE itself, the person who owns the standard is the gate authority - changes to the standard require their explicit review before merge.
5. **Speed vs. consistency** - which wins, and why
6. **Human approval boundary** - name the specific action types requiring explicit human approval
7. **Monitoring requirement** - every production feature has observable confirmation it works
8. **Documentation standard** - documentation is part of the feature, not cleanup afterward

<a name="REQ-1.4-01"></a>
**REQ-1.4-01** `artifact` `session-start` `hard` `all`
The project's application document contains the scope statement first principle.

<a name="REQ-1.4-02"></a>
**REQ-1.4-02** `artifact` `session-start` `hard` `all`
The project's application document contains the source of truth first principle.

<a name="REQ-1.4-03"></a>
**REQ-1.4-03** `artifact` `session-start` `hard` `all`
The project's application document contains the verifiability standard first principle.

<a name="REQ-1.4-04"></a>
**REQ-1.4-04** `artifact` `session-start` `hard` `all`
The project's application document contains the gate authority first principle.

<a name="REQ-1.4-05"></a>
**REQ-1.4-05** `artifact` `session-start` `hard` `all` `deprecated:non-first-principles`
~~Deprecated: philosophical statement, not actionable.~~

<a name="REQ-1.4-06"></a>
**REQ-1.4-06** `artifact` `session-start` `hard` `all`
The project's application document contains the human approval boundary first principle.

<a name="REQ-1.4-07"></a>
**REQ-1.4-07** `artifact` `session-start` `hard` `all`
The project's application document contains the monitoring requirement first principle.

<a name="REQ-1.4-08"></a>
**REQ-1.4-08** `artifact` `session-start` `hard` `all`
The project's application document contains the documentation standard first principle.

<a name="REQ-1.4-09"></a>
**REQ-1.4-09** `gate` `session-start` `hard` `all` `per-item` `deprecated:non-first-principles`
~~Deprecated: unverifiable ritual; no binary test for "reviewed."~~

### 1.5 Domain Applicability

The practices in this standard are calibrated for the Complicated domain: problems where cause and effect are not self-evident but can be determined through expert analysis. In Complicated work, documented processes, defined lifecycles, and prescribed quality gates produce reliable outcomes because the path from problem to solution is knowable before execution begins. Most software delivery falls here.

Not all engineering work is Complicated. In the Complex domain (novel AI architectures, genuinely new problem spaces, systems with emergent behavior), cause and effect are only apparent in retrospect. No amount of up-front analysis makes the path knowable in advance. The appropriate response is probe-sense-respond: run small experiments, observe what emerges, and adapt. Applying prescriptive gates and defined lifecycles to Complex work constrains the experimentation needed to discover what actually works.

This standard does not define how to work in the Complex domain. Teams encountering Complex-domain work should apply the documentation and learning practices here: session logs ([§4.6](#46-work-session-logs)), post-mortems ([§8.2](#82-post-mortem-format)), and lessons-learned registry ([§8.3](#83-lessons-learned-registry)) capture what is discovered without enforcing a predetermined process. When work transitions from Complex to Complicated (once the approach is understood and repeatable), the full standard applies.

**Practical classification:** Two questions determine which domain applies. First: can you write acceptance criteria before you start? If yes - the solution space is knowable in advance, this is Complicated work, and ESE applies in full. Second: does the correct approach depend on what experiments reveal rather than on analysis of known information? If yes - this is Complex work; apply probe-sense-respond until the approach is established, then write acceptance criteria and apply ESE in full. When genuinely uncertain, treat the work as Complex, run a time-boxed probe (see [§1.2 measurement-driven investigations](#12-document-progression)), and reassess. The signal that work has crossed from Complex to Complicated: you can now write acceptance criteria you are confident will not change based on what you discover next.

Reference: Snowden, D.J. and Boone, M.E. (2007). A Leader's Framework for Decision Making. *Harvard Business Review*, 85(11), 68-76. See [hbr.org/2007/11/a-leaders-framework-for-decision-making](https://hbr.org/2007/11/a-leaders-framework-for-decision-making), tracked in [dependencies.md](dependencies.md).

**Machine-derived enforcement and external imposition.** An enforcement tool may apply ESE-derived gate rules to a target repository operating in a Complicated-domain work session even when the target repository has not explicitly adopted ESE. The rationale: Complicated-domain work follows analyzable patterns; ESE requirements describe those patterns in a published, versioned standard. Applying them to an unadopted repo is external analysis against a published standard, not imposition of a private convention. Two carve-outs apply: (1) repositories classified as Complex-domain per the criteria above are exempt (probe-sense-respond work cannot satisfy predefined gates by design); (2) a project may document an explicit ESE carve-out in its standards-application.md, which takes precedence over externally applied rules for that project.

<a name="REQ-1.5-01"></a>
**REQ-1.5-01** `gate` `continuous` `hard` `all` `per-item`
An enforcement tool applying ESE-derived rules to a target repository in a Complicated-domain work session must exempt repositories whose standards-application.md documents an explicit ESE carve-out for the rule in question.

<a name="REQ-1.5-02"></a>
**REQ-1.5-02** `gate` `continuous` `hard` `all` `per-item`
Complex-domain work sessions are exempt from externally applied ESE enforcement rules.

<a name="REQ-1.5-03"></a>
**REQ-1.5-03** `gate` `continuous` `hard` `all` `per-item` `deprecated:REQ-1.5-02`
~~Deprecated: consolidated into REQ-1.5-02.~~

---

## 2. Methodology

### 2.1 The Lifecycle

Every piece of work that enters the delivery system follows this sequence. Signals discarded or parked at DISCOVER do not enter the delivery system and do not follow this sequence. Skipping a step that applies is a gate violation.

<a name="REQ-2.1-01"></a>
**REQ-2.1-01** `gate` `continuous` `hard` `all` `per-item`
Every work item follows the DISCOVER-DEFINE-DESIGN-BUILD-VERIFY-DOCUMENT-DEPLOY-MONITOR-CLOSE sequence.

<a name="REQ-2.1-18"></a>
**REQ-2.1-18** `gate` `continuous` `hard` `all` `per-item` `deprecated:REQ-2.1-01`
~~Deprecated: consolidated into REQ-2.1-01 (negative restatement).~~

#### Process Decision Tree

Answer these five questions in order before starting any work item. The most consequential questions run first.

**Step 1 - Domain ([§1.5](#15-domain-applicability)).** Can you write acceptance criteria before starting? Does the correct approach depend on what experiments reveal? Complex domain: probe-sense-respond; ESE does not govern the probe cycle. Complicated domain: continue to Step 2.

**Step 2 - Urgency (class of service, [§2.2](#22-work-item-discipline)).** Expedite class (active outage, data loss, security breach in progress): resolve first, back-fill documentation after. Fixed-date class: track the countdown. Standard or Intangible: normal flow; continue.

**Step 3 - Scope (DISCOVER depth).** New product or major feature: D2 characterization then [§1.2 document progression](#12-document-progression) before DEFINE. Routine feature or known-cause defect: D0 capture then D1 triage, then DEFINE. Unknown-cause defect: D0 then D1 then D2 characterization, then DEFINE. Investigation: D2 is the primary work.

<a name="REQ-2.1-14"></a>
**REQ-2.1-14** `gate` `define` `hard` `all` `per-item` `deprecated:non-first-principles`
~~Deprecated: unverifiable "answered in order" ritual.~~

**Step 4 - Type ([§2.2](#22-work-item-discipline)).** Assign one of 9 types. Type determines lifecycle gates and close conditions.

**Step 5 - Addenda overlay.** Check each addendum that applies to this project. Requirements from applicable addenda stack with the base requirements at each stage. The per-stage blocks below show which addenda activate at which stage.

```
DISCOVER -> DEFINE -> DESIGN -> BUILD -> VERIFY -> DOCUMENT -> DEPLOY -> MONITOR -> CLOSE
```

This lifecycle maps to PDCA and DMAIC quality frameworks:

| PDCA Phase | ESE Lifecycle Stages |
|---|---|
| **Plan** | DISCOVER + DEFINE + DESIGN |
| **Do** | BUILD |
| **Check** | VERIFY |
| **Act** | DOCUMENT + DEPLOY + MONITOR + CLOSE (feeding back into DISCOVER) |

PDCA's Plan phase includes signals that are evaluated but discarded or parked at DISCOVER. A signal that does not proceed to DEFINE is evaluated, not planned work.

| DMAIC Phase | ESE Lifecycle Stages |
|---|---|
| **Define** | DISCOVER + DEFINE |
| **Measure** | Baseline measurement in DEFINE (for improvement-type work items) and metric verification in VERIFY |
| **Analyze** | DISCOVER depth D2 (root cause characterization and problem research) and DESIGN qualification |
| **Improve** | BUILD |
| **Control** | MONITOR + CLOSE + lessons-learned and anti-pattern registries |

**DISCOVER:** Signals arrive through the project's [§2.7](#27-user-feedback) feedback channel. DISCOVER operates at three depth levels determined by what is already known about the signal:

| Depth | Name | Entry condition | Activities | Artifact | Exit |
|---|---|---|---|---|---|
| **D0** | Capture | Signal observed | Record raw observation and source | Row appended to intake log ([starters/intake-log.md](starters/intake-log.md) or tracked system) | Signal captured; triage scheduled. Target: under 2 minutes. |
| **D1** | Triage | Intake log entry exists | Evidence check; duplicate check; consult [lessons-learned (§8.3)](#83-lessons-learned-registry) and [anti-pattern (§8.4)](#84-anti-pattern-registry) registries | Triage decision recorded | One of four exits: **promote** (confirmed, cause known) to DEFINE; **investigate** (suspected, unconfirmed) to type=investigation work item; **park** (real but not now) with revisit trigger; **discard** (not real or duplicate) with reason |
| **D2** | Characterize | Signal promoted but AC cannot yet be written | Root cause analysis for defects (5 Whys, fishbone); problem research for features (see [templates/problem-research.md](templates/problem-research.md) abbreviated use); baseline measurement for improvements | Investigation or problem research document | Root cause identified, OR problem characterized enough to write observable AC, OR baseline measured |

D0 and D1 apply to every signal. D2 applies when the signal is confirmed but AC cannot yet be written. For expedite class signals (active outages): fix first, then back-fill D0/D1 documentation after resolution.

<a name="REQ-2.1-19"></a>
**REQ-2.1-19** `artifact` `discover` `hard` `all`
Every observed signal has a D0 intake log entry recording the raw observation and source.

<a name="REQ-2.1-20"></a>
**REQ-2.1-20** `gate` `discover` `hard` `all` `per-item`
D1 triage includes an evidence check, a duplicate check, and consultation of the lessons-learned and anti-pattern registries before a triage decision is recorded.

<a name="REQ-2.1-21"></a>
**REQ-2.1-21** `gate` `discover` `hard` `all` `per-item`
D1 triage produces exactly one of four decisions: promote to DEFINE, investigate, park with a revisit trigger, or discard with a reason.

<a name="REQ-2.1-22"></a>
**REQ-2.1-22** `artifact` `discover` `hard` `all`
When a signal is confirmed but AC cannot yet be written, D2 characterization produces an investigation or problem research document before DEFINE begins.

<a name="REQ-2.1-23"></a>
**REQ-2.1-23** `artifact` `discover` `hard` `type:expedite`
Expedite class signals are resolved first; D0 and D1 documentation is back-filled after resolution.

<a name="REQ-2.1-44"></a>
**REQ-2.1-44** `gate` `discover` `hard` `all` `per-item` `deprecated:non-first-principles`
~~Deprecated: ceremony; recording registry entries consulted does not prevent failures.~~

<a name="REQ-2.1-45"></a>
**REQ-2.1-45** `gate` `close` `hard` `type:expedite` `per-item`
Expedite work items are not closed until D0 and D1 back-fill documentation is verified complete.

**DEFINE:** Write acceptance criteria before starting any implementation work - code, documentation, configuration, or infrastructure. What does done look like? Observable, binary, and measurable. "Loads in under 2s on a 3G connection" not "should be fast." If this work item claims an improvement outcome (type=improvement), record the baseline measurement and method before BUILD begins.

<a name="REQ-2.1-02"></a>
**REQ-2.1-02** `gate` `define` `hard` `all` `per-item`
Acceptance criteria are written before any implementation work (code, documentation, configuration, or infrastructure) begins.

<a name="REQ-2.1-12"></a>
**REQ-2.1-12** `gate` `define` `hard` `type:improvement` `per-item`
Improvement work items record the baseline measurement and method before BUILD begins.

**DESIGN:** Run the qualification checklist (see [work item template](templates/work-item.md) DESIGN section) before BUILD:

- D2 artifact read? Before writing any ADR or architecture document, check whether a D2 characterization artifact exists for this work item (problem research, investigation document, or root cause analysis). If one exists, read it and cite its path in the ADR Context section. If none exists and none is required (routine feature or known-cause defect per step 3 above), state "D2: not required" explicitly in the ADR Context section.
- ADR required? Introduces a new component, replaces an existing approach, adds an external dependency, or alters how services communicate -> write an ADR. See [§4.2](#42-adr-format).
- FMEA required? Touches authentication, payments, data mutation, or external integrations -> complete both a DFMEA (component failure modes) and review the project PFMEA (process sequence failure modes). High-RPN failure modes and any with Severity 9-10 require design changes before BUILD. See [templates/fmea.md](templates/fmea.md).
- Architecture doc exists? If this change touches a component, verify an architecture doc exists per [§3.3](#33-architecture-doc-backlog). If none exists, file an issue for it before proceeding.

**"Qualifying changes" defined:** A qualifying change (triggering PFMEA review) is one that alters: (1) a lifecycle phase definition, (2) a tool or API surface (new actions, changed preconditions, added or removed external integrations), or (3) how services communicate (protocol, schema, authentication boundary). Qualifying changes do NOT include: prompt or copy updates, test additions, internal refactors with no external surface change, log or metric format changes, or dependency upgrades with no API surface change.

**FMEA type distinction:** Two types of failure analysis apply at the same qualifying triggers. A DFMEA (Design FMEA) analyzes the component being changed: what can fail in this feature, what does the user experience, what controls prevent or detect the failure. A PFMEA (Process FMEA) analyzes the delivery process: what process step could be skipped, done out of order, produce insufficient output for the next step, or enter a recursive loop that never exits. Both are required because a component that passes all design checks can still reach users through a broken process (skipped VERIFY, wrong deployment sequence, untested rollback). The PFMEA is a living project document reviewed at each qualifying change, not rebuilt from scratch. For recurring bugs, the recurrence itself is a PFMEA failure mode: the post-mortem-to-prevention-to-verification loop did not close.

<a name="REQ-2.1-03"></a>
**REQ-2.1-03** `artifact` `design` `hard` `type:feature AND (type:component OR type:security)`
An ADR exists when the work item introduces a new component, replaces an existing approach, adds an external dependency, or alters how services communicate.

<a name="REQ-2.1-04"></a>
**REQ-2.1-04** `artifact` `design` `hard` `type:feature AND type:security`
A DFMEA is completed when the work item touches authentication, payments, data mutation, or external integrations.

<a name="REQ-2.1-35"></a>
**REQ-2.1-35** `gate` `design` `hard` `type:feature AND type:security` `per-item`
The project PFMEA is reviewed when the work item touches authentication, payments, data mutation, or external integrations.

<a name="REQ-2.1-36"></a>
**REQ-2.1-36** `gate` `close` `hard` `type:bug` `per-item`
When a bug recurs, the PFMEA is updated with the process failure that allowed recurrence.

<a name="REQ-2.1-54"></a>
**REQ-2.1-54** `gate` `design` `hard` `type:feature OR type:component` `per-item`
Before writing an ADR or architecture document: a D2 characterization artifact is either cited in the ADR Context section (path verified to exist) or explicitly stated as not required with rationale.

<a name="REQ-2.1-17"></a>
**REQ-2.1-17** `gate` `design` `hard` `all` `per-item`
High-RPN failure modes and any with Severity 9-10 have design changes before BUILD begins.

<a name="REQ-2.1-37"></a>
**REQ-2.1-37** `gate` `design` `hard` `all` `per-item`
Every FMEA failure mode above the RPN threshold has a named control recorded in the FMEA controls summary before the FMEA iteration closes.

<a name="REQ-2.1-38"></a>
**REQ-2.1-38** `gate` `verify` `hard` `all` `per-item`
Every named control in the FMEA controls summary has either an implemented artifact or a tracked work item before the work item advances past VERIFY.

<a name="REQ-2.1-39"></a>
**REQ-2.1-39** `gate` `close` `hard` `all` `per-item`
No work item is closed while its FMEA has above-threshold failure modes with unimplemented controls unless each has a tracked dependency-linked work item.

<a name="REQ-2.1-41"></a>
**REQ-2.1-41** `gate` `design` `hard` `all` `per-item`
The RPN threshold is defined in the FMEA before failure mode scoring begins.

<a name="REQ-2.1-48"></a>
**REQ-2.1-48** `advisory` `design` `soft` `all`
The default RPN threshold is 75; the default severity threshold is 7. Projects override these in their standards-application document with documented rationale.

**Rescoring scope:** Full rescoring and RPN documentation is required only for failure modes where Severity ≥ 7 OR RPN ≥ 75. Failure modes below both thresholds are logged with detection controls only; they do not require design changes or a full rescore cycle. This prevents checklist expansion into low-signal failure modes that dilute attention from genuinely high-severity risks.

<a name="REQ-2.1-49"></a>
**REQ-2.1-49** `gate` `verify` `hard` `all` `per-item`
FMEA derived sections (High-Severity table, RPN Summary, Controls Summary, Review Checklist) are either auto-generated from the source FM tables or validated for consistency with them before close.

<a name="REQ-2.1-50"></a>
**REQ-2.1-50** `gate` `close` `hard` `all` `per-item`
When a new section is added to a starter template, the project's corresponding instance document is updated in the same work period.

<a name="REQ-2.1-51"></a>
**REQ-2.1-51** `gate` `continuous` `hard` `all` `per-item`
The project's own artifacts comply with the standards it has adopted: a compliance review that would fail an adopting project also fails the standard's own repository.

<a name="REQ-2.1-52"></a>
**REQ-2.1-52** `artifact` `document` `soft` `all`
The default effective scope for all requirements is continuous (applies whenever the activity occurs). Requirements that deviate from this default state their scope explicitly in the CHANGELOG entry that introduces them.

<a name="REQ-2.1-53"></a>
**REQ-2.1-53** `gate` `verify` `hard` `all` `per-artifact`
Every checked item in an FMEA Controls Summary that references a script file is verified: the script exists and is called from CI.

<a name="REQ-2.1-42"></a>
**REQ-2.1-42** `gate` `design` `hard` `all` `per-item`
After a corrective action is implemented, the failure mode is rescored with the control in place.

<a name="REQ-2.1-43"></a>
**REQ-2.1-43** `gate` `verify` `hard` `all` `per-item`
All count references, RPN values, and status claims within an FMEA document are internally consistent at close.

<a name="REQ-2.1-40"></a>
**REQ-2.1-40** `gate` `continuous` `hard` `all` `per-item`
Every work period begins by verifying that the prior work period's close obligations were fulfilled: no unfinished deliverables, no unpublished changes, no work items abandoned mid-lifecycle without documented handoff.

**BUILD:** Code with tests. Tests written alongside or before the code. Testing requirements defined in [Section 6](#6-testing-and-output-quality).

<a name="REQ-2.1-05"></a>
**REQ-2.1-05** `gate` `build` `hard` `all` `per-item`
Tests are written alongside or before the code they cover.

**VERIFY:** Unit tests pass. Integration tests pass. End-to-end tests run against a live environment. Output reviewed by a human. Performance measured, not assumed. Record the VERIFY answer in the work item's VERIFY field (see [work item template](templates/work-item.md)) before CLOSE: what was specifically verified and what the result was.

When the claimed outcome is an improvement (faster, more reliable, fewer defects), verify that the measured change exceeds normal process variation. A small directional movement that falls within the range of historical fluctuation is not evidence of improvement; it is noise. State what the baseline was, what changed, and why the difference is meaningful. The specific method for distinguishing signal from noise is a project decision (see §7.7); the requirement to make that distinction before declaring an improvement verified is not.

For documentation-only changes, the verification checklist is:
- [ ] Every internal link resolves to a valid target
- [ ] No formatting defects: no corrupt tables, no orphaned lines, no mismatched heading levels
- [ ] No AI-generated typographic characters: no em dashes, en dashes, or double hyphens used as sentence dashes
- [ ] All cross-references are hyperlinks, not plain text
- [ ] No sentence fragments, no duplicate sentences within or across sections
- [ ] Every template section covers the requirements from its governing section in the standard
- [ ] Changelog entry written

<a name="REQ-2.1-06"></a>
**REQ-2.1-06** `gate` `verify` `hard` `all` `per-item`
Unit tests pass before the work item advances past VERIFY.

<a name="REQ-2.1-15"></a>
**REQ-2.1-15** `gate` `verify` `hard` `all` `per-item`
Integration tests pass before the work item advances past VERIFY.

<a name="REQ-2.1-07"></a>
**REQ-2.1-07** `artifact` `verify` `hard` `all`
The VERIFY answer is recorded in the work item before CLOSE: what was specifically verified and the result.

<a name="REQ-2.1-13"></a>
**REQ-2.1-13** `gate` `verify` `hard` `all` `per-item`
Documentation-only changes: every internal link resolves to a valid target.

<a name="REQ-2.1-28"></a>
**REQ-2.1-28** `gate` `verify` `hard` `all` `per-item`
Documentation-only changes: no formatting defects (corrupt tables, orphaned lines, mismatched heading levels).

<a name="REQ-2.1-29"></a>
**REQ-2.1-29** `gate` `verify` `hard` `all` `per-item`
Documentation-only changes: no AI-generated typographic characters (em dashes, en dashes, double-hyphen sentence dashes).

<a name="REQ-2.1-30"></a>
**REQ-2.1-30** `advisory` `verify` `soft` `all`
Documentation-only changes: all cross-references are hyperlinks, not plain text.

<a name="REQ-2.1-31"></a>
**REQ-2.1-31** `advisory` `verify` `soft` `all`
Documentation-only changes: no sentence fragments or duplicate sentences.

<a name="REQ-2.1-32"></a>
**REQ-2.1-32** `gate` `verify` `hard` `all` `per-item`
Documentation-only changes: every template section covers the requirements from its governing standard section.

<a name="REQ-2.1-33"></a>
**REQ-2.1-33** `gate` `verify` `hard` `all` `per-item`
Documentation-only changes: changelog entry written.

<a name="REQ-2.1-46"></a>
**REQ-2.1-46** `gate` `verify` `hard` `all` `per-item`
Every markdown table has consistent column counts across all rows within the table.

<a name="REQ-2.1-47"></a>
**REQ-2.1-47** `gate` `verify` `hard` `all` `per-item`
FMEA and analysis documents have internally consistent data: iteration counts, RPN values, status claims, and summary tables all reflect the same state.

**DOCUMENT:** All documentation written before closing the work item, not after. When a document is superseded by a newer version: move the superseded file to `docs/archive/` using the naming convention `{original-name}-archived-{YYYY-MM-DD}.md`, add the archived document frontmatter schema (see [§4.1](#41-what-must-be-documented)), and update all cross-references to point to the new document.

<a name="REQ-2.1-08"></a>
**REQ-2.1-08** `gate` `document` `hard` `all` `per-item`
All documentation is written before closing the work item.

**DEPLOY:** Change propagated per [Section 5](#5-code-and-deployability). Rollout strategy and rollback trigger must be defined per [§5.7](#57-deployment-strategies-and-release-safety) before deploying. Environment restarted, smoke test run, monitoring confirmed active.

<a name="REQ-2.1-09"></a>
**REQ-2.1-09** `artifact` `deploy` `hard` `all`
Rollout strategy is defined before deploying.

<a name="REQ-2.1-16"></a>
**REQ-2.1-16** `artifact` `deploy` `hard` `all`
Rollback trigger (specific metric threshold or error condition) is defined before deploying.

**MONITOR:** Alert configured. How will we know if this breaks in 30 days? Answer required before close. Record the MONITOR answer in the work item's MONITOR field (see [work item template](templates/work-item.md)) before CLOSE: the specific alert, dashboard, or detection mechanism, and who is notified.

<a name="REQ-2.1-10"></a>
**REQ-2.1-10** `artifact` `monitor` `hard` `all`
The MONITOR answer records the specific alert, dashboard, or detection mechanism in the work item before CLOSE.

<a name="REQ-2.1-34"></a>
**REQ-2.1-34** `artifact` `monitor` `hard` `all`
The MONITOR answer records who is notified when the detection mechanism triggers.

**CLOSE:** Gate evidence attached - the specific artifacts proving the work is done: test output showing pass/fail counts, screenshots of output at key states, CI pipeline result, deployment verification, and any other observable proof that acceptance criteria are met. All of the above confirmed. Human review if any doubt.

<a name="REQ-2.1-11"></a>
**REQ-2.1-11** `artifact` `close` `hard` `all`
Gate evidence (test output, screenshots, CI result, deployment verification) is attached at CLOSE.

#### Re-entry Triggers

The lifecycle is not strictly forward-only. When a later stage discovers that an earlier stage was incomplete, work returns to the incomplete stage before continuing. The stage that discovered the gap records what was missing and why the return was necessary.

<a name="REQ-2.1-24"></a>
**REQ-2.1-24** `gate` `build` `hard` `all` `per-item`
When BUILD discovers DEFINE was incomplete, work returns to DEFINE and AC are updated before BUILD continues.

<a name="REQ-2.1-25"></a>
**REQ-2.1-25** `gate` `verify` `hard` `all` `per-item`
When VERIFY reveals DESIGN was wrong, work returns to DESIGN before VERIFY continues.

<a name="REQ-2.1-26"></a>
**REQ-2.1-26** `gate` `deploy` `hard` `all` `per-item`
When DEPLOY reveals VERIFY was incomplete, work returns to VERIFY before DEPLOY continues.

<a name="REQ-2.1-27"></a>
**REQ-2.1-27** `artifact` `continuous` `hard` `all`
The stage that triggers a re-entry records what was missing in the earlier stage and why the return was necessary.

#### Per-Stage Operational Blocks

Each stage below shows its entry condition (Input), the artifacts it produces, and which addenda requirements activate. A practitioner at any stage sees everything needed without leaving this section.

| Stage | Input | Artifacts | Addenda at this stage |
|---|---|---|---|
| **DISCOVER** | Signal from [§2.7](#27-user-feedback) | D0: intake log row ([starters/intake-log.md](starters/intake-log.md)); D1: triage decision; D2: [templates/investigation.md](templates/investigation.md) or [templates/problem-research.md](templates/problem-research.md) (abbreviated) | [CI addendum](docs/addenda/continuous-improvement.md): Gemba, waste audit, constraint ID. [AI/ML addendum](docs/addenda/ai-ml.md): incident taxonomy extension. |
| **DEFINE** | Confirmed problem; sufficient to write observable AC | All: [templates/work-item.md](templates/work-item.md) per [§2.2](#22-work-item-discipline). Investigation type: + [templates/investigation.md](templates/investigation.md) (continued from D2). §1.2 products: + [templates/prd.md](templates/prd.md) per [§1.2](#12-document-progression) | [CI addendum](docs/addenda/continuous-improvement.md): QFD. [Multi-Team addendum](docs/addenda/multi-team.md): RFC before work item. |
| **DESIGN** | Work item with observable AC | Per qualification checklist: new component/replaced approach/new dep/changed service comm → [templates/adr.md](templates/adr.md) per [§4.2](#42-adr-format); auth/payments/data mutation/external integrations → [templates/fmea.md](templates/fmea.md); new component → [templates/architecture-doc.md](templates/architecture-doc.md) per [§3.1](#31-component-architecture-template) | [CI addendum](docs/addenda/continuous-improvement.md): DoE, SMED. [AI/ML addendum](docs/addenda/ai-ml.md): autonomy, hallucination. [Web addendum](docs/addenda/web-applications.md): browser matrix, a11y. [Event-Driven addendum](docs/addenda/event-driven.md): schema, idempotency, DLQ. [Multi-Service addendum](docs/addenda/multi-service.md): API contract, circuit breaker. [Multi-Team addendum](docs/addenda/multi-team.md): agreements. [Containerized addendum](docs/addenda/containerized-systems.md): hardening, limits. |
| **BUILD** | DESIGN complete | Code + tests per [§6](#6-testing-and-output-quality). No template. | [CI addendum](docs/addenda/continuous-improvement.md): Kaizen execution. [AI/ML addendum](docs/addenda/ai-ml.md): versioning, governance. [Containerized addendum](docs/addenda/containerized-systems.md): image build. |
| **VERIFY** | BUILD complete | [templates/work-item.md](templates/work-item.md) VERIFY field. Documentation-only: §2.1 documentation checklist above. | [CI addendum](docs/addenda/continuous-improvement.md): SPC, before/after, SMED. [AI/ML addendum](docs/addenda/ai-ml.md): eval harness, bias. [Web addendum](docs/addenda/web-applications.md): Vitals, Lighthouse, viewport, a11y. [Event-Driven addendum](docs/addenda/event-driven.md): schema compat. [Multi-Service addendum](docs/addenda/multi-service.md): contract tests, tracing. [Multi-Team addendum](docs/addenda/multi-team.md): integration test, agreement verify. |
| **DOCUMENT** | VERIFY passed | As applicable: [templates/work-session-log.md](templates/work-session-log.md) per [§4.6](#46-work-session-logs); [starters/runbook.md](starters/runbook.md) per [§4.8](#48-documentation-layers); [starters/deployment.md](starters/deployment.md) per [§4.1](#41-what-must-be-documented) | [AI/ML addendum](docs/addenda/ai-ml.md): model card. [Event-Driven addendum](docs/addenda/event-driven.md): architecture doc additions. [Multi-Service addendum](docs/addenda/multi-service.md): architecture doc additions. |
| **DEPLOY** | DOCUMENT complete; rollout + rollback defined per [§5.7](#57-deployment-strategies-and-release-safety) | [starters/deployment.md](starters/deployment.md) executed | [AI/ML addendum](docs/addenda/ai-ml.md): model promotion. [Web addendum](docs/addenda/web-applications.md): browser verify. [Containerized addendum](docs/addenda/containerized-systems.md): rollout, health probes. |
| **MONITOR** | DEPLOY complete; smoke test passed | [templates/work-item.md](templates/work-item.md) MONITOR field; [templates/slo.md](templates/slo.md) per [§7.5](#75-service-level-objectives) if new SLO | [CI addendum](docs/addenda/continuous-improvement.md): capability, control charts. [AI/ML addendum](docs/addenda/ai-ml.md): quality, confidence, drift. [Web addendum](docs/addenda/web-applications.md): Vitals ongoing. [Event-Driven addendum](docs/addenda/event-driven.md): lag, DLQ, violations. |
| **CLOSE** | All [§2.3 DoD](#23-definition-of-done) and type-conditional close conditions met | [templates/work-item.md](templates/work-item.md) Gate Evidence field; private tracked systems: [templates/work-item-export.md](templates/work-item-export.md) per [ADR-019](docs/decisions/ADR-019-work-item-accessibility-requirement.md) | [CI addendum](docs/addenda/continuous-improvement.md): Kaizen post-event. |

Each addendum also contains a cross-reference to this table as the source of truth for per-stage activation of that addendum's requirements. The cross-cutting activation summary in [docs/adoption.md](docs/adoption.md) Part 2 shows the same information organized by addendum (column view) rather than by stage (row view). When this table and adoption.md diverge, this table is authoritative; update both in the same commit.

### 2.2 Work Item Discipline

A work item represents one clearly bounded unit of work with:
- An unambiguous title
- Measurable acceptance criteria
- Linked dependencies
- An assigned owner
- A link to the discovery source (see below)
- Priority based on user impact
- A class of service (see below)
- A work item type (see below)

Blank template: [templates/work-item.md](templates/work-item.md).

**Terminology note:** Throughout this document, "work item," "issue," and "ticket" are used interchangeably. All three refer to a tracked unit of work that satisfies the requirements of this section. The term used by your tracking system does not affect the meaning; ESE uses "work item" as the universal term.

<a name="REQ-2.2-06"></a>
**REQ-2.2-06** `gate` `define` `hard` `all` `per-item` `deprecated:non-first-principles`
~~Deprecated: meta-requirement restating REQ-2.2-01 through -18 collectively.~~

<a name="REQ-2.2-19"></a>
**REQ-2.2-19** `gate` `continuous` `hard` `all` `per-item`
The work item system maintains lifecycle status.

<a name="REQ-2.2-20"></a>
**REQ-2.2-20** `gate` `close` `hard` `all` `per-item`
The work item system attaches gate evidence in a reviewable form.

**Compliant tracked work item systems.** A tracked work item system that captures all eight required attributes (title, AC, dependencies, owner, discovery source, priority, class of service, type), maintains lifecycle status, and attaches gate evidence in a reviewable form satisfies the work item record requirement. Projects using such a system do not need to maintain separate markdown work item files for each work item; the tracked system is canonical for structured data, and narrative artifacts (ADRs, post-mortems, session logs) are canonical in the repository, linked by work item ID. Projects using a private or personal tracked system must export closed work item records to the project repository at close time per ADR-019 (export format: [templates/work-item-export.md](templates/work-item-export.md)). Projects using a publicly accessible tracked system satisfy ADR-019 by default.

Work items are not catch-all tasks, vague aspirations, or items without an observable acceptance criterion.

**Root cause identification:** A work item must either address a root cause directly or explicitly identify itself as a symptom fix with a link to the work item that tracks the root cause. Label symptom-only fixes with a note such as "symptom fix: root cause tracked in [work item ID]" and add the root-cause work item as a dependency. A backlog of symptom-fix items without root-cause links creates recurrence: each symptom is resolved while the underlying cause persists and generates new symptoms. When the root cause is unknown, scope the work item as an investigation whose deliverable is a root cause identification, not a fix. This root-cause requirement applies at all severity levels, independently of whether a post-mortem is written. A P2 bug closed as a symptom fix must still link to a root-cause work item even if no post-mortem is required per [§8.2](#82-post-mortem-format).

Every work item also belongs to a class of service that determines its flow policy: how it moves through the delivery system relative to other work. Different classes have different cost-of-delay profiles, reflecting how quickly the cost of waiting accumulates for each type of work. Four classes cover most software delivery work:

- **Expedite:** cost of delay is immediate and accelerating. This work interrupts all other work and starts now. WIP limits are temporarily suspended for it. Limit to one expedite item at a time; more than one indicates the classification is being misused. Examples: production outage, active data loss, security breach in progress.
- **Fixed-date:** cost of delay is near zero before the deadline, then high and fixed when the deadline is missed. Track the countdown to the date and escalate when the buffer is exhausted. Examples: regulatory filings, contract commitments, external release dates.
- **Standard:** cost of delay grows linearly. Work moves through the system in arrival order, respecting WIP limits. Most features, bug fixes, and improvements belong here.
- **Intangible:** cost of delay is low in the short term but compounds silently over time. Technical debt, refactoring, exploratory work. Without reserved capacity, intangible work is always displaced by higher-urgency classes. Reserve a defined percentage of total capacity for this class and protect it.

Class of service is distinct from the P0-P4 severity scale in [§8.1](#81-incident-taxonomy). Severity measures the impact of a failure that has already occurred and drives incident response. Class of service determines how a work item flows before failure occurs and drives scheduling policy. A P1 incident is typically expedite class. A P2 bug with a client deadline is fixed-date. The same severity can map to different classes depending on context, and both dimensions are set independently.

Every work item has a type that determines which lifecycle gates apply and which close conditions activate beyond the universal Definition of Done ([§2.3](#23-definition-of-done)). The type is set at creation and determines conditional requirements:

| Type | Description | Required upstream artifacts (DESIGN gates) | Required close conditions (beyond universal DoD) |
|---|---|---|---|
| **feature** | New user-facing capability or behavior change | ADR if qualifying change ([§4.2](#42-adr-format)); FMEA if auth/payments/data mutation/external integrations ([§2.1](#21-the-lifecycle)); architecture doc if new component ([§3.1](#31-component-architecture-template)) | Addenda requirements captured if applicable |
| **bug** | Defect in existing behavior | None beyond standard lifecycle | Regression test ([§6.1](#61-test-layers)); post-mortem if P0/P1 ([§8.2](#82-post-mortem-format)) |
| **debt** | Technical debt paydown | None beyond standard lifecycle | Source document (ADR, post-mortem, or code comment) updated to mark debt resolved ([§8.6](#86-technical-debt-tracking)) |
| **investigation** | Root cause identification or decision research; deliverable is a finding, not a fix | None beyond standard lifecycle | Root cause statement documented; at least one implementation work item filed before close ([§2.2](#22-work-item-discipline) root cause identification); exception: when the investigation uses a measurement-driven prototype, the investigation stays open until measurement is complete ([§1.2](#12-document-progression)). Template: [templates/investigation.md](templates/investigation.md) |
| **improvement** | Process or system improvement with a measurable before/after claim | A3 if recurring issue ([§8.7](#87-a3-structured-problem-solving)); baseline measurement recorded before BUILD | Measured improvement exceeds normal process variation ([§2.1](#21-the-lifecycle) VERIFY) |
| **component** | New system component or major component change | Architecture doc ([§3.1](#31-component-architecture-template)); ADR ([§4.2](#42-adr-format)) | Architecture doc complete and reviewed |
| **security** | Security-impacting change (auth, data access, credentials, attack surface) | FMEA ([§2.1](#21-the-lifecycle)); security review ([§2.5](#25-reliability-and-security-gates)) | Security regression tests ([§6.5](#65-security-regression-standard)) |
| **prevention** | Generated from a post-mortem prevention action | None beyond standard lifecycle | Source post-mortem Prevention table updated to mark action closed |
| **countermeasure** | Generated from an A3 countermeasure | None beyond standard lifecycle | Source A3 Countermeasures table updated to mark action closed |

Type is distinct from both priority (P0-P3) and class of service (expedite, fixed-date, standard, intangible). All three dimensions are set independently. A P1 bug with expedite class and type=bug has three independent attributes governing its severity, flow policy, and lifecycle gates respectively.

**Discovery source:** Every work item records how it was discovered. The discovery source supports multiple relationship types, because a work item's provenance is not the same as its technical dependencies:

- **discovered-from: [work item ID]** - provenance: this work item was surfaced during work on another work item (not necessarily a blocking dependency)
- **triggered-by: [document path]** - generated by a specific document: a post-mortem, A3, FMEA, or compliance review
- **blocking-dep: [work item ID]** - technical dependency: this work item cannot start or close until the dependency is resolved
- **observed directly** - discovered through monitoring, user report, or direct observation during a session
- **promoted from intake log entry [date]** - signal was captured in the intake log ([§2.7](#27-user-feedback) / [starters/intake-log.md](starters/intake-log.md)), triaged, and promoted to a work item

A work item is ready to enter active development when: acceptance criteria are written and agreed on, dependencies are identified, it is scoped to a meaningful increment, and the team has enough context to begin without a discovery session. Starting work before these conditions are met produces rework. "Definition of Ready" is the complement to Definition of Done: both ends of the work item lifecycle have explicit criteria.

Periodically review the backlog and remove or close work items that are no longer relevant. A backlog full of stale items that no one intends to do erodes trust in the system and obscures what actually matters. If an item has been deprioritized through multiple cycles without progress, either recommit to it with a timeline or close it explicitly.

**Work item accessibility:** Work item records are a permanent audit artifact of the delivery process. The system used to track work items must be accessible to authorized reviewers for the life of the project. A new team member, an internal quality reviewer, or an external auditor must be able to read the history of what was decided, when, what acceptance criteria existed, and what gate evidence was attached - without asking the original author and without requiring access to a private system. Projects using a publicly accessible work item system (GitHub Issues, a shared project-management tool) satisfy this requirement by default. Projects using a private or personal system must export closed work item records to a committed location in the project repository at close time. Export format template: [templates/work-item-export.md](templates/work-item-export.md). An audit that can only be performed by someone with access to the original author's private tools is not an independently verifiable audit trail. Per [ADR-019](docs/decisions/ADR-019-work-item-accessibility-requirement.md).

<a name="REQ-2.2-01"></a>
**REQ-2.2-01** `gate` `define` `hard` `all` `per-item`
A work item has a title.

<a name="REQ-2.2-12"></a>
**REQ-2.2-12** `gate` `define` `hard` `all` `per-item` `deprecated:REQ-2.1-02`
~~Deprecated: consolidated into REQ-2.1-02 (AC before code).~~

<a name="REQ-2.2-13"></a>
**REQ-2.2-13** `gate` `define` `hard` `all` `per-item`
A work item has linked dependencies.

<a name="REQ-2.2-14"></a>
**REQ-2.2-14** `gate` `define` `hard` `all` `per-item`
A work item has an assigned owner.

<a name="REQ-2.2-15"></a>
**REQ-2.2-15** `gate` `define` `hard` `all` `per-item`
A work item has a discovery source.

<a name="REQ-2.2-16"></a>
**REQ-2.2-16** `gate` `define` `hard` `all` `per-item`
A work item has a priority.

<a name="REQ-2.2-17"></a>
**REQ-2.2-17** `gate` `define` `hard` `all` `per-item`
A work item has a class of service.

<a name="REQ-2.2-18"></a>
**REQ-2.2-18** `gate` `define` `hard` `all` `per-item`
A work item has a type.

<a name="REQ-2.2-02"></a>
**REQ-2.2-02** `gate` `define` `hard` `all` `per-item`
A work item either addresses a root cause directly or identifies itself as a symptom fix with a link to the root-cause work item.

<a name="REQ-2.2-03"></a>
**REQ-2.2-03** `gate` `define` `hard` `all` `per-item` `deprecated:REQ-2.2-18`
~~Deprecated: consolidated into REQ-2.2-18 (type enumeration).~~

<a name="REQ-2.2-04"></a>
**REQ-2.2-04** `gate` `define` `hard` `all` `per-item` `deprecated:REQ-2.2-17`
~~Deprecated: consolidated into REQ-2.2-17 (class of service enumeration).~~

<a name="REQ-2.2-05"></a>
**REQ-2.2-05** `gate` `close` `hard` `all` `per-item`
Closed work item records are accessible to authorized reviewers for the life of the project.

<a name="REQ-2.2-07"></a>
**REQ-2.2-07** `artifact` `close` `hard` `all`
Projects using a private work item system export closed records to the repository at close time.

<a name="REQ-2.2-08"></a>
**REQ-2.2-08** `gate` `define` `hard` `all` `per-item`
Acceptance criteria are observable, binary, and measurable: each states a specific condition that is either true or false with no subjective judgment required.

<a name="REQ-2.2-09"></a>
**REQ-2.2-09** `gate` `define` `hard` `type:feature` `per-item`
At least one acceptance criterion covers a failure, boundary, or error condition.

<a name="REQ-2.2-10"></a>
**REQ-2.2-10** `gate` `define` `hard` `all` `per-item`
A work item is not claimed until AC are written and agreed.

<a name="REQ-2.2-21"></a>
**REQ-2.2-21** `gate` `define` `hard` `all` `per-item`
A work item is not claimed until dependencies are identified.

<a name="REQ-2.2-22"></a>
**REQ-2.2-22** `gate` `define` `hard` `all` `per-item` `deprecated:non-first-principles`
~~Deprecated: "meaningful" is pure judgment; no binary test.~~

<a name="REQ-2.2-23"></a>
**REQ-2.2-23** `gate` `define` `hard` `all` `per-item` `deprecated:non-first-principles`
~~Deprecated: "sufficient" has no testable definition.~~

<a name="REQ-2.2-11"></a>
**REQ-2.2-11** `advisory` `continuous` `soft` `all` `deprecated:non-first-principles`
~~Deprecated: advisory process hygiene; no binary gate.~~

### 2.3 Definition of Done

Done requires all of the following:
- [ ] Acceptance criteria explicitly verified
- [ ] Tests written and passing per [§6.1](#61-test-layers) test pyramid (unit, integration, system as applicable; regression test for any bug fix)
- [ ] Documentation updated
- [ ] Gate evidence attached (test results, screenshots, CI output, deployment verification)
- [ ] Monitoring in place (for any change that affects production behavior)
- [ ] Deployed to the live environment
- [ ] All relevant repositories pushed and verified up to date with remote
- [ ] Work item record accessible: stored in a system accessible to authorized reviewers, or exported to the repository at close
- [ ] New person readiness: someone joining this project tomorrow with no context could find this feature, understand what it does and why, set it up locally without asking anyone, debug a failure without access to the original author, and safely extend or modify it. If any answer is no, documentation is not done.

**Handoff verification:** When work is being handed off to another person or team, verify by domain:

- **Code:** Compiles without unexplained warnings. All tests pass. Code style is consistent with existing patterns. No hardcoded credentials or machine-specific paths.
- **Documentation:** README updated. [ADRs](#42-adr-format) written for architectural decisions. API changes documented. Configuration documented. [Runbook](#48-documentation-layers) updated.
- **Infrastructure:** Deployment procedure documented. Environment variables documented. [Monitoring](#71-service-health-checks) configured. Rollback procedure documented.
- **Testing:** Coverage matches risk: higher risk (auth, payments, data mutation, external integrations) requires deeper coverage; lower risk (styling, copy changes) requires less. [Regression test](#61-test-layers) added for any bug fix. Functional test added for any user-facing feature.
- **Security:** No new attack surface without documented mitigation. Secrets properly managed. Auth and authorization correct for new endpoints.

<a name="REQ-2.3-10"></a>
**REQ-2.3-10** `gate` `close` `hard` `all` `per-item`
Type-conditional close requirements for the work item's type are met in addition to the universal DoD checklist.

<a name="REQ-2.3-15"></a>
**REQ-2.3-15** `gate` `close` `hard` `all` `per-item` `deprecated:non-first-principles`
~~Deprecated: meta-statement, not a requirement.~~

**Type-conditional close requirements:** In addition to the universal checklist above, each work item type ([§2.2](#22-work-item-discipline)) activates specific close conditions. These are gates, not suggestions - a work item of the specified type is not done until its type-specific requirements are also met. See the [work item template](templates/work-item.md) for the complete per-type checklist. Key type-conditional requirements:

- **bug:** regression test added per [§6.1](#61-test-layers); post-mortem written per [§8.2](#82-post-mortem-format) if P0 or P1; regression cases from post-mortem filed as work items per [§8.1](#81-incident-taxonomy)
- **feature:** applicable addenda requirements captured; ADR if qualifying change; FMEA if high-risk
- **debt:** source document (ADR, post-mortem, or code comment) updated to mark debt resolved per [§8.6](#86-technical-debt-tracking)
- **investigation:** root cause statement documented; at least one implementation work item filed
- **improvement:** baseline measurement recorded; measured improvement exceeds normal process variation; A3 if recurring issue per [§8.7](#87-a3-structured-problem-solving)
- **component:** architecture doc complete per [§3.1](#31-component-architecture-template); ADR written per [§4.2](#42-adr-format)
<a name="REQ-2.3-11"></a>
**REQ-2.3-11** `gate` `close` `hard` `type:security` `per-item`
Security type work items have a completed FMEA before close.

<a name="REQ-2.3-12"></a>
**REQ-2.3-12** `gate` `close` `hard` `type:security` `per-item`
Security type work items have security regression tests per §6.5 before close.

<a name="REQ-2.3-13"></a>
**REQ-2.3-13** `gate` `close` `hard` `type:security` `per-item`
Security type work items have a security review per §2.5 before close.

- **security:** FMEA completed; security regression tests per [§6.5](#65-security-regression-standard); security review per [§2.5](#25-reliability-and-security-gates)
- **prevention:** source post-mortem Prevention table updated to mark action closed
- **countermeasure:** source A3 Countermeasures table updated to mark action closed

<a name="REQ-2.3-16"></a>
**REQ-2.3-16** `gate` `close` `hard` `type:bug` `per-item`
P0 and P1 bug work items have a post-mortem written before close.

<a name="REQ-2.3-17"></a>
**REQ-2.3-17** `gate` `close` `hard` `type:investigation` `per-item`
Investigation work items have a root cause statement documented before close.

<a name="REQ-2.3-18"></a>
**REQ-2.3-18** `gate` `close` `hard` `type:investigation` `per-item`
Investigation work items have at least one implementation work item filed before close.

<a name="REQ-2.3-19"></a>
**REQ-2.3-19** `gate` `define` `hard` `type:improvement` `per-item` `deprecated:REQ-2.1-12`
~~Deprecated: consolidated into REQ-2.1-12 (improvement baseline).~~

<a name="REQ-2.3-20"></a>
**REQ-2.3-20** `gate` `verify` `hard` `type:improvement` `per-item`
Improvement work items verify that the measured result exceeds normal process variation before close.

<a name="REQ-2.3-21"></a>
**REQ-2.3-21** `gate` `close` `hard` `type:component` `per-item`
Component work items have a completed and reviewed architecture document before close.

<a name="REQ-2.3-22"></a>
**REQ-2.3-22** `gate` `close` `hard` `type:debt` `per-item`
Debt work items have the source document (ADR, post-mortem, or code comment) updated to mark debt resolved before close.

<a name="REQ-2.3-23"></a>
**REQ-2.3-23** `gate` `close` `hard` `type:prevention` `per-item`
Prevention work items have the source post-mortem Prevention table updated to mark the action closed before close.

<a name="REQ-2.3-24"></a>
**REQ-2.3-24** `gate` `close` `hard` `type:countermeasure` `per-item`
Countermeasure work items have the source A3 Countermeasures table updated to mark the action closed before close.

<a name="REQ-2.3-01"></a>
**REQ-2.3-01** `gate` `close` `hard` `all` `per-item`
Acceptance criteria are explicitly verified with observable evidence before close.

<a name="REQ-2.3-02"></a>
**REQ-2.3-02** `gate` `close` `hard` `all` `per-item`
Tests are written and passing per §6.1 test pyramid (unit, integration, system as applicable).

<a name="REQ-2.3-14"></a>
**REQ-2.3-14** `gate` `close` `hard` `type:bug` `per-item`
A regression test is added for every bug fix.

<a name="REQ-2.3-03"></a>
**REQ-2.3-03** `gate` `close` `hard` `all` `per-item`
Documentation is updated before the work item is closed.

<a name="REQ-2.3-04"></a>
**REQ-2.3-04** `artifact` `close` `hard` `all`
Gate evidence is attached: test output, screenshots, CI pipeline result, deployment verification.

<a name="REQ-2.3-05"></a>
**REQ-2.3-05** `gate` `close` `hard` `all` `per-item`
Monitoring is in place for any change that affects production behavior.

<a name="REQ-2.3-06"></a>
**REQ-2.3-06** `gate` `close` `hard` `all` `per-item`
The change is deployed to the live environment.

<a name="REQ-2.3-07"></a>
**REQ-2.3-07** `gate` `session-end` `hard` `all` `per-commit`
All relevant repositories are pushed and verified up to date with remote.

<a name="REQ-2.3-08"></a>
**REQ-2.3-08** `gate` `close` `hard` `all` `per-item`
The work item record is accessible to authorized reviewers (public system or exported to repository).

<a name="REQ-2.3-09"></a>
**REQ-2.3-09** `gate` `close` `hard` `all` `per-item` `deprecated:REQ-2.3-26`
~~Deprecated: consolidated into REQ-2.3-26.~~

<a name="REQ-2.3-25"></a>
**REQ-2.3-25** `gate` `close` `hard` `all` `per-item` `deprecated:REQ-2.3-26`
~~Deprecated: consolidated into REQ-2.3-26.~~

<a name="REQ-2.3-26"></a>
**REQ-2.3-26** `gate` `close` `hard` `all` `per-item`
A new person can set it up locally without asking anyone using only the documentation.

<a name="REQ-2.3-27"></a>
**REQ-2.3-27** `gate` `close` `hard` `all` `per-item` `deprecated:non-first-principles`
~~Deprecated: subjective "debug"; aspirational, not testable.~~

<a name="REQ-2.3-28"></a>
**REQ-2.3-28** `gate` `close` `hard` `all` `per-item` `deprecated:non-first-principles`
~~Deprecated: subjective "safely extend"; aspirational, not testable.~~

<a name="REQ-2.3-29"></a>
**REQ-2.3-29** `gate` `close` `hard` `all` `per-item`
A parent work item is not closed until every constituent work item is either closed or explicitly descoped with documented rationale.

<a name="REQ-2.3-30"></a>
**REQ-2.3-30** `gate` `close` `hard` `all` `per-item`
Every acceptance criterion is satisfied before close; no partial satisfaction with deferred items is permitted unless each deferred item has a tracked dependency-linked work item.

### 2.4 Shared Ownership

The team that builds a feature owns its production health. There is no handoff to "ops" that transfers responsibility.

At all times, there is a named owner for every service in production - a team, or a named individual within that team. The owner is discoverable: recorded in the service's [runbook](#48-documentation-layers) or operations documentation, not held in someone's head.

A new team member, an on-call responder, or anyone paged at 2am must be able to answer - using the [runbook](#48-documentation-layers), not from memory - how to confirm the service is working, how to detect failure, and what to do when it fails. The [runbook](#48-documentation-layers) is how ownership survives team changes.

When team composition changes, ownership transfers explicitly: the incoming owner reviews the [runbook](#48-documentation-layers), accepts responsibility, and the change is recorded in the runbook's named owner field and in the project's [standards-application document](starters/standards-application.md). Undocumented ownership transfers leave services in a state where no one knows they are responsible.

<a name="REQ-2.4-01"></a>
**REQ-2.4-01** `artifact` `continuous` `hard` `all`
Every service in production has a named owner discoverable in the runbook or operations documentation.

<a name="REQ-2.4-02"></a>
**REQ-2.4-02** `artifact` `continuous` `hard` `all`
The runbook answers three questions without requiring memory: how to confirm working, how to detect failure, what to do when it fails.

<a name="REQ-2.4-03"></a>
**REQ-2.4-03** `artifact` `continuous` `hard` `all`
When ownership transfers, the incoming owner records acceptance in the runbook's named owner field and in the project's standards-application document.

### 2.5 Reliability and Security Gates

These gates apply to all work in addition to the lifecycle:

- If delivery health metrics (see [Section 7](#7-monitoring-and-observability)) worsen for two consecutive review periods, shrink change size, strengthen gates and tests, and prioritize reliability work before adding features. The generating principle (from statistical process control): a single observation cannot distinguish a genuine process shift from common cause variation; two consecutive observations in the same direction are the minimum evidence for a real trend. Responding to a single-period fluctuation is tampering, which increases variation rather than reducing it.
- Any recurring manual operational task whose cumulative cost over a reasonable planning horizon exceeds its one-time automation cost is toil. Automate it, eliminate it, or file an issue with a plan to remove it. Default calibration: tasks recurring more than three times, or consuming more than 30 minutes per week, have typically crossed this point. Projects may adjust these reference thresholds based on their automation capacity and planning horizon.
- Any change that expands attack surface, adds a new external endpoint, processes a new class of sensitive data, or increases process permissions requires explicit security review before merge.
<a name="REQ-2.5-04"></a>
**REQ-2.5-04** `advisory` `verify` `soft` `all`
Change approval is risk-based: automated gates for routine changes, peer review for moderate risk, explicit human approval only for high-impact changes.

- Change approval processes that require external committee review for every change reduce deployment frequency without improving stability. Risk-based approval - automated gates for routine changes, peer review for moderate risk, explicit human approval only for high-impact changes (such as schema migrations, credential scope changes, or external-facing behavior changes) - achieves both speed and safety. Blanket pre-approval for all changes regardless of risk is a delivery anti-pattern. Projects subject to regulatory mandates document their required approval tiers in their compliance documentation.

<a name="REQ-2.5-01"></a>
**REQ-2.5-01** `gate` `verify` `hard` `all` `per-item`
Any change expanding attack surface, adding external endpoints, processing new sensitive data, or increasing process permissions has an explicit security review before merge.

<a name="REQ-2.5-02"></a>
**REQ-2.5-02** `gate` `continuous` `hard` `all` `per-section`
When delivery health metrics worsen for two consecutive review periods (the minimum evidence for a real trend per statistical process control theory), change size is reduced and reliability work is prioritized before new features.

<a name="REQ-2.5-03"></a>
**REQ-2.5-03** `gate` `continuous` `hard` `all` `per-item`
Any recurring manual operational task whose cumulative cost over a reasonable planning horizon exceeds its one-time automation cost has a filed work item to automate, eliminate, or remove it. Default calibration: three recurrences or 30 minutes per week.

### 2.6 Flow and Batch Size

Two universal constraints on how work moves through a delivery system:

<a name="REQ-2.6-01"></a>
**REQ-2.6-01** `advisory` `build` `soft` `all`
Work is delivered in the smallest increment that can be independently reviewed, tested, deployed, and reversed.

<a name="REQ-2.6-05"></a>
**REQ-2.6-05** `gate` `continuous` `hard` `all` `per-item`
WIP limits are defined and enforced.

<a name="REQ-2.6-02"></a>
**REQ-2.6-02** `advisory` `continuous` `soft` `all` `deprecated:non-first-principles`
~~Deprecated: Theory of Constraints ritual; no verifiable action.~~

<a name="REQ-2.6-06"></a>
**REQ-2.6-06** `advisory` `continuous` `soft` `all` `deprecated:non-first-principles`
~~Deprecated: redundant with removed REQ-2.6-02.~~

**Small batches:** Deliver in the smallest increment that can be independently reviewed, tested, deployed, and reversed. Smaller batches mean faster feedback, lower risk per change, and less work discarded when something is wrong. When a feature requires more than a few days of work, decompose it into independently mergeable increments. A large change that cannot be rolled back is a liability; a small change that can be reversed is an option.

**Work In Progress (WIP) limits:** Limit the number of work items in simultaneous progress. Context switching between many active items reduces throughput and masks bottlenecks - work piles up waiting rather than moving forward. A team that has ten things in progress and finishes none of them is slower than a team that has three things in progress and finishes them in order. When WIP exceeds the team's capacity to deliver, prioritize finishing over starting. Class of service (see [§2.2](#22-work-item-discipline)) interacts directly with WIP limits: expedite items suspend the limit by definition; intangible items require dedicated capacity reserved within the limit so they are never crowded out by higher-urgency work.

<a name="REQ-2.6-03"></a>
**REQ-2.6-03** `advisory` `continuous` `soft` `all` `deprecated:non-first-principles`
~~Deprecated: meaningless without delivery metrics infrastructure.~~

<a name="REQ-2.6-04"></a>
**REQ-2.6-04** `advisory` `continuous` `soft` `all` `deprecated:non-first-principles`
~~Deprecated: unverifiable trigger and completion.~~

**Delivery rate awareness:** Before making capacity and prioritization decisions, define the required delivery rate (how quickly stakeholders need working software) and compare it to actual throughput. When required rate exceeds actual throughput, the response is not longer hours but smaller batches, removed constraints, or renegotiated scope. When actual throughput exceeds required rate, investing in quality improvement takes priority over delivering faster. Teams that make capacity decisions without this comparison are navigating without knowing their destination speed.

**Constraint identification before optimization:** Before investing in any delivery system improvement (adding automation, tuning WIP limits, reducing batch size, or adding capacity), identify the binding constraint: the one step or resource that limits total throughput. Improving anything that is not the constraint increases local efficiency without increasing total throughput. The Theory of Constraints five focusing steps apply: (1) identify the constraint, (2) exploit it fully before investing elsewhere, (3) subordinate all other decisions to supporting the constraint, (4) elevate the constraint if throughput is still insufficient, (5) prevent inertia from reinstating the old constraint once it is resolved (see [toc-goldratt.com](https://www.toc-goldratt.com/en/product/the-goal), Goldratt, 1984, tracked in [dependencies.md](dependencies.md)). The continuous-improvement addendum provides specific methods for identifying the constraint in a software delivery system.

**Waste identification:** When delivery health declines or throughput stalls, a waste audit names where capacity is being consumed without producing value. Lean software delivery recognizes eight forms of waste (TIMWOODS). Recurring manual toil is covered in [§2.5](#25-reliability-and-security-gates). For the full taxonomy with software-specific examples and structured audit methods, see the [continuous-improvement addendum](docs/addenda/continuous-improvement.md#waste-audit-methods).

### 2.7 User Feedback

User feedback is the primary signal source for the [DISCOVER step (§2.1)](#21-the-lifecycle). Without a functioning intake and triage process, there is no reliable path from observation to confirmed work item. A system that cannot receive feedback from its users cannot improve.

Every project must define all five of the following:

1. How signals are captured (intake record format and filing location)
2. Where intake records accumulate before triage (the intake channel)
3. The triage cadence (how frequently intake records are reviewed and assigned a triage decision)
4. How confirmed problems are promoted to §2.2 work items
5. How users are notified when their feedback is acted on

<a name="REQ-2.7-01"></a>
**REQ-2.7-01** `artifact` `continuous` `hard` `all`
Signal capture format and filing location are defined.

<a name="REQ-2.7-02"></a>
**REQ-2.7-02** `artifact` `continuous` `hard` `all`
Intake accumulation channel (where records accumulate before triage) is defined.

<a name="REQ-2.7-03"></a>
**REQ-2.7-03** `artifact` `continuous` `hard` `all`
Triage cadence (how frequently intake records are reviewed) is defined.

<a name="REQ-2.7-04"></a>
**REQ-2.7-04** `artifact` `continuous` `hard` `all`
Promotion process from intake to §2.2 work items is defined.

<a name="REQ-2.7-05"></a>
**REQ-2.7-05** `artifact` `continuous` `soft` `all`
User notification process (how users are informed when feedback is acted on) is defined.

<a name="REQ-2.8-01"></a>
**REQ-2.8-01** `advisory` `continuous` `soft` `all`
A visible status shows what is in progress for any work that others depend on.

<a name="REQ-2.8-02"></a>
**REQ-2.8-02** `advisory` `continuous` `soft` `all`
A visible status shows what is blocked for any work that others depend on.

<a name="REQ-2.8-03"></a>
**REQ-2.8-03** `advisory` `continuous` `soft` `all`
A visible status shows what shipped for any work that others depend on.

<a name="REQ-2.8-04"></a>
**REQ-2.8-04** `advisory` `continuous` `soft` `all`
A visible status shows what is next for any work that others depend on.

### 2.8 Status Visibility

Stakeholders who depend on your work - other teams, users, leadership, or downstream systems - should be able to determine the current status of that work without asking you directly. Define and maintain a visible, regularly updated status for any work that others are waiting on.

At minimum: what is in progress, what is blocked and on what, what shipped since the last update, and what is expected next. The format and cadence are project decisions. The existence of proactive status communication is not.

**Scale trigger:** §2.8 is advisory for projects where a single operator can hold all concurrent work items in working memory. It becomes load-bearing (requiring a dedicated visibility surface, not just implicit status) when concurrent items exceed an individual's working memory capacity, when multiple stakeholders need independent access to status, or when portfolios span multiple distinct domains. The generating principle: human working memory is bounded (Miller, 1956); when item count exceeds that bound, status information must be externalized. Default calibration: roughly 10 concurrent work items. At that scale, the cost of status-by-request exceeds the cost of building and maintaining a status surface.

---

## 3. Architecture and Design

### 3.1 Component Architecture Template

Every system component has an architecture document. Blank template: [templates/architecture-doc.md](templates/architecture-doc.md).

Required sections: purpose, measurable goals, current vs. target state, architecture diagram, data flows, external dependencies with failure behavior, failure modes, boundaries (what this component does NOT do), and future implementor notes. Architecture diagrams use Mermaid fenced blocks (` ```mermaid `) when the document is rendered by a platform that supports them (GitHub, GitLab, most modern markdown viewers); the generating principle is that text-source diagrams are lintable, diffable, and maintainable without external tooling, while binary or ASCII-art diagrams resist automated validation.

Also address the following when the component fits the condition: stateless vs. durable state (any component that persists data); capacity assumptions (any component with a throughput target or user-facing latency SLO); trust boundaries (any component that crosses an authentication or authorization boundary); data sensitivity classes (any component that stores or transmits personal, financial, or regulated data); non-functional requirements: scalability, durability, consistency, throughput, testability, portability (any component required to meet an explicit SLO); and internationalization (any user-facing component that may serve multiple locales). See [W3C Internationalization](https://www.w3.org/International/), tracked in [dependencies.md](dependencies.md). Optional sections are included in the template.

<a name="REQ-3.1-02"></a>
**REQ-3.1-02** `artifact` `design` `hard` `type:component`
Always-on services with a defined uptime SLO include a Fault Tree Analysis and reliability block diagram in the architecture document.

For always-on services with a defined uptime SLO (see [§7.5](#75-service-level-objectives)), extend the failure modes section with two additional analyses. First, a Fault Tree Analysis (FTA): starting from the undesired top event (service outage, SLO breach, or data loss), work down through AND/OR logic gates to identify which combinations of component failures produce that outcome. FTA is the top-down complement to FMEA (see [§2.1](#21-the-lifecycle)): FMEA starts from each component and asks what could fail there; FTA starts from a system-level failure and asks what must have failed together to cause it. Second, a reliability block diagram: model which components must be functioning for the service to meet its SLO, identify single points of failure, and quantify the reliability impact of each component's uptime on overall service availability. Both analyses belong in the architecture document before the component moves to BUILD.

### 3.2 Design Principles

These principles apply to all code and architecture decisions:

- **SOLID (Single responsibility, Open/closed, Liskov substitution, Interface segregation, Dependency inversion)** - each module does one thing and can be changed without breaking its neighbors.
- **DRY (Don't Repeat Yourself)** - every piece of knowledge has one authoritative representation. Duplication is a maintenance liability.
- **KISS (Keep It Simple, Stupid)** - the simplest solution that meets the requirement is the best solution. Complexity must justify itself.
- **YAGNI (You Aren't Gonna Need It)** - do not build what is not yet needed. Speculative features accumulate cost without delivering value.
- **Separation of Concerns** - each component addresses one concern. Mixing responsibilities makes systems harder to test, debug, and hand off.
- **Least Surprise** - software should behave as its users and maintainers expect. Surprising behavior is a bug even if it is technically correct.
- **Loose Coupling, High Cohesion** - components depend on each other minimally; internal elements within a component are strongly related.
- **Fail Fast** - detect and report errors as close to the source as possible. Log with diagnostic context, surface useful messages to callers (not stack traces), and degrade gracefully when dependencies are unavailable.
- **Design for Failure** - assume every dependency will be unavailable at some point. Define timeout, retry, and fallback behavior at design time, not after the first outage.
- **Shift Left** - move testing, security review, and quality checks earlier in the lifecycle. Problems found in design cost less than problems found in production.
- **API-First** - when building a service that will be consumed by others, design the API contract before the implementation. The contract is the product; the implementation is the mechanism.
- **Consistent Formatting** - code and documentation within a project follow one formatting standard, enforced by automated tooling. The specific tools are a project decision; the existence of automated formatting is not. Style debates resolved by the formatter, not by humans in reviews. This applies equally to code (linters, formatters) and documentation (consistent heading structure, list style, link format, whitespace). For markdown documentation, follow the CommonMark specification (see [commonmark.org](https://commonmark.org), tracked in [dependencies.md](dependencies.md)).
<a name="REQ-3.2-02"></a>
**REQ-3.2-02** `gate` `commit` `hard` `all` `per-commit`
New compiler warnings fail the build.

<a name="REQ-3.2-03"></a>
**REQ-3.2-03** `gate` `commit` `hard` `all` `per-commit`
Formatting divergence is rejected by the pre-commit hook.

- **5S (Sort, Set in Order, Shine, Standardize, Sustain)** - five practices for maintaining a clean and consistent codebase: Sort (remove dead code, stale branches, and unused dependencies), Set in Order (consistent project structure and naming so any contributor finds any artifact without asking), Shine (zero unexplained compiler warnings and zero linting violations; a warning that persists trains practitioners to ignore all warnings), Standardize (linters and pre-commit hooks enforce all rules mechanically; standards are not maintained by code review discipline alone), and Sustain (automated gates prevent regression to a prior state; when a new warning appears the build fails, and when formatting diverges the pre-commit hook rejects the commit). Sustain is a gate, not a cultural aspiration.

<a name="REQ-3.2-01"></a>
**REQ-3.2-01** `gate` `commit` `hard` `all` `per-commit`
Code and documentation formatting is enforced by automated tooling.

<a name="REQ-3.2-04"></a>
**REQ-3.2-04** `gate` `commit` `hard` `all` `per-commit`
Markdown documentation follows the CommonMark specification.

### 3.3 Architecture Doc Backlog

Every project maintains a list of components that lack [architecture docs](#31-component-architecture-template). This list lives in the project's own [application document](starters/standards-application.md), not here. Review it at the start of any significant work period.

No further changes to a component that lacks an architecture doc until that doc exists or an issue is filed to create it.

<a name="REQ-3.1-01"></a>
**REQ-3.1-01** `artifact` `design` `hard` `type:component`
Every system component has an architecture document.

<a name="REQ-3.1-10"></a>
**REQ-3.1-10** `artifact` `design` `hard` `type:component`
The architecture document states the component's purpose.

<a name="REQ-3.1-11"></a>
**REQ-3.1-11** `artifact` `design` `hard` `type:component`
The architecture document states measurable goals.

<a name="REQ-3.1-12"></a>
**REQ-3.1-12** `artifact` `design` `hard` `type:component`
The architecture document includes a current vs. target state comparison.

<a name="REQ-3.1-13"></a>
**REQ-3.1-13** `artifact` `design` `hard` `type:component`
The architecture document includes a system diagram.

<a name="REQ-3.1-14"></a>
**REQ-3.1-14** `artifact` `design` `hard` `type:component`
The architecture document documents data flows.

<a name="REQ-3.1-15"></a>
**REQ-3.1-15** `artifact` `design` `hard` `type:component`
The architecture document documents all dependencies with failure behavior for each.

<a name="REQ-3.1-16"></a>
**REQ-3.1-16** `artifact` `design` `hard` `type:component`
The architecture document documents failure modes.

<a name="REQ-3.1-17"></a>
**REQ-3.1-17** `artifact` `design` `hard` `type:component`
The architecture document documents system boundaries.

<a name="REQ-3.3-01"></a>
**REQ-3.3-01** `gate` `design` `hard` `all` `per-item`
No changes to a component that lacks an architecture doc until the doc exists or an issue is filed to create it.

### 3.4 Conway's Law and Team-Architecture Alignment

The structure of a software system mirrors the communication structure of the organization that built it (Conway, 1968; see [martinfowler.com/bliki/ConwaysLaw.html](https://martinfowler.com/bliki/ConwaysLaw.html)). This is not a tendency to manage - it is a constraint to design with. Teams that must coordinate closely on every change will produce tightly coupled systems regardless of the intended architecture. The inverse is also true: if you want loosely coupled systems, design loosely coupled teams first.

<a name="REQ-3.4-01"></a>
**REQ-3.4-01** `advisory` `design` `soft` `all` `deprecated:non-first-principles`
~~Deprecated: Conway's Law advisory; theoretical padding.~~

<a name="REQ-3.4-02"></a>
**REQ-3.4-02** `advisory` `design` `soft` `all`
Independent deployability test passes: the team can deploy its component without coordinating a release with any other team.

<a name="REQ-3.4-03"></a>
**REQ-3.4-03** `gate` `design` `hard` `all` `per-artifact`
Independent testability test passes: the team can test its component in isolation using test doubles for dependencies.

Two tests for alignment:
- **Independent deployability:** Can a team deploy its component to production without coordinating a release with any other team? If not, the system is more coupled than the architecture diagram shows.
- **Independent testability:** Can a team test its component in isolation using test doubles for its dependencies? If not, that coupling is real and will slow every change.

When these tests fail, the correct response is to fix the team boundary or the interface contract - not to add more coordination process. Coordination overhead is a symptom; the cause is architectural coupling.

A related constraint is team cognitive load: every team has a limit to how much they can understand, maintain, and operate. Architecture decisions that push a team beyond that limit - too many services, too wide a codebase, too many dependencies to understand - produce quality problems regardless of how capable the team is. When designing component boundaries, ask not only whether the system can be decomposed this way, but whether a team can own and understand it.

---

## 4. Documentation Standards

Documentation is not a separate activity that follows work. It is part of the work. A change without documentation is not done.

Operational documentation (runbooks, deployment procedures, checklists) represents the current best-known method for a task, not a permanent answer. This is the Lean Standard Work principle: the documented method is a baseline, subject to systematic improvement through experience. When a better method is discovered through an incident, a post-mortem, or direct observation, the documentation is updated. Operational docs that reflect how the system worked a year ago are not Standard Work; they are documentation debt. The lessons-learned cycle ([§8.3](#83-lessons-learned-registry)) is the explicit improvement mechanism: every post-mortem lesson that changes an operational practice updates the corresponding Standard Work.

### 4.1 What Must Be Documented

Every project maintains a standard directory layout so documentation is discoverable without asking the author. Reference layout: [starters/repo-structure.md](starters/repo-structure.md).

| Type | Location | Required for |
|---|---|---|
| Why this decision was made | ADR in `{project}/docs/decisions/` | New component, replaced approach, new dependency, or changed service communication |
| What the feature does | README or module docstring | Every new module or feature |
| How to install and configure | `docs/setup.md` ([template](starters/setup.md)) | Any new dependency or configuration |
| How to deploy | `docs/deployment.md` ([template](starters/deployment.md)) | Any deployment change |
| How to operate | `docs/runbook.md` | Any always-on service |
| Known limitations | Work item description and inline comments | Any known gap |
| API contract | OpenAPI spec or typed module docs | Any new API endpoint |
| Data schema | Entity-relationship diagram or schema comments | Any new data model |
| Security considerations | Security section in [ADR](#42-adr-format) | Any auth or data change |
| Compliance review | Periodic internal audit ([template](templates/compliance-review.md)) | Per the cadence defined in the [standards application document](starters/standards-application.md) |
| Archived document metadata | Frontmatter in the archived file: `status: archived`, `superseded-by: {relative path}`, `date-archived: {YYYY-MM-DD}` | Any document moved to `docs/archive/` |

<a name="REQ-4.1-01"></a>
**REQ-4.1-01** `artifact` `document` `hard` `all`
The project maintains a standard directory layout per starters/repo-structure.md so documentation is discoverable without asking the author.

Documented artifacts produced from a template (whether shipped by ESE or defined by the project) conform to their template's required section structure. A template declares a set of sections; every instance of that template must contain each required (non-optional) section, or explicitly document each omitted section inline. The generating principle is that a template only has value if instances are verifiable against it: a template with drifting instances is indistinguishable from no template at all, and readers lose the ability to scan an artifact for known sections. Verification is automated (as a template-compliance check in CI or pre-commit; see `starters/linters/lint-template-compliance.sh` for a portable reference implementation) or documented as a periodic compliance review activity.

<a name="REQ-4.1-02"></a>
**REQ-4.1-02** `gate` `document` `hard` `all` `per-artifact`
Every documented artifact created from a template contains every required section from that template, or explicitly documents each omitted section inline. A section is required if the template declares it without an optional marker; a section is omitted by recording the omission in the instance file (for example, with an inline comment naming the omitted section).

<a name="REQ-4.1-03"></a>
**REQ-4.1-03** `artifact` `document` `hard` `all`
Template-compliance verification is either automated (a check that runs on every commit or every CI build) or documented as a step in the periodic compliance review. Projects that use templates decide which verification mode applies and document the decision in standards-application.md.

<a name="REQ-4.2-01"></a>
**REQ-4.2-01** `gate` `design` `hard` `all` `per-item`
An ADR exists for every qualifying change.

<a name="REQ-4.2-03"></a>
**REQ-4.2-03** `artifact` `design` `hard` `all`
The ADR includes a context section (problem, constraints, cost of doing nothing).

<a name="REQ-4.2-04"></a>
**REQ-4.2-04** `artifact` `design` `hard` `all`
The ADR includes a decision section (specific and unambiguous).

<a name="REQ-4.2-05"></a>
**REQ-4.2-05** `artifact` `design` `hard` `all`
The ADR includes a consequences section (positive and negative trade-offs).

<a name="REQ-4.2-06"></a>
**REQ-4.2-06** `artifact` `design` `hard` `all`
The ADR includes an alternatives considered section with rejection rationale for each.

<a name="REQ-4.2-07"></a>
**REQ-4.2-07** `artifact` `design` `hard` `all`
The ADR includes a validation section with binary outcome-based assessment criteria and an event-based trigger.

### 4.2 ADR Format

Blank template: [templates/adr.md](templates/adr.md).

Required sections: context (problem, constraints, cost of doing nothing), decision (specific and unambiguous), consequences (positive and negative trade-offs), alternatives considered (with rejection rationale), and validation (what observable signal confirms the decision was correct, and what triggers the assessment).

<a name="REQ-4.2-02"></a>
**REQ-4.2-02** `gate` `design` `hard` `all` `per-item`
ADR validation criteria are outcome-based and binary (true or false, not a judgment call) with an event-based assessment trigger.

Validation criteria must be outcome-based and binary: they state a specific, observable condition that is either true or false - not a subjective judgment. The assessment trigger should be an event (first adoption, first production incident, first external review) rather than a fixed calendar period, because a calendar period can elapse without the relevant conditions occurring. A time window may be used as a backstop when no natural trigger exists, but the primary criterion must still be a named, observable outcome.

An ADR carries frontmatter fields for all applicable lifecycle decision documents: `dfmea` when the change triggers a DFMEA requirement (§2.1 DESIGN: auth, payments, data mutation, external integrations); `pfmea` when the change triggers a PFMEA review (§2.1 DESIGN qualifying changes); `architecture-doc` when the change introduces a new component (§3.1). Fields are omitted (or set to `~`) when not applicable. When populated, the named file must exist and its `adr:` frontmatter field must reference this ADR.

<a name="REQ-4.2-08"></a>
**REQ-4.2-08** `gate` `design` `hard` `all` `per-item`
When an ADR's dfmea frontmatter field is populated, the named DFMEA file exists and its adr field references this ADR.

<a name="REQ-4.2-09"></a>
**REQ-4.2-09** `gate` `design` `hard` `all` `per-item`
When an ADR's pfmea frontmatter field is populated, the named PFMEA file exists and its adr field references this ADR.

An ADR for a change that modifies an existing component, API, interface, or standard includes a **Per-Document Impact Analysis** section. This section lists every document affected by the decision (API references, architecture docs, dependent standards, published contracts) and states for each: whether a change is required and what it is, or an explicit confirmation that no change is required. Documents confirmed unchanged must be listed explicitly; their omission means the analysis was not done, not that they are unaffected.

<a name="REQ-4.2-10"></a>
**REQ-4.2-10** `gate` `design` `hard` `all` `per-artifact`
An ADR that modifies an existing component, API, interface, or standard includes a Per-Document Impact Analysis section.

<a name="REQ-4.2-11"></a>
**REQ-4.2-11** `gate` `design` `hard` `all` `per-item`
Each entry in the Per-Document Impact Analysis section states either the required change or an explicit confirmation that no change is required.

### 4.3 Changelogs

Standards, APIs, and actively evolving documents maintain a changelog. Not every file needs one; a stable README or a rarely-updated runbook does not. Changelog location: `CHANGELOG.md` at the repository root for any document in a git repository; inline at the top of the document only for standalone files distributed independently of a repository. An entry that says only "updated" provides no value; state what changed and why (see REQ-4.3-02 through REQ-4.3-05).

Projects that publish versioned releases (tagged software, standards, libraries, schemas, or other consumed artifacts with version identifiers) additionally document a release trigger policy: what conditions cut a new version, who authorizes the cut, and how patch, minor, and major bumps are assigned. The policy lives in an ADR, a dedicated section of README.md, or the CHANGELOG preamble; the format is a project choice, but the existence of a written policy is not. The generating principle is that an unwritten release cadence is indistinguishable from a random cadence from a consumer's perspective: consumers of a versioned artifact cannot plan migrations, deprecations, or upgrades against a policy that exists only in one person's head. A written release trigger policy also gives automation and agent sessions a check they can run before proposing a release ceremony commit.

<a name="REQ-4.4-01"></a>
**REQ-4.4-01** `gate` `document` `hard` `all` `per-artifact`
Every document with more than three sections has a table of contents (exception: documents following a fixed template where every section is predictable).

<a name="REQ-4.3-01"></a>
**REQ-4.3-01** `artifact` `document` `hard` `all`
Standards, APIs, and actively evolving documents maintain a changelog.

<a name="REQ-4.3-02"></a>
**REQ-4.3-02** `artifact` `document` `hard` `all`
Each changelog entry includes the version.

<a name="REQ-4.3-03"></a>
**REQ-4.3-03** `artifact` `document` `hard` `all`
Each changelog entry includes the date.

<a name="REQ-4.3-04"></a>
**REQ-4.3-04** `artifact` `document` `hard` `all`
Each changelog entry states what changed (which sections, behaviors, or interfaces).

<a name="REQ-4.3-05"></a>
**REQ-4.3-05** `artifact` `document` `hard` `all`
Each changelog entry states why the change was made.

<a name="REQ-4.3-06"></a>
**REQ-4.3-06** `artifact` `document` `hard` `all`
Projects that publish versioned releases document a release trigger policy covering (a) what conditions cut a new version, (b) who authorizes the cut, and (c) how patch, minor, and major bumps are assigned. Activation: the project publishes versioned releases (assigns and tags version identifiers to released states of the artifact).

### 4.4 Table of Contents Structure

Every document with more than three sections has a table of contents, unless the document follows a fixed template where every section is predictable (e.g., [ADRs](#42-adr-format)). Structure rules:

- ToC depth matches the document's actual navigation need. A single-level ToC lists top-level sections only. Subsections appear only when they represent independently navigable reference content.
- Be consistent: do not list subsections for some sections and not others at the same level.
- Use the link format the rendering environment supports. For repositories rendered by hosting platforms: standard markdown links. For knowledge-base tools that support wiki-style links: use those instead.
- The ToC is accurate. Keep it in sync when headings change.

### 4.5 Code Documentation

Every function and module documents:
1. What it does (one sentence, present tense)
2. Why it exists (what is not obvious from reading the code)
3. What can go wrong (failure modes, edge cases)
4. Example usage (for public APIs)

No undocumented public functions.

<a name="REQ-4.5-01"></a>
**REQ-4.5-01** `gate` `build` `hard` `all` `per-artifact`
Every public function and module documents what it does (one sentence).

<a name="REQ-4.5-05"></a>
**REQ-4.5-05** `gate` `build` `hard` `all` `per-artifact`
Every public function and module documents why it exists.

<a name="REQ-4.5-06"></a>
**REQ-4.5-06** `gate` `build` `hard` `all` `per-artifact`
Every public function and module documents what can go wrong (failure modes and edge cases).

<a name="REQ-4.5-07"></a>
**REQ-4.5-07** `gate` `build` `hard` `all` `per-artifact`
Every public API has example usage documented.

<a name="REQ-4.5-02"></a>
**REQ-4.5-02** `gate` `build` `hard` `all` `per-artifact`
No undocumented public functions exist.

### 4.6 Work Session Logs

<a name="REQ-4.6-01"></a>
**REQ-4.6-01** `artifact` `session-end` `hard` `all`
Significant work sessions produce a log.

<a name="REQ-4.6-02"></a>
**REQ-4.6-02** `artifact` `session-end` `hard` `all`
The work session log records what was attempted and what succeeded.

<a name="REQ-4.6-03"></a>
**REQ-4.6-03** `artifact` `session-end` `hard` `all`
The work session log records what failed.

<a name="REQ-4.6-04"></a>
**REQ-4.6-04** `artifact` `session-end` `hard` `all`
The work session log records what is left open with work item IDs.

<a name="REQ-4.6-05"></a>
**REQ-4.6-05** `artifact` `session-end` `hard` `all`
The work session log records decisions made.

Significant work sessions produce a log capturing: what was attempted, what succeeded, what failed and why, what was left open with issue IDs, and decisions made linking to ADRs. Store these in a consistent location in the project. The log is how future sessions resume context without re-discovering prior work. Blank template: [templates/work-session-log.md](templates/work-session-log.md).

### 4.7 Document Length and Cascade

A document that cannot be read in a single sitting has become a reference corpus, not a standard. The generating principle: human working memory constrains comprehension; a reader must build and maintain a mental model of the document's structure while reading. Beyond the point where the model exceeds working memory, readers resort to searching rather than comprehending, and the document has lost its function as a readable standard. Before a document reaches that point:

<a name="REQ-4.7-01"></a>
**REQ-4.7-01** `advisory` `document` `soft` `all`
A section whose length exceeds a single-sitting read is evaluated for extraction (default calibration: roughly 500 words, or about 2 minutes of reading).

<a name="REQ-4.7-02"></a>
**REQ-4.7-02** `advisory` `document` `soft` `all`
A document whose length forces search-based rather than scan-based navigation cascades into sub-documents (default calibration: roughly 2000 words, or about 8 minutes of reading).

- When a section exceeds single-sitting readability and its content would be meaningful as a standalone reference, evaluate whether it should become its own document with a summary and link in the parent. When a document forces practitioners to search rather than scan to find content, cascade into sub-documents.

The definitive test is not the word count; it is: can someone new to the project open this document, read it end to end, and know what is required of them? If not, restructure. The word counts are evaluation triggers, not gates.

### 4.8 Documentation Layers

<a name="REQ-4.8-01"></a>
**REQ-4.8-01** `artifact` `document` `hard` `all`
Every component has a code documentation layer.

<a name="REQ-4.8-13"></a>
**REQ-4.8-13** `artifact` `document` `hard` `all`
Every component has an operations documentation layer.

<a name="REQ-4.8-14"></a>
**REQ-4.8-14** `artifact` `document` `hard` `all`
Every component has a configuration documentation layer.

<a name="REQ-4.8-15"></a>
**REQ-4.8-15** `artifact` `document` `hard` `all`
Every component has a security documentation layer.

<a name="REQ-4.8-16"></a>
**REQ-4.8-16** `artifact` `document` `hard` `all`
Every component has a network documentation layer.

<a name="REQ-4.8-17"></a>
**REQ-4.8-17** `artifact` `document` `hard` `all`
Every component has a database documentation layer.

<a name="REQ-4.8-18"></a>
**REQ-4.8-18** `gate` `document` `hard` `all` `per-artifact`
Documentation across all layers is sufficient for a new person to maintain the component without access to the person who built it.

Every component has documentation sufficient for someone new to maintain it without access to the person who built it. Blank runbook template covering all required layers: [starters/runbook.md](starters/runbook.md).

Required layers:

**Code** - docstrings, inline comments explaining non-obvious logic, type annotations

**Security** - trust boundaries, data sensitivity classes, credential scope, what is redacted from logs, backup encryption, token rotation procedure

**Network** - open ports, protocols, transport encryption (TLS) requirements

<a name="REQ-4.8-02"></a>
**REQ-4.8-02** `artifact` `document` `hard` `all`
Database layer documents schema with field descriptions.

<a name="REQ-4.8-09"></a>
**REQ-4.8-09** `artifact` `document` `hard` `all`
Database layer documents index rationale.

<a name="REQ-4.8-10"></a>
**REQ-4.8-10** `artifact` `document` `hard` `all`
Database layer documents migration strategy with tested rollback.

<a name="REQ-4.8-11"></a>
**REQ-4.8-11** `artifact` `document` `hard` `all`
Database layer documents backup policy with RTO and RPO.

<a name="REQ-4.8-12"></a>
**REQ-4.8-12** `artifact` `document` `hard` `all`
Database layer documents restore test cadence.

<a name="REQ-4.8-03"></a>
**REQ-4.8-03** `artifact` `document` `hard` `all`
Configuration layer documented: every environment variable has purpose, example value, and required-or-optional designation.

**Database** - schema with field descriptions, index rationale, migration strategy (backward-compatible changes preferred; zero-downtime migrations required for production; every migration has a tested rollback), backup policy with defined Recovery Time Objective (RTO - how long until service is restored) and Recovery Point Objective (RPO - how much data loss is acceptable), and restore test cadence

**Operations** - how to start, stop, restart; how to check [health](#71-service-health-checks); how to debug the three most common failures; escalation contacts; dependency map showing what this service depends on and what depends on it

**Configuration** - every environment variable documented: purpose, example value, required or optional

### 4.9 Machine-Readable Requirement Format

This section defines the canonical format for expressing enforceable requirements in STANDARDS.md and its addenda. Structured requirement units enable linters, generators, and enforcement tools to parse, validate, and cross-reference gates without reading surrounding prose.

#### 4.9.1 Requirement Unit Format

Each requirement unit is exactly three lines. No additional lines appear within a unit. Blank lines separate consecutive units.

```
<a name="REQ-2.2-01"></a>
**REQ-2.2-01** `gate` `define` `hard` `all` `per-item`
A work item title states what is wrong and what correct looks like.
```

- **Line 1:** HTML anchor: `<a name="{REQ-ID}"></a>`
- **Line 2:** Bold REQ-ID followed by four or five space-separated backtick-wrapped tokens
- **Line 3:** One binary, observable, present-tense statement with no sub-clauses

#### 4.9.2 Inline Tag Schema

| Position | Name | Valid values | Required for |
|---|---|---|---|
| 1 | `kind` | `gate` \| `artifact` \| `advisory` | all |
| 2 | `scope` | `discover` \| `define` \| `design` \| `build` \| `verify` \| `document` \| `deploy` \| `monitor` \| `close` (ESE §2.1 lifecycle stages) \| `commit` \| `session-start` \| `session-end` \| `continuous` (enforcement system extensions; see note below) | all |
| 3 | `enforcement` | `hard` \| `soft` \| `none` | all |
| 4 | `applies-when` | `all` \| `type:{name}` \| `addendum:{code}` \| compound expression (§4.9.4) | all |
| 5 | `eval-scope` | `per-item` \| `per-section` \| `per-artifact` \| `per-commit` | `kind:gate` only |

`kind` semantics: `gate` blocks lifecycle progression when the condition fails; `artifact` requires a produced document or named output; `advisory` is informational with no automated block. `enforcement` semantics: `hard` requires tooling to block on failure; `soft` produces a warning without blocking; `none` is informational only and carries no runtime enforcement.

The four scope values without an ESE §2.1 counterpart are enforcement-system extensions: `commit` applies at pre-commit hook execution; `session-start` applies when a work session begins; `session-end` applies when a work session ends; `continuous` applies at all times regardless of lifecycle stage. Adopters providing their own enforcement must implement equivalent hooks for these four values.

Positions 1-4 are required on every requirement unit. Position 5 is required when `kind` is `gate` and omitted otherwise. Requirements carrying only four tokens are valid as `kind:artifact` or `kind:advisory` requirements.

Rationale for all tag values and ESE traceability: [ADR-2026-03-25-ese-machine-readable-first-format.md](docs/decisions/ADR-2026-03-25-ese-machine-readable-first-format.md).

#### 4.9.3 Eval-Scope (5th Token)

The fifth token defines the granularity at which an automated evaluator applies a gate requirement:

- `per-item`: the evaluator runs once per acceptance-criterion item
- `per-section`: the evaluator runs once per document section
- `per-artifact`: the evaluator runs once per complete artifact
- `per-commit`: the evaluator runs once per commit

#### 4.9.4 Applies-When Grammar

The fourth token carries an `applies-when` expression. For compound expressions, the entire expression is contained within one backtick pair. The full grammar in PEG notation:

```peg
applies-when  <- expr EOF
expr          <- or-expr
or-expr       <- and-expr ( SP+ "OR" SP+ and-expr )*
and-expr      <- not-expr ( SP+ "AND" SP+ not-expr )*
not-expr      <- "NOT" SP+ not-expr / primary
primary       <- "(" SP* expr SP* ")" / "all" / type-pred / addendum-pred
type-pred     <- "type:" name
addendum-pred <- "addendum:" code
name          <- [a-z] [a-z0-9\-]*
code          <- [A-Z] [A-Z0-9\-]*
SP            <- [ \t]
EOF           <- !.
```

`{name}` begins with a lowercase ASCII letter; subsequent characters are lowercase letters, decimal digits, or hyphens. `{code}` begins with an uppercase ASCII letter; subsequent characters are uppercase letters, decimal digits, or hyphens. Neither allows a leading hyphen or digit, preventing ambiguity with operator keywords `AND`, `OR`, `NOT` and the literal `all`.

Precedence is encoded structurally: NOT binds tightest, AND next, OR loosest. Parentheses override. No separate precedence table is needed; PEG ordered choice and rule stratification make binding unambiguous by construction. This grammar maps directly to a recursive-descent parser with one function per rule.

Worked examples:

```
`all`
`type:bug`
`type:feature AND addendum:AI`
`(type:feature OR type:epic) AND NOT addendum:LEGACY`
```

#### 4.9.5 REQ-ID Scheme

- **Base requirements** (STANDARDS.md §1-§9): `REQ-{section}-{seq:02d}` e.g. `REQ-2.2-01`
- **Adoption requirements** (docs/adoption.md): `REQ-ADO-{seq:02d}` e.g. `REQ-ADO-01`
- **Starter requirements** (starters/): `REQ-STR-{seq:02d}` e.g. `REQ-STR-01`
- **Template requirements** (templates/): `REQ-TPL-{seq:02d}` e.g. `REQ-TPL-01`
- **Addenda requirements**: `REQ-ADD-{CODE}-{seq:02d}` e.g. `REQ-ADD-AI-01`; codes: `WEB`, `AI`, `CI`, `EVT`, `MS`, `CTR`, `MT`
- `{seq}` is zero-padded two digits assigned sequentially within a section or addendum
- IDs are globally unique: base IDs carry the section number; addenda IDs carry the `ADD-{CODE}-` prefix, which cannot match any section-numbered base ID
- Gaps in sequence are permitted after deprecation

#### 4.9.6 Immutability Rule

REQ-IDs are immutable once published in a released version. A released version is any commit that appears in `CHANGELOG.md` under a versioned heading (not under `[Unreleased]`). An ID is never renumbered, reused, or removed.

When a requirement is deprecated, a sixth optional token is appended to the tag line:

```
<a name="REQ-2.1-01"></a>
**REQ-2.1-01** `gate` `define` `hard` `all` `per-item` `deprecated:REQ-2.1-07`
~~Deprecated: superseded by REQ-2.1-07~~
```

The `deprecated:{superseding-REQ-ID}` token carries the replacing ID. For requirements with no direct successor, use `deprecated:none`. The anchor is retained so the URL fragment continues to resolve. Deprecated gate requirements are omitted from the generated `enforcement-spec.yml`.

#### 4.9.7 Prose vs. Requirement Distinction

A statement earns a REQ-ID when it is (a) binary pass/fail, (b) enforcement-relevant: a gate fires on it or an artifact is produced for it, and (c) not already captured by an existing REQ-ID.

Four content types exist. Types 1 and 2 earn REQ-IDs. Type 3 earns a REQ-ID of `kind:advisory`. Type 4 does not earn a REQ-ID.

**Type 1 (gate):** a condition an automated tool evaluates, returning a block or warning.
**Type 2 (artifact):** a condition satisfied by the existence of a named, inspectable output.
**Type 3 (advisory):** guidance that shapes practice but carries no pass/fail consequence.
**Type 4 (narrative):** rationale, context, examples, analogies, framework mappings.

When the type is ambiguous, assign a REQ-ID. Under-coverage at scale is more costly than over-coverage.

A linter scans every prose block line (any line not immediately following an `<a name="REQ-` anchor within two lines) for the obligation keywords `must`, `required`, `shall`, `block`, `blocks`, `gate`, `cannot`. On a match the linter emits an `unclassified-obligation` warning identifying the line, the keyword, and the classification options.

#### 4.9.8 Line Count Ceiling

<a name="REQ-4.9-03"></a>
**REQ-4.9-03** `gate` `commit` `hard` `all` `per-commit`
Every requirement unit is exactly three lines (anchor, tag line, statement).

<a name="REQ-4.9-07"></a>
**REQ-4.9-07** `gate` `commit` `hard` `all` `per-commit`
No sub-clauses in the statement line.

<a name="REQ-4.9-04"></a>
**REQ-4.9-04** `gate` `commit` `hard` `all` `per-item`
Tag positions 1-4 (kind, scope, enforcement, applies-when) are present on every requirement unit.

<a name="REQ-4.9-08"></a>
**REQ-4.9-08** `gate` `commit` `hard` `all` `per-item`
Position 5 (eval-scope) is present when kind is gate and absent otherwise.

<a name="REQ-4.9-05"></a>
**REQ-4.9-05** `gate` `continuous` `hard` `all` `per-item`
REQ-IDs are immutable once published under a versioned CHANGELOG heading.

<a name="REQ-4.9-09"></a>
**REQ-4.9-09** `gate` `continuous` `hard` `all` `per-item`
Deprecated IDs retain their anchor with a deprecated token.

<a name="REQ-4.9-06"></a>
**REQ-4.9-06** `gate` `commit` `hard` `all` `per-commit`
The obligation keyword linter scans every prose line for must, required, shall, block, blocks, gate, cannot and emits unclassified-obligation warnings for lines without a nearby REQ-ID.

<a name="REQ-4.9-01"></a>
**REQ-4.9-01** `gate` `continuous` `hard` `all` `per-commit`
Section §4.9 does not exceed 150 lines.

<a name="REQ-4.9-10"></a>
**REQ-4.9-10** `gate` `continuous` `hard` `all` `per-commit` `deprecated:none`
~~Deprecated: referenced the prose-line count gate (REQ-4.9-02), which is removed.~~

<a name="REQ-4.9-02"></a>
**REQ-4.9-02** `gate` `continuous` `hard` `all` `per-commit` `deprecated:none`
~~Deprecated: arbitrary prose-line ceiling removed. Document length is governed by §4.7 qualitative test (can be read end to end in a single sitting). No numeric ceiling applies.~~

<a name="REQ-4.9-11"></a>
**REQ-4.9-11** `gate` `continuous` `hard` `all` `per-commit` `deprecated:none`
~~Deprecated: referenced the prose-line count gate (REQ-4.9-02), which is removed.~~

<a name="REQ-4.9-12"></a>
**REQ-4.9-12** `gate` `document` `hard` `all` `per-artifact`
Requirement statements are first-principles based: they state what must be true without referencing specific tools, products, or proprietary systems unless the requirement governs that specific technology domain.

REQ-ID blocks (the 3-line anchor + tag + statement units defined in §4.9.1) are structured reference data, not prose. A practitioner scans them by ID; they do not affect prose readability. Document length is governed by the §4.7 qualitative test: can the document be read end to end in a single sitting and leave the reader knowing what is required?

---

## 5. Code and Deployability

### 5.1 Version Control Discipline

The primary branch is always deployable. All work happens in short-lived branches that are integrated back before their divergence from the primary branch creates material merge conflict risk. No direct commits to the primary branch except emergency hotfixes with a retroactive review.

The generating principle: integration risk grows with the degree of divergence between a branch and its target, not with calendar time per se. However, divergence correlates strongly with elapsed time because the trunk continues to move. Default calibration: one to two days. When a feature takes longer, decompose it into independently mergeable increments rather than accumulating work in a branch.

Commit messages are structured and categorized so that intent is clear from the message alone. The commit body explains why, not what. The specific convention (e.g., Conventional Commits) is a project decision; the requirement for structured, meaningful messages is not.

Every repository has a `.gitignore` (or equivalent) that excludes build artifacts, OS files, IDE configurations, dependency directories, compiled output, and environment/secret files. Nothing generated or machine-specific enters version control.

<a name="REQ-5.1-01"></a>
**REQ-5.1-01** `gate` `continuous` `hard` `all` `per-artifact`
The primary branch is always deployable.

<a name="REQ-5.1-07"></a>
**REQ-5.1-07** `gate` `build` `hard` `all` `per-item`
All work happens in short-lived branches integrated back before divergence from the primary branch creates material merge conflict risk (default calibration: one to two days).

Before merging:
- [ ] All tests pass
- [ ] At least one review. A review verifies: acceptance criteria are met, tests cover the change, no security issues are introduced, code style matches existing patterns, and the change does what the description says. A review that rubber-stamps without checking these items is worse than no review because it creates false confidence. Self-review is acceptable for solo work but must be documented.
- [ ] Documentation updated
- [ ] Gate evidence attached for functional changes (screenshots, test output, quality scores as applicable)
- [ ] Pre-commit checks pass: at minimum, linting, formatting, and type checks. The specific tools are a project decision; the existence of the gate is not.
- [ ] All repositories pushed and verified up to date with remote at session end

<a name="REQ-5.1-02"></a>
**REQ-5.1-02** `gate` `verify` `hard` `all` `per-item`
At least one review is completed before merge.

<a name="REQ-5.1-08"></a>
**REQ-5.1-08** `gate` `verify` `hard` `all` `per-item`
Review verifies acceptance criteria are met.

<a name="REQ-5.1-11"></a>
**REQ-5.1-11** `gate` `verify` `hard` `all` `per-item`
Review verifies tests cover the change.

<a name="REQ-5.1-12"></a>
**REQ-5.1-12** `gate` `verify` `hard` `all` `per-item`
Review verifies no security issues introduced.

<a name="REQ-5.1-13"></a>
**REQ-5.1-13** `gate` `verify` `hard` `all` `per-item`
Review verifies code style matches existing patterns.

<a name="REQ-5.1-14"></a>
**REQ-5.1-14** `gate` `verify` `hard` `all` `per-item`
Review verifies the change does what the description says.

<a name="REQ-5.1-03"></a>
**REQ-5.1-03** `gate` `commit` `hard` `all` `per-commit`
Pre-commit checks pass (linting, formatting, type checks) before merge.

<a name="REQ-5.1-09"></a>
**REQ-5.1-09** `gate` `commit` `hard` `all` `per-commit` `deprecated:non-first-principles`
~~Deprecated: restates a principle; not a testable gate.~~

<a name="REQ-5.1-04"></a>
**REQ-5.1-04** `gate` `commit` `hard` `all` `per-commit`
Commit messages are structured and categorized.

<a name="REQ-5.1-10"></a>
**REQ-5.1-10** `gate` `commit` `hard` `all` `per-commit`
The body explains why, not what.

<a name="REQ-5.1-05"></a>
**REQ-5.1-05** `gate` `commit` `hard` `all` `per-artifact`
The repository .gitignore excludes build artifacts.

<a name="REQ-5.1-15"></a>
**REQ-5.1-15** `gate` `commit` `hard` `all` `per-artifact`
The repository .gitignore excludes OS files and IDE configs.

<a name="REQ-5.1-16"></a>
**REQ-5.1-16** `gate` `commit` `hard` `all` `per-artifact`
The repository .gitignore excludes dependency directories and compiled output.

<a name="REQ-5.1-17"></a>
**REQ-5.1-17** `gate` `commit` `hard` `all` `per-artifact`
The repository .gitignore excludes secret files.

<a name="REQ-5.1-06"></a>
**REQ-5.1-06** `gate` `close` `hard` `all` `per-item`
A future implementor can set up the dev environment using only the documentation.

<a name="REQ-5.1-18"></a>
**REQ-5.1-18** `gate` `close` `hard` `all` `per-item`
A future implementor can understand the change using only the documentation.

<a name="REQ-5.1-19"></a>
**REQ-5.1-19** `gate` `close` `hard` `all` `per-item`
A future implementor can run all tests using only the documentation.

<a name="REQ-5.1-20"></a>
**REQ-5.1-20** `gate` `close` `hard` `all` `per-item`
A future implementor can deploy and verify the change using only the documentation.

<a name="REQ-5.1-21"></a>
**REQ-5.1-21** `gate` `close` `hard` `all` `per-item`
A future implementor knows what monitoring to check using only the documentation.

**Readability test:** Before a change is merged, a future implementor must be able to, using only the documentation: set up the development environment from scratch, understand what the change does and why, run all tests and see them pass, deploy the change, verify the change is working, and know what monitoring to check. If any of these are impossible without asking the original author, the work is not done. Time from clone to a working local environment matters; if setup is slow enough to discourage new contributors, the setup documentation or tooling needs improvement.

### 5.2 Dependency Management

All runtime and build dependencies must be explicitly declared, version-pinned, and reviewed before adoption.

- Run dependency vulnerability scans on every CI pass. High-severity findings block merge unless the vulnerability is in a transitive dependency with no available fix - in that case, document the exposure, file a work item with a mitigation plan, and proceed. Review open exceptions at minimum quarterly until resolved.
- Dependency updates follow the full development lifecycle - they are not silent background bumps.
<a name="REQ-5.2-02"></a>
**REQ-5.2-02** `gate` `continuous` `hard` `all` `per-artifact`
Dependency licenses are audited at minimum annually.

<a name="REQ-5.2-03"></a>
**REQ-5.2-03** `gate` `continuous` `hard` `all` `per-artifact`
No undeclared global tools are required for development or deployment.

- Audit dependency licenses at minimum annually. Copyleft licenses (GNU General Public License (GPL), GNU Affero General Public License (AGPL)) may affect distribution rights. Incompatible licenses must be identified and resolved before the dependency ships.
- No undeclared global tools may be required for normal development or deployment.

<a name="REQ-5.2-01"></a>
**REQ-5.2-01** `gate` `build` `hard` `all` `per-artifact`
All dependencies are explicitly declared, version-pinned, and vulnerability-scanned on every CI pass.

<a name="REQ-5.2-04"></a>
**REQ-5.2-04** `gate` `build` `hard` `all` `per-artifact`
High-severity findings block merge.

<a name="REQ-5.3-01"></a>
**REQ-5.3-01** `artifact` `document` `hard` `all`
Cross-repository changes are documented, all affected repositories updated in the same work session, and coordination recorded in the session log.

<a name="REQ-5.3-02"></a>
**REQ-5.3-02** `artifact` `document` `hard` `all`
Dependent repos are never left inconsistent.

### 5.3 Multi-Repository Coordination

When a change crosses repository boundaries, document which repositories are affected, update all of them in the same logical work session, and record the coordination in the [work session log](#46-work-session-logs). Never leave dependent repositories in an inconsistent state.

### 5.4 Restart Safety and Resilience

> **Activation:** Applies when the project has a runtime service (always-on process) or persistent storage. See Component Capabilities Declaration in standards-application.

All long-running processes must tolerate restart without corrupting state or duplicating irreversible work. Jobs must be idempotent or explicitly resumable. Startup must be fast enough for supervised recovery. Shutdown must be graceful.

Every external call (HTTP, database, queue, third-party API) must have a defined timeout. Unbounded waits are a top reliability failure. Any operation that retries on failure must use exponential backoff with jitter - never retry in a tight loop.

<a name="REQ-5.4-01"></a>
**REQ-5.4-01** `gate` `build` `hard` `all` `per-artifact`
Every external call (HTTP, database, queue, third-party API) has a defined timeout.

<a name="REQ-5.4-03"></a>
**REQ-5.4-03** `gate` `build` `hard` `all` `per-artifact`
Any operation that retries on failure uses exponential backoff with jitter.

<a name="REQ-5.4-04"></a>
**REQ-5.4-04** `gate` `build` `hard` `all` `per-artifact`
All long-running processes tolerate restart without corrupting state or duplicating irreversible work.

<a name="REQ-5.4-02"></a>
**REQ-5.4-02** `artifact` `design` `hard` `all`
Every system defines its behavior under overload (shed load, queue with backpressure, or degrade gracefully) before overload occurs.

Every system must define its behavior under overload before overload occurs. When demand exceeds capacity, the system must do one of: shed load (reject requests with a clear signal), queue with backpressure (push back on producers when the queue is full), or degrade gracefully (serve reduced functionality rather than failing completely). A system that silently degrades without a defined strategy will fail in unpredictable ways when it matters most.

### 5.5 Continuous Integration and Delivery

<a name="REQ-5.5-02"></a>
**REQ-5.5-02** `gate` `deploy` `hard` `all` `per-artifact`
Rollback trigger and strategy are pre-defined before any production deployment.

<a name="REQ-5.5-04"></a>
**REQ-5.5-04** `gate` `deploy` `hard` `all` `per-artifact` `deprecated:REQ-5.5-02`
~~Deprecated: consolidated into REQ-5.5-02 (negative restatement).~~

Every project has an automated CI pipeline that runs on every proposed change before merge is permitted. The pipeline must at minimum:
- Compile or build the project
- Run the full test suite (unit, integration)
- Run dependency vulnerability scans
- Run the pre-commit gate (see [Section 5.1](#51-version-control-discipline))
- Fail visibly on any error - a green pipeline that hides failures is worse than no pipeline

<a name="REQ-5.5-03"></a>
**REQ-5.5-03** `gate` `continuous` `hard` `all` `per-artifact`
Every passing build on the primary branch is deployable to production.

<a name="REQ-5.5-05"></a>
**REQ-5.5-05** `gate` `continuous` `hard` `all` `per-artifact` `deprecated:REQ-5.5-02`
~~Deprecated: consolidated into REQ-5.5-02 (combined restatement).~~

Continuous delivery means every passing build on the primary branch is deployable to production. Whether deployment is automatic (continuous deployment) or manually triggered is a project decision that must be documented. In either case, the rollback trigger and strategy must be pre-defined per [Section 5.7](#57-deployment-strategies-and-release-safety) - not decided ad hoc after a failure.

### 5.6 Infrastructure as Code

> **Activation:** Applies when the project manages infrastructure (servers, cloud resources). See Component Capabilities Declaration in standards-application.

<a name="REQ-5.6-01"></a>
**REQ-5.6-01** `artifact` `deploy` `hard` `all`
Infrastructure is version-controlled, reproducible from the repository, and applied through automation.

<a name="REQ-5.6-02"></a>
**REQ-5.6-02** `artifact` `deploy` `hard` `all`
The runbook documents steps to restore from total environment loss.

Infrastructure that you manage must be version-controlled, reproducible, and applied through automation - not hand-applied on a server. If a machine is destroyed, the environment must be fully reproducible from the repository. For any always-on service, document in the [runbook](#48-documentation-layers) the specific steps to restore from total environment loss, a system-level Recovery Time Objective, and a tested recovery path verified on a defined cadence.

This applies to: server configuration, network rules, database schema, environment setup, secret references, and deployment definitions. "It works on my machine" is not acceptable for any production dependency. Managed services (cloud databases, SaaS integrations) are configured through their provider's API or console - the configuration choices must still be documented and reproducible, even if the underlying infrastructure is not yours to codify.

<a name="REQ-5.7-01"></a>
**REQ-5.7-01** `artifact` `deploy` `hard` `all`
Every production deployment defines its rollout strategy (full cutover, feature flag, canary, or blue-green) before starting.

<a name="REQ-5.7-02"></a>
**REQ-5.7-02** `artifact` `deploy` `hard` `all`
Every production deployment defines its rollback trigger (specific metric threshold or error condition) before starting.

### 5.7 Deployment Strategies and Release Safety

> **Activation:** Applies when the project deploys to a production environment. See Component Capabilities Declaration in standards-application.

Every production deployment defines its rollout strategy before it starts. Acceptable strategies:

- **Full cutover** - replace the running version entirely. Requires fast rollback procedure.
- **Feature flag** - new behavior is gated behind a flag, disabled by default, enabled per environment or user segment. Enables gradual rollout and instant rollback by toggling the flag.
- **Canary** - new version receives a small percentage of traffic. Monitored against the baseline before full rollout.
- **Blue-green** - two environments run in parallel; traffic is switched. Rollback is switching back.

The rollback trigger (per REQ-5.7-02 above) specifies the metric threshold or error condition that initiates a rollback, and who is authorized to trigger it. A deployment without a defined rollback trigger is not a safe deployment.

### 5.8 API Versioning and Compatibility

> **Activation:** Applies when the project exposes an API consumed by other systems. See Component Capabilities Declaration in standards-application.

Any API exposed to consumers - external or internal - must follow an explicit versioning strategy.

- Version numbers follow Semantic Versioning (see [semver.org v2.0.0](https://semver.org), tracked in [dependencies.md](dependencies.md)): major version increments signal breaking changes, minor versions add functionality without breaking existing consumers, patches fix bugs.
- Breaking changes - removing fields, changing field types, altering authentication, removing endpoints - require a major version increment and a documented deprecation period.
- Old API versions remain functional through their deprecation window. The window length must be defined and communicated before the first breaking change is shipped.

<a name="REQ-5.8-01"></a>
**REQ-5.8-01** `gate` `build` `hard` `all` `per-artifact`
APIs follow semantic versioning.

<a name="REQ-5.8-02"></a>
**REQ-5.8-02** `gate` `build` `hard` `all` `per-artifact`
Breaking changes require a major version increment, a documented deprecation period, and old versions remain functional through the deprecation window.
- The API contract ([Section 4.1](#41-what-must-be-documented)) documents the current version and any active deprecations.
- Hyrum's Law (see [hyrumslaw.com](https://www.hyrumslaw.com)): with enough consumers, every observable behavior of an API will be depended on - not just the documented contract. Undocumented behaviors that consumers rely on become implicit contract obligations. Design defensively: assume any behavior you expose will be used, version conservatively, and provide migration tooling alongside deprecation notices rather than just waiting out the deprecation window.

<a name="REQ-5.9-01"></a>
**REQ-5.9-01** `advisory` `build` `soft` `all` `deprecated:non-first-principles`
~~Deprecated: N/A for non-service projects.~~

<a name="REQ-5.9-02"></a>
**REQ-5.9-02** `advisory` `build` `soft` `all`
Secrets have a defined lifecycle.

<a name="REQ-5.9-03"></a>
**REQ-5.9-03** `advisory` `build` `soft` `all`
Logs are structured event streams.

### 5.9 Runtime and Deployability

> **Activation:** Applies when the project has a runtime service. See Component Capabilities Declaration in standards-application.

All services should satisfy the Twelve-Factor App criteria (see [12factor.net](https://12factor.net), 2011-2018 edition, tracked in [dependencies.md](dependencies.md)). Where a factor does not apply to a given architecture (e.g., stateless processes in a stateful system), document the deviation and the alternative approach in the architecture doc.

Key emphasis for services with background workers, daemons, and always-on processes:
- **Config** - secrets and environment-specific configuration live outside code. No exceptions. Secrets have a defined lifecycle: how developers get them locally, how CI pipelines access them, how they reach staging and production, that each environment uses different credentials with the minimum necessary privileges, and a rotation cadence (not just on compromise).
- **Build / release / run** - these are separate stages. Every release has a unique identifier and a documented rollback path.
- **Disposability** - processes restart cleanly. Jobs resume without duplicating completed work.
- **Logs** - structured event streams, not prose. Machine-readable without custom parsers.
- **Admin processes** - migrations, backfills, and repair scripts use the same codebase and configuration as the main application.

### 5.10 Minimum Security Baseline

> **Activation:** Applies when the project handles sensitive or personal data. See Component Capabilities Declaration in standards-application.

**Security design principles:**
- **Defense in Depth** - multiple independent layers of security controls. If one layer is bypassed, others still protect the system.
- **Secure by Default** - the default configuration is the secure configuration. Users and operators must opt into risk, not out of it.
- **Fail Secure** - when a system fails, it denies access rather than granting it. A crashed auth service means no access, not open access.
- **Separation of Duties** - no single person or automated process controls all steps of a critical operation (e.g., deploying code, approving the deploy, and verifying the deploy should not all be the same actor).
- **Zero Trust** - never trust a request based solely on its network location. Authenticate and authorize at every boundary.

**Authentication:** "Strong authentication" means, at minimum: Multi-Factor Authentication (MFA) or equivalent for operator and admin access, no shared accounts, no default credentials. For end-user authentication in products you build, reference OWASP ASVS V2 (Authentication) for password policy, session management, MFA support, account recovery, and brute force protection standards.

<a name="REQ-5.10-02"></a>
**REQ-5.10-02** `gate` `build` `hard` `all` `per-artifact`
Services storing or processing sensitive data meet OWASP ASVS Level 1 minimum controls.

<a name="REQ-5.10-03"></a>
**REQ-5.10-03** `advisory` `design` `soft` `all`
Projects handling personal data in regulated jurisdictions identify which regulations apply and document where compliance evidence lives.

Any service that stores or processes sensitive data (credentials, financial records, health information, personal communications, or similar) must meet the minimum controls defined by the Open Web Application Security Project (OWASP) Application Security Verification Standard (ASVS) v5.0.0 Level 1 (see [owasp.org/www-project-application-security-verification-standard](https://owasp.org/www-project-application-security-verification-standard/), tracked in [dependencies.md](dependencies.md)). Key requirements:

- Remote access defaults to localhost-only. Remote access requires MFA or equivalent strong authentication and encrypted transport.
- Secrets are never stored in source control, logs, screenshots, or crash dumps.
- Sensitive data is classified and handled per its sensitivity level.
- Logs and telemetry redact sensitive payloads.
- Process credentials follow least privilege.
- All external inputs are validated. All rendered outputs are escaped.
- All sensitive data is encrypted at rest (primary data stores, not just backups) and in transit (Transport Layer Security (TLS) for all network communication, no exceptions for internal traffic).
- Backups containing sensitive data are encrypted, restore-tested on a defined cadence, and documented.
- Data is classified into sensitivity levels (e.g., public, internal, confidential, restricted) with handling rules defined per level. The classification lives in the architecture document, not in someone's head.
- Data retention policies are defined: how long each class of data is kept, when and how it is purged, and who authorizes deletion. Without retention policies, storage grows indefinitely and legal exposure increases.
- Projects handling personal data of users in regulated jurisdictions must identify which regulations apply (General Data Protection Regulation (GDPR), California Consumer Privacy Act (CCPA), Personal Information Protection and Electronic Documents Act (PIPEDA), or similar) and where compliance evidence lives. The standard does not prescribe specific regulatory compliance; it requires that the question is answered and documented.
- Security incidents require credential rotation, affected-service review, and a [post-mortem](#82-post-mortem-format).

<a name="REQ-5.10-01"></a>
**REQ-5.10-01** `gate` `deploy` `hard` `all` `per-artifact`
Multi-factor authentication or equivalent is required for operator and admin access.

<a name="REQ-5.10-04"></a>
**REQ-5.10-04** `gate` `deploy` `hard` `all` `per-artifact`
No shared accounts and no default credentials exist in any environment.

<a name="REQ-5.10-05"></a>
**REQ-5.10-05** `gate` `commit` `hard` `all` `per-commit`
Secrets are never stored in source control.

<a name="REQ-5.10-07"></a>
**REQ-5.10-07** `gate` `continuous` `hard` `all` `per-artifact`
Secrets are never stored in logs, screenshots, or crash dumps.

<a name="REQ-5.10-06"></a>
**REQ-5.10-06** `gate` `deploy` `hard` `all` `per-artifact`
All sensitive data is encrypted at rest and in transit (TLS for all network communication).

---

## 6. Testing and Output Quality

<a name="REQ-5.5-01"></a>
**REQ-5.5-01** `gate` `commit` `hard` `all` `per-commit`
An automated CI pipeline runs on every proposed change before merge.

<a name="REQ-5.5-07"></a>
**REQ-5.5-07** `gate` `commit` `hard` `all` `per-commit`
The CI pipeline compiles the code.

<a name="REQ-5.5-08"></a>
**REQ-5.5-08** `gate` `commit` `hard` `all` `per-commit`
The CI pipeline runs the full test suite.

<a name="REQ-5.5-09"></a>
**REQ-5.5-09** `gate` `commit` `hard` `all` `per-commit`
The CI pipeline runs a dependency vulnerability scan.

<a name="REQ-5.5-10"></a>
**REQ-5.5-10** `gate` `commit` `hard` `all` `per-commit`
The CI pipeline runs pre-commit gates.

<a name="REQ-5.5-06"></a>
**REQ-5.5-06** `gate` `commit` `hard` `all` `per-commit`
Pipeline fails visibly on any error.

### 6.1 Test Layers

> **Activation:** Applies when the project contains logic code (functions with branching, looping, or error handling). See Component Capabilities Declaration in standards-application.

The test pyramid (see [Fowler/Vocke, 2018](https://martinfowler.com/articles/practical-test-pyramid.html), tracked in [dependencies.md](dependencies.md)) applies to all projects:

- **Unit tests** - one function or module in isolation, no external dependencies, fast. Every function with logic gets a unit test. "Logic" means: branching, looping, computation, state transformation, error handling, or any behavior where different inputs can produce different outputs. Pure pass-through functions with no logic are exempt.
- **Integration tests** - multiple modules working together, may use a real database, no live external services, runs on CI.
- **System tests** - complete flows end-to-end using the live running system.
- **Regression tests** - every fixed bug produces a regression test. Regression tests are maintained permanently unless explicitly retired with documented justification (recorded both in the work item that authorizes the retirement and as a code comment at the test's former location - e.g., "regression test removed: the tested feature [name] was removed in [version]"). Retirement is a deliberate decision, not cleanup.
- **Performance tests** - assert on timing. Required for any feature with a latency requirement.
- **Load tests** - verify the system handles expected concurrent usage without degradation. Required for any service with external users. Know the breaking point before users find it.

<a name="REQ-6.2-01"></a>
**REQ-6.2-01** `artifact` `define` `hard` `all`
The project maintains a testing gap table audited at the start of every significant feature phase.

<a name="REQ-6.2-02"></a>
**REQ-6.2-02** `artifact` `define` `hard` `all`
P0 and P1 gaps block shipping the affected feature.

### 6.2 Testing Gap Audit

Every project maintains its own testing gap table. Audit at the start of any significant feature phase. Common categories:

| Gap | Typical impact | Priority |
|---|---|---|
| No unit tests for core logic | Regressions invisible without full E2E | P1 |
| No integration tests for boundary components | Inter-module bugs reach production | P1 |
| No regression tests for previously fixed bugs | Same bugs reappear silently | P1 |
| Output review checks presence only, not quality | Quality problems ship undetected | P0 |
| No performance regression baseline | Latency regressions invisible | P2 |
| No failure tests for external dependencies | Unknown behavior when dependencies fail | P2 |
| No security regression tests | Auth and injection bugs slip through | P1 |

P0 and P1 gaps block shipping the affected feature.

### 6.3 Output Quality

> **Activation:** Applies when the project produces user-visible output. See Component Capabilities Declaration in standards-application.

<a name="REQ-6.3-02"></a>
**REQ-6.3-02** `gate` `verify` `hard` `all` `per-artifact`
Every output type is intentional, complete, and clear.

<a name="REQ-6.3-04"></a>
**REQ-6.3-04** `gate` `verify` `hard` `all` `per-artifact`
User-facing output is usable by people with disabilities (keyboard navigation, accessible labels, color not sole channel).

<a name="REQ-6.3-03"></a>
**REQ-6.3-03** `artifact` `define` `hard` `all`
Output quality gate thresholds for the project are documented in the standards application document.

The output of every software component must be intentional, complete, and clear. Output includes user interfaces, API responses, command-line output, error messages, log entries, notifications, and reports. The principles behind this section are grounded in Nielsen's 10 Usability Heuristics (see [nngroup.com](https://www.nngroup.com/articles/ten-usability-heuristics/), tracked in [dependencies.md](dependencies.md)).

<a name="REQ-6.3-01"></a>
**REQ-6.3-01** `gate` `verify` `hard` `all` `per-artifact`
Every output type (UI, API, CLI, errors, logs, notifications, reports) is verified for correct communication.

<a name="REQ-6.3-06"></a>
**REQ-6.3-06** `gate` `verify` `hard` `all` `per-artifact`
Every output type is verified for correct formatting.

<a name="REQ-6.3-07"></a>
**REQ-6.3-07** `gate` `verify` `hard` `all` `per-artifact`
Every output type is verified for error handling.

<a name="REQ-6.3-08"></a>
**REQ-6.3-08** `gate` `verify` `hard` `all` `per-artifact`
Every output type is verified for edge cases.

<a name="REQ-6.3-09"></a>
**REQ-6.3-09** `gate` `verify` `hard` `all` `per-artifact`
Every output type is verified for cross-environment consistency.

For every output type, verify:
- Does the output communicate what the user or consumer needs to know?
- Is formatting consistent and readable at all expected scales - empty state, typical load, and maximum load?
- Are error states handled explicitly and usefully, not with silent failure or generic messages?
- Are edge cases handled - no items, overflow, unexpected input, degraded upstream dependencies?
- Is the output consistent across all deployment environments?

**For visual or rendered output** (web interfaces, generated documents, dashboards, reports):
- Content is not truncated or cut off at any supported size
- Layout does not break under minimum or maximum content
- Text contrast meets accessibility standards. See [Web Content Accessibility Guidelines (WCAG) 2.2](https://www.w3.org/TR/WCAG22/), tracked in [dependencies.md](dependencies.md). Document the specific contrast targets in the project's [application document](starters/standards-application.md).
- Empty states, loading states, and error states are all explicitly handled - no blank pages, no frozen UIs, no opaque error codes
- Every interactive element does what its label says. Form submissions persist data. Navigation routes correctly.
- Output is consistent across all deployment environments
- User-facing output must be usable by people with disabilities: keyboard navigation, accessible labels, color not the sole information channel, screen reader compatibility

Projects with specific output types (web, mobile, hardware) may have additional measurable quality gates defined by external standards. Document those thresholds in the project's [application document](starters/standards-application.md). For existing codebases not yet meeting quality gates, file issues for each gap and resolve incrementally - legacy debt does not block all deployments but must be tracked.

<a name="REQ-6.1-01"></a>
**REQ-6.1-01** `gate` `build` `hard` `all` `per-item`
Every function with logic (branching, looping, computation, state transformation, error handling) has a unit test.

<a name="REQ-6.1-04"></a>
**REQ-6.1-04** `gate` `build` `hard` `all` `per-item`
Every fixed bug has a regression test.

<a name="REQ-6.1-02"></a>
**REQ-6.1-02** `gate` `verify` `hard` `all` `per-item`
Integration tests (multiple modules, may use real DB, runs on CI) pass before the work item advances.

<a name="REQ-6.1-03"></a>
**REQ-6.1-03** `gate` `verify` `hard` `all` `per-item`
Performance tests assert on timing for any feature with a latency requirement.

<a name="REQ-6.1-05"></a>
**REQ-6.1-05** `gate` `verify` `hard` `all` `per-item`
Load tests verify concurrent usage for any service with external users.

### 6.4 No Half-Finished Features

Every feature either fully meets its acceptance criteria, has an explicit issue filed for what remains incomplete, or is explicitly documented as a known limitation. There is no other valid state.

"Close enough" is not done. If a feature cannot be completed correctly in the current cycle, document the gap, file a high-priority issue, and do not present it as complete. A missing health check, absent runbook, or unresolved edge case means the feature is not done.

When a defect is detected during development, whether by a failing test, a gate, a code review, or a team member, work on the affected feature stops until the defect is resolved. Defects are not carried forward to the next stage. A defect passed downstream is not work completed; it is work deferred and compounded: harder to find, more expensive to fix, and more damaging when it surfaces. Schedule pressure does not change this. Every team member and every automated gate holds the authority and obligation to stop progress when a defect is detected. This is the principle behind every gate and test requirement in this section.

### 6.5 Security Regression Standard

> **Activation:** Applies when the project handles authentication, input processing, file handling, or URL fetching. See Component Capabilities Declaration in standards-application.

Changes that affect authentication, data access, file handling, external fetches, or execution of externally supplied input require regression tests covering:
- Unauthorized access
- Input injection (SQL, command, template, and similar)
- Path traversal and unsafe file access
- Server-side request forgery via constructed URLs
- Sensitive data leakage into logs, traces, or responses

These tests are permanent and run on every [CI pass](#55-continuous-integration-and-delivery) once added.

<a name="REQ-6.4-01"></a>
**REQ-6.4-01** `gate` `build` `hard` `all` `per-item`
Work stops when a defect is detected during development.

<a name="REQ-6.4-02"></a>
**REQ-6.4-02** `gate` `build` `hard` `all` `per-item`
No defect passes downstream to the next stage.

<a name="REQ-6.5-01"></a>
**REQ-6.5-01** `gate` `build` `hard` `type:security` `per-item`
Security-affecting changes have regression tests covering unauthorized access.

<a name="REQ-6.5-03"></a>
**REQ-6.5-03** `gate` `build` `hard` `type:security` `per-item`
Security-affecting changes have regression tests covering injection.

<a name="REQ-6.5-04"></a>
**REQ-6.5-04** `gate` `build` `hard` `type:security` `per-item`
Security-affecting changes have regression tests covering path traversal.

<a name="REQ-6.5-05"></a>
**REQ-6.5-05** `gate` `build` `hard` `type:security` `per-item`
Security-affecting changes have regression tests covering SSRF.

<a name="REQ-6.5-06"></a>
**REQ-6.5-06** `gate` `build` `hard` `type:security` `per-item`
Security-affecting changes have regression tests covering data leakage.

<a name="REQ-6.5-02"></a>
**REQ-6.5-02** `gate` `commit` `hard` `all` `per-commit`
Security regression tests are permanent and run on every CI pass.

---

## 7. Monitoring and Observability

### 7.1 Service Health Checks

> **Activation:** Applies when the project has a runtime service (always-on process). See Component Capabilities Declaration in standards-application.

Every always-on service has a health check that is visible on a monitoring page, time-stamped, alerting when silent beyond a configured threshold, and meaningful - a real functional check, not just a process ping.

<a name="REQ-7.1-01"></a>
**REQ-7.1-01** `gate` `deploy` `hard` `all` `per-artifact`
Every always-on service has a health check.

<a name="REQ-7.1-02"></a>
**REQ-7.1-02** `gate` `deploy` `hard` `all` `per-artifact` `deprecated:REQ-7.1-01`
~~Deprecated: consolidated into REQ-7.1-01.~~

<a name="REQ-7.1-03"></a>
**REQ-7.1-03** `gate` `deploy` `hard` `all` `per-artifact` `deprecated:REQ-7.1-01`
~~Deprecated: consolidated into REQ-7.1-01.~~

<a name="REQ-7.1-04"></a>
**REQ-7.1-04** `gate` `deploy` `hard` `all` `per-artifact`
The health check alerts when silent beyond a defined threshold.

<a name="REQ-7.1-05"></a>
**REQ-7.1-05** `gate` `deploy` `hard` `all` `per-artifact`
The health check is functionally meaningful (not just a process ping).

Every project maintains its own health check status table in its project docs, not here. Every gap is an open engineering issue.

<a name="REQ-7.2-01"></a>
**REQ-7.2-01** `artifact` `monitor` `hard` `all` `deprecated:non-first-principles`
~~Deprecated: N/A for projects with no supervised services.~~

<a name="REQ-7.2-02"></a>
**REQ-7.2-02** `artifact` `monitor` `hard` `all` `deprecated:non-first-principles`
~~Deprecated: derivative of monitoring existing.~~

<a name="REQ-7.2-03"></a>
**REQ-7.2-03** `artifact` `monitor` `hard` `all` `deprecated:REQ-7.1-01`
~~Deprecated: consolidated into REQ-7.1-01.~~

<a name="REQ-7.2-04"></a>
**REQ-7.2-04** `artifact` `monitor` `hard` `all` `deprecated:non-first-principles`
~~Deprecated: derivative of monitoring existing.~~

<a name="REQ-7.2-05"></a>
**REQ-7.2-05** `artifact` `monitor` `hard` `all` `deprecated:non-first-principles`
~~Deprecated: derivative of alerting existing.~~

### 7.2 Monitoring Dashboard

The project's monitoring page shows for each supervised service: alive or dead with last health check timestamp, queue depth, error rate for the last 24 hours, last run duration vs. baseline, and active alerts. Services that do not yet meet this level are tracked in the project's health check status table with an open issue to close the gap.

### 7.3 Audit Trail

Every consequential action is logged with: who initiated it, what was done, when, outcome, and duration. Both blocked and permitted actions are logged. Without logging permitted actions, a work session cannot be audited after the fact.

<a name="REQ-7.3-01"></a>
**REQ-7.3-01** `gate` `continuous` `hard` `all` `per-artifact`
Every consequential action is logged with who initiated it.

<a name="REQ-7.3-06"></a>
**REQ-7.3-06** `gate` `continuous` `hard` `all` `per-artifact` `deprecated:REQ-7.3-01`
~~Deprecated: consolidated into REQ-7.3-01.~~

<a name="REQ-7.3-07"></a>
**REQ-7.3-07** `gate` `continuous` `hard` `all` `per-artifact` `deprecated:REQ-7.3-01`
~~Deprecated: consolidated into REQ-7.3-01.~~

<a name="REQ-7.3-08"></a>
**REQ-7.3-08** `gate` `continuous` `hard` `all` `per-artifact` `deprecated:REQ-7.3-01`
~~Deprecated: consolidated into REQ-7.3-01.~~

<a name="REQ-7.3-09"></a>
**REQ-7.3-09** `gate` `continuous` `hard` `all` `per-artifact` `deprecated:REQ-7.3-01`
~~Deprecated: consolidated into REQ-7.3-01.~~

<a name="REQ-7.3-02"></a>
**REQ-7.3-02** `gate` `continuous` `hard` `all` `per-artifact`
Both blocked and permitted actions are logged.

### 7.4 Delivery Health

Track four delivery health metrics for every service in active development: deployment frequency, lead time for changes, change failure rate, and time to restore service. These are defined by the DevOps Research and Assessment (DORA) program (see [dora.dev](https://dora.dev), 2025 research, tracked in [dependencies.md](dependencies.md)). Calibrate targets to the system's criticality - a personal tool has different expectations than a client-facing production service. The goal is small, reversible changes with fast recovery, not maximizing deploy counts.

When delivery health worsens over two consecutive review periods, reduce change size and strengthen testing and gates before resuming feature work.

**Work item cycle time:** In addition to DORA metrics for the deployment pipeline, track cycle time at the work item level: elapsed time from when a work item is claimed (active development begins) to when it is closed with evidence attached. This is distinct from DORA "lead time for changes," which measures code commit to production deployment. Work item cycle time captures the full problem-to-resolution span, including time spent in DEFINE, DESIGN, VERIFY, and DOCUMENT (stages where DORA has no visibility). Measure cycle time per work item class (see [§2.2](#22-work-item-discipline)) and compare across cycles. When cycle time grows while deployment frequency holds steady, the bottleneck is not deployment; it is somewhere earlier in the lifecycle.

**Compound yield and the hidden factory:** Track first-pass yield across delivery stages: what percentage of work items move from each stage to the next without being returned for rework. A PR returned for revision, a VERIFY run repeated because tests were insufficient, a deployment rolled back: each represents rework that does not appear in DORA metrics as a failure but consumes capacity. When stage-level metrics look acceptable but production quality is poor, this rework (the hidden factory) is the explanation. Measure rework within stages, not only at stage exits. The specific measurement approach is a project decision; the requirement to track it is not.

### 7.5 Service Level Objectives

> **Activation:** Applies when the project has an always-on user-facing capability. See Component Capabilities Declaration in standards-application.

Every always-on capability defines at least one user-centered Service Level Indicator (SLI) and Service Level Objective (SLO). The Site Reliability Engineering (SRE) discipline around SLIs, SLOs, and error budgets is documented in the [Google SRE Book (2016)](https://sre.google/sre-book/table-of-contents/) and [SRE Workbook (2018)](https://sre.google/workbook/table-of-contents/), tracked in [dependencies.md](dependencies.md).

Each SLO specifies: how it is measured, the authoritative data source, the error budget, and what action is taken when the budget is exhausted.

<a name="REQ-7.4-01"></a>
**REQ-7.4-01** `artifact` `continuous` `hard` `all`
Four DORA delivery health metrics (deployment frequency, lead time, change failure rate, time to restore) are tracked for every service in active development.

<a name="REQ-7.6-01"></a>
**REQ-7.6-01** `gate` `deploy` `hard` `all` `per-artifact`
Every production service produces correlated traces, metrics, and structured logs.

<a name="REQ-7.6-02"></a>
**REQ-7.6-02** `gate` `build` `hard` `all` `per-artifact`
Sensitive payloads are redacted before emission.

When a service exhausts more than half its monthly error budget, reliability work takes priority over new feature work until the trend corrects.

Alerts declare their severity: page now, same-day review, or daily summary. Only page-now alerts interrupt the operator outside normal working hours. Blank SLO definition template: [templates/slo.md](templates/slo.md).

<a name="REQ-7.5-01"></a>
**REQ-7.5-01** `artifact` `deploy` `hard` `all`
Every always-on capability defines at least one SLI and SLO.

<a name="REQ-7.5-03"></a>
**REQ-7.5-03** `artifact` `deploy` `hard` `all` `deprecated:REQ-7.5-01`
~~Deprecated: consolidated into REQ-7.5-01.~~

<a name="REQ-7.5-04"></a>
**REQ-7.5-04** `artifact` `deploy` `hard` `all` `deprecated:REQ-7.5-01`
~~Deprecated: consolidated into REQ-7.5-01.~~

<a name="REQ-7.5-05"></a>
**REQ-7.5-05** `artifact` `deploy` `hard` `all` `deprecated:REQ-7.5-01`
~~Deprecated: consolidated into REQ-7.5-01.~~

<a name="REQ-7.5-06"></a>
**REQ-7.5-06** `artifact` `deploy` `hard` `all` `deprecated:REQ-7.5-01`
~~Deprecated: consolidated into REQ-7.5-01.~~

<a name="REQ-7.5-02"></a>
**REQ-7.5-02** `gate` `continuous` `hard` `all` `per-section`
When a service's error budget consumption rate, extrapolated forward, would exhaust the remaining budget before the measurement period ends, reliability work takes priority over new feature work until the trend corrects. The generating principle: error budgets balance reliability investment against feature velocity; when consumption outpaces the planned rate, the balance has tipped toward unreliability. The simplest check: if more than half the budget is consumed before the period's midpoint, the rate exceeds plan.

### 7.6 Observability Standard

Health checks and audit logs are necessary but not sufficient. For production services, every request, background job, and deployment event produces correlated telemetry across traces, metrics, and structured logs. See [OpenTelemetry specification v1.x](https://opentelemetry.io/docs/specs/otel/), tracked in [dependencies.md](dependencies.md).

At minimum:
- **Traces** - root spans for requests, jobs, external calls, and database operations, with context IDs propagated across all service boundaries
- **Metrics** - latency histograms, success and failure counts, retry counts, queue depth, queue age
- **Logs** - structured, with at minimum: timestamp, level, service, version, correlation ID, outcome, redacted error detail

Sensitive payloads must be redacted before emission.

### 7.7 Measurement Integrity

<a name="REQ-7.7-01"></a>
**REQ-7.7-01** `advisory` `continuous` `soft` `all`
Before drawing conclusions from any metric, the metric definition is confirmed unambiguous.

<a name="REQ-7.7-04"></a>
**REQ-7.7-04** `advisory` `continuous` `soft` `all`
Before drawing conclusions from any metric, the data source is confirmed authoritative.

<a name="REQ-7.7-05"></a>
**REQ-7.7-05** `advisory` `continuous` `soft` `all`
Before drawing conclusions from any metric, a calibration test is run.

<a name="REQ-7.7-02"></a>
**REQ-7.7-02** `advisory` `continuous` `soft` `all`
Signal is distinguished from noise before responding to metric movement.

Three principles apply to all metrics tracked under this section: health checks ([§7.1](#71-service-health-checks)), delivery health ([§7.4](#74-delivery-health)), SLOs ([§7.5](#75-service-level-objectives)), and observability telemetry ([§7.6](#76-observability-standard)).

**Validate before trusting.** Before drawing conclusions from any metric, verify that the measurement system is reliable and captures what it claims to capture. Validation means: (1) confirming the measurement definition is unambiguous (what events increment the counter, what time window applies, what is excluded); (2) confirming the data source is authoritative (the system that records the event, not a derived report); and (3) running a calibration test on known data (a controlled change with a known expected outcome confirms the metric responds as intended). Document what validation was performed for each metric in the project's [standards-application document](starters/standards-application.md).

**Distinguish signal from noise.** Before responding to a metric movement, determine whether it represents a real shift in system behavior (special cause variation) or normal fluctuation within a stable process (common cause variation). Responding to common cause variation as though it were a signal increases variation rather than reducing it.

**Measure process capability, not only outcomes.** Measure how consistently the delivery process meets its quality targets over time, not only whether a threshold was breached on a given day.

For the statistical foundations behind these principles (process control theory, tampering, capability indices), see [docs/background.md](docs/background.md).

---

## 8. Learning from Failure

### 8.1 Incident Taxonomy

Classify every incident before writing a post-mortem. Classification supports pattern detection:
- Software defect (logic error, race condition, null handling)
- Data integrity (corruption, loss, stale state)
- Infrastructure failure (dependency outage, resource exhaustion)
- Security incident (unauthorized access, data exposure, credential misuse)
- Configuration error (wrong environment, missing variable, version mismatch)
- Behavioral regression (a change made things worse in a way tests did not catch)

Projects with probabilistic or learned components should extend this taxonomy in their [application document](starters/standards-application.md).

Every incident must produce one or more regression cases that would have caught it earlier.

<a name="REQ-8.1-01"></a>
**REQ-8.1-01** `gate` `close` `hard` `type:bug` `per-item`
Every incident is classified per the taxonomy before the post-mortem is written and produces at least one regression case.

<a name="REQ-8.2-01"></a>
**REQ-8.2-01** `artifact` `close` `hard` `type:bug`
A post-mortem exists for every P0 and P1 incident.

<a name="REQ-8.2-02"></a>
**REQ-8.2-02** `artifact` `close` `hard` `type:bug` `deprecated:REQ-8.2-01`
~~Deprecated: consolidated into REQ-8.2-01.~~

<a name="REQ-8.2-03"></a>
**REQ-8.2-03** `artifact` `close` `hard` `type:bug`
The post-mortem identifies the root cause.

<a name="REQ-8.2-04"></a>
**REQ-8.2-04** `artifact` `close` `hard` `type:bug` `deprecated:REQ-8.2-03`
~~Deprecated: consolidated into REQ-8.2-03.~~

<a name="REQ-8.2-05"></a>
**REQ-8.2-05** `artifact` `close` `hard` `type:bug` `deprecated:REQ-8.2-01`
~~Deprecated: consolidated into REQ-8.2-01.~~

<a name="REQ-8.2-06"></a>
**REQ-8.2-06** `artifact` `close` `hard` `type:bug` `deprecated:REQ-8.2-01`
~~Deprecated: consolidated into REQ-8.2-01.~~

<a name="REQ-8.2-07"></a>
**REQ-8.2-07** `artifact` `close` `hard` `type:bug` `deprecated:REQ-8.2-01`
~~Deprecated: consolidated into REQ-8.2-01.~~

<a name="REQ-8.2-08"></a>
**REQ-8.2-08** `artifact` `close` `hard` `type:bug` `deprecated:REQ-8.2-01`
~~Deprecated: consolidated into REQ-8.2-01.~~

<a name="REQ-8.2-09"></a>
**REQ-8.2-09** `artifact` `close` `hard` `type:bug` `deprecated:REQ-8.2-01`
~~Deprecated: consolidated into REQ-8.2-01.~~

<a name="REQ-8.2-10"></a>
**REQ-8.2-10** `gate` `continuous` `hard` `all` `per-item`
Every prevention action in a post-mortem has a tracked work item (type=prevention) that is not closed until the action is implemented.

<a name="REQ-8.2-11"></a>
**REQ-8.2-11** `gate` `close` `hard` `type:prevention` `per-item`
A prevention work item includes evidence that the implemented action prevents the original failure mode, not just that the action was completed.

**Severity levels:**
- **P0** - complete outage or data loss. Core functionality is unavailable for all users. Immediate response required.
- **P1** - major degradation. A primary feature is broken or significantly impaired. Same-day resolution.
- **P2** - minor issue. Non-critical functionality is affected, a workaround exists, or a small number of users are impacted. Resolved within the current work cycle.
- **P3** - cosmetic or low-impact. No user workflow is blocked. Scheduled for a future cycle.

### 8.2 Post-Mortem Format

> **Activation:** Applies when the project experiences a P0/P1 incident or any incident affecting external users. See Component Capabilities Declaration in standards-application.

<a name="REQ-8.4-01"></a>
**REQ-8.4-01** `artifact` `continuous` `hard` `all`
The project maintains an anti-pattern registry.

<a name="REQ-8.4-02"></a>
**REQ-8.4-02** `artifact` `continuous` `hard` `all`
Entries are promoted from lessons-learned when the same pattern appears in 2+ post-mortems, a P0 reveals a systemic factor, or a compliance review surfaces the pattern across 2+ cycles.

<a name="REQ-8.5-01"></a>
**REQ-8.5-01** `artifact` `deploy` `hard` `all`
The incident communication channel is defined before the first incident occurs.

<a name="REQ-8.5-02"></a>
**REQ-8.5-02** `artifact` `deploy` `hard` `all`
User-affecting incidents are communicated with impact and expected resolution timeline.

Write a post-mortem for every P0 and P1 incident. P2 incidents at the team's discretion. P3 does not require a post-mortem. Post-mortems are blameless: the question is not who made a mistake, but what conditions allowed the mistake to reach production and how to change the system to make recurrence harder.

Four principles from Deming's System of Profound Knowledge deepen what blameless analysis requires in practice (see [deming.org/explore/sopk/](https://deming.org/explore/sopk/), tracked in [dependencies.md](dependencies.md)). First, appreciation for a system: most failures result from how the system is designed, not from individual error. A practitioner who followed the process correctly can still produce a defect if the process permits it. The question is always what system conditions allowed the outcome, not what the individual did wrong. Second, knowledge of variation: a failure is either common cause (produced regularly by the stable process) or special cause (produced by a specific, unusual condition). Common cause failures require process improvement; special cause failures require removing the specific contributing condition. Treating a common cause failure as a one-off anomaly guarantees recurrence, because the system continues producing the same outcome. Third, theory of knowledge: every prevention action is a prediction. Before closing a post-mortem, state explicitly what outcome the proposed change predicts. After the action is implemented, verify the prediction holds. Prevention actions that do not carry explicit predictions are not evidence-based reasoning about cause; they are guesses. Fourth, psychology: the blameless environment exists not as a courtesy but as a prerequisite for accurate information. When individuals fear punishment, they hide problems, route around failures, and optimize for personal safety rather than system improvement. Without psychological safety, the post-mortem is missing its most important inputs.

Blank template: [templates/post-mortem.md](templates/post-mortem.md).

Required sections: timeline, root cause (technical, specific), contributing factors, impact (quantified), detection (how discovered and how long after it started; if detection latency allowed material user impact to accumulate before response began, file a [monitoring gap issue](#71-service-health-checks); the generating principle is that detection must outpace damage accumulation), resolution, prevention actions with issue IDs, and lessons learned.

If the incident involved data exposure, credential misuse, or unauthorized access, also complete the security supplement: containment steps, credential rotation performed, exposure window, and user-impact assessment. This section is included in the template.

### 8.3 Lessons Learned Registry

Every project maintains a lessons-learned registry in its project docs. Every post-mortem lesson is added to it. Before starting any new feature, the registry is consulted for relevant entries. It is the institutional memory that prevents recurrence.

A lessons-learned entry records a specific observation from a specific incident: what happened, what the team now does differently, and the source post-mortem. It is a factual record tied to one event. Starter file: [starters/lessons-learned-registry.md](starters/lessons-learned-registry.md).

<a name="REQ-8.3-02"></a>
**REQ-8.3-02** `artifact` `continuous` `hard` `all`
The project maintains a lessons-learned registry.

<a name="REQ-8.3-04"></a>
**REQ-8.3-04** `artifact` `continuous` `hard` `all` `deprecated:REQ-8.3-02`
~~Deprecated: consolidated into REQ-8.3-02.~~

### 8.4 Anti-Pattern Registry

Every project maintains an anti-pattern registry. An anti-pattern is a practice that looks correct - it is not obviously wrong - but consistently causes problems in this system. Anti-patterns are extracted from multiple incidents or from a single severe one. Promote a lessons-learned entry to an anti-pattern when: (a) the same named pattern appears in 2 or more post-mortems, (b) a single incident has severity P0 and the pattern is identified as a systemic contributing factor, or (c) a compliance review surfaces the same named pattern across 2 or more review cycles. They differ from lessons learned in that they are generalized and named, not tied to a single event: the point is to recognize the pattern when it recurs and name it in reviews.

Each entry records: the name of the pattern, why it looks like the right approach, why it fails here, and the incident that first surfaced it. Starter file: [starters/anti-pattern-registry.md](starters/anti-pattern-registry.md).

### 8.5 Incident Communication

When a production incident affects users, they must be informed: what is happening, what the impact is, and when to expect resolution. Define the communication channel (status page, email, in-product banner, or other) before the first incident occurs. Discovering during an outage that there is no way to tell users about it compounds the problem.

### 8.6 Technical Debt Tracking

Technical debt acknowledged in [ADRs](#42-adr-format), [post-mortems](#82-post-mortem-format), or code comments must be tracked as [work items](#22-work-item-discipline) (type=debt) - not just mentioned and forgotten. When a debt work item is closed, update the source document (ADR, post-mortem, or code comment) that originally noted the debt to indicate it is resolved, with the work item ID and resolution date. Periodically audit accumulated debt and prioritize paying it down. Debt that is never reviewed grows silently until it causes an incident.

Prioritize debt paydown using the Cost of Quality lens: compare the ongoing cost of carrying the debt (rework time, incident risk, and slower delivery caused by working around known problems) against the cost of resolving it. Debt that appears low-risk in day-to-day work often has high compound cost that only becomes visible after an incident.

<a name="REQ-8.6-01"></a>
**REQ-8.6-01** `gate` `continuous` `hard` `all` `per-item`
Acknowledged technical debt is tracked as type=debt work items.

<a name="REQ-8.6-02"></a>
**REQ-8.6-02** `gate` `close` `hard` `type:debt` `per-item`
When a debt work item is closed, the source document (ADR, post-mortem, or code comment) is updated with the work item ID.

<a name="REQ-8.6-03"></a>
**REQ-8.6-03** `gate` `close` `hard` `type:debt` `per-item` `deprecated:REQ-8.6-02`
~~Deprecated: consolidated into REQ-8.6-02.~~

Periodically measure codebase health beyond what informal tracking surfaces. Common indicators include: duplicate code, dead or unused code, dependency currency, and version proliferation across the codebase. The specific metrics appropriate to a given technology stack belong in the project's [application document](starters/standards-application.md). These measurements identify systemic maintainability problems that no single work item reveals.

### 8.7 A3 Structured Problem Solving

The post-mortem format ([§8.2](#82-post-mortem-format)) is designed for production incidents: there is a timeline, a measurable impact, and a failure that reached users. It is the wrong format for non-incident improvement problems (recurring quality issues, delivery bottlenecks, process inefficiencies) where there is no failure event to reconstruct and no incident timeline to anchor the analysis.

<a name="REQ-8.7-01"></a>
**REQ-8.7-01** `artifact` `define` `hard` `type:improvement`
Recurring quality issues, delivery bottlenecks, and process inefficiencies use A3 structured problem solving.

<a name="REQ-8.7-02"></a>
**REQ-8.7-02** `artifact` `define` `hard` `type:improvement`
The A3 is completed before countermeasures are implemented.

Use A3 structured problem solving for systematic improvement work that does not have a production incident as its trigger. An A3 is a one-page format that enforces concise problem definition before proposing countermeasures. Blank template: [templates/a3.md](templates/a3.md).

The A3 is a complement to the post-mortem, not a replacement. Post-mortems investigate failures that occurred; A3s address patterns and inefficiencies that, if unaddressed, will eventually produce failures.

---

## 9. Technology Adoption

<a name="REQ-8.3-01"></a>
**REQ-8.3-01** `gate` `define` `hard` `all` `per-item`
The lessons-learned registry is consulted before starting any new feature.

<a name="REQ-8.3-03"></a>
**REQ-8.3-03** `gate` `close` `hard` `type:bug` `per-item`
Every post-mortem lesson is added to the lessons-learned registry.

### 9.1 Evaluation Framework

Before adopting any new technology, framework, or external service, complete this evaluation. "Adoption" means introducing a new package or service not previously used in the project, or a version change that introduces a behavior-category change (new API surface, removed API, changed security model). Version bumps within a stable API are dependency updates governed by [§5.2](#52-dependency-management), not adoption. The [§2.1 DESIGN](#21-the-lifecycle) ADR trigger for "adds a new external dependency" applies the same threshold. Blank template: [templates/tech-eval.md](templates/tech-eval.md).

**Research** (time-boxed; the generating principle is Parkinson's Law: work expands to fill the time available; a time-box forces a decision with available information rather than deferring indefinitely; default calibration: 1-2 days; adjust based on the criticality and reversibility of the adoption decision):
- What problem does it solve, and what are the alternatives?
- What are the known failure modes?
- What is the ongoing maintenance cost and operator toil?
- What is the security exposure - does it process sensitive data?
- Can it be traced, measured, and monitored with existing tooling?
- What is the exit strategy if the vendor changes terms, pricing, or quality?
- What is the license?

**Proof of concept** (time-boxed; same principle; default calibration: 3 days):
- Build the smallest thing that validates the core assumption
- Measure actual performance, not claimed performance
- Document what breaks if this dependency is removed

<a name="REQ-9.1-02"></a>
**REQ-9.1-02** `artifact` `design` `hard` `all`
The technology adoption decision (proceed, reject, or defer) is recorded in an ADR with rollback plan defined before integration begins.

**Decision** ([ADR](#42-adr-format) required):
- Proceed, Reject, or Defer
- If Proceed: define a rollback plan before starting integration
- If Reject: document why, to prevent re-evaluating the same option

<a name="REQ-9.1-01"></a>
**REQ-9.1-01** `artifact` `design` `hard` `all`
Research is completed before adopting any new technology, framework, or external service.

<a name="REQ-9.1-04"></a>
**REQ-9.1-04** `artifact` `design` `hard` `all` `deprecated:REQ-9.1-01`
~~Deprecated: consolidated into REQ-9.1-01.~~

<a name="REQ-9.1-05"></a>
**REQ-9.1-05** `artifact` `design` `hard` `all` `deprecated:REQ-9.1-02`
~~Deprecated: consolidated into REQ-9.1-02.~~

**Integration** (only if Decision is Proceed):
- Follows the full development lifecycle from [Section 2](#2-methodology) - no shortcuts because "it's just a library"
- The new technology gets dedicated [architecture documentation](#31-component-architecture-template) before it reaches production
- [Alerts and monitoring](#71-service-health-checks) configured for the new dependency - health check, error rate, latency
- [Runbook](#48-documentation-layers) updated with the new dependency's failure mode and recovery procedure

### 9.2 Technology ADR Backlog

Every project maintains its own technology [ADR](#42-adr-format) backlog. Every technology decision in active use that was made without a formal ADR needs one. File an issue for the retroactive ADR - the issue unblocks continued work while ensuring the ADR gets written. The ADR itself does not block the next change, but the issue must exist.

Retroactive ADR status field: `Accepted (retroactive) - decision made {date}, ADR written {date}`.

<a name="REQ-9.2-01"></a>
**REQ-9.2-01** `artifact` `continuous` `hard` `all`
Every technology decision in active use that lacks a formal ADR has a filed work item for a retroactive ADR.

### 9.3 External Standards Management

External standards and research programs are dependencies, not just citations. They have their own change cycles, and a practice built on an outdated version of an external standard may be subtly wrong.

Every project that references external standards maintains a dependency tracking document listing each standard, the version or publication date referenced, the last review date, and a note on any known upcoming changes.

<a name="REQ-9.3-01"></a>
**REQ-9.3-01** `artifact` `continuous` `hard` `all`
A dependency tracking document lists each referenced external standard with version, last review date, and known upcoming changes.

<a name="REQ-9.3-02"></a>
**REQ-9.3-02** `artifact` `continuous` `hard` `all`
Affected practices are updated when a standard changes materially.

When a referenced standard changes materially, update the affected practices and record the change in the [changelog](#43-changelogs). The annual review of dependencies catches most updates. This repository's external dependencies are tracked in [dependencies.md](dependencies.md).

---

---

## Addenda

The universal standard covers principles that apply to all software projects. The following first-party addenda extend it for specific architectures, team structures, and deployment contexts. Apply every addendum that matches your project's context in addition to - not instead of - the universal standard.

| Addendum | Apply when |
|---|---|
| [Multi-Service Architectures](docs/addenda/multi-service.md) | Your project communicates with services owned by other teams, or owns a service consumed by other teams |
| [Multi-Team Organizations](docs/addenda/multi-team.md) | More than one team contributes to or depends on your project |
| [Web Applications](docs/addenda/web-applications.md) | Your project includes a browser-rendered user interface |
| [Containerized and Orchestrated Systems](docs/addenda/containerized-systems.md) | Your project runs in containers or is managed by an orchestrator |
| [AI and ML Systems](docs/addenda/ai-ml.md) | Your project trains, fine-tunes, or serves machine learning models, or builds on probabilistic AI outputs |
| [Event-Driven Systems](docs/addenda/event-driven.md) | Your project produces or consumes events or messages via a broker, queue, or stream |
| [Agent-Assisted Development](docs/addenda/agent-assisted-development.md) | AI coding agents hold commit authority in your repository, whether as primary maintainers, paired collaborators, or autonomous contributors |
| [Continuous Improvement](docs/addenda/continuous-improvement.md) | Your project has recurring quality issues of the same class, delivery throughput consistently below required rate, or is targeting a defined sigma-level quality improvement goal |

