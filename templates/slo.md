---
type: slo
stage:
  - monitor
applies-to:
  - all
implements:
  - REQ-7.5-01
---

# SLO Definition: {Capability Name}

<a name="REQ-TPL-45"></a>
**REQ-TPL-45** `advisory` `continuous` `soft` `all`
Service Level Objective definition for {Capability Name}.

> Service Level Objective definition for {Capability Name}. Required by [§7.5](../STANDARDS.md#75-service-level-objectives) for every always-on capability. Every SLO specifies how it is measured, the authoritative data source, the error budget, and what action is taken when the budget is exhausted.
>
> Alert severity levels - page now, same-day review, daily summary - are defined at [§7.5](../STANDARDS.md#75-service-level-objectives). Only page-now alerts interrupt the operator outside normal working hours. Size alerts to match actual severity per [§8.1](../STANDARDS.md#81-incident-taxonomy).

---

## Service Level Indicator (SLI)

<a name="REQ-TPL-46"></a>
**REQ-TPL-46** `advisory` `continuous` `soft` `all`
§7.5: the SLI must be user-centered - it measures what the user experiences, not what the system does internally.

> [§7.5](../STANDARDS.md#75-service-level-objectives): the SLI must be user-centered - it measures what the user experiences, not what the system does internally.

**What is being measured:** {one sentence describing the user-visible behavior}

**Measurement method:** {how it is measured - which metric, which system, query or formula}

**Authoritative data source:** {specific dashboard, metric name, or query - per [§7.2](../STANDARDS.md#72-monitoring-dashboard)}

---

## Service Level Objective (SLO)

> [§7.5](../STANDARDS.md#75-service-level-objectives): the SLO is the target reliability. Set it at the level users actually need, not aspirationally high - an SLO that is always exceeded provides no signal.

**Target:** {percentage or threshold} over a {rolling 30-day / calendar month} window

**Example:** 99.5% of requests complete successfully within 2 seconds, measured over a rolling 30-day window

---

## Error Budget

> [§7.5](../STANDARDS.md#75-service-level-objectives): when a service exhausts more than half its monthly error budget, reliability work takes priority over new feature work until the trend corrects.

**Monthly budget:** {100% minus SLO target, expressed as time or event count}

**Example:** 0.5% of requests may fail ≈ 3.6 hours downtime or {N} failed requests per month

**Budget tracking:** {where the current budget consumption is visible - per [§7.2](../STANDARDS.md#72-monitoring-dashboard)}

---

## Consequences of Budget Exhaustion

<a name="REQ-TPL-47"></a>
**REQ-TPL-47** `advisory` `continuous` `soft` `all`
§7.5: actions must be pre-defined. Discovering the response during an incident compounds the problem.

> [§7.5](../STANDARDS.md#75-service-level-objectives): actions must be pre-defined. Discovering the response during an incident compounds the problem.

**At 50% consumed:** {action - e.g., reliability review, pause new feature work}

**At 100% consumed:** {action - e.g., freeze feature work, mandatory reliability sprint, escalate}

---

## Alert Thresholds

> [§7.5](../STANDARDS.md#75-service-level-objectives): alerts declare their severity. Only page-now alerts interrupt outside normal working hours. See [§7.6](../STANDARDS.md#76-observability-standard) for observability requirements.

| Condition | Severity | Response |
|-----------|---------|----------|
| Budget burn rate will exhaust budget in < 2 hours | Page now | Immediate response |
| Budget burn rate will exhaust budget in < 24 hours | Same-day review | Respond within business hours |
| Consumption > 50% of monthly budget | Daily summary | Review at next planning cycle |

---

## Delivery Health Connection

> [§7.4](../STANDARDS.md#74-delivery-health): SLO breaches are a signal for delivery health. Two consecutive periods of degraded SLO performance trigger the same response as degraded DORA metrics - reduce change size and strengthen testing before resuming feature work.

*Link to delivery health dashboard: {URL}*

---

*Owner: {team}*
*Last reviewed: {date}*
