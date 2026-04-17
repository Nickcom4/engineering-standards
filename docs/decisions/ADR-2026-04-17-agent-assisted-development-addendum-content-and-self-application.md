---
type: adr
id: ADR-2026-04-17-agent-assisted-development-addendum-content-and-self-application
title: "Agent-assisted-development addendum content and self-application"
status: Accepted
date: 2026-04-17
deciders: "Nick Baker"
stage:
  - design
applies-to: all
implements:
  - REQ-4.2-01
  - REQ-2.1-03
dfmea: ~
pfmea: ~
architecture-doc: ~
---

# ADR-2026-04-17: Agent-assisted-development addendum content and self-application

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

[ADR-2026-04-16-agent-assisted-development-addenda-slot.md](ADR-2026-04-16-agent-assisted-development-addenda-slot.md) advertised an `agent-assisted-development` slot in the starter applicability schema and deferred two things into a follow-on work: the addendum content file itself (`docs/addenda/agent-assisted-development.md`) and ESE's self-application of the addendum to its own `docs/standards-application.md`. That ADR also recorded a deliberate, known-divergent state between the internal and starter versions of `lint-standards-application-frontmatter.sh`: the starter gained the new addendum key, the internal did not, so ESE's own applicability document was not forced to declare the field before the content file existed.

The addendum content file now lands. With it, the sequencing constraint from the earlier ADR is satisfied: the cross-check between adopter applicability and `docs/addenda/` has an authoritative target, and ESE itself can honestly declare the posture it has operated under since the plugin ecosystem emerged. The deferred items become executable in the same release:

- Ship the content file with 10 REQ-ADD-AAD-NN requirements spanning posture declaration, commit-authority boundary, human gate, approval boundary, sandbox posture, audit trail, credential handling, revocation path, configuration-file integrity, and external-tool register.
- Flip ESE's self-application (`docs/standards-application.md`) to declare `agent-assisted-development: true` in YAML and mirror the claim in the Applicable Addenda prose table.
- Reconverge the internal `scripts/lint-standards-application-frontmatter.sh` with the starter `starters/linters/lint-standards-application-frontmatter.sh` on the three maintained maps (`REQUIRED_ADDENDA`, `ADDENDUM_LABEL_TO_KEY`, `ADDENDUM_TO_TOKEN` with token `AAD`).

Constraints:

- The content file's REQ-IDs become live obligations on any adopter who declares the addendum `true`. Scope must be wide enough to cover the observed failure classes (posture drift, protected-branch reach, unreviewed configuration changes, credential persistence) and narrow enough to be actionable without prescribing a specific harness.
- ESE's own posture is the canonical first adopter signal. If ESE cannot honestly declare the addendum `true` against its own operating model, the addendum's authority is rhetorical.
- The linter reconvergence is the forcing function that makes self-application visible in the schema: once both linters validate the same map, the internal applicability document is required to declare the field or fail at commit time.

Cost of inaction: adopter repositories maintained with AI coding agent assistance continue to accumulate undeclared posture. The slot would exist without a target to validate against; the authoring project would continue to assert influence over a class of failure it had not acknowledged in its own applicability document.

**Supersedes:** N/A. Partially closes deferred Implementation Checklist items from ADR-2026-04-16-agent-assisted-development-addenda-slot.md (specifically the addendum content file row and the revisit-when-content-lands rows for `scripts/lint-standards-application-frontmatter.sh` and `docs/standards-application.md`).

---

## Decision

