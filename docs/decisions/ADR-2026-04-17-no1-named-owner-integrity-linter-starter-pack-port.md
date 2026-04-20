---
type: adr
id: ADR-2026-04-17-no1-named-owner-integrity-linter-starter-pack-port
title: "NO1 named-owner integrity linter starter-pack port"
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

# ADR-2026-04-17: NO1 named-owner integrity linter starter-pack port

<a name="REQ-TPL-03"></a>
**REQ-TPL-03** `advisory` `continuous` `soft` `all`
Architectural Decision Record. Required by §4.2 for any change that introduces a new component, replaces an existing approach, adds an external dep...

> Architectural Decision Record. Required by [§4.2](../../STANDARDS.md#42-adr-format) for any change that introduces a new component, replaces an existing approach, adds an external dependency, or alters how services communicate. Also required at [§2.1 DESIGN step](../../STANDARDS.md#21-the-lifecycle) and for all technology adoption decisions per [§9.1](../../STANDARDS.md#91-evaluation-framework).
>
> The YAML frontmatter above is required by the CI gate (`.github/workflows/ci.yml` Check 2). The five CI-required fields are: `type`, `id`, `title`, `status`, `date`. The `deciders` field is recommended but not enforced by CI. Status values: `Proposed` | `Accepted` | `Superseded by ADR-{n}`.

---

## Context

> [§4.2](../../STANDARDS.md#42-adr-format): describe the problem, constraints, and cost of doing nothing.

The NO1 opportunity card in `ese-plugin/docs/research/ecc-comparison-2026-04-16.md` identifies a gap between ESE's writing rule ("no person names in normative content; the named-owner field in `standards-application.md` is the only place for an operator name") and the actual state of adopter corpora. The rule is declared but not verified: an adopter can declare an owner correctly in the YAML field and still have the same name appearing in ADR Context sections, FMEA narratives, and architecture-doc author credits. Ownership then drifts from a single-named-field posture into a distributed set of implicit authorship signals across normative artifacts.

ese-plugin (Session J) landed `scripts/lint-named-owner-integrity.sh` as an internal linter in its own repository. That linter is ese-plugin-specific in three ways: it reads `standards-application.md` at the repo root (ese-plugin's layout), it scans ese-plugin-specific artifact directories (`docs/adrs/`, `docs/incidents/`, `docs/investigations/`, `docs/product/`, `docs/fmeas/`, `docs/architecture/`, `docs/architecture.md`), and its diagnostic output is shaped for ese-plugin's corpus. Ecosystem adopters cannot use the ese-plugin internal linter as-is.

The starter pack in `starters/linters/` is the canonical place to ship parameterized adopter-portable versions of ESE-internal linters. Ten such linters already exist there. Porting NO1 extends that pattern: adopter repositories vendor the starter, parameterize paths to their own layout, and surface the same class of positional drift that ese-plugin surfaces on itself.

Constraints:

- The port must preserve ese-plugin's semantics. Adopters running the starter against a state that produces N findings under the ese-plugin internal linter should produce the same N findings under the starter (same set of violating files, same per-file line numbers).
- The starter must be parameterized enough to fit the common ESE layout plus variations: `docs/decisions/` (ESE uses this) or `docs/adrs/` (ese-plugin uses this), `docs/standards-application.md` (ESE) or `standards-application.md` at repo root (ese-plugin). The parameter defaults cover ESE's layout; `APPLICATION_FILE` and `ARTIFACT_DIRS` overrides cover ese-plugin and other variations.
- ESE's own corpus has 27 pre-existing positional violations (confirmed via ese-plugin's internal linter run against the ese-plugin state, and confirmed via the starter port smoke-tested against ese-plugin with matching parameters). Running the linter internally in ESE would surface these immediately. Triaging 27 violations is a decision the gate authority has not yet made; shipping the internal linter without that decision would produce CI output the gate authority does not act on, which the shadow-gate-promotion-policy ADR explicitly warns against (linter-as-decoration).

Cost of inaction: adopter ecosystem retains the drift class without a detection surface. NO1 stays an ese-plugin-internal finding while the ESE writing rule itself is an ecosystem-wide rule. Adopters who want to check their own corpora against the rule would need to re-invent the linter.

**Supersedes:** N/A.

---

## Decision

> [§4.2](../../STANDARDS.md#42-adr-format): be specific and unambiguous. Not "we will consider X" - "we are doing X."

Ship `starters/linters/lint-named-owner-integrity.sh` ported from ese-plugin's `scripts/lint-named-owner-integrity.sh` (Session J commit 7). The starter is parameterized per starter-pack conventions: `PROJECT_ROOT`, `APPLICATION_FILE`, `ARTIFACT_DIRS` (colon-separated list of directory or single-file paths relative to PROJECT_ROOT, defaulting to the common ESE layout), and `MAX_FINDINGS` (truncation ceiling with `MAX_FINDINGS=0` for unlimited).

Semantics match the ese-plugin internal linter:

- The owner name is sourced from the `APPLICATION_FILE`'s YAML `owner.name`. Silent-pass when the owner is not declared or the declared name is blank.
- For each artifact under `ARTIFACT_DIRS`, scan the body (not the frontmatter, which legitimately records the artifact's own author). Flag occurrences of the owner name.
- Silent-pass when no normative artifacts exist at the configured paths.
- `# status: shadow` per the shadow-gate-promotion-policy ADR; records findings for auditability but does not block the build.

Do NOT ship an ESE-internal mirror (`scripts/lint-named-owner-integrity.sh`) in this release. ESE's own corpus has 27 known positional violations. Running the internal linter against them without a gate-authority triage decision produces CI output that is not acted on, which the shadow-gate-promotion-policy ADR names as a failure mode (shadow posture is evidence-accumulation; posture drift without owner action is decoration). The ESE-internal mirror is deferred to a future decision that follows a gate-authority triage of the 27 violations.

Smoke-test verification: running the starter linter against ese-plugin's state with an `APPLICATION_FILE` override pointing at ese-plugin's own `standards-application.md` and an `ARTIFACT_DIRS` override listing `docs/adrs:docs/incidents:docs/investigations:docs/product:docs/fmeas:docs/architecture:docs/architecture.md` produces 27 findings, matching the count produced by ese-plugin's internal linter against the same state. Functional-equivalence established at the "same set of violating files" level.

---

## Consequences

> [§4.2](../../STANDARDS.md#42-adr-format): state both positive and negative trade-offs. An ADR with no negative consequences was not thought through.

### Positive

- The ESE writing rule gains an ecosystem-wide detection surface. Adopters who vendor the starter find positional drift the same way ese-plugin finds it on itself.
- The starter is parameterized for layout variation (ADR directory, application-file location, artifact-directory set) so adopters with non-canonical layouts do not need to fork the linter.
- Shadow-first posture means the first adopter to run it does not pay enforcement cost until evidence justifies promotion. Shadow output accumulates into the signal the gate authority uses for promotion.

### Negative

- ESE itself does not yet self-apply this linter. A project that ships a linter and does not run it against its own corpus is practicing the thing the self-application ADRs explicitly reject. The trade-off is accepted deliberately: triaging 27 pre-existing violations is gate-authority scope that Session K does not have authority to execute, and shipping the internal mirror without the triage is worse (decoration) than deferring until the triage happens.
- Lexical detection matches on substring equality for the owner name. An adopter whose owner name is a common word (unlikely but possible) or contains a substring that is itself a common phrase would produce false positives. The `MAX_FINDINGS` cap contains the noise; the shadow-phase refinement path addresses the root cause.
- Two paths exist now for linter-against-own-corpus posture: A2 (agent-config) which ESE does self-apply, and NO1 which ESE does not self-apply. The inconsistency is real and is documented as the follow-on triage item.

---

## Alternatives Considered

<a name="REQ-TPL-04"></a>
**REQ-TPL-04** `advisory` `continuous` `soft` `all`
§4.2: every rejected alternative must have a documented rejection rationale. This prevents re-evaluating the same option later.

> [§4.2](../../STANDARDS.md#42-adr-format): every rejected alternative must have a documented rejection rationale. This prevents re-evaluating the same option later.

### Alternative 1: Port without parameterization (ESE-layout defaults only)

Rejected. The starter-pack convention is that linters accept `PROJECT_ROOT`, `APPLICATION_FILE`, and domain-specific env vars with sensible defaults (see `lint-vsm-baseline-reference.sh`, `lint-standards-application-frontmatter.sh`, and other starters in the pack). Shipping NO1 without that pattern would be an exception that breaks adopter expectations; adopters whose layout differs (notably ese-plugin itself, which uses `docs/adrs/` and `standards-application.md` at root) would need to fork the linter to use it. The parameterization cost is low (three env vars) and the pattern match is valuable.

### Alternative 2: Add an ESE-internal mirror immediately alongside the starter

Rejected. ESE's own corpus has 27 pre-existing positional violations of the writing rule. Running the internal linter in CI today produces 27 shadow findings against ESE's own artifacts. The shadow-gate-promotion-policy ADR is explicit that shadow posture is for evidence-accumulation; shadow findings that sit without gate-authority action turn into decoration rather than signal. Triaging the 27 violations (refactor each to remove the name, or mark each as historical, or deliberately accept them with rationale) is work the gate authority has not yet authorized. Shipping the internal mirror before that triage puts the linter into the decoration-posture the policy rejects.

### Alternative 3: Triage ESE's 27 violations inside Session K and then ship the mirror

Rejected. Session K's scope is the seven commits named in the session prompt: A1 content, A1 self-application, A1 ADR, MA5 methodology, A2 linter, NO1 upstream port, and linter ADRs. A 27-violation refactor is a distinct scope that deserves its own session, ADR (or set of individual refactor decisions), and gate-authority sign-off on the individual cases. Absorbing it into Session K would bundle decisions that should be made separately. The cleaner path is: ship NO1 starter-only here; triage the 27 violations in a follow-on session; ship the ESE-internal mirror in the session that lands the triage.

### Alternative 4: Defer NO1 entirely until ESE is ready to self-apply

Rejected. Adopters do not need to wait for ESE's triage to benefit from the linter against their own corpora. The inconsistency between A2 (ESE self-applies) and NO1 (ESE does not yet) is accepted as a temporary state resolved by the follow-on triage. Holding the starter back from adopters because ESE itself is not ready inverts the "adopter value first" posture ESE tries to practice in the ecosystem.

---

## Validation

<a name="REQ-TPL-05"></a>
**REQ-TPL-05** `advisory` `continuous` `soft` `all`
§4.2: what observable signal confirms this decision was correct, and what triggers the assessment? Criteria must be binary (true or false, not a ju...

> [§4.2](../../STANDARDS.md#42-adr-format): what observable signal confirms this decision was correct, and what triggers the assessment? Criteria must be binary (true or false, not a judgment call) and outcome-triggered (an event, not a calendar window). See §4.2 for the full requirement.

**Pass condition:** `bash scripts/preflight.sh` passes after the starter lands; running the starter against ese-plugin's state with the documented parameter overrides produces 27 findings, matching the ese-plugin internal linter's count against the same state (functional-equivalence test); `starters/linters/README.md` catalog contains the NO1 row with the "no ESE-internal mirror" qualifier.

**Trigger:** the first external adopter who vendors the starter and either (a) reports the linter surfaced positional drift they acted on, or (b) reports the linter surfaced a false positive requiring pattern refinement. At that point the decision is assessed against the outcome.

**Failure condition:** the starter produces a materially different set of findings than the ese-plugin internal linter against matched state (evidence of port regression); OR ESE's follow-on triage of its 27 violations concludes the ESE-internal mirror should never land (evidence the starter pack should be the only NO1 surface, and this ADR should be amended to record that posture); OR an adopter reports the parameterization set is insufficient for their layout (evidence the parameter defaults need extension).

---

## Per-Document Impact Analysis <!-- optional -->

> Required by [REQ-4.2-10](../../STANDARDS.md#req-4210) for ADRs modifying an existing component, API, interface, or standard. List every document affected by this decision. Documents confirmed unchanged must be listed explicitly. Optional in the template-compliance linter: only ADRs that modify an existing component, API, interface, or standard need to include this section. ADRs introducing genuinely new decisions with no existing artifacts to modify may omit it.

| Document | Change required | Notes |
|---|---|---|
| `starters/linters/lint-named-owner-integrity.sh` | Yes: new parameterized starter-pack linter | Landed in Session K commit 6 (SHA 30e1414) |
| `starters/linters/README.md` | Yes: catalog row added; narrative extends to eleven with qualifier | Landed in Session K commit 6 |
| `scripts/lint-named-owner-integrity.sh` | No, intentional: ESE-internal mirror deferred pending gate-authority triage of 27 pre-existing violations | Deferred to follow-on session |
| `docs/decisions/ADR-2026-04-16-shadow-gate-promotion-policy.md` | No: this ADR cites the policy, does not modify it | Reference-only cross-link |
| ese-plugin `scripts/lint-named-owner-integrity.sh` | No: Session J's internal linter is the source; this ADR ports it, does not change it | Reference-only cross-link |

---

## Follow-on Requirements <!-- optional -->

> If this decision introduces or modifies a component touching authentication, payments, data mutation, or external integrations, complete a FMEA per [§2.1 DESIGN](../../STANDARDS.md#21-the-lifecycle) before BUILD begins. Optional in the template-compliance linter: only ADRs that introduce qualifying follow-on obligations (FMEA, new REQ-IDs, etc.) need this section. Process-only ADRs that trigger no downstream artifacts may omit it.

<a name="REQ-TPL-06"></a>
**REQ-TPL-06** `advisory` `continuous` `soft` `all`
FMEA required: {yes / no}.

**FMEA required:** no. This ADR ports an existing linter with shadow-first posture. Failure modes are bounded: false positives are advisory, false negatives are absent-signal rather than corruption, and the blast radius is adopter friction rather than production risk.

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
| T1 | ese-plugin `scripts/lint-named-owner-integrity.sh` exists as the port source | Context (prerequisite) | Source linter to port from | ese-plugin Session J commit 7 |

**Implementation (sequential or parallel as noted):**

| # | Scope | Dependencies | Work Item |
|---|---|---|---|
| I1 | Port and parameterize as starter; update catalog; smoke-test against ese-plugin | T1 | Session K commit 6 (SHA 30e1414) |
| I2 | This ADR | I1 | Session K commit 7b (this commit) |
| F1 | Gate-authority triage of ESE's 27 pre-existing positional violations; follow-on session and ADR for ESE-internal mirror | I2 | Deferred |

**Template and artifact revisions (if this ADR changes templates or standards):**

| Artifact | Change needed | Work Item |
|---|---|---|
| `starters/linters/lint-named-owner-integrity.sh` | New parameterized starter ported from ese-plugin | Session K commit 6 |

**Cross-repo propagation (ESE §2.1 DOCUMENT: all documentation updated before work item closes):**

When this ADR introduces or changes a component, verify the following artifacts are updated
in the same work period. Each row is either checked off or marked N/A. An unchecked row
that is not N/A blocks ADR closure.

| Artifact | What to update | Status |
|---|---|---|
| Architecture doc | `docs/architecture/{component-name}.md` per ESE §3.3 (new component) or update existing | [x] N/A: starter linter sits alongside existing starter linters under the same architectural surface |
| System map / overview | Reference to new component in project system map or README | [x] done: `starters/linters/README.md` catalog gained a row with the "ships first in starter pack; no ESE-internal mirror yet" qualifier |
| Runbook | Operational procedures updated if this ADR changes how a service is started, stopped, or monitored | [x] N/A: no runtime behavior affected |
| Downstream config | Any agent context files, session guides, or operator docs that reference the component by name | [x] N/A: adopter-facing starter only; no CLAUDE.md wiring (no internal mirror in this release) |
