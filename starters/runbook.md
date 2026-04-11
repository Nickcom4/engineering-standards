---
type: starter
purpose: "Operational documentation for a running service"
frequency: one-time
---

<a name="REQ-STR-10"></a>
**REQ-STR-10** `artifact` `document` `hard` `all`
The runbook documents the code layer.

<a name="REQ-STR-22"></a>
**REQ-STR-22** `artifact` `document` `hard` `all`
The runbook documents the security layer.

<a name="REQ-STR-23"></a>
**REQ-STR-23** `artifact` `document` `hard` `all`
The runbook documents the network layer.

<a name="REQ-STR-24"></a>
**REQ-STR-24** `artifact` `document` `hard` `all`
The runbook documents the database layer.

<a name="REQ-STR-25"></a>
**REQ-STR-25** `artifact` `document` `hard` `all`
The runbook documents the operations layer.

<a name="REQ-STR-26"></a>
**REQ-STR-26** `artifact` `document` `hard` `all`
The runbook documents the configuration layer.

# Runbook: {Service Name}

> Operations reference for {Service Name}. Maintained by {team/owner}. Last reviewed: {date}.
> Required by [§4.8](../STANDARDS.md#48-documentation-layers) for every always-on service. A service without a runbook has an undocumented owner and an unknown recovery procedure. Per [§2.4](../STANDARDS.md#24-shared-ownership), the owner of this runbook is the named owner of this service in production.

---

## Table of Contents

- [Ownership](#ownership)
- [Code](#code)
- [Security](#security)
- [Network](#network)
- [Database](#database)
- [Deployment](#deployment)
- [Operations](#operations)
- [Dependency Map](#dependency-map)
- [Configuration](#configuration)
- [Monitoring and Alerts](#monitoring-and-alerts)

---

## Ownership

> [§2.4](../STANDARDS.md#24-shared-ownership): every always-on service has a named owner discoverable without asking anyone.

**Named owner:** {team or individual}
**On-call rotation:** {link or description}
**How to reach the owner:** {channel, escalation path}
**SLO definition:** {link to SLO doc - per [§7.5](../STANDARDS.md#75-service-level-objectives)}
**Monitoring dashboard:** {link - per [§7.2](../STANDARDS.md#72-monitoring-dashboard)}

---

## Code

> [§4.8](../STANDARDS.md#48-documentation-layers): code layer - enough for a new maintainer to find their way around without asking the original author.

**Repository:** {URL}
**Language/runtime:** {language, version}
**Key entry points:** {main file, start command}
**Non-obvious logic:** {anything a maintainer needs to understand that is not clear from reading the code}

---

## Security

> [§4.8](../STANDARDS.md#48-documentation-layers), [§5.10](../STANDARDS.md#510-minimum-security-baseline): trust boundaries, data classification, credential management.

**Trust boundaries:** {where untrusted input enters this service}
**Data sensitivity:** {what data classes this service handles - public / internal / confidential / restricted}
**Credential scope:** {what permissions this service's credentials have - least privilege per [§5.10](../STANDARDS.md#510-minimum-security-baseline)}
**Redacted from logs:** {what is explicitly excluded from log output}
**Backup encryption:** {yes/no, key management approach}
**Token rotation:** {cadence, procedure}

---

## Network

<a name="REQ-STR-11"></a>
**REQ-STR-11** `advisory` `continuous` `soft` `all`
§4.8: open ports and transport encryption. Per §5.10, TLS required for all external communication.

> [§4.8](../STANDARDS.md#48-documentation-layers): open ports and transport encryption. Per [§5.10](../STANDARDS.md#510-minimum-security-baseline), TLS required for all external communication.

**Open ports:** {port, protocol, purpose}
**Transport encryption:** {TLS required? Version? Certificate source?}
**Ingress:** {what sends traffic to this service}
**Egress:** {what this service calls}

---

## Database

<a name="REQ-STR-12"></a>
**REQ-STR-12** `advisory` `continuous` `soft` `all`
Database documentation includes schema with field descriptions.

<a name="REQ-STR-27"></a>
**REQ-STR-27** `advisory` `continuous` `soft` `all`
Database documentation includes migration strategy with tested rollback.

<a name="REQ-STR-28"></a>
**REQ-STR-28** `advisory` `continuous` `soft` `all`
Database documentation includes backup policy with defined RTO and RPO.

<a name="REQ-STR-29"></a>
**REQ-STR-29** `advisory` `continuous` `soft` `all`
Database documentation includes restore test cadence.

> [§4.8](../STANDARDS.md#48-documentation-layers): schema, migration, backup, and recovery. RTO and RPO are required - undefined recovery objectives mean unknown exposure.

**Data stores:** {name, type, location}
**Schema location:** {migration files, schema docs}
**Index rationale:** {why each non-obvious index exists}
**Migration strategy:** {how to run migrations; backward-compatible changes preferred; zero-downtime required for production}
**Rollback procedure:** {how to reverse a migration}
**Backup policy:** {cadence, retention, location}
**RTO:** {Recovery Time Objective - how long until service is restored after full loss}
**RPO:** {Recovery Point Objective - how much data loss is acceptable}
**Restore test cadence:** {how often restores are tested - per [§5.10](../STANDARDS.md#510-minimum-security-baseline)}

---

## Deployment

> [§5.7](../STANDARDS.md#57-deployment-strategies-and-release-safety): every deployment defines its rollout strategy and rollback trigger before it starts.

**Rollout strategy:** Full cutover / Feature flag / Canary / Blue-green - {which and why}

**How to deploy:**
```
{deploy command or procedure}
```

**Smoke test after deploy:**
```
{command or URL to verify deployment succeeded}
```

**Rollback trigger:** {the specific metric threshold or error condition that initiates rollback}

**How to roll back:**
```
{rollback command or procedure}
```

**Rollback authorization:** {who is authorized to trigger rollback}

---

## Operations

<a name="REQ-STR-13"></a>
**REQ-STR-13** `advisory` `continuous` `soft` `all`
Operations documentation includes how to start the service.

<a name="REQ-STR-30"></a>
**REQ-STR-30** `advisory` `continuous` `soft` `all`
Operations documentation includes how to stop the service.

<a name="REQ-STR-31"></a>
**REQ-STR-31** `advisory` `continuous` `soft` `all`
Operations documentation includes how to restart the service.

<a name="REQ-STR-32"></a>
**REQ-STR-32** `advisory` `continuous` `soft` `all`
Operations documentation includes how to check service health.

<a name="REQ-STR-33"></a>
**REQ-STR-33** `advisory` `continuous` `soft` `all`
Operations documentation includes how to debug the service.

> [§4.8](../STANDARDS.md#48-documentation-layers): start, stop, restart, health, debug. A responder paged at 2am must be able to answer every question in this section without asking anyone - per [§2.4](../STANDARDS.md#24-shared-ownership).

### Starting the service

```
{start command}
```

### Stopping the service

```
{stop command}
```

### Restarting the service

```
{restart command}
```

### Health check

<a name="REQ-STR-14"></a>
**REQ-STR-14** `advisory` `continuous` `soft` `all`
§7.1: health check must be meaningful - a real functional check, not just a process ping.

> [§7.1](../STANDARDS.md#71-service-health-checks): health check must be meaningful - a real functional check, not just a process ping. Must be time-stamped and alert when silent beyond a configured threshold.

```
{health check command or URL}
```

Expected output when healthy: {describe}
Alert threshold: {how long silent before alerting}
Alert destination: {where the alert goes}

### Debugging the three most common failures

**1. {Most common failure}**
- Symptoms: {what you see}
- Cause: {why it happens}
- Resolution: {what to do}
- Verification: {how to confirm it is fixed}

**2. {Second most common failure}**
- Symptoms:
- Cause:
- Resolution:
- Verification:

**3. {Third most common failure}**
- Symptoms:
- Cause:
- Resolution:
- Verification:

### Escalation contacts

| Role | Contact | When to escalate |
|------|---------|-----------------|
| Primary on-call | {name/channel} | First contact for any incident |
| Team lead | {name/channel} | P0/P1 unresolved after 30 minutes |
| Vendor support | {URL/contact} | Infrastructure provider issues |

---

## Dependency Map

> [§4.8](../STANDARDS.md#48-documentation-layers): every service needs a dependency map so a responder knows what else is affected.

**This service depends on:**
| Dependency | Purpose | Behavior if unavailable |
|-----------|---------|------------------------|
| {Service} | {what for} | {degrade / fail / queue} |

**This service is depended on by:**
| Consumer | Purpose |
|---------|---------|
| {Service} | {for what} |

---

## Configuration

> [§4.8](../STANDARDS.md#48-documentation-layers), [§5.9](../STANDARDS.md#59-runtime-and-deployability): every environment variable documented. Secrets never stored in source control - per [§5.10](../STANDARDS.md#510-minimum-security-baseline).

| Variable | Purpose | Required | Example |
|----------|---------|----------|---------|
| {ENV_VAR} | {what it configures} | yes/no | {safe example value - never a real secret} |

---

## Monitoring and Alerts

<a name="REQ-STR-15"></a>
**REQ-STR-15** `advisory` `continuous` `soft` `all`
§7.1, §7.2, §7.6: monitoring must be active before the service is considered production-ready.

> [§7.1](../STANDARDS.md#71-service-health-checks), [§7.2](../STANDARDS.md#72-monitoring-dashboard), [§7.6](../STANDARDS.md#76-observability-standard): monitoring must be active before the service is considered production-ready.

**Monitoring dashboard:** {URL}

| Signal | Alert condition | Severity | Destination |
|--------|---------------|---------|-------------|
| Health check | Silent > {threshold} | Page now | {channel} |
| Error rate | > {threshold}% over {window} | Page now / Same-day | {channel} |
| Latency P95 | > {threshold}ms | Same-day | {channel} |
| Queue depth | > {threshold} | Same-day | {channel} |