> [§4.2](../STANDARDS.md#42-adr-format): be specific and unambiguous. Not "we will consider X" - "we are doing X."

Ship `docs/addenda/agent-assisted-development.md` with 10 REQ-ADD-AAD-NN requirements. The requirements are:

1. REQ-ADD-AAD-01 (artifact, define): posture declaration in the project's standards-application document, naming harness, commit authority, sandbox posture, configuration audit path, and external-tool register path.
2. REQ-ADD-AAD-02 (gate, define): commit-authority branch scope and protected-branch gating condition.
3. REQ-ADD-AAD-03 (gate, verify): human gate-authority review or equivalent CI gate before any agent-initiated commit reaches a protected branch.
4. REQ-ADD-AAD-04 (artifact, design): approval boundary declared explicitly (file-type allowlist, blocklist, command categories, wildcard rationale).
5. REQ-ADD-AAD-05 (artifact, design): sandbox / isolation level declared from the named enum.
6. REQ-ADD-AAD-06 (gate, build): agent-initiated commits distinguishable from human-initiated commits via a durable convention.
7. REQ-ADD-AAD-07 (artifact, monitor): credentials are session-scoped by default; long-lived credentials require stated rationale.
8. REQ-ADD-AAD-08 (artifact, monitor): revocation path documented and achievable within one business day.
9. REQ-ADD-AAD-09 (gate, build): agent configuration files are version-controlled and treated as normative artifacts.
10. REQ-ADD-AAD-10 (artifact, define): MCP and external-tool register enumerating every tool the harness may load.

Add the Addenda summary row in `STANDARDS.md` linking to the new file.

ESE's `docs/standards-application.md` declares `addenda.agent-assisted-development: true` in YAML and `Yes` in the Applicable Addenda prose table, with a compliance note naming CLAUDE.md and AGENTS.md as the posture-declaration files, naming the commit-authority scope (feature branches with gate-authority review required before protected-branch merge), and naming the sandbox posture (devcontainer-equivalent; session-scoped; no persistent credentials).

`scripts/lint-standards-application-frontmatter.sh` extends its three maintained maps to include `agent-assisted-development` / `Agent-Assisted Development` / `AAD`, matching the starter linter's already-landed state. Formatting between the two linters is retained (the starter is parameterized via env vars; the internal uses hardcoded repo paths). The addenda-map contents are identical.

The REQ-ID count moves from 741 to 751; the gate count moves from 313 to 317. `req-manifest.sha256`, `enforcement-spec.yml`, and `docs/requirement-index.md` are regenerated to register the new IDs.

---

## Consequences

> [§4.2](../STANDARDS.md#42-adr-format): state both positive and negative trade-offs. An ADR with no negative consequences was not thought through.

### Positive

- Adopters declaring `agent-assisted-development: true` now pass `lint-template-compliance.sh` because the addendum file exists. The forcing function from the Session C ADR is satisfied by content, not by deferral.
- ESE's self-application signal becomes authentic: the authoring project declares the posture it actually operates under, rather than advertising an addendum it does not apply to itself.
- The internal-vs-starter linter divergence closes; a future Dependabot bump of the submodule downstream will not surface schema mismatches at the starter layer.
- The 10 REQ-ADD-AAD-NN requirements cover the failure classes the card identified (protected-branch reach, posture drift, unreviewed configuration escalation, credential persistence, external-tool surface drift) without prescribing a specific harness or implementation.

### Negative

- Downstream repositories (ese-starter, ese-plugin) that vendored the starter linter under the `false` default may need to flip to `true` in their own applicability documents once their submodule bump brings in this content. The linter will surface the required declaration at commit time in those repos; propagation is a follow-on session, not part of this ADR.
- The requirements inventory commits ESE to a specific vocabulary (sandbox posture enum values, register row shape, revocation one-business-day ceiling). Adopters whose posture does not fit the enum values exactly will need project-specific adapters or ADR-recorded deviations.
- The reserved token `AAD` from the Session C ADR is now in active use; any future rename is a breaking change for every adopter repository vendoring the linter, not just a starter-file cosmetic change.

---

## Alternatives Considered

<a name="REQ-TPL-04"></a>
**REQ-TPL-04** `advisory` `continuous` `soft` `all`
§4.2: every rejected alternative must have a documented rejection rationale. This prevents re-evaluating the same option later.

> [§4.2](../STANDARDS.md#42-adr-format): every rejected alternative must have a documented rejection rationale. This prevents re-evaluating the same option later.

### Alternative 1: Ship the addendum content but defer ESE's self-application

Rejected. ESE is its own first adopter by construction; every decision in the standard is validated against ESE's own operational posture before it is asked of any external repository. Shipping the addendum content without self-applying it would create a two-tier standard: "this applies to adopters" and "this does not yet apply to us." That split weakens the authority of every future addendum added to ESE and invites adopters to treat addenda as aspirational rather than normative. The content and the self-application ship together because ESE cannot be its own first adopter across a gap.

### Alternative 2: Wait for external-adopter feedback before self-applying

Rejected. External adopters cannot credibly be asked to declare posture for an addendum whose authoring project has not declared the same posture for itself. ESE is the only corpus the project can study in depth today; waiting for external feedback before self-applying is waiting on a signal ESE itself is blocking. The self-application is additive (flipping `false` to `true` and populating compliance notes); if external adopter experience later surfaces a refinement, the refinement is a separate ADR extending or amending this one, not a pre-requisite for acting.

### Alternative 3: Subsume the addendum content under the existing AI and ML Systems addendum

Rejected (reaffirmed from the Session C ADR). AI and ML Systems covers AI as a consumed technology in the shipped application: model behavior, evaluation harness, probabilistic output discipline, bias evaluation, explainability, retirement. Agent-assisted development covers AI as a development collaborator that holds commit authority in the repository itself: harness configuration, approval boundary, sandbox posture, commit-authority scope. A project ships a ChatGPT-backed feature but has no AI coding agent (AI and ML Systems yes, Agent-Assisted no). A project is maintained by Claude Code but ships a CRUD API with no ML (Agent-Assisted yes, AI and ML no). Conflating them forces every AI-maintained repository to inherit requirements (model versioning, bias) that do not apply, and every ML application to inherit requirements (harness configuration, commit-authority scoping) that do not apply. Two distinct concerns, two distinct addenda.

### Alternative 4: Ship fewer REQs and let the addendum grow organically

Rejected. The 10 REQs map directly to the failure classes identified in `ese-plugin/docs/research/ecc-comparison-2026-04-16.md` opportunity A1 and its Session K posture-fields resolution (harness-in-use, agents-have-commit-authority, sandbox-posture, configuration-audit-path, MCP-evaluation-register-path), plus four coverage requirements the card named explicitly (approval boundary, audit trail, credential handling, revocation). A smaller set would leave named failure classes without an enforcement surface; a larger set would pad without corresponding observed need. Ten is the count that covers every named failure class with exactly one REQ per cluster.

---

## Validation

<a name="REQ-TPL-05"></a>
**REQ-TPL-05** `advisory` `continuous` `soft` `all`
§4.2: what observable signal confirms this decision was correct, and what triggers the assessment? Criteria must be binary (true or false, not a ju...

> [§4.2](../STANDARDS.md#42-adr-format): what observable signal confirms this decision was correct, and what triggers the assessment? Criteria must be binary (true or false, not a judgment call) and outcome-triggered (an event, not a calendar window). See §4.2 for the full requirement.

**Pass condition:** (a) a new external adopter who flips `addenda.agent-assisted-development: true` in their own standards-application document passes `lint-standards-application-frontmatter.sh` and `lint-template-compliance.sh` without modifying either; (b) ESE's own `bash scripts/preflight.sh` passes on a tree that contains both the content file and the self-applied posture row; (c) the internal and starter linter `REQUIRED_ADDENDA`, `ADDENDUM_LABEL_TO_KEY`, and `ADDENDUM_TO_TOKEN` maps contain the same keys in the same order.

**Trigger:** the first external repository that vendors the updated starter linter and flips the addendum to `true` against its own applicability document. At that point the decision is assessed against the adopter's outcome.

**Failure condition:** an adopter reports that one or more of the 10 REQ-ADD-AAD-NN requirements is ambiguous enough that their posture cannot be honestly mapped to a pass/fail; or an adopter reports a posture that cannot be expressed in the declared enum values without a project-specific ADR; or ESE's own posture drifts from the declared values (for example, ESE adopts a new harness without updating its self-applied compliance note).

---

## Per-Document Impact Analysis <!-- optional -->

> Required by [REQ-4.2-10](../STANDARDS.md#req-4210) for ADRs modifying an existing component, API, interface, or standard. List every document affected by this decision. Documents confirmed unchanged must be listed explicitly. Optional in the template-compliance linter: only ADRs that modify an existing component, API, interface, or standard need to include this section. ADRs introducing genuinely new decisions with no existing artifacts to modify may omit it.

| Document | Change required | Notes |
|---|---|---|
| `docs/addenda/agent-assisted-development.md` | Yes: new file with 10 REQ-ADD-AAD-NN requirements across ten clusters | Landed in commit 1 of Session K |
| `STANDARDS.md` | Yes: Addenda summary row added | Landed in commit 1 of Session K |
| `docs/standards-application.md` | Yes: YAML and prose flipped to `true` / `Yes` with compliance note | Landed in commit 2 of Session K |
| `scripts/lint-standards-application-frontmatter.sh` | Yes: three maintained maps extended to match starter linter | Landed in commit 2 of Session K |
| `req-manifest.sha256`, `enforcement-spec.yml`, `docs/requirement-index.md` | Yes: regenerated to register 10 new REQ-ADD-AAD-NN IDs | Landed in commit 1 of Session K |
| `CLAUDE.md` | Yes: REQ-ID count and gate count references updated from 741/313 to 751/317 | Landed in commit 1 of Session K |
| `docs/architecture/ese-machine-readable-enforcement-system.md` | Yes: count references updated | Landed in commit 1 of Session K |
| `starters/standards-application.md` | No: the addendum slot and prose row were already added in v2.9.0 | Session C ADR |
| `starters/linters/lint-standards-application-frontmatter.sh` | No: the three maps already carried `agent-assisted-development` / `AAD` since v2.9.0 | Session C ADR |
| `docs/decisions/ADR-2026-04-16-agent-assisted-development-addenda-slot.md` | No: status remains Accepted; the deferred Implementation Checklist rows for the content file and the revisit-when-content-lands linter/applicability rows are closed by this ADR | Reference-only cross-link |

---

## Follow-on Requirements <!-- optional -->

> If this decision introduces or modifies a component touching authentication, payments, data mutation, or external integrations, complete a FMEA per [§2.1 DESIGN](../STANDARDS.md#21-the-lifecycle) before BUILD begins. Optional in the template-compliance linter: only ADRs that introduce qualifying follow-on obligations (FMEA, new REQ-IDs, etc.) need this section. Process-only ADRs that trigger no downstream artifacts may omit it.

<a name="REQ-TPL-06"></a>
**REQ-TPL-06** `advisory` `continuous` `soft` `all`
FMEA required: {yes / no}.

**FMEA required:** no. This ADR extends a declarative schema with an addendum content file and flips an applicability flag. The 10 new REQ-ADD-AAD-NN requirements themselves are authored to apply FMEA-style thinking to adopter postures (blast radius, single point of failure in the revocation path, credential-persistence residual surface); they do not introduce new authentication, payments, data mutation, or external integration components in this repository.

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
| T1 | `bash scripts/preflight.sh` exits zero on a clean tree before Session K's first commit | Validation pass condition (b) | Baseline green before commit 1 | ese-plugin Session K prompt |

**Implementation (sequential or parallel as noted):**

| # | Scope | Dependencies | Work Item |
|---|---|---|---|
| I1 | Addendum content file, STANDARDS.md Addenda row, manifest regeneration, count updates | T1 green | Session K commit 1 (SHA 40267f4) |
| I2 | `docs/standards-application.md` YAML and prose flip; internal linter map reconvergence | I1 committed | Session K commit 2 (SHA 7528dd9) |
| I3 | This ADR file | I2 committed | Session K commit 3 (this commit) |

**Template and artifact revisions (if this ADR changes templates or standards):**

| Artifact | Change needed | Work Item |
|---|---|---|
| `STANDARDS.md` Addenda section | Add summary row for Agent-Assisted Development | Session K commit 1 |
| `docs/addenda/agent-assisted-development.md` | New content file with 10 REQ-ADD-AAD-NN requirements | Session K commit 1 |

**Cross-repo propagation (ESE §2.1 DOCUMENT: all documentation updated before work item closes):**

When this ADR introduces or changes a component, verify the following artifacts are updated
in the same work period. Each row is either checked off or marked N/A. An unchecked row
that is not N/A blocks ADR closure.

| Artifact | What to update | Status |
|---|---|---|
| Architecture doc | `docs/architecture/{component-name}.md` per ESE §3.3 (new component) or update existing | [x] N/A: no new component; addendum file and applicability schema, not a runtime or build-time component |
| System map / overview | Reference to new component in project system map or README | [x] N/A: no new component |
| Runbook | Operational procedures updated if this ADR changes how a service is started, stopped, or monitored | [x] N/A: no runtime behavior affected |
| Downstream config | Any agent context files, session guides, or operator docs that reference the component by name | [x] N/A: downstream propagation into ese-starter and ese-plugin's own applicability documents is tracked as a follow-on cross-repo session, not an artifact of this ADR |
