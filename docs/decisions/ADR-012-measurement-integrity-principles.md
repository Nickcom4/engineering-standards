---
type: adr
id: ADR-012
title: Measurement Integrity Principles in Section 7
date: 2026-03-22
status: Accepted
accepted: 2026-03-22
deciders: gate authority
tags: [monitoring, measurement, six-sigma, process-quality]
implements:
  - REQ-4.2-01
  - REQ-4.1-01
---

# ADR-012: Measurement Integrity Principles in Section 7

## Context

ESE §7 requires monitoring, health checks, DORA metrics, SLOs, and observability
telemetry. It does not require that practitioners validate measurement systems before
acting on metric data. This gap means a project can satisfy every §7 requirement using
metrics that do not accurately represent system behavior.

Six Sigma's MEASURE phase establishes the foundational principle: acting on unvalidated
or misread metrics causes more harm than no measurement at all. Three related problems
arise when measurement integrity is not required:

1. **Measurement error:** metrics may not capture what practitioners believe they
   capture. A "deployment frequency" count that includes failed deployments overstates
   delivery health. A "change failure rate" that only catches incidents formally filed
   understates it.

2. **Tampering:** every stable process produces natural variation. When practitioners
   react to common cause variation as though it signals a system change (tighten a gate,
   slow down deployments, escalate), they increase variation rather than reduce it.
   Deming identified tampering as one of the leading causes of process degradation.

3. **Threshold-only thinking:** tracking whether a threshold was breached (alert: yes
   or no) does not reveal whether the process is capable of consistently meeting its
   targets. A process that passes its threshold 70% of the time and one that passes 99.9%
   of the time both "pass" in any given period. Process capability measurement makes the
   difference visible.

**Cost of doing nothing:** Projects build responses to phantom signals, miss real
degradation, and have no way to know whether their measurement systems are reliable.

## Decision

Add a new **§7.7 Measurement Integrity** to STANDARDS.md covering three principles:

1. **Validate before trusting:** the measurement system must be validated as reliable
   before metrics are used for decisions (Measurement System Analysis principle).

2. **Distinguish signal from noise:** practitioners must determine whether a metric
   change represents a real shift (special cause variation) or normal fluctuation
   (common cause variation) before responding.

3. **Measure process capability, not only outcomes:** track how consistently the
   delivery process meets quality targets, not only whether individual thresholds are
   breached.

Placement: new §7.7 after §7.6 Observability Standard. These principles apply to all
metrics in §7 (health checks, delivery health, SLOs, observability), not to delivery
health alone, which is why §7.4 is not the correct placement.

**ESE framing:** Principle stated, method not prescribed. Formal methods (SPC charts,
Cp/Cpk, Gage R&R) are referenced for practitioners who need them and will be detailed in
the continuous-improvement addendum. ESE requires the outcome (validated, signal-aware,
capability-measured monitoring) not the specific tool.

## Consequences

**Positive:**
- Projects must actively validate metrics before building responses to them
- Tampering (reacting to noise as signal) is named and required to be avoided
- Process capability becomes a visible, required dimension of delivery health
- The three principles complement every existing §7 requirement without replacing any

**Negative:**
- Adds compliance obligation for all projects using ESE
- Practitioners unfamiliar with SPC concepts will need to learn the distinction between
  common and special cause variation
- "Validate before trusting" requires defining what validation looks like per metric

**Trade-off accepted:** The compliance cost is low relative to the cost of projects
that optimize responses to measurement noise while real signals go undetected.

## Alternatives Considered

**Add to §7.4 (Delivery Health):** Rejected. §7.4 is specifically DORA metrics for the
delivery pipeline. Measurement integrity applies to all §7 metrics including SLOs,
health checks, and observability telemetry. Placement in §7.4 would imply the principles
only apply to DORA metrics.

**Add as §7 preamble (before §7.1):** Considered. A preamble would communicate
that these principles govern all of §7. Rejected in favor of a named section because a
named section is independently referenceable, auditable, and linkable from the
requirement index. A preamble cannot be targeted by a specific compliance check.

**Prescribe specific methods (control charts, Cp/Cpk, Gage R&R):** Rejected per ESE
ADR-005 (practical over theoretical). ESE states the principle and the required outcome;
the continuous-improvement addendum will contain specific methods for projects that want
them.

## Validation

At the first adoption review: at least one project applying ESE has documented their measurement validation approach in their standards-application.md testing gaps table. At the first P1 or P0 incident post-mortem after adoption: the post-mortem confirms whether common vs. special cause variation was evaluated before the response (a false-signal response, reacting to common cause variation as though it were special cause, present in the post-mortem is a negative signal for this change).
