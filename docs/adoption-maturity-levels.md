---
type: adoption-maturity-levels
implements:
  - REQ-1.6-01
last-updated: 2026-04-17
---

# Adoption Maturity Levels

Five maturity levels for ESE adoption, adapted from the CMMI five-level staged representation and tailored to the Excellence Standards - Engineering adoption model. Used by adopters to self-assess posture, identify next-step investments, and calibrate review expectations.

> ESE does not gate the maturity level. An adopter self-declares their current level in `docs/standards-application.md` under a new optional frontmatter field `maturity-level:` (enum: 1-5 or one of the named values below). The self-declaration is advisory; its purpose is honest posture communication, not enforcement.

## Table of Contents

- [Level 1: Initial](#level-1-initial)
- [Level 2: Managed](#level-2-managed)
- [Level 3: Defined](#level-3-defined)
- [Level 4: Quantitatively Managed](#level-4-quantitatively-managed)
- [Level 5: Optimizing](#level-5-optimizing)
- [Self-declaration format](#self-declaration-format)
- [Movement between levels](#movement-between-levels)

## Level 1: Initial

**Characteristics:**

- ESE is present but not load-bearing. CLAUDE.md / AGENTS.md references exist. The bootstrap is complete (no `{placeholder}` strings remain).
- Living documents (`docs/setup.md`, `docs/deployment.md` when applicable, `docs/runbook.md` when applicable) are filled in at least once; they may be stale beyond the adopter's declared freshness threshold but they are not placeholders.
- Linters are vendored but not consistently run. CI invokes `bash scripts/verify.sh` but local pre-commit hooks may not be installed.
- Individual artifacts (ADRs, FMEAs, incidents) may or may not exist; when they exist, they are instances of ESE templates and pass `lint-template-compliance.sh`.

**Signals of Level 1:**

- `scripts/preflight.sh` exists, runs locally when asked, not on every commit.
- `docs/standards-application.md` declares capabilities but the corresponding living docs may not exist yet.
- Zero or minimal ADR / FMEA / incident history on disk.

**Advisory next step:** move to Level 2 by installing the pre-commit hook (`ln -sf ../../scripts/pre-commit .git/hooks/pre-commit`) and by completing the required living documents per the declared capability set.

## Level 2: Managed

**Characteristics:**

- Pre-commit hook installed in every adopter clone. CI green on every PR. Preflight runs automatically.
- All living documents declared by `docs/standards-application.md` capability booleans exist and carry content current within the declared freshness threshold.
- ADRs are used for real decisions, not as compliance paperwork. Each ADR has a non-empty Context, Decision, Consequences, and at least one Alternatives-considered entry.
- Work items are used for tracked work but may still mix expedite and standard flow without explicit class-of-service declaration.

**Signals of Level 2:**

- Every commit runs preflight (hook installed).
- `docs/standards-application.md` Capability Present column matches the actual living-doc inventory.
- At least 3 ADRs in `docs/decisions/` with status Accepted.

**Advisory next step:** move to Level 3 by adopting the compliance-review cadence and by publishing an intake log that distinguishes expedite from standard flow.

## Level 3: Defined

**Characteristics:**

- Compliance review performed on a declared cadence (monthly / quarterly). Each review produces a `docs/compliance-review-<period>.md` artifact.
- Intake process formalized: `docs/intake-log.md` (or equivalent) tracks every work item with class of service; expedites are back-filled post-resolution.
- FMEA applied to every design decision that crosses the REQ-2.1-35 threshold. Implemented controls carry file paths; tracked controls carry dependency WI references.
- Cross-document consistency checked: `lint-count-congruence.sh`, `lint-standards-application-frontmatter.sh`, `lint-fmea-congruence.sh` all gate green.

**Signals of Level 3:**

- Compliance review history: at least one review cycle completed per declared cadence.
- FMEA count: at least 1 FMEA per component that meets the trigger threshold.
- `docs/intake-log.md` exists with at least 10 tracked work items.

**Advisory next step:** move to Level 4 by instrumenting the SLOs declared in `docs/slos/` (when `has-runtime-service` is true) and by collecting baseline metrics for VSM improvement work.

## Level 4: Quantitatively Managed

**Characteristics:**

- SLOs defined for every declared runtime service. SLO compliance tracked; error-budget reports produced per review cycle.
- VSM baseline captured when the continuous-improvement addendum is adopted; cycle-time, defect-rate, and change-failure-rate metrics are collected.
- Post-mortems produced for every P0/P1 incident within one business day; Prevention-table actions tracked to closure (`lint-post-mortem-action-retirement.sh` clean).
- Statistical process control: defect rates and lead times monitored against declared thresholds; deviation triggers investigation.

**Signals of Level 4:**

- SLO artifacts exist and are current; error-budget reports referenced from compliance reviews.
- `docs/vsms/` contains at least one baseline VSM; improvement WIs cite the baseline per REQ-ADD-CI-01.
- Post-mortem cadence: 100 percent coverage of P0/P1 within one business day.

**Advisory next step:** move to Level 5 by initiating SMED / kaizen / constraint-identification work based on VSM data and by treating the compliance review as the kaizen cadence driver.

## Level 5: Optimizing

**Characteristics:**

- Continuous-improvement addendum is adopted and actively driving change. Kaizen events produce tracked WIs with measurable targets and follow-up verification.
- Theory of Constraints (per REQ-ADD-CI-67 through -69) identifies the current system constraint; improvement work preferentially targets the constraint.
- Failure-registry signatures (per REQ-8.3, REQ-8.4, and ese-plugin N1) drive automated pattern detection; anti-pattern entries are promoted from drafter output rather than written by hand after-the-fact.
- The adopter has one or more closed A3s that produced measurable target-condition attainment; follow-up verification met the declared target within the declared window.

**Signals of Level 5:**

- At least one kaizen cycle per review period.
- At least one A3 per period that shows measurable movement toward target condition.
- Constraint identified and named in compliance review; improvement WIs traceable to the constraint.

**Advisory next step:** Level 5 is not an end-state; optimization is continuous. The organization's advisory next step is to document what specific practices are load-bearing for their current throughput so the practices survive personnel turnover.

## Self-declaration format

In `docs/standards-application.md` frontmatter, add an optional field:

```yaml
maturity-level: 3         # self-declared level (1-5)
maturity-level-asof: 2026-04-17
maturity-level-next: 4    # adopter's advisory next-step target
```

The linter layer does not gate this. It is declarative context for reviewers, auditors, and new team members.

## Movement between levels

Movement is driven by observable signal, not by calendar time. Adopters move up when they meet the signals of the next level for at least one compliance-review cycle; adopters move down when a compliance review finds the current level's signals are no longer met.

Level movement is advisory; it does not trigger ESE enforcement. Its purpose is honest posture, not gate pressure.
