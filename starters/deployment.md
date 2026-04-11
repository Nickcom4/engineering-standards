---
type: starter
purpose: "Document deployment procedure for a service"
frequency: one-time
---

# Deployment: {Project Name}

<a name="REQ-STR-01"></a>
**REQ-STR-01** `advisory` `continuous` `soft` `all`
Deployment documentation for {Project Name}. Required by §4.

> Deployment documentation for {Project Name}. Required by [§4.1](../STANDARDS.md#41-what-must-be-documented) for any deployment change. Every production deployment must define its rollout strategy and rollback trigger before starting - per [§5.7](../STANDARDS.md#57-deployment-strategies-and-release-safety).
>
> A deployment without a pre-defined rollback trigger is not a safe deployment.

---

## Table of Contents

- [Environments](#environments)
- [Prerequisites](#prerequisites)
- [Deployment Procedure](#deployment-procedure)
- [Rollout Strategy](#rollout-strategy)
- [Rollback Trigger](#rollback-trigger)
- [Rollback Procedure](#rollback-procedure)
- [Post-Deployment Verification](#post-deployment-verification)
- [Monitoring After Deploy](#monitoring-after-deploy)

---

## Environments

| Environment | URL / Host | Purpose | Access |
|-------------|-----------|---------|--------|
| Local | localhost:{port} | Development | All developers |
| Staging | {URL} | Pre-production validation | {who} |
| Production | {URL} | Live | {who} |

---

## Prerequisites

> [§5.1](../STANDARDS.md#51-version-control-discipline): all tests pass, review complete, documentation updated, pre-commit checks pass before merge.

- [ ] All tests pass (unit, integration)
- [ ] Pre-merge checklist complete per [§5.1](../STANDARDS.md#51-version-control-discipline)
- [ ] Monitoring configured per [§7.1](../STANDARDS.md#71-service-health-checks)
- [ ] Rollback trigger defined (see below)

---

## Deployment Procedure

> [§5.7](../STANDARDS.md#57-deployment-strategies-and-release-safety): define the rollout strategy before starting.

### To Staging

1. {Step-by-step procedure}
2. {What automated steps run}
3. {What requires human action}

### To Production

1. {Step-by-step procedure}
2. {What automated steps run}
3. {What requires human action}
4. {Smoke test to confirm deployment succeeded}

---

## Rollout Strategy

> [§5.7](../STANDARDS.md#57-deployment-strategies-and-release-safety): select one per deployment. Document the choice.

- [ ] **Full cutover** - replace the running version entirely
- [ ] **Feature flag** - new behavior gated behind a flag, disabled by default
- [ ] **Canary** - new version receives a small percentage of traffic
- [ ] **Blue-green** - two environments in parallel; traffic is switched

**Selected strategy for this project:** {which and why}

---

## Rollback Trigger

> [§5.7](../STANDARDS.md#57-deployment-strategies-and-release-safety): the specific metric threshold or error condition that initiates a rollback. Define this BEFORE deploying, not during the incident.

**Trigger condition:** {specific metric or error condition - e.g., "error rate exceeds 5% for 2 consecutive minutes", "health check fails 3 consecutive times"}

**Who is authorized to trigger rollback:** {name or role}

---

## Rollback Procedure

> [§5.7](../STANDARDS.md#57-deployment-strategies-and-release-safety): specific steps, not "revert the change."

1. {Exact command or action to roll back}
2. {How to verify rollback succeeded}
3. {Who to notify}
4. {What monitoring to check after rollback}

**Estimated rollback time:** {how long from trigger to restored}

---

## Post-Deployment Verification

> [§2.1 DEPLOY](../STANDARDS.md#21-the-lifecycle): smoke test run, monitoring confirmed active.

- [ ] Application responds to health check
- [ ] Key user flows verified (list them)
- [ ] Monitoring dashboard shows healthy metrics
- [ ] No new errors in logs within first 15 minutes
- [ ] Alert thresholds confirmed active

---

## Monitoring After Deploy

> [§7.1](../STANDARDS.md#71-service-health-checks): how will we know if this breaks in 30 days?

**Dashboard:** {URL}
**Alerts configured for:** {what conditions trigger alerts}
**First review after deploy:** {when - e.g., "check dashboard 1 hour post-deploy"}

---

*Owner: {team or individual}*
*Last updated: {date}*
