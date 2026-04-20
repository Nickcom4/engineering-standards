---
type: adr
id: ADR-2026-04-17-approval-boundary-for-agent-actions
title: "approval boundary for agent actions"
status: Accepted
date: 2026-04-17
deciders: "Nick Baker"
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

# ADR-2026-04-17: approval boundary for agent actions

<a name="REQ-TPL-03"></a>
**REQ-TPL-03** `advisory` `continuous` `soft` `all`
Architectural Decision Record. Required by §4.2 for any change that introduces a new component, replaces an existing approach, adds an external dep...

> Architectural Decision Record. Required by [§4.2](../../STANDARDS.md#42-adr-format) for any change that introduces a new component, replaces an existing approach, adds an external dependency, or alters how services communicate. Also required at [§2.1 DESIGN step](../../STANDARDS.md#21-the-lifecycle) and for all technology adoption decisions per [§9.1](../../STANDARDS.md#91-evaluation-framework).
>
> The YAML frontmatter above is required by the CI gate (`.github/workflows/ci.yml` Check 2). The five CI-required fields are: `type`, `id`, `title`, `status`, `date`. The `deciders` field is recommended but not enforced by CI. Status values: `Proposed` | `Accepted` | `Superseded by ADR-{n}`.

---

## Context

> [§4.2](../../STANDARDS.md#42-adr-format): describe the problem, constraints, and cost of doing nothing.
>
> If this decision replaces an existing approach: update the superseded ADR's status field to `Superseded by ADR-{this number}` and link it here.

The agent-assisted-development addendum names an approval boundary requirement at [REQ-ADD-AAD-04](../addenda/agent-assisted-development.md#req-add-aad-04) without specifying how adopters declare the boundary or what the floor must be. Adopters have responded by documenting ad-hoc approval rules in hooks, settings files, or unstated convention; the lack of a named floor means an adopter claiming addendum compliance can ship an agent whose approval boundary is "the gate authority reviews nothing" and still pass the posture check in principle.

The cost of doing nothing is that the agent-assisted-development addendum's posture requirement is non-binding in the direction that matters. A reviewer of an adopter posture today cannot answer "what is the minimum approval boundary this posture must meet" from the addendum alone.

**Supersedes:** N/A

---

## Decision

> [§4.2](../../STANDARDS.md#42-adr-format): be specific and unambiguous. Not "we will consider X" - "we are doing X."

The approval boundary for agent actions is declarable per adopter in the posture declaration required by [REQ-ADD-AAD-01](../addenda/agent-assisted-development.md#req-add-aad-01), and the declaration must meet a named floor:

**Minimum approval boundary floor (non-negotiable):** no deletion of tracked files, no destructive git operations (force-push, reset --hard, branch delete on protected branches, tag delete, amending a published commit), and no operations that write outside the current project's working tree without explicit gate-authority prompt on each invocation. An adopter posture may set a stricter boundary (for example, any write operation prompts) but may not go below this floor.

**Per-adopter extensions:** the posture declaration names which of the following additional classes the adopter requires per-invocation prompting for, with rationale: shell execution, network egress to unapproved hosts, credential reads, writes outside the working tree even when non-destructive, package installation, CI or deployment triggers.

**Enforcement layer:** the declaration also names where the enforcement lives: in the agent harness's hook layer, in the shell allowlist, in the sandbox posture (REQ-ADD-AAD-15 through REQ-ADD-AAD-17), or by a combination. A declaration that does not name an enforcement layer is invalid.

**Scope:** this decision governs the AAD addendum's REQ-ADD-AAD-04 floor only. Agents that do not operate under this addendum are not subject to this ADR.

---

## Consequences

> [§4.2](../../STANDARDS.md#42-adr-format): state both positive and negative trade-offs. An ADR with no negative consequences was not thought through.

### Positive

- A reviewer reading an adopter posture can confirm the minimum floor is met from a single rule set.
- Adopters get clear guidance on what "approval boundary" means operationally without inventing their own definitions.
- The floor is concrete enough to support future linter enforcement (an adopter posture naming the four minimum classes can be detected programmatically; a future shadow linter can surface postures that fail to name them).
- Leaves the per-adopter extension space open for stricter postures without bloating the base requirement.

### Negative

- The floor is opinionated and will need updates as agent action surfaces evolve (e.g., if MCPs introduce a new operation class). Every floor update is a minor-version ADR event.
- Adopters with pre-existing postures may have to add explicit declarations for classes they had been handling implicitly. Upgrade cost is real but limited; the declaration is prose, not configuration.
- The ADR narrows adopter choice in one direction: an adopter that wants a posture below the named floor cannot declare compliance with the addendum without breaking the posture contract. This is the intended trade-off; a compliance claim that can mean nothing is worse than a claim that names a floor.

---

## Alternatives Considered

<a name="REQ-TPL-04"></a>
**REQ-TPL-04** `advisory` `continuous` `soft` `all`
§4.2: every rejected alternative must have a documented rejection rationale. This prevents re-evaluating the same option later.

> [§4.2](../../STANDARDS.md#42-adr-format): every rejected alternative must have a documented rejection rationale. This prevents re-evaluating the same option later.

### Unbounded agent authority (adopter decides everything, no floor)

Rejected. This is the status quo that produced the original REQ-ADD-AAD-04 gap. Without a named floor, compliance with the approval-boundary requirement is a claim the adopter makes against their own discretion; review cannot distinguish a diligent adopter from an absent one. The addendum's purpose is to make the posture reviewable, which a floor-free rule cannot do.

### Per-action prompt for everything (maximum strict; no per-adopter variation)

Rejected. Prompting on every action defeats the agent's usefulness; adopters hit "approve everything" fatigue and start clicking through prompts without reading them, which is operationally equivalent to no approval boundary at all. The floor-with-extensions shape preserves reviewability without requiring unusable strictness.

### Tiered boundaries by repo criticality (tier 1 / tier 2 / tier 3 with distinct floors)

Rejected. Tiering introduces classification overhead and category disputes that do not produce proportional value; the floor named in the accepted decision is stringent enough to protect the common case, and adopters with genuinely critical repos can declare a stricter posture as a per-adopter extension. The tier mechanism multiplies the rule surface without reducing the number of bad postures.

### ESE-level enforcement of specific hook configurations (prescribe Claude Code settings.json contents)

Rejected. ESE does not prescribe a specific runtime or harness; the addendum names posture shape, not implementation. Prescribing Claude-Code-specific configuration couples the standard to a runtime, which violates the ESE §3.3 runtime-portability principle.

---

## Validation

<a name="REQ-TPL-05"></a>
**REQ-TPL-05** `advisory` `continuous` `soft` `all`
§4.2: what observable signal confirms this decision was correct, and what triggers the assessment? Criteria must be binary (true or false, not a ju...

> [§4.2](../../STANDARDS.md#42-adr-format): what observable signal confirms this decision was correct, and what triggers the assessment? Criteria must be binary (true or false, not a judgment call) and outcome-triggered (an event, not a calendar window). See §4.2 for the full requirement.

**Pass condition:** the next adopter posture declaration landed against the v2.12.0 or later agent-assisted-development addendum names each of the four minimum-floor classes (tracked-file deletion, destructive git, out-of-working-tree writes, gate-authority-prompt mechanism) and an enforcement layer. Reviewable from the posture file alone.

**Trigger:** the first adopter posture declaration that is created or updated after v2.12.0 lands.

**Failure condition:** the next such posture declaration omits the floor or declares a boundary below it. Failure signals that the ADR's floor is not actionable without tighter guidance or a linter; revisit to reshape the decision or add enforcement.

---

## Per-Document Impact Analysis <!-- optional -->

> Required by [REQ-4.2-10](../../STANDARDS.md#req-4210) for ADRs modifying an existing component, API, interface, or standard. List every document affected by this decision. Documents confirmed unchanged must be listed explicitly. Optional in the template-compliance linter: only ADRs that modify an existing component, API, interface, or standard need to include this section. ADRs introducing genuinely new decisions with no existing artifacts to modify may omit it.

| Document | Change required | Notes |
|---|---|---|
| {path/to/doc.md} | {Yes: description of change / No: confirmed no change required} | |

---

## Follow-on Requirements <!-- optional -->

> If this decision introduces or modifies a component touching authentication, payments, data mutation, or external integrations, complete a FMEA per [§2.1 DESIGN](../../STANDARDS.md#21-the-lifecycle) before BUILD begins. Optional in the template-compliance linter: only ADRs that introduce qualifying follow-on obligations (FMEA, new REQ-IDs, etc.) need this section. Process-only ADRs that trigger no downstream artifacts may omit it.

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
