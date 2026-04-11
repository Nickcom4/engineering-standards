---
type: adr
id: ADR-016
title: FMEA Requirement for High-Risk Features in DESIGN Step
status: Accepted
date: 2026-03-23
deciders: gate authority
section: "§2.1 DESIGN"
implements:
  - REQ-4.2-01
  - REQ-2.1-37
  - REQ-2.1-41
---

# ADR-016: FMEA Requirement for High-Risk Features in DESIGN Step


## Context

The DESIGN step currently requires an Architectural Decision Record for structural
decisions: new components, replaced approaches, new dependencies, changed service
communication. This covers decisions about how the system is structured. It does not
require analysis of how individual components within the chosen structure can fail.

For most features, this gap is acceptable. For features touching authentication,
payments, data mutation, or external integrations, it is not. These four categories
share a property: their failure modes have high severity, are often invisible to
functional testing, and are expensive or irreversible when they surface in production.
A password reset endpoint with an inadequate token generator passes all functional
tests. A payment endpoint without idempotency keys behaves correctly in unit tests but
double-charges under retry conditions. A bulk data mutation with no rollback path
passes all tests until the first production run on live data.

Failure Mode and Effects Analysis (FMEA) is the established bottom-up method for
enumerating failure modes at design time: for each component or function, name what
could fail, the effect on the system, the root cause, the current controls, and a risk
score derived from Severity, Occurrence, and Detectability. The Risk Priority Number
(RPN = S x O x D) produces a prioritizable list: high-RPN items require action before
BUILD; low-RPN items are accepted risks or already controlled.

The cost of not requiring this: failure modes in the four trigger categories are first
discovered in testing (expensive but recoverable) or in production (expensive,
sometimes irreversible, and logged as incidents that require post-mortems, credential
rotation, and user communication).


## Decision

Add FMEA as a required DESIGN artifact for features touching authentication, payments,
data mutation, or external integrations. High-RPN failure modes, and any failure mode
with a Severity score of 9 or 10 regardless of RPN, require design changes or
additional controls before BUILD begins. Template and worked example: templates/fmea.md.

**Scope of "data mutation":** Bulk operations, delete and truncate operations, schema
migrations, and write operations on data that cannot be easily reversed. Single-row
inserts and updates on non-critical data are not in scope.

**Scope of "external integrations":** Any call to a third-party API, webhook delivery,
or message queue interaction where failure or latency in the external system affects the
feature's behavior.


## Consequences

### Positive

- Failure modes in the highest-risk feature categories are enumerated at design time,
  when they are cheapest to address
- The RPN score produces a prioritized action list: teams address the highest-risk
  failure modes first rather than treating all risks equally
- FMEA findings feed directly into acceptance criteria and test planning, closing the
  gap between design-time risk identification and verification coverage
- Consistent with the Cost of Quality framing added to §1.1: investing in quality at
  the DESIGN stage reduces the cost of poor quality at the VERIFY and DEPLOY stages
- FMEA is the bottom-up complement to the top-down FTA requirement added in §3.1
  for always-on services with defined SLOs

### Negative

- Additional DESIGN time for the four trigger categories; some teams will see this as
  overhead on features they consider low-risk within these categories
- The RPN threshold is a project decision, not prescribed by the standard; teams must
  define and maintain their own threshold in their standards application document
- Practitioners must learn the FMEA scoring scales (Severity, Occurrence,
  Detectability); the template provides the scales and a worked example, but there is
  still a learning cost
- Score gaming is possible: a team under pressure can understate Severity or overstate
  Detectability. This is a cultural risk that no template requirement prevents; it is
  the same cultural risk as bypassing ADRs or skipping post-mortems


## Alternatives Considered

### No FMEA requirement (current state)

Rejected. The four trigger categories have a documented pattern of expensive production
failures that stem from unexamined failure modes at design time. The current ADR
requirement does not fill this gap because ADRs document structural decisions, not
failure mode analysis of the components within those decisions.

### Generic risk checklist (not scored FMEA)

Considered. A checklist (for example: "have you considered token expiry? rate limiting?
idempotency?") is simpler to complete and requires no scoring knowledge. Rejected
because a checklist produces a binary pass/fail with no prioritization. The RPN score
tells the team which failure modes require action and in what order. A checklist for
every possible failure mode in all four trigger categories would be too long to be
useful; FMEA scopes to the specific feature being designed.

### Require FMEA for all features

Rejected per ADR-005 (Practical Over Theoretical). A single-row data update, a copy
change, and a styling fix do not have meaningful failure modes that differ from those
already covered by the standard test pyramid. Applying FMEA to all features would make
the requirement impractical and train teams to complete it perfunctorily.

### FMEA as optional guidance rather than a required gate

Rejected per ESE §1.4 (gates, not guidelines). An optional recommendation will be
skipped under schedule pressure, precisely the conditions under which failure mode
analysis matters most. A requirement that is skippable provides no protection in the
situations where skipping is most tempting.


## Validation

**Pass condition:** At the first adoption review, at least one project has completed a
FMEA for an authentication or payment feature and documented at least one failure mode
that was not already covered by their existing test plan. At the first post-mortem for
a high-risk feature failure: the post-mortem does not describe a failure mode that
would have been identified by a FMEA completed at design time; if it does, the
requirement did not change behavior and should be reviewed for scope or enforcement.

**Trigger:** First external adoption review after publication.

**Failure condition:** No adopter uses the FMEA template, or all adopters report that
FMEA added no value over their existing process for the four trigger categories.
