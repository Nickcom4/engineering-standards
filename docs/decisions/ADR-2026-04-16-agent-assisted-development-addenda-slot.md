---
type: adr
id: ADR-2026-04-16-agent-assisted-development-addenda-slot
title: "agent-assisted-development addenda slot"
status: Accepted
date: 2026-04-16
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

# ADR-2026-04-16: agent-assisted-development addenda slot

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

The adopter ecosystem increasingly includes repositories maintained with AI coding agents that carry commit authority. These agents operate inside harnesses (hooks, permission configurations, scoped and wildcard allows), produce commits at machine speed, and can trigger classes of failure with a shape the base standard does not currently anticipate (inadvertent destructive operations, chain-bypass attempts, posture drift between harness layers, accidental leakage through agent-writable files).

The base standard has no mechanism for an adopter to declare this posture. The existing AI and ML Systems addendum covers AI as a consumed technology: probabilistic output discipline, autonomy boundaries, hallucination containment, model versioning, data governance, bias evaluation. It does not cover AI as a development collaborator.

Constraints:

- Adopters ought to remain in control of whether their repository declares this posture. A silent default should not imply agent-assisted development where none exists.
- The extension mechanism already exists: the `addenda:` block in `starters/standards-application.md` is the canonical way for adopters to opt in to domain-specific overlays (multi-service, multi-team, web-applications, and others).
- The addendum content file is a non-trivial deliverable. Scoping the slot and the content into the same release would delay both.

Cost of inaction: adopter repositories maintained by AI coding agents accumulate divergent ad hoc conventions for disclosing and controlling that posture. When a class of failure emerges, there is no shared vocabulary or declarative surface for addressing it across the ecosystem. Slot scarcity is itself a signal that the standard has not yet acknowledged the development mode.

**Supersedes:** N/A

---

## Decision

