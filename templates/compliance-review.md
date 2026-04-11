---
type: compliance-review
stage:
  - verify
applies-to:
  - all
implements:
  - REQ-4.1-01
---

# Compliance Review: {Project Name}

> Periodic internal audit of ESE compliance. Per ADR-011 Gap 2: every project defines a compliance review cadence - at minimum annually or when significant system changes occur. This template structures the review to ensure consistency. Results update the project's [standards-application.md](../starters/standards-application.md).

**Reviewer:** {name}
**Date:** YYYY-MM-DD
**Scope:** {full review / targeted review of sections {list}}
**ESE version reviewed against:** {version from CHANGELOG.md}
**Previous review date:** {date or "first review"}

---

## Review Summary

| Dimension | Previous | Current | Trend |
|-----------|----------|---------|-------|
| Total compliant sections | {count} | {count} | Better / Same / Worse |
| Total gaps | {count} | {count} | Better / Same / Worse |
| P0/P1 gaps | {count} | {count} | Better / Same / Worse |
| Gaps closed since last review | - | {count} | - |
| New gaps found this review | - | {count} | - |

---

## Section-by-Section Assessment

> For each ESE section: is the project compliant? What evidence proves it? What gaps remain?

### §1 - Scope and Product Discipline

| Requirement | Status | Evidence | Issue (if gap) |
|-------------|--------|----------|----------------|
| §1.1 Problem statement documented | Compliant / Gap | {link to doc} | {issue ID} |
| §1.2 Document progression followed | Compliant / Gap | {link} | |
| §1.3 Phases defined | Compliant / Gap / N/A | {link} | |
| §1.4 First principles documented | Compliant / Gap | {link} | |
| §1.5 Complex-domain work identified and handled appropriately (probe-sense-respond, not prescriptive gates) | Compliant / Gap / N/A | {link or "no complex-domain work"} | |

### §2 - Methodology

