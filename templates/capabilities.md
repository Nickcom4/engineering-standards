---
type: capabilities
stage:
  - define
applies-to:
  - feature
  - epic
implements:
  - REQ-1.2-01
  - REQ-1.2-02
---

# Capabilities: {Feature or Product Name}

<a name="REQ-TPL-20"></a>
**REQ-TPL-20** `advisory` `continuous` `soft` `all`
Capabilities document for {Feature or Product Name}.

> Capabilities document for {Feature or Product Name}. Produced at Step 2 of the [§1.2 Document Progression](../STANDARDS.md#12-document-progression). This document describes what users will be able to DO - in observable, non-technical terms. No implementation details belong here. Write it from the user's perspective. If an engineer must understand system internals to parse a capability statement, rewrite it.
>
> Requires completed problem research ([§1.2 Step 1](../STANDARDS.md#12-document-progression)). Input to PRD ([§1.2 Step 3](../STANDARDS.md#12-document-progression)).

---

## References

- Problem research: [{Problem Name}]({path-to-problem-research-doc})

---

## Users

> [§1.2](../STANDARDS.md#12-document-progression), [§2.7](../STANDARDS.md#27-user-feedback): who will use this? Be specific. Vague personas produce vague capabilities.

| User type | Context | What they cannot do today |
|-----------|---------|--------------------------|
| {Role or persona} | {When and where they encounter this problem} | {The gap this feature closes} |

---

## Capabilities

> [§1.2](../STANDARDS.md#12-document-progression): what will each user type be able to do? State each as an observable action or outcome. Per [§1.1](../STANDARDS.md#11-before-starting-any-significant-work): "what does solved look like - concretely?"
>
> **Format:** {User type} can {observable action} so that {outcome they care about}.
>
> Do not describe HOW. Do not reference components, APIs, queues, schemas, or internal mechanics. If understanding the capability requires knowing how the system works, rewrite it.

### {User Type 1}

- [ ] Can {observable action} so that {outcome}
- [ ] Can {observable action} so that {outcome}

### {User Type 2}

- [ ] Can {observable action} so that {outcome}

---

## First Principles Check

> [§1.1](../STANDARDS.md#11-before-starting-any-significant-work): run this check before finalizing capabilities.

- What is this fundamentally trying to do?
<a name="REQ-TPL-21"></a>
**REQ-TPL-21** `advisory` `continuous` `soft` `all`
What constraints cannot change?.

- What constraints cannot change?
- What is the simplest set of capabilities that meets the requirement?

---

## Explicitly NOT Included

> [§1.1](../STANDARDS.md#11-before-starting-any-significant-work): OUT of scope is equally important and often omitted. Name what is excluded before implementation begins - this section makes the boundary defensible and prevents creep.

| Capability | Phase | Rationale |
|-----------|-------|-----------|
| {Something a reader might expect} | Phase 2 / Out of scope | {Why not now, or why never - per [§1.3](../STANDARDS.md#13-roadmap-discipline)} |

---

## Success Signals (User-Visible)

> [§1.1](../STANDARDS.md#11-before-starting-any-significant-work): "what does solved look like - concretely?" These are observable changes in user experience, not technical metrics.

- {Users can now X, where before they had to Y}
- {Time to complete workflow W drops from {current} to {target}}
- {Category of support request or user feedback decreases}

---

## Open Questions

> Unresolved questions that could change the scope or shape of the capabilities. Per [§2.2](../STANDARDS.md#22-work-item-discipline): work is not ready to proceed until these are resolved or explicitly deferred.

| Question | Impact if unresolved | Who can answer | Due |
|----------|---------------------|----------------|-----|
| | | | |

---

## Approval

<a name="REQ-TPL-22"></a>
**REQ-TPL-22** `advisory` `continuous` `soft` `all`
§1.4 gate authority: capabilities must be approved before a PRD is written.

> [§1.4](../STANDARDS.md#14-project-first-principles) gate authority: capabilities must be approved before a PRD is written. A PRD written before capabilities are approved produces an implementation spec masquerading as requirements. For single-operator projects: the gate authority approves. For multi-party teams: add a line per domain approver.

- [ ] Approved - {name, role, date}

---

## Next Step

If capabilities are approved: write a PRD. Template: [templates/prd.md](prd.md).

---

*Completed by: {name}*
*Date: YYYY-MM-DD*
*Project: {project name}*
*Problem research: {link}*
