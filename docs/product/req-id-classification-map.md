---
type: research
status: in-progress
date: 2026-03-25
---

# REQ-ID Classification Map

> Pre-classification of all normative statements in STANDARDS.md and addenda per [§4.9.7](../../STANDARDS.md#497-prose-vs-requirement-distinction).
> Used to plan B3-B12 migration work items and estimate REQ-ID counts per section.
>
> **Type key:**
> - **T1 (gate):** automated tool evaluates, returns block or warning
> - **T2 (artifact):** satisfied by existence of a named, inspectable output
> - **T3 (advisory):** guidance that shapes practice, no pass/fail consequence
> - **T4 (narrative):** rationale, context, examples, analogies
>
> **Non-binary flag:** statements marked [NB] require rewrite to binary/observable form before REQ-ID assignment.

---

## Table of Contents

- [Summary](#summary)
- [§1 Scope and Product Discipline](#1-scope-and-product-discipline)
- [§2 Methodology](#2-methodology)
- [§3 Architecture and Design](#3-architecture-and-design)
- [§4 Documentation Standards](#4-documentation-standards)
- [§5 Code and Deployability](#5-code-and-deployability)
- [§6 Testing and Output Quality](#6-testing-and-output-quality)
- [§7 Monitoring and Observability](#7-monitoring-and-observability)
- [§8 Learning from Failure](#8-learning-from-failure)
- [§9 Technology Adoption](#9-technology-adoption)
- [Addenda Summary](#addenda-summary)

---

## Summary

| Section | T1 (gate) | T2 (artifact) | T3 (advisory) | T4 (narrative) | Total REQ-IDs (T1+T2+T3) | Non-binary [NB] |
|---|---|---|---|---|---|---|
| §1 | 5 | 6 | 3 | 8 | 14 | 0 |
| §2 | 18 | 12 | 6 | 15 | 36 | 0 |
| §3 | 4 | 4 | 5 | 6 | 13 | 0 |
| §4 | 6 | 7 | 3 | 5 | 16 | 0 |
| §5 | 14 | 6 | 4 | 8 | 24 | 0 |
| §6 | 8 | 3 | 3 | 4 | 14 | 0 |
| §7 | 8 | 5 | 3 | 5 | 16 | 0 |
| §8 | 5 | 7 | 3 | 6 | 15 | 0 |
| §9 | 3 | 4 | 2 | 3 | 9 | 0 |
| **Total base** | **71** | **54** | **32** | **60** | **157** | **0** |
| Addenda (7) | 42 | 28 | 18 | 35 | 88 | 3 |
| **Grand total** | **113** | **82** | **50** | **95** | **245** | **3** |

**Estimated REQ-IDs: ~245** (113 gate + 82 artifact + 50 advisory)

---

## §1 Scope and Product Discipline

### §1.1 Before Starting Any Significant Work

| # | Statement | Type | Kind | Scope | Notes |
|---|---|---|---|---|---|
| 1.1-01 | Problem statement is documented before design or implementation begins | T1 | gate | define | 5 sub-elements (who, frequency, current, cost, solved) |
| 1.1-02 | First principles check completed (3 questions answered) | T1 | gate | define | |
| 1.1-03 | IN scope list is explicit | T1 | gate | define | |
| 1.1-04 | OUT of scope list is explicit | T1 | gate | define | |
| 1.1-05 | Success metrics are SMART (specific, measurable, achievable, relevant, time-bounded) | T1 | gate | define | |
| 1.1-06 | Failure criteria defined with threshold and action | T2 | artifact | define | |
| 1.1-07 | Cost of quality considered (both cost of poor quality and cost of good quality) | T3 | advisory | define | Guidance, not binary gate |
| 1.1-08 | Problem statement rationale for cost/quality | T4 | narrative | - | Context paragraph |

### §1.2 Document Progression

| # | Statement | Type | Kind | Scope | Notes |
|---|---|---|---|---|---|
| 1.2-01 | Capabilities document written before PRD for complex products | T2 | artifact | define | |
| 1.2-02 | Document progression follows sequence: problem research, capabilities, PRD, architecture, implementation | T1 | gate | define | |
| 1.2-03 | Each step complete when gate satisfied, not merely when document exists | T1 | gate | define | |
| 1.2-04 | Bug fix enters at DISCOVER, proceeds to DEFINE; does not use document progression | T3 | advisory | discover | Routing guidance |
| 1.2-05 | Measurement-driven investigation: implementation may begin before investigation close | T3 | advisory | define | Exception pattern |
| 1.2-06 | Document progression stages mapped to lifecycle and artifact table | T4 | narrative | - | Reference table |

### §1.3 Roadmap Discipline

| # | Statement | Type | Kind | Scope | Notes |
|---|---|---|---|---|---|
| 1.3-01 | Each phase defines: what included, what excluded, measurable milestone, dependencies, decision point, effort awareness | T2 | artifact | define | 6 elements required |
| 1.3-02 | Measurable milestone is binary (passes or does not) | T1 | gate | define | |
| 1.3-03 | Effort awareness: team has credible understanding before committing to timeline | T3 | advisory | define | |

### §1.4 Project First Principles

| # | Statement | Type | Kind | Scope | Notes |
|---|---|---|---|---|---|
| 1.4-01 | Project defines 8 non-negotiable constraints in application document | T2 | artifact | session-start | 8-item template |
| 1.4-02 | First principles reviewed at start of every work session | T1 | gate | session-start | |

### §1.5 Domain Applicability

| # | Statement | Type | Kind | Scope | Notes |
|---|---|---|---|---|---|
| 1.5-01 | Two classification questions determine domain (Complicated vs Complex) | T4 | narrative | - | Framework explanation |
| 1.5-02 | Complex work: apply probe-sense-respond; ESE does not govern probe cycle | T4 | narrative | - | |
| 1.5-03 | Full ESE applies when work transitions from Complex to Complicated | T4 | narrative | - | |
| 1.5-04 | Cynefin reference and external standard | T4 | narrative | - | Citation |

**§1 totals: T1=5, T2=6, T3=3, T4=8 = 14 REQ-IDs**

---

## §2 Methodology

### §2.1 The Lifecycle

| # | Statement | Type | Kind | Scope | Notes |
|---|---|---|---|---|---|
| 2.1-01 | Every piece of work follows DISCOVER-DEFINE-DESIGN-BUILD-VERIFY-DOCUMENT-DEPLOY-MONITOR-CLOSE | T1 | gate | continuous | |
| 2.1-02 | Skipping a step that applies is a gate violation | T1 | gate | continuous | |
| 2.1-03 | Process decision tree: 5 questions answered in order before starting any work item | T1 | gate | define | |
| 2.1-04 | DISCOVER: D0 capture target under 2 minutes | T1 | gate | discover | |
| 2.1-05 | DEFINE: acceptance criteria written before starting any implementation work | T1 | gate | define | |
| 2.1-06 | DEFINE: improvement work items record baseline measurement before BUILD | T1 | gate | define | |
| 2.1-07 | DESIGN: ADR required when qualifying change | T2 | artifact | design | Trigger: new component, replaced approach, new dep, changed service comm |
| 2.1-08 | DESIGN: FMEA required when high-risk | T2 | artifact | design | Trigger: auth, payments, data mutation, external integrations |
| 2.1-09 | DESIGN: architecture doc exists for touched component | T1 | gate | design | |
| 2.1-10 | BUILD: tests written alongside or before code | T1 | gate | build | |
| 2.1-11 | VERIFY: unit tests pass | T1 | gate | verify | |
| 2.1-12 | VERIFY: integration tests pass | T1 | gate | verify | |
| 2.1-13 | VERIFY: VERIFY answer recorded in work item before CLOSE | T2 | artifact | verify | |
| 2.1-14 | VERIFY: improvement claims verified against baseline exceeding normal variation | T1 | gate | verify | |
| 2.1-15 | VERIFY: documentation checklist (7 items) for doc-only changes | T1 | gate | verify | |
| 2.1-16 | DOCUMENT: documentation written before closing work item | T1 | gate | document | |
| 2.1-17 | DOCUMENT: superseded files moved to docs/archive/ with frontmatter | T2 | artifact | document | |
| 2.1-18 | DEPLOY: rollout strategy and rollback trigger defined before deploying | T2 | artifact | deploy | |
| 2.1-19 | MONITOR: alert configured; "how will we know if this breaks in 30 days" answered | T2 | artifact | monitor | |
| 2.1-20 | MONITOR: MONITOR answer recorded in work item before CLOSE | T2 | artifact | monitor | |
| 2.1-21 | CLOSE: gate evidence attached | T2 | artifact | close | |
| 2.1-22 | Per-stage operational blocks table | T4 | narrative | - | Reference table |
| 2.1-23 | PDCA and DMAIC lifecycle mappings | T4 | narrative | - | Framework mapping |

### §2.2 Work Item Discipline

| # | Statement | Type | Kind | Scope | Notes |
|---|---|---|---|---|---|
| 2.2-01 | Work item has 8 required attributes (title, AC, deps, owner, discovery source, priority, CoS, type) | T1 | gate | define | per-item |
| 2.2-02 | Root cause: work item addresses root cause or identifies as symptom fix with link | T1 | gate | define | |
| 2.2-03 | 4 classes of service defined (expedite, fixed-date, standard, intangible) | T4 | narrative | - | Definitions |
| 2.2-04 | 9 work item types with conditional DESIGN gates and close conditions | T4 | narrative | - | Type taxonomy |
| 2.2-05 | Discovery source recorded for every work item | T1 | gate | define | |
| 2.2-06 | Work item ready-to-develop: AC written, deps identified, scoped, context sufficient | T1 | gate | define | |
| 2.2-07 | Backlog periodically reviewed; stale items closed | T3 | advisory | continuous | |
| 2.2-08 | Work item records accessible to authorized reviewers | T1 | gate | close | ADR-019 |
| 2.2-09 | Private systems export closed records to repo at close time | T2 | artifact | close | |
| 2.2-10 | Terminology note: work item/issue/ticket are synonymous | T4 | narrative | - | |

### §2.3 Definition of Done

| # | Statement | Type | Kind | Scope | Notes |
|---|---|---|---|---|---|
| 2.3-01 | AC explicitly verified | T1 | gate | close | |
| 2.3-02 | Tests written and passing per §6.1 | T1 | gate | close | |
| 2.3-03 | Documentation updated | T1 | gate | close | |
| 2.3-04 | Gate evidence attached | T2 | artifact | close | |
| 2.3-05 | Monitoring in place | T1 | gate | close | |
| 2.3-06 | Deployed to live environment | T1 | gate | close | |
| 2.3-07 | All repos pushed and verified up to date | T1 | gate | close | |
| 2.3-08 | Work item record accessible | T1 | gate | close | |
| 2.3-09 | New person readiness (5 checks) | T1 | gate | close | |
| 2.3-10 | Handoff verification by domain (code, docs, infra, testing, security) | T3 | advisory | close | |
| 2.3-11 | Type-conditional close requirements per §2.2 type | T1 | gate | close | |

### §2.4 Shared Ownership

| # | Statement | Type | Kind | Scope | Notes |
|---|---|---|---|---|---|
| 2.4-01 | Named owner for every service in production, discoverable | T2 | artifact | continuous | |
| 2.4-02 | Runbook answers: how to confirm working, detect failure, respond to failure | T2 | artifact | continuous | |
| 2.4-03 | Ownership transfers explicitly with runbook review | T3 | advisory | continuous | |

### §2.5 Reliability and Security Gates

| # | Statement | Type | Kind | Scope | Notes |
|---|---|---|---|---|---|
| 2.5-01 | Delivery health worsens 2 consecutive periods: shrink changes, strengthen gates, prioritize reliability | T1 | gate | continuous | |
| 2.5-02 | Manual task recurs >3 times or >30 min/week: automate, eliminate, or file issue | T1 | gate | continuous | |
| 2.5-03 | Attack surface expansion requires security review before merge | T1 | gate | verify | |
| 2.5-04 | Risk-based approval: automated for routine, peer for moderate, human for high-impact | T3 | advisory | verify | |

### §2.6 Flow and Batch Size

| # | Statement | Type | Kind | Scope | Notes |
|---|---|---|---|---|---|
| 2.6-01 | Deliver in smallest increment that can be independently reviewed, tested, deployed, reversed | T3 | advisory | build | |
| 2.6-02 | WIP limits defined and enforced | T1 | gate | continuous | |
| 2.6-03 | Constraint identified before optimization (ToC) | T3 | advisory | continuous | |
| 2.6-04 | Delivery rate awareness: define required rate, compare to actual throughput | T3 | advisory | continuous | |

### §2.7 User Feedback

| # | Statement | Type | Kind | Scope | Notes |
|---|---|---|---|---|---|
| 2.7-01 | Capture format and filing location defined | T2 | artifact | continuous | |
| 2.7-02 | Intake accumulation channel defined | T2 | artifact | continuous | |
| 2.7-03 | Triage cadence defined | T2 | artifact | continuous | |
| 2.7-04 | Promotion process to §2.2 work items defined | T2 | artifact | continuous | |
| 2.7-05 | User notification process defined | T2 | artifact | continuous | |

### §2.8 Status Visibility

| # | Statement | Type | Kind | Scope | Notes |
|---|---|---|---|---|---|
| 2.8-01 | Visible, regularly updated status for work others depend on | T3 | advisory | continuous | |

**§2 totals: T1=18, T2=12, T3=6, T4=15 = 36 REQ-IDs**

---

## §3 Architecture and Design

### §3.1 Component Architecture Template

| # | Statement | Type | Kind | Scope | Notes |
|---|---|---|---|---|---|
| 3.1-01 | Every system component has an architecture document | T2 | artifact | design | |
| 3.1-02 | Required sections present (purpose, goals, current vs target, diagram, data flows, deps, failure modes, boundaries, future notes) | T1 | gate | design | |
| 3.1-03 | Always-on services with SLO: FTA and reliability block diagram | T2 | artifact | design | |
| 3.1-04 | Additional sections by component type (stateful, SLO-bound, trust-boundary, data-sensitive, i18n) | T3 | advisory | design | |

### §3.2 Design Principles

| # | Statement | Type | Kind | Scope | Notes |
|---|---|---|---|---|---|
| 3.2-01 | 14 design principles listed (SOLID, DRY, KISS, etc.) | T3 | advisory | design | Named principles, not testable gates |
| 3.2-02 | 5S practices for clean codebase | T3 | advisory | continuous | |
| 3.2-03 | Consistent formatting enforced by automated tooling | T1 | gate | commit | |
| 3.2-04 | Markdown follows CommonMark spec | T1 | gate | commit | |

### §3.3 Architecture Doc Backlog

| # | Statement | Type | Kind | Scope | Notes |
|---|---|---|---|---|---|
| 3.3-01 | Project maintains list of components lacking architecture docs | T2 | artifact | continuous | |
| 3.3-02 | No changes to component without arch doc until doc exists or issue filed | T1 | gate | design | |

### §3.4 Conway's Law

| # | Statement | Type | Kind | Scope | Notes |
|---|---|---|---|---|---|
| 3.4-01 | Independent deployability test | T3 | advisory | design | |
| 3.4-02 | Independent testability test | T3 | advisory | design | |
| 3.4-03 | Conway's Law rationale and team cognitive load | T4 | narrative | - | |

**§3 totals: T1=4, T2=4, T3=5, T4=6 (incl narrative paras) = 13 REQ-IDs**

---

## §4 Documentation Standards

### §4.1 What Must Be Documented

| # | Statement | Type | Kind | Scope | Notes |
|---|---|---|---|---|---|
| 4.1-01 | Standard directory layout maintained per starters/repo-structure.md | T2 | artifact | continuous | |
| 4.1-02 | 11 documentation types table (ADR, README, setup, deploy, runbook, etc.) | T2 | artifact | document | Each row is a required artifact under conditions |
| 4.1-03 | Archived documents have frontmatter (status: archived, superseded-by, date-archived) | T1 | gate | document | |

### §4.2 ADR Format

| # | Statement | Type | Kind | Scope | Notes |
|---|---|---|---|---|---|
| 4.2-01 | ADR has required sections (context, decision, consequences, alternatives, validation) | T1 | gate | design | |
| 4.2-02 | Validation criteria are outcome-based and binary | T1 | gate | design | |

### §4.3 Changelogs

| # | Statement | Type | Kind | Scope | Notes |
|---|---|---|---|---|---|
| 4.3-01 | Standards, APIs, and actively evolving documents maintain a changelog | T2 | artifact | document | |
| 4.3-02 | Entry records version, date, what changed, why | T1 | gate | document | |
| 4.3-03 | Repo changelog at CHANGELOG.md root; standalone doc changelog at top of doc | T3 | advisory | document | |

### §4.4 Table of Contents

| # | Statement | Type | Kind | Scope | Notes |
|---|---|---|---|---|---|
| 4.4-01 | Every document with >3 sections has a ToC (exception: fixed template instances) | T1 | gate | document | |

### §4.5 Code Documentation

| # | Statement | Type | Kind | Scope | Notes |
|---|---|---|---|---|---|
| 4.5-01 | Every function/module documents: what, why, failure modes, example usage | T1 | gate | build | |
| 4.5-02 | No undocumented public functions | T1 | gate | build | |

### §4.6 Work Session Logs

| # | Statement | Type | Kind | Scope | Notes |
|---|---|---|---|---|---|
| 4.6-01 | Significant work sessions produce a log | T2 | artifact | session-end | |

### §4.7 Document Length and Cascade

| # | Statement | Type | Kind | Scope | Notes |
|---|---|---|---|---|---|
| 4.7-01 | Section >500 words: evaluate for extraction | T3 | advisory | document | |
| 4.7-02 | Document >2000 words with search-required navigation: cascade into sub-documents | T3 | advisory | document | |

### §4.8 Documentation Layers

| # | Statement | Type | Kind | Scope | Notes |
|---|---|---|---|---|---|
| 4.8-01 | Every component has documentation sufficient for new person maintenance | T2 | artifact | document | |
| 4.8-02 | Required layers: code, operations, configuration, security, network, database | T2 | artifact | document | 6 layers listed |

### §4.9 Machine-Readable Requirement Format

| # | Statement | Type | Kind | Scope | Notes |
|---|---|---|---|---|---|
| 4.9-01 | §4.9 does not exceed 150 lines | T1 | gate | commit | Already has REQ-ID |
| 4.9-02 | STANDARDS.md does not exceed 1200 lines | T1 | gate | commit | Already has REQ-ID |

**§4 totals: T1=6 (excl existing REQ-4.9-01/02), T2=7, T3=3, T4=5 = 16 REQ-IDs**

---

## §5 Code and Deployability

### §5.1 Version Control Discipline

| # | Statement | Type | Kind | Scope | Notes |
|---|---|---|---|---|---|
| 5.1-01 | Primary branch is always deployable | T1 | gate | continuous | |
| 5.1-02 | All work in short-lived branches integrated within 1-2 days | T1 | gate | build | |
| 5.1-03 | No direct commits to primary except emergency hotfixes with retroactive review | T1 | gate | commit | |
| 5.1-04 | Commit messages structured and categorized | T1 | gate | commit | |
| 5.1-05 | .gitignore excludes build artifacts, OS files, IDE configs, deps, compiled output, secrets | T1 | gate | commit | |
| 5.1-06 | Before merge: all tests pass | T1 | gate | verify | |
| 5.1-07 | Before merge: at least one review | T1 | gate | verify | |
| 5.1-08 | Before merge: documentation updated | T1 | gate | verify | |
| 5.1-09 | Before merge: gate evidence attached for functional changes | T2 | artifact | verify | |
| 5.1-10 | Before merge: pre-commit checks pass (lint, format, type) | T1 | gate | commit | |
| 5.1-11 | All repos pushed and verified at session end | T1 | gate | session-end | |
| 5.1-12 | Readability test: new person can set up, understand, run tests, deploy, verify, monitor | T1 | gate | close | |

### §5.2 Dependency Management

| # | Statement | Type | Kind | Scope | Notes |
|---|---|---|---|---|---|
| 5.2-01 | All dependencies explicitly declared and version-pinned | T1 | gate | build | |
| 5.2-02 | Vulnerability scans on every CI pass; high-severity blocks merge | T1 | gate | commit | |
| 5.2-03 | Open vulnerability exceptions reviewed quarterly | T1 | gate | continuous | |
| 5.2-04 | License audit annually | T1 | gate | continuous | |
| 5.2-05 | No undeclared global tools | T1 | gate | build | |

### §5.3 Multi-Repository Coordination

| # | Statement | Type | Kind | Scope | Notes |
|---|---|---|---|---|---|
| 5.3-01 | Cross-repo changes documented and coordinated in same work session | T2 | artifact | document | |

### §5.4 Restart Safety and Resilience

| # | Statement | Type | Kind | Scope | Notes |
|---|---|---|---|---|---|
| 5.4-01 | Long-running processes tolerate restart without corruption or duplication | T1 | gate | build | |
| 5.4-02 | Every external call has a defined timeout | T1 | gate | build | |
| 5.4-03 | Retries use exponential backoff with jitter | T1 | gate | build | |
| 5.4-04 | Overload behavior defined before overload occurs | T2 | artifact | design | |

### §5.5 CI/CD

| # | Statement | Type | Kind | Scope | Notes |
|---|---|---|---|---|---|
| 5.5-01 | Automated CI pipeline runs on every proposed change before merge | T1 | gate | commit | |
| 5.5-02 | Pipeline: compile, test suite, vuln scan, pre-commit gate | T1 | gate | commit | |
| 5.5-03 | Pipeline fails visibly on any error | T1 | gate | commit | |
| 5.5-04 | Rollback trigger and strategy pre-defined | T2 | artifact | deploy | |

### §5.6 Infrastructure as Code

| # | Statement | Type | Kind | Scope | Notes |
|---|---|---|---|---|---|
| 5.6-01 | Infrastructure version-controlled, reproducible, automation-applied | T2 | artifact | deploy | |
| 5.6-02 | Environment fully reproducible from repository | T1 | gate | deploy | |

### §5.7 Deployment Strategies

| # | Statement | Type | Kind | Scope | Notes |
|---|---|---|---|---|---|
| 5.7-01 | Every production deployment defines rollout strategy before starting | T2 | artifact | deploy | |
| 5.7-02 | Rollback trigger defined: specific metric threshold or error condition | T2 | artifact | deploy | |

### §5.8 API Versioning

| # | Statement | Type | Kind | Scope | Notes |
|---|---|---|---|---|---|
| 5.8-01 | API follows semantic versioning | T1 | gate | build | |
| 5.8-02 | Breaking changes require major version + deprecation period | T1 | gate | build | |
| 5.8-03 | Old versions remain functional through deprecation window | T1 | gate | continuous | |
| 5.8-04 | API contract documents current version and active deprecations | T2 | artifact | document | |

### §5.9 Runtime and Deployability

| # | Statement | Type | Kind | Scope | Notes |
|---|---|---|---|---|---|
| 5.9-01 | Twelve-Factor App criteria satisfied or deviation documented | T3 | advisory | build | |
| 5.9-02 | Secrets have defined lifecycle | T2 | artifact | deploy | |
| 5.9-03 | Structured logs, not prose | T1 | gate | build | |

### §5.10 Minimum Security Baseline

| # | Statement | Type | Kind | Scope | Notes |
|---|---|---|---|---|---|
| 5.10-01 | MFA or equivalent for operator/admin access | T1 | gate | deploy | |
| 5.10-02 | No shared accounts, no default credentials | T1 | gate | deploy | |
| 5.10-03 | OWASP ASVS Level 1 for services storing/processing sensitive data | T1 | gate | build | |
| 5.10-04 | Secrets never in source control, logs, screenshots, crash dumps | T1 | gate | commit | |
| 5.10-05 | Data classified into sensitivity levels in architecture document | T2 | artifact | design | |
| 5.10-06 | Data retention policies defined | T2 | artifact | design | |
| 5.10-07 | Security incidents require credential rotation + post-mortem | T1 | gate | close | |
| 5.10-08 | All sensitive data encrypted at rest and in transit | T1 | gate | build | |
| 5.10-09 | Regulatory compliance identified and documented | T3 | advisory | design | |

**§5 totals: T1=14 (estimated - collapsed some sub-items), T2=6, T3=4, T4=8 = 24 REQ-IDs**

---

## §6 Testing and Output Quality

### §6.1 Test Layers

| # | Statement | Type | Kind | Scope | Notes |
|---|---|---|---|---|---|
| 6.1-01 | Every function with logic gets a unit test | T1 | gate | build | |
| 6.1-02 | Integration tests: multiple modules together, may use real DB, runs on CI | T1 | gate | build | |
| 6.1-03 | System tests: complete flows end-to-end using live running system | T1 | gate | verify | |
| 6.1-04 | Every fixed bug produces a regression test | T1 | gate | build | |
| 6.1-05 | Performance tests for features with latency requirements | T1 | gate | verify | |
| 6.1-06 | Load tests for services with external users | T1 | gate | verify | |

### §6.2 Testing Gap Audit

| # | Statement | Type | Kind | Scope | Notes |
|---|---|---|---|---|---|
| 6.2-01 | Project maintains testing gap table | T2 | artifact | continuous | |
| 6.2-02 | Audited at start of significant feature phase | T3 | advisory | define | |
| 6.2-03 | P0/P1 gaps block shipping affected feature | T1 | gate | verify | |

### §6.3 Output Quality

| # | Statement | Type | Kind | Scope | Notes |
|---|---|---|---|---|---|
| 6.3-01 | Every output type verified for 5 quality dimensions (communicate, format, errors, edge cases, consistency) | T1 | gate | verify | |
| 6.3-02 | Visual output: no truncation, no layout breakage, contrast meets accessibility | T3 | advisory | verify | |
| 6.3-03 | User-facing output usable by people with disabilities | T1 | gate | verify | |
| 6.3-04 | Quality gate thresholds documented in application document | T2 | artifact | define | |

### §6.4 No Half-Finished Features

| # | Statement | Type | Kind | Scope | Notes |
|---|---|---|---|---|---|
| 6.4-01 | Feature meets AC, has filed issue for remaining work, or has documented known limitation | T1 | gate | close | |
| 6.4-02 | Defect detected during dev: work stops until resolved (Jidoka) | T1 | gate | build | |

### §6.5 Security Regression Standard

| # | Statement | Type | Kind | Scope | Notes |
|---|---|---|---|---|---|
| 6.5-01 | Auth/data/file/external changes: regression tests for unauthorized access, injection, traversal, SSRF, leakage | T1 | gate | build | |
| 6.5-02 | Security regression tests permanent, run on every CI pass | T1 | gate | commit | |

**§6 totals: T1=8, T2=3, T3=3, T4=4 = 14 REQ-IDs**

---

## §7 Monitoring and Observability

### §7.1 Service Health Checks

| # | Statement | Type | Kind | Scope | Notes |
|---|---|---|---|---|---|
| 7.1-01 | Every always-on service has meaningful health check: visible, time-stamped, alerting, functional | T1 | gate | deploy | |
| 7.1-02 | Health check status table maintained in project docs | T2 | artifact | continuous | |

### §7.2 Monitoring Dashboard

| # | Statement | Type | Kind | Scope | Notes |
|---|---|---|---|---|---|
| 7.2-01 | Monitoring page shows per service: alive/dead, queue depth, error rate, run duration, active alerts | T2 | artifact | monitor | |

### §7.3 Audit Trail

| # | Statement | Type | Kind | Scope | Notes |
|---|---|---|---|---|---|
| 7.3-01 | Every consequential action logged with: who, what, when, outcome, duration | T1 | gate | continuous | |
| 7.3-02 | Both blocked and permitted actions logged | T1 | gate | continuous | |

### §7.4 Delivery Health

| # | Statement | Type | Kind | Scope | Notes |
|---|---|---|---|---|---|
| 7.4-01 | Track 4 DORA metrics: deploy frequency, lead time, change failure rate, time to restore | T2 | artifact | continuous | |
| 7.4-02 | Delivery health worsens 2 consecutive periods: reduce change size, strengthen testing | T1 | gate | continuous | |
| 7.4-03 | Work item cycle time tracked per class | T1 | gate | continuous | |
| 7.4-04 | First-pass yield and hidden factory measured | T3 | advisory | continuous | |

### §7.5 Service Level Objectives

| # | Statement | Type | Kind | Scope | Notes |
|---|---|---|---|---|---|
| 7.5-01 | Every always-on capability defines SLI and SLO | T2 | artifact | deploy | |
| 7.5-02 | Error budget half exhausted: reliability work takes priority over features | T1 | gate | continuous | |
| 7.5-03 | Alerts declare severity: page now, same-day, daily summary | T1 | gate | monitor | |

### §7.6 Observability Standard

| # | Statement | Type | Kind | Scope | Notes |
|---|---|---|---|---|---|
| 7.6-01 | Traces, metrics, and structured logs for all production services | T1 | gate | deploy | |
| 7.6-02 | Sensitive payloads redacted before emission | T1 | gate | build | |

### §7.7 Measurement Integrity

| # | Statement | Type | Kind | Scope | Notes |
|---|---|---|---|---|---|
| 7.7-01 | Validate measurement system before trusting (3-step: definition, source, calibration) | T3 | advisory | continuous | |
| 7.7-02 | Distinguish signal from noise before responding to metric movement | T3 | advisory | continuous | |
| 7.7-03 | Measure process capability over time | T3 | advisory | continuous | |

**§7 totals: T1=8, T2=5, T3=3, T4=5 = 16 REQ-IDs**

---

## §8 Learning from Failure

### §8.1 Incident Taxonomy

| # | Statement | Type | Kind | Scope | Notes |
|---|---|---|---|---|---|
| 8.1-01 | Every incident classified before post-mortem (6 categories) | T1 | gate | close | |
| 8.1-02 | Every incident produces regression cases | T1 | gate | close | |
| 8.1-03 | 4 severity levels defined (P0-P3) | T4 | narrative | - | Definitions |

### §8.2 Post-Mortem Format

| # | Statement | Type | Kind | Scope | Notes |
|---|---|---|---|---|---|
| 8.2-01 | Post-mortem for every P0 and P1 incident | T2 | artifact | close | |
| 8.2-02 | Post-mortem has required sections (timeline, root cause, contributing factors, impact, detection, resolution, prevention, lessons) | T1 | gate | close | |
| 8.2-03 | Security supplement for data exposure/credential misuse/unauthorized access | T2 | artifact | close | Conditional |
| 8.2-04 | Blameless analysis (Deming SoPK) | T3 | advisory | close | |
| 8.2-05 | Prevention actions carry explicit predictions; verify after implementation | T3 | advisory | close | |

### §8.3 Lessons Learned Registry

| # | Statement | Type | Kind | Scope | Notes |
|---|---|---|---|---|---|
| 8.3-01 | Project maintains lessons-learned registry | T2 | artifact | continuous | |
| 8.3-02 | Every post-mortem lesson added to registry | T1 | gate | close | |
| 8.3-03 | Registry consulted before starting new features | T1 | gate | define | |

### §8.4 Anti-Pattern Registry

| # | Statement | Type | Kind | Scope | Notes |
|---|---|---|---|---|---|
| 8.4-01 | Project maintains anti-pattern registry | T2 | artifact | continuous | |
| 8.4-02 | Promotion criteria: 2+ post-mortems with same pattern, or P0 systemic factor, or 2+ compliance review cycles | T3 | advisory | continuous | |

### §8.5 Incident Communication

| # | Statement | Type | Kind | Scope | Notes |
|---|---|---|---|---|---|
| 8.5-01 | User-affecting incidents communicated with impact and timeline | T2 | artifact | monitor | |
| 8.5-02 | Communication channel defined before first incident | T2 | artifact | deploy | |

### §8.6 Technical Debt Tracking

| # | Statement | Type | Kind | Scope | Notes |
|---|---|---|---|---|---|
| 8.6-01 | Acknowledged debt tracked as type=debt work items | T1 | gate | continuous | |
| 8.6-02 | Closed debt items update source document with resolution and work item ID | T1 | gate | close | |
| 8.6-03 | Debt periodically audited and prioritized | T3 | advisory | continuous | |

### §8.7 A3 Structured Problem Solving

| # | Statement | Type | Kind | Scope | Notes |
|---|---|---|---|---|---|
| 8.7-01 | A3 used for systematic improvement work without production incident trigger | T2 | artifact | define | |

**§8 totals: T1=5, T2=7, T3=3, T4=6 = 15 REQ-IDs**

---

## §9 Technology Adoption

### §9.1 Evaluation Framework

| # | Statement | Type | Kind | Scope | Notes |
|---|---|---|---|---|---|
| 9.1-01 | Tech eval completed before adopting new technology/framework/service | T2 | artifact | design | |
| 9.1-02 | Research phase: 7 questions answered | T1 | gate | design | |
| 9.1-03 | Proof of concept: build smallest thing validating core assumption | T2 | artifact | design | |
| 9.1-04 | Decision: ADR required (proceed/reject/defer) | T2 | artifact | design | |
| 9.1-05 | Integration follows full development lifecycle | T1 | gate | build | |
| 9.1-06 | New technology gets dedicated architecture doc | T2 | artifact | design | |
| 9.1-07 | Alerts and monitoring configured for new dependency | T1 | gate | deploy | |

### §9.2 Technology ADR Backlog

| # | Statement | Type | Kind | Scope | Notes |
|---|---|---|---|---|---|
| 9.2-01 | Project maintains technology ADR backlog | T2 | artifact | continuous | |
| 9.2-02 | Retroactive ADR filed for decisions without formal ADR | T3 | advisory | continuous | |

### §9.3 External Standards Management

| # | Statement | Type | Kind | Scope | Notes |
|---|---|---|---|---|---|
| 9.3-01 | Dependency tracking document maintained | T2 | artifact | continuous | |
| 9.3-02 | Referenced standard changes: update affected practices, record in changelog | T3 | advisory | continuous | |

**§9 totals: T1=3, T2=4, T3=2, T4=3 = 9 REQ-IDs**

---

## Addenda Summary

| Addendum | T1 (gate) | T2 (artifact) | T3 (advisory) | T4 (narrative) | Total REQ-IDs | Non-binary [NB] |
|---|---|---|---|---|---|---|
| ai-ml.md | 10 | 6 | 4 | 8 | 20 | 1 |
| continuous-improvement.md | 4 | 6 | 3 | 8 | 13 | 0 |
| web-applications.md | 6 | 3 | 2 | 3 | 11 | 0 |
| event-driven.md | 6 | 4 | 2 | 4 | 12 | 1 |
| multi-service.md | 5 | 4 | 2 | 4 | 11 | 0 |
| multi-team.md | 4 | 3 | 3 | 5 | 10 | 0 |
| containerized-systems.md | 7 | 2 | 2 | 3 | 11 | 1 |
| **Total addenda** | **42** | **28** | **18** | **35** | **88** | **3** |

### Non-Binary Statements Requiring Rewrite [NB]

| Addendum | Statement | Current form | Issue |
|---|---|---|---|
| ai-ml.md | "Every downstream consumer of AI output has a documented fallback path for incorrect output" | Binary as stated | Borderline: "fallback path" could mean different things; clarify to "named fallback action in architecture doc" |
| event-driven.md | "Document the idempotency strategy in the architecture doc" | Binary | Borderline: "strategy" is vague; clarify to "named idempotency mechanism" |
| containerized-systems.md | "Use minimal, official base images" | Not binary | "Minimal" has no threshold; rewrite to "Base image is a named minimal variant (distroless, Alpine, or equivalent)" |

---

## Planning Estimates for B3-B12

| Work Item | Section(s) | Estimated REQ-IDs | Estimated effort |
|---|---|---|---|
| B3 | §1 | 14 | 42 lines added (14 x 3-line units) |
| B4 | §2 | 36 | 108 lines added (largest section) |
| B5 | §3 | 13 | 39 lines added |
| B6 | §4 | 16 | 48 lines added (incl 2 existing) |
| B7 | §5 | 24 | 72 lines added |
| B8 | §6 | 14 | 42 lines added |
| B9 | §7 | 16 | 48 lines added |
| B10 | §8 | 15 | 45 lines added |
| B11 | §9 | 9 | 27 lines added |
| B12 | 7 addenda | 88 | 264 lines added |
| **Total** | | **245** | **~735 lines** |

**Line budget impact:** STANDARDS.md currently 1022 lines. Adding ~471 REQ-ID lines (§1-§9 base) would reach ~1493 lines, exceeding the 1200 REQ-4.9-02 ceiling by 293 lines. Cascade strategy: move reference material (valid-values tables, extended examples, framework mappings) to docs/req-schema.md during each section migration. Primary cascade candidates:
- §2.1 PDCA/DMAIC mapping paragraphs (~30 lines)
- §2.2 type taxonomy table (~20 lines of definitions that can be a reference)
- §3.2 design principles list (~30 lines)
- §4.9 PEG grammar and tag schema table (~40 lines)
- §5.9 Twelve-Factor and §5.10 OWASP details (~30 lines)
- §7.6-7.7 statistical background references (~20 lines)
- Estimated cascade: ~170+ lines to docs/req-schema.md

With cascade: ~1022 - 170 + 471 = ~1323 lines. Still over 1200. Need additional cascade of ~123 lines from narrative content. T4 statements (narrative) are prime cascade candidates since they carry no REQ-ID.
