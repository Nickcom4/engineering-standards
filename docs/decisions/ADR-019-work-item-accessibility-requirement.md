---
type: adr
id: ADR-019
title: "Work Item Records Must Be Accessible to Authorized Reviewers"
status: Accepted
date: 2026-03-24
deciders: "Gate authority (see standards-application.md)"
implements:
  - REQ-4.2-01
  - REQ-2.2-07
---

# ADR-019: Work Item Records Must Be Accessible to Authorized Reviewers

## Context

§2.2 defines the seven required attributes of a work item (title, acceptance criteria, dependencies, owner, discovering item, priority, class of service). §2.3 defines the Definition of Done. Neither section specifies where work items are stored or whether records must be accessible to anyone other than the original author.

This gap has a concrete consequence: a third-party auditor, a new team member, or an internal quality reviewer reading only the project repository cannot verify:

- §2.1 DEFINE: that acceptance criteria existed before BUILD began
- §2.2: that work items had all seven required attributes
- §2.3: that gate evidence was attached before close

If the work item system is private (a personal work item database, a private Jira project, a local file), the audit trail for §2 compliance is invisible to everyone except the original author. §7.3 requires an audit trail for consequential actions but does not address work item lifecycle. §2.3 (new person readiness, in Definition of Done) requires that a new team member can understand what a feature does and why it exists; this is impossible if the work items that drove the feature are inaccessible.

**Cost of doing nothing:** Projects that genuinely apply the standard have no way to demonstrate that compliance. An external adopter asking "how do I prove my team followed the lifecycle?" receives no answer from the standard. As ESE moves toward external adoption, this gap would be the first thing a third-party reviewer notices.

## Decision

Add an accessibility requirement to §2.2 and a corresponding gate to §2.3.

**§2.2 addition (after the backlog hygiene paragraph):**

Work item records are a permanent audit artifact. The system used to track work items must be accessible to authorized reviewers for the life of the project. New team members, internal quality reviewers, and external auditors must be able to read the history of what was decided, when, what acceptance criteria were written, and what gate evidence was attached. Projects using a publicly accessible work item system (GitHub Issues, a shared project-management tool) satisfy this by default. Projects using a private or personal system must export closed work item records to a committed location in the project repository at close time. An audit that can only be performed by someone with access to the original author's private tools is not an independently verifiable audit trail.

**§2.3 Definition of Done addition:**

- [ ] Work item record accessible: stored in a system accessible to authorized reviewers, or exported to the repository at close

## Consequences

### Positive

- §2 compliance is auditable by anyone with repository access when the fallback path (export) is used
- Closes the visibility gap surfaced by the pre-release audit
- Consistent with §2.3 (new person readiness, in Definition of Done) and §7.3 (audit trail): the work item history is part of the delivery record
- Does not mandate a specific tool; the requirement is accessibility, not format

### Negative

- Teams using private work item systems must add an export step to their close process
- For high-volume teams, per-item export files can accumulate; teams may choose a summary export (one file per sprint, per milestone) as a reasonable alternative
- "Accessible to authorized reviewers" requires the team to define who counts as authorized; this is left as a project decision

## Alternatives Considered

### Require a publicly accessible work item system

Rejected. Too prescriptive for a universal standard. Many teams have legitimate reasons to use internal-only tools (security constraints, enterprise policy). The accessibility requirement achieves the audit goal without mandating a specific system.

### Require work item records in the repository unconditionally

Rejected. Redundant for teams already using publicly accessible systems (GitHub Issues, etc.) and imposes mechanical overhead for no benefit. The requirement should fire only when the primary system is not independently accessible.

### No change

Rejected. The gap is real: projects that apply the standard cannot demonstrate compliance to anyone who lacks access to their work item system. External adoption makes this immediately visible.

### Require a machine-readable export format

Considered but deferred. Specifying format (JSON, Markdown, YAML) is tooling-level detail that belongs in a project's standards-application document, not in the universal standard. The standard requires accessibility and committed storage; format is a project decision.

## Validation

**Pass condition:** A new team member or external auditor with only repository access can read the work item records for a recently completed feature (its title, acceptance criteria, class of service, and gate evidence) without asking the original author or requesting access to a private system.

**Trigger:** First external adoption review after this ADR is accepted, or first internal audit where a reviewer does not have access to the team's work item system.

**Failure condition:** A reviewer cannot determine whether AC existed before BUILD for a given feature without being granted access to the original author's private system. If this occurs, the accessibility requirement was not met and the close step was incomplete.
