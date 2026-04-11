# Addendum: Multi-Team Organizations

> Extends [Excellence Standards - Engineering](../../STANDARDS.md). Apply when more than one team contributes to or depends on your project.

<a name="REQ-ADD-MT-10"></a>
**REQ-ADD-MT-10** `advisory` `continuous` `soft` `addendum:MT` `deprecated:non-first-principles`
~~Deprecated: meta-information about the addendum, not a testable requirement.~~

> Per-stage lifecycle activation of this addendum's requirements is documented in the [§2.1 per-stage blocks](../../STANDARDS.md#per-stage-operational-blocks). When this addendum's requirements are listed in the §2.1 table, those entries are authoritative; update both in the same commit.

---

## Lifecycle Stage Mapping

This table shows which requirements from this addendum activate at each ESE lifecycle stage. The [§2.1 per-stage table](../../STANDARDS.md#per-stage-operational-blocks) is the authoritative source; update both in the same commit when either changes.

| Stage | Requirements active |
|---|---|
| **DEFINE** | Write RFC before work begins if any of the RFC trigger conditions apply. |
| **DESIGN** | Document team topology: which team owns the component end-to-end, what the interface boundary is, whether the team can deploy independently. Establish or confirm working agreements with all teams that will be affected. |
| **BUILD** | Multi-team requirements at BUILD are organizational and lifecycle-boundary concerns, not implementation details. No addendum-specific artifacts required at this stage beyond what §2.1 mandates. |
| **VERIFY** | Confirm RFC was written and reviewed by affected teams if triggered. Confirm working agreements cover the new interface or behavior. |
| **DEPLOY** | If deploying as part of a coordinated multi-team deployment: release coordination plan distributed and all teams confirmed ready before the deployment sequence begins. |
| **MONITOR** | On-call rotation and escalation path documented and verified for the affected service. |
| **Continuous** | Working agreements reviewed at least quarterly. Cross-team dependency notifications sent before any change that will affect another team's work. |

---

## Table of Contents

- [Team Topology and Conway's Law (Required)](#team-topology-and-conways-law-required)
- [Working Agreements (Required)](#working-agreements-required)
- [RFC Process (Required for Cross-Team Changes)](#rfc-process-required-for-cross-team-changes)
- [Release Coordination and Versioning (Required)](#release-coordination-and-versioning-required)
- [On-Call and Escalation (Required)](#on-call-and-escalation-required)
- [Cross-Team Dependency Notification (Required)](#cross-team-dependency-notification-required)
- [Change Approval](#change-approval)
- [Platform Team Responsibilities](#platform-team-responsibilities)
- [Testing Gap Audit Additions](#testing-gap-audit-additions)
- [Work Session Log Additions](#work-session-log-additions)


## Team Topology and Conway's Law (Required)

<a name="REQ-ADD-MT-01"></a>
**REQ-ADD-MT-01** `artifact` `design` `hard` `addendum:MT`
Before any significant new component: document which team owns it end-to-end.

<a name="REQ-ADD-MT-32"></a>
**REQ-ADD-MT-32** `artifact` `design` `hard` `addendum:MT` `deprecated:REQ-ADD-MT-01`
~~Deprecated: consolidated into REQ-ADD-MT-01.~~

<a name="REQ-ADD-MT-33"></a>
**REQ-ADD-MT-33** `artifact` `design` `hard` `addendum:MT` `deprecated:REQ-ADD-MT-01`
~~Deprecated: consolidated into REQ-ADD-MT-01.~~

Per Section 3.4 of the universal standard: team boundaries and component boundaries must be designed together. Before any significant new component is built, document:
- Which team owns it end-to-end (builds it, operates it, on-call for it)
- What its interface boundary is with other teams
- Whether the team can deploy, test, and release it independently

Teams that must wait on other teams for every change are architecturally coupled regardless of the technical design. Resolve the coupling before adding more features.

## Working Agreements (Required)

<a name="REQ-ADD-MT-02"></a>
**REQ-ADD-MT-02** `artifact` `continuous` `hard` `addendum:MT`
Dependent teams have a documented working agreement.

<a name="REQ-ADD-MT-34"></a>
**REQ-ADD-MT-34** `artifact` `continuous` `hard` `addendum:MT` `deprecated:REQ-ADD-MT-02`
~~Deprecated: consolidated into REQ-ADD-MT-02.~~

<a name="REQ-ADD-MT-13"></a>
**REQ-ADD-MT-13** `artifact` `continuous` `hard` `addendum:MT` `deprecated:REQ-ADD-MT-02`
~~Deprecated: consolidated into REQ-ADD-MT-02.~~

<a name="REQ-ADD-MT-14"></a>
**REQ-ADD-MT-14** `artifact` `continuous` `hard` `addendum:MT` `deprecated:REQ-ADD-MT-02`
~~Deprecated: consolidated into REQ-ADD-MT-02.~~

<a name="REQ-ADD-MT-15"></a>
**REQ-ADD-MT-15** `artifact` `continuous` `hard` `addendum:MT` `deprecated:REQ-ADD-MT-02`
~~Deprecated: consolidated into REQ-ADD-MT-02.~~

<a name="REQ-ADD-MT-16"></a>
**REQ-ADD-MT-16** `artifact` `continuous` `hard` `addendum:MT` `deprecated:REQ-ADD-MT-02`
~~Deprecated: consolidated into REQ-ADD-MT-02.~~

<a name="REQ-ADD-MT-17"></a>
**REQ-ADD-MT-17** `artifact` `continuous` `hard` `addendum:MT` `deprecated:REQ-ADD-MT-02`
~~Deprecated: consolidated into REQ-ADD-MT-02.~~

<a name="REQ-ADD-MT-18"></a>
**REQ-ADD-MT-18** `artifact` `continuous` `hard` `addendum:MT` `deprecated:REQ-ADD-MT-02`
~~Deprecated: consolidated into REQ-ADD-MT-02.~~

<a name="REQ-ADD-MT-19"></a>
**REQ-ADD-MT-19** `artifact` `continuous` `hard` `addendum:MT` `deprecated:REQ-ADD-MT-02`
~~Deprecated: consolidated into REQ-ADD-MT-02.~~

<a name="REQ-ADD-MT-05"></a>
**REQ-ADD-MT-05** `artifact` `continuous` `hard` `addendum:MT`
Reviewed at least quarterly.

Teams that depend on each other must establish explicit, documented agreements about how they will work together. A working agreement is not a process meeting; it is a short written document covering the expectations that, when unspoken, cause the most friction.

A working agreement between two teams must cover all of the following topics:

- **PR review response time:** How long does the receiving team have to review a pull request that affects a shared interface? State the time bound explicitly (example: 2 business days for standard changes, 4 hours for changes needed to resolve a P1 incident).
- **Incident response:** If Team A's service causes degradation for Team B's users, who does Team B contact and what is the maximum response time by severity?
- **Change notification lead time:** How many days or sprints in advance must Team A notify Team B of a breaking change? State the number explicitly (example: one sprint minimum for interface changes, two sprints for changes requiring consumer migration).
- **Code ownership:** Which repositories, modules, or code paths does each team own exclusively? Which are shared, and what is the process for proposing changes to shared code?
- **API stability commitment:** After an API or data contract is published for cross-team consumption, how long must it remain stable before the producing team may introduce a breaking change? State the minimum support window explicitly (example: 90 days with a documented migration path provided before the deprecation window begins).
- **On-call handoff:** What must the outgoing on-call communicate to the incoming on-call? At minimum: open incidents, pending cross-team deployments, and any known degraded state in services the other team depends on.
- **Decision authority:** Which decisions can Team A make unilaterally, which require Team B's input, and which require joint approval?
- **Communication channel:** Where do the teams communicate about dependencies? State the channel name and the expected response time during business hours.

Working agreements are reviewed at least quarterly and updated when friction surfaces. An unwritten working agreement is not an agreement; it is an assumption waiting to cause an incident.

## RFC Process (Required for Cross-Team Changes)

<a name="REQ-ADD-MT-03"></a>
**REQ-ADD-MT-03** `gate` `define` `hard` `addendum:MT` `per-item`
An RFC is written before implementation begins when any trigger condition is true (API change, behavior change, capability removal, coordinated deploy, auth change, shared schema change).

An RFC is required before implementation begins when any of the following conditions is true. Evaluate each condition independently; one true condition is sufficient to require an RFC.

| Condition | RFC required? |
|---|---|
| The change adds, modifies, or removes a field in an API, event, or data contract consumed by another team | Yes |
| The change alters the behavior of an existing endpoint, event, or message such that a consuming team's code could produce different results, even if the schema is unchanged | Yes |
| The change removes a capability, endpoint, event, or feature that another team's code or documented process depends on | Yes |
| The change requires another team to deploy their service within a specific time window or in a specific sequence relative to yours | Yes |
| The change alters the authentication, access control, or credential requirements for a shared service | Yes |
| The change modifies a shared data store schema (tables, fields, indexes) in a way that affects another team's reads or writes | Yes |

<a name="REQ-ADD-MT-11"></a>
**REQ-ADD-MT-11** `advisory` `continuous` `soft` `addendum:MT` `deprecated:non-first-principles`
~~Deprecated: advisory guidance, not testable.~~

RFC not required when: the change is purely additive (new optional fields or new endpoints only, no existing behavior changed for any consuming team) and no other team must take any action. When in doubt: write the RFC. A false-positive RFC costs one document; a missed RFC costs an incident.

An RFC is a short document:
- **Problem:** What are we solving and why now?
- **Proposed change:** What is the interface or behavior change?
- **Affected teams:** Who must know about or adapt to this change?
- **Timeline:** When does this change ship, and how long is the migration period?
- **Alternatives considered:** What other approaches were evaluated?

RFCs are shared with affected teams before work begins. Affected teams have a defined review window (typically 5 business days) to raise concerns. The proposing team incorporates feedback or documents why it was not incorporated.

## Release Coordination and Versioning (Required)

<a name="REQ-ADD-MT-04"></a>
**REQ-ADD-MT-04** `artifact` `deploy` `hard` `addendum:MT`
A release coordination plan is distributed before coordinated deployment begins.

<a name="REQ-ADD-MT-20"></a>
**REQ-ADD-MT-20** `artifact` `deploy` `hard` `addendum:MT` `deprecated:REQ-ADD-MT-04`
~~Deprecated: consolidated into REQ-ADD-MT-04.~~

<a name="REQ-ADD-MT-21"></a>
**REQ-ADD-MT-21** `artifact` `deploy` `hard` `addendum:MT` `deprecated:REQ-ADD-MT-04`
~~Deprecated: consolidated into REQ-ADD-MT-04.~~

<a name="REQ-ADD-MT-22"></a>
**REQ-ADD-MT-22** `artifact` `deploy` `hard` `addendum:MT` `deprecated:REQ-ADD-MT-04`
~~Deprecated: consolidated into REQ-ADD-MT-04.~~

<a name="REQ-ADD-MT-23"></a>
**REQ-ADD-MT-23** `artifact` `deploy` `hard` `addendum:MT` `deprecated:REQ-ADD-MT-04`
~~Deprecated: consolidated into REQ-ADD-MT-04.~~

<a name="REQ-ADD-MT-24"></a>
**REQ-ADD-MT-24** `artifact` `deploy` `hard` `addendum:MT` `deprecated:REQ-ADD-MT-04`
~~Deprecated: consolidated into REQ-ADD-MT-04.~~

When a change requires more than one team to deploy in a coordinated sequence, the proposing team must produce and distribute a release coordination plan before any team begins deployment.

### Coordinated Deployment

A release coordination plan must include:

| Field | Requirement |
|---|---|
| Deployment sequence | The order in which each team deploys, with explicit wait conditions between steps (example: Team B deploys only after Team A's service passes its health check) |
| Dependency confirmation | Each team confirms readiness in the designated channel before the sequence begins |
| Go/no-go checkpoint | A named role with authority to halt the deployment at any step |
| Rollback trigger | The observable conditions that initiate a rollback (example: error rate exceeds 1% for more than 2 minutes, health check fails) |
| Rollback sequence | The order in which teams roll back, and who initiates each step |
| Communication channel | Where teams post status updates during the deployment window |

Do not begin a coordinated deployment until all teams have confirmed readiness in the designated channel.

### Version Compatibility Requirements

<a name="REQ-ADD-MT-06"></a>
**REQ-ADD-MT-06** `artifact` `deploy` `hard` `addendum:MT`
Every service with cross-team consumers documents its current stable version.

<a name="REQ-ADD-MT-25"></a>
**REQ-ADD-MT-25** `artifact` `deploy` `hard` `addendum:MT` `deprecated:REQ-ADD-MT-06`
~~Deprecated: consolidated into REQ-ADD-MT-06.~~

<a name="REQ-ADD-MT-26"></a>
**REQ-ADD-MT-26** `artifact` `deploy` `hard` `addendum:MT` `deprecated:REQ-ADD-MT-06`
~~Deprecated: consolidated into REQ-ADD-MT-06.~~

<a name="REQ-ADD-MT-27"></a>
**REQ-ADD-MT-27** `artifact` `deploy` `hard` `addendum:MT` `deprecated:REQ-ADD-MT-06`
~~Deprecated: consolidated into REQ-ADD-MT-06.~~

Every service with cross-team consumers must document its compatibility contract:

- **Current stable version:** The version all consumers are expected to run against.
- **Supported versions:** The list of older versions still receiving compatibility guarantees. Consumers running versions not on this list have no breakage guarantee.
- **Deprecation timeline:** When a version or API is deprecated, the removal date must be stated before deprecation is announced (example: deprecated on date X, removed no earlier than 90 days later).
- **Breaking change definition:** A published, explicit definition of what constitutes a breaking change for this service (example: removing a required field, changing a field type, changing error codes). Consuming teams use this definition to determine independently whether a proposed change requires an RFC.

### Rollback Coordination

When one team rolls back a service that other teams depend on:

1. Notify all consuming teams in the designated communication channel before initiating the rollback.
2. State the version being rolled back to and the expected duration of the rollback window.
<a name="REQ-ADD-MT-12"></a>
**REQ-ADD-MT-12** `advisory` `continuous` `soft` `addendum:MT` `deprecated:non-first-principles`
~~Deprecated: advisory guidance.~~

3. Identify any consuming teams that must also roll back to maintain compatibility, and confirm their rollback plan before proceeding.
4. After rollback completes, post a confirmation of system state in the communication channel.

A rollback that breaks a consuming team due to version incompatibility is a coordination failure. The release coordination plan must document compatibility at deployment time to prevent this outcome.

## On-Call and Escalation (Required)

Every service in production has an on-call owner at all times. Define and document:

| Field | Requirement |
|-------|-------------|
| Primary on-call | Named individual or rotation schedule, visible to all teams |
| Rotation cadence | How often primary rotates |
| Escalation path | Who to contact if primary is unreachable or cannot resolve within 30 minutes |
| Escalation contacts | Secondary on-call, team lead, management chain for P0 |
| Handoff procedure | What the outgoing on-call communicates to the incoming on-call |
| On-call expectations | Response time SLA by severity (P0: immediate, P1: 30 min, P2: same day) |

<a name="REQ-ADD-MT-08"></a>
**REQ-ADD-MT-08** `artifact` `deploy` `hard` `addendum:MT`
Every service in production has a named on-call owner.

<a name="REQ-ADD-MT-28"></a>
**REQ-ADD-MT-28** `artifact` `deploy` `hard` `addendum:MT` `deprecated:REQ-ADD-MT-08`
~~Deprecated: consolidated into REQ-ADD-MT-08.~~

<a name="REQ-ADD-MT-29"></a>
**REQ-ADD-MT-29** `artifact` `deploy` `hard` `addendum:MT` `deprecated:REQ-ADD-MT-08`
~~Deprecated: consolidated into REQ-ADD-MT-08.~~

<a name="REQ-ADD-MT-30"></a>
**REQ-ADD-MT-30** `artifact` `deploy` `hard` `addendum:MT` `deprecated:REQ-ADD-MT-08`
~~Deprecated: consolidated into REQ-ADD-MT-08.~~

<a name="REQ-ADD-MT-31"></a>
**REQ-ADD-MT-31** `artifact` `deploy` `hard` `addendum:MT` `deprecated:REQ-ADD-MT-08`
~~Deprecated: consolidated into REQ-ADD-MT-08.~~

The on-call rotation and escalation path live in the service runbook ([§4.8](../../STANDARDS.md#48-documentation-layers), starter: [starters/runbook.md](../../starters/runbook.md)). Every team member must know how to find the on-call owner for any service their work depends on.

## Cross-Team Dependency Notification (Required)

<a name="REQ-ADD-MT-07"></a>
**REQ-ADD-MT-07** `gate` `design` `hard` `addendum:MT` `per-item`
Changes affecting another team's work or timelines are communicated before work begins: what is changing, when, what action required, and who to contact.

When your team plans a change that will affect another team's work or timelines, notify that team before the change is in progress, not after it ships. The minimum notification includes: what is changing, when it ships, what action (if any) the other team must take, and who to contact with questions.

Unannounced breaking changes are incidents, not deployments.

## Change Approval

Per Section 2.5 of the universal standard: risk-based approval, not committee review for every change. Define your project's change tiers:

| Tier | Examples | Approval required |
|------|----------|------------------|
| Standard | Bug fixes, internal refactors, config changes with rollback | Peer review + automated gates |
| Significant | New external-facing behavior, schema changes, dependency upgrades | Team lead review + peer review |
| High-impact | Breaking API changes, credential scope changes, new external integrations | RFC + tech lead approval |
| Emergency | P0 hotfix | Deploy first, retroactive review within 24 hours |

## Platform Team Responsibilities

If your organization has a platform team (or equivalent internal developer platform), the platform team is responsible for:
- Providing self-service infrastructure that stream-aligned teams can use without waiting for the platform team
- Documenting the "paved path": the recommended, supported way to deploy, observe, and secure services
- Measuring and reducing the cognitive load placed on stream-aligned teams by the platform

Stream-aligned teams are responsible for:
- Using the paved path unless there is a documented architectural reason not to
- Reporting gaps, friction, and failures in the platform via the platform team's feedback channel
- Not bypassing the platform in ways that create undocumented dependencies

## Testing Gap Audit Additions

| Gap | Typical impact | Priority |
|---|---|---|
| No RFC coverage test | Cross-team interface changes ship without affected teams being notified | P0 |
| No release coordination plan for coordinated deployments | Deployment sequence and rollback order are undocumented; discovered under incident conditions | P0 |
| No on-call escalation path test | P0 incidents have no verified escalation path until an incident occurs | P1 |
| No working agreement verification | Unwritten agreements are assumptions; SLA breaches go undetected | P1 |
| No cross-team dependency integration test | Changes propagate to consuming teams without compatibility confirmation | P1 |
| No version compatibility documentation | Consumers do not know which versions are supported; rollback compatibility is unknown | P1 |
| No independent deployability test | Teams cannot confirm they can deploy without coordinating with other teams | P2 |

## Work Session Log Additions

<a name="REQ-ADD-MT-09"></a>
**REQ-ADD-MT-09** `artifact` `session-end` `hard` `addendum:MT`
Multi-team work sessions record which teams were consulted, what decisions triggered an RFC, what cross-team dependencies were created or resolved, and coordinated deployment outcomes.

Multi-team work sessions must additionally record: which other teams were consulted or notified, what decisions triggered an RFC, what cross-team dependencies were created or resolved, and whether any coordinated deployment or rollback occurred and what its outcome was.