| Requirement | Status | Evidence | Issue (if gap) |
|-------------|--------|----------|----------------|
| REQ-2.1-01: Lifecycle followed (DISCOVER through CLOSE) | Compliant / Gap | {link} | |
| REQ-2.1-19: D0 intake log entry for every observed signal | Compliant / Gap | {link} | |
| REQ-2.1-20: D1 triage includes evidence check, duplicate check, registry consult | Compliant / Gap | {link} | |
| REQ-2.1-21: D1 triage exits one of four (promote, investigate, park, discard) | Compliant / Gap | {link} | |
| REQ-2.1-22: D2 characterization artifact when AC cannot yet be written | Compliant / Gap / N/A | {link} | |
| REQ-2.1-23: Expedite signals resolved first, D0/D1 back-filled | Compliant / Gap / N/A | {link} | |
| REQ-2.1-02: AC written before implementation begins | Compliant / Gap | {link} | |
| REQ-2.1-03: ADR for qualifying changes | Compliant / Gap / N/A | {link} | |
| REQ-2.1-04: FMEA for auth/payments/data mutation/external integrations | Compliant / Gap / N/A | {link} | |
| REQ-2.1-17: High-RPN/Severity 9-10 have design changes before BUILD | Compliant / Gap / N/A | {link} | |
| REQ-2.1-05: Tests written alongside or before code | Compliant / Gap | {link} | |
| REQ-2.1-06: Unit tests pass | Compliant / Gap | {link} | |
| REQ-2.1-15: Integration tests pass | Compliant / Gap | {link} | |
| REQ-2.1-07: VERIFY answer recorded | Compliant / Gap | {link} | |
| REQ-2.1-08: Documentation written before close | Compliant / Gap | {link} | |
| REQ-2.1-09: Rollout strategy defined before deploy | Compliant / Gap | {link} | |
| REQ-2.1-16: Rollback trigger defined before deploy | Compliant / Gap | {link} | |
| REQ-2.1-10: MONITOR answer recorded | Compliant / Gap | {link} | |
| REQ-2.1-11: Gate evidence attached at CLOSE | Compliant / Gap | {link} | |
| REQ-2.1-24: Re-entry from BUILD to DEFINE when DEFINE incomplete | Compliant / Gap / N/A | {link} | |
| REQ-2.1-25: Re-entry from VERIFY to DESIGN when DESIGN wrong | Compliant / Gap / N/A | {link} | |
| REQ-2.1-26: Re-entry from DEPLOY to VERIFY when VERIFY incomplete | Compliant / Gap / N/A | {link} | |
| REQ-2.1-27: Re-entry triggers recorded (what was missing and why) | Compliant / Gap / N/A | {link} | |
| REQ-2.2-01: Work item has all 8 required attributes | Compliant / Gap | {link} | |
| REQ-2.2-02: Root cause or symptom-fix link | Compliant / Gap | {link} | |
| REQ-2.2-03: Work item has type (1 of 9) | Compliant / Gap | {link} | |
| REQ-2.2-04: Work item has class of service | Compliant / Gap | {link} | |
| REQ-2.2-05: Closed records accessible to reviewers | Compliant / Gap | {link} | |
| REQ-2.2-07: Private system exports at close | Compliant / Gap / N/A | {link} | |
| REQ-2.2-08: AC are observable, binary, measurable | Compliant / Gap | {link} | |
| REQ-2.2-09: Feature AC has failure/boundary/error case | Compliant / Gap / N/A | {link} | |
| REQ-2.2-10: Definition of Ready met before claiming | Compliant / Gap | {link} | |
| REQ-2.3-01: AC explicitly verified before close | Compliant / Gap | {link} | |
| REQ-2.3-02: Tests passing per §6.1 pyramid | Compliant / Gap | {link} | |
| REQ-2.3-14: Regression test for bug fixes | Compliant / Gap / N/A | {link} | |
| REQ-2.3-03: Documentation updated | Compliant / Gap | {link} | |
| REQ-2.3-04: Gate evidence attached | Compliant / Gap | {link} | |
| REQ-2.3-05: Monitoring in place | Compliant / Gap | {link} | |
| REQ-2.3-06: Deployed to live environment | Compliant / Gap | {link} | |
| REQ-2.3-07: Repos pushed and up to date | Compliant / Gap | {link} | |
| REQ-2.3-08: Work item record accessible | Compliant / Gap | {link} | |
| REQ-2.3-09: New person readiness | Compliant / Gap | {link} | |
| REQ-2.3-10: Type-conditional close requirements met | Compliant / Gap | {link} | |
| REQ-2.3-11: Security: FMEA before close | Compliant / Gap / N/A | {link} | |
| REQ-2.3-12: Security: regression tests | Compliant / Gap / N/A | {link} | |
| REQ-2.3-13: Security: security review | Compliant / Gap / N/A | {link} | |
| REQ-2.3-16: Bug P0/P1: post-mortem | Compliant / Gap / N/A | {link} | |
| REQ-2.3-17: Investigation: root cause documented | Compliant / Gap / N/A | {link} | |
| REQ-2.3-18: Investigation: implementation work item filed | Compliant / Gap / N/A | {link} | |
| REQ-2.3-19: Improvement: baseline before BUILD | Compliant / Gap / N/A | {link} | |
| REQ-2.3-20: Improvement: exceeds process variation | Compliant / Gap / N/A | {link} | |
| REQ-2.3-21: Component: arch doc complete | Compliant / Gap / N/A | {link} | |
| REQ-2.3-22: Debt: source doc updated | Compliant / Gap / N/A | {link} | |
| REQ-2.3-23: Prevention: post-mortem table updated | Compliant / Gap / N/A | {link} | |
| REQ-2.3-24: Countermeasure: A3 table updated | Compliant / Gap / N/A | {link} | |
| REQ-2.4-01: Named owner for every service | Compliant / Gap | {link} | |
| REQ-2.4-02: Runbook answers 3 questions | Compliant / Gap | {link} | |
| REQ-2.4-03: Ownership transfer recorded | Compliant / Gap / N/A | {link} | |
| REQ-2.5-01: Security review for attack surface changes | Compliant / Gap / N/A | {link} | |
| REQ-2.5-02: Delivery health decline triggers action | Compliant / Gap / N/A | {link} | |
| REQ-2.5-03: Toil tracked and addressed | Compliant / Gap / N/A | {link} | |
| REQ-2.6-01: Small batch delivery | Compliant / Gap | {link} | |
| REQ-2.6-05: WIP limits defined and enforced | Compliant / Gap | {link} | |
| REQ-2.7-01: Signal capture format defined | Compliant / Gap | {link} | |
| REQ-2.7-02: Intake channel defined | Compliant / Gap | {link} | |
| REQ-2.7-03: Triage cadence defined | Compliant / Gap | {link} | |
| REQ-2.7-04: Promotion process defined | Compliant / Gap | {link} | |
| REQ-2.7-05: User notification process defined | Compliant / Gap | {link} | |
| REQ-2.8-01: Status visibility for dependent work | Compliant / Gap | {link} | |
| §2.2 Work item system compliant: tracked system captures all 8 attributes OR markdown work item files used with ADR-019 export at close | Compliant / Gap | {link} | |
| §2.2 Backlog reviewed periodically: stale or deprioritized items explicitly closed or recommitted with a timeline; no items remain that no one intends to act on | Compliant / Gap / N/A | {link} | |
| §2.2 Definition of Ready applied before claiming work: AC written and agreed, dependencies identified, scoped to a meaningful increment, team has context to begin without a discovery session | Compliant / Gap | {link} | |
| §2.8 Status visibility maintained for stakeholders waiting on the work | Compliant / Gap / N/A | {link or "N/A - no external stakeholders"} | |

