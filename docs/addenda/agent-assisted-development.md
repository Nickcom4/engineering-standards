# Addendum: Agent-Assisted Development

> Extends [Excellence Standards - Engineering](../../STANDARDS.md). Apply when AI coding agents hold commit authority in a repository, whether as primary maintainers, paired collaborators, or autonomous contributors operating against a posture configuration.

> Per-stage lifecycle activation of this addendum's requirements is documented in the [§2.1 per-stage blocks](../../STANDARDS.md#per-stage-operational-blocks). When this addendum's requirements are listed in the §2.1 table, those entries are authoritative; update both in the same commit.

> **Scope note.** This addendum covers AI as a development collaborator: the harness, the posture, the commit-authority boundary. The [AI and ML Systems](ai-ml.md) addendum covers AI as a consumed technology in the shipped application (model behavior, evaluation harness, bias). A project can have either, both, or neither.

---

## Lifecycle Stage Mapping

| Stage | Requirements active |
|---|---|
| **DEFINE** | Declare the harness and commit-authority posture in the project's standards application document before agent-assisted work begins. |
| **DESIGN** | Establish approval-boundary scope (allowed file types, directory allowlists, command categories) before any action takes place against the repository. |
| **BUILD** | Distinguish agent-initiated commits from human-initiated commits via a durable convention (commit message convention, trailer, or signed-by field). Configuration files that shape agent behavior are treated as normative artifacts subject to the same review discipline as code. |
| **VERIFY** | Confirm that protected-branch changes passed a human gate-authority review or a CI gate that encodes the equivalent decision. |
| **DEPLOY** | No addendum-specific requirements beyond the universal standard. |
| **MONITOR** | Credential-handling and revocation-path posture is operational (credentials not persistent across sessions; revocation achievable within the declared response window). |
| **Continuous** | Harness configuration drift between declared and actual state is detected and reconciled during compliance reviews. |

---

## Table of Contents

