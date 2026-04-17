# Addendum: Multi-Service Architectures

> Extends [Excellence Standards - Engineering](../../STANDARDS.md). Apply when your project communicates with services owned by other teams, or owns a service consumed by other teams.


<a name="REQ-ADD-MS-11"></a>
**REQ-ADD-MS-11** `advisory` `continuous` `soft` `addendum:MS` `deprecated:non-first-principles`
~~Deprecated: advisory meta-req.~~

> Per-stage lifecycle activation of this addendum's requirements is documented in the [§2.1 per-stage blocks](../../STANDARDS.md#per-stage-operational-blocks). When this addendum's requirements are listed in the §2.1 table, those entries are authoritative; update both in the same commit.
---

## Table of Contents

- [Service-to-Service Authentication and Authorization (Required)](#service-to-service-authentication-and-authorization-required)
- [Independent Deployability (Required)](#independent-deployability-required)
- [Contract Testing (Required)](#contract-testing-required)
- [Circuit Breakers and Resilience (Required)](#circuit-breakers-and-resilience-required)
- [Service Versioning (Required)](#service-versioning-required)
- [Distributed Tracing (Required)](#distributed-tracing-required)
- [Distributed Transaction Strategy (Required)](#distributed-transaction-strategy-required)
- [Architecture Documentation Additions](#architecture-documentation-additions)
- [Testing Gap Audit Additions](#testing-gap-audit-additions)


## Service-to-Service Authentication and Authorization (Required)

**Lifecycle activation:** DESIGN (document the authentication mechanism and authorization model for each service boundary in the architecture doc before BUILD); BUILD (implement); VERIFY (test that unauthenticated and unauthorized requests are rejected at each boundary).

<a name="REQ-ADD-MS-01"></a>
**REQ-ADD-MS-01** `gate` `design` `hard` `addendum:MS` `per-item`
Every request crossing a service boundary is authenticated.

<a name="REQ-ADD-MS-07"></a>
**REQ-ADD-MS-07** `gate` `design` `hard` `addendum:MS` `per-item`
The authentication mechanism (mTLS, token, API key) and authorization model are documented for each interface.

Every request crossing a service boundary must be authenticated. Being inside the same network is not an authentication mechanism. Document the approach for every service-to-service interface before implementation.

**Authentication mechanisms** (choose based on your trust model; document the choice and the reason):

- **Mutual TLS (mTLS):** both sides present a certificate; the connection is established only if both certificates are valid and trusted by a shared certificate authority. Appropriate for high-frequency synchronous calls between services you control. Provides cryptographic identity verification at the transport layer. Requires certificate lifecycle management.
- **Token-based authentication (Bearer / JWT):** the calling service obtains a short-lived token from an identity provider and presents it with each request. Appropriate when services span organizational boundaries, run on different platforms, or require a federated identity model. Requires token validation on every inbound request; token expiry is a required property, not optional.
- **API keys:** a static credential issued to a specific caller. Lower operational complexity than mTLS or tokens, but weaker: keys do not expire by default, cannot be scoped to a single request, and are slower to rotate when compromised. Acceptable only for lower-risk integrations with an explicit rotation cadence defined in the service's security documentation.

**Authorization** (distinct from authentication):

Authentication establishes who is calling. Authorization establishes what that caller is permitted to do. A service that authenticates callers but applies no authorization allows any authenticated service to call any endpoint. That is a misconfigured service.

For each service-to-service interface, document:
- Which services are permitted to call which endpoints
- Whether different callers have different permission scopes (e.g., service A may read; service B may read and write)
- How the service enforces those permissions at runtime, not just at the network layer


## Independent Deployability (Required)

**Lifecycle activation:** DESIGN (verify the proposed interface design permits independent deployment; resolve coupling before BUILD if it does not); VERIFY (confirm no deployment coordination dependency exists before closing the work item).

<a name="REQ-ADD-MS-02"></a>
**REQ-ADD-MS-02** `gate` `verify` `hard` `addendum:MS` `per-item`
Every service is independently deployable, independently testable with test doubles, and capable of running against the previous and next version of any dependency.

Every service must be deployable to production without coordinating a release with any other team. If your service cannot deploy independently, that coupling is an architectural problem to solve, not a coordination process to add.

At all times, every service must be:
- Independently testable using test doubles (stubs, mocks, fakes) for its dependencies
- Deployable without requiring other teams to deploy simultaneously
- Capable of running against the previous and next version of any dependency it calls

If a deployment requires coordinating with another team, file an architecture issue. The root cause is always an interface design problem.


## Contract Testing (Required)

**Lifecycle activation:** BUILD (consumer writes the contract; provider adds contract verification to CI); VERIFY (all contracts pass before the work item closes).

<a name="REQ-ADD-MS-03"></a>
**REQ-ADD-MS-03** `gate` `build` `hard` `addendum:MS` `per-artifact`
Consumer-driven contract tests exist for every public API endpoint consumed by an external team.

<a name="REQ-ADD-MS-08"></a>
**REQ-ADD-MS-08** `gate` `build` `hard` `addendum:MS` `per-artifact`
Provider CI fails if a consumer contract is broken.

Any API consumed by an external team must have consumer-driven contract tests. The consumer defines the contract; the provider verifies against it on every build. Consumer-driven means the consumer specifies what it actually uses (not the full provider surface), so coverage follows real usage, not documentation.

**Minimum coverage:** A contract must exist for every public API endpoint consumed by an external team. For each endpoint under contract, the contract covers:
- Every response field the consumer reads
- Every error response the consumer handles (status codes and relevant response body fields)
- Every request parameter the consumer sends

<a name="REQ-ADD-MS-12"></a>
**REQ-ADD-MS-12** `advisory` `continuous` `soft` `addendum:MS` `deprecated:non-first-principles`
~~Deprecated: restates other requirements.~~

Coverage is "all public endpoints with external consumers," not "endpoints where breaking changes are anticipated." Breaking changes cannot be reliably anticipated; full coverage is the gate.

**Process requirements:**
- Contracts are version-controlled in a shared location accessible to both teams
- The provider's CI pipeline must fail if it breaks a consumer's contract
- Breaking a contract requires explicit consumer coordination and a deprecation period, not a silent fix


## Circuit Breakers and Resilience (Required)

**Lifecycle activation:** DESIGN (document circuit breaker configuration, including threshold, open duration, and fallback behavior, in the architecture doc); BUILD (implement); VERIFY (test that the fallback behavior activates correctly when the dependency is unavailable or slow).

A **circuit breaker** is a component that monitors outbound calls to a dependency and trips (opens the circuit) after a configured failure threshold is reached. Once open, it stops forwarding requests to the failing dependency and immediately returns the fallback response instead. After a recovery period, the circuit enters a half-open state: a limited number of test requests are allowed through. If they succeed, the circuit closes and normal flow resumes. The name comes from electrical engineering: rather than letting current flow through a fault until something fails, the breaker opens and contains the damage.

<a name="REQ-ADD-MS-04"></a>
**REQ-ADD-MS-04** `gate` `build` `hard` `addendum:MS` `per-item`
Every outbound call has a defined timeout, circuit breaker with failure threshold, and defined fallback behavior when the circuit is open.

Every outbound call to an external service must have:
- A defined timeout (per Section 5.4 of the universal standard)
- A circuit breaker that stops sending requests to a failing service after a defined failure threshold
- A defined fallback behavior when the circuit is open (graceful degradation, not hard failure)

**Bulkhead isolation** (required when a service makes calls to multiple independent dependencies): a **bulkhead** limits the resources (connections, threads, queue depth) any single downstream dependency can consume. Without it, a slow dependency exhausts all available resources and degrades calls to unrelated, healthy dependencies. The name comes from ship construction: watertight compartments (bulkheads) contain flooding to one section instead of sinking the ship.

Document in the architecture doc: circuit breaker threshold, open duration, and fallback behavior for each outbound dependency. If bulkhead isolation is in use, document the resource limits per dependency.


## Service Versioning (Required)

**Lifecycle activation:** DESIGN (establish the versioning strategy and deprecation policy before the first external consumer onboards); ongoing (apply at every breaking change thereafter).

External-facing service APIs follow the versioning requirements in Section 5.8 of the universal standard. Additionally:
- Services must support at least one prior major version concurrently during the deprecation period
- Deprecation notices are communicated to all known consumers before the deprecation window starts
- Consumers are identified from contract tests and dependency tracking, not from informal knowledge


## Distributed Tracing (Required)

**Lifecycle activation:** BUILD (implement correlation ID propagation for all cross-service calls); VERIFY (confirm a request originating at service A produces linked spans across all services it traverses, with no trace gaps).

<a name="REQ-ADD-MS-05"></a>
**REQ-ADD-MS-05** `gate` `build` `hard` `addendum:MS` `per-artifact`
Every request crossing a service boundary propagates a correlation ID.

<a name="REQ-ADD-MS-09"></a>
**REQ-ADD-MS-09** `gate` `build` `hard` `addendum:MS` `per-artifact`
All spans in a request trace are linkable across all services.

Every request crossing a service boundary must propagate a correlation ID. All spans in a request trace - across all services - must be linkable by correlation ID in the observability system. Trace gaps (requests that enter a service but do not produce a span) are a monitoring gap, not an acceptable state.


## Distributed Transaction Strategy (Required)

**Lifecycle activation:** DESIGN (document the consistency strategy for every cross-service operation that must maintain consistency; BUILD on a cross-service operation without a documented strategy is blocked).

<a name="REQ-ADD-MS-06"></a>
**REQ-ADD-MS-06** `artifact` `design` `hard` `addendum:MS`
Every cross-service operation requiring consistency has a documented strategy (saga, eventual consistency, or synchronous coordination with rollback) before implementation.

Services with separate data stores cannot use distributed ACID transactions across service boundaries without significant coordination cost and coupling. Every cross-service operation that must maintain consistency documents its strategy before implementation.

The three viable strategies are:

**Saga pattern:** a sequence of local transactions, each publishing an event or message that triggers the next step. If any step fails, compensating transactions undo the preceding steps. Two variants: choreography (each service reacts to events) and orchestration (a central coordinator directs each step). Document which variant applies, where compensation logic lives, and what the user sees during a partially-completed saga.

**Eventual consistency with idempotent operations:** operations are designed to be retried safely; the system converges to a consistent state without explicit compensation. Document the maximum convergence time and the user-visible intermediate states.

**Synchronous coordination with rollback:** for operations that must be atomic from the user's perspective, a coordinator makes calls sequentially with rollback on failure. This increases coupling and is appropriate only when saga compensation is impractical. Requires a timeout and rollback procedure.

"We don't have distributed transactions" is not a strategy. If your services share no state and never need consistency across boundaries, document that and explain why. If they do, document which strategy applies and where the compensation or convergence logic lives.


## Architecture Documentation Additions

**Lifecycle activation:** DOCUMENT (add these entries to the architecture doc before closing the work item).

<a name="REQ-ADD-MS-10"></a>
**REQ-ADD-MS-10** `artifact` `document` `hard` `addendum:MS` `deprecated:REQ-ADD-MS-07`
~~Deprecated: consolidated into REQ-ADD-MS-07.~~

<a name="REQ-ADD-MS-14"></a>
**REQ-ADD-MS-14** `artifact` `document` `hard` `addendum:MS` `deprecated:REQ-ADD-MS-07`
~~Deprecated: consolidated into REQ-ADD-MS-07.~~

<a name="REQ-ADD-MS-15"></a>
**REQ-ADD-MS-15** `artifact` `document` `hard` `addendum:MS`
Multi-service architecture docs include contracts exposed and consumed.

<a name="REQ-ADD-MS-16"></a>
**REQ-ADD-MS-16** `artifact` `document` `hard` `addendum:MS`
Multi-service architecture docs include failure mode for each consumed service.

In addition to Section 3.1 requirements, multi-service architecture documents must include:
- The authentication mechanism in use for each service-to-service interface
- The authorization model: which callers may call which endpoints, and how the service enforces it at runtime
- The contracts exposed to other teams, version and stability status
- The contracts consumed from other teams, and behavior when those dependencies are unavailable
- The failure mode for each consumed service: is the circuit open, is degradation graceful, is the user informed?


## Testing Gap Audit Additions

<a name="REQ-ADD-MS-13"></a>
**REQ-ADD-MS-13** `advisory` `continuous` `soft` `addendum:MS` `deprecated:non-first-principles`
~~Deprecated: meta-info.~~

**Lifecycle activation:** VERIFY (run this audit before closing any work item that touches service boundaries; all P0 and P1 gaps in the table must be addressed or explicitly accepted with a documented rationale before close).

| Gap | Typical impact | Priority |
|---|---|---|
| No service-to-service authentication | Any service on the network can call any endpoint | P0 |
| No consumer-driven contract tests | Breaking changes reach consumers silently | P0 |
| No circuit breaker on outbound calls | One degraded dependency cascades to full service failure | P1 |
| No distributed transaction strategy documented | Data consistency approach unknown; failure behavior undefined | P1 |
| No test for dependency-unavailable scenario | Behavior when dependencies fail is unknown until production | P1 |
| No authorization enforcement on service boundaries | Authenticated callers reach endpoints they should not | P1 |
| No correlation ID propagation | Cross-service debugging requires log archaeology | P2 |

---

## Contract Test Coverage Registry

Consumer-driven contract tests (REQ-ADD-MS-03, REQ-ADD-MS-08) verify that every producer keeps its contract with every consumer as the system evolves. The discipline breaks down silently when a new consumer-producer pair is introduced without a matching contract test: the absence is invisible to the CI gate that only validates the tests that exist. The contract test coverage registry closes that gap by making every consumer-producer pair visible as a registry row whose test path must resolve or whose exemption must be named.

<a name="REQ-ADD-MS-17"></a>
**REQ-ADD-MS-17** `artifact` `design` `hard` `addendum:MS`
A contract test coverage registry exists at `docs/api-contracts/registry.md` (or equivalent machine-readable path) listing every consumer-producer pair in the adopter's architecture.

<a name="REQ-ADD-MS-18"></a>
**REQ-ADD-MS-18** `artifact` `verify` `hard` `addendum:MS`
Each registry row names four fields: consumer service, producer service, contract test path (or `exempt:<reason>` with a documented rationale), and last-verified-passing date or CI run reference.

<a name="REQ-ADD-MS-19"></a>
**REQ-ADD-MS-19** `advisory` `verify` `soft` `addendum:MS`
Registry entries whose contract test path does not resolve on disk or whose last-verified date is older than the adopter's configured staleness threshold are surfaced as a gap in the Testing Gap Audit. The staleness threshold is an adopter decision with a declared default (90 days recommended for continuously-delivered systems).

**Acceptance criteria (all must be true to advance):**

- The registry row count matches the count of consumer-producer pairs discovered via route scanning, dependency graph, or declared architecture doc (the discovery method is a named adopter choice).
- Every row's path field is either a resolvable test file or a named exemption rationale; no "TBD" or empty entries.
- Registry staleness check is wired into CI as a warning-level signal when the adopter reaches the declared cadence threshold.

**Relationship to REQ-ADD-MS-03 and REQ-ADD-MS-08.** REQ-ADD-MS-03 requires contracts; REQ-ADD-MS-08 requires provider CI to fail on contract break; REQ-ADD-MS-17 through -19 make the completeness of that coverage auditable by reifying the pair-to-test map as a single registry artifact.

