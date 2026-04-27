---
type: adr
id: ADR-2026-04-24-ese-code-canonicalization-ese-starter-as-single-source-for-adopter-facing-executable-code
title: "ESE code canonicalization ese-starter as single source for adopter-facing executable code"
status: Accepted
date: 2026-04-24
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

# ADR-2026-04-24: ESE code canonicalization ese-starter as single source for adopter-facing executable code

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

**Problem.** ESE's executable linter and tooling scripts currently exist in up to five copies spread across four repositories: `engineering-standards/scripts/`, `engineering-standards/starters/linters/`, `engineering-standards/starters/tools/`, `ese-starter/scripts/`, `ese-plugin/scripts/`, and `dotfiles/scripts/`. An 18-file audit on 2026-04-24 found roughly 74 copies of 16 canonical scripts. This violates ESE first principle #3 (single source of truth for each concern) and first principle #5 (mechanical enforcement over guidance); see [STANDARDS.md](../../STANDARDS.md) for the canonical principles list.

**Constraints (observed drift direction).** Drift between these copies is structural, not incidental:

- `ese-plugin/scripts/` holds the most recent critical fixes: WI-127 set-e/EXIT-trap fix, 27 false-positive regex reductions in the NO1 linter, SCRIPT_DIR resolution fix, WI-027 auto-numbering, N3 FMEA normalization, N12 Part B inheritance resolution, and Tier 2.5 placeholder-residue detection.
- `ese-starter/scripts/` performed a shellcheck-clean sweep on 2026-04-14 (SC2086, SC2001, SC2295 fixes) that never back-propagated to `engineering-standards/starters/`.
- The nominal "upstream" at `engineering-standards/starters/linters/` is frequently the STALEST copy.

Fixes flow UP from adopter-side repos into the nominal upstream, not the other way around. The current layout inverts the normal dependency direction.

**Cost of inaction.** Drift accumulates release-over-release. Adopters running `scripts/bootstrap.sh --upgrade` silently inherit pre-fix copies. The "upgrade-check advisory" pattern shifts recurring reconciliation burden onto every adopter indefinitely. Every ESE release ships a new generation of silently divergent copies.