- [Posture Declaration (Required)](#posture-declaration-required)
- [Commit-Authority Boundary (Required)](#commit-authority-boundary-required)
- [Human Gate Authority (Required)](#human-gate-authority-required)
- [Approval Boundary (Required)](#approval-boundary-required)
- [Sandbox and Isolation Posture (Required)](#sandbox-and-isolation-posture-required)
- [Audit Trail (Required)](#audit-trail-required)
- [Credential Handling (Required)](#credential-handling-required)
- [Revocation Path (Required)](#revocation-path-required)
- [Configuration File Integrity (Required)](#configuration-file-integrity-required)
- [MCP and External Tool Register (Required when applicable)](#mcp-and-external-tool-register-required-when-applicable)
- [External Standards](#external-standards)
- [Testing Gap Audit Additions](#testing-gap-audit-additions)

---

## Posture Declaration (Required)

> **Activates at:** DEFINE (declared in the standards application document before any agent-assisted work begins).

A repository maintained with agent assistance must declare that posture explicitly. A silent default is not a declaration: a reader cannot tell whether the absence of agent-related content means "no agent is present" or "agent is present but undocumented." Declaration is the forcing function that turns implicit posture into reviewable posture.

<a name="REQ-ADD-AAD-01"></a>
**REQ-ADD-AAD-01** `artifact` `define` `hard` `addendum:AAD`
The project's standards application document declares the harness in use, whether agents hold commit authority, the sandbox posture, and the paths to the agent configuration audit and external-tool register.

At minimum the declaration names:

- **Harness in use:** the identifier of the agent harness (for example, `claude-code`, `cursor`, `codex`, `opencode`, `none`). `none` is a valid declaration and is distinct from a silent default.
- **Commit authority:** whether agents can produce commits that land on any branch of this repository.
- **Sandbox posture:** the isolation level under which agents execute (one of: `devcontainer`, `vm`, `network-isolated`, `unrestricted`, `not-applicable`).
- **Configuration audit path:** the relative path of the agent configuration file or directory that carries the project's prescriptive rules (for example, `CLAUDE.md`, `AGENTS.md`, `.cursorrules`, `.agent/`). When multiple configuration surfaces apply, list each.
- **External tool register path:** the relative path of the register enumerating each external tool or Model Context Protocol (MCP) server the harness may load. Named `not-applicable` when no external tools are configured.

The declaration is machine-readable (YAML frontmatter keys) so future tooling can branch on it without prose parsing.

---

## Commit-Authority Boundary (Required)

> **Activates at:** DEFINE (boundary declared before the first agent-initiated commit).

<a name="REQ-ADD-AAD-02"></a>
**REQ-ADD-AAD-02** `gate` `define` `hard` `addendum:AAD` `per-item`
When an agent holds commit authority, the branches on which agent-initiated commits are permitted are named, and the gating condition for any other branch is recorded.

Agent commit speed is machine-scale. A single session can produce more commits than a human reviewer can read in the same window. The branch-scope boundary prevents the speed from reaching protected history before the gate applies.

- **Named branches:** list every branch pattern where agent-initiated commits land directly (for example, `feature/*`, `work/agent/*`).
- **Protected-branch gating:** for each protected branch (for example, `main`, `release/*`), record whether agent-initiated commits reach it at all, and if so, through which gate (pull request, CI-approved merge, human review). "The agent pushes to main" is a valid posture only when paired with the human-gate or CI-gate row of this addendum.

---

## Human Gate Authority (Required)

> **Activates at:** VERIFY (human or equivalent-CI gate applied before a commit reaches a protected branch).

<a name="REQ-ADD-AAD-03"></a>
**REQ-ADD-AAD-03** `gate` `verify` `hard` `addendum:AAD` `per-item`
No agent-initiated commit lands on a protected branch without a human gate-authority review or a CI gate that encodes the equivalent decision boundary.

The review need not be per-commit human-in-the-loop; it may be a CI gate whose pass condition was authored, reviewed, and approved by a human gate authority and whose failure blocks merge. The point of the requirement is that the decision to admit the change to the protected branch was made by, or deterministically enforced on behalf of, a named human.

A CI gate that encodes the equivalent decision must be auditable: the rules file is under version control, reviewed on the same discipline as code, and changed only through the same gate. A CI gate whose rules can be rewritten by the agent being reviewed is not a gate.

---

## Approval Boundary (Required)

> **Activates at:** DESIGN (approval boundary scoped before any action takes place against the repository).

<a name="REQ-ADD-AAD-04"></a>
**REQ-ADD-AAD-04** `artifact` `design` `hard` `addendum:AAD`
The scope of approved agent actions is declared explicitly: allowed file types, directory allowlists, and command categories. Wildcard grants are named explicitly rather than implicit.

Ambiguity about approval scope accumulates as risk. A wildcard grant that was acceptable at one point in the project's history is typically not re-evaluated on its own; it sits and continues to apply until a class-of-failure event exposes it. Explicit enumeration forces the evaluation at declaration time.

At minimum the declaration distinguishes:

- **File-type allowlist:** extensions or paths the agent may write (for example, `*.md`, `src/**/*.ts`).
- **File-type blocklist:** extensions or paths the agent must not write (for example, `*.env`, `secrets/**`).
- **Command categories:** shell-command families the agent is permitted to run (for example, read-only discovery, test runners, formatters). Destructive categories (force-push, history rewrite, dependency removal) require individual justification at the time the agent is invoked, not a blanket grant.
- **Wildcard grants:** if a wildcard grant exists, the rationale is named. "Everything except X" is a valid posture when X is enumerated; it is not a valid posture when X is implicit.

---

## Sandbox and Isolation Posture (Required)

> **Activates at:** DESIGN (isolation level recorded before agent execution begins).

<a name="REQ-ADD-AAD-05"></a>
**REQ-ADD-AAD-05** `artifact` `design` `hard` `addendum:AAD`
The agent execution environment has a declared isolation level (one of: devcontainer, vm, network-isolated, unrestricted, not-applicable) recorded in the posture declaration.

Isolation posture is the containment boundary for a misbehaving agent or a compromised configuration. The declaration makes the containment claim reviewable: a reader can tell whether a directory traversal, an exfiltration attempt, or a credential read against the local filesystem would be contained, limited, or unconstrained.

- **devcontainer:** agent runs inside a container with declared mount scope; filesystem side effects are contained to the container's volume.
- **vm:** agent runs inside a dedicated virtual machine with declared network and filesystem scope.
- **network-isolated:** agent runs on the host filesystem but without general network egress; only named endpoints are reachable.
- **unrestricted:** agent runs on the host with the invoking user's privileges; this is a valid posture for solo projects where the human is the containment boundary, and is invalid posture for any project handling sensitive data.
- **not-applicable:** no agent is configured; the posture exists for compliance-check completeness only.

A posture of `unrestricted` paired with `handles-sensitive-data: true` in the capability declaration is a blocking discrepancy and should be resolved before further work.

### Sandbox and Isolation Posture Extensions

The isolation-level declaration above names the category; the three requirements in this subsection govern the content of the posture within each category. The category alone (`devcontainer`, `vm`, etc.) is not a containment claim; the content is.

<a name="REQ-ADD-AAD-15"></a>
**REQ-ADD-AAD-15** `artifact` `design` `hard` `addendum:AAD`
The posture declaration names the filesystem scope the agent can reach: the directory trees mounted read-write, the directory trees mounted read-only, the directory trees out of reach entirely. A posture that does not name filesystem scope is invalid for any category other than `not-applicable`.

Filesystem scope is what makes the containment claim measurable. An agent running in a `devcontainer` that mounts the whole host filesystem read-write is not containment by the common-sense reading of the term; the category is honest only when scope is named.

<a name="REQ-ADD-AAD-16"></a>
**REQ-ADD-AAD-16** `artifact` `design` `hard` `addendum:AAD`
The posture declaration names the network policy for agent sessions: the egress destinations permitted (by host or CIDR), the egress destinations blocked, whether ingress is permitted (for example, debugging proxies), and whether the policy is enforced at the network layer (e.g., iptables, container networking) or at the application layer (e.g., HTTP client allowlist).

Network policy is a lever the isolation category does not determine: a `vm` with default routing is network-unconstrained; a `devcontainer` with a strict network allowlist is network-constrained. The policy statement disambiguates.

<a name="REQ-ADD-AAD-17"></a>
**REQ-ADD-AAD-17** `artifact` `design` `hard` `addendum:AAD`
The posture declaration names the credential-access scope inside the sandbox: which credentials the agent can read (for example, a scoped API token for the adopter's GitHub organization), which it cannot (for example, the operator's personal PAT), and the mechanism by which the distinction is enforced (mount-scope, environment-variable allowlist, credential-broker).

Without a credential-access scope, a sandboxed agent that can still read the operator's long-lived tokens on disk is not sandboxed for the classes of threat the sandbox was meant to address. Naming the scope is what makes the sandbox threat model complete.

---

## Audit Trail (Required)

> **Activates at:** BUILD (the convention is in place and applied to every agent-initiated commit).

<a name="REQ-ADD-AAD-06"></a>
**REQ-ADD-AAD-06** `gate` `build` `hard` `addendum:AAD` `per-artifact`
Agent-initiated commits are distinguishable from human-initiated commits through a durable convention recorded in the posture declaration (commit message convention, structured trailer, or signed-by field).

The distinction does not have to be visually loud; it has to be machine-readable. A reviewer scanning a branch's log should be able to filter to agent-initiated commits and human-initiated commits without reconstructing state from session logs.

- **Structured trailer:** for example, `Agent-Session: <session-id>` in the commit message trailer block.
- **Signed-by field:** for example, a signing key reserved for agent-initiated commits.
- **Commit message convention:** a stable prefix or suffix, provided it is enforced (a pre-commit hook or server-side rule) rather than a convention agents are asked to honor.

Co-Authored-By trailers are not sufficient on their own: they record authorship but not initiation posture, and different harnesses emit or omit them inconsistently.

---

## Credential Handling (Required)

> **Activates at:** MONITOR (credential posture applies whenever the agent is active).

<a name="REQ-ADD-AAD-07"></a>
**REQ-ADD-AAD-07** `artifact` `monitor` `hard` `addendum:AAD`
Agents do not hold persistent access to credentials outside an active session. Session-scoped credentials are the default; long-lived credentials require an explicit posture rationale.

A long-lived credential attached to an agent execution environment becomes a latent authorization surface: if the environment is compromised, the credential is available for as long as it lives. Session scoping constrains the blast radius to the session window.

- **Session-scoped:** credentials are provisioned for the duration of a session and revoked at session end. This is the default posture.
- **Long-lived, rationale-present:** a declared long-lived credential (for example, a deploy key for a solo project) is acceptable when the posture declaration names the credential, names the rationale, and names the revocation path.
- **Long-lived, rationale-absent:** not a valid posture; reconciliation is required before further work.

Credentials are never stored in agent configuration files, prompt context, or repository history. Configuration files that reference credentials do so via environment-variable names or secret-manager references, not literal values.

---

## Revocation Path (Required)

> **Activates at:** MONITOR (path documented before the first incident; achievable within the declared response window).

<a name="REQ-ADD-AAD-08"></a>
**REQ-ADD-AAD-08** `artifact` `monitor` `hard` `addendum:AAD`
A named path exists for revoking agent commit authority within one business day of a trust incident, recorded in the posture declaration.

Revocation is not a reaction; it is a pre-staged procedure. A trust incident (leaked prompt-injection payload, suspected model-weight compromise, accidental destructive commit) is a high-pressure moment; expecting the path to be designed on-the-fly is expecting it to fail. One business day is a ceiling, not a target; revocation in minutes is strictly better when the path allows it.

At minimum the declaration names:

- **The branch-protection toggle or equivalent** that blocks the agent's commits without affecting other maintainers.
- **The credential-revocation command** for the agent's session credentials, deploy keys, or long-lived tokens.
- **The configuration kill switch:** the single edit to the posture declaration or branch-protection configuration that moves the repository into "no agent-initiated commits permitted" state.

---

## Configuration File Integrity (Required)

> **Activates at:** BUILD (configuration changes reviewed on the same discipline as code).

<a name="REQ-ADD-AAD-09"></a>
**REQ-ADD-AAD-09** `gate` `build` `hard` `addendum:AAD` `per-artifact`
Agent configuration files (for example, CLAUDE.md, AGENTS.md, .cursorrules, harness settings files) are committed to the repository and are treated as normative artifacts subject to the same review discipline as code.

An agent configuration file is executable policy: it changes what the agent will do. A configuration change that lands without review is a privilege escalation that leaves no other audit trail than the commit diff. Treating configuration files as normative artifacts means the commit-authority-boundary, human-gate, and approval-boundary requirements apply to them.

- **Configuration files are version-controlled:** not in a personal dotfiles repository, not in an untracked state, not present on the maintainer's machine but absent from the repository.
- **Configuration changes follow the same gate:** an agent that can rewrite its own configuration and land the change on a protected branch without human review is not operating under a gate.
- **Configuration changes are named in the CHANGELOG** for any change that materially alters the agent's approval boundary, sandbox posture, or commit-authority scope.

---

## MCP and External Tool Register (Required when applicable)

> **Activates at:** DEFINE (register maintained alongside the posture declaration) and BUILD (new tools are added through the same gate).

<a name="REQ-ADD-AAD-10"></a>
**REQ-ADD-AAD-10** `artifact` `define` `hard` `addendum:AAD`
When the harness loads external tools or Model Context Protocol (MCP) servers, a register enumerates each tool, its source, its authentication posture, and its approval status. Tools not on the register are not loaded.

External tools extend the agent's action surface. Each tool added is a new trust relationship; without a register, the cumulative trust surface drifts past what any reviewer can hold in working memory. The register makes the drift reviewable.

At minimum each register row names:

- **Tool identifier:** the name the harness uses to address the tool.
- **Source:** the supply path (for example, a maintainer identity, a package registry coordinate, a GitHub repository).
- **Authentication posture:** how the tool authenticates to upstream services, if it does (for example, `session-scoped-token`, `long-lived-token-rationale-X`, `none`).
- **Approval status:** whether the tool is approved for the current posture (for example, `approved`, `trial`, `blocked`).

When the harness loads no external tools, the register is a single row declaring `not-applicable` with the rationale. Silent absence of the register is not a valid posture.

### MCP Supply-Chain Extensions

The register above names MCP servers and external tools; the four requirements in this subsection govern how those entries are evaluated as supply-chain artifacts. MCPs and external tools are packaged code that the harness grants trust to; each enablement is a supply-chain decision equivalent to adding a dependency to the project.

<a name="REQ-ADD-AAD-11"></a>
**REQ-ADD-AAD-11** `artifact` `define` `hard` `addendum:AAD`
Each MCP or external tool on the register names the provenance-verification evidence used to accept its supply path before enablement: a signed-release verification, a maintainer identity trusted through the adopter's existing trust graph, an internal build with source review, or an explicit "unverified provenance; rationale recorded" acknowledgment. Silent acceptance of a new supply path is not valid posture.

An unverified supply path is a supply-chain attack vector; named acceptance with rationale is not a mitigation but is a reviewable claim that surfaces the risk. The goal is that every row on the register can be traced to a conscious decision about its origin.

<a name="REQ-ADD-AAD-12"></a>
**REQ-ADD-AAD-12** `artifact` `define` `hard` `addendum:AAD`
Each register row pins the MCP or external tool to a specific version (release tag, commit SHA, or content hash); `latest` and unpinned references are invalid. Re-pinning is a register update subject to the same gate as a new enablement.

Unpinned references defeat supply-chain verification by allowing silent upstream rewrites of the trusted code. Pinning is the mechanism that makes REQ-ADD-AAD-11's provenance decision durable; a decision recorded against an unpinned reference applies to a version that does not exist.

<a name="REQ-ADD-AAD-13"></a>
**REQ-ADD-AAD-13** `artifact` `build` `hard` `addendum:AAD`
Enablement and disablement of an MCP or external tool in the register are audit-trailed: a commit message, ADR, or register-local changelog names who decided, when, against what version, and the rationale. Register edits without audit-trail evidence are invalid posture.

The audit trail is what makes the register evolve reviewably. Without it, the register snapshot is an assertion of the current state with no history of decisions; future review has no way to distinguish deliberate enablement from drift.

<a name="REQ-ADD-AAD-14"></a>
**REQ-ADD-AAD-14** `artifact` `design` `soft` `addendum:AAD`
Each register row lists the threat surface the MCP or external tool adds: the classes of data it can exfiltrate, the operations it can perform, the prompt-injection paths it opens. One sentence per class is sufficient; the list need not be exhaustive but must surface the primary threats a reviewer should know.

Threat-listing is the forcing function that makes the adopter reason about the tool before adding it. A tool whose threats cannot be summarized in one sentence per class is a tool whose trust decision is not yet informed enough to make.

---

## External Standards

The U.S. National Institute of Standards and Technology (NIST) Cybersecurity Framework (CSF 2.0) and the Secure Software Development Framework (SSDF, NIST SP 800-218) both address the supply-chain and configuration-integrity aspects of software delivery. Apply the "Protect" and "Detect" function of the CSF to the agent-configuration and MCP registers; apply the SSDF practices PO.1 (define security requirements) and PW.4 (reuse existing, well-secured components) to the approval-boundary and external-tool-register declarations. Track references in [dependencies.md](../../dependencies.md) when adopted.

---

## Testing Gap Audit Additions

| Gap | Typical impact | Priority |
|---|---|---|
| No posture declaration in standards application document | Reader cannot tell whether agents are involved; drift goes undetected | P0 |
| Commit-authority boundary not named (no branch scope recorded) | Agent-initiated commits reach protected branches without a gate | P0 |
| No human gate-authority review or equivalent CI gate on protected branches | Protected history is shaped by unreviewed machine-speed commits | P0 |
| Approval boundary uses wildcard grants without enumerated exceptions | Agent actions outside the intended scope are permitted by default | P1 |
| Sandbox posture unrestricted paired with handles-sensitive-data true | Credential or data exfiltration by misbehaving agent is unconstrained | P0 |
| Agent-initiated commits not distinguishable from human commits | Audit trail cannot separate initiation posture; post-incident triage is manual reconstruction | P1 |
| Long-lived credentials attached to agent without rationale | Compromised agent environment grants persistent access | P0 |
| No revocation path documented | Trust incident response invents the procedure under pressure; mistakes compound | P1 |
| Agent configuration files uncommitted or excluded from review discipline | Privilege escalation lands without a review trail | P0 |
| External tools loaded without a register | Cumulative trust surface drifts past reviewable state | P1 |
