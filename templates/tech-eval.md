---
type: tech-eval
stage:
  - design
applies-to:
  - all
implements:
  - REQ-9.1-01
---

# Technology Evaluation: {Technology Name}

<a name="REQ-TPL-48"></a>
**REQ-TPL-48** `advisory` `continuous` `soft` `all`
Required by §9.1 before adopting any new technology, framework, or external service.

> Required by [§9.1](../STANDARDS.md#91-evaluation-framework) before adopting any new technology, framework, or external service. Time-boxes prevent unbounded research. Every evaluation produces a documented Proceed / Reject / Defer decision with an ADR ([templates/adr.md](adr.md)).
>
> A rejected evaluation is not wasted work - it prevents re-evaluating the same option. Per [§9.2](../STANDARDS.md#92-technology-adr-backlog): every technology decision in active use that lacks an ADR needs a retroactive one.

**Evaluator:** {name}
**Date started:** {date}
**Decision deadline:** {date}

---

## Problem Statement

> [§9.1](../STANDARDS.md#91-evaluation-framework): what problem does this technology solve? What is used today and why is it insufficient?

What problem does this technology solve?
What are we using today and why is it insufficient?

---

## Step 1: Research (time-box to 1-2 days)

> [§9.1](../STANDARDS.md#91-evaluation-framework): research phase. Stop at the time-box - additional research beyond 2 days is scope creep, not diligence.

**What problem it solves:**

**Known alternatives:**
| Alternative | Why considered | Why not chosen for PoC |
|-------------|---------------|----------------------|
| {Alternative} | | |

**Known failure modes:**

**Ongoing maintenance cost and operator toil:**

<a name="REQ-TPL-49"></a>
**REQ-TPL-49** `advisory` `continuous` `soft` `all`
Security exposure - does it process sensitive data? What attack surface does it add? Per §5.

**Security exposure** - does it process sensitive data? What attack surface does it add? Per [§5.2](../STANDARDS.md#52-dependency-management): high-severity vulnerabilities in dependencies block merge.

**Compatibility with existing observability tooling** - can it be traced, measured, and monitored with current tools? Per [§7.6](../STANDARDS.md#76-observability-standard).

**Exit strategy** - what happens if the vendor changes terms, pricing, or quality? Per [§9.1](../STANDARDS.md#91-evaluation-framework).

**License:** {license name} - compatible with distribution requirements? {yes/no} - Per [§5.2](../STANDARDS.md#52-dependency-management): incompatible licenses must be identified before the dependency ships.

**Research verdict:** Proceed to PoC / Reject / Defer

*If Reject or Defer: document the reason below and stop. This record prevents re-evaluating the same option.*

---

## Step 2: Proof of Concept (time-box to 3 days)

> [§9.1](../STANDARDS.md#91-evaluation-framework): build the smallest thing that validates the core assumption. Measure actual performance, not claimed performance.

**Core assumption being validated:**

**What was built:**

**Measured performance** (actual numbers, not claimed):

**What breaks if this dependency is removed:**

**Surprises discovered:**

**PoC verdict:** Proceed / Reject

---

## Step 3: Decision

<a name="REQ-TPL-50"></a>
**REQ-TPL-50** `advisory` `continuous` `soft` `all`
§9.1: an ADR is required for every Proceed decision - before integration begins. Per §4.2.

> [§9.1](../STANDARDS.md#91-evaluation-framework): an ADR is required for every Proceed decision - before integration begins. Per [§4.2](../STANDARDS.md#42-adr-format).

**Decision:** Proceed / Reject / Defer

**Rationale:**

**If Proceed - rollback plan before integration begins:**

**If Reject - reason documented to prevent future re-evaluation:**

<a name="REQ-TPL-51"></a>
**REQ-TPL-51** `advisory` `continuous` `soft` `all`
*ADR required: templates/adr.md*.

*ADR required: [templates/adr.md](adr.md)*

---

## Step 4: Integration (complete only if Decision is Proceed)

> [§9.1](../STANDARDS.md#91-evaluation-framework): integration follows the full development lifecycle ([§2.1](../STANDARDS.md#21-the-lifecycle)) - no shortcuts because "it's just a library."

**Architecture document location:** {link - per [§3.1](../STANDARDS.md#31-component-architecture-template)}

**Documentation updated** - per [§4.8](../STANDARDS.md#48-documentation-layers):
- [ ] Runbook updated with failure mode and recovery procedure
- [ ] Setup docs updated with new dependency

**Monitoring configured** - per [§7.1](../STANDARDS.md#71-service-health-checks), [§7.6](../STANDARDS.md#76-observability-standard):
- [ ] Health check
- [ ] Error rate alert
- [ ] Latency alert

**Dependency declared and version-pinned** - per [§5.2](../STANDARDS.md#52-dependency-management):
- [ ] Added to dependency manifest with pinned version
- [ ] Vulnerability scan passing

**Full development lifecycle followed** - per [§2.1](../STANDARDS.md#21-the-lifecycle): [ ]

---

*Decision date: {date}*
*ADR link: {link}*