**Supersedes:** [ADR-2026-04-17-ese-starter-consolidation-into-engineering-standards](ADR-2026-04-17-ese-starter-consolidation-into-engineering-standards.md) (which is being Rejected concurrently with this ADR's authoring; it proposed the OPPOSITE direction of canonicalization).

### First principles check

This decision is a direct application of:

- **First principle #3 (single source of truth for each concern):** the current tree has 5 copies; the target state has 1 canonical copy with downstream vendored copies that are mechanically verified against it.
- **First principle #5 (mechanical enforcement over guidance):** the drift-ratchet CI check (see Consequences) replaces human audit discipline, which has demonstrably failed over the prior release cycles.

---

## Decision

> [§4.2](../../STANDARDS.md#42-adr-format): be specific and unambiguous. Not "we will consider X" - "we are doing X."

Adopter-facing executable code lives canonically in `ese-starter/scripts/`. Specifically:

- Linters matching `scripts/lint-*.sh`.
- Tools: `new-artifact.sh`, `verify.sh`, `upgrade-check.sh`, `catchup.sh`, `bootstrap.sh`, `pre-commit`.
- Supporting libraries under `scripts/lib/`.
- The mapping table `scripts/template-instance-mappings.txt`.

`engineering-standards/starters/linters/` and `engineering-standards/starters/tools/` are deprecated and will be removed in a subsequent commit pair. The `engineering-standards/scripts/` directory (internal self-validation toolchain: REQ-ID generators, ADR lifecycle linters, etc.) is NOT affected by this decision and remains owned by engineering-standards.

`ese-plugin` and `dotfiles` continue to vendor linter copies for their own CI and runtime needs, but re-source those copies from `ese-starter`, not from `engineering-standards`. Plugin-specific specializations (linter-status framework, session state logging, plugin-only linters) remain in `ese-plugin` and are preserved via opt-in library sourcing, environment variables, or feature flags so that the vendored copy stays byte-equal to the `ese-starter` canonical source.

After migration, the repository roles are:

| Repo | Role |
|---|---|
| `engineering-standards` | Pure specification (STANDARDS.md, templates, addenda, ADRs) plus its own internal self-validation toolchain. No adopter-facing executable code. |
| `ese-starter` | Canonical source of all adopter-facing executable code. Publishes v1.12.0 as the first release under the new contract. |
| `ese-plugin` | Claude Code runtime integration. Vendors linter copies from ese-starter; preserves plugin-only logic via lib/env/flag hooks. |
| `dotfiles` | Operator environment. Vendors linter copies from ese-starter for CI parity. |

---

## Consequences

> [§4.2](../../STANDARDS.md#42-adr-format): state both positive and negative trade-offs. An ADR with no negative consequences was not thought through.

### Positive

- `engineering-standards` sheds approximately 15 script files and becomes pure specification plus internal toolchain. Smaller surface, clearer repo identity, easier reasoning about "what does this repo own."
- `ese-starter` absorbs the merged-best-of each canonical file and ships v1.12.0 as a minor release documenting the new contract.
- `ese-plugin` and `dotfiles` re-vendor from `ese-starter` v1.12.0; each preserves local specializations via library sourcing, environment variables, or feature flags (no forks).
- A drift-ratchet CI check is added to each downstream consumer to prevent re-emergence of the five-copy pattern.
- The direction of fixes is now correct: they flow DOWN from the canonical source to vendored copies, via mechanical verification.
- Dependabot submodule bumps in adopter repos continue to function; those bumps no longer ship code changes through the specification channel.

### Negative

- One-time migration cost: four repos (engineering-standards, ese-starter, ese-plugin, dotfiles) must all accept coordinated commits. The migration window is a period of elevated coupling risk.
- Known adopter repos whose CI references `.standards/starters/linters/` directly (rather than vendoring via `scripts/bootstrap.sh`) must migrate to pulling from `ese-starter` vendored copies. Adopters that vendor via `scripts/bootstrap.sh` are unaffected.
- `ese-plugin` and `dotfiles` carry a vendoring contract they did not previously carry: the drift-ratchet CI check must pass on every change. This is enforced mechanically but adds a new class of CI failure to triage.
- Specification-only consumers who previously read linter source from `engineering-standards/starters/linters/` for reference purposes must now read it from `ese-starter/scripts/`. Documentation cross-references in the specification repo need updating.

---

## Alternatives Considered

<a name="REQ-TPL-04"></a>
**REQ-TPL-04** `advisory` `continuous` `soft` `all`
§4.2: every rejected alternative must have a documented rejection rationale. This prevents re-evaluating the same option later.

> [§4.2](../../STANDARDS.md#42-adr-format): every rejected alternative must have a documented rejection rationale. This prevents re-evaluating the same option later.

### Alternative 1: Keep three-way vendor tree with WI-074-style lightweight reconciliation

`ese-plugin` currently tracks intentional divergences in `vendored-linter-changes.md`, keeps `upgrade-check` advisory, and audits periodically. Extending this pattern across all four repos would preserve the status quo layout while formalizing the reconciliation practice.

**Rejected.** Trades a bounded one-time migration cost for an indefinite recurring maintenance cost. Drift can still accumulate silently between audits; the pattern requires human discipline that has demonstrably failed over the prior release cycles (see Context: fixes currently flow UP from adopters to the nominal upstream, which is backwards). Advisory checks do not mechanically prevent the failure they are supposed to detect.

### Alternative 2: Canonicalize INTO engineering-standards (per Proposed ADR-2026-04-17)

The pre-existing Proposed ADR argues the opposite direction: make `engineering-standards/starters/` the canonical source and have `ese-starter`, `ese-plugin`, and `dotfiles` vendor from it.

**Rejected.** Leaves `engineering-standards` shipping executable bash code, which conflates specification with implementation and muddies the repo's identity as the normative standard. It still requires every adopter to vendor copies (so it does not reduce the copy count), and critically, the stalest copy today IS `engineering-standards/starters/linters/`. That observation reveals the direction in which fixes flow: UP from adopters, not DOWN from a pure spec repo. Designating the stalest copy as canonical would institutionalize the drift the audit identified.

### Alternative 3: Canonicalize into ese-plugin

`ese-plugin` holds the most recent fixes today, which makes it the empirically freshest copy.

**Rejected.** `ese-plugin` is Claude-Code-runtime-only. Adopters using ESE without Claude Code still need bash linters for CI and local verification. Making `ese-plugin` canonical would force non-Claude-Code CI environments to depend on a Claude Code plugin distribution channel, which is a coupling failure. `ese-starter` is the correct home because it has no runtime dependency on Claude Code and its purpose is already "the scaffold an adopter starts from."

---

## Validation

<a name="REQ-TPL-05"></a>
**REQ-TPL-05** `advisory` `continuous` `soft` `all`
§4.2: what observable signal confirms this decision was correct, and what triggers the assessment? Criteria must be binary (true or false, not a ju...

> [§4.2](../../STANDARDS.md#42-adr-format): what observable signal confirms this decision was correct, and what triggers the assessment? Criteria must be binary (true or false, not a judgment call) and outcome-triggered (an event, not a calendar window). See §4.2 for the full requirement.

**Pass condition:** after migration completes, running `bash scripts/verify.sh` in each of `engineering-standards`, `ese-starter`, `ese-plugin`, and `dotfiles` exits 0; AND `bash scripts/upgrade-check.sh` Dimension 3 reports no unmodified drift against `ese-starter` as the new canonical source.

**Trigger:** `ese-starter` v1.12.0 tag published. This is the event that makes the full assessment possible because it is the first release under the new contract; until that tag exists, downstream consumers cannot pin to it.

**Failure condition:** any of the four repos' `verify.sh` returns non-zero, OR `upgrade-check.sh` Dimension 3 reports drift in a file that was supposed to be byte-equal to the canonical source, OR a downstream repo (ese-plugin, dotfiles) develops an unvendored local modification to a file that is contractually canonical.

**Validation audit due:** 30 days after v1.12.0 to confirm no regressions in adopter repos.

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

**FMEA required:** no
**FMEA path:** N/A (the decision is architectural deduplication, not the introduction of a new failure-prone component. The risk surface is adopter migration, which is handled in the migration plan rather than in a design FMEA; the canonical directions for auth, payments, data mutation, or external integrations are not touched by this ADR.)

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
