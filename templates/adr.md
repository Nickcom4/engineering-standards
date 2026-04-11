---
type: adr
id: ADR-{number}
title: "{Title}"
status: Proposed
date: YYYY-MM-DD
deciders: "{who was involved}"
stage:
  - design
applies-to: all
implements:
  - REQ-4.2-01
  - REQ-2.1-03
# Lifecycle document cross-references (populate when applicable; omit fields that do not apply):
# dfmea: filename of the associated DFMEA (required when this ADR introduces auth/payments/data/external integrations)
# pfmea: filename of the associated PFMEA (required when this ADR introduces qualifying process changes)
# architecture-doc: filename of the associated architecture doc (required when this ADR introduces a new component)
dfmea: ~
pfmea: ~
architecture-doc: ~
---

# ADR-YYYY-MM-DD: {Title}

<a name="REQ-TPL-03"></a>
**REQ-TPL-03** `advisory` `continuous` `soft` `all`
Architectural Decision Record. Required by §4.2 for any change that introduces a new component, replaces an existing approach, adds an external dep...

> Architectural Decision Record. Required by [§4.2](../STANDARDS.md#42-adr-format) for any change that introduces a new component, replaces an existing approach, adds an external dependency, or alters how services communicate. Also required at [§2.1 DESIGN step](../STANDARDS.md#21-the-lifecycle) and for all technology adoption decisions per [§9.1](../STANDARDS.md#91-evaluation-framework).
>
> The YAML frontmatter above is required by the CI gate (`.github/workflows/ci.yml` Check 2). The five CI-required fields are: `type`, `id`, `title`, `status`, `date`. The `deciders` field is recommended but not enforced by CI. Status values: `Proposed` | `Accepted` | `Superseded by ADR-{n}`.

---

## Context

> [§4.2](../STANDARDS.md#42-adr-format): describe the problem, constraints, and cost of doing nothing.
>
> If this decision replaces an existing approach: update the superseded ADR's status field to `Superseded by ADR-{this number}` and link it here.

What problem are we solving? What constraints exist?
What would happen if we did nothing?

**Supersedes:** {ADR-NNN if replacing an existing approach, or N/A}

---

## Decision

> [§4.2](../STANDARDS.md#42-adr-format): be specific and unambiguous. Not "we will consider X" - "we are doing X."

What are we doing? Be specific and unambiguous.

---

## Consequences

> [§4.2](../STANDARDS.md#42-adr-format): state both positive and negative trade-offs. An ADR with no negative consequences was not thought through.

### Positive

- What improves?

### Negative

- What trade-offs were accepted?
- What technical debt does this create?

---

## Alternatives Considered

<a name="REQ-TPL-04"></a>
**REQ-TPL-04** `advisory` `continuous` `soft` `all`
§4.2: every rejected alternative must have a documented rejection rationale. This prevents re-evaluating the same option later.

> [§4.2](../STANDARDS.md#42-adr-format): every rejected alternative must have a documented rejection rationale. This prevents re-evaluating the same option later.

### {Alternative}

Why was this rejected?

---

## Validation

<a name="REQ-TPL-05"></a>
**REQ-TPL-05** `advisory` `continuous` `soft` `all`
§4.2: what observable signal confirms this decision was correct, and what triggers the assessment? Criteria must be binary (true or false, not a ju...

> [§4.2](../STANDARDS.md#42-adr-format): what observable signal confirms this decision was correct, and what triggers the assessment? Criteria must be binary (true or false, not a judgment call) and outcome-triggered (an event, not a calendar window). See §4.2 for the full requirement.

**Pass condition:** {specific observable state that is either true or false}

**Trigger:** {the event that makes this assessment possible - first external adoption, first production deployment, first incident, first N uses, etc.}

**Failure condition:** {what would indicate the decision was wrong and should be revisited}

**Example:** "Pass: no adopter has filed an issue requesting restoration of inline templates since first adoption review. Trigger: first external project completes adoption. Failure: any such issue filed."

---

## Per-Document Impact Analysis <!-- optional -->

> Required by [REQ-4.2-10](../STANDARDS.md#req-4210) for ADRs modifying an existing component, API, interface, or standard. List every document affected by this decision. Documents confirmed unchanged must be listed explicitly. Optional in the template-compliance linter: only ADRs that modify an existing component, API, interface, or standard need to include this section. ADRs introducing genuinely new decisions with no existing artifacts to modify may omit it.

| Document | Change required | Notes |
|---|---|---|
| {path/to/doc.md} | {Yes: description of change / No: confirmed no change required} | |

---

## Follow-on Requirements <!-- optional -->

> If this decision introduces or modifies a component touching authentication, payments, data mutation, or external integrations, complete a FMEA per [§2.1 DESIGN](../STANDARDS.md#21-the-lifecycle) before BUILD begins. Optional in the template-compliance linter: only ADRs that introduce qualifying follow-on obligations (FMEA, new REQ-IDs, etc.) need this section. Process-only ADRs that trigger no downstream artifacts may omit it.

<a name="REQ-TPL-06"></a>
**REQ-TPL-06** `advisory` `continuous` `soft` `all`
FMEA required: {yes / no}.

**FMEA required:** {yes / no}
**FMEA path:** {link to FMEA if yes, or N/A}

---

## Implementation Checklist <!-- optional -->

> Maps this ADR's decisions to concrete deliverables. An accepted ADR without an implementation path produces a decision that is never executed. Each row traces to a work item or pre-BUILD control. ADR does not close until every row has a work item reference or is marked N/A. Optional in the template-compliance linter: ADRs whose implementation is trivial or fully described in the Decision section may omit this scaffolding. Required when the ADR introduces new components, scripts, or tracked work items.

<a name="REQ-TPL-07"></a>
**REQ-TPL-07** `advisory` `continuous` `soft` `all`
Pre-BUILD controls (must be passing before implementation begins):.

**Pre-BUILD controls (must be passing before implementation begins):**

| # | Deliverable | Maps to | AC summary | Work Item |
|---|---|---|---|---|
| T1 | {tool, script, or gate} | {FMEA FM-XX or decision reference} | {one-sentence binary AC} | {work-item-ID or TBD} |

**Implementation (sequential or parallel as noted):**

| # | Scope | Dependencies | Work Item |
|---|---|---|---|
| I1 | {what is built or changed} | {what must be done first} | {work-item-ID or TBD} |

**Template and artifact revisions (if this ADR changes templates or standards):**

| Artifact | Change needed | Work Item |
|---|---|---|
| {templates/X.md or starters/X.md} | {specific change} | {work-item-ID or TBD} |

**Cross-repo propagation (ESE §2.1 DOCUMENT: all documentation updated before work item closes):**

When this ADR introduces or changes a component, verify the following artifacts are updated
in the same work period. Each row is either checked off or marked N/A. An unchecked row
that is not N/A blocks ADR closure.

| Artifact | What to update | Status |
|---|---|---|
| Architecture doc | `docs/architecture/{component-name}.md` per ESE §3.3 (new component) or update existing | [ ] done / [x] N/A: {reason} |
| System map / overview | Reference to new component in project system map or README | [ ] done / [x] N/A: {reason} |
| Runbook | Operational procedures updated if this ADR changes how a service is started, stopped, or monitored | [ ] done / [x] N/A: {reason} |
| Downstream config | Any agent context files, session guides, or operator docs that reference the component by name | [ ] done / [x] N/A: {reason} |
