---
type: adr
id: ADR-2026-04-16-vsm-baseline-archiving-and-enforcement
title: "VSM baseline archiving and enforcement"
status: Accepted
date: 2026-04-16
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

# ADR-2026-04-16: VSM baseline archiving and enforcement

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

[REQ-ADD-CI-01](../addenda/continuous-improvement.md) in the continuous-improvement addendum obligates a current-state value stream map drawn from at least 10 completed work items before optimization. The requirement is worded against a map at a point in time; it does not prescribe how prior maps are retained. The standard as written therefore admits the failure mode where every improvement cycle maps the current state fresh, files the map somewhere ephemeral (a chat thread, an ad-hoc document, a person's memory), and starts measuring again the next cycle from scratch.

Without an on-disk archive of each baseline, cross-cycle comparison is not possible. An improvement claim of the form "reduce PR review wait from 1.5 days to 4 hours" presumes a prior measured baseline; if the baseline was never archived or is only described in prose inside the improvement work item itself, future cycles cannot reproduce the measurement to verify the improvement held or detect regression. The measurement falsifiability requirement at [§7.7](../../STANDARDS.md#77-measurement-system-analysis) implicitly assumes an archive exists; without one, verification against baseline is a claim without an auditable anchor.

The gap was surfaced by the Ecology of Coordination Comparison analysis dated 2026-04-16 as opportunity VSM1: "VSM baseline archiving." The companion opportunity MA5 (Lean value stream mapping methodology import) is the methodology side of the same gap; VSM1 is the artifact-discipline companion and is independently valuable now. Addressing VSM1 requires a directory convention, a template, a citation rule, and an enforcement linter. Addressing MA5 requires importing the methodology itself (pre-work, data collection, current-state/future-state mapping rhythm) into STANDARDS.md or the continuous-improvement addendum and is out of scope for this decision.

Cost of inaction: adopters who enable the continuous-improvement addendum satisfy REQ-ADD-CI-01 by mapping the current state but produce no archived artifact. Each subsequent improvement cycle pays the full cost of re-mapping from memory or re-measurement without the benefit of prior baseline comparison. Improvement claims are made against implicit baselines that cannot be reviewed. Retrospectives cannot falsify claims. The failure is silent because the standard does not require the archive.

**Supersedes:** N/A

---

## Decision

> [§4.2](../../STANDARDS.md#42-adr-format): be specific and unambiguous. Not "we will consider X" - "we are doing X."

Four concrete mechanisms operationalize REQ-ADD-CI-01 into an enforceable baseline-archive discipline:

1. **Directory convention.** Every value stream map is archived under `docs/improvement/vsm/` as `VSM-YYYY-MM-DD-<slug>.md`, where the date is the current-state-as-of date. One file per mapping exercise; prior maps are not overwritten. The convention is part of the project repository, not an external tool.

2. **Artifact template.** `templates/vsm.md` provides the template with required sections: Purpose and Context, Current-State Map (stages with active/wait/yield/ownership), Measured Observations (10 or more items sourced from completed work items), Bottleneck Identification (three largest wait times with evidence), Metadata (current-state-as-of date, author, status, supersedes). Future-State Vision is optional. Scaffolding via `bash scripts/new-artifact.sh vsm "Title"`.

3. **Citation rule.** A work item whose YAML frontmatter declares `type: improvement` must cite a baseline VSM in its Dependencies table by its relative path (`docs/improvement/vsm/VSM-YYYY-MM-DD-<slug>.md`). The citation's Type cell is `triggered-by`; the Status cell reflects the cited VSM's own Status. Improvement claims whose verification does not rest on a stage-to-stage comparison are exempt.

4. **Shadow linter.** `scripts/lint-vsm-baseline-reference.sh` (internal to ESE) and `starters/linters/lint-vsm-baseline-reference.sh` (parameterized for adopters) walk the work-items directory for files declaring `type: improvement`, parse the Dependencies table, and verify at least one row cites a resolvable path under the VSM archive directory. Silent pass when no improvement work items exist. Both linters ship with `# status: shadow` in the header; the exit code is 0 on violations so the build does not block. Promotion to gate is evidence-based and is a gate-authority decision made after the shadow phase accumulates true-positive catches with zero false-positive patterns. Promotion consists of flipping the header from `shadow` to `gate` and adjusting the CI wiring to treat the exit code as blocking; the script logic is unchanged.

The linter reads the existing `## Dependencies` table rather than requiring a new frontmatter field on `templates/work-item.md`. Modifying the work-item template would cascade adopter cost for a field that the Dependencies table already accommodates.

No new REQ-ID is introduced. REQ-ADD-CI-01 is the standards anchor; VSM1 operationalizes it.

---

## Consequences

> [§4.2](../../STANDARDS.md#42-adr-format): state both positive and negative trade-offs. An ADR with no negative consequences was not thought through.

### Positive

- Baseline measurements become durable and reviewable across improvement cycles. An improvement claim of the form "reduce X from A to B" now resolves to an auditable prior measurement rather than an implicit baseline.
- The `docs/improvement/vsm/` archive accumulates as the project's own longitudinal record of process changes, readable in the same format that the improvement work items cite.
- Shadow-first enforcement lets the rule bed in before blocking. Adopters with active improvement arcs see where the rule applies without the build breaking on day one.
- The starter linter propagates the enforcement surface to adopter repos automatically at the next submodule bump; adopters get the same check ESE uses on itself.

### Negative

- Adopters with active `type: improvement` work items may see first-linter-run findings that represent real gaps. The shadow posture softens the landing: the findings are printed but do not block. The gap is that the work items were already non-compliant with REQ-ADD-CI-01 by not citing a baseline; the linter surfaces the non-compliance rather than creating it.
- Downstream repositories (ese-plugin, ese-starter) must re-vendor the new starter linter at their next submodule bump. This is normal propagation tracked by the cross-repo session pattern and is not a novel debt.
- The shadow status means the enforcement surface is temporarily soft. A malformed improvement WI can still land. The alternative (land as gate) was rejected because the rule is new and the false-positive surface is not yet characterized.
- A small amount of downstream friction at adoption: adopters whose improvement WIs have lived without baseline citations must now either add citations or justify their absence. This is a one-time cost and is the intended forcing function of REQ-ADD-CI-01.

---

## Alternatives Considered

<a name="REQ-TPL-04"></a>
**REQ-TPL-04** `advisory` `continuous` `soft` `all`
§4.2: every rejected alternative must have a documented rejection rationale. This prevents re-evaluating the same option later.

> [§4.2](../../STANDARDS.md#42-adr-format): every rejected alternative must have a documented rejection rationale. This prevents re-evaluating the same option later.

### Alternative A: Prose-only inside improvement work items

Embed current-state measurements directly in the improvement WI's body. No separate archive, no template, no linter.

Rejected. Prose-only discipline fails at cross-cycle comparison: the measurements live inside a single work item whose status transitions to closed, after which the prose is not a natural reference point for the next cycle. A future cycle would need to scavenge prior WIs to reconstruct prior baselines. Improvement claims are also harder to audit because the baseline is encoded in free prose rather than a table the linter can parse. The failure mode this ADR addresses (no archive, no cross-cycle comparison) reproduces itself in the prose-only approach.

### Alternative B: External VSM tracker

Track baselines in a separate tool (spreadsheet, external wiki, tracker custom field). Work items link to tracker entries rather than on-disk paths.

Rejected. An out-of-tree archive breaks lint-based enforcement: the linter cannot resolve the citation to verify the baseline exists, so the rule becomes socially enforced rather than mechanically enforced. External tools add adopter onboarding overhead: every adopter must stand up or subscribe to the external tracker before they can satisfy REQ-ADD-CI-01's archive requirement. The on-disk approach costs nothing to adopt; every adopter already has a repository.

### Alternative C: Defer to MA5 (methodology import)

Do not ship VSM1 independently; wait for MA5 to import the Lean VSM methodology as a whole and ship the artifact discipline together.

Rejected. MA5 imports the methodology (pre-work, data collection, mapping rhythm, future-state iteration) into STANDARDS.md or the continuous-improvement addendum, which is a larger-surface decision with its own scope boundary to settle. VSM1 is scoped tightly to the artifact-discipline half (directory convention, template, linter) and is independently valuable: REQ-ADD-CI-01 already anchors the artifact in the standard, so the enforcement surface can land before the methodology import. Coupling the two delays the enforcement surface for a decision that is ready now. VSM1 and MA5 remain separately tracked; MA5 is a Wave 2 work item.

### Alternative D: Land the linter as gate from day one

Wire the linter to block the build on violations immediately, not as shadow.

Rejected. The linter is new and the false-positive surface is not yet characterized. Shadow-first lets the rule bed in: real adopter improvement arcs surface whatever edge cases the current rule misses, and the gate authority promotes to hard gate only after evidence confirms the rule catches true positives cleanly. This matches the shadow-first policy adopted for new linter classes in the engineering-standards self-application arc. Landing as gate preserves theoretical strictness at the cost of adopter confidence; the shadow arc trades a short enforcement-soft window for a longer-term stable gate.

---

## Validation

<a name="REQ-TPL-05"></a>
**REQ-TPL-05** `advisory` `continuous` `soft` `all`
§4.2: what observable signal confirms this decision was correct, and what triggers the assessment? Criteria must be binary (true or false, not a ju...

> [§4.2](../../STANDARDS.md#42-adr-format): what observable signal confirms this decision was correct, and what triggers the assessment? Criteria must be binary (true or false, not a judgment call) and outcome-triggered (an event, not a calendar window). See §4.2 for the full requirement.

**Pass condition:** `bash scripts/lint-vsm-baseline-reference.sh` (a) exits 0 and prints a pass message when run against a synthetic work item whose frontmatter declares `type: improvement` and whose Dependencies table cites an existing path under `docs/improvement/vsm/`, AND (b) exits 0 and prints a shadow-violation message naming the work item and the missing citation when run against a synthetic work item whose frontmatter declares `type: improvement` and whose Dependencies table cites nothing or cites an unresolvable path.

**Trigger:** the first real adopter improvement arc that cites a baseline VSM in its Dependencies table, reviewed by the gate authority for whether the baseline captured the constraint correctly and whether the linter treated the citation as resolved. The trigger is whichever comes first of (1) the first external adopter reports a shadow-run finding for the VSM1 linter, or (2) the first internal improvement arc in ese-plugin, ese-starter, or engineering-standards cites a baseline VSM and runs against the linter.

**Failure condition:** the linter produces false positives against compliant work items (cited citation exists but is flagged as missing), or the linter passes over work items whose Dependencies table obviously lacks any VSM citation while frontmatter declares `type: improvement`. Either outcome blocks promotion to gate until the rule is fixed.

**Example of promotion evidence:** three or more real adopter improvement arcs pass the shadow linter cleanly, zero false positives surface in the shadow run logs, and the gate authority confirms the rule caught at least one true-positive gap that would have otherwise produced an unverifiable improvement claim.

---

## Per-Document Impact Analysis <!-- omit-section: Per-Document Impact Analysis -->

<!-- This ADR introduces a genuinely new artifact type and enforcement surface with no prior inline equivalents; there are no existing components, APIs, or interfaces being modified. Section omitted per REQ-4.2-10's "new decisions with no existing artifacts to modify may omit" carve-out. -->

---

## Follow-on Requirements <!-- omit-section: Follow-on Requirements -->

<!-- This ADR does not introduce a component touching authentication, payments, data mutation, or external integrations. No FMEA is required. Section omitted per the template's process-only-ADR carve-out. -->

---

## Implementation Checklist

<a name="REQ-TPL-07"></a>
**REQ-TPL-07** `advisory` `continuous` `soft` `all`
Pre-BUILD controls (must be passing before implementation begins):.

**Pre-BUILD controls (must be passing before implementation begins):**

| # | Deliverable | Maps to | AC summary | Work Item |
|---|---|---|---|---|
| T1 | Baseline preflight green | Decision guardrail | `bash scripts/preflight.sh` exits 0 before any implementation commit | N/A (completed inline) |

**Implementation (sequential or parallel as noted):**

| # | Scope | Dependencies | Work Item |
|---|---|---|---|
| I1 | `templates/vsm.md` artifact template with required sections | none | Landed in commit preceding this ADR |
| I2 | `starters/vsm.md` adopter-facing convention starter | I1 | Landed in commit preceding this ADR |
| I3 | `scripts/lint-vsm-baseline-reference.sh` internal shadow linter wired as CI Check 37 | I1 | Landed in commit preceding this ADR |
| I4 | `starters/linters/lint-vsm-baseline-reference.sh` parameterized starter linter | I3 | Landed in commit preceding this ADR |
| I5 | `scripts/template-instance-mappings.txt` VSM mapping added; `scripts/new-artifact.sh` case pattern extended to include `VSM-` | I1 | Landed in commit preceding this ADR |

**Template and artifact revisions (if this ADR changes templates or standards):**

| Artifact | Change needed | Work Item |
|---|---|---|
| `templates/work-item.md` | N/A; the linter reads the existing Dependencies table rather than requiring a new field | N/A |
| `STANDARDS.md` §2.6 | N/A; REQ-ADD-CI-01 wording is the existing anchor and is preserved | N/A |

**Cross-repo propagation (ESE §2.1 DOCUMENT: all documentation updated before work item closes):**

| Artifact | What to update | Status |
|---|---|---|
| Architecture doc | `docs/architecture/{component-name}.md` per ESE §3.3 (new component) or update existing | [x] N/A: VSM1 introduces no new always-on component; the archive directory is static and the linters are CI scripts, not components requiring an architecture doc |
| System map / overview | Reference to new component in project system map or README | [x] done: `README.md` Structure section lists the new template, starter, and starter linter |
| Runbook | Operational procedures updated if this ADR changes how a service is started, stopped, or monitored | [x] N/A: no service behavior changes |
| Downstream config | Any agent context files, session guides, or operator docs that reference the component by name | [x] done: `CLAUDE.md` Before Every Commit suite gains the new linter invocation; CI check count updated from 36 to 37 |

**Cross-references:**

- ese-plugin research: `docs/research/ecc-comparison-2026-04-16.md` opportunity VSM1 (this ADR's originating observation).
- Companion opportunity MA5 (Lean VSM methodology import): Wave 2 work item; separately tracked. MA5 imports the methodology (pre-work protocol, data-collection rhythm, future-state iteration), while this ADR (VSM1) establishes the artifact-discipline companion.
- Standards anchor: [REQ-ADD-CI-01](../addenda/continuous-improvement.md) in the continuous-improvement addendum.
