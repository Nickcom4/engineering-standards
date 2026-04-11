---
type: problem-research
stage:
  - discover
applies-to:
  - feature
  - epic
implements:
  - REQ-1.1-01
---

# Problem Research: {Problem Name}

> **Dual-role template.** This template serves two distinct use cases at different depths:
>
<a name="REQ-TPL-42"></a>
**REQ-TPL-42** `advisory` `continuous` `soft` `all`
Full depth (§1.2 Step 1 for complex products): Complete all sections.

> - **Full depth** ([§1.2](../STANDARDS.md#12-document-progression) Step 1 for complex products): Complete all sections. Required before capabilities or PRD work begins. Gate: gate authority confirms the problem is characterized before proceeding to Step 2.
> - **Abbreviated** ([§2.1 DISCOVER D2](../STANDARDS.md#21-the-lifecycle) characterization for routine features): Complete only the **Problem Statement** and **Decision** sections when a signal is confirmed but acceptance criteria cannot yet be written. Sufficient to proceed to DEFINE.
>
> Problem research for {Project Name}. Per [§2.1 DISCOVER](../STANDARDS.md#21-the-lifecycle): evidence required - user report, log error, metric drift, or validated observation. No work item without evidence of a real problem. A capabilities document written without this research is speculation, not product development.

---

## Problem Statement

> [§1.1](../STANDARDS.md#11-before-starting-any-significant-work): the problem statement answers five questions before any solution is considered.

**Who has this problem?**
{Specific user type, role, or context - not "users" generically. Name the person.}

**How frequently does it occur?**
{Daily / weekly / per transaction / on every deployment - with observed frequency or an estimate with a stated basis, not a guess.}

**What do they currently do instead?**
{The current workaround, manual step, or alternative. This establishes the status quo and its cost.}

**What is the cost of the current approach?**
{Time lost, errors introduced, revenue impact, user frustration - quantified where possible. An unquantified cost is an assumption.}

**What does solved look like - concretely?**
{Observable end state a user would recognize without explanation. Use "The user can X without Y" format. No implementation details.}

---

## Existing Landscape

> [§1.1](../STANDARDS.md#11-before-starting-any-significant-work): first principles check - what is the simplest solution that meets the requirement? Check what already exists before proposing something new.

**What alternatives or partial solutions already exist?**
{Competing tools, internal workarounds, adjacent features - and why each does not fully solve the problem. If nothing exists, say so and explain why.}

**What has been tried before in this codebase or organization?**
{Prior attempts, with outcome and reason for failure or abandonment. Check the [lessons-learned registry](../STANDARDS.md#83-lessons-learned-registry) before filling this in - per [§8.3](../STANDARDS.md#83-lessons-learned-registry).}

**Could this be solved without new code?**
{Configuration change, combining existing components, removing friction from an existing feature. If yes: what would that look like? The simplest solution that meets the requirement is the best solution - per [§3.2](../STANDARDS.md#32-design-principles) KISS.}

---

## Evidence

<a name="REQ-TPL-43"></a>
**REQ-TPL-43** `advisory` `continuous` `soft` `all`
§2.1 DISCOVER: evidence required. Anecdote is weak evidence; frequency data, user sessions, and support tickets are stronger.

> [§2.1 DISCOVER](../STANDARDS.md#21-the-lifecycle): evidence required. Anecdote is weak evidence; frequency data, user sessions, and support tickets are stronger. Per [§2.7](../STANDARDS.md#27-user-feedback): user feedback is evidence for the DISCOVER step.

| Source | Finding | Date |
|--------|---------|------|
| {User interview / support ticket / log data / metric / observation} | {What it shows} | YYYY-MM-DD |

**Evidence quality check:**
- [ ] At least one direct user observation, report, or support ticket
- [ ] Frequency is estimated from data, not assumption
- [ ] Cost of the current approach is quantified (even rough order of magnitude)
- [ ] The solved state is observable and binary - an outsider could verify it

---

## First Principles Check

> [§1.1](../STANDARDS.md#11-before-starting-any-significant-work): run before writing any capabilities.

- What is this fundamentally trying to do?
<a name="REQ-TPL-44"></a>
**REQ-TPL-44** `advisory` `continuous` `soft` `all`
What constraints cannot change?.

- What constraints cannot change?
- What is the simplest solution that meets the requirement?

---

## Open Questions

> [§2.2](../STANDARDS.md#22-work-item-discipline): work is not ready to proceed until dependencies are identified. Unresolved questions here are blockers for the capabilities step.

| Question | Who can answer | Priority |
|----------|---------------|----------|
| | | |

---

## Decision

> [§2.1 DISCOVER](../STANDARDS.md#21-the-lifecycle): every discovery step produces a decision. Document it so it is not re-researched.

- [ ] **Proceed** - evidence supports building. Create a [§2.2](../STANDARDS.md#22-work-item-discipline) work item (type=feature) for the capabilities phase with discovered-from pointing to this problem research document. Work item ID: {ID}. Then move to Capabilities document.
- [ ] **Defer** - problem is real but not prioritized now. File a [§2.2](../STANDARDS.md#22-work-item-discipline) work item to track the deferral. Work item ID: {ID}.
- [ ] **Close** - problem does not warrant work. Document the reason so it is not re-researched.

**Rationale:**
{Why this decision was made. Future sessions will read this.}

---

## Next Step

If proceeding: write a Capabilities document. Template: [templates/capabilities.md](capabilities.md).

---

*Completed by: {name}*
*Date: YYYY-MM-DD*
*Project: {project name}*
