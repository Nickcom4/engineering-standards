---
# Machine-readable applicability summary for ESE's self-application.
# This block is validated by scripts/lint-standards-application-frontmatter.sh
# against the prose tables in this file and against the rest of the repo
# (enforcement-spec.yml, req-manifest.sha256, CHANGELOG.md version headings).

ese-version: "2.19.0"
last-updated: "2026-04-29"

owner:
  name: "Nick Baker"
  contact: "GitHub repo owner"

compliance-review:
  cadence: "every-significant-release"
  last-review-date: "2026-04-14"
  next-review-trigger: "next-significant-release"

capabilities:
  has-runtime-service: false
  deploys-to-production: false
  exposes-api: false
  has-persistent-storage: false
  manages-infrastructure: false
  handles-sensitive-data: false
  has-external-users: false
  produces-user-visible-output: false
  has-runtime-dependencies: false
  has-multiple-repositories: false
  contains-logic-code: true

addenda:
  multi-service: false
  multi-team: false
  web-applications: false
  containerized: false
  ai-ml: false
  event-driven: false
  agent-assisted-development: true
  continuous-improvement: false

template-compliance:
  mode: "automated"
  evidence: "scripts/lint-template-compliance.sh"

fmea:
  rpn-threshold: 75
  severity-threshold: 7
---

# Excellence Standards - Engineering - Standards Application

> This document applies the [Excellence Standards - Engineering (ESE)](../STANDARDS.md) to ESE itself. It captures current state, known gaps, and project-specific constraints. Update it when gaps close or requirements change.
>
> The YAML frontmatter above is the machine-readable summary of this document's structured claims (version pin, owner, capabilities, applicable addenda, template-compliance mode, FMEA thresholds, review cadence). Prose sections below are the human-readable rationale; they must stay consistent with the frontmatter. The `scripts/lint-standards-application-frontmatter.sh` linter enforces both presence/types and claim-vs-reality consistency against `enforcement-spec.yml` and `CHANGELOG.md`.

---


## Table of Contents