### §3 - Architecture and Design

| Requirement | Status | Evidence | Issue (if gap) |
|-------------|--------|----------|----------------|
| §3.1 Architecture docs for all components | Compliant / Gap | {link} | |
| §3.2 Design principles applied | Compliant / Gap | {link} | |
| §3.3 Architecture doc backlog maintained | Compliant / Gap | {link} | |
| §3.4 Team-architecture alignment: components independently deployable and independently testable by their owning team; team cognitive load within maintainable bounds | Compliant / Gap / N/A | {link or "N/A - single-team project"} | |

### §4 - Documentation Standards

| Requirement | Status | Evidence | Issue (if gap) |
|-------------|--------|----------|----------------|
| §4.1 Required docs present (ADRs, README, setup.md, deployment.md, runbook.md, API contract, data schema, compliance review) | Compliant / Gap | {link} | |
| §4.1 Template compliance (REQ-4.1-02): every documented artifact created from a template contains every required section from that template, or explicitly documents each omitted section inline | Compliant / Gap | {link to template-compliance verification result} | |
| §4.1 Template-compliance verification mode (REQ-4.1-03): automated check OR compliance-review step, with the decision documented in standards-application.md | Compliant / Gap | {link to standards-application.md section declaring the mode} | |
| §4.1 Archived document metadata present for all files moved to docs/archive/: status: archived, superseded-by: {relative path}, date-archived: {YYYY-MM-DD} | Compliant / Gap / N/A | {link or "N/A - no documents archived"} | |
| §4.2 ADRs for significant decisions (5 required sections; binary outcome-based validation) | Compliant / Gap | {link} | |
| §4.3 Changelog maintained | Compliant / Gap | {link} | |
| §4.4 Table of contents present for every document with more than 3 sections | Compliant / Gap | {link} | |
| §4.5 Code documentation complete (4 items per function; no undocumented public functions) | Compliant / Gap / N/A | {link or "N/A - no code"} | |
| §4.6 Work session logs written for significant sessions | Compliant / Gap / N/A | {link} | |
| §4.7 Documents cascaded to sub-documents when too long to read in a single sitting | Compliant / Gap / N/A | {link or "N/A - no documents approaching length threshold"} | |
| §4.8 Documentation layers present for all components: code, security, network, database, operations, configuration | Compliant / Gap / N/A | {link or "N/A - no always-on components"} | |

### §5 - Code and Deployability

