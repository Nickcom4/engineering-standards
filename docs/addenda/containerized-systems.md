# Addendum: Containerized and Orchestrated Systems

> Extends [Excellence Standards - Engineering](../../STANDARDS.md). Apply when your project runs in containers or is managed by an orchestrator (Kubernetes, ECS, Nomad, or equivalent).


<a name="REQ-ADD-CTR-13"></a>
**REQ-ADD-CTR-13** `advisory` `continuous` `soft` `addendum:CTR` `deprecated:non-first-principles`
~~Deprecated: advisory meta-req.~~

> Per-stage lifecycle activation of this addendum's requirements is documented in the [§2.1 per-stage blocks](../../STANDARDS.md#per-stage-operational-blocks). When this addendum's requirements are listed in the §2.1 table, those entries are authoritative; update both in the same commit.
---

## Table of Contents

- [Lifecycle Stage Mapping](#lifecycle-stage-mapping)
- [Container Image Standards (Required)](#container-image-standards-required)
- [Image Scanning (Required)](#image-scanning-required)
- [Health Probes (Required)](#health-probes-required)
- [Resource Limits (Required)](#resource-limits-required)
- [Security Context (Required)](#security-context-required)
- [Secret Management (Required)](#secret-management-required)
- [Observability (Required for Production)](#observability-required-for-production)
- [Network Policy (Required for Production)](#network-policy-required-for-production)
- [Immutable Infrastructure](#immutable-infrastructure)
- [Orchestrator-Specific Documentation](#orchestrator-specific-documentation)
- [Testing Gap Audit Additions](#testing-gap-audit-additions)


## Lifecycle Stage Mapping

<a name="REQ-ADD-CTR-14"></a>
**REQ-ADD-CTR-14** `advisory` `continuous` `soft` `addendum:CTR` `deprecated:non-first-principles`
~~Deprecated: meta-info.~~

This table shows which requirements from this addendum activate at each ESE lifecycle stage. The [§2.1 per-stage table](../../STANDARDS.md#per-stage-operational-blocks) is the authoritative source; update both in the same commit when either changes.

| Stage | Requirements active |
|---|---|
| **DESIGN** | Document probe configuration, resource estimates, and network policy intent in the architecture doc. Select base image and document the reason. |
| **BUILD** | Image built in CI with multi-stage build. Base image pinned by digest. No secrets in layers. Image signed in CI pipeline. Scanning runs on every build; Critical/High findings block merge. |
| **VERIFY** | Liveness, readiness, and startup probes exercised in integration environment. Resource limits confirmed in manifests. Security context confirmed (non-root, capabilities dropped). |
| **DEPLOY** | Signed image digest deployed (not a mutable tag). Health probes active before traffic is routed. Network policy applied. Rollout strategy and rollback trigger defined. |
| **MONITOR** | Metrics, structured logs, and traces flowing to observability backend. Alerts configured for error rate, latency, and resource saturation. Weekly scheduled image re-scan active. |

---

## Container Image Standards (Required)

**Base images:**
- Base image is a named minimal variant (distroless, Alpine, slim, or equivalent). When a larger base is used, the rationale is documented in the architecture doc.
- Pin base image versions with a digest, not just a tag. `FROM node:20-alpine` is mutable; `FROM node:20-alpine@sha256:...` is not.
- Document the reason for the chosen base image in the architecture doc.

**Build:**
- Images are built in CI, not on developer machines.
- Multi-stage builds separate the build environment from the runtime image. Build tools do not ship in production images.
- No secrets in image layers. Secrets passed at runtime via environment or mounted secrets, never baked in.

**Image registry:**
- All production images are tagged with an immutable identifier (git SHA or build number) in addition to any mutable tags.
- Mutable tags (`latest`) are not used in production deployment manifests. Only immutable identifiers.

**Image signing (supply chain security):**
- Every production image is signed in CI using a verifiable identity (cosign keyless signing with OIDC, Notary v2, or equivalent). The signature binds the image digest to the CI identity that produced it.
- Signature verification is enforced at deploy time: the deployment pipeline or admission controller verifies the signature before any image is promoted to a production environment. An unsigned or unverifiable image does not deploy.
- The signing identity and verification policy are documented in the architecture doc.

## Image Scanning (Required)

- Every image is scanned for known vulnerabilities before it is deployed to any environment.
<a name="REQ-ADD-CTR-01"></a>
**REQ-ADD-CTR-01** `gate` `build` `hard` `addendum:CTR` `per-commit`
Image scanning runs on every build.

<a name="REQ-ADD-CTR-05"></a>
**REQ-ADD-CTR-05** `gate` `build` `hard` `addendum:CTR` `per-commit`
Critical and High severity findings block deployment.

<a name="REQ-ADD-CTR-06"></a>
**REQ-ADD-CTR-06** `gate` `build` `hard` `addendum:CTR` `per-commit`
Medium findings triaged within 30 days.

<a name="REQ-ADD-CTR-07"></a>
**REQ-ADD-CTR-07** `gate` `build` `hard` `addendum:CTR` `per-commit`
Weekly scheduled re-scans active.

- **Blocking threshold:** Critical (CVSS 9.0+) and High (CVSS 7.0-8.9) severity findings block deployment. A finding at these severities may not be bypassed without a documented mitigation plan (accepted risk statement, compensating control, and remediation timeline) reviewed by the team lead.
- **Scan frequency:** Scanning runs in CI on every image build. Images already deployed to production are re-scanned on a weekly scheduled basis; vulnerabilities are discovered after build time and a clean build-time scan does not guarantee ongoing safety.
- Medium findings (CVSS 4.0-6.9) must be triaged within 30 days of discovery. Low findings are tracked but do not block deployment or require a triage deadline.

## Health Probes (Required)

Every container in production defines all three probe types:

<a name="REQ-ADD-CTR-02"></a>
**REQ-ADD-CTR-02** `gate` `deploy` `hard` `addendum:CTR` `per-artifact`
Liveness probe is configured with documented endpoint, thresholds, and timing.

<a name="REQ-ADD-CTR-17"></a>
**REQ-ADD-CTR-17** `gate` `deploy` `hard` `addendum:CTR` `per-artifact`
Readiness probe is configured with documented endpoint, thresholds, and timing.

<a name="REQ-ADD-CTR-18"></a>
**REQ-ADD-CTR-18** `gate` `deploy` `hard` `addendum:CTR` `per-artifact`
Startup probe is configured with documented endpoint, thresholds, and timing.

<a name="REQ-ADD-CTR-08"></a>
**REQ-ADD-CTR-08** `gate` `deploy` `hard` `addendum:CTR` `per-artifact`
Health probes are active before traffic is routed.

**Liveness probe:** confirms the process is alive and not deadlocked. Failing this probe causes the container to restart. Must be a lightweight check that cannot fail for transient reasons (network latency to a dependency must not fail liveness). Required thresholds: `timeoutSeconds: 5`, `periodSeconds: 10`, `failureThreshold: 3`. After 3 consecutive failures (30 seconds) the container restarts. `initialDelaySeconds` should be 0 when a startup probe is present; set to 30+ only when no startup probe is used.

**Readiness probe:** confirms the container is ready to serve traffic. Failing this probe removes the container from the load balancer without restarting it. Must represent actual readiness; a container that passes readiness but cannot serve requests is a misconfigured probe. Required thresholds: `timeoutSeconds: 5`, `periodSeconds: 5`, `failureThreshold: 3`. The probe endpoint must respond within 5 seconds under normal operating conditions; a probe that regularly times out at 5 seconds indicates an application performance problem, not a threshold problem.

**Startup probe:** for containers with slow initialization. Used to give the container time to start before liveness checking begins. Prevents liveness from restarting a container that is still initializing. Required thresholds: `failureThreshold: 30`, `periodSeconds: 10`. This allows up to 5 minutes for startup. If startup regularly exceeds 5 minutes, investigate the initialization path; do not simply raise `failureThreshold`.

Document probe configuration (endpoint, thresholds, timing) in the architecture doc. Thresholds above are required minimums; document any project-specific deviations and the reason.

## Resource Limits (Required)

Every container defines explicit CPU and memory requests and limits. No container may be deployed without all four values set.

**Policy:**
<a name="REQ-ADD-CTR-03"></a>
**REQ-ADD-CTR-03** `gate` `deploy` `hard` `addendum:CTR` `per-artifact`
Resource limits (CPU and memory) are set for every container.

<a name="REQ-ADD-CTR-09"></a>
**REQ-ADD-CTR-09** `gate` `deploy` `hard` `addendum:CTR` `per-artifact`
Memory request is at least 50% of limit.

<a name="REQ-ADD-CTR-10"></a>
**REQ-ADD-CTR-10** `gate` `deploy` `hard` `addendum:CTR` `per-artifact`
CPU request is at least 25% of limit.

- Memory request must be at least 50% of the memory limit. A memory limit of 512 MiB requires a request of at least 256 MiB. Requests far below limits hide actual consumption and produce unreliable scheduling decisions.
- CPU request must be at least 25% of the CPU limit. CPU is compressible (throttled, not killed) but requests far below limits produce unstable scheduling behavior under load.
- Do not set CPU limit to a value lower than the observed P95 CPU usage under realistic load; doing so causes CPU throttling that manifests as latency spikes without any alert or OOM event.

**How to set values:** Profile the application under realistic load (not idle) before committing limits. Measure P95 and P99 CPU and memory consumption. Set the limit above the P99 observed value with a safety margin. Record the profiling method and baseline measurements in the architecture doc. Limits set without profiling are guesses; guesses cause OOM kills or CPU throttling in production.

Containers without limits are unbounded and can starve neighbors. Containers without requests produce unreliable scheduling on under-resourced nodes.

## Security Context (Required)

Every container specifies a security context:
- Run as non-root (`runAsNonRoot: true`)
- Use a specific non-root UID (`runAsUser: {N}`)
- Read-only root filesystem where the application allows it (`readOnlyRootFilesystem: true`)
<a name="REQ-ADD-CTR-04"></a>
**REQ-ADD-CTR-04** `gate` `deploy` `hard` `addendum:CTR` `per-artifact`
Container runs as non-root user.

<a name="REQ-ADD-CTR-19"></a>
**REQ-ADD-CTR-19** `gate` `deploy` `hard` `addendum:CTR` `per-artifact`
Container has read-only root filesystem.

<a name="REQ-ADD-CTR-20"></a>
**REQ-ADD-CTR-20** `gate` `deploy` `hard` `addendum:CTR` `per-artifact`
All capabilities dropped (add back only what is explicitly required).

<a name="REQ-ADD-CTR-21"></a>
**REQ-ADD-CTR-21** `gate` `deploy` `hard` `addendum:CTR` `per-artifact`
No privilege escalation allowed.

- Drop all capabilities; add back only what is explicitly required (`capabilities.drop: [ALL]`, `capabilities.add: []`)

Exceptions require documented justification in the architecture doc.

## Secret Management (Required)

Secrets are not stored in container images, environment variables baked into manifests, or ConfigMaps. Secrets are:
- Stored in a secrets management system (Vault, AWS Secrets Manager, Kubernetes Secrets with encryption at rest, or equivalent)
- Mounted at runtime via projected volumes or the orchestrator's native secret injection
- Rotated on the cadence defined in the service's security documentation
- Scoped to the minimum permissions required by the service

## Observability (Required for Production)

<a name="REQ-ADD-CTR-11"></a>
**REQ-ADD-CTR-11** `gate` `deploy` `hard` `addendum:CTR` `per-artifact`
All log output is structured (JSON or equivalent machine-parseable format).

<a name="REQ-ADD-CTR-12"></a>
**REQ-ADD-CTR-12** `artifact` `deploy` `hard` `addendum:CTR`
Network policy restricts traffic to minimum required (ingress from known sources, egress to known destinations).

Containerized services cannot be debugged by SSHing into a running instance. Observability is not optional; it is the only window into what a running container is doing.

**Structured logging:**
- All log output is structured (JSON or equivalent machine-parseable format). Free-text log lines are not acceptable for production services because they cannot be reliably queried or alerted on.
- Every log entry includes: timestamp (ISO 8601), severity level, service name, version, trace ID (when a trace is active), and the structured fields relevant to the event.
- Logs are written to stdout/stderr (not to files inside the container). The orchestrator or a sidecar collects and forwards them.

**Metrics:**
- Every service exposes a metrics endpoint compatible with the project's metrics backend (Prometheus `/metrics`, CloudWatch agent, or equivalent).
- At minimum, the RED metrics are instrumented for every service entry point: **Rate** (requests per second), **Errors** (error rate, broken out by error type), **Duration** (request latency at P50, P95, P99).
- Resource saturation metrics (CPU utilization, memory utilization, connection pool usage) are exported and have alerts configured at 80% of the configured limit.
- Alert thresholds are documented in the architecture doc alongside the SLO they protect.

**Distributed tracing:**
- Services that communicate with other services (downstream HTTP calls, queue producers/consumers, database clients) propagate trace context using an open standard (OpenTelemetry W3C Trace Context, or Zipkin B3 headers).
- Trace spans are exported to the project's tracing backend. A request that fails in production can be reconstructed end-to-end from trace data without access to the originating container.
- Trace sampling rate is documented. For low-volume services, 100% sampling is acceptable. For high-volume services, document the sampling strategy and confirm that error traces are always sampled regardless of the global rate.

Document the observability backend, retention policy, and alert routing in the architecture doc.

## Network Policy (Required for Production)

Production services define network policies (or equivalent) that:
<a name="REQ-ADD-CTR-15"></a>
**REQ-ADD-CTR-15** `advisory` `continuous` `soft` `addendum:CTR`
Allow only the traffic required (ingress from known sources, egress to known destinations).

- Allow only the traffic required (ingress from known sources, egress to known destinations)
- Deny by default all other traffic

"Allow all" network policies are not acceptable for services handling sensitive data.

## Immutable Infrastructure

Running containers are not modified after deployment. If a change is needed, build a new image and deploy it. No `kubectl exec` or `docker exec` to modify a running container's files. Changes made inside a running container are invisible to version control, not reproducible, and lost on the next restart.

## Orchestrator-Specific Documentation

In the architecture doc, document:
- Minimum replica count and scaling triggers
- Pod disruption budget (how many pods may be unavailable during maintenance)
- Affinity and anti-affinity rules if applicable
- Persistent volume claims and their lifecycle

## Testing Gap Audit Additions

| Gap | Typical impact | Priority |
|---|---|---|
| No image vulnerability scanning | Known CVEs ship to production | P0 |
| No image signing or verification | Tampered or substituted images deploy without detection | P0 |
| Secrets in image layers or ConfigMaps | Credential exposure in registry or etcd | P0 |
| No liveness or readiness probes | Failed containers serve traffic; orchestrator cannot self-heal | P1 |
| Probe thresholds not set explicitly | Default thresholds may restart healthy containers or fail to detect unhealthy ones | P1 |
| No resource limits defined | One misbehaving container starves the node | P1 |
| Resource requests far below limits | Unreliable scheduling; burst behavior is invisible to the scheduler | P1 |
| Containers run as root | Privilege escalation blast radius is the full host | P1 |
| No structured logging | Production failures cannot be queried or alerted on; debugging requires container access | P1 |
| No metrics endpoint or RED instrumentation | Latency and error regressions are invisible until users report them | P1 |
| No distributed tracing | Cross-service failures cannot be reconstructed; RCA requires guesswork | P2 |
| Deployed images not re-scanned after build | Vulnerabilities discovered post-build are invisible until the next release | P1 |

