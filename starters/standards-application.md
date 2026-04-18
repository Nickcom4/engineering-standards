---
# Starter metadata (remove these three keys when copying this file to
# your project's docs/standards-application.md):
type: starter
purpose: "Document how ESE applies to a specific project"
frequency: one-time

# Applicability frontmatter for your project (keep and fill in).
# Each {placeholder} must be replaced with your project's value before
# scripts/lint-standards-application-frontmatter.sh will pass. Concrete
# values below are ESE defaults that projects typically accept unchanged;
# override with documented rationale. Boolean fields default to false
# (conservative opt-in) so your project must explicitly declare every
# capability and addendum that applies. Keep the YAML values consistent
# with the prose tables in this file; the linter enforces that
# consistency at commit time.

ese-version: "{X.Y.Z}"                      # pin to the ESE version your submodule points at
last-updated: "YYYY-MM-DD"                  # bump whenever this file changes; new-artifact.sh substitutes to today's date at scaffold time

# Applicability inheritance (optional, N12).
# When set, identifies an upstream source whose applicability-field defaults
# should auto-propagate into this file's capabilities and addenda sections
# on ese-starter bootstrap-upgrade runs. Leave empty or omit to manage
# fields manually. Recognized values:
#   ese-starter   - inherit from ese-starter/docs/standards-application.md
#                   at the pinned .standards/ submodule tag; adopter agrees
#                   that ese-starter's starter is the source of truth for
#                   optional-field defaults
# Unset or empty keeps the current manual-management posture; nothing
# auto-propagates. Downstream linters warn on source-drift when
# inherit-from is set and an inherited field has diverged from the upstream
# value without an override comment.
inherit-from: ""                            # empty = manual; set to "ese-starter" for N12 auto-sync

owner:
  name: "{Team or individual}"              # §2.4 named owner; must be discoverable without asking
  contact: "{channel or contact method}"    # how to reach the owner

compliance-review:
  cadence: "every-significant-release"      # enum: every-significant-release | quarterly | semi-annual | annual | event-triggered
  last-review-date: "YYYY-MM-DD"            # date of most recent compliance review; substituted to today at scaffold time; update after each subsequent review
  next-review-trigger: "{date or event description}"  # ISO date OR free-text event description

# Component Capabilities Declaration (§5-§9 activation gate).
# Set to true only for capabilities this project actually has.
# Must match the Yes/No cells in the Component Capabilities Declaration prose table below.
capabilities:
  has-runtime-service: false                # always-on process; activates §5.4, §5.9, §7.1, §7.2, §7.5, §7.6
  deploys-to-production: false              # has a production environment; activates §5.5, §5.7, §7.4
  exposes-api: false                        # consumed by other systems; activates §5.8
  has-persistent-storage: false             # database or file-based state; activates §5.4 restart safety
  manages-infrastructure: false             # IaC, provisioning; activates §5.6
  handles-sensitive-data: false             # PII, PHI, financial, credentials; activates §5.10, §6.5
  has-external-users: false                 # humans outside the team use it; activates §8.5
  produces-user-visible-output: false       # UI, reports, generated content; activates §6.3
  has-runtime-dependencies: false           # declared external packages or services; activates §5.2
  has-multiple-repositories: false          # spans multiple repos; activates §5.3
  contains-logic-code: false                # branches, loops, error handling; activates §6.1

# Applicable addenda (first-party extensions for specific contexts).
# Set to true for every addendum that matches this project's context.
# Must match the yes/no cells in the Applicable Addenda prose table below.
addenda:
  multi-service: false                      # microservices, service mesh, cross-service calls
  multi-team: false                         # multiple teams own parts of this codebase
  web-applications: false                   # browser-rendered UI
  containerized: false                      # Docker, Kubernetes, OCI runtime
  ai-ml: false                              # ML models, LLMs, probabilistic components
  event-driven: false                       # event brokers, message queues, event sourcing
  agent-assisted-development: false         # AI coding agents with commit authority, harness configuration, agent security posture
  continuous-improvement: false             # formal Lean or Six Sigma practice

# §4.1 template-compliance verification mode (REQ-4.1-03).
template-compliance:
  mode: "automated"                         # enum: automated | compliance-review
  evidence: "scripts/lint-template-compliance.sh"  # path to the script (automated) or the review activity name (compliance-review)