| Requirement | Status | Evidence | Issue (if gap) |
|-------------|--------|----------|----------------|
| §5.1 Version control discipline (primary branch deployable; short-lived branches; structured commits; pre-merge checklist) | Compliant / Gap | {link} | |
| §5.2 Dependencies managed (declared, pinned, vulnerability scans, license audit) | Compliant / Gap | {link} | |
| §5.3 Multi-repository changes documented in work session log; all affected repositories updated in the same logical work session with no dependent repository left in an inconsistent state | Compliant / Gap / N/A | {link or "N/A - single-repository project"} | |
| §5.4 Restart safety: long-running processes tolerate restart without state corruption; all external calls have defined timeouts; retries use exponential backoff with jitter | Compliant / Gap / N/A | {link or "N/A - no long-running processes"} | |
| §5.5 CI pipeline active (compile, full test suite, dependency scans, pre-commit gate; fails visibly on error) | Compliant / Gap | {link} | |
| §5.6 Infrastructure as Code: infrastructure version-controlled and fully reproducible from the repository; total-loss restore procedure documented in runbook with a system-level RTO defined | Compliant / Gap / N/A | {link or "N/A - no managed infrastructure"} | |
| §5.7 Deployment strategy documented (rollout strategy and rollback trigger defined before each deployment) | Compliant / Gap / N/A | {link or "N/A - no production deployments"} | |
| §5.8 API versioning: semver applied to all consumer-facing APIs; breaking changes require major version increment with a documented deprecation period communicated before the first breaking change ships | Compliant / Gap / N/A | {link or "N/A - no external APIs"} | |
| §5.9 Runtime and deployability: Twelve-Factor App criteria satisfied or deviations documented with the alternative approach in the architecture doc | Compliant / Gap / N/A | {link or "N/A - not a service"} | |
| §5.10 Minimum security baseline (MFA for operator access, no shared accounts, secrets never in source control, sensitive data classified, encryption at rest and in transit) | Compliant / Gap / N/A | {link or "N/A - no sensitive data processed"} | |

### §6 - Testing and Output Quality

| Requirement | Status | Evidence | Issue (if gap) |
|-------------|--------|----------|----------------|
| §6.1 Test layers present | Compliant / Gap | {link} | |
| §6.2 Testing gap audit current | Compliant / Gap | {link} | |
| §6.2 All applicable addenda Testing Gap Audit items present in standards-application testing table | Compliant / Gap / N/A | {link} | |
| §6.3 Output quality verified | Compliant / Gap | {link} | |
| §6.4 Stop-the-line enforced: defects do not pass to the next stage | Compliant / Gap | {link} | |
| §6.5 Security regression tests for auth/data/file/fetch/exec changes | Compliant / Gap / N/A | {link} | |

### §7 - Monitoring and Observability

| Requirement | Status | Evidence | Issue (if gap) |
|-------------|--------|----------|----------------|
| §7.1 Health checks for all services | Compliant / Gap | {link} | |
| §7.2 Monitoring dashboard present: shows alive/dead status with last health check timestamp, queue depth, error rate, run duration vs. baseline, and active alerts per supervised service | Compliant / Gap / N/A | {link or "N/A - no always-on services"} | |
| §7.3 Audit trail active: every consequential action logged with who, what, when, outcome, and duration; both blocked and permitted actions logged | Compliant / Gap / N/A | {link} | |
| §7.4 DORA metrics tracked (deployment frequency, lead time, change failure rate, time to restore) | Compliant / Gap | {link} | |
| §7.4 Work item cycle time tracked: elapsed time from claim to close measured per work item class; compared across delivery cycles to identify bottlenecks outside the deployment pipeline | Compliant / Gap / N/A | {link} | |
| §7.4 Compound yield tracked: first-pass yield measured per delivery stage; rework within stages (not only at stage exits) is visible | Compliant / Gap / N/A | {link} | |
| §7.5 SLOs defined | Compliant / Gap | {link} | |
| §7.6 Observability implemented: traces (root spans with context IDs propagated across service boundaries), metrics (latency, error counts, retry counts, queue depth), and logs (structured with correlation ID and redacted sensitive payloads) | Compliant / Gap / N/A | {link or "N/A - no production services"} | |
| §7.7 Measurement system validated before acting on metrics | Compliant / Gap / N/A | {link} | |
| §7.7 Common vs. special cause variation distinguished before responding to metric signals | Compliant / Gap / N/A | {link} | |

### §8 - Learning from Failure

