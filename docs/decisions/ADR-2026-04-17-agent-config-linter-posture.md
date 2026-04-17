---
type: adr
id: ADR-2026-04-17-agent-config-linter-posture
title: "Agent-config linter posture"
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

# ADR-2026-04-17: Agent-config linter posture

<a name="REQ-TPL-03"></a>
**REQ-TPL-03** `advisory` `continuous` `soft` `all`
Architectural Decision Record. Required by §4.2 for any change that introduces a new component, replaces an existing approach, adds an external dep...

> Architectural Decision Record. Required by [§4.2](../STANDARDS.md#42-adr-format) for any change that introduces a new component, replaces an existing approach, adds an external dependency, or alters how services communicate. Also required at [§2.1 DESIGN step](../STANDARDS.md#21-the-lifecycle) and for all technology adoption decisions per [§9.1](../STANDARDS.md#91-evaluation-framework).
>
> The YAML frontmatter above is required by the CI gate (`.github/workflows/ci.yml` Check 2). The five CI-required fields are: `type`, `id`, `title`, `status`, `date`. The `deciders` field is recommended but not enforced by CI. Status values: `Proposed` | `Accepted` | `Superseded by ADR-{n}`.

---

## Context

> [§4.2](../STANDARDS.md#42-adr-format): describe the problem, constraints, and cost of doing nothing.

[ADR-2026-04-17-agent-assisted-development-addendum-content-and-self-application.md](ADR-2026-04-17-agent-assisted-development-addendum-content-and-self-application.md) shipped 10 REQ-ADD-AAD-NN requirements governing adopter posture for AI-coding-agent-maintained repositories. Requirements written in prose are necessary but not sufficient: a requirement that cannot be checked automatically will drift silently between adopters, and between an adopter's declared state and its actual state. The `lint-template-compliance.sh` linter already catches cases where `addenda.agent-assisted-development: true` is declared before the addendum content file exists; that is necessary but does not reach the posture-file layer. Once a posture file exists, its contents are no longer checked.

The A2 opportunity card in `ese-plugin/docs/research/ecc-comparison-2026-04-16.md` names the specific shape of drift: an adopter that declares the addendum applicable and whose CLAUDE.md or AGENTS.md is present but silent on one of the required posture statements (commit-authority declaration, gate-authority review pathway, approval boundary, credential handling, revocation path). Zero of ESE's pre-existing `scripts/lint-*.sh` scan `.claude/` or posture files; nothing in the existing linter corpus surfaces a partial posture declaration.

Constraints:

- The linter must not fire when the addendum is not applicable; adopters who declare `agent-assisted-development: false` should see silent-pass. The addendum applicability flag is the opt-in trigger.
- Detection has to start simple enough to land on day one. A model-driven natural-language detector would take ecosystem-scale effort to stand up and would itself need an ADR-ADD-AI-30-style evaluation harness before promotion. Lexical phrase patterns are tractable and can be refined once real-world false positives and false negatives are known.
- Promotion from advisory to blocking requires evidence, not time (per [ADR-2026-04-16-shadow-gate-promotion-policy.md](ADR-2026-04-16-shadow-gate-promotion-policy.md)). A lexical detector has false-positive risk; shipping it as a hard gate on day one would create adopter friction the policy is intended to prevent.

Cost of inaction: the 10 REQ-ADD-AAD-NN requirements remain declarative only. Adopter drift between posture declaration and posture content accumulates with no detection surface. Self-application by ESE itself has no linter forcing function to catch future drift when CLAUDE.md is edited without attention to the addendum's posture requirements.

**Supersedes:** N/A.

---

## Decision

> [§4.2](../STANDARDS.md#42-adr-format): be specific and unambiguous. Not "we will consider X" - "we are doing X."

Ship `starters/linters/lint-agent-config.sh` (parameterized adopter-portable) and `scripts/lint-agent-config.sh` (ESE-internal mirror) as `# status: shadow` per the shadow-gate-promotion-policy ADR. The internal linter is wired as `.github/workflows/ci.yml` Check 38 and auto-discovered by `scripts/preflight.sh`.

Scope: when the project's `standards-application.md` declares `addenda.agent-assisted-development: true`, scan the configured posture files (default: `AGENTS.md`, `CLAUDE.md`, `.cursorrules`, `.agent.md` at repo root) for six required statement classes and report any absent from the corpus:

1. Posture file exists at the project root (REQ-ADD-AAD-01).
2. Agent-authority declaration (REQ-ADD-AAD-02).
3. Gate-authority review pathway (REQ-ADD-AAD-03).
4. Approval-boundary statement (REQ-ADD-AAD-04).
5. Credential-handling statement (REQ-ADD-AAD-07).
6. Revocation-path statement (REQ-ADD-AAD-08).

Detection is lexical: each check has a small phrase-pattern set. False positives (posture declared in unusual wording) and false negatives (phrases present that do not convey the posture statement) are expected in the shadow phase and inform pattern refinement before promotion. Parameterization: `PROJECT_ROOT`, `APPLICATION_FILE`, `POSTURE_FILES` (colon-separated). Silent-pass when the addendum is not applicable or no application file exists.

Promotion from shadow to gate is evidence-based. The trigger is: the first adopter who lands a posture file without one of the six statements AND the linter's shadow finding matches the subsequent incident or review finding. At that point the linter has documented its first true-positive catch and the gate authority decides whether to promote (matching the policy from ADR-2026-04-16-shadow-gate-promotion-policy.md).

---

## Consequences

> [§4.2](../STANDARDS.md#42-adr-format): state both positive and negative trade-offs. An ADR with no negative consequences was not thought through.

### Positive

- The 10 REQ-ADD-AAD-NN requirements now have a detection surface. Drift between posture declaration and posture content is surfaced at commit time for adopters who vendor the linter.
- ESE's own CLAUDE.md gains a linter that watches for the same kind of drift. First-run output against ESE's current state produces two expected shadow findings (credential-handling and revocation-path statements absent from CLAUDE.md prose); these are documented findings, not blockers, and they inform future posture-content additions.
- Shadow-first posture is a one-step-removed risk position: lexical detection lands safely because it cannot block adopter progress until evidence justifies promotion.

### Negative

- Lexical phrase patterns produce false positives when posture is declared in wording not matched by the pattern set. The shadow-phase friction cost is "adopter reads a shadow finding that does not reflect real drift"; the fix is pattern refinement in subsequent releases.
- The linter reaches only the posture-file surface, not the operational configuration (harness settings, MCP registrations, hook allowlists). A full A-card sequence (A3 MCP supply-chain, A5 sandbox/isolation, A6 approval-boundary) extends the reach; those are deferred to later work.
- Two copies of the linter (starter and internal) add maintenance surface. The starter is parameterized; the internal inlines repo-specific defaults; both must be kept in semantic sync. This matches the pattern already established for `lint-standards-application-frontmatter.sh` and `lint-vsm-baseline-reference.sh`.

---

## Alternatives Considered

<a name="REQ-TPL-04"></a>
**REQ-TPL-04** `advisory` `continuous` `soft` `all`
§4.2: every rejected alternative must have a documented rejection rationale. This prevents re-evaluating the same option later.

> [§4.2](../STANDARDS.md#42-adr-format): every rejected alternative must have a documented rejection rationale. This prevents re-evaluating the same option later.

### Alternative 1: Ship the linter as a hard gate from day one

Rejected. Lexical phrase-pattern detection has false-positive risk: an adopter who declares posture in wording the pattern set does not match would be blocked until they either adopted the expected wording or filed a suppression. The shadow-gate-promotion-policy ADR is explicit that gate posture is evidence-promoted; shipping as a gate on day one inverts that discipline. Shadow-first lets ecosystem-wide posture drift accumulate into evidence for or against promotion before the enforcement cost lands.

### Alternative 2: Model-driven natural-language detection (LLM-generated or ML classifier)

Rejected. An LLM or classifier would reduce false-negative risk but would require an evaluation harness per the REQ-ADD-AI-30..-35 LLM-generated-rule discipline: F1 thresholds set before evaluation, two independent labeled runs, both at F1 >= 0.85 before promotion. Standing that up for a linter that does not yet have a labeled sample set is not the right sequence. A simpler lexical detector runs today, generates the labeled samples (true positives and false positives in its shadow output), and makes a model-driven detector a rational future step once the data exists.

### Alternative 3: Skip the linter and rely on reviewer vigilance

Rejected. Reviewer vigilance is the posture this ADR exists to retire. The 10 REQ-ADD-AAD-NN requirements already ask for posture declarations; a review discipline that catches missing declarations reliably would make the linter redundant, but the observed drift across the adopter ecosystem (zero of ESE's pre-existing linters touch posture files) is the evidence that reviewer vigilance is not catching this class on its own. A linter running in CI is a fixed cost; reviewer vigilance on every PR is not.

### Alternative 4: Ship only the starter linter; skip the ESE-internal mirror

Rejected. ESE self-applies the agent-assisted-development addendum in the companion decision. A project that declares the addendum applicable and does not run the linter against its own posture files is not practicing what it ships. The internal mirror is the forcing function that catches drift in ESE's own CLAUDE.md and AGENTS.md before adopters inherit the drift through the submodule bump.

---

## Validation

<a name="REQ-TPL-05"></a>
**REQ-TPL-05** `advisory` `continuous` `soft` `all`
§4.2: what observable signal confirms this decision was correct, and what triggers the assessment? Criteria must be binary (true or false, not a ju...

> [§4.2](../STANDARDS.md#42-adr-format): what observable signal confirms this decision was correct, and what triggers the assessment? Criteria must be binary (true or false, not a judgment call) and outcome-triggered (an event, not a calendar window). See §4.2 for the full requirement.

**Pass condition:** both the starter and internal linters pass `bash scripts/preflight.sh` on the engineering-standards tree on commit day; `.github/workflows/ci.yml` registers the new check at slot 38; the internal linter surfaces at least the two expected shadow findings against ESE's current CLAUDE.md (credential-handling and revocation-path) without blocking the build; the starter linter silent-passes when run against a project whose `standards-application.md` declares the addendum `false`.

**Trigger:** the first adopter posture incident in which one of the six statement classes is absent from their posture file AND (a) the linter shadow output identified it, or (b) the linter missed it (true-positive catch or false-negative miss). At that point the decision is assessed against the outcome and either promoted to gate (per the shadow-gate-promotion policy) or held in shadow while detection patterns are refined.

**Failure condition:** the linter's shadow output contains more false positives than true positives after a first observed window of ecosystem use (evidence of over-matching), OR the lexical phrase patterns miss a posture incident that an adopter post-hoc identifies as "should have been caught" (evidence of under-matching), OR the linter surfaces drift in ESE's own posture without ESE acting on it (evidence of linter-as-decoration posture).

---

## Per-Document Impact Analysis <!-- optional -->

> Required by [REQ-4.2-10](../STANDARDS.md#req-4210) for ADRs modifying an existing component, API, interface, or standard. List every document affected by this decision. Documents confirmed unchanged must be listed explicitly. Optional in the template-compliance linter: only ADRs that modify an existing component, API, interface, or standard need to include this section. ADRs introducing genuinely new decisions with no existing artifacts to modify may omit it.

| Document | Change required | Notes |
|---|---|---|
| `starters/linters/lint-agent-config.sh` | Yes: new parameterized starter-pack linter | Landed in Session K commit 5 (SHA 19d680d) |
| `scripts/lint-agent-config.sh` | Yes: new internal mirror | Landed in Session K commit 5 |
| `.github/workflows/ci.yml` | Yes: Check 38 added; summary line extended | Landed in Session K commit 5 |
| `CLAUDE.md` | Yes: CI count 37 to 38; Before Every Commit suite extended | Landed in Session K commit 5 |
| `starters/linters/README.md` | Yes: catalog row added; narrative extends to ten | Landed in Session K commit 5 |
| `docs/decisions/ADR-2026-04-16-shadow-gate-promotion-policy.md` | No: this ADR cites the shadow-gate-promotion policy, does not modify it | Reference-only cross-link |
| `docs/decisions/ADR-2026-04-17-agent-assisted-development-addendum-content-and-self-application.md` | No: companion ADR; this ADR is its detection-surface follow-on | Reference-only cross-link |

---

## Follow-on Requirements <!-- optional -->

> If this decision introduces or modifies a component touching authentication, payments, data mutation, or external integrations, complete a FMEA per [§2.1 DESIGN](../STANDARDS.md#21-the-lifecycle) before BUILD begins. Optional in the template-compliance linter: only ADRs that introduce qualifying follow-on obligations (FMEA, new REQ-IDs, etc.) need this section. Process-only ADRs that trigger no downstream artifacts may omit it.

<a name="REQ-TPL-06"></a>
**REQ-TPL-06** `advisory` `continuous` `soft` `all`
FMEA required: {yes / no}.

**FMEA required:** no. This ADR introduces a shadow linter whose failure modes are bounded by the shadow-first posture: false positives are advisory, false negatives surface as absent-signal rather than corruption, and the blast radius is adopter friction rather than production risk.

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
| T1 | A1 addendum content file in place with 10 REQ-ADD-AAD-NN requirements | Context (prerequisite) | Linter has REQ-IDs to anchor against | Session K commit 1 (SHA 40267f4) |
| T2 | ESE self-applies the addendum | Context (prerequisite) | Internal linter has a posture state to enforce | Session K commit 2 (SHA 7528dd9) |

**Implementation (sequential or parallel as noted):**

| # | Scope | Dependencies | Work Item |
|---|---|---|---|
| I1 | Starter + internal linter, CI wiring, README catalog, CLAUDE.md local suite and count | T1, T2 | Session K commit 5 (SHA 19d680d) |
| I2 | This ADR | I1 | Session K commit 7a (this commit) |

**Template and artifact revisions (if this ADR changes templates or standards):**

| Artifact | Change needed | Work Item |
|---|---|---|
| `starters/linters/lint-agent-config.sh` | New parameterized starter | Session K commit 5 |
| `scripts/lint-agent-config.sh` | New internal mirror | Session K commit 5 |

**Cross-repo propagation (ESE §2.1 DOCUMENT: all documentation updated before work item closes):**

When this ADR introduces or changes a component, verify the following artifacts are updated
in the same work period. Each row is either checked off or marked N/A. An unchecked row
that is not N/A blocks ADR closure.

| Artifact | What to update | Status |
|---|---|---|
| Architecture doc | `docs/architecture/{component-name}.md` per ESE §3.3 (new component) or update existing | [x] N/A: linters sit alongside existing linters under the same architectural surface; no new component |
| System map / overview | Reference to new component in project system map or README | [x] done: `starters/linters/README.md` catalog gained a row |
| Runbook | Operational procedures updated if this ADR changes how a service is started, stopped, or monitored | [x] N/A: no runtime behavior affected |
| Downstream config | Any agent context files, session guides, or operator docs that reference the component by name | [x] done: `CLAUDE.md` Before Every Commit suite extended with the new linter |