> [§4.2](../STANDARDS.md#42-adr-format): be specific and unambiguous. Not "we will consider X" - "we are doing X."

Add `agent-assisted-development: boolean` to the `addenda:` YAML block in `starters/standards-application.md`, default `false`, positioned immediately before `continuous-improvement`. Add a matching row to the Applicable Addenda prose table in the same starter. Extend the vendored `starters/linters/lint-standards-application-frontmatter.sh` maintained maps (`REQUIRED_ADDENDA`, `ADDENDUM_LABEL_TO_KEY`, `ADDENDUM_TO_TOKEN` with token `AAD`) so the new key is a first-class member of the schema.

The addendum content file itself (`docs/addenda/agent-assisted-development.md`) is not shipped in this decision. It is a separate follow-on deliverable. While the content file is absent, any adopter who sets the flag to `true` is caught by `lint-template-compliance.sh`'s existing cross-check against `docs/addenda/`. That behavior is the forcing function: the slot is advertised; the content follows; no adopter can opt in to a declaration that cannot yet be satisfied.

The internal `scripts/lint-standards-application-frontmatter.sh` is intentionally not extended in the same release. ESE's own `docs/standards-application.md` is therefore not forced to declare the field in this version. The two linters reconverge when the addendum content file lands and ESE's self-application becomes required to declare its posture.

---

## Consequences

> [§4.2](../STANDARDS.md#42-adr-format): state both positive and negative trade-offs. An ADR with no negative consequences was not thought through.

### Positive

- Adopters gain a declarative slot for a posture the base standard did not previously acknowledge.
- The declaration is machine-readable (YAML frontmatter) so future tooling can branch on it without prose parsing.
- The extension uses the existing addenda pattern; no parallel mechanism is introduced.
- The forcing function (`lint-template-compliance.sh` cross-check) prevents adopters from declaring `true` before the addendum content file exists, which preserves the invariant that every active addendum has an authoritative content file.

### Negative

- The slot exists before the addendum content file does. An adopter who encounters the starter field without reading the CHANGELOG may set it to `true` expecting it to activate requirements, then fail the cross-check. The failure message names the missing file, so the diagnostic path is short; the consequence is mild operator surprise rather than data loss.
- The internal `scripts/lint-standards-application-frontmatter.sh` is intentionally not updated in the same release, producing a temporary known-divergent state between the internal and starter linters. The divergence is contained within ESE and resolves when the addendum file lands; the CHANGELOG entry documents it so the next upgrade diff review does not flag it as accidental drift.
- The token reserved for the addendum in `ADDENDUM_TO_TOKEN` is `AAD`. That identifier is now an implicit commitment; any future rename requires a coordinated upgrade across adopter repositories that have vendored the linter.

---

## Alternatives Considered

<a name="REQ-TPL-04"></a>
**REQ-TPL-04** `advisory` `continuous` `soft` `all`
§4.2: every rejected alternative must have a documented rejection rationale. This prevents re-evaluating the same option later.

> [§4.2](../STANDARDS.md#42-adr-format): every rejected alternative must have a documented rejection rationale. This prevents re-evaluating the same option later.

### Alternative 1: Introduce a new top-level block (for example `agent-posture:`) rather than reusing the addenda block

Rejected. The `addenda:` block is the existing canonical extension point for every domain overlay in ESE. Introducing a parallel top-level block would create two inconsistent extension mechanisms for the same shape of decision ("does this domain overlay apply to this project?"). Adopters would then need to learn two schemas, tooling would need to parse both, and the mental model of "addenda are how ESE extends" would be broken. The addenda pattern is already proven across seven domains; extending it by one is strictly additive.

### Alternative 2: Subsume agent-assisted-development under the existing AI and ML Systems addendum

Rejected. The AI and ML Systems addendum covers AI as a consumed technology inside the application (model behavior, evaluation harness, probabilistic output discipline, bias evaluation). Agent-assisted development is a different concern: it covers AI as a development collaborator that holds commit authority in the repository itself. A project can have either, both, or neither; a project that uses an AI coding agent to maintain a CRUD API has agent-assisted-development but not AI and ML Systems, and a project that ships an ML model maintained entirely by humans has AI and ML Systems but not agent-assisted-development. Conflating the two would force every AI-maintained repository to inherit requirements (model versioning, bias evaluation) that do not apply, and every ML application to inherit requirements (harness configuration, commit-authority scoping) that do not apply. Two distinct concerns, two distinct posture fields.

### Alternative 3: Defer the schema change until the addendum content file is ready

Rejected. The addendum content file is a substantial deliverable (requirements inventory, REQ-ID allocation under a new token, validation plan, cross-references to existing addenda). Blocking the schema slot behind it would mean adopters who today want to start declaring the posture have no way to do so. Shipping the slot first is a forward-compatible move: adopters who declare `false` today (the safe default) remain unaffected when the content file lands; adopters who want to declare `true` are held back by the forcing function until the content is authoritative. The order is therefore: slot first, content second; the inverse order would block adopter adoption on ESE's internal backlog.

---

## Validation

<a name="REQ-TPL-05"></a>
**REQ-TPL-05** `advisory` `continuous` `soft` `all`
§4.2: what observable signal confirms this decision was correct, and what triggers the assessment? Criteria must be binary (true or false, not a ju...

> [§4.2](../STANDARDS.md#42-adr-format): what observable signal confirms this decision was correct, and what triggers the assessment? Criteria must be binary (true or false, not a judgment call) and outcome-triggered (an event, not a calendar window). See §4.2 for the full requirement.

**Pass condition:** `bash scripts/preflight.sh` passes in engineering-standards after this ADR and the matching `starters/standards-application.md` and `starters/linters/lint-standards-application-frontmatter.sh` changes are applied; the starter YAML `addenda:` block declares exactly 8 boolean keys including `agent-assisted-development`; the starter Applicable Addenda prose table has one row per YAML boolean; the vendored linter's three maintained maps each contain an `agent-assisted-development` entry.

**Trigger:** the first event that admits a richer assessment, which is whichever comes first of (a) the addendum content file `docs/addenda/agent-assisted-development.md` lands and an adopter declares `true`, or (b) the first external repository vendoring the starter linter reports a schema-validation outcome against the new field. At that point the decision is re-examined against the outcome.

**Failure condition:** an adopter reports that the slot is ambiguous (for example, cannot tell whether their own posture qualifies), or the forcing function misfires (an adopter who legitimately needs to declare `true` is blocked when they should not be), or the slot is conflated with the existing AI and ML Systems declaration in practice, or the token `AAD` collides with a future addendum that is pre-empted.

---

## Per-Document Impact Analysis <!-- optional -->

> Required by [REQ-4.2-10](../STANDARDS.md#req-4210) for ADRs modifying an existing component, API, interface, or standard. List every document affected by this decision. Documents confirmed unchanged must be listed explicitly. Optional in the template-compliance linter: only ADRs that modify an existing component, API, interface, or standard need to include this section. ADRs introducing genuinely new decisions with no existing artifacts to modify may omit it.

| Document | Change required | Notes |
|---|---|---|
| `starters/standards-application.md` | Yes: add `agent-assisted-development: false` to `addenda:` YAML block; add row to Applicable Addenda prose table | Done in the same release (commit 920f505) |
| `starters/linters/lint-standards-application-frontmatter.sh` | Yes: extend `REQUIRED_ADDENDA`, `ADDENDUM_LABEL_TO_KEY` (label `Agent-Assisted Development`), `ADDENDUM_TO_TOKEN` (token `AAD`) | Done in the same release (commit 920f505) |
| `CHANGELOG.md` | Yes: add `[Unreleased]` `### Added` entry describing the schema slot and deferred content file | Done in the same release (commit 920f505) |
| `scripts/lint-standards-application-frontmatter.sh` | No, intentional: internal linter held back so ESE's self-application is not forced to declare the field before the addendum content file exists | Revisits when the content file lands |
| `docs/standards-application.md` | No, intentional: ESE self-application defers declaring the field until the content file lands | Revisits alongside the internal linter |
| `docs/addenda/agent-assisted-development.md` | No in this decision: deliberately out of scope; a separate work item tracks the content deliverable | Forcing function is the `lint-template-compliance.sh` cross-check |
| `STANDARDS.md` | No | This ADR extends the applicability schema shape, not the normative text of the standard |

---

## Follow-on Requirements <!-- optional -->

> If this decision introduces or modifies a component touching authentication, payments, data mutation, or external integrations, complete a FMEA per [§2.1 DESIGN](../STANDARDS.md#21-the-lifecycle) before BUILD begins. Optional in the template-compliance linter: only ADRs that introduce qualifying follow-on obligations (FMEA, new REQ-IDs, etc.) need this section. Process-only ADRs that trigger no downstream artifacts may omit it.

<a name="REQ-TPL-06"></a>
**REQ-TPL-06** `advisory` `continuous` `soft` `all`
FMEA required: {yes / no}.

**FMEA required:** no. This ADR extends a declarative schema slot. It introduces no authentication, payments, data mutation, or external integration component. The blast radius is contained by the existing `lint-template-compliance.sh` cross-check: an adopter who sets the new flag to `true` before the content file lands is caught at commit time, not at runtime.

**FMEA path:** N/A

---

## Implementation Checklist <!-- optional -->

> Maps this ADR's decisions to concrete deliverables. An accepted ADR without an implementation path produces a decision that is never executed. Each row traces to a work item or pre-BUILD control. ADR does not close until every row has a work item reference or is marked N/A. Optional in the template-compliance linter: ADRs whose implementation is trivial or fully described in the Decision section may omit this scaffolding. Required when the ADR introduces new components, scripts, or tracked work items.

<a name="REQ-TPL-07"></a>
**REQ-TPL-07** `advisory` `continuous` `soft` `all`
Pre-BUILD controls (must be passing before implementation begins):.

**Pre-BUILD controls (must be passing before implementation begins):**

| # | Deliverable | Maps to | AC summary | Work Item |
|---|---|---|---|---|
| T1 | `bash scripts/preflight.sh` exits zero on a clean engineering-standards tree | Validation pass-condition | Preflight baseline green before commit 1 | ese-plugin WI-081 |

**Implementation (sequential or parallel as noted):**

| # | Scope | Dependencies | Work Item |
|---|---|---|---|
| I1 | Add `agent-assisted-development: false` to `starters/standards-application.md` addenda YAML and prose table; extend `starters/linters/lint-standards-application-frontmatter.sh` maintained maps; add CHANGELOG `[Unreleased]` entry | Pre-BUILD control T1 green | ese-plugin WI-081, commit 920f505 |
| I2 | File this ADR and link from CHANGELOG entry | I1 committed | ese-plugin WI-081, this commit |

**Template and artifact revisions (if this ADR changes templates or standards):**

| Artifact | Change needed | Work Item |
|---|---|---|
| `starters/standards-application.md` | Add 8th addenda boolean slot and matching prose row | ese-plugin WI-081, commit 920f505 |
| `starters/linters/lint-standards-application-frontmatter.sh` | Extend three maintained maps to accept the new key | ese-plugin WI-081, commit 920f505 |

**Cross-repo propagation (ESE §2.1 DOCUMENT: all documentation updated before work item closes):**

When this ADR introduces or changes a component, verify the following artifacts are updated
in the same work period. Each row is either checked off or marked N/A. An unchecked row
that is not N/A blocks ADR closure.

| Artifact | What to update | Status |
|---|---|---|
| Architecture doc | `docs/architecture/{component-name}.md` per ESE §3.3 (new component) or update existing | [x] N/A: no new component; schema extension only |
| System map / overview | Reference to new component in project system map or README | [x] N/A: no new component |
| Runbook | Operational procedures updated if this ADR changes how a service is started, stopped, or monitored | [x] N/A: no runtime behavior affected |
| Downstream config | Any agent context files, session guides, or operator docs that reference the component by name | [x] N/A: no component name introduced; adopter-facing propagation into ese-starter and ese-plugin's own standards-application.md is tracked as a follow-on session, not an artifact of this ADR |
