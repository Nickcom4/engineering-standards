# Addendum: Event-Driven Systems

> Extends [Excellence Standards - Engineering](../../STANDARDS.md). Apply when your project produces or consumes events or messages via a broker, queue, or stream (Kafka, RabbitMQ, SQS, EventBridge, NATS, or equivalent).


<a name="REQ-ADD-EVT-18"></a>
**REQ-ADD-EVT-18** `advisory` `continuous` `soft` `addendum:EVT` `deprecated:non-first-principles`
~~Deprecated: advisory meta-req.~~

> Per-stage lifecycle activation of this addendum's requirements is documented in the [§2.1 per-stage blocks](../../STANDARDS.md#per-stage-operational-blocks). When this addendum's requirements are listed in the §2.1 table, those entries are authoritative; update both in the same commit.
---

## Lifecycle Stage Mapping

This table shows which requirements from this addendum activate at each ESE lifecycle stage. The [§2.1 per-stage table](../../STANDARDS.md#per-stage-operational-blocks) is the authoritative source; update both in the same commit when either changes.

| Stage | Requirements active |
|---|---|
| **DESIGN** | Document every event type produced and consumed. Define schema registry and compatibility policy. Define idempotency strategy. Define ordering guarantee. Define DLQ strategy. Document security model: authentication, authorization, credential management, encryption in transit. |
| **BUILD** | Implement idempotency logic (runs before any side effect). Implement DLQ routing. Implement backpressure controls. Enforce schema compatibility mechanically via registry. |
| **VERIFY** | Confirm idempotency under duplicate delivery. Confirm DLQ routes failing messages. Confirm consumer lag alert fires. Confirm schema evolution rules enforced by registry. Test ordering-dependent logic for out-of-order behavior. |
| **DEPLOY** | Confirm monitoring active for consumer lag, DLQ depth, throughput, and processing time. |
| **MONITOR** | Consumer lag, DLQ depth, throughput, and processing time all alerting with defined thresholds. |

---

## Table of Contents

- [Event Schema and Contracts (Required)](#event-schema-and-contracts-required)
- [Consumer Idempotency (Required)](#consumer-idempotency-required)
- [Dead Letter Handling (Required)](#dead-letter-handling-required)
- [Ordering Guarantees (Required - Document)](#ordering-guarantees-required---document)
- [Backpressure and Flow Control (Required)](#backpressure-and-flow-control-required)
- [Security (Required)](#security-required)
- [Exactly-Once Semantics](#exactly-once-semantics)
- [Monitoring Additions (Required)](#monitoring-additions-required)
- [Architecture Documentation Additions](#architecture-documentation-additions)
- [Testing Gap Audit Additions](#testing-gap-audit-additions)
- [Event Sourcing (Document If Used)](#event-sourcing-document-if-used)


## Event Schema and Contracts (Required)

Events are API contracts. Apply the same discipline as HTTP APIs:

- Every event type has a versioned schema (AsyncAPI, JSON Schema, Avro, Protobuf, or equivalent)
- Schemas are version-controlled and consumer-visible
- Breaking schema changes (removing fields, changing field types, changing semantics) follow the same deprecation policy as breaking API changes (Section 5.8 of the universal standard)
- Additive changes (new optional fields) are backward-compatible and do not require a version increment

<a name="REQ-ADD-EVT-01"></a>
**REQ-ADD-EVT-01** `gate` `build` `hard` `addendum:EVT` `per-artifact`
Every event type has a versioned schema.

<a name="REQ-ADD-EVT-07"></a>
**REQ-ADD-EVT-07** `gate` `build` `hard` `addendum:EVT` `per-artifact`
Schema compatibility is enforced mechanically via a schema registry.

<a name="REQ-ADD-EVT-08"></a>
**REQ-ADD-EVT-08** `gate` `build` `hard` `addendum:EVT` `per-artifact`
Breaking changes follow the §5.8 deprecation policy.

<a name="REQ-ADD-EVT-02"></a>
**REQ-ADD-EVT-02** `gate` `build` `hard` `addendum:EVT` `per-item`
Consumers ignore unknown fields (tolerant reader pattern).

<a name="REQ-ADD-EVT-09"></a>
**REQ-ADD-EVT-09** `gate` `build` `hard` `addendum:EVT` `per-item`
Schema evolution is add-only.

<a name="REQ-ADD-EVT-10"></a>
**REQ-ADD-EVT-10** `gate` `build` `hard` `addendum:EVT` `per-item`
Fields are never removed, renamed, or re-typed in place.

Schema compatibility must be enforced mechanically - not by convention. A schema registry (a centralized service that stores schema versions and enforces compatibility rules) prevents incompatible producers from publishing events that break consumers.

**Schema evolution rules:**
- **Add fields only.** New optional fields with sensible defaults are backward-compatible. Removing or renaming a field breaks every consumer that reads it.
- **Never remove or rename a field in place.** Deprecate in version N (mark the field deprecated in the schema and documentation, stop writing it in new events), confirm all consumers have migrated, then remove in version N+1.
- **Never change a field's type or semantics.** If a field's meaning must change, add a new field with the new type or meaning and deprecate the old one. Repurposing an existing field corrupts the event history.
- **Consumers must ignore unknown fields** (tolerant reader pattern: a receiver accepts what it understands and ignores what it does not). A consumer that rejects messages containing unrecognized fields breaks every time the producer adds a new field, even a backward-compatible one.

## Consumer Idempotency (Required)

<a name="REQ-ADD-EVT-03"></a>
**REQ-ADD-EVT-03** `gate` `build` `hard` `addendum:EVT` `per-item`
Every consumer handles duplicate message delivery without producing duplicate effects.

<a name="REQ-ADD-EVT-11"></a>
**REQ-ADD-EVT-11** `gate` `build` `hard` `addendum:EVT` `per-item`
The architecture document names the specific idempotency mechanism and where state is stored.

Every consumer must handle duplicate message delivery without producing duplicate effects. Message brokers guarantee at-least-once delivery, not exactly-once.

- Idempotency key: every event includes a unique, stable identifier that the consumer uses to detect and skip duplicates
- Idempotency logic runs before any side effect is produced
- Idempotency state is durable - not lost if the consumer restarts between processing an event and recording that it was processed

The architecture document names the specific idempotency mechanism (unique event ID dedup, database upsert, or equivalent) and where idempotency state is stored. "We don't expect duplicates" is not a mechanism.

## Dead Letter Handling (Required)

<a name="REQ-ADD-EVT-04"></a>
**REQ-ADD-EVT-04** `artifact` `design` `hard` `addendum:EVT`
Every queue/stream consumer has a defined dead letter handling strategy: failed messages route to a DLQ, DLQ is monitored with alerting, reprocessing procedure is documented.

Every queue or stream consumer defines what happens to messages that cannot be processed after the maximum number of retries:

- Failed messages move to a dead letter queue (DLQ) or equivalent, not silently dropped
- DLQ contents are monitored and alerting is configured - a growing DLQ is a production issue
- Reprocessing procedure is documented: when and how to replay from the DLQ
- The root cause of DLQ growth is investigated before wholesale replay

## Ordering Guarantees (Required - Document)

Document the ordering guarantee your system relies on and the guarantee your broker provides:
- **Unordered:** events may arrive in any order; consumer logic must be order-independent
- **Per-partition ordered:** events within a partition are ordered; cross-partition ordering is not guaranteed
- **Globally ordered:** all events are globally ordered; this is rare and expensive

When consumer logic assumes ordering, document that assumption. Violating an undocumented ordering assumption is a common source of data corruption.

## Backpressure and Flow Control (Required)

<a name="REQ-ADD-EVT-05"></a>
**REQ-ADD-EVT-05** `artifact` `design` `hard` `addendum:EVT`
Backpressure behavior is defined explicitly (block, drop, or buffer).

<a name="REQ-ADD-EVT-12"></a>
**REQ-ADD-EVT-12** `artifact` `design` `hard` `addendum:EVT`
Queue depth alerts fire before saturation.

<a name="REQ-ADD-EVT-13"></a>
**REQ-ADD-EVT-13** `artifact` `design` `hard` `addendum:EVT`
Consumer maximum sustainable throughput is known and tested.

When a consumer cannot keep up with producer throughput:
- Define the behavior explicitly: block, drop, or buffer
- Configure queue depth alerts: alert before the queue saturates, not after it causes cascading failures
- Know your consumer's maximum sustainable throughput under normal conditions, and test behavior when that threshold is exceeded

A consumer that silently falls behind without alerting is a time-delayed incident.

## Security (Required)

Message brokers are not public endpoints. Apply the same access-control discipline as any other production service.

**Authentication**
- Every producer and consumer authenticates to the broker before connecting. Anonymous connections are not permitted in production.
- Use the broker's native authentication mechanism: mTLS client certificates, SASL/SCRAM, API keys, or IAM-based identity depending on the broker. "Traffic is internal network only" is not authentication; it is a network perimeter assumption that a misconfigured security group or compromised host will invalidate.

**Authorization**
- Apply least-privilege ACLs: each producer is authorized to publish only to the topics or queues it owns; each consumer is authorized to read only from the topics it consumes.
- Authorization is enforced in the broker, not assumed from network topology. Document the intended ACL for each service in the architecture doc; the documented ACL is the spec, and drift from it is a misconfiguration.

**Credential management**
- Broker credentials are stored in a secrets manager (Vault, AWS Secrets Manager, or equivalent). Credentials do not appear in source control, application config files, or environment variable definitions committed to a repo.
<a name="REQ-ADD-EVT-06"></a>
**REQ-ADD-EVT-06** `gate` `deploy` `hard` `addendum:EVT` `per-artifact`
All broker connections use TLS.

<a name="REQ-ADD-EVT-14"></a>
**REQ-ADD-EVT-14** `gate` `deploy` `hard` `addendum:EVT` `per-artifact`
Every producer and consumer authenticates.

<a name="REQ-ADD-EVT-15"></a>
**REQ-ADD-EVT-15** `gate` `deploy` `hard` `addendum:EVT` `per-artifact`
ACLs enforce least-privilege.

<a name="REQ-ADD-EVT-16"></a>
**REQ-ADD-EVT-16** `gate` `deploy` `hard` `addendum:EVT` `per-artifact`
Credentials rotate on a defined schedule and immediately on suspected compromise.

- Credentials rotate on a defined schedule and immediately on suspected compromise. Producers and consumers must handle credential rotation without downtime: pre-load new credentials before revoking old ones.

**Encryption in transit**
- All broker connections use TLS. Plaintext connections are not permitted in production.
- If events contain PII or regulated data, verify that broker-at-rest encryption is enabled and documented in your data classification policy.

## Exactly-Once Semantics

True exactly-once delivery is expensive and often unnecessary. Document which guarantee your system requires:
- **At-most-once:** events may be lost but are never processed twice. Acceptable for metrics and analytics.
<a name="REQ-ADD-EVT-19"></a>
**REQ-ADD-EVT-19** `advisory` `continuous` `soft` `addendum:EVT` `deprecated:non-first-principles`
~~Deprecated: meta-info.~~

- **At-least-once + idempotent consumer:** events may be delivered multiple times but the net effect is as if delivered once. Required for state mutations.
- **Exactly-once:** guaranteed by the broker (Kafka transactions, or equivalent). Use only when idempotency is not achievable at the consumer.

## Monitoring Additions (Required)

In addition to Section 7 of the universal standard:
- **Consumer lag:** how far behind the consumer is relative to the producer; alert before lag exceeds a defined threshold
- **DLQ depth:** growing DLQ is a P1 issue
- **Throughput:** events processed per second; alert on sustained drops
- **Processing time:** time from event production to consumer acknowledgment; alert on degradation

## Architecture Documentation Additions

In addition to Section 3.1 requirements:
- Event catalog: list every event type produced and consumed, with schema version and broker/topic
- Retention policy: how long events are retained in the broker and why
- Replay strategy: can the system replay events from a specific offset (a broker-maintained position marker within a partition or stream that identifies where replay should begin)? If yes, how?

## Testing Gap Audit Additions

| Gap | Typical impact | Priority |
|---|---|---|
| No idempotency in consumer | Duplicate deliveries cause duplicate state mutations | P0 |
| No schema validation on consumed events | Schema evolution breaks consumers silently | P1 |
| No DLQ defined or monitored | Failed events disappear silently | P1 |
| No consumer lag alert | Consumer falls behind; lag grows until system is hours behind | P1 |
| No test for duplicate delivery | Idempotency bugs undiscovered until production incident | P1 |
| No test for out-of-order delivery | Order assumptions invisible until they are violated | P2 |

## Event Sourcing (Document If Used)

<a name="REQ-ADD-EVT-17"></a>
**REQ-ADD-EVT-17** `artifact` `design` `soft` `addendum:EVT`
If event sourcing is used: event log retention policy is documented in the architecture doc.

<a name="REQ-ADD-EVT-21"></a>
**REQ-ADD-EVT-21** `artifact` `design` `soft` `addendum:EVT`
If event sourcing is used: snapshot strategy is documented in the architecture doc.

<a name="REQ-ADD-EVT-22"></a>
**REQ-ADD-EVT-22** `artifact` `design` `soft` `addendum:EVT`
If event sourcing is used: schema evolution (upcasting) strategy is documented in the architecture doc.

<a name="REQ-ADD-EVT-23"></a>
**REQ-ADD-EVT-23** `artifact` `design` `soft` `addendum:EVT`
If event sourcing is used: consistency model is documented in the architecture doc.

Event sourcing is an architectural pattern where the event log is the authoritative source of state - current state is derived by replaying events, not stored as a snapshot. It is not required for event-driven systems; many event-driven systems use a traditional current-state store and publish events as notifications.

If your system uses event sourcing, document:
- **Event log retention:** events must be retained for the full lifetime of the system, or until a snapshot strategy makes earlier events recoverable. Deleting events without a snapshot strategy destroys the ability to reconstruct state.
- **Snapshot strategy:** at what point do you snapshot state to avoid replaying from the beginning? What triggers a snapshot? How are snapshots versioned?
- **Schema evolution:** as events accumulate over years, old events must still be replayable against a newer schema. Document how old event versions are upcast to current schema (upcasting: transforming an older event version into the current schema before processing, so a single code path handles all historical event versions).
- **Consistency model:** event sourcing is eventually consistent by default. Document what guarantees you provide to consumers and how you handle concurrent writes.

If your system does not use event sourcing, a one-sentence statement to that effect in the architecture doc is sufficient.

---

## Consumer Idempotency Requirements

Event-driven systems typically offer at-least-once delivery semantics: a consumer may see the same event twice under normal operation (broker retry, network timeout, consumer crash between processing and acknowledgement). Consumer idempotency is the discipline of handling duplicates without producing duplicate side effects: double-crediting an account, double-shipping an order, double-emitting a downstream event. Idempotency is a mandatory property of every consumer, not an optimization.

<a name="REQ-ADD-EVT-24"></a>
**REQ-ADD-EVT-24** `artifact` `design` `hard` `addendum:EVT`
Every consumer declares an idempotency mechanism in the architecture doc: dedup-key (consumer-local record of processed message IDs), upsert (target-state operation that is naturally idempotent), or state-machine guard (consumer rejects a transition that has already occurred).

<a name="REQ-ADD-EVT-25"></a>
**REQ-ADD-EVT-25** `artifact` `design` `hard` `addendum:EVT`
The dedup window is documented: how long must a processed message ID be retained before it is safe to forget? The window must be at least the maximum broker redelivery window plus a safety margin.

<a name="REQ-ADD-EVT-26"></a>
**REQ-ADD-EVT-26** `artifact` `design` `soft` `addendum:EVT`
Poison-message handling is documented: a message that repeatedly fails processing is routed to a dead-letter queue or equivalent quarantine, not retried indefinitely. The retry count threshold and dead-letter destination are both named.

<a name="REQ-ADD-EVT-27"></a>
**REQ-ADD-EVT-27** `artifact` `design` `soft` `addendum:EVT`
At-least-once semantics are explicitly acknowledged in the architecture doc: "exactly-once" claims are rejected unless backed by a distinct mechanism (transactional outbox pattern, idempotent receiver with persistence, or a broker with genuine exactly-once guarantees under the consumer's actual configuration).

**Acceptance criteria (all must be true to advance):**

- Each consumer names one of the three idempotency mechanisms by technique (not just "we have idempotency").
- The dedup window is a named duration, not "long enough".
- Poison-message routing is tested (not just documented); a negative-path test injects a message that will fail and verifies it reaches the DLQ within the configured retry count.

**Relationship to REQ-ADD-EVT-11.** REQ-ADD-EVT-11 requires every consumer to handle duplicates; REQ-ADD-EVT-24 through -27 specify the architectural-doc surfaces where the mechanism, window, poison handling, and delivery semantics must be documented so the requirement is auditable, not implicit.

