---
type: adr
id: ADR-2026-04-17-ese-starter-consolidation-into-engineering-standards
title: "ese-starter consolidation into engineering-standards"
status: Rejected
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

# ADR-2026-04-17: ese-starter consolidation into engineering-standards

<a name="REQ-TPL-03"></a>
**REQ-TPL-03** `advisory` `continuous` `soft` `all`
Architectural Decision Record. Required by §4.2 for any change that introduces a new component, replaces an existing approach, adds an external dep...

> Architectural Decision Record. Required by [§4.2](../../STANDARDS.md#42-adr-format) for any change that introduces a new component, replaces an existing approach, adds an external dependency, or alters how services communicate. Also required at [§2.1 DESIGN step](../../STANDARDS.md#21-the-lifecycle) and for all technology adoption decisions per [§9.1](../../STANDARDS.md#91-evaluation-framework).
>
> The YAML frontmatter above is required by the CI gate (`.github/workflows/ci.yml` Check 2). The five CI-required fields are: `type`, `id`, `title`, `status`, `date`. The `deciders` field is recommended but not enforced by CI. Status values: `Proposed` | `Accepted` | `Superseded by ADR-{n}`.

---

## Context

> [§4.2](../../STANDARDS.md#42-adr-format): describe the problem, constraints, and cost of doing nothing.

ESE currently lives across two repositories: `engineering-standards` (the normative standard, templates, addenda, starters) and `ese-starter` (vendored scripts, CI workflow, pre-commit hook, AGENTS.md / CLAUDE.md seed files, bootstrap tooling). Adopters consume ESE by cloning or bootstrapping from ese-starter, which pulls engineering-standards in as a git submodule.

The two-repo split creates three observable costs:

1. **Upgrade double-hop.** When engineering-standards ships v2.14.0, ese-starter must bump its submodule pin AND vendor any new starter linters / starters, then adopters consume ese-starter vN+1. The hop doubles the release cadence and creates a window where engineering-standards has content that ese-starter has not yet propagated. Session O observes this directly: commits 13-17 land in engineering-standards; commits 21-22 propagate to ese-starter; commits 23-24 propagate back into ese-plugin.
2. **Vendoring drift.** ese-starter's `scripts/` are hand-copied from engineering-standards's `starters/linters/` (and `scripts/`). The upgrade-check linter detects drift but does not auto-correct; adopters can be out of sync with engineering-standards even when their submodule pin is current, because the starter-level vendoring is separate.
3. **Two CHANGELOGs to reason about.** Every feature touching adopter-visible behavior requires two CHANGELOG entries (engineering-standards for the normative change, ese-starter for the adopter-visible vendoring). The second entry is easy to forget.

What would happen if we did nothing: the two-repo split persists; upgrade cadence remains constrained by the double-hop; vendoring drift remains a manual upgrade-check discipline rather than a mechanical guarantee; CHANGELOG entries remain duplicated.

This ADR is Proposed only; it is a PLANNING artifact that documents the consolidation option, alternatives, and a phased path. The decision itself is deferred to a later ADR with status Accepted once the gate authority has reviewed this planning.

**Supersedes:** N/A

**Superseded by:** [ADR-2026-04-24-ese-code-canonicalization-ese-starter-as-single-source-for-adopter-facing-executable-code](ADR-2026-04-24-ese-code-canonicalization-ese-starter-as-single-source-for-adopter-facing-executable-code.md)

---

## Decision

> [§4.2](../../STANDARDS.md#42-adr-format): be specific and unambiguous. Not "we will consider X" - "we are doing X."

**This ADR's decision is to PROPOSE consolidation and document the planning; the consolidation itself is deferred to a follow-up Accepted ADR after gate-authority review.**

Proposed consolidation shape:

1. `engineering-standards` absorbs ese-starter's distinctive content:
   - `scripts/bootstrap.sh` (from ese-starter) moves to `engineering-standards/scripts/bootstrap.sh`.
   - `scripts/pre-commit` (from ese-starter) moves to `engineering-standards/scripts/pre-commit`.
   - `.github/workflows/ci.yml` (from ese-starter) moves to `engineering-standards/starters/ci-workflow.yml.starter` so adopters copy it explicitly.
   - `AGENTS.md` / `CLAUDE.md` seeds move to `engineering-standards/starters/` (already partially done via C1 and C2 in Session O).
2. `engineering-standards/starters/linters/` is retained as the single vendoring source; adopters copy linters from this directory directly, eliminating the starter-level drift gap.
3. `ese-starter` is retired after consolidation lands; its repo becomes an archive. Existing adopters who cloned from ese-starter receive an advisory to re-adopt from `engineering-standards` directly on their next upgrade. The adopter's `.standards/` submodule pin already points at engineering-standards, so the consolidation is transparent for content; only the bootstrap source repo changes.
4. Adopters bootstrap with `bash engineering-standards/scripts/bootstrap.sh --target <your-repo>` (same invocation shape; different source repo).

Scope boundaries of the CONSOLIDATION (not of this planning ADR):

- In: bootstrap.sh, pre-commit hook, CI workflow starter, agent-context starters, starter-linter vendoring source.
- Out: the ese-plugin (which is a separate Claude Code plugin and remains its own repo; consolidation applies to ese-starter only).
- Future: a follow-up ADR may revisit the ese-plugin repo split after the ese-starter consolidation has been stable for at least one release cycle.

---

## Consequences

> [§4.2](../../STANDARDS.md#42-adr-format): state both positive and negative trade-offs. An ADR with no negative consequences was not thought through.

### Positive

- **One release cadence.** Engineering-standards ships v2.N; adopters consume directly. The ese-starter hop disappears.
- **Vendoring source collapses to one.** No more hand-copying between engineering-standards and ese-starter; adopters pull from a single directory.
- **Single CHANGELOG.** Adopter-visible changes land in engineering-standards CHANGELOG; the duplicate ese-starter CHANGELOG retires.
- **Simpler mental model for new adopters.** "Clone engineering-standards; run bootstrap" is one step shorter than "clone ese-starter which vendors engineering-standards."

### Negative

- **Repository scope expands.** engineering-standards becomes not only the normative standard but also the bootstrap tooling host. Section boundaries in its CLAUDE.md / AGENTS.md become more important to prevent contributors from bundling standard edits with tooling edits.
- **Migration cost for existing adopters.** Adopters who bootstrapped from ese-starter need to be told (in ese-starter's archived README) to re-bootstrap or to repoint their upgrade-check target. The cost is one-time but real.
- **ese-starter git history is archived.** Contributors who have bookmarked or referenced specific ese-starter commits need to follow the archived repo forward; link rot is likely over time.
- **ese-plugin split remains.** The consolidation resolves the starter split, not the plugin split. A second ADR may be needed later.

---

## Rejection rationale

This ADR was moved from Proposed to Rejected on 2026-04-24 after an 18-file audit and meta-analysis across engineering-standards, ese-starter, ese-plugin, and dotfiles produced evidence that inverted the consolidation direction this ADR had proposed.

**Empirical finding: fix-flow runs upward from adopters to engineering-standards, not downward from a pure-specification repo.** The audit found that ese-plugin holds the most recent critical fixes: the WI-127 `set -e` / EXIT-trap fix, 27 false-positive regex reductions in the NO1 linter, SCRIPT_DIR resolution, WI-027 auto-numbering, N3 FMEA normalization, N12 Part B inheritance, and Tier 2.5 placeholder-residue detection. Separately, ese-starter performed a shellcheck-clean sweep on 2026-04-14 that never propagated upstream. The nominal upstream copy at `starters/linters/` in engineering-standards is, in practice, frequently the STALEST of the three copies.

**Consequence for this ADR's direction.** This ADR proposed pulling ese-starter's executable content (bootstrap.sh, pre-commit hook, CI workflow, starter-linter vendoring) INTO engineering-standards and retiring ese-starter. The observed direction of fixes contradicts that topology: the repo that should be canonical is the one where the fixes actually land first, which is the adopter-facing layer (ese-starter and ese-plugin), not the specification repo. Consolidating code into engineering-standards would institutionalize the current lag pattern instead of resolving it.

**Superseding decision.** The inverse direction was adopted in ADR-2026-04-24-ese-code-canonicalization-ese-starter-as-single-source-for-adopter-facing-executable-code: ese-starter becomes the single source of truth for adopter-facing executable code, and engineering-standards contracts to pure specification plus its own internal self-validation toolchain. That direction matches the observed flow of fixes and removes the staleness gap at its root rather than absorbing it.

**Preservation note.** The Context, Decision, Consequences, and Alternatives sections above are retained as the historical record of the direction that was considered and rejected; the Alternatives section's "Move engineering-standards into ese-starter instead" entry, which was originally rejected, is effectively the direction the superseding ADR adopted once the observed fix-flow evidence was weighed.

---

## Alternatives Considered

<a name="REQ-TPL-04"></a>
**REQ-TPL-04** `advisory` `continuous` `soft` `all`
§4.2: every rejected alternative must have a documented rejection rationale. This prevents re-evaluating the same option later.

> [§4.2](../../STANDARDS.md#42-adr-format): every rejected alternative must have a documented rejection rationale. This prevents re-evaluating the same option later.

### Keep the two-repo split

Preserve the status quo: engineering-standards as the normative source, ese-starter as the vendoring / bootstrap distribution. Rejected because the costs documented in Context (double-hop, vendoring drift, duplicated CHANGELOG) accumulate with every release; the split's original justification (adopter concerns about depending on the normative repo directly) has not held up in practice since every adopter pins the submodule anyway.

### Move engineering-standards into ese-starter instead

Invert the consolidation direction: absorb engineering-standards into ese-starter. Rejected because the normative content is the primary ESE artifact; naming it "ese-starter" would obscure its authority and confuse readers. The normative content should live in the repo whose name communicates its role.

### Consolidate only the scripts / CI

Keep agent-context starters and `docs/` in engineering-standards; move only `scripts/` and `.github/workflows/` from ese-starter. Rejected because partial consolidation produces two incomplete repos rather than one complete one; the drift surface does not fully collapse.

---

## Validation

<a name="REQ-TPL-05"></a>
**REQ-TPL-05** `advisory` `continuous` `soft` `all`
§4.2: what observable signal confirms this decision was correct, and what triggers the assessment? Criteria must be binary (true or false, not a ju...

> [§4.2](../../STANDARDS.md#42-adr-format): what observable signal confirms this decision was correct, and what triggers the assessment? Criteria must be binary (true or false, not a judgment call) and outcome-triggered (an event, not a calendar window). See §4.2 for the full requirement.

**Pass condition:** within two engineering-standards release cycles after the follow-up Accepted ADR lands, zero adopters have reported bootstrap or upgrade failures attributable to the consolidation AND the CHANGELOG entries for the first two post-consolidation releases contain no duplicated content that previously lived in both engineering-standards and ese-starter.

**Trigger:** the first engineering-standards release that ships the consolidation; assessment happens two releases later.

**Failure condition:** any adopter-filed issue during the two-release window that cites lost bootstrap functionality, broken upgrade path, or missing vendoring target that was present pre-consolidation. A single such issue triggers a reversal ADR or a follow-up patch release to restore the capability.

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