| Requirement | Status | Evidence | Issue (if gap) |
|-------------|--------|----------|----------------|
| §8.1 Incident taxonomy applied: every incident classified by category (software defect, data integrity, infrastructure failure, security incident, configuration error, behavioral regression) before post-mortem is written; every incident produces at least one regression case | Compliant / Gap / N/A | {link} | |
| §8.2 Post-mortems written for P0/P1 | Compliant / Gap | {link} | |
| §8.3 Lessons-learned registry maintained | Compliant / Gap | {link} | |
| §8.4 Anti-pattern registry maintained | Compliant / Gap | {link} | |
| §8.5 Incident communication channel defined | Compliant / Gap | {link} | |
| §8.6 Technical debt tracked as work items | Compliant / Gap | {link} | |
| §8.7 A3 used for non-incident systemic improvement problems | Compliant / Gap / N/A | {link} | |

### §9 - Technology Adoption

| Requirement | Status | Evidence | Issue (if gap) |
|-------------|--------|----------|----------------|
| §9.1 Tech evaluations completed | Compliant / Gap | {link} | |
| §9.2 ADR backlog maintained | Compliant / Gap | {link} | |
| §9.3 External standards dependency tracking maintained: each referenced external standard listed with version or publication date, last review date, and note on known upcoming changes; affected practices updated when a standard changes materially | Compliant / Gap / N/A | {link} | |

*§10 was dissolved in v1.14.0 per ADR-020. Its requirements are now in §2.3 (new person readiness, handoff verification), §4.8 (documentation layers), §5.1 (readability test), and §5.10 (security baseline).*

---

## Applicable Addenda Reviewed

<a name="REQ-TPL-23"></a>
**REQ-TPL-23** `advisory` `continuous` `soft` `all`
Per-stage requirements are documented in the §2.1 per-stage blocks.

Per-stage requirements are documented in the [§2.1 per-stage blocks](../STANDARDS.md#per-stage-operational-blocks). Sign-off on each addendum is blocked until per-stage requirements have been verified against those blocks.

| Addendum | Reviewed | Per-stage requirements verified (see §2.1 per-stage blocks) | Key findings |
|----------|---------|-------------------------------------------------------------|-------------|
| Multi-Service Architectures | yes / no / N/A | yes / no / N/A | |
| Multi-Team Organizations | yes / no / N/A | yes / no / N/A | |
| Web Applications | yes / no / N/A | yes / no / N/A | |
| Containerized and Orchestrated Systems | yes / no / N/A | yes / no / N/A | |
| AI and ML Systems | yes / no / N/A | yes / no / N/A | |
| Event-Driven Systems | yes / no / N/A | yes / no / N/A | |
| Continuous Improvement | yes / no / N/A | yes / no / N/A | |

---

## New Gaps Found

| Gap | Section | Priority | Issue filed |
|-----|---------|----------|-------------|
| {description} | §{n} | P0/P1/P2/P3 | {issue ID} |

---

## Gaps Closed Since Last Review

| Gap | Section | Evidence of closure |
|-----|---------|-------------------|
| {description} | §{n} | {link to fix, test, or artifact} |

---

## Actions

- [ ] standards-application.md updated with current compliance state
- [ ] All new gaps filed as work items
- [ ] Next review date set: {YYYY-MM-DD}

---

## Document Verification

> [§2.1 VERIFY](../STANDARDS.md#21-the-lifecycle): this compliance review is a document subject to the documentation VERIFY checklist.

- [ ] Every internal link resolves to a valid target
- [ ] No formatting defects
- [ ] No AI-generated typographic characters
- [ ] All cross-references are hyperlinks
- [ ] No sentence fragments or duplicate sentences
- [ ] Every section covers the requirements from its governing standard section
- [ ] All gaps in the New Gaps Found table have a [§2.2](../STANDARDS.md#22-work-item-discipline)-compliant work item ID in the Issue filed column

---

## Sign-off

<a name="REQ-TPL-24"></a>
**REQ-TPL-24** `advisory` `continuous` `soft` `all`
Gate authority sign-off is blocked until all gaps in the New Gaps Found table have a filed work item ID and the Document Verification checklist abo...

> Gate authority sign-off is blocked until all gaps in the New Gaps Found table have a filed work item ID and the Document Verification checklist above is complete.

**Reviewed by:** {name}
**Gate authority approval:** {name, date}

---

*Next review: {date}*
