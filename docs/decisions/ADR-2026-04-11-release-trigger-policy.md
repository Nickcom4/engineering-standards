---
type: adr
id: ADR-2026-04-11-release-trigger-policy
title: "ESE release trigger policy: gate-authority-cut on thematic completion"
status: Partially superseded by ADR-2026-04-14-automate-release-mechanics-at-close-push-remains-gate-authority-only
date: 2026-04-11
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

# ADR-2026-04-11: ESE Release Trigger Policy

## Table of Contents

- [Context](#context)
- [Decision](#decision)
- [Consequences](#consequences)
- [Alternatives Considered](#alternatives-considered)
- [Validation](#validation)
- [Per-Document Impact](#per-document-impact)

## Context

ESE has cut three releases (v1.7.0, v1.8.0, v2.1.0) without a written release trigger policy. The practice has been "gate authority decides when thematic work accumulates," but this rule has never been documented. A self-audit on 2026-04-11 identified this as a genuine gap: eleven commits had accumulated under `[Unreleased]` since v2.1.0 (including one `feat:` commit that wired six previously-orphaned lint scripts into CI), and no written rule existed to answer the question "when does this become v2.2.0?"

Two concrete problems follow from the absence of a written policy:

1. **Agent sessions cannot distinguish a shippable [Unreleased] window from an open one.** An AI coding agent working on an ESE change has no way to know whether it should propose a release ceremony commit at session end. Without a trigger rule, the agent either proposes prematurely (creating release ceremony commits the gate authority did not intend) or never proposes (leaving releases indefinitely deferred).

2. **Consumers of ESE artifacts (the REQ-ID schema, `enforcement-spec.yml`, templates, starters) have no predictability model.** A consumer cannot answer "when should I expect the next version" because the cadence is ad hoc. The three prior releases illustrate the range: v1.7.0 and v1.8.0 shipped the same day, then v2.1.0 came 17 days later after a major audit.

The generating principle is: **an unwritten release cadence is indistinguishable from a random release cadence from a consumer's perspective.** Either the policy is written down (at which point consumers can plan against it, and agents can follow it), or there is effectively no policy. The status quo leaves ESE in the second state.

Cost of doing nothing: continued ad-hoc release timing, agents proposing premature ceremony commits, stale `[Unreleased]` windows with no defined end state, and an eventual drift event where a release ships without the gate authority's full intent (because the agent or the tooling proposed it without a rule to check against).

**Supersedes:** N/A. No prior ADR addresses release triggering.

## Decision

ESE adopts a **gate-authority-cut-on-thematic-completion** release policy with deterministic semver assignment. The policy has seven parts:

1. **The gate authority cuts releases.** No time-based cadence, no automation, no agent authority. A release happens when the gate authority decides the `[Unreleased]` window represents a coherent shippable unit. Release cuts are an explicit exception to any general "agents progress autonomously through lifecycle stages" rule an agent harness may follow: agents may propose a release, but only the gate authority may execute one.

2. **Thematic completion is the trigger signal.** A release cut corresponds to a recognizable theme expressible in a single sentence (examples: "compliance audit remediation," "CI expansion from 25 to 31 checks," "addenda refresh for event-driven systems"). A grab-bag of unrelated fixes is explicitly not a release trigger; such commits accumulate under `[Unreleased]` until a theme forms or until a breaking change forces a cut.

3. **Semver assignment is deterministic based on the affected interfaces.** The ESE "interfaces" are: the REQ-ID schema, `enforcement-spec.yml` format, starter and template contracts, and the normative text of STANDARDS.md and addenda. The bump rules:

   | Bump | Triggering change |
   |---|---|
   | **Patch** (x.y.Z) | Typo corrections, script bug fixes, doc clarifications with zero adopter-visible behavior change |
   | **Minor** (x.Y.0) | New REQ-IDs, new addenda, new CI scripts or checks, new templates, new activation conditions, §4.9-protocol deprecations (anchors retained with `deprecated:` tag), new content boundaries |
   | **Major** (X.0.0) | REQ-ID schema changes, `enforcement-spec.yml` format changes, REQ-ID removals without the §4.9 deprecated-anchor protocol, starter or template removals, process changes requiring adopter migration, any breaking change to a consumed interface |

4. **Release ceremony is a single atomic commit.** The ceremony commit (a) moves `## [Unreleased]` to `## [X.Y.Z] - YYYY-MM-DD` in `CHANGELOG.md`, (b) updates `docs/standards-application.md` (`Standard version applied:` and `Last updated:` fields), and (c) includes a one-sentence thematic summary in the commit message body. The commit is then tagged with `git tag vX.Y.Z -m "..."`. The tag points at the ceremony commit, not at a subsequent commit.

5. **CI must be green on the ceremony commit.** All CI checks (currently 31) must pass before the tag is applied. A release cut on a red CI state is a gate violation and must be reverted immediately.

6. **Breaking changes require pre-release notice.** Any major bump must first appear as a "Breaking change" or "Action required" annotation in `[Unreleased]` for at least one commit before the ceremony commit, so the breaking intent is visible in git history and in any consumer's local checkout before the tag. This gives consumers who pull `main` a chance to see the annotation before they pull the tag.

7. **Agents do not cut releases; they may propose.** An AI coding agent may recommend a release ceremony commit with a proposed version bump and a proposed thematic summary, but the gate authority must explicitly approve and execute the ceremony commit and the tag. An agent that creates a ceremony commit or applies a tag without explicit gate authority approval in the same session is in violation of this policy.

This ADR captures ESE's own release policy. It does not add a normative requirement for adopters. A separate decision on whether to add `REQ-4.3-06` ("projects that publish versioned releases document the release trigger policy") is pending; that is a larger change requiring a STANDARDS.md edit, manifest regeneration, and a CHANGELOG entry in the next release window, and is explicitly out of scope for this ADR.

## Consequences

**Positive:**

- The ambiguity gap identified in the 2026-04-11 self-audit is closed. Future self-audits cannot rediscover this gap.
- Semver assignment becomes a lookup against a table instead of a judgment call. No debate about whether a change is minor vs patch.
- "Thematic completion" as the cut signal naturally discourages grab-bag releases that are hard to justify in a version heading.
- Explicitly excluding agents from release authority matches the existing gate authority model already documented in the project agent context file.
- No automation means no failure mode where tooling cuts a release the gate authority did not intend. The gate authority remains the single control point.
- The written policy gives future agents a check they can run: "does the current `[Unreleased]` window form a theme, and if so, what bump does the affected-interfaces table dictate?"

**Negative:**

- The `[Unreleased]` window can still grow indefinitely if no theme coalesces. Consumers who want a regular cadence have no guarantee they will get one. The policy explicitly accepts this tradeoff.
- "Thematic completion" is a judgment call. Two reasonable people could disagree about whether a batch of fixes constitutes a coherent theme. The policy mitigates this with the "one-sentence summary" test, but does not eliminate it.
- No time-boxed safety net exists for gate-authority unavailability. This is a pre-existing solo-operator constraint, not one introduced by this ADR, but it is worth naming.
- The policy covers ESE's own practice only. Adopters who want the same discipline must either adopt the policy by reference or wait for a future `REQ-4.3-06` decision.

**Risks:**

- If the gate authority departs and no successor is named, the policy has no executor and releases cannot be cut until succession is established. The named owner field in `docs/standards-application.md` is the existing mitigation; this ADR does not introduce new succession machinery.
- The "theme" requirement could become a rationalization vector (any grab-bag can be retrofitted with a theme). The validation section below includes a failure condition that catches this pattern.

## Alternatives Considered

1. **Time-boxed cadence** (for example, "minor release every 4 weeks if `[Unreleased]` is non-empty"): Rejected. ESE has no external pressure requiring a regular cadence. A time-box would force the gate authority to either cut thin releases on a schedule or amend the policy, both of which erode the policy's value. The prior tag history (v1.7.0 and v1.8.0 same day, then 17 days to v2.1.0) shows there is no natural cadence to codify. A time-box is a solution to a problem ESE does not have.

2. **Feat-triggered** (for example, "every `feat:` commit queues a minor bump at end of work session"): Rejected. This conflates commit type with release significance. A `feat:` commit can be part of a larger theme that is not yet complete (for example, wiring 6 of 10 planned lint scripts; the 6 are a `feat:` but the theme is "CI expansion" and is not done). The policy would force a release at an arbitrary intermediate point and prevent the natural thematic cut.

3. **Automated on `[Unreleased]` non-empty for N days**: Rejected. Automation removes gate authority judgment, which is the single most valuable quality control ESE has at its current scale. Automation also introduces a CI dependency (some workflow checking the age of `[Unreleased]`) that would itself need to be specified, tested, and maintained, adding failure modes rather than removing them. The `lint-adr-triggers.sh` advisory check already provides a similar signal for a different artifact (ADR validation) without cutting releases.

4. **No written policy** (the status quo before this ADR): Rejected. This ADR exists because the absence of a written policy was identified as a gap. Shipping without a policy is the null hypothesis that this ADR replaces.

5. **Write the policy into `README.md` instead of an ADR**: Rejected. The README is adopter-facing and describes what the project is, not how its internal process decisions were made. Release policy is a decision with alternatives, tradeoffs, and a validation trigger; that is the shape of an ADR, not a README section. A one-line pointer from `README.md` to this ADR is appropriate; the full rationale belongs here.

6. **Write the policy directly into `STANDARDS.md` §4.3 as a new REQ-ID**: Rejected for this decision, deferred for a later one. Adding a universal requirement that all adopters document a release trigger policy is a larger decision with broader impact (activation conditions, adopter migration cost, manifest regeneration). It requires a separate ADR or a direct STANDARDS.md edit with its own review. This ADR covers ESE's own policy only.

## Validation

**Pass condition:** The next three release cuts after this ADR is Accepted each satisfy all of the following:

- Ceremony commit follows the format in decision point 4 (single atomic commit, CHANGELOG version heading moved, standards-application.md fields updated, thematic summary in commit message body).
- Git tag `vX.Y.Z` is applied to the ceremony commit, not to a subsequent commit.
- CI is green on the tagged SHA (all 31 checks passing at tag time).
- The CHANGELOG version heading or the tag message contains a one-sentence thematic explanation.
- The ceremony commit author field shows the gate authority, not an agent or automation account.
- The semver bump matches the affected-interfaces table in decision point 3.

**Trigger:** Next release ceremony after this ADR is Accepted. Assessment repeats at each of the next three cuts.

**Failure condition:** Any one of the following, on any of the next three cuts, counts as a failure and reopens this ADR:

- A release cut without a one-sentence theme (or with a theme that is obviously retrofitted to justify a grab-bag).
- A release cut by an agent or automation without explicit gate authority approval in the same session.
- A ceremony commit amended after tagging.
- A tag applied to a SHA with red CI.
- A bump that does not match the affected-interfaces table (for example, a patch release that adds a new REQ-ID).
- A release cut during a breaking change window without the pre-release "Breaking change" annotation from decision point 6.

**Failure response:** If any failure condition fires, the next release is paused and this ADR is reopened for revision. The specific failure is added to `docs/incidents/lessons-learned.md` as a policy violation entry.

## Per-Document Impact

| Document | Change required | Notes |
|---|---|---|
| `docs/decisions/ADR-2026-04-11-release-trigger-policy.md` | Yes: this file (new) | Proposed at creation; Accepted after gate authority review |
| `CHANGELOG.md` | Yes: add entry under `[Unreleased]` `### Added` pointing at this ADR | Entry deferred until ADR is Accepted |
| `README.md` | Yes: add one-line pointer in `## Versioning` section referencing this ADR | Deferred until Accepted |
| Project agent context file at repo root | Yes: add one line under Hard Gates or near commit discipline noting that release ceremony commits require gate authority approval and are not subject to autonomous progression | Deferred until Accepted |
| `docs/standards-application.md` | No | Its `Standard version applied:` and `Last updated:` fields are untouched by this ADR; they update only at the next release ceremony itself |
| `STANDARDS.md` | No | REQ-4.3-06 (the adopter-facing generalization) is a separate pending decision, out of scope for this ADR |
| `templates/adr.md` | No | The existing template is sufficient for this ADR |
| `docs/adoption.md` | No | Adoption guide does not document release cadence for adopters; that gap is tracked in REQ-4.3-06 discussion |

**FMEA required:** No. This ADR documents a process decision. It does not introduce authentication, payments, data mutation, external integrations, or new runtime components. No failure modes are introduced that require DFMEA or PFMEA treatment. The policy's own failure conditions are captured in the Validation section.