# §2.1 FMEA thresholds (REQ-2.1-48).
# ESE defaults: RPN 75, severity 7. Override with documented rationale if your project requires different thresholds.
fmea:
  rpn-threshold: 75
  severity-threshold: 7
---

<a name="REQ-STR-17"></a>
**REQ-STR-17** `artifact` `session-start` `hard` `all`
The project's standards application document contains all 8 first principles.

<a name="REQ-STR-44"></a>
**REQ-STR-44** `artifact` `continuous` `hard` `all`
The standards application document contains a named owner section.

<a name="REQ-STR-45"></a>
**REQ-STR-45** `artifact` `continuous` `hard` `all`
The standards application document contains a component architecture backlog.

<a name="REQ-STR-46"></a>
**REQ-STR-46** `artifact` `continuous` `hard` `all`
The standards application document contains a service health status section.

<a name="REQ-STR-47"></a>
**REQ-STR-47** `artifact` `continuous` `hard` `all`
The standards application document contains SLO definitions.

<a name="REQ-STR-48"></a>
**REQ-STR-48** `artifact` `continuous` `hard` `all`
The standards application document contains delivery health metrics.

<a name="REQ-STR-49"></a>
**REQ-STR-49** `artifact` `continuous` `hard` `all`
The standards application document contains a testing gap table.

<a name="REQ-STR-50"></a>
**REQ-STR-50** `artifact` `continuous` `hard` `all`
The standards application document contains applicable addenda identification.

<a name="REQ-STR-51"></a>
**REQ-STR-51** `artifact` `continuous` `hard` `all`
The standards application document contains a compliance review cadence.

<a name="REQ-STR-52"></a>
**REQ-STR-52** `artifact` `continuous` `hard` `all`
The standards application document contains a new person readiness check.

# {Project Name} - Engineering Standards Application

> This document applies the [Excellence Standards - Engineering (ESE)](../STANDARDS.md) to {Project Name}. It captures current state, known gaps, and project-specific constraints. Update it when gaps close, new components are added, or requirements change. This is a living record, not a one-time audit.
>
> The YAML frontmatter above is the machine-readable summary of this project's structured applicability claims (ESE version pin, owner, capabilities, applicable addenda, template-compliance mode, FMEA thresholds, review cadence). Prose sections below are the human-readable rationale; they must stay consistent with the frontmatter. `scripts/lint-standards-application-frontmatter.sh` (ESE CI Check 34) enforces both presence/types and claim-vs-reality consistency against `enforcement-spec.yml` and `CHANGELOG.md`.

---

## Table of Contents

