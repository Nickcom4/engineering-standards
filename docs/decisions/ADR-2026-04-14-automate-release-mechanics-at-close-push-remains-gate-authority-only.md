---
type: adr
id: ADR-2026-04-14-automate-release-mechanics-at-close-push-remains-gate-authority-only
title: "Automate release mechanics at CLOSE; push remains gate-authority only"
status: Accepted
date: 2026-04-14
deciders: "Nick Baker"
stage:
  - design
applies-to: all
implements:
  - REQ-4.2-01
  - REQ-2.1-03
  - REQ-4.3-01
dfmea: ~
pfmea: ~
architecture-doc: ~
---

# ADR-2026-04-14: Automate release mechanics at CLOSE; push remains gate-authority only

## Table of Contents

- [Context](#context)
- [Decision](#decision)
- [Consequences](#consequences)
- [Alternatives Considered](#alternatives-considered)
- [Validation](#validation)
- [Per-Document Impact](#per-document-impact)

## Context

[ADR-2026-04-11](ADR-2026-04-11-release-trigger-policy.md) adopted a gate-authority-cut-on-thematic-completion policy and explicitly rejected automation. Six release cycles of experience later (v2.1.0 through v2.7.0), two concrete problems with the no-automation rule have surfaced:

1. **Structural drift against the rule the policy itself enforces.** `scripts/lint-release-existence.sh` was added in v2.7.0 to catch the failure mode where `[Unreleased]` content accumulates indefinitely without a release cut. That linter exists because the no-automation rule reliably produces the very state it is designed to prevent: a human has to remember to cut the release, and often does not. The gate authority added a detection mechanism for a problem that disappears under automation. The detector is a workaround for the policy, not a validation of it.

2. **The current rule conflates two actions with very different reversibility.** "Release ceremony" under ADR-2026-04-11 decision point 4 is a single atomic bundle: move `[Unreleased]` heading, update `standards-application.md`, commit, tag, push. But the commit and tag are local and reversible (`git tag -d`, `git reset`); the push is shared and hard to reverse (force-push requires consumer coordination). Gating the entire bundle means gating commit mechanics that do not warrant gating, because the externally-visible action (push) is what actually needs human judgment.

The generating principle, stated plainly: **local reversible actions should be automated when gates are trustworthy; shared irreversible actions should remain under explicit human control.** ADR-2026-04-11 does not make this distinction; it gates everything together. The result is both unnecessary friction (on the local-reversible parts) and an insufficient signal for the actually-risky step (because the human approval is amortized across all the mechanics, reducing its meaning for the one step that needs it most).

Cost of doing nothing: continued `[Unreleased]` accumulation, continued reliance on `lint-release-existence.sh` as a detector for a policy-induced failure mode, and continued conflation of ceremony mechanics with the push decision so that neither gets the right amount of attention.

**Supersedes:** Partially supersedes [ADR-2026-04-11](ADR-2026-04-11-release-trigger-policy.md) decision points 1, 4, 5, and 7. Decision points 2 (thematic completion trigger), 3 (deterministic semver table), and 6 (breaking-change pre-release notice) remain in force unchanged.

## Decision

ESE adopts **automated release mechanics at CLOSE, with push remaining explicit gate-authority approval**. The policy has six parts:

1. **Automation trigger.** At the CLOSE stage of the work-item-lifecycle chain, if all of the following are true, the lifecycle automatically performs the release ceremony:
   - All preflight gates pass (currently 35/35).
   - `CHANGELOG.md` has real content under `[Unreleased]` (not the `*No unreleased changes.*` placeholder).
   - The work item has not set `release: defer` in its frontmatter (opt-out).
   - The derived semver bump is `patch` or `minor` (see part 3). Major bumps always require explicit gate authority approval; the breaking-change pre-release notice from ADR-2026-04-11 decision point 6 remains in force.

2. **Automated mechanics.** The ceremony is a single atomic commit that:
   - Moves `## [Unreleased]` to `## [X.Y.Z] - YYYY-MM-DD` in `CHANGELOG.md` with today's date and a derived thematic summary (one sentence, composed from the commit messages between the last tag and `HEAD`).
   - Updates `docs/standards-application.md` `ese-version`, `last-updated`, `Standard version applied:`, and `Last updated:` fields.
   - Commits with message `chore: release vX.Y.Z` and the thematic summary in the body.
   - Applies the tag `git tag -a vX.Y.Z -m "..."` locally.
   - Re-runs preflight against the ceremony commit before the tag is applied. If preflight fails, the commit is reverted and the ceremony is aborted.

3. **Semver derivation is deterministic from commit types.** The bump is derived from the set of commit types between the last tag and `HEAD`:
   - Any `feat:` or any commit body containing `BREAKING CHANGE:` or `!` marker on a feat/fix: triggers a major bump (which aborts automation and requires gate authority approval per part 1).
   - Any `feat:` without breaking markers: minor bump.
   - Only `fix:`, `docs:`, `chore:`, `refactor:`: patch bump.
   - No substantive commits (only `chore: release` or similar): abort, nothing to release.

   This matches the Conventional Commits derivation and is consistent with the affected-interfaces table in ADR-2026-04-11 decision point 3.

4. **Push remains gate-authority only.** `git push` is never automated. After the ceremony commit and tag are applied locally, the lifecycle surfaces the status ("Release vX.Y.Z prepared locally; push with `git push origin main --follow-tags` when ready") and stops. The gate authority executes the push when appropriate. This preserves human control over the externally-visible action while eliminating friction on the local-reversible preparation.

5. **Opt-out mechanism.** A work item may declare `release: defer` in its frontmatter, which suppresses automation for that CLOSE. This exists for cases where the work is genuinely done but should not ship yet (e.g., it is part of a larger theme that has not yet completed, or it is waiting on coordination with another repo). The opt-out is work-item-scoped; the next CLOSE without `release: defer` resumes automation.

6. **Agents may execute mechanics but not push; gate authority still formally authorizes the release by pushing.** An agent may perform the automated ceremony and tag locally because those actions are reversible. An agent may not push; push is the authorization signal. This aligns with both Anthropic's agent-safety guidance (shared-state actions require explicit confirmation) and the user's global rule that push requires explicit instruction.

## Consequences

**Positive:**

- `lint-release-existence.sh` becomes redundant for its original purpose: the failure mode it detects can no longer occur because every closed work item with `[Unreleased]` content produces a local release. The linter remains useful as a guard against the opt-out mechanism being overused.
- Smaller, more frequent releases. Per DORA, this improves bisection, reduces per-release blast radius, and shortens feedback loops.
- Ceremony mechanics become a table lookup for 95%+ of cases. Judgment remains exactly where it matters: major bumps (breaking changes) and push timing (external visibility).
- The gate-authority signal becomes more meaningful, not less. Instead of approving commit mechanics plus tagging plus push as one bundle, the gate authority approves only push, and push is the clear "ship this externally" signal.
- Aligns with the local-reversible vs shared-irreversible distinction already implicit in agent-safety guidance.
- Work items that close with `[Unreleased]` empty get no release (no-op), which matches current behavior.

**Negative:**

- Automation can derive the wrong thematic summary. Mitigation: the summary is visible in the ceremony commit message and can be amended before push. If push is rejected (e.g., gate authority decides to amend), the tag can be moved (local tag, not yet public).
- Adds a CLOSE-stage dependency on preflight re-running after the ceremony commit. This is already done for verification; the additional cost is one preflight run per release, which is under one minute.
- Opt-out via `release: defer` can be overused, recreating the `[Unreleased]` accumulation problem. Mitigation: `lint-release-existence.sh` still fires; a defer-heavy repo will accumulate and fail the gate.
- Major bumps still require gate authority judgment, so the "always automatic" narrative is not quite true. This is intentional: breaking changes are exactly where human judgment is most valuable.

**Risks:**

- If the semver derivation is wrong (e.g., a `feat:` commit is actually a breaking change that was mis-tagged), a minor release could ship with breaking content. Mitigation: the commit-author is responsible for correct commit typing; the pre-release breaking-change annotation from ADR-2026-04-11 decision point 6 remains a separate check. If this fires in practice, that is a commit-discipline failure, not an automation failure.
- An agent that runs the full lifecycle on a branch that should not have triggered a release (e.g., exploratory work committed to main by mistake) could produce a ceremony commit. Mitigation: push gating catches this before external visibility. The local ceremony commit can be reverted with `git reset --hard HEAD~1 && git tag -d vX.Y.Z`.

## Alternatives Considered

1. **Status quo (ADR-2026-04-11 as-is).** Rejected. Six release cycles of experience have shown the friction and the structural drift that led to `lint-release-existence.sh`. The policy as written produces the failure mode it forbids.

2. **Full automation including push.** Rejected. Push is shared-state and hard to reverse. Anthropic's agent-safety guidance and the user's global rule both require explicit confirmation for shared actions. The value of the gate-authority signal is highest exactly at push; moving push into automation dilutes that value.

3. **Automated cadence (e.g., weekly release if `[Unreleased]` non-empty).** Already rejected in ADR-2026-04-11 decision 3 of Alternatives Considered. Re-rejected here for the same reasons: ESE has no external cadence requirement, and a time-box forces thin releases or amendments. This ADR takes a different approach: release on work-item close, not on a clock.

4. **Manual semver, automated mechanics only.** Merged into the proposal. The mechanics (heading move, field updates, commit, tag) are automated; semver derivation is deterministic from commit types (part 3); major bumps still require gate authority approval (part 1). This is effectively "automated mechanics with an escape hatch for the judgment-requiring cases."

5. **Move the gate from commit to push but keep everything else manual.** Considered. This is the same as the proposal minus the automation of the mechanics themselves. Rejected because it does not solve the structural problem: the human still has to remember to run the ceremony, and `lint-release-existence.sh` remains necessary as a detector. The value of this ADR is in automating the mechanics, not just in moving the gate.

## Validation

**Pass condition:** The next three release cuts after this ADR is Accepted each satisfy all of the following:

- Ceremony commit was produced by lifecycle automation at CLOSE, not by a human manual run. The git author field shows the same committer as other recent commits; no automation account is introduced.
- Semver bump matches the derivation in decision point 3, verifiable from `git log <last-tag>..HEAD --format='%s'` and the commit-type-to-bump table.
- Re-preflight on the ceremony commit passed before the tag was applied (evidenced by a green `bash scripts/preflight.sh` run in the work session log).
- Push was a separate human action; git reflog on the pushing machine shows a non-automated `git push` invocation.
- No work item used `release: defer` without a documented reason in the work item artifact.
- Major bumps, if any, went through explicit gate authority approval and did not auto-release.

**Trigger:** Each of the next three release ceremonies after this ADR is Accepted.

**Failure condition:** Any one of the following, on any of the next three cuts, counts as a failure and reopens this ADR:

- An automated ceremony commit that should not have been produced (e.g., exploratory work, incomplete arc).
- A tag applied with red CI (re-preflight bug or bypass).
- An auto-derived semver bump that does not match the commit-type table.
- A push that was itself automated (violation of part 4).
- A major bump that was auto-executed (violation of part 1).
- Three or more consecutive `release: defer` opt-outs without documented reasons; that pattern indicates the automation trigger is wrong.

**Failure response:** If any failure condition fires, the lifecycle automation is disabled (revert to ADR-2026-04-11 policy) and this ADR is reopened. The specific failure is added to `docs/incidents/lessons-learned.md`.

## Per-Document Impact

| Document | Change required | Notes |
|---|---|---|
| `docs/decisions/ADR-2026-04-11-release-trigger-policy.md` | Yes: update status to `Partially superseded by ADR-2026-04-14-automate-release-mechanics-at-close-push-remains-gate-authority-only` (decision points 1, 4, 5, 7); note that points 2, 3, 6 remain in force | Done after this ADR is Accepted |
| `docs/decisions/ADR-2026-04-14-automate-release-mechanics-at-close-push-remains-gate-authority-only.md` | Yes: this file (new) | Proposed at creation; Accepted after gate authority review |
| `CHANGELOG.md` | Yes: add entry under `[Unreleased]` `### Changed` pointing at this ADR | Deferred until Accepted |
| `CLAUDE.md` | Yes: update Hard Gate #7 to reflect partial-supersession; the remaining gate is push, not release | Deferred until Accepted |
| `README.md` | Yes: update `## Versioning` section reference if it mentions release trigger | Deferred until Accepted |
| ese-plugin `work-item-lifecycle-step-09-close` skill | Yes: implement the automation described in decision points 1-4 | Separate work item; ese-plugin is a separate repo |
| `scripts/lint-release-existence.sh` | No structural change; remains as an opt-out-overuse guard | Repurposed, not removed |
| `docs/standards-application.md` | No | Updated at each release ceremony itself, not by this ADR |
| `STANDARDS.md` | No | This ADR governs ESE's own practice; adopter-facing generalization (REQ-4.3-06 discussion from ADR-2026-04-11) remains deferred |

**FMEA required:** No. This ADR documents a process automation decision. No authentication, payments, data mutation, or new runtime components are introduced. The automation's failure modes are captured in the Validation section's Failure Conditions.