- [Project First Principles](#project-first-principles)
- [Naming Conventions and Directory Layout](#naming-conventions-and-directory-layout)
- [Component Capabilities Declaration](#component-capabilities-declaration)
- [Named Owner](#named-owner)
- [Roadmap and Phase Definitions](#roadmap-and-phase-definitions)
- [Components Lacking Architecture Docs](#components-lacking-architecture-docs)
- [Service Health Check Status](#service-health-check-status)
- [SLO Definitions](#slo-definitions)
- [Delivery Health Metrics](#delivery-health-metrics)
- [Current Testing Gaps](#current-testing-gaps)
- [Technology Decisions Lacking ADRs](#technology-decisions-lacking-adrs)
- [Lessons-Learned Registry](#lessons-learned-registry)
- [Anti-Pattern Registry](#anti-pattern-registry)
- [New Person Readiness](#new-person-readiness)
- [User Feedback Mechanism](#user-feedback-mechanism)
- [Incident Communication Channel](#incident-communication-channel)
- [Technical Debt Tracking](#technical-debt-tracking)
- [Active Improvement Initiatives](#active-improvement-initiatives)
- [Applicable Addenda](#applicable-addenda)
- [§5.3 Multi-Repository Coordination](#53-multi-repository-coordination)
- [§5.8 API Versioning](#58-api-versioning)
- [§4.1 Template Compliance Verification Mode](#41-template-compliance-verification-mode)
- [§4.3 Changelog Compliance](#43-changelog-compliance)
- [FMEA Thresholds](#fmea-thresholds)

## Project First Principles

> [§1.4](../STANDARDS.md#14-project-first-principles)

1. **Scope statement** - ESE is a universal engineering standard defining software delivery requirements (process, documentation, quality, testing, monitoring, incident response). Built to ISO-equivalent rigor for self-verification. Not an ISO QMS, not a certification path, not a technology-specific checklist. See §1 scope statement.
2. **Source of truth** - for tasks: a private tracked work item system; for knowledge: this repo; for state: CHANGELOG.md and git history.
3. **Verifiability standard** - done requires: documentation VERIFY checklist passes (§2.1), CHANGELOG updated, committed atomically, pushed to origin.
4. **Gate authority** - the standard's owner (Nick Baker) reviews all changes before merge. ESE is the one context where human review is always required. Per STANDARDS.md §5.1, self-review is acceptable for solo work and must be documented: git commit messages and CHANGELOG entries serve as the self-review record for routine changes.
5. **Speed vs. consistency** - consistency wins. A rushed standard change propagates errors to every project that adopts it.
6. **Human approval boundary** - all changes to STANDARDS.md, addenda, and ADRs require explicit review.
7. **Monitoring requirement** - not applicable (no always-on service). The CHANGELOG and git log serve as the audit trail.
8. **Documentation standard** - every STANDARDS.md change must have: an ADR for decisions involving evaluated alternatives, a CHANGELOG entry, and a [docs/background.md](background.md) update if research was involved.

---

## Naming Conventions and Directory Layout

> [ADR-021 D9](decisions/ADR-021-discover-as-intake-stage-and-work-item-system-acknowledgment.md): naming scheme, intake log status, and §2.2-compliant system status.

**Numbering scheme:** ESE's existing ADRs (ADR-001 through ADR-021) use sequential numbering (retained as-is; migration cost is not warranted for established history). All new ADRs in ESE use date-based naming (e.g., ADR-2026-03-25-ese-machine-readable-first-format.md). Date-based is the sole convention for new projects per [starters/repo-structure.md](../starters/repo-structure.md).

**Intake log:** N/A. ESE uses a private tracked work item system for signal capture and triage. The [starters/intake-log.md](../starters/intake-log.md) template applies to projects without a compliant tracked system.

---

## Component Capabilities Declaration

> [§5-§9 Activation](../STANDARDS.md): Capabilities present in this project. Requirements in sections 5-9 activate based on these declarations.

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
| Contains logic code (branching, looping, error handling) | Yes | §6.1 |

ESE is a standard document repository. The only logic code is in `scripts/`. §5-§9 service and deployment requirements are not activated. §6.1 applies to the CI scripts.

---

## Named Owner

> [§2.4](../STANDARDS.md#24-shared-ownership)

**Project owner:** Nick Baker
**How to reach them:** GitHub repo owner

---

## Roadmap and Phase Definitions

> [§1.3](../STANDARDS.md#13-roadmap-discipline)

Single-phase. ESE evolves through versioned releases, not planned phases. Each change follows the full lifecycle.

---

## Components Lacking Architecture Docs

> [§3.3](../STANDARDS.md#33-architecture-doc-backlog)

Not applicable for product components. ESE has no product software components.

Note: The CI scripts under `scripts/` constitute a software component with logic, dependencies, and failure modes (current count tracked by `lint-count-congruence.sh` against the generator source; historical counts are in the CHANGELOG). Testing gap for CI scripts tracked in Current Testing Gaps table.

---

## Service Health Check Status

> [§7.1](../STANDARDS.md#71-service-health-checks)

Not applicable. ESE is not an always-on service.

---

## SLO Definitions

> [§7.5](../STANDARDS.md#75-service-level-objectives)

Not applicable.

---

## Delivery Health Metrics

> [§7.4](../STANDARDS.md#74-delivery-health)

DORA service metrics are not applicable (no deployable service). Work item cycle time is tracked via git log and CHANGELOG. Quality is tracked through the incident registries and CHANGELOG.

---

## Current Testing Gaps

> [§6.2](../STANDARDS.md#62-testing-gap-audit)

| Gap | Affected feature | Impact | Priority | Issue | Evidence (when resolved) | Resolved date |
|-----|-----------------|--------|----------|-------|-------------------------|---------------|
| No automated link validation | All internal cross-references in STANDARDS.md | Broken links not caught until manual review | P2 | - | CI Check 3: Markdown link check (internal links) in `.github/workflows/ci.yml` | 2026-03-23 |
| No automated typographic indicator check | All markdown files | AI-generated characters not caught until manual review | P3 | - | CI Check 1: covers Unicode em dash (U+2014), Unicode en dash (U+2013), and ASCII double-hyphen sentence dashes. Full corpus cleanup completed. | 2026-04-08 |
| Branch protection not configured on GitHub repo | CI quality gate enforcement | CI checks are advisory only; merges not blocked by the gate | P2 | File a GitHub Issue to configure branch protection rules requiring CI checks to pass before merge | | |
| CI scripts lack unit tests | All bash scripts under `scripts/` | Logic bugs in CI checks not caught before execution | P3 | - | | |

---

## Technology Decisions Lacking ADRs

> [§9.2](../STANDARDS.md#92-technology-adr-backlog)

None identified. See `docs/decisions/` for all ADRs.

---

## Lessons-Learned Registry

> [§8.3](../STANDARDS.md#83-lessons-learned-registry)

Full registry at [docs/incidents/lessons-learned.md](incidents/lessons-learned.md).

---

## Anti-Pattern Registry

> [§8.4](../STANDARDS.md#84-anti-pattern-registry)

Full registry at [docs/incidents/anti-patterns.md](incidents/anti-patterns.md).

---

## New Person Readiness

> [§2.3](../STANDARDS.md#23-definition-of-done)

- [x] Find this standard - README.md
- [x] Understand what it does and why - STANDARDS.md intro + [docs/background.md](background.md)
- [x] Set it up locally - `git clone` (no build step)
- [x] Debug a failure - incident registries document known patterns
- [x] Safely extend or modify - ADRs document all structural decisions; CHANGELOG documents all changes

*Last checked: 2026-03-24*

---

## User Feedback Mechanism

> [§2.7](../STANDARDS.md#27-user-feedback): every project must define all five required elements: signal capture format, intake channel, triage cadence, promotion path to work items, and user notification.

1. **How signals are captured** (intake record format and filing location): GitHub Issues for external adopters; filed via the private tracked work item system for internal engineering gaps found during ESE application sessions. Intake log (starters/intake-log.md) is N/A; the private tracked work item system is used.
2. **Where intake records accumulate before triage** (intake channel): GitHub Issues queue (external); the private tracked system's open queue (internal). Both reviewed per triage cadence.
3. **Triage cadence**: Per session for internal gaps (immediate promotion to tracked work item). GitHub Issues reviewed at each minor or major release cycle.
4. **How confirmed problems are promoted to work items**: Internal: filed via the tracked work item system with §2.2 attributes immediately. External: GitHub Issue triaged and filed as tracked work item at next review cycle.
5. **How users are notified when feedback is acted on**: CHANGELOG entry with version number at next release; originating GitHub Issue closed with reference to the CHANGELOG version that resolved it.

**Intake log:** N/A. The compliant private tracked work item system is used; intake records live in that tracked system.

**§2.2-compliant system:** The work item system for ESE is private and operator-local. It captures all 8 §2.2 attributes, lifecycle status, and gate evidence. ADR-019 export obligation: closed work item records are backed up to a private repository at session end. Committed exports to this public repository per [templates/work-item-export.md](../templates/work-item-export.md) are stored in `docs/work-items/`.

---

## Incident Communication Channel

> [§8.5](../STANDARDS.md#85-incident-communication)

ESE has experienced documentation-quality incidents (em-dash contamination, broken links, adopter-specific references). These are tracked in docs/incidents/lessons-learned.md.

Compliant. ESE is a documentation standard with no runtime service. For corrections that break backward compatibility or require adopters to change their process, the communication channel is: CHANGELOG major or minor version entry with explicit "Breaking change" or "Action required" annotation, published with the release. No separate status page or incident channel is warranted at the current adoption scale.

---

## Technical Debt Tracking

> [§8.6](../STANDARDS.md#86-technical-debt-tracking): technical debt acknowledged in ADRs, post-mortems, or code comments must be tracked as work items. Periodically audit accumulated debt and prioritize paydown.

| Debt item | Source | Priority | Status |
|-----------|--------|----------|--------|
| No current open debt items | - | - | - |

*Note: The branch protection configuration gap is tracked in the Current Testing Gaps table above. Technical debt for ESE is primarily documentation quality gaps - these are tracked as work items at creation and resolved within the same or next release cycle.*

---

## Active Improvement Initiatives

> [§8.7](../STANDARDS.md#87-a3-structured-problem-solving): track active A3 structured problem-solving initiatives here. A3s are used for recurring quality issues or delivery bottlenecks; ESE improvement is tracked through compliance review sessions and CHANGELOG releases rather than formal A3 initiatives.

| A3 Title | Path | Stage | Target metric | Status |
|----------|------|-------|--------------|--------|
| None active | - | - | - | - |

---

## Applicable Addenda

> [Addenda section](../STANDARDS.md#addenda)

| Addendum | Applies? | Notes |
|----------|---------|-----------------|
| Multi-Service Architectures | No | Single repo, no service communication |
| Multi-Team Organizations | No | Single owner |
| Web Applications | No | No browser-rendered interface |
| Containerized and Orchestrated Systems | No | No containers |
| AI and ML Systems | No | No ML models |
| Event-Driven Systems | No | No event brokers |
| Agent-Assisted Development | Yes | AI coding agents hold commit authority in this repository (primary maintainer posture). Posture declared in CLAUDE.md and AGENTS.md at repo root. Commit-authority scope: feature branches with gate-authority review required before protected-branch merge. Sandbox posture: devcontainer-equivalent (session-scoped; no persistent credentials). The 10 REQ-ADD-AAD-NN requirements in [docs/addenda/agent-assisted-development.md](addenda/agent-assisted-development.md) are adopted. |
| Continuous Improvement | No | No recurring quality issues requiring formal Lean/Six Sigma methods |

---

## §5.3 Multi-Repository Coordination

> [§5.3](../STANDARDS.md#53-multi-repository-coordination)

Breaking ESE changes can affect adopter submodules. Impact tracked via CHANGELOG "Breaking change" annotations.

---

## §5.8 API Versioning

> [§5.8](../STANDARDS.md#58-api-versioning-and-compatibility)

REQ-ID schema and enforcement-spec.yml are consumed interfaces. Versioning tracked via CHANGELOG semver.

---

## §4.1 Template Compliance Verification Mode

> [§4.1](../STANDARDS.md#41-what-must-be-documented), REQ-4.1-02, REQ-4.1-03: projects using templates must verify that instances conform to their template's required sections, and must document the verification mode chosen.

**Verification mode:** automated, via `scripts/lint-template-compliance.sh` wired as CI Check 32 (see `.github/workflows/ci.yml`) and in the `scripts/pre-commit` hook. The linter reads `scripts/template-instance-mappings.txt` and checks every declared instance against its template's non-optional sections. Sections marked `<!-- optional -->` in templates are exempt; instances can document intentional omissions via `<!-- omit-section: Name -->` or whole-file exemption via `<!-- template-compliance: historical-exempt -->`. Coverage: 10 of 15 templates with living instances in ESE. The remaining 5 templates (a3, post-mortem, slo, tech-eval, work-item) have zero instances in ESE and can only be covered in adopter repos via the ese-starter-owned `scripts/lint-template-compliance.sh` (the parameterized adopter-portable version; canonical per ADR-2026-04-24).

**REQ-4.1-02 status:** Compliant. The linter passes on every commit and runs as a gating CI check.
**REQ-4.1-03 status:** Compliant. Verification mode is automated, documented here, and cross-referenced in the compliance review template.

---

## §4.3 Changelog Compliance

STANDARDS.md lives in a git repo alongside other files. Per §4.3: changelog is in `CHANGELOG.md` at repo root, not inline in STANDARDS.md. No inline changelog exists in STANDARDS.md. Compliance confirmed.

---

## FMEA Thresholds

> [§2.1](../STANDARDS.md#21-the-lifecycle), REQ-2.1-48: ESE defaults are RPN threshold 75 and severity threshold 7.

**RPN threshold:** 75 (ESE default; no override needed for a documentation standard)
**Severity threshold:** 7 (ESE default)

---

*Standard version applied: 2.19.0*
*Last updated: 2026-04-29*
*Compliance review cadence: every significant release*
*Last compliance review: 2026-04-14 (v2.7.0 bidirectional flow with ese-starter: back-ported lint-release-existence.sh from ese-starter v1.3.0 as CI Check 36 so upstream-vendoring adopters get the same release-discipline gate as bootstrap-adopted repos; closed the ese-starter adoption arc work item as a work-item-export)*
*Next compliance review: next significant release (v2.7.0 or later)*