- [Project First Principles](#project-first-principles)
- [Component Capabilities Declaration](#component-capabilities-declaration)
- [Named Owner](#named-owner)
- [Roadmap and Phase Definitions](#roadmap-and-phase-definitions)
- [Components Lacking Architecture Docs](#components-lacking-architecture-docs)
- [Service Health Check Status](#service-health-check-status)
- [SLO Definitions](#slo-definitions)
- [Delivery Health Metrics](#delivery-health-metrics)
- [Active Improvement Initiatives](#active-improvement-initiatives)
- [Current Testing Gaps](#current-testing-gaps)
- [Technology Decisions Lacking ADRs](#technology-decisions-lacking-adrs)
- [User Feedback Mechanism](#user-feedback-mechanism)
- [Technical Debt Tracking](#technical-debt-tracking)
- [Incident Communication Channel](#incident-communication-channel)
- [Lessons-Learned Registry](#lessons-learned-registry)
- [Anti-Pattern Registry](#anti-pattern-registry)
- [New Person Readiness](#new-person-readiness)
- [Applicable Addenda](#applicable-addenda)
- [§4.1 Template Compliance Verification Mode](#41-template-compliance-verification-mode)
- [FMEA Thresholds](#fmea-thresholds)

---

## Project First Principles

> [§1.4](../STANDARDS.md#14-project-first-principles): every project's non-negotiable constraints. Reviewed at the start of every work session.

1. **Scope statement** - {one sentence: what this system IS and IS NOT}
2. **Source of truth** - for tasks: {tool/file}; for knowledge: {tool/file}; for state: {tool/file}
3. **Verifiability standard** - done requires: {specific observable evidence}
<a name="REQ-STR-18"></a>
**REQ-STR-18** `advisory` `continuous` `soft` `all`
4. Gate authority - {who or what determines work is done; for ESE-governed repos, ESE compliance is the gate - per §1.4}.

4. **Gate authority** - {who or what determines work is done; for ESE-governed repos, ESE compliance is the gate - per [§1.4](../STANDARDS.md#14-project-first-principles)}
5. **Speed vs. consistency** - {which wins and why}
6. **Human approval boundary** - requires explicit human approval: {list specific action types - e.g., production deploy, schema migration, credential change}
7. **Monitoring requirement** - {how production features are confirmed working}
8. **Documentation standard** - {your project's documentation expectations}

---

## Component Capabilities Declaration

> [§5-§9 Activation](../STANDARDS.md): Declare which capabilities this project has. Requirements in sections 5-9 activate based on these declarations. Update when project scope changes.

| Capability | Present? | Relevant sections |
|-----------|----------|-------------------|
| Has runtime service (always-on process) | No | §5.4, §5.9, §7.1, §7.2, §7.5, §7.6 |
| Deploys to production environment | No | §5.5, §5.7, §7.4 |
| Exposes API consumed by other systems | No | §5.8 |
| Has database or persistent storage | No | §5.4 (restart safety) |
| Manages infrastructure (servers, cloud) | No | §5.6 |
| Handles sensitive or personal data | No | §5.10, §6.5 |
| Has external users or consumers | No | §8.5 |
| Produces user-visible output | No | §6.3 |
| Has declared runtime dependencies | No | §5.2 |
| Has multiple repositories | No | §5.3 |
| Contains logic code (branching, looping, error handling) | No | §6.1 |

> **Adopter action:** flip each Present? cell from No to Yes for every capability your project actually has. Each Yes activates the requirements listed under Relevant sections. The YAML applicability frontmatter at the top of this file must match: a Yes here requires `true` for the corresponding `capabilities.*` key, enforced by `lint-standards-application-frontmatter.sh` Tier 2.

---

## Named Owner

> [§2.4](../STANDARDS.md#24-shared-ownership): every project and every service in production has a named owner discoverable without asking anyone.

**Project owner:** {team or individual}
**How to reach them:** {channel or contact}

---

## Roadmap and Phase Definitions

> [§1.3](../STANDARDS.md#13-roadmap-discipline): for any project with more than one planned release, define what is in each phase before starting Phase 1.

| Phase | Deliverables | Milestone condition | Decision point | Dependencies |
|-------|-------------|--------------------| --------------|--------------|
| Phase 1 | | | | |

*If single-phase or not yet planned: note that here.*

---

## Components Lacking Architecture Docs

> [§3.3](../STANDARDS.md#33-architecture-doc-backlog): no further changes to a component that lacks an architecture doc until that doc exists or an issue is filed. File the issue, then continue.

| Component | Status | Evidence | Last verified | Issue | Notes |
|-----------|--------|----------|---------------|-------|-------|
| {Component name} | Compliant / Gap | {link to arch doc} | YYYY-MM-DD | {issue ID if gap} | |

---

## Service Health Check Status

> [§7.1](../STANDARDS.md#71-service-health-checks): every always-on service has a meaningful health check, visible on a monitoring page, time-stamped, and alerting when silent.

| Service | Health check | Alert configured | Monitoring dashboard | Evidence | Last verified |
|---------|-------------|-----------------|---------------------|----------|---------------|
| {Service name} | yes/no | yes/no | {URL} | {link to health check config} | YYYY-MM-DD |

---

## SLO Definitions

> [§7.5](../STANDARDS.md#75-service-level-objectives): every always-on capability defines at least one SLI and SLO. Template: [templates/slo.md](../templates/slo.md).

| Service | SLO defined | SLO doc | Error budget status | Evidence | Last verified |
|---------|------------|---------|-------------------|----------|---------------|
| {Service name} | yes/no | {link} | On track / At risk / Exhausted | {link to SLO definition} | YYYY-MM-DD |

---

## Delivery Health Metrics

> [§7.4](../STANDARDS.md#74-delivery-health): track DORA metrics for every service in active development. If health worsens over two consecutive review periods, reduce change size and strengthen testing before resuming feature work.

| Metric | Current | Target | Trend | Last reviewed |
|--------|---------|--------|-------|--------------|
| Deployment frequency | | | Improving / Stable / Declining | |
| Lead time for changes | | | Improving / Stable / Declining | |
| Change failure rate | | | Improving / Stable / Declining | |
| Time to restore service | | | Improving / Stable / Declining | |

> When Trend is Declining for two consecutive review periods: stop feature work, reduce change size, strengthen testing per [§7.4](../STANDARDS.md#74-delivery-health). File an A3 ([§8.7](../STANDARDS.md#87-a3-structured-problem-solving)) or Kaizen event.

---

## Active Improvement Initiatives

> [§8.7](../STANDARDS.md#87-a3-structured-problem-solving): track active A3 structured problem solving initiatives here.

| A3 Title | Path | Stage | Target metric | Verification date | Status |
|----------|------|-------|--------------|-------------------|--------|
| {title} | {link to A3 document} | Current State / Root Cause / Countermeasures / Implementation / Follow-Up | {metric} | YYYY-MM-DD | Active / Complete / Abandoned |

---

## Current Testing Gaps

<a name="REQ-STR-19"></a>
**REQ-STR-19** `advisory` `continuous` `soft` `all`
§6.2: P0 and P1 gaps block shipping the affected feature.

> [§6.2](../STANDARDS.md#62-testing-gap-audit): P0 and P1 gaps block shipping the affected feature. Audit at the start of any significant feature phase. Include all applicable [addenda](../STANDARDS.md#addenda) Testing Gap Audit items in this table - each addendum ends with a Testing Gap Audit Additions table; these are required rows when the addendum applies.

| Gap | Affected feature | Impact | Priority | Issue | Evidence (when resolved) | Resolved date |
|-----|-----------------|--------|----------|-------|-------------------------|---------------|
| {Gap description} | {feature} | {impact} | P0/P1/P2 | {issue ID} | {link to fix when closed} | YYYY-MM-DD |

---

## Technology Decisions Lacking ADRs

> [§9.2](../STANDARDS.md#92-technology-adr-backlog): every significant technology decision in active use that was made without a formal ADR needs one. File an issue for each - the issue unblocks continued work while the ADR gets written.

| Decision | Status | Evidence | Last verified | Issue |
|----------|--------|----------|---------------|-------|
| {Technology or architectural choice} | Documented / Session notes only / Undocumented | {link to ADR} | YYYY-MM-DD | {issue ID if gap} |

---

## User Feedback Mechanism

<a name="REQ-STR-20"></a>
**REQ-STR-20** `advisory` `continuous` `soft` `all`
§2.7: every project must define how users report problems, how reports enter the work item system, and how users are notified when feedback is acte...

> [§2.7](../STANDARDS.md#27-user-feedback): every project must define how users report problems, how reports enter the work item system, and how users are notified when feedback is acted on.

- **How users report problems or requests:** {channel}
- **How reported items enter the work item system:** {process}
- **How users are notified when feedback is acted on:** {mechanism}

---

## Technical Debt Tracking

<a name="REQ-STR-21"></a>
**REQ-STR-21** `advisory` `continuous` `soft` `all`
§8.6: technical debt acknowledged in ADRs, post-mortems, or code comments must be tracked as work items.

> [§8.6](../STANDARDS.md#86-technical-debt-tracking): technical debt acknowledged in ADRs, post-mortems, or code comments must be tracked as work items. Periodically audit accumulated debt and prioritize paydown.

| Debt item | Source (ADR, post-mortem, code comment) | Work item | Priority | Status |
|-----------|---------------------------------------|-----------|----------|--------|
| {description} | {link to source} | {issue ID} | P0-P3 | Open / Resolved |

---

## Incident Communication Channel

> [§8.5](../STANDARDS.md#85-incident-communication): define the user communication channel before the first incident occurs. Discovering during an outage that there is no way to tell users about it compounds the problem.

**Channel:** {status page URL / email list / in-product banner / other}
**Who is notified:** {end users / internal stakeholders / both}
**Who is authorized to post:** {named individuals or role}
**Template for incident updates:** {link or inline template for "what is happening, impact, expected resolution"}

---

## Lessons-Learned Registry

> [§8.3](../STANDARDS.md#83-lessons-learned-registry): specific observations from specific incidents. Consult before starting any new feature. Add after every post-mortem. Full starter file: [starters/lessons-learned-registry.md](lessons-learned-registry.md).

| Date | What happened | What we do differently now | Source post-mortem |
|------|--------------|---------------------------|-------------------|
| | | | |

---

## Anti-Pattern Registry

> [§8.4](../STANDARDS.md#84-anti-pattern-registry): named practices that look correct but consistently cause problems in this system. Add when a pattern recurs or a single severe incident reveals it. Full starter file: [starters/anti-pattern-registry.md](anti-pattern-registry.md).

| Name | Why it looks right | Why it fails here | First surfaced |
|------|--------------------|-------------------|----------------|
| | | | |

---

## New Person Readiness

> [§2.3](../STANDARDS.md#23-definition-of-done): before closing any significant work item, verify a new person could do each of the following using only the documentation.

- [ ] Find this feature
- [ ] Understand what it does and why it exists
- [ ] Set it up and run it locally without asking anyone
- [ ] Debug a failure without access to the original author
- [ ] Safely extend or modify it

*Last checked: {date}*

---

## Applicable Addenda

> First-party addenda extend ESE for specific contexts. Apply every addendum that matches this project's context - in addition to, not instead of, the universal standard. Per [Addenda section](../STANDARDS.md#addenda).

| Addendum | Applies? | Compliance notes |
|----------|---------|-----------------|
| Multi-Service Architectures | no | |
| Multi-Team Organizations | no | |
| Web Applications | no | |
| Containerized and Orchestrated Systems | no | |
| AI and ML Systems | no | |
| Event-Driven Systems | no | |
| Agent-Assisted Development | no | |
| Continuous Improvement | no | |

> **Adopter action:** flip each Applies? cell from no to yes for every addendum that matches your project's context. Each yes activates an overlay of extra requirements on top of the base standard. The YAML applicability frontmatter at the top of this file must match: a yes here requires `true` for the corresponding `addenda.*` key, enforced by `lint-standards-application-frontmatter.sh` Tier 2. The addendum files live in the vendored ESE submodule under `docs/addenda/`; reference those for the full REQ list each addendum adds.

For contexts not covered by first-party addenda (PCI DSS, HIPAA, SOC 2, etc.): create a project-specific addendum in your own `docs/addenda/` directory and link it here.

---

## §4.1 Template Compliance Verification Mode

> [§4.1](../STANDARDS.md#41-what-must-be-documented), REQ-4.1-02, REQ-4.1-03: projects using templates must verify that instances conform to their template's required sections, and must document the verification mode chosen.

**Verification mode:** automated, via `scripts/lint-template-compliance.sh` (vendored from ESE's `starters/linters/` pack) wired into CI (see `.github/workflows/ci.yml`) and the pre-commit hook (`scripts/pre-commit`). The linter reads `scripts/template-instance-mappings.txt` and checks every declared instance against its template's non-optional sections.

**REQ-4.1-02 status:** (adopter fills in: Compliant / Gap, with evidence)
**REQ-4.1-03 status:** (adopter fills in: Compliant / Gap, with evidence; this section itself is the evidence that the mode is documented)

> **Adopter action:** if your project prefers compliance-review mode instead (manual review on cadence rather than automated CI), change the mode here and in the YAML frontmatter `template-compliance.mode` field. The linter enforces that both match.

---

## FMEA Thresholds

<a name="REQ-STR-53"></a>
**REQ-STR-53** `artifact` `continuous` `hard` `all`
The project's FMEA RPN threshold and severity threshold are documented.

> [§2.1](../STANDARDS.md#21-the-lifecycle): ESE defaults are RPN threshold 75 and severity threshold 7 (REQ-2.1-48). Override below with rationale if your project requires different thresholds.

**RPN threshold:** 75
**Severity threshold:** 7

> **Adopter action:** if your project requires different thresholds (e.g., safety-critical domain dropping RPN to 50 or severity to 6), change the values here AND the corresponding `fmea.rpn-threshold` / `fmea.severity-threshold` fields in the YAML frontmatter at the top of this file. Add a rationale as a prose paragraph below the threshold lines. The linter enforces that YAML and prose match.

---

*Standard version applied: {X.Y.Z}*
*Last updated: YYYY-MM-DD*
*Compliance review cadence: every-significant-release*
*Last compliance review: YYYY-MM-DD*
*Next compliance review: next-significant-release*
