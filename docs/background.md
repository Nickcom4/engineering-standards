# Engineering Standards Research

Background context for contributors. This document captures: the research methodology, sources consulted, findings evaluated (including what was excluded and why), and the reasoning behind each section of STANDARDS.md.

**Maintenance convention:** Any change to STANDARDS.md that involves evaluating and rejecting alternatives - whether from research, external review, or internal discussion - requires an ADR per [§4.2](../STANDARDS.md#42-adr-format). The ADR is the required artifact; this document provides broader research context. Both should accompany the change in the same commit.

---

## Table of Contents

- [Research Methodology](#research-methodology)
- [Sources Consulted](#sources-consulted)
- [DORA Capabilities Evaluation](#dora-capabilities-evaluation)
- [Additional Source Findings](#additional-source-findings)
- [Tool Capability Mapping](#tool-capability-mapping)
- [Additional Validation Methods](#additional-validation-methods)
- [Why Each Section Exists](#why-each-section-exists)
- [What Was Deliberately Excluded](#what-was-deliberately-excluded)
- [§7.7 Measurement Integrity - Statistical Foundations](#77-measurement-integrity---statistical-foundations)

---

## Research Methodology

The standard was developed against multiple authoritative sources: the DORA capability catalog, the Google Software Engineering (SWE) Book, Team Topologies, Microsoft Engineering Fundamentals, Cybersecurity and Infrastructure Security Agency (CISA) Secure by Design, NIST publications, and the AWS Well-Architected Framework. Established engineering principles (Conway's Law, Hyrum's Law, SOLID, Twelve-Factor, test pyramid) were evaluated alongside these sources.

For each finding, the evaluation question was: does this principle apply universally regardless of technology stack, team size, or domain? If yes, it belongs in STANDARDS.md. If it only applies in specific contexts, it belongs in a first-party addendum.

Completeness was validated through three additional methods: mapping the core capabilities of widely-adopted project management, engineering, and version control tools against the standard; reviewing real-world project notes against the standard to identify uncovered concerns; and a timelessness review to ensure the standard expresses principles rather than convention-specific language.

---

## Sources Consulted

| Source | What it contributed |
|--------|-------------------|
| DORA Capability Catalog (dora.dev/capabilities/) | 35 capabilities evaluated; core delivery performance predictors |
| Software Engineering at Google (SWE Book, abseil.io) | Team structure, knowledge sharing, code review culture |
| Team Topologies (teamtopologies.com) | Cognitive load as architectural constraint, Conway's Law applications |
| Microsoft Engineering Fundamentals | Definition of Ready, working agreements, risk management |
| Cybersecurity and Infrastructure Security Agency (CISA) Secure by Design | Security ownership principles, shifting security left |
| NIST AI Risk Management Framework (RMF) 1.0 | AI risk governance framework (Govern, Map, Measure, Manage) |
| NIST Secure Software Development Framework (SSDF, SP 800-218) | Software supply chain security practice groups |
| AWS Well-Architected Framework | Six pillars: operational excellence, security, reliability, performance, cost, sustainability |
| Hyrum's Law (hyrumslaw.com) | Observable API behavior as implicit contract |
| Conway's Law (Conway 1968; Fowler reference) | System structure mirrors organizational communication structure |
| OWASP ASVS v5.0.0 | Application security verification requirements |
| Google SRE Book and Workbook | Reliability engineering practices, SLOs, blameless post-mortems |
| The Twelve-Factor App | Service deployability and configuration principles |
| Fowler/Vocke Test Pyramid (2018) | Test layer structure and purpose |
| OpenTelemetry Specification | Observability standards (traces, metrics, logs) |

---

## DORA Capabilities Evaluation

DORA's capability catalog (dora.dev/capabilities/) lists the practices most strongly associated with software delivery performance. Each capability was evaluated for inclusion.

### Included in STANDARDS.md (principle-level, universal)

| Capability | Where in standard | Rationale |
|-----------|-----------------|-----------|
| Working in small batches | Section 2.6 | DORA core; faster feedback, lower risk per change, applies at any scale |
| Work in process limits | Section 2.6 | DORA core; reduces context switching and masks bottlenecks |
| Trunk-based development | Section 5.1 | Long-lived branches accumulate merge risk; integrate within 1-2 days |
| Streamlining change approval | Section 2.5 | Heavyweight change advisory boards reduce deployment frequency without improving stability |
| Code maintainability | Section 8.6 | Measure codebase health; duplicate code, dead code, dependency currency |
| Monitoring and observability | Section 7 | Universal; no production system operates safely without it |
| Continuous integration | Section 5.5 | Universal; automated verification on every change |
| Continuous delivery | Section 5.5 | Universal; primary branch is always deployable |
| Customer feedback | Section 2.7 | Universal; a system without feedback has no improvement signal |
| Documentation quality | Section 4 | Universal; documentation is part of the work |
| Deployment automation | Section 5.5, Section 5.7 | Universal; manual deployments are toil and error-prone |
| Version control | Section 5.1 | Universal; foundational |
| Test automation | Section 6 | Universal; test pyramid applies to all projects |
| Loosely coupled teams | Section 3.4 | Conway's Law - team structure mirrors system structure |
| Proactive failure notification | Section 7.1, Section 7.5 | Universal; alerts before users report failures |
| User-centric focus | Section 1.1, Section 2.7 | Universal; scope starts with the user's problem |
| Database change management | Section 5.7 | Universal; zero-downtime migrations, rollback required |

### Deferred to addenda (scenario-specific)

| Capability | Addendum | Rationale |
|-----------|---------|-----------|
| Platform engineering | multi-team | Only applies when a platform team exists |
| Contract testing | multi-service | Only applies when services are consumed by other teams |

### Evaluated and excluded (not principle-level or out of scope)

| Capability | Why excluded |
|-----------|-------------|
| Visual management | Making Kanban boards visible is an implementation detail of Section 2.6 WIP limits; not a separate principle |
| Work visibility in value stream | Value stream mapping is a specific technique, not a universal principle |
| Well-being | Organizational culture is out of scope for an engineering standards document |
| Team experimentation | Implied by Section 2.6 small batches and the lifecycle; not a separate principle |
| Generative organizational culture | Psychological safety is a leadership concern, not a technical engineering requirement |
| Flexible infrastructure | Covered by Section 5.6 Infrastructure as Code and Section 5.9 Twelve-Factor |
| Job satisfaction | Out of scope |
| Pervasive security | Covered by Shift Left (Section 3.2), security gates (Section 2.5), and minimum security baseline (Section 5.10) |

---

## Additional Source Findings

### Team Topologies

Key concepts evaluated:
- **Cognitive load as architectural constraint**: Section 3.4. Every team has a cognitive load limit; architecture decisions that exceed it produce quality problems. Universal.
- **Conway's Law application (Inverse Conway Maneuver)**: Section 3.4. Design team boundaries to produce the architecture you want.
- **Stream-aligned, platform, enabling, complicated subsystem team types**: multi-team addendum. Only applicable in multi-team contexts.
- **Thinnest Viable Platform**: multi-team addendum. Platform-specific.

### Software Engineering at Google (SWE Book)

Key findings:
- **Hyrum's Law**: Section 5.8. All observable API behaviors become implicit contracts.
- **Bus factor / knowledge distribution**: Section 2.4 shared ownership and runbook requirement.
- **Blameless post-mortem culture**: Section 8.2.
- **Readability / code review as institutional practice**: Section 5.1 review quality gates.
- **Knowledge sharing**: Section 4.6 work session logs and Section 8.3 lessons-learned registry.

### Microsoft Engineering Fundamentals

Key findings:
- **Definition of Ready**: Section 2.2. Companion to Definition of Done; starting work before criteria are met produces rework.
- **Working agreements**: multi-team addendum. Explicit inter-team expectations.
- **Risk management**: Section 1.1 scope discipline and Section 2.3 definition of done.

### Cybersecurity and Infrastructure Security Agency (CISA) Secure by Design

Three core principles evaluated:
- **Take ownership of customer security outcomes**: Section 5.10 minimum security baseline and Section 6.5 security regression standard.
- **Embrace radical transparency and accountability**: Section 7.3 audit trail and Section 8.2 blameless post-mortems.
- **Lead from the top (executive responsibility)**: out of scope for a technical engineering standard.

Memory-safe languages recommendation: technology-specific, excluded per ADR-002.

### NIST Secure Software Development Framework (SSDF, SP 800-218)

Four practice groups:
- **PO (Prepare the Organization)**: partially covered by Section 5.10 security baseline and Section 9.1 technology evaluation.
- **PS (Protect Software)**: supply chain and provenance - partially covered by Section 5.2 dependency management (vulnerability scanning, license compliance). Full Software Bill of Materials (SBOM) requirement deferred; emerging practice not yet stable enough for a universal principle.
- **PW (Produce Well-Secured Software)**: Section 6.5 security regression standard and Section 5.10.
- **RV (Respond to Vulnerabilities)**: Section 8.1 incident taxonomy and Section 5.2 vulnerability scanning.

### AWS Well-Architected Framework

Six pillars evaluated:
- **Operational Excellence**: Section 2 (methodology), Section 7 (observability), Section 8 (failure learning).
- **Security**: Section 2.5, Section 6.5, Section 5.10.
- **Reliability**: Section 5.4 (restart safety), Section 5.7 (deployment strategies), Section 7.5 (SLOs).
- **Performance Efficiency**: Section 6 (performance testing), Section 3.1 (architecture template non-functional requirements).
- **Cost Optimization**: excluded - domain-specific, depends heavily on cloud provider and workload type.
- **Sustainability**: excluded - not yet a universal software engineering principle; practices vary significantly by deployment context.

---

## Tool Capability Mapping

To validate completeness, core capabilities of three widely-adopted tool categories were mapped against STANDARDS.md. Tool-specific features (automations, UI, integrations) were excluded; only capabilities representing universal engineering practices were evaluated.

### Project management (Asana)

| Capability | Covered | Where |
|---|---|---|
| Tasks with title, assignee, priority | Yes | Section 2.2 |
| Dependencies between tasks | Yes | Section 2.2 |
| Projects and milestones | Yes | Section 1.3 |
| Intake forms | Yes | Section 2.7 |
| WIP / workload limits | Yes | Section 2.6 |
| Approvals | Yes | Section 1.4, Section 2.5 |
| Status updates | Yes | Section 2.8 |
| Backlog maintenance | Yes | Section 2.2 |

### Engineering project management (Linear)

| Capability | Covered | Where |
|---|---|---|
| Issues with status, priority, assignee | Yes | Section 2.2 |
| Cycles / time-boxed delivery | Yes | Section 2.6 |
| Roadmap | Yes | Section 1.3 |
| Triage | Yes | Section 2.2 (Definition of Ready), Section 2.7 |
| Estimation | Yes | Section 1.3 effort awareness |
| SLAs | Yes | Section 7.5 |

### Version control and collaboration (GitHub)

| Capability | Covered | Where |
|---|---|---|
| Branching and branch protection | Yes | Section 5.1 |
| Code review | Yes | Section 5.1 |
| CI/CD | Yes | Section 5.5 |
| Issues | Yes | Section 2.2 |
| Dependency scanning | Yes | Section 5.2 |
| Code scanning | Yes | Section 6.5 |
| Releases | Yes | Section 5.7, Section 4.3 |
| Environments and secrets | Yes | Section 5.9 |
| Code ownership | Yes | Section 2.4 |

### Evaluated and excluded (tool-specific, not principle-level)

Notifications and alerts (tool UX), labels and tags (categorization scheme), automations and workflows (tool feature), discussions and comments (communication), templates for issues (covered by Section 2.2 work item structure).

### Runtime architecture principles mapping

Reliable runtime systems encode strong opinions about how systems should be built. The following principles (drawn from the a reliable runtime ecosystem ecosystem as one well-documented example) were each evaluated for universality:

| Runtime principle | Universal? | Where |
|---|---|---|
| Let it crash / supervision (restart to known good state) | Yes | Section 3.2 Design for Failure, Section 5.4 Restart Safety |
| Process isolation (fault boundaries) | Yes | Section 3.2 Separation of Concerns, Section 3.4 independent deployability |
| Message passing / no shared state | Yes | Section 3.2 Loose Coupling |
| Design-time recovery strategy | Yes | Section 3.2 Design for Failure ("at design time, not after the first outage") |
| Hot code upgrades / zero-downtime deploy | Yes | Section 5.7 deployment strategies and zero-downtime migrations |
| Explicit overload handling / backpressure | Yes | Section 5.4 - outbound resilience (timeouts, retry) and inbound resilience (overload behavior: shed load, backpressure, graceful degradation) |
| Runtime state introspection | Yes | Section 7.1 health checks, Section 7.6 observability |
| Location transparency / distribution | No (scenario) | Multi-service addendum |

---

## Additional Validation Methods

### Real-world project notes validation

A set of 36 items from real-world project planning notes (website rebuild) was checked against STANDARDS.md. 33 items were covered by the standard or its addenda. Three items were correctly outside scope (brand terminology strategy, gamification, competitive benchmarking - product/marketing strategy, not engineering). One partial gap (penetration testing) was addressed by adding it to the web applications addendum.

### Timelessness review

Every requirement in STANDARDS.md was reviewed for convention-specific language that ties the standard to a particular tool or era. The principle was: state the engineering principle, reference specific conventions as examples where helpful, but ensure the principle survives if the convention changes.

Changes made: "primary branch" instead of naming a specific branch; commit message structure described as a principle with specific conventions as project decisions; "proposed change" instead of tool-specific terminology; Twelve-Factor softened from unconditional mandate to documented-deviation model; setup time threshold replaced with principle-level language.

---

## Why Each Section Exists

**Section 1 (Scope and Product Discipline)** - SRE workbook emphasizes defining reliability targets before building. DORA research shows unclear scope is a leading cause of change failure. Document progression (Section 1.2) prevents PRDs from becoming implementation specs. Roadmap discipline (Section 1.3) requires measurable milestones, explicit phase boundaries, and effort awareness before commitment. Success metrics require all five dimensions: specific, measurable, achievable, relevant, and time-bounded.

**Section 2 (Methodology)** - The DISCOVER through CLOSE lifecycle aligns with SRE lifecycle discipline and DORA's emphasis on small, verifiable changes. Definition of Ready (Section 2.2) is the companion to Definition of Done; both ends of the work item lifecycle require explicit criteria. Backlog hygiene (Section 2.2) prevents stale items from eroding trust in the work system. Shared ownership (Section 2.4) requires team-level ownership with named discoverable owners, runbook-based knowledge transfer, and explicit ownership transfer when teams change. Risk-based change approval (Section 2.5) replaces heavyweight approval processes that reduce deployment frequency without improving stability. Flow and batch size (Section 2.6) encodes DORA's core finding that small batches and WIP limits are among the strongest predictors of delivery performance. User feedback (Section 2.7) ensures systems have a signal for whether they meet user needs. Status visibility (Section 2.8) ensures stakeholders can determine the current state of work without asking.

**Section 3 (Architecture and Design)** - Architecture templates with measurable goals and failure modes are standard SRE practice. Design principles (Section 3.2) name the foundational principles (SOLID, DRY, KISS, YAGNI, Fail Fast, Design for Failure, Shift Left, API-First) that every developer applies. Conway's Law (Section 3.4) is foundational to architecture decisions; the independent deployability and independent testability tests make it actionable. Cognitive load as an architectural constraint (Section 3.4) ensures team capacity is a design input. Internationalization is a design-time decision because retrofitting is far more expensive.

**Section 4 (Documentation Standards)** - Undocumented standards drift causes teams to apply outdated practices unknowingly. The changelog requirement (Section 4.3) makes change visible. The ToC requirement (Section 4.4) ensures navigability. The document cascade rule (Section 4.7) prevents documents from growing past readability.

**Section 5 (Code and Deployability)** - Dependency vulnerability scanning comes from OWASP ASVS. License compliance addresses legal liability. Short-lived branches (Section 5.1) encode the DORA trunk-based-development capability. Hyrum's Law (Section 5.8) recognizes that all observable API behaviors become implicit contract obligations. Restart safety (Section 5.4) includes timeouts and retry-with-backoff as universal resilience principles. The secret management lifecycle addresses how secrets reach each environment, not just that they live outside code.

**Section 6 (Testing and Output Quality)** - The test pyramid provides the layer structure. Output quality standards apply to all output types, not just web interfaces. Accessibility references WCAG 2.2 for principles; specific targets are project-level per ADR-002. Load testing is required for any service with external users.

**Section 7 (Monitoring and Observability)** - Delivery health, SLOs, and observability are each referenced to authoritative external sources rather than redocumented.

**Section 8 (Learning from Failure)** - Blameless post-mortems come from SRE Book chapter 15. The incident taxonomy classifies incidents to support pattern detection. Severity definitions (P0-P3) provide clear response expectations. Incident communication ensures users are informed during outages. Technical debt tracking converts acknowledged debt into tracked work items. Codebase health measurement (Section 8.6) encodes the DORA code-maintainability capability.

**Section 9 (Technology Adoption)** - The exit strategy question comes from the OWASP finding that vendor lock-in risk is underweighted. External standards management (Section 9.3) treats external standards as dependencies with version tracking and review cadence.

**Former Section 10 (Implementation and Handoff)** - This section was reorganized: security baseline content moved to Section 5.10, migration safety to Section 5.7, security design principles to Section 3.2. OWASP ASVS Level 1 is referenced rather than redocumented. Security design principles (Defense in Depth, Secure by Default, Fail Secure, Separation of Duties, Zero Trust) are foundational. Data classification, retention policies, encryption at rest and in transit, and regulatory compliance mapping close real gaps. Migration safety (backward-compatible, zero-downtime, rollback) and backup/disaster recovery (RTO, RPO, restore cadence) ensure operations documentation is complete.

---

## What Was Deliberately Excluded

- **AI-specific content from STANDARDS.md** - a first-party addendum (`docs/addenda/ai-ml.md`) is provided per ADR-002 and ADR-004
- **Cost governance** - domain-specific; depends heavily on deployment type, provider, and business model
- **Specific tooling requirements** - the standard covers practices, not tool choices
- **Scenario-specific patterns** (circuit breakers, AsyncAPI, container probes, Cross-Origin Resource Sharing (CORS), saga pattern, etc.) - first-party addenda per ADR-002 and ADR-004
- **Software Bill of Materials (SBOM)** - an emerging supply chain security practice; the dependency vulnerability scanning in Section 5.2 covers the universal requirement; SBOM specifics are a rapidly evolving area not yet stable enough for a universal principle
- **Cost Optimization / FinOps** - AWS Well-Architected pillar evaluated; excluded as too cloud-provider-specific and business-model-dependent
- **Sustainability** - AWS Well-Architected pillar evaluated; excluded as not yet universally applicable across deployment contexts
- **Chaos engineering** - one implementation approach for verifying "Design for Failure" (Section 3.2); the principle is universal, the practice is not
- **On-call rotation structure** - multi-team addendum; meaningfully different between team sizes and organizational structures
- **RFC process** - multi-team addendum; only applies when cross-team coordination is required
- **RACI and decision frameworks** - organizational process tools, not engineering principles; decision authority is covered contextually in Section 1.4, Section 2.4, Section 2.5, and Section 5.7

The following were evaluated during an external practitioner review (2026-03-19) and not incorporated. Full evaluation in [ADR-008](../docs/decisions/ADR-008-external-practitioner-review-2026-03-19.md).

- **ISO document control / uncontrolled copy notation** - ESE is not an ISO 9001 quality management system. Version history and the CHANGELOG already handle this for a software engineering context. Teams operating under ISO certification are governed by regulatory addenda.
- **"Where" element in the problem statement** - already elicited through "Who has this problem?" which prompts for "specific user type, role, or context." Context covers environment and dependencies.
- **Current State / Optimal State / Recommended State progression** - a structured AS-IS/TO-BE methodology from enterprise architecture. Fails ADR-005: most software teams will not do optimal state analysis consistently. The §1.2 progression (problem research through PRD) achieves the same structured thinking without requiring formal state modeling.
- **Weakest link as a standalone design principle** - already covered by §3.2 "Design for Failure" ("assume every dependency will be unavailable at some point") and the failure modes table required in the architecture template.
- **Interoperability and compatibility matrices** - already addressed through the setup.md requirement in §4.1, §5.9 (Twelve-Factor App), and the Web Applications addendum.
- **UI/UX graphic standards** - design system concern, not an engineering principle. §6.3 covers output quality and accessibility gates. Specific graphic standards belong in a project design system.
- **Naming convention prescription** - §3.2 requires a documented naming standard enforced by tooling. Prescribing a specific convention (camelCase, snake_case, etc.) violates ADR-002: the choice is technology-specific and a project decision.

One item from the same review was incorporated: system-level disaster recovery documentation requirement (§5.6, v1.1.2). The DR sentence was added because §5.6 already required infrastructure reproducibility but did not require documenting or testing the recovery path.

---

## §7.7 Measurement Integrity - Statistical Foundations

> Relocated from STANDARDS.md §7.7 per ADR-020. The three gate sentences remain inline in §7.7. This section provides the theoretical context.

Before acting on any metric, validate that the measurement system is measuring what you believe it is. A monitoring strategy built on metrics that do not accurately represent system behavior produces responses to phantom problems and misses real ones.

**Validate before trusting (detail).** The measurement system must be reliable: it captures what it claims to capture, its collection method is consistent across environments and time periods, and known sources of measurement error are understood and bounded. Acting on unvalidated metrics is equivalent to navigating with an uncalibrated instrument.

**Distinguish signal from noise (detail).** Every stable process produces natural variation. A stable process will show fluctuating measurements within predictable bounds even when nothing has changed. Responding to common cause variation as though it were a signal, a practice known as tampering, increases variation rather than reducing it. The response to common cause variation is to improve the process; the response to special cause variation is to find and remove the specific cause.

**Measure process capability (detail).** Two processes with radically different capability levels are indistinguishable to threshold-only monitoring during the periods when both happen to pass. Only capability measurement reveals whether a process is reliably meeting its targets or narrowly clearing them, and the response to each is different.
