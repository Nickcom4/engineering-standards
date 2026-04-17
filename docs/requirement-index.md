# Requirement Index

> Auto-generated from REQ-ID tags by `scripts/generate-req-index.sh`. Do not edit by hand.
> Source: 627 active REQ-IDs across the corpus (STANDARDS.md, 7 addenda, templates, starters, adoption.md).
> Organized by lifecycle scope, then by applies-when group.
> Enforcement: **hard** = blocks; *soft* = warns; none = informational.

---

## Table of Contents

- [Discover](#discover)
- [Define](#define)
- [Design](#design)
- [Build](#build)
- [Verify](#verify)
- [Document](#document)
- [Deploy](#deploy)
- [Monitor](#monitor)
- [Close](#close)
- [Commit (pre-commit hooks)](#commit-pre-commit-hooks)
- [Session Start](#session-start)
- [Session End](#session-end)
- [Continuous](#continuous)

---

## Discover

*7 requirements.*

### All work items

| REQ-ID | Enforcement | Statement | Source |
|---|---|---|---|
| `REQ-2.1-19` | **hard** | Every observed signal has a D0 intake log entry recording the raw observation and source. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-2.1-20` | **hard** | D1 triage includes an evidence check, a duplicate check, and consultation of the lessons-learned and anti-pattern regist... | [STANDARDS.md](../STANDARDS.md) |
| `REQ-2.1-21` | **hard** | D1 triage produces exactly one of four decisions: promote to DEFINE, investigate, park with a revisit trigger, or discar... | [STANDARDS.md](../STANDARDS.md) |
| `REQ-2.1-22` | **hard** | When a signal is confirmed but AC cannot yet be written, D2 characterization produces an investigation or problem resear... | [STANDARDS.md](../STANDARDS.md) |

### Addendum: Continuous Improvement

| REQ-ID | Enforcement | Statement | Source |
|---|---|---|---|
| `REQ-ADD-CI-04` | **hard** | Gemba (direct observation of current state from actual artifacts) is completed before any improvement hypothesis is form... | [docs/addenda/continuous-improvement.md](addenda/continuous-improvement.md) |
| `REQ-ADD-CI-09` | **hard** | Observations are written, not inferred. | [docs/addenda/continuous-improvement.md](addenda/continuous-improvement.md) |

### type:expedite

| REQ-ID | Enforcement | Statement | Source |
|---|---|---|---|
| `REQ-2.1-23` | **hard** | Expedite class signals are resolved first; D0 and D1 documentation is back-filled after resolution. | [STANDARDS.md](../STANDARDS.md) |

## Define

*57 requirements.*

### All work items

| REQ-ID | Enforcement | Statement | Source |
|---|---|---|---|
| `REQ-1.1-01` | **hard** | A problem statement is documented before design or implementation begins. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-1.1-02` | **hard** | A first principles check (3 questions: fundamentally doing, constraints, simplest solution) is completed before design b... | [STANDARDS.md](../STANDARDS.md) |
| `REQ-1.1-03` | **hard** | Explicit IN scope and OUT of scope lists are present in the work item or scoping document. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-1.1-05` | **hard** | Failure criteria with specific metric thresholds and rollback actions are defined before implementation begins. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-1.1-08` | **hard** | Each success metric has a numeric threshold or binary pass/fail condition. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-1.1-09` | *soft* | Each success metric is achievable: the team can influence the outcome. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-1.1-11` | **hard** | Each success metric states when it will be measured. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-1.1-12` | **hard** | Each success metric states the measurement method. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-1.1-13` | **hard** | The problem statement identifies who has the problem. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-1.1-14` | *soft* | The problem statement states how frequently the problem occurs. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-1.1-15` | **hard** | The problem statement describes the current approach or workaround. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-1.1-16` | *soft* | The problem statement quantifies the cost of the current state. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-1.1-17` | **hard** | The problem statement describes what solved looks like. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-1.2-07` | **hard** | Each document in the §1.2 progression has its gate passed (approval, proceed/no-proceed decision) before the next docume... | [STANDARDS.md](../STANDARDS.md) |
| `REQ-1.3-01` | **hard** | Each planned phase defines what is included. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-1.3-02` | **hard** | Each phase's measurable milestone is binary verifiable: it either passes or does not, with no judgment required. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-1.3-03` | **hard** | Each planned phase defines what is excluded. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-1.3-04` | **hard** | Each planned phase defines a binary measurable milestone. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-1.3-06` | **hard** | Each planned phase defines a decision point for evaluating whether to continue. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-2.1-02` | **hard** | Acceptance criteria are written before any implementation work (code, documentation, configuration, or infrastructure) b... | [STANDARDS.md](../STANDARDS.md) |
| `REQ-2.2-01` | **hard** | A work item has a title. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-2.2-02` | **hard** | A work item either addresses a root cause directly or identifies itself as a symptom fix with a link to the root-cause w... | [STANDARDS.md](../STANDARDS.md) |
| `REQ-2.2-08` | **hard** | Acceptance criteria are observable, binary, and measurable: each states a specific condition that is either true or fals... | [STANDARDS.md](../STANDARDS.md) |
| `REQ-2.2-10` | **hard** | A work item is not claimed until AC are written and agreed. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-2.2-13` | **hard** | A work item has linked dependencies. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-2.2-14` | **hard** | A work item has an assigned owner. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-2.2-15` | **hard** | A work item has a discovery source. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-2.2-16` | **hard** | A work item has a priority. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-2.2-17` | **hard** | A work item has a class of service. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-2.2-18` | **hard** | A work item has a type. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-2.2-21` | **hard** | A work item is not claimed until dependencies are identified. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-6.2-01` | **hard** | The project maintains a testing gap table audited at the start of every significant feature phase. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-6.2-02` | **hard** | P0 and P1 gaps block shipping the affected feature. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-6.3-03` | **hard** | Output quality gate thresholds for the project are documented in the standards application document. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-8.3-01` | **hard** | The lessons-learned registry is consulted before starting any new feature. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-ADO-03` | **hard** | First steps after adoption are completed in order: copy starters, set up repo structure, identify applicable addenda, de... | [docs/adoption.md](adoption.md) |
| `REQ-ADO-04` | *soft* | Pre-existing projects adopt incrementally: create standards-application.md first, add missing files in priority order (R... | [docs/adoption.md](adoption.md) |

### type: feature

| REQ-ID | Enforcement | Statement | Source |
|---|---|---|---|
| `REQ-1.2-01` | **hard** | The §1.2 document progression (problem research, capabilities, PRD, architecture) is followed in order for new products ... | [STANDARDS.md](../STANDARDS.md) |
| `REQ-1.2-03` | **hard** | Each §1.2 step is complete when its gate is satisfied, not merely when a document exists. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-1.2-04` | **hard** | Each §1.2 step is complete when its gate is satisfied, not merely when a document exists. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-1.2-05` | **hard** | Producing a document without passing its gate is not completing the step. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-1.2-06` | **hard** | Each step's gate is satisfied before the next step begins. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-2.2-09` | **hard** | At least one acceptance criterion covers a failure, boundary, or error condition. | [STANDARDS.md](../STANDARDS.md) |

### Addendum: Continuous Improvement

| REQ-ID | Enforcement | Statement | Source |
|---|---|---|---|
| `REQ-ADD-CI-05` | **hard** | SIPOC Suppliers are identified before scoping any improvement initiative. | [docs/addenda/continuous-improvement.md](addenda/continuous-improvement.md) |

### Addendum: Multi-Team

| REQ-ID | Enforcement | Statement | Source |
|---|---|---|---|
| `REQ-ADD-MT-03` | **hard** | An RFC is written before implementation begins when any trigger condition is true (API change, behavior change, capabili... | [docs/addenda/multi-team.md](addenda/multi-team.md) |

### Addendum: Web Applications

| REQ-ID | Enforcement | Statement | Source |
|---|---|---|---|
| `REQ-ADD-WEB-01` | **hard** | The project application document records a specific numeric threshold for LCP. | [docs/addenda/web-applications.md](addenda/web-applications.md) |
| `REQ-ADD-WEB-26` | **hard** | The project application document records a specific numeric threshold for INP. | [docs/addenda/web-applications.md](addenda/web-applications.md) |
| `REQ-ADD-WEB-27` | **hard** | The project application document records a specific numeric threshold for CLS. | [docs/addenda/web-applications.md](addenda/web-applications.md) |
| `REQ-ADD-WEB-28` | **hard** | The project application document records minimum Lighthouse scores for Performance, Accessibility, Best Practices, and S... | [docs/addenda/web-applications.md](addenda/web-applications.md) |

### addendum:AAD

| REQ-ID | Enforcement | Statement | Source |
|---|---|---|---|
| `REQ-ADD-AAD-01` | **hard** | The project's standards application document declares the harness in use, whether agents hold commit authority, the sand... | [docs/addenda/agent-assisted-development.md](addenda/agent-assisted-development.md) |
| `REQ-ADD-AAD-02` | **hard** | When an agent holds commit authority, the branches on which agent-initiated commits are permitted are named, and the gat... | [docs/addenda/agent-assisted-development.md](addenda/agent-assisted-development.md) |
| `REQ-ADD-AAD-10` | **hard** | When the harness loads external tools or Model Context Protocol (MCP) servers, a register enumerates each tool, its sour... | [docs/addenda/agent-assisted-development.md](addenda/agent-assisted-development.md) |
| `REQ-ADD-AAD-11` | **hard** | Each MCP or external tool on the register names the provenance-verification evidence used to accept its supply path befo... | [docs/addenda/agent-assisted-development.md](addenda/agent-assisted-development.md) |
| `REQ-ADD-AAD-12` | **hard** | Each register row pins the MCP or external tool to a specific version (release tag, commit SHA, or content hash); `lates... | [docs/addenda/agent-assisted-development.md](addenda/agent-assisted-development.md) |

### type:improvement

| REQ-ID | Enforcement | Statement | Source |
|---|---|---|---|
| `REQ-2.1-12` | **hard** | Improvement work items record the baseline measurement and method before BUILD begins. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-8.7-01` | **hard** | Recurring quality issues, delivery bottlenecks, and process inefficiencies use A3 structured problem solving. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-8.7-02` | **hard** | The A3 is completed before countermeasures are implemented. | [STANDARDS.md](../STANDARDS.md) |

## Design

*74 requirements.*

### All work items

| REQ-ID | Enforcement | Statement | Source |
|---|---|---|---|
| `REQ-2.1-17` | **hard** | High-RPN failure modes and any with Severity 9-10 have design changes before BUILD begins. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-2.1-37` | **hard** | Every FMEA failure mode above the RPN threshold has a named control recorded in the FMEA controls summary before the FME... | [STANDARDS.md](../STANDARDS.md) |
| `REQ-2.1-41` | **hard** | The RPN threshold is defined in the FMEA before failure mode scoring begins. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-2.1-42` | **hard** | After a corrective action is implemented, the failure mode is rescored with the control in place. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-2.1-48` | *soft* | The default RPN threshold is 75; the default severity threshold is 7. Projects override these in their standards-applica... | [STANDARDS.md](../STANDARDS.md) |
| `REQ-3.3-01` | **hard** | No changes to a component that lacks an architecture doc until the doc exists or an issue is filed to create it. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-3.4-02` | *soft* | Independent deployability test passes: the team can deploy its component without coordinating a release with any other t... | [STANDARDS.md](../STANDARDS.md) |
| `REQ-3.4-03` | **hard** | Independent testability test passes: the team can test its component in isolation using test doubles for dependencies. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-4.2-01` | **hard** | An ADR exists for every qualifying change. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-4.2-02` | **hard** | ADR validation criteria are outcome-based and binary (true or false, not a judgment call) with an event-based assessment... | [STANDARDS.md](../STANDARDS.md) |
| `REQ-4.2-03` | **hard** | The ADR includes a context section (problem, constraints, cost of doing nothing). | [STANDARDS.md](../STANDARDS.md) |
| `REQ-4.2-04` | **hard** | The ADR includes a decision section (specific and unambiguous). | [STANDARDS.md](../STANDARDS.md) |
| `REQ-4.2-05` | **hard** | The ADR includes a consequences section (positive and negative trade-offs). | [STANDARDS.md](../STANDARDS.md) |
| `REQ-4.2-06` | **hard** | The ADR includes an alternatives considered section with rejection rationale for each. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-4.2-07` | **hard** | The ADR includes a validation section with binary outcome-based assessment criteria and an event-based trigger. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-4.2-08` | **hard** | When an ADR's dfmea frontmatter field is populated, the named DFMEA file exists and its adr field references this ADR. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-4.2-09` | **hard** | When an ADR's pfmea frontmatter field is populated, the named PFMEA file exists and its adr field references this ADR. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-4.2-10` | **hard** | An ADR that modifies an existing component, API, interface, or standard includes a Per-Document Impact Analysis section. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-4.2-11` | **hard** | Each entry in the Per-Document Impact Analysis section states either the required change or an explicit confirmation tha... | [STANDARDS.md](../STANDARDS.md) |
| `REQ-5.10-03` | *soft* | Projects handling personal data in regulated jurisdictions identify which regulations apply and document where complianc... | [STANDARDS.md](../STANDARDS.md) |
| `REQ-5.4-02` | **hard** | Every system defines its behavior under overload (shed load, queue with backpressure, or degrade gracefully) before over... | [STANDARDS.md](../STANDARDS.md) |
| `REQ-9.1-01` | **hard** | Research is completed before adopting any new technology, framework, or external service. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-9.1-02` | **hard** | The technology adoption decision (proceed, reject, or defer) is recorded in an ADR with rollback plan defined before int... | [STANDARDS.md](../STANDARDS.md) |
| `REQ-TPL-09` | **hard** | Architecture document goals are measurable with a specific metric, threshold, and measurement method. | [templates/architecture-doc.md](../templates/architecture-doc.md) |
| `REQ-TPL-11` | **hard** | Every external dependency states what happens when it is unavailable: timeout, retry, and fallback behavior. | [templates/architecture-doc.md](../templates/architecture-doc.md) |
| `REQ-TPL-12` | **hard** | Each gap in the current vs target state table has a filed §2.2 work item ID. | [templates/architecture-doc.md](../templates/architecture-doc.md) |

### type: component

| REQ-ID | Enforcement | Statement | Source |
|---|---|---|---|
| `REQ-3.1-01` | **hard** | Every system component has an architecture document. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-3.1-02` | **hard** | Always-on services with a defined uptime SLO include a Fault Tree Analysis and reliability block diagram in the architec... | [STANDARDS.md](../STANDARDS.md) |
| `REQ-3.1-10` | **hard** | The architecture document states the component's purpose. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-3.1-11` | **hard** | The architecture document states measurable goals. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-3.1-12` | **hard** | The architecture document includes a current vs. target state comparison. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-3.1-13` | **hard** | The architecture document includes a system diagram. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-3.1-14` | **hard** | The architecture document documents data flows. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-3.1-15` | **hard** | The architecture document documents all dependencies with failure behavior for each. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-3.1-16` | **hard** | The architecture document documents failure modes. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-3.1-17` | **hard** | The architecture document documents system boundaries. | [STANDARDS.md](../STANDARDS.md) |

### Addendum: Continuous Improvement

| REQ-ID | Enforcement | Statement | Source |
|---|---|---|---|
| `REQ-ADD-CI-01` | **hard** | Value stream mapping produces a current-state map with active time and wait time sourced from at least 10 completed work... | [docs/addenda/continuous-improvement.md](addenda/continuous-improvement.md) |
| `REQ-ADD-CI-07` | **hard** | At least one improvement work item is filed with a measurable before/after target. | [docs/addenda/continuous-improvement.md](addenda/continuous-improvement.md) |
| `REQ-ADD-CI-64` | **hard** | Before the first improvement work item is filed against a value stream, the bottleneck stage is named explicitly and bac... | [docs/addenda/continuous-improvement.md](addenda/continuous-improvement.md) |

### Addendum: Multi-Team

| REQ-ID | Enforcement | Statement | Source |
|---|---|---|---|
| `REQ-ADD-MT-01` | **hard** | Before any significant new component: document which team owns it end-to-end. | [docs/addenda/multi-team.md](addenda/multi-team.md) |
| `REQ-ADD-MT-07` | **hard** | Changes affecting another team's work or timelines are communicated before work begins: what is changing, when, what act... | [docs/addenda/multi-team.md](addenda/multi-team.md) |

### Addendum: Event-Driven

| REQ-ID | Enforcement | Statement | Source |
|---|---|---|---|
| `REQ-ADD-EVT-04` | **hard** | Every queue/stream consumer has a defined dead letter handling strategy: failed messages route to a DLQ, DLQ is monitore... | [docs/addenda/event-driven.md](addenda/event-driven.md) |
| `REQ-ADD-EVT-05` | **hard** | Backpressure behavior is defined explicitly (block, drop, or buffer). | [docs/addenda/event-driven.md](addenda/event-driven.md) |
| `REQ-ADD-EVT-12` | **hard** | Queue depth alerts fire before saturation. | [docs/addenda/event-driven.md](addenda/event-driven.md) |
| `REQ-ADD-EVT-13` | **hard** | Consumer maximum sustainable throughput is known and tested. | [docs/addenda/event-driven.md](addenda/event-driven.md) |
| `REQ-ADD-EVT-17` | *soft* | If event sourcing is used: event log retention policy is documented in the architecture doc. | [docs/addenda/event-driven.md](addenda/event-driven.md) |
| `REQ-ADD-EVT-21` | *soft* | If event sourcing is used: snapshot strategy is documented in the architecture doc. | [docs/addenda/event-driven.md](addenda/event-driven.md) |
| `REQ-ADD-EVT-22` | *soft* | If event sourcing is used: schema evolution (upcasting) strategy is documented in the architecture doc. | [docs/addenda/event-driven.md](addenda/event-driven.md) |
| `REQ-ADD-EVT-23` | *soft* | If event sourcing is used: consistency model is documented in the architecture doc. | [docs/addenda/event-driven.md](addenda/event-driven.md) |

### Addendum: AI/ML

| REQ-ID | Enforcement | Statement | Source |
|---|---|---|---|
| `REQ-ADD-AI-01` | **hard** | Every downstream consumer of AI output has a named fallback action (default value, human escalation, rejection with expl... | [docs/addenda/ai-ml.md](addenda/ai-ml.md) |
| `REQ-ADD-AI-02` | **hard** | Every AI-consuming component distinguishes confidence score from correctness. | [docs/addenda/ai-ml.md](addenda/ai-ml.md) |
| `REQ-ADD-AI-03` | **hard** | Every AI-driven action type is classified by autonomy level (informational, assisted, automated, autonomous). | [docs/addenda/ai-ml.md](addenda/ai-ml.md) |
| `REQ-ADD-AI-04` | **hard** | Grounding strategy is documented for every user-facing generative AI output. | [docs/addenda/ai-ml.md](addenda/ai-ml.md) |
| `REQ-ADD-AI-08` | **hard** | Any model driving automated decisions, surfacing recommendations, or contributing to consequential outcomes has a docume... | [docs/addenda/ai-ml.md](addenda/ai-ml.md) |
| `REQ-ADD-AI-09` | **hard** | The architecture reflects that high-confidence wrong answers are more dangerous than low-confidence answers that trigger... | [docs/addenda/ai-ml.md](addenda/ai-ml.md) |
| `REQ-ADD-AI-10` | **hard** | Mixed levels require explicit boundaries. | [docs/addenda/ai-ml.md](addenda/ai-ml.md) |
| `REQ-ADD-AI-21` | **hard** | Validation strategy is documented for every user-facing generative AI output. | [docs/addenda/ai-ml.md](addenda/ai-ml.md) |
| `REQ-ADD-AI-22` | **hard** | Confidence communication strategy is documented for every user-facing generative AI output. | [docs/addenda/ai-ml.md](addenda/ai-ml.md) |
| `REQ-ADD-AI-23` | **hard** | Human review gates are documented for every user-facing generative AI output. | [docs/addenda/ai-ml.md](addenda/ai-ml.md) |
| `REQ-ADD-AI-30` | **hard** | The F1 threshold for LLM-generated enforcement rule activation is set and committed before evaluation begins. | [docs/addenda/ai-ml.md](addenda/ai-ml.md) |

### Addendum: Multi-Service

| REQ-ID | Enforcement | Statement | Source |
|---|---|---|---|
| `REQ-ADD-MS-01` | **hard** | Every request crossing a service boundary is authenticated. | [docs/addenda/multi-service.md](addenda/multi-service.md) |
| `REQ-ADD-MS-06` | **hard** | Every cross-service operation requiring consistency has a documented strategy (saga, eventual consistency, or synchronou... | [docs/addenda/multi-service.md](addenda/multi-service.md) |
| `REQ-ADD-MS-07` | **hard** | The authentication mechanism (mTLS, token, API key) and authorization model are documented for each interface. | [docs/addenda/multi-service.md](addenda/multi-service.md) |

### addendum:AAD

| REQ-ID | Enforcement | Statement | Source |
|---|---|---|---|
| `REQ-ADD-AAD-04` | **hard** | The scope of approved agent actions is declared explicitly: allowed file types, directory allowlists, and command catego... | [docs/addenda/agent-assisted-development.md](addenda/agent-assisted-development.md) |
| `REQ-ADD-AAD-05` | **hard** | The agent execution environment has a declared isolation level (one of: devcontainer, vm, network-isolated, unrestricted... | [docs/addenda/agent-assisted-development.md](addenda/agent-assisted-development.md) |
| `REQ-ADD-AAD-14` | *soft* | Each register row lists the threat surface the MCP or external tool adds: the classes of data it can exfiltrate, the ope... | [docs/addenda/agent-assisted-development.md](addenda/agent-assisted-development.md) |
| `REQ-ADD-AAD-15` | **hard** | The posture declaration names the filesystem scope the agent can reach: the directory trees mounted read-write, the dire... | [docs/addenda/agent-assisted-development.md](addenda/agent-assisted-development.md) |
| `REQ-ADD-AAD-16` | **hard** | The posture declaration names the network policy for agent sessions: the egress destinations permitted (by host or CIDR)... | [docs/addenda/agent-assisted-development.md](addenda/agent-assisted-development.md) |
| `REQ-ADD-AAD-17` | **hard** | The posture declaration names the credential-access scope inside the sandbox: which credentials the agent can read (for ... | [docs/addenda/agent-assisted-development.md](addenda/agent-assisted-development.md) |

### type:feature AND (type:component OR type:security)

| REQ-ID | Enforcement | Statement | Source |
|---|---|---|---|
| `REQ-2.1-03` | **hard** | An ADR exists when the work item introduces a new component, replaces an existing approach, adds an external dependency,... | [STANDARDS.md](../STANDARDS.md) |

### type:feature AND type:security

| REQ-ID | Enforcement | Statement | Source |
|---|---|---|---|
| `REQ-2.1-04` | **hard** | A DFMEA is completed when the work item touches authentication, payments, data mutation, or external integrations. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-2.1-35` | **hard** | The project PFMEA is reviewed when the work item touches authentication, payments, data mutation, or external integratio... | [STANDARDS.md](../STANDARDS.md) |
| `REQ-TPL-25` | **hard** | An FMEA exists for qualifying changes with all required sections: FM table, RPN tracking, controls summary, high-severit... | [templates/fmea.md](../templates/fmea.md) |

### type:feature OR type:component

| REQ-ID | Enforcement | Statement | Source |
|---|---|---|---|
| `REQ-2.1-54` | **hard** | Before writing an ADR or architecture document: a D2 characterization artifact is either cited in the ADR Context sectio... | [STANDARDS.md](../STANDARDS.md) |

## Build

*65 requirements.*

### All work items

| REQ-ID | Enforcement | Statement | Source |
|---|---|---|---|
| `REQ-2.1-05` | **hard** | Tests are written alongside or before the code they cover. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-2.1-24` | **hard** | When BUILD discovers DEFINE was incomplete, work returns to DEFINE and AC are updated before BUILD continues. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-2.6-01` | *soft* | Work is delivered in the smallest increment that can be independently reviewed, tested, deployed, and reversed. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-4.5-01` | **hard** | Every public function and module documents what it does (one sentence). | [STANDARDS.md](../STANDARDS.md) |
| `REQ-4.5-02` | **hard** | No undocumented public functions exist. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-4.5-05` | **hard** | Every public function and module documents why it exists. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-4.5-06` | **hard** | Every public function and module documents what can go wrong (failure modes and edge cases). | [STANDARDS.md](../STANDARDS.md) |
| `REQ-4.5-07` | **hard** | Every public API has example usage documented. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-5.1-07` | **hard** | All work happens in short-lived branches integrated back before divergence from the primary branch creates material merg... | [STANDARDS.md](../STANDARDS.md) |
| `REQ-5.10-02` | **hard** | Services storing or processing sensitive data meet OWASP ASVS Level 1 minimum controls. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-5.2-01` | **hard** | All dependencies are explicitly declared, version-pinned, and vulnerability-scanned on every CI pass. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-5.2-04` | **hard** | High-severity findings block merge. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-5.4-01` | **hard** | Every external call (HTTP, database, queue, third-party API) has a defined timeout. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-5.4-03` | **hard** | Any operation that retries on failure uses exponential backoff with jitter. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-5.4-04` | **hard** | All long-running processes tolerate restart without corrupting state or duplicating irreversible work. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-5.8-01` | **hard** | APIs follow semantic versioning. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-5.8-02` | **hard** | Breaking changes require a major version increment, a documented deprecation period, and old versions remain functional ... | [STANDARDS.md](../STANDARDS.md) |
| `REQ-5.9-02` | *soft* | Secrets have a defined lifecycle. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-5.9-03` | *soft* | Logs are structured event streams. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-6.1-01` | **hard** | Every function with logic (branching, looping, computation, state transformation, error handling) has a unit test. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-6.1-04` | **hard** | Every fixed bug has a regression test. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-6.4-01` | **hard** | Work stops when a defect is detected during development. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-6.4-02` | **hard** | No defect passes downstream to the next stage. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-7.6-02` | **hard** | Sensitive payloads are redacted before emission. | [STANDARDS.md](../STANDARDS.md) |

### type: security

| REQ-ID | Enforcement | Statement | Source |
|---|---|---|---|
| `REQ-6.5-01` | **hard** | Security-affecting changes have regression tests covering unauthorized access. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-6.5-03` | **hard** | Security-affecting changes have regression tests covering injection. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-6.5-04` | **hard** | Security-affecting changes have regression tests covering path traversal. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-6.5-05` | **hard** | Security-affecting changes have regression tests covering SSRF. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-6.5-06` | **hard** | Security-affecting changes have regression tests covering data leakage. | [STANDARDS.md](../STANDARDS.md) |

### Addendum: Continuous Improvement

| REQ-ID | Enforcement | Statement | Source |
|---|---|---|---|
| `REQ-ADD-CI-40` | *soft* | Setup times are measured and targeted for reduction: local dev environment under 15 minutes, CI pipeline under 10 minute... | [docs/addenda/continuous-improvement.md](addenda/continuous-improvement.md) |

### Addendum: Web Applications

| REQ-ID | Enforcement | Statement | Source |
|---|---|---|---|
| `REQ-ADD-WEB-02` | **hard** | Web interfaces conform to WCAG 2.2 Level AA minimum. | [docs/addenda/web-applications.md](addenda/web-applications.md) |
| `REQ-ADD-WEB-05` | **hard** | Keyboard navigation meets AA thresholds. | [docs/addenda/web-applications.md](addenda/web-applications.md) |
| `REQ-ADD-WEB-08` | **hard** | All user-visible strings are externalized through a localization function. | [docs/addenda/web-applications.md](addenda/web-applications.md) |
| `REQ-ADD-WEB-09` | **hard** | No user-visible string is assembled by string concatenation in code. | [docs/addenda/web-applications.md](addenda/web-applications.md) |
| `REQ-ADD-WEB-10` | **hard** | CSP disallows inline scripts except where explicitly required and documented. | [docs/addenda/web-applications.md](addenda/web-applications.md) |
| `REQ-ADD-WEB-29` | **hard** | Focus management meets AA thresholds. | [docs/addenda/web-applications.md](addenda/web-applications.md) |
| `REQ-ADD-WEB-30` | **hard** | Screen reader compatibility meets AA thresholds. | [docs/addenda/web-applications.md](addenda/web-applications.md) |
| `REQ-ADD-WEB-31` | **hard** | Color is not the sole channel for conveying information. | [docs/addenda/web-applications.md](addenda/web-applications.md) |
| `REQ-ADD-WEB-32` | **hard** | Text contrast meets AA thresholds. | [docs/addenda/web-applications.md](addenda/web-applications.md) |
| `REQ-ADD-WEB-33` | **hard** | All user-visible dates and numbers are externalized through a localization function. | [docs/addenda/web-applications.md](addenda/web-applications.md) |
| `REQ-ADD-WEB-34` | **hard** | All user-visible currencies are externalized through a localization function. | [docs/addenda/web-applications.md](addenda/web-applications.md) |
| `REQ-ADD-WEB-35` | **hard** | All user-visible plural forms are externalized through a localization function. | [docs/addenda/web-applications.md](addenda/web-applications.md) |

### Addendum: Event-Driven

| REQ-ID | Enforcement | Statement | Source |
|---|---|---|---|
| `REQ-ADD-EVT-01` | **hard** | Every event type has a versioned schema. | [docs/addenda/event-driven.md](addenda/event-driven.md) |
| `REQ-ADD-EVT-02` | **hard** | Consumers ignore unknown fields (tolerant reader pattern). | [docs/addenda/event-driven.md](addenda/event-driven.md) |
| `REQ-ADD-EVT-03` | **hard** | Every consumer handles duplicate message delivery without producing duplicate effects. | [docs/addenda/event-driven.md](addenda/event-driven.md) |
| `REQ-ADD-EVT-07` | **hard** | Schema compatibility is enforced mechanically via a schema registry. | [docs/addenda/event-driven.md](addenda/event-driven.md) |
| `REQ-ADD-EVT-08` | **hard** | Breaking changes follow the §5.8 deprecation policy. | [docs/addenda/event-driven.md](addenda/event-driven.md) |
| `REQ-ADD-EVT-09` | **hard** | Schema evolution is add-only. | [docs/addenda/event-driven.md](addenda/event-driven.md) |
| `REQ-ADD-EVT-10` | **hard** | Fields are never removed, renamed, or re-typed in place. | [docs/addenda/event-driven.md](addenda/event-driven.md) |
| `REQ-ADD-EVT-11` | **hard** | The architecture document names the specific idempotency mechanism and where state is stored. | [docs/addenda/event-driven.md](addenda/event-driven.md) |

### Addendum: AI/ML

| REQ-ID | Enforcement | Statement | Source |
|---|---|---|---|
| `REQ-ADD-AI-06` | **hard** | Training and fine-tuning data has documented provenance. | [docs/addenda/ai-ml.md](addenda/ai-ml.md) |
| `REQ-ADD-AI-24` | **hard** | Training data contains no PII without documented consent and legal basis. | [docs/addenda/ai-ml.md](addenda/ai-ml.md) |
| `REQ-ADD-AI-26` | **hard** | Training data retention policies match production data retention policies. | [docs/addenda/ai-ml.md](addenda/ai-ml.md) |

### Addendum: Containerized Systems

| REQ-ID | Enforcement | Statement | Source |
|---|---|---|---|
| `REQ-ADD-CTR-01` | **hard** | Image scanning runs on every build. | [docs/addenda/containerized-systems.md](addenda/containerized-systems.md) |
| `REQ-ADD-CTR-05` | **hard** | Critical and High severity findings block deployment. | [docs/addenda/containerized-systems.md](addenda/containerized-systems.md) |
| `REQ-ADD-CTR-06` | **hard** | Medium findings triaged within 30 days. | [docs/addenda/containerized-systems.md](addenda/containerized-systems.md) |
| `REQ-ADD-CTR-07` | **hard** | Weekly scheduled re-scans active. | [docs/addenda/containerized-systems.md](addenda/containerized-systems.md) |

### Addendum: Multi-Service

| REQ-ID | Enforcement | Statement | Source |
|---|---|---|---|
| `REQ-ADD-MS-03` | **hard** | Consumer-driven contract tests exist for every public API endpoint consumed by an external team. | [docs/addenda/multi-service.md](addenda/multi-service.md) |
| `REQ-ADD-MS-04` | **hard** | Every outbound call has a defined timeout, circuit breaker with failure threshold, and defined fallback behavior when th... | [docs/addenda/multi-service.md](addenda/multi-service.md) |
| `REQ-ADD-MS-05` | **hard** | Every request crossing a service boundary propagates a correlation ID. | [docs/addenda/multi-service.md](addenda/multi-service.md) |
| `REQ-ADD-MS-08` | **hard** | Provider CI fails if a consumer contract is broken. | [docs/addenda/multi-service.md](addenda/multi-service.md) |
| `REQ-ADD-MS-09` | **hard** | All spans in a request trace are linkable across all services. | [docs/addenda/multi-service.md](addenda/multi-service.md) |

### addendum:AAD

| REQ-ID | Enforcement | Statement | Source |
|---|---|---|---|
| `REQ-ADD-AAD-06` | **hard** | Agent-initiated commits are distinguishable from human-initiated commits through a durable convention recorded in the po... | [docs/addenda/agent-assisted-development.md](addenda/agent-assisted-development.md) |
| `REQ-ADD-AAD-09` | **hard** | Agent configuration files (for example, CLAUDE.md, AGENTS.md, .cursorrules, harness settings files) are committed to the... | [docs/addenda/agent-assisted-development.md](addenda/agent-assisted-development.md) |
| `REQ-ADD-AAD-13` | **hard** | Enablement and disablement of an MCP or external tool in the register are audit-trailed: a commit message, ADR, or regis... | [docs/addenda/agent-assisted-development.md](addenda/agent-assisted-development.md) |

## Verify

*69 requirements.*

### All work items

| REQ-ID | Enforcement | Statement | Source |
|---|---|---|---|
| `REQ-2.1-06` | **hard** | Unit tests pass before the work item advances past VERIFY. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-2.1-07` | **hard** | The VERIFY answer is recorded in the work item before CLOSE: what was specifically verified and the result. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-2.1-13` | **hard** | Documentation-only changes: every internal link resolves to a valid target. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-2.1-15` | **hard** | Integration tests pass before the work item advances past VERIFY. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-2.1-25` | **hard** | When VERIFY reveals DESIGN was wrong, work returns to DESIGN before VERIFY continues. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-2.1-28` | **hard** | Documentation-only changes: no formatting defects (corrupt tables, orphaned lines, mismatched heading levels). | [STANDARDS.md](../STANDARDS.md) |
| `REQ-2.1-29` | **hard** | Documentation-only changes: no AI-generated typographic characters (em dashes, en dashes, double-hyphen sentence dashes)... | [STANDARDS.md](../STANDARDS.md) |
| `REQ-2.1-30` | *soft* | Documentation-only changes: all cross-references are hyperlinks, not plain text. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-2.1-31` | *soft* | Documentation-only changes: no sentence fragments or duplicate sentences. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-2.1-32` | **hard** | Documentation-only changes: every template section covers the requirements from its governing standard section. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-2.1-33` | **hard** | Documentation-only changes: changelog entry written. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-2.1-38` | **hard** | Every named control in the FMEA controls summary has either an implemented artifact or a tracked work item before the wo... | [STANDARDS.md](../STANDARDS.md) |
| `REQ-2.1-43` | **hard** | All count references, RPN values, and status claims within an FMEA document are internally consistent at close. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-2.1-46` | **hard** | Every markdown table has consistent column counts across all rows within the table. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-2.1-47` | **hard** | FMEA and analysis documents have internally consistent data: iteration counts, RPN values, status claims, and summary ta... | [STANDARDS.md](../STANDARDS.md) |
| `REQ-2.1-49` | **hard** | FMEA derived sections (High-Severity table, RPN Summary, Controls Summary, Review Checklist) are either auto-generated f... | [STANDARDS.md](../STANDARDS.md) |
| `REQ-2.1-53` | **hard** | Every checked item in an FMEA Controls Summary that references a script file is verified: the script exists and is calle... | [STANDARDS.md](../STANDARDS.md) |
| `REQ-2.5-01` | **hard** | Any change expanding attack surface, adding external endpoints, processing new sensitive data, or increasing process per... | [STANDARDS.md](../STANDARDS.md) |
| `REQ-2.5-04` | *soft* | Change approval is risk-based: automated gates for routine changes, peer review for moderate risk, explicit human approv... | [STANDARDS.md](../STANDARDS.md) |
| `REQ-5.1-02` | **hard** | At least one review is completed before merge. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-5.1-08` | **hard** | Review verifies acceptance criteria are met. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-5.1-11` | **hard** | Review verifies tests cover the change. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-5.1-12` | **hard** | Review verifies no security issues introduced. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-5.1-13` | **hard** | Review verifies code style matches existing patterns. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-5.1-14` | **hard** | Review verifies the change does what the description says. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-6.1-02` | **hard** | Integration tests (multiple modules, may use real DB, runs on CI) pass before the work item advances. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-6.1-03` | **hard** | Performance tests assert on timing for any feature with a latency requirement. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-6.1-05` | **hard** | Load tests verify concurrent usage for any service with external users. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-6.3-01` | **hard** | Every output type (UI, API, CLI, errors, logs, notifications, reports) is verified for correct communication. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-6.3-02` | **hard** | Every output type is intentional, complete, and clear. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-6.3-04` | **hard** | User-facing output is usable by people with disabilities (keyboard navigation, accessible labels, color not sole channel... | [STANDARDS.md](../STANDARDS.md) |
| `REQ-6.3-06` | **hard** | Every output type is verified for correct formatting. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-6.3-07` | **hard** | Every output type is verified for error handling. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-6.3-08` | **hard** | Every output type is verified for edge cases. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-6.3-09` | **hard** | Every output type is verified for cross-environment consistency. | [STANDARDS.md](../STANDARDS.md) |

### Addendum: Continuous Improvement

| REQ-ID | Enforcement | Statement | Source |
|---|---|---|---|
| `REQ-ADD-CI-02` | **hard** | Kaizen event produces a before/after measurement of the target metric. | [docs/addenda/continuous-improvement.md](addenda/continuous-improvement.md) |
| `REQ-ADD-CI-08` | **hard** | No measurement improvement without data. | [docs/addenda/continuous-improvement.md](addenda/continuous-improvement.md) |
| `REQ-ADD-CI-13` | **hard** | The improvement is implemented (not planned) by the end of the event. | [docs/addenda/continuous-improvement.md](addenda/continuous-improvement.md) |
| `REQ-ADD-CI-14` | **hard** | The result (target met or missed, with the actual measured value) is recorded in the lessons-learned registry. | [docs/addenda/continuous-improvement.md](addenda/continuous-improvement.md) |
| `REQ-ADD-CI-15` | *soft* | At least 20 consecutive data points are plotted in chronological order. | [docs/addenda/continuous-improvement.md](addenda/continuous-improvement.md) |
| `REQ-ADD-CI-16` | **hard** | The team has documented in writing whether the current state is special cause (specific cause investigated and recorded)... | [docs/addenda/continuous-improvement.md](addenda/continuous-improvement.md) |
| `REQ-ADD-CI-17` | **hard** | Every user-facing function has at least one failure mode documented. | [docs/addenda/continuous-improvement.md](addenda/continuous-improvement.md) |
| `REQ-ADD-CI-18` | **hard** | All RPN 100+ failure modes have a named owner and a specific action (not "under review"). | [docs/addenda/continuous-improvement.md](addenda/continuous-improvement.md) |
| `REQ-ADD-CI-19` | *soft* | Five work items have been traced and all stages are documented for each. | [docs/addenda/continuous-improvement.md](addenda/continuous-improvement.md) |
| `REQ-ADD-CI-20` | **hard** | Every recurring pattern is matched to a named TIMWOODS category. | [docs/addenda/continuous-improvement.md](addenda/continuous-improvement.md) |
| `REQ-ADD-CI-21` | **hard** | Each top pattern is filed as a work item with a measurable improvement target. | [docs/addenda/continuous-improvement.md](addenda/continuous-improvement.md) |
| `REQ-ADD-CI-22` | **hard** | A single stage is identified as the constraint by name. | [docs/addenda/continuous-improvement.md](addenda/continuous-improvement.md) |
| `REQ-ADD-CI-23` | **hard** | Subordination actions (adjusted WIP limits or prioritization rules) are in place and documented. | [docs/addenda/continuous-improvement.md](addenda/continuous-improvement.md) |
| `REQ-ADD-CI-25` | **hard** | The rope limit is enforced: new pipeline intake is gated on buffer consumption, not on available capacity at the first s... | [docs/addenda/continuous-improvement.md](addenda/continuous-improvement.md) |
| `REQ-ADD-CI-26` | *soft* | Baseline standard deviation of items per deployment is measured over at least 30 deployments and recorded. | [docs/addenda/continuous-improvement.md](addenda/continuous-improvement.md) |
| `REQ-ADD-CI-28` | **hard** | Median and 95th percentile are recorded for all identified setup event types. | [docs/addenda/continuous-improvement.md](addenda/continuous-improvement.md) |
| `REQ-ADD-CI-29` | **hard** | The new baseline is documented in the project's setup documentation or standards-application.md. | [docs/addenda/continuous-improvement.md](addenda/continuous-improvement.md) |
| `REQ-ADD-CI-33` | **hard** | Written observations from direct production log review (not a summary or alert rollup) are recorded with a timestamp. | [docs/addenda/continuous-improvement.md](addenda/continuous-improvement.md) |
| `REQ-ADD-CI-34` | *soft* | Written observations from the last 5 CI/CD pipeline runs are recorded, including stage durations and any manual interven... | [docs/addenda/continuous-improvement.md](addenda/continuous-improvement.md) |
| `REQ-ADD-CI-35` | **hard** | No VSM, Kaizen pre-work, or A3 current-state section has been started before all four observation sets are written. | [docs/addenda/continuous-improvement.md](addenda/continuous-improvement.md) |
| `REQ-ADD-CI-36` | **hard** | Every customer need has at least one Strong or Weak relationship to a tech spec. | [docs/addenda/continuous-improvement.md](addenda/continuous-improvement.md) |
| `REQ-ADD-CI-37` | **hard** | All conflicts between specs are explicitly marked and each conflict has a recorded resolution decision. | [docs/addenda/continuous-improvement.md](addenda/continuous-improvement.md) |
| `REQ-ADD-CI-38` | **hard** | All five columns have named, specific entries with no blanks and no "TBD" values. | [docs/addenda/continuous-improvement.md](addenda/continuous-improvement.md) |
| `REQ-ADD-CI-39` | **hard** | What is outside the Suppliers-to-Customers boundary is stated explicitly in writing and agreed to by the team. | [docs/addenda/continuous-improvement.md](addenda/continuous-improvement.md) |
| `REQ-ADD-CI-62` | **hard** | FMEA derived sections (High-Severity table, RPN Summary, Controls Summary, Review Checklist) are consistent with source ... | [docs/addenda/continuous-improvement.md](addenda/continuous-improvement.md) |
| `REQ-ADD-CI-65` | **hard** | Before a countermeasure to the named bottleneck is implemented, the pre-intervention baseline measurement is recorded (w... | [docs/addenda/continuous-improvement.md](addenda/continuous-improvement.md) |

### Addendum: AI/ML

| REQ-ID | Enforcement | Statement | Source |
|---|---|---|---|
| `REQ-ADD-AI-05` | **hard** | A regression threshold is defined in a committed file before evaluation begins. | [docs/addenda/ai-ml.md](addenda/ai-ml.md) |
| `REQ-ADD-AI-11` | **hard** | CI fails (not warns) when results breach the threshold. | [docs/addenda/ai-ml.md](addenda/ai-ml.md) |
| `REQ-ADD-AI-31` | **hard** | An LLM-generated enforcement gate rule has been evaluated against a minimum of 2 independent labeled sample sets before ... | [docs/addenda/ai-ml.md](addenda/ai-ml.md) |
| `REQ-ADD-AI-32` | **hard** | Each of the 2 required evaluation runs achieves F1 >= 0.85 independently before the rule is promoted from inert to activ... | [docs/addenda/ai-ml.md](addenda/ai-ml.md) |

### Addendum: Multi-Service

| REQ-ID | Enforcement | Statement | Source |
|---|---|---|---|
| `REQ-ADD-MS-02` | **hard** | Every service is independently deployable, independently testable with test doubles, and capable of running against the ... | [docs/addenda/multi-service.md](addenda/multi-service.md) |

### addendum:AAD

| REQ-ID | Enforcement | Statement | Source |
|---|---|---|---|
| `REQ-ADD-AAD-03` | **hard** | No agent-initiated commit lands on a protected branch without a human gate-authority review or a CI gate that encodes th... | [docs/addenda/agent-assisted-development.md](addenda/agent-assisted-development.md) |

### addendum:CI AND type:improvement

| REQ-ID | Enforcement | Statement | Source |
|---|---|---|---|
| `REQ-ADD-CI-03` | **hard** | Improvement claims are verified by process capability measurement: the claimed improvement exceeds normal process variat... | [docs/addenda/continuous-improvement.md](addenda/continuous-improvement.md) |

### type:improvement

| REQ-ID | Enforcement | Statement | Source |
|---|---|---|---|
| `REQ-2.3-20` | **hard** | Improvement work items verify that the measured result exceeds normal process variation before close. | [STANDARDS.md](../STANDARDS.md) |

## Document

*43 requirements.*

### All work items

| REQ-ID | Enforcement | Statement | Source |
|---|---|---|---|
| `REQ-2.1-08` | **hard** | All documentation is written before closing the work item. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-2.1-52` | *soft* | The default effective scope for all requirements is continuous (applies whenever the activity occurs). Requirements that... | [STANDARDS.md](../STANDARDS.md) |
| `REQ-4.1-01` | **hard** | The project maintains a standard directory layout per starters/repo-structure.md so documentation is discoverable withou... | [STANDARDS.md](../STANDARDS.md) |
| `REQ-4.1-02` | **hard** | Every documented artifact created from a template contains every required section from that template, or explicitly docu... | [STANDARDS.md](../STANDARDS.md) |
| `REQ-4.1-03` | **hard** | Template-compliance verification is either automated (a check that runs on every commit or every CI build) or documented... | [STANDARDS.md](../STANDARDS.md) |
| `REQ-4.3-01` | **hard** | Standards, APIs, and actively evolving documents maintain a changelog. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-4.3-02` | **hard** | Each changelog entry includes the version. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-4.3-03` | **hard** | Each changelog entry includes the date. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-4.3-04` | **hard** | Each changelog entry states what changed (which sections, behaviors, or interfaces). | [STANDARDS.md](../STANDARDS.md) |
| `REQ-4.3-05` | **hard** | Each changelog entry states why the change was made. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-4.3-06` | **hard** | Projects that publish versioned releases document a release trigger policy covering (a) what conditions cut a new versio... | [STANDARDS.md](../STANDARDS.md) |
| `REQ-4.4-01` | **hard** | Every document with more than three sections has a table of contents (exception: documents following a fixed template wh... | [STANDARDS.md](../STANDARDS.md) |
| `REQ-4.7-01` | *soft* | A section whose length exceeds a single-sitting read is evaluated for extraction (default calibration: roughly 500 words... | [STANDARDS.md](../STANDARDS.md) |
| `REQ-4.7-02` | *soft* | A document whose length forces search-based rather than scan-based navigation cascades into sub-documents (default calib... | [STANDARDS.md](../STANDARDS.md) |
| `REQ-4.8-01` | **hard** | Every component has a code documentation layer. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-4.8-02` | **hard** | Database layer documents schema with field descriptions. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-4.8-03` | **hard** | Configuration layer documented: every environment variable has purpose, example value, and required-or-optional designat... | [STANDARDS.md](../STANDARDS.md) |
| `REQ-4.8-09` | **hard** | Database layer documents index rationale. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-4.8-10` | **hard** | Database layer documents migration strategy with tested rollback. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-4.8-11` | **hard** | Database layer documents backup policy with RTO and RPO. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-4.8-12` | **hard** | Database layer documents restore test cadence. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-4.8-13` | **hard** | Every component has an operations documentation layer. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-4.8-14` | **hard** | Every component has a configuration documentation layer. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-4.8-15` | **hard** | Every component has a security documentation layer. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-4.8-16` | **hard** | Every component has a network documentation layer. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-4.8-17` | **hard** | Every component has a database documentation layer. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-4.8-18` | **hard** | Documentation across all layers is sufficient for a new person to maintain the component without access to the person wh... | [STANDARDS.md](../STANDARDS.md) |
| `REQ-4.9-12` | **hard** | Requirement statements are first-principles based: they state what must be true without referencing specific tools, prod... | [STANDARDS.md](../STANDARDS.md) |
| `REQ-5.3-01` | **hard** | Cross-repository changes are documented, all affected repositories updated in the same work session, and coordination re... | [STANDARDS.md](../STANDARDS.md) |
| `REQ-5.3-02` | **hard** | Dependent repos are never left inconsistent. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-STR-06` | **hard** | docs/setup.md lists prerequisites (tools, versions, accounts). | [starters/repo-structure.md](../starters/repo-structure.md) |
| `REQ-STR-08` | **hard** | docs/runbook.md exists for every always-on service with all required documentation layers per §4.8. | [starters/repo-structure.md](../starters/repo-structure.md) |
| `REQ-STR-10` | **hard** | The runbook documents the code layer. | [starters/runbook.md](../starters/runbook.md) |
| `REQ-STR-22` | **hard** | The runbook documents the security layer. | [starters/runbook.md](../starters/runbook.md) |
| `REQ-STR-23` | **hard** | The runbook documents the network layer. | [starters/runbook.md](../starters/runbook.md) |
| `REQ-STR-24` | **hard** | The runbook documents the database layer. | [starters/runbook.md](../starters/runbook.md) |
| `REQ-STR-25` | **hard** | The runbook documents the operations layer. | [starters/runbook.md](../starters/runbook.md) |
| `REQ-STR-26` | **hard** | The runbook documents the configuration layer. | [starters/runbook.md](../starters/runbook.md) |
| `REQ-STR-38` | **hard** | docs/setup.md has step-by-step instructions from clone to running. | [starters/repo-structure.md](../starters/repo-structure.md) |
| `REQ-STR-39` | **hard** | docs/setup.md has an environment variable reference. | [starters/repo-structure.md](../starters/repo-structure.md) |
| `REQ-STR-40` | **hard** | docs/setup.md lists common setup failures and solutions. | [starters/repo-structure.md](../starters/repo-structure.md) |

### Addendum: Multi-Service

| REQ-ID | Enforcement | Statement | Source |
|---|---|---|---|
| `REQ-ADD-MS-15` | **hard** | Multi-service architecture docs include contracts exposed and consumed. | [docs/addenda/multi-service.md](addenda/multi-service.md) |
| `REQ-ADD-MS-16` | **hard** | Multi-service architecture docs include failure mode for each consumed service. | [docs/addenda/multi-service.md](addenda/multi-service.md) |

## Deploy

*48 requirements.*

### All work items

| REQ-ID | Enforcement | Statement | Source |
|---|---|---|---|
| `REQ-2.1-09` | **hard** | Rollout strategy is defined before deploying. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-2.1-16` | **hard** | Rollback trigger (specific metric threshold or error condition) is defined before deploying. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-2.1-26` | **hard** | When DEPLOY reveals VERIFY was incomplete, work returns to VERIFY before DEPLOY continues. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-5.10-01` | **hard** | Multi-factor authentication or equivalent is required for operator and admin access. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-5.10-04` | **hard** | No shared accounts and no default credentials exist in any environment. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-5.10-06` | **hard** | All sensitive data is encrypted at rest and in transit (TLS for all network communication). | [STANDARDS.md](../STANDARDS.md) |
| `REQ-5.5-02` | **hard** | Rollback trigger and strategy are pre-defined before any production deployment. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-5.6-01` | **hard** | Infrastructure is version-controlled, reproducible from the repository, and applied through automation. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-5.6-02` | **hard** | The runbook documents steps to restore from total environment loss. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-5.7-01` | **hard** | Every production deployment defines its rollout strategy (full cutover, feature flag, canary, or blue-green) before star... | [STANDARDS.md](../STANDARDS.md) |
| `REQ-5.7-02` | **hard** | Every production deployment defines its rollback trigger (specific metric threshold or error condition) before starting. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-7.1-01` | **hard** | Every always-on service has a health check. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-7.1-04` | **hard** | The health check alerts when silent beyond a defined threshold. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-7.1-05` | **hard** | The health check is functionally meaningful (not just a process ping). | [STANDARDS.md](../STANDARDS.md) |
| `REQ-7.5-01` | **hard** | Every always-on capability defines at least one SLI and SLO. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-7.6-01` | **hard** | Every production service produces correlated traces, metrics, and structured logs. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-8.5-01` | **hard** | The incident communication channel is defined before the first incident occurs. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-8.5-02` | **hard** | User-affecting incidents are communicated with impact and expected resolution timeline. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-STR-07` | **hard** | docs/deployment.md describes how to deploy to each environment. | [starters/repo-structure.md](../starters/repo-structure.md) |
| `REQ-STR-41` | **hard** | docs/deployment.md states what is automated vs manual. | [starters/repo-structure.md](../starters/repo-structure.md) |
| `REQ-STR-42` | **hard** | docs/deployment.md includes rollback procedure with specific steps. | [starters/repo-structure.md](../starters/repo-structure.md) |
| `REQ-STR-43` | **hard** | docs/deployment.md defines the rollback trigger condition. | [starters/repo-structure.md](../starters/repo-structure.md) |

### Addendum: Multi-Team

| REQ-ID | Enforcement | Statement | Source |
|---|---|---|---|
| `REQ-ADD-MT-04` | **hard** | A release coordination plan is distributed before coordinated deployment begins. | [docs/addenda/multi-team.md](addenda/multi-team.md) |
| `REQ-ADD-MT-06` | **hard** | Every service with cross-team consumers documents its current stable version. | [docs/addenda/multi-team.md](addenda/multi-team.md) |
| `REQ-ADD-MT-08` | **hard** | Every service in production has a named on-call owner. | [docs/addenda/multi-team.md](addenda/multi-team.md) |

### Addendum: Web Applications

| REQ-ID | Enforcement | Statement | Source |
|---|---|---|---|
| `REQ-ADD-WEB-04` | **hard** | Content-Security-Policy header is emitted. | [docs/addenda/web-applications.md](addenda/web-applications.md) |
| `REQ-ADD-WEB-07` | **hard** | Verified on every deployment. | [docs/addenda/web-applications.md](addenda/web-applications.md) |
| `REQ-ADD-WEB-36` | **hard** | X-Frame-Options header is emitted. | [docs/addenda/web-applications.md](addenda/web-applications.md) |
| `REQ-ADD-WEB-37` | **hard** | X-Content-Type-Options header is emitted. | [docs/addenda/web-applications.md](addenda/web-applications.md) |
| `REQ-ADD-WEB-38` | **hard** | Strict-Transport-Security (HSTS) header is emitted. | [docs/addenda/web-applications.md](addenda/web-applications.md) |
| `REQ-ADD-WEB-39` | **hard** | Referrer-Policy header is emitted. | [docs/addenda/web-applications.md](addenda/web-applications.md) |

### Addendum: Event-Driven

| REQ-ID | Enforcement | Statement | Source |
|---|---|---|---|
| `REQ-ADD-EVT-06` | **hard** | All broker connections use TLS. | [docs/addenda/event-driven.md](addenda/event-driven.md) |
| `REQ-ADD-EVT-14` | **hard** | Every producer and consumer authenticates. | [docs/addenda/event-driven.md](addenda/event-driven.md) |
| `REQ-ADD-EVT-15` | **hard** | ACLs enforce least-privilege. | [docs/addenda/event-driven.md](addenda/event-driven.md) |
| `REQ-ADD-EVT-16` | **hard** | Credentials rotate on a defined schedule and immediately on suspected compromise. | [docs/addenda/event-driven.md](addenda/event-driven.md) |

### Addendum: Containerized Systems

| REQ-ID | Enforcement | Statement | Source |
|---|---|---|---|
| `REQ-ADD-CTR-02` | **hard** | Liveness probe is configured with documented endpoint, thresholds, and timing. | [docs/addenda/containerized-systems.md](addenda/containerized-systems.md) |
| `REQ-ADD-CTR-03` | **hard** | Resource limits (CPU and memory) are set for every container. | [docs/addenda/containerized-systems.md](addenda/containerized-systems.md) |
| `REQ-ADD-CTR-04` | **hard** | Container runs as non-root user. | [docs/addenda/containerized-systems.md](addenda/containerized-systems.md) |
| `REQ-ADD-CTR-08` | **hard** | Health probes are active before traffic is routed. | [docs/addenda/containerized-systems.md](addenda/containerized-systems.md) |
| `REQ-ADD-CTR-09` | **hard** | Memory request is at least 50% of limit. | [docs/addenda/containerized-systems.md](addenda/containerized-systems.md) |
| `REQ-ADD-CTR-10` | **hard** | CPU request is at least 25% of limit. | [docs/addenda/containerized-systems.md](addenda/containerized-systems.md) |
| `REQ-ADD-CTR-11` | **hard** | All log output is structured (JSON or equivalent machine-parseable format). | [docs/addenda/containerized-systems.md](addenda/containerized-systems.md) |
| `REQ-ADD-CTR-12` | **hard** | Network policy restricts traffic to minimum required (ingress from known sources, egress to known destinations). | [docs/addenda/containerized-systems.md](addenda/containerized-systems.md) |
| `REQ-ADD-CTR-17` | **hard** | Readiness probe is configured with documented endpoint, thresholds, and timing. | [docs/addenda/containerized-systems.md](addenda/containerized-systems.md) |
| `REQ-ADD-CTR-18` | **hard** | Startup probe is configured with documented endpoint, thresholds, and timing. | [docs/addenda/containerized-systems.md](addenda/containerized-systems.md) |
| `REQ-ADD-CTR-19` | **hard** | Container has read-only root filesystem. | [docs/addenda/containerized-systems.md](addenda/containerized-systems.md) |
| `REQ-ADD-CTR-20` | **hard** | All capabilities dropped (add back only what is explicitly required). | [docs/addenda/containerized-systems.md](addenda/containerized-systems.md) |
| `REQ-ADD-CTR-21` | **hard** | No privilege escalation allowed. | [docs/addenda/containerized-systems.md](addenda/containerized-systems.md) |

## Monitor

*10 requirements.*

### All work items

| REQ-ID | Enforcement | Statement | Source |
|---|---|---|---|
| `REQ-2.1-10` | **hard** | The MONITOR answer records the specific alert, dashboard, or detection mechanism in the work item before CLOSE. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-2.1-34` | **hard** | The MONITOR answer records who is notified when the detection mechanism triggers. | [STANDARDS.md](../STANDARDS.md) |

### Addendum: Continuous Improvement

| REQ-ID | Enforcement | Statement | Source |
|---|---|---|---|
| `REQ-ADD-CI-66` | **hard** | After a bottleneck countermeasure lands, re-measurement is scheduled on an event trigger (N completed work items travers... | [docs/addenda/continuous-improvement.md](addenda/continuous-improvement.md) |

### Addendum: AI/ML

| REQ-ID | Enforcement | Statement | Source |
|---|---|---|---|
| `REQ-ADD-AI-07` | **hard** | AI systems monitor output quality metrics. | [docs/addenda/ai-ml.md](addenda/ai-ml.md) |
| `REQ-ADD-AI-25` | **hard** | Data drift between training data and production inputs is monitored with a defined threshold. | [docs/addenda/ai-ml.md](addenda/ai-ml.md) |
| `REQ-ADD-AI-27` | **hard** | AI systems monitor input distribution drift. | [docs/addenda/ai-ml.md](addenda/ai-ml.md) |
| `REQ-ADD-AI-28` | **hard** | AI systems monitor confidence distribution shifts. | [docs/addenda/ai-ml.md](addenda/ai-ml.md) |
| `REQ-ADD-AI-29` | **hard** | AI systems monitor anomalous outputs. | [docs/addenda/ai-ml.md](addenda/ai-ml.md) |

### addendum:AAD

| REQ-ID | Enforcement | Statement | Source |
|---|---|---|---|
| `REQ-ADD-AAD-07` | **hard** | Agents do not hold persistent access to credentials outside an active session. Session-scoped credentials are the defaul... | [docs/addenda/agent-assisted-development.md](addenda/agent-assisted-development.md) |
| `REQ-ADD-AAD-08` | **hard** | A named path exists for revoking agent commit authority within one business day of a trust incident, recorded in the pos... | [docs/addenda/agent-assisted-development.md](addenda/agent-assisted-development.md) |

## Close

*42 requirements.*

### All work items

| REQ-ID | Enforcement | Statement | Source |
|---|---|---|---|
| `REQ-2.1-11` | **hard** | Gate evidence (test output, screenshots, CI result, deployment verification) is attached at CLOSE. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-2.1-39` | **hard** | No work item is closed while its FMEA has above-threshold failure modes with unimplemented controls unless each has a tr... | [STANDARDS.md](../STANDARDS.md) |
| `REQ-2.1-50` | **hard** | When a new section is added to a starter template, the project's corresponding instance document is updated in the same ... | [STANDARDS.md](../STANDARDS.md) |
| `REQ-2.2-05` | **hard** | Closed work item records are accessible to authorized reviewers for the life of the project. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-2.2-07` | **hard** | Projects using a private work item system export closed records to the repository at close time. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-2.2-20` | **hard** | The work item system attaches gate evidence in a reviewable form. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-2.3-01` | **hard** | Acceptance criteria are explicitly verified with observable evidence before close. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-2.3-02` | **hard** | Tests are written and passing per §6.1 test pyramid (unit, integration, system as applicable). | [STANDARDS.md](../STANDARDS.md) |
| `REQ-2.3-03` | **hard** | Documentation is updated before the work item is closed. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-2.3-04` | **hard** | Gate evidence is attached: test output, screenshots, CI pipeline result, deployment verification. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-2.3-05` | **hard** | Monitoring is in place for any change that affects production behavior. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-2.3-06` | **hard** | The change is deployed to the live environment. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-2.3-08` | **hard** | The work item record is accessible to authorized reviewers (public system or exported to repository). | [STANDARDS.md](../STANDARDS.md) |
| `REQ-2.3-10` | **hard** | Type-conditional close requirements for the work item's type are met in addition to the universal DoD checklist. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-2.3-26` | **hard** | A new person can set it up locally without asking anyone using only the documentation. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-2.3-29` | **hard** | A parent work item is not closed until every constituent work item is either closed or explicitly descoped with document... | [STANDARDS.md](../STANDARDS.md) |
| `REQ-2.3-30` | **hard** | Every acceptance criterion is satisfied before close; no partial satisfaction with deferred items is permitted unless ea... | [STANDARDS.md](../STANDARDS.md) |
| `REQ-5.1-06` | **hard** | A future implementor can set up the dev environment using only the documentation. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-5.1-18` | **hard** | A future implementor can understand the change using only the documentation. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-5.1-19` | **hard** | A future implementor can run all tests using only the documentation. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-5.1-20` | **hard** | A future implementor can deploy and verify the change using only the documentation. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-5.1-21` | **hard** | A future implementor knows what monitoring to check using only the documentation. | [STANDARDS.md](../STANDARDS.md) |

### type: bug

| REQ-ID | Enforcement | Statement | Source |
|---|---|---|---|
| `REQ-2.1-36` | **hard** | When a bug recurs, the PFMEA is updated with the process failure that allowed recurrence. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-2.3-14` | **hard** | A regression test is added for every bug fix. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-2.3-16` | **hard** | P0 and P1 bug work items have a post-mortem written before close. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-8.1-01` | **hard** | Every incident is classified per the taxonomy before the post-mortem is written and produces at least one regression cas... | [STANDARDS.md](../STANDARDS.md) |
| `REQ-8.2-01` | **hard** | A post-mortem exists for every P0 and P1 incident. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-8.2-03` | **hard** | The post-mortem identifies the root cause. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-8.3-03` | **hard** | Every post-mortem lesson is added to the lessons-learned registry. | [STANDARDS.md](../STANDARDS.md) |

### type: component

| REQ-ID | Enforcement | Statement | Source |
|---|---|---|---|
| `REQ-2.3-21` | **hard** | Component work items have a completed and reviewed architecture document before close. | [STANDARDS.md](../STANDARDS.md) |

### type: security

| REQ-ID | Enforcement | Statement | Source |
|---|---|---|---|
| `REQ-2.3-11` | **hard** | Security type work items have a completed FMEA before close. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-2.3-12` | **hard** | Security type work items have security regression tests per §6.5 before close. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-2.3-13` | **hard** | Security type work items have a security review per §2.5 before close. | [STANDARDS.md](../STANDARDS.md) |

### Addendum: Continuous Improvement

| REQ-ID | Enforcement | Statement | Source |
|---|---|---|---|
| `REQ-ADD-CI-61` | **hard** | Kaizen events that improve user-facing behavior close the §2.7 feedback loop by notifying affected users. | [docs/addenda/continuous-improvement.md](addenda/continuous-improvement.md) |

### type:countermeasure

| REQ-ID | Enforcement | Statement | Source |
|---|---|---|---|
| `REQ-2.3-24` | **hard** | Countermeasure work items have the source A3 Countermeasures table updated to mark the action closed before close. | [STANDARDS.md](../STANDARDS.md) |

### type:debt

| REQ-ID | Enforcement | Statement | Source |
|---|---|---|---|
| `REQ-2.3-22` | **hard** | Debt work items have the source document (ADR, post-mortem, or code comment) updated to mark debt resolved before close. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-8.6-02` | **hard** | When a debt work item is closed, the source document (ADR, post-mortem, or code comment) is updated with the work item I... | [STANDARDS.md](../STANDARDS.md) |

### type:expedite

| REQ-ID | Enforcement | Statement | Source |
|---|---|---|---|
| `REQ-2.1-45` | **hard** | Expedite work items are not closed until D0 and D1 back-fill documentation is verified complete. | [STANDARDS.md](../STANDARDS.md) |

### type:investigation

| REQ-ID | Enforcement | Statement | Source |
|---|---|---|---|
| `REQ-2.3-17` | **hard** | Investigation work items have a root cause statement documented before close. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-2.3-18` | **hard** | Investigation work items have at least one implementation work item filed before close. | [STANDARDS.md](../STANDARDS.md) |

### type:prevention

| REQ-ID | Enforcement | Statement | Source |
|---|---|---|---|
| `REQ-2.3-23` | **hard** | Prevention work items have the source post-mortem Prevention table updated to mark the action closed before close. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-8.2-11` | **hard** | A prevention work item includes evidence that the implemented action prevents the original failure mode, not just that t... | [STANDARDS.md](../STANDARDS.md) |

## Commit (pre-commit hooks)

*29 requirements.*

### All work items

| REQ-ID | Enforcement | Statement | Source |
|---|---|---|---|
| `REQ-3.2-01` | **hard** | Code and documentation formatting is enforced by automated tooling. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-3.2-02` | **hard** | New compiler warnings fail the build. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-3.2-03` | **hard** | Formatting divergence is rejected by the pre-commit hook. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-3.2-04` | **hard** | Markdown documentation follows the CommonMark specification. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-4.9-03` | **hard** | Every requirement unit is exactly three lines (anchor, tag line, statement). | [STANDARDS.md](../STANDARDS.md) |
| `REQ-4.9-04` | **hard** | Tag positions 1-4 (kind, scope, enforcement, applies-when) are present on every requirement unit. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-4.9-06` | **hard** | The obligation keyword linter scans every prose line for must, required, shall, block, blocks, gate, cannot and emits un... | [STANDARDS.md](../STANDARDS.md) |
| `REQ-4.9-07` | **hard** | No sub-clauses in the statement line. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-4.9-08` | **hard** | Position 5 (eval-scope) is present when kind is gate and absent otherwise. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-5.1-03` | **hard** | Pre-commit checks pass (linting, formatting, type checks) before merge. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-5.1-04` | **hard** | Commit messages are structured and categorized. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-5.1-05` | **hard** | The repository .gitignore excludes build artifacts. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-5.1-10` | **hard** | The body explains why, not what. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-5.1-15` | **hard** | The repository .gitignore excludes OS files and IDE configs. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-5.1-16` | **hard** | The repository .gitignore excludes dependency directories and compiled output. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-5.1-17` | **hard** | The repository .gitignore excludes secret files. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-5.10-05` | **hard** | Secrets are never stored in source control. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-5.5-01` | **hard** | An automated CI pipeline runs on every proposed change before merge. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-5.5-06` | **hard** | Pipeline fails visibly on any error. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-5.5-07` | **hard** | The CI pipeline compiles the code. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-5.5-08` | **hard** | The CI pipeline runs the full test suite. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-5.5-09` | **hard** | The CI pipeline runs a dependency vulnerability scan. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-5.5-10` | **hard** | The CI pipeline runs pre-commit gates. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-6.5-02` | **hard** | Security regression tests are permanent and run on every CI pass. | [STANDARDS.md](../STANDARDS.md) |

### Addendum: Web Applications

| REQ-ID | Enforcement | Statement | Source |
|---|---|---|---|
| `REQ-ADD-WEB-03` | **hard** | An automated accessibility scan runs on every pull request. | [docs/addenda/web-applications.md](addenda/web-applications.md) |
| `REQ-ADD-WEB-06` | **hard** | Automated pass is a gate, not a certification. | [docs/addenda/web-applications.md](addenda/web-applications.md) |

### Addendum: AI/ML

| REQ-ID | Enforcement | Statement | Source |
|---|---|---|---|
| `REQ-ADD-AI-33` | **hard** | The promotion commit for an LLM-generated rule records the F1 score from each of the two required evaluation runs. | [docs/addenda/ai-ml.md](addenda/ai-ml.md) |
| `REQ-ADD-AI-34` | **hard** | The promotion commit for an LLM-generated rule records the labeled set reference used in each evaluation run. | [docs/addenda/ai-ml.md](addenda/ai-ml.md) |
| `REQ-ADD-AI-35` | **hard** | The promotion commit for an LLM-generated rule includes explicit confirmation that the F1 threshold was set before evalu... | [docs/addenda/ai-ml.md](addenda/ai-ml.md) |

## Session Start

*8 requirements.*

### All work items

| REQ-ID | Enforcement | Statement | Source |
|---|---|---|---|
| `REQ-1.4-01` | **hard** | The project's application document contains the scope statement first principle. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-1.4-02` | **hard** | The project's application document contains the source of truth first principle. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-1.4-03` | **hard** | The project's application document contains the verifiability standard first principle. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-1.4-04` | **hard** | The project's application document contains the gate authority first principle. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-1.4-06` | **hard** | The project's application document contains the human approval boundary first principle. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-1.4-07` | **hard** | The project's application document contains the monitoring requirement first principle. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-1.4-08` | **hard** | The project's application document contains the documentation standard first principle. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-STR-17` | **hard** | The project's standards application document contains all 8 first principles. | [starters/standards-application.md](../starters/standards-application.md) |

## Session End

*7 requirements.*

### All work items

| REQ-ID | Enforcement | Statement | Source |
|---|---|---|---|
| `REQ-2.3-07` | **hard** | All relevant repositories are pushed and verified up to date with remote. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-4.6-01` | **hard** | Significant work sessions produce a log. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-4.6-02` | **hard** | The work session log records what was attempted and what succeeded. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-4.6-03` | **hard** | The work session log records what failed. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-4.6-04` | **hard** | The work session log records what is left open with work item IDs. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-4.6-05` | **hard** | The work session log records decisions made. | [STANDARDS.md](../STANDARDS.md) |

### Addendum: Multi-Team

| REQ-ID | Enforcement | Statement | Source |
|---|---|---|---|
| `REQ-ADD-MT-09` | **hard** | Multi-team work sessions record which teams were consulted, what decisions triggered an RFC, what cross-team dependencie... | [docs/addenda/multi-team.md](addenda/multi-team.md) |

## Continuous

*168 requirements.*

### All work items

| REQ-ID | Enforcement | Statement | Source |
|---|---|---|---|
| `REQ-1.5-01` | **hard** | An enforcement tool applying ESE-derived rules to a target repository in a Complicated-domain work session must exempt r... | [STANDARDS.md](../STANDARDS.md) |
| `REQ-1.5-02` | **hard** | Complex-domain work sessions are exempt from externally applied ESE enforcement rules. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-2.1-01` | **hard** | Every work item follows the DISCOVER-DEFINE-DESIGN-BUILD-VERIFY-DOCUMENT-DEPLOY-MONITOR-CLOSE sequence. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-2.1-27` | **hard** | The stage that triggers a re-entry records what was missing in the earlier stage and why the return was necessary. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-2.1-40` | **hard** | Every work period begins by verifying that the prior work period's close obligations were fulfilled: no unfinished deliv... | [STANDARDS.md](../STANDARDS.md) |
| `REQ-2.1-51` | **hard** | The project's own artifacts comply with the standards it has adopted: a compliance review that would fail an adopting pr... | [STANDARDS.md](../STANDARDS.md) |
| `REQ-2.2-19` | **hard** | The work item system maintains lifecycle status. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-2.4-01` | **hard** | Every service in production has a named owner discoverable in the runbook or operations documentation. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-2.4-02` | **hard** | The runbook answers three questions without requiring memory: how to confirm working, how to detect failure, what to do ... | [STANDARDS.md](../STANDARDS.md) |
| `REQ-2.4-03` | **hard** | When ownership transfers, the incoming owner records acceptance in the runbook's named owner field and in the project's ... | [STANDARDS.md](../STANDARDS.md) |
| `REQ-2.5-02` | **hard** | When delivery health metrics worsen for two consecutive review periods (the minimum evidence for a real trend per statis... | [STANDARDS.md](../STANDARDS.md) |
| `REQ-2.5-03` | **hard** | Any recurring manual operational task whose cumulative cost over a reasonable planning horizon exceeds its one-time auto... | [STANDARDS.md](../STANDARDS.md) |
| `REQ-2.6-05` | **hard** | WIP limits are defined and enforced. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-2.7-01` | **hard** | Signal capture format and filing location are defined. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-2.7-02` | **hard** | Intake accumulation channel (where records accumulate before triage) is defined. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-2.7-03` | **hard** | Triage cadence (how frequently intake records are reviewed) is defined. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-2.7-04` | **hard** | Promotion process from intake to §2.2 work items is defined. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-2.7-05` | *soft* | User notification process (how users are informed when feedback is acted on) is defined. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-2.8-01` | *soft* | A visible status shows what is in progress for any work that others depend on. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-2.8-02` | *soft* | A visible status shows what is blocked for any work that others depend on. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-2.8-03` | *soft* | A visible status shows what shipped for any work that others depend on. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-2.8-04` | *soft* | A visible status shows what is next for any work that others depend on. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-4.9-01` | **hard** | Section §4.9 does not exceed 150 lines. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-4.9-05` | **hard** | REQ-IDs are immutable once published under a versioned CHANGELOG heading. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-4.9-09` | **hard** | Deprecated IDs retain their anchor with a deprecated token. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-5.1-01` | **hard** | The primary branch is always deployable. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-5.10-07` | **hard** | Secrets are never stored in logs, screenshots, or crash dumps. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-5.2-02` | **hard** | Dependency licenses are audited at minimum annually. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-5.2-03` | **hard** | No undeclared global tools are required for development or deployment. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-5.5-03` | **hard** | Every passing build on the primary branch is deployable to production. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-7.3-01` | **hard** | Every consequential action is logged with who initiated it. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-7.3-02` | **hard** | Both blocked and permitted actions are logged. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-7.4-01` | **hard** | Four DORA delivery health metrics (deployment frequency, lead time, change failure rate, time to restore) are tracked fo... | [STANDARDS.md](../STANDARDS.md) |
| `REQ-7.5-02` | **hard** | When a service's error budget consumption rate, extrapolated forward, would exhaust the remaining budget before the meas... | [STANDARDS.md](../STANDARDS.md) |
| `REQ-7.7-01` | *soft* | Before drawing conclusions from any metric, the metric definition is confirmed unambiguous. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-7.7-02` | *soft* | Signal is distinguished from noise before responding to metric movement. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-7.7-04` | *soft* | Before drawing conclusions from any metric, the data source is confirmed authoritative. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-7.7-05` | *soft* | Before drawing conclusions from any metric, a calibration test is run. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-8.2-10` | **hard** | Every prevention action in a post-mortem has a tracked work item (type=prevention) that is not closed until the action i... | [STANDARDS.md](../STANDARDS.md) |
| `REQ-8.3-02` | **hard** | The project maintains a lessons-learned registry. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-8.4-01` | **hard** | The project maintains an anti-pattern registry. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-8.4-02` | **hard** | Entries are promoted from lessons-learned when the same pattern appears in 2+ post-mortems, a P0 reveals a systemic fact... | [STANDARDS.md](../STANDARDS.md) |
| `REQ-8.6-01` | **hard** | Acknowledged technical debt is tracked as type=debt work items. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-9.2-01` | **hard** | Every technology decision in active use that lacks a formal ADR has a filed work item for a retroactive ADR. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-9.3-01` | **hard** | A dependency tracking document lists each referenced external standard with version, last review date, and known upcomin... | [STANDARDS.md](../STANDARDS.md) |
| `REQ-9.3-02` | **hard** | Affected practices are updated when a standard changes materially. | [STANDARDS.md](../STANDARDS.md) |
| `REQ-ADO-01` | **hard** | The project pins ESE to a specific version via git submodule. | [docs/adoption.md](adoption.md) |
| `REQ-ADO-02` | **hard** | After every ESE version update, all four steps are completed: read the CHANGELOG, audit all template-based artifacts, ru... | [docs/adoption.md](adoption.md) |
| `REQ-ADO-05` | **hard** | Updates are pulled explicitly, never received automatically. | [docs/adoption.md](adoption.md) |
| `REQ-ADO-06` | *soft* | Adopting this standard positions your engineering processes at approximately CMMI Maturity Level 3 (Defined). | [docs/adoption.md](adoption.md) |
| `REQ-ADO-07` | *soft* | Consult the §2.1 per-stage blocks for when each addendum's requirements activate. | [docs/adoption.md](adoption.md) |
| `REQ-ADO-08` | *soft* | 4. Do not block current work on the reorganization - track it, don't stop for it. | [docs/adoption.md](adoption.md) |
| `REQ-ADO-09` | *soft* | This table answers a different question than the per-stage blocks in §2. | [docs/adoption.md](adoption.md) |
| `REQ-ADO-10` | *soft* | The §2.1 per-stage blocks show exactly where in the lifecycle each CI tool activates. | [docs/adoption.md](adoption.md) |
| `REQ-ADO-11` | *soft* | Beyond initial adoption, these requirements apply continuously. An audit at any point in the project lifecycle must conf... | [docs/adoption.md](adoption.md) |
| `REQ-ADO-12` | *soft* | Edge case 1 - Reclassification mid-lifecycle. If a signal's type or addenda change after the work item is created, re-ru... | [docs/adoption.md](adoption.md) |
| `REQ-ADO-13` | *soft* | Every issue is reviewed against the standards decision log (ADRs) before any change is made to STANDARDS. | [docs/adoption.md](adoption.md) |
| `REQ-ADO-14` | **hard** | Every starter file copied into a project has its placeholder content replaced with project-specific content before the f... | [docs/adoption.md](adoption.md) |
| `REQ-ADO-15` | **hard** | Compliance review is completed at the cadence defined in the project's standards-application document; no compliance rev... | [docs/adoption.md](adoption.md) |
| `REQ-ADO-16` | **hard** | When project scope changes (new technology, new team, new deployment target), applicable addenda are re-evaluated and th... | [docs/adoption.md](adoption.md) |
| `REQ-ADO-17` | **hard** | Every starter file copied into a project has its placeholder content replaced with project-specific content before the f... | [docs/adoption.md](adoption.md) |
| `REQ-ADO-18` | **hard** | Compliance review is completed at the cadence defined in the project's standards-application document; no compliance rev... | [docs/adoption.md](adoption.md) |
| `REQ-ADO-19` | **hard** | When project scope changes (new technology, new team, new deployment target), applicable addenda are re-evaluated and th... | [docs/adoption.md](adoption.md) |
| `REQ-STR-01` | *soft* | Deployment documentation for {Project Name}. Required by §4. | [starters/deployment.md](../starters/deployment.md) |
| `REQ-STR-02` | *soft* | Required by §2.1 (DISCOVER D0/D1) and §2.7. | [starters/intake-log.md](../starters/intake-log.md) |
| `REQ-STR-03` | *soft* | Reference layout for a repository that applies the Excellence Standards - Engineering (ESE). | [starters/repo-structure.md](../starters/repo-structure.md) |
| `REQ-STR-04` | **hard** | README.md states what the project does. | [starters/repo-structure.md](../starters/repo-structure.md) |
| `REQ-STR-05` | *soft* | Required when: the project has versioned releases, external consumers, or is an evolving standard. | [starters/repo-structure.md](../starters/repo-structure.md) |
| `REQ-STR-09` | *soft* | 4. Do not block current work on the reorganization - track it, don't stop for it. | [starters/repo-structure.md](../starters/repo-structure.md) |
| `REQ-STR-11` | *soft* | §4.8: open ports and transport encryption. Per §5.10, TLS required for all external communication. | [starters/runbook.md](../starters/runbook.md) |
| `REQ-STR-12` | *soft* | Database documentation includes schema with field descriptions. | [starters/runbook.md](../starters/runbook.md) |
| `REQ-STR-13` | *soft* | Operations documentation includes how to start the service. | [starters/runbook.md](../starters/runbook.md) |
| `REQ-STR-14` | *soft* | §7.1: health check must be meaningful - a real functional check, not just a process ping. | [starters/runbook.md](../starters/runbook.md) |
| `REQ-STR-15` | *soft* | §7.1, §7.2, §7.6: monitoring must be active before the service is considered production-ready. | [starters/runbook.md](../starters/runbook.md) |
| `REQ-STR-16` | *soft* | Setup documentation for {Project Name}. Required by §4. | [starters/setup.md](../starters/setup.md) |
| `REQ-STR-18` | *soft* | 4. Gate authority - {who or what determines work is done; for ESE-governed repos, ESE compliance is the gate - per §1.4}... | [starters/standards-application.md](../starters/standards-application.md) |
| `REQ-STR-19` | *soft* | §6.2: P0 and P1 gaps block shipping the affected feature. | [starters/standards-application.md](../starters/standards-application.md) |
| `REQ-STR-20` | *soft* | §2.7: every project must define how users report problems, how reports enter the work item system, and how users are not... | [starters/standards-application.md](../starters/standards-application.md) |
| `REQ-STR-21` | *soft* | §8.6: technical debt acknowledged in ADRs, post-mortems, or code comments must be tracked as work items. | [starters/standards-application.md](../starters/standards-application.md) |
| `REQ-STR-27` | *soft* | Database documentation includes migration strategy with tested rollback. | [starters/runbook.md](../starters/runbook.md) |
| `REQ-STR-28` | *soft* | Database documentation includes backup policy with defined RTO and RPO. | [starters/runbook.md](../starters/runbook.md) |
| `REQ-STR-29` | *soft* | Database documentation includes restore test cadence. | [starters/runbook.md](../starters/runbook.md) |
| `REQ-STR-30` | *soft* | Operations documentation includes how to stop the service. | [starters/runbook.md](../starters/runbook.md) |
| `REQ-STR-31` | *soft* | Operations documentation includes how to restart the service. | [starters/runbook.md](../starters/runbook.md) |
| `REQ-STR-32` | *soft* | Operations documentation includes how to check service health. | [starters/runbook.md](../starters/runbook.md) |
| `REQ-STR-33` | *soft* | Operations documentation includes how to debug the service. | [starters/runbook.md](../starters/runbook.md) |
| `REQ-STR-34` | **hard** | README.md states who maintains it. | [starters/repo-structure.md](../starters/repo-structure.md) |
| `REQ-STR-35` | **hard** | README.md states how to run locally. | [starters/repo-structure.md](../starters/repo-structure.md) |
| `REQ-STR-36` | **hard** | README.md states where documentation lives. | [starters/repo-structure.md](../starters/repo-structure.md) |
| `REQ-STR-37` | **hard** | README.md states current status. | [starters/repo-structure.md](../starters/repo-structure.md) |
| `REQ-STR-44` | **hard** | The standards application document contains a named owner section. | [starters/standards-application.md](../starters/standards-application.md) |
| `REQ-STR-45` | **hard** | The standards application document contains a component architecture backlog. | [starters/standards-application.md](../starters/standards-application.md) |
| `REQ-STR-46` | **hard** | The standards application document contains a service health status section. | [starters/standards-application.md](../starters/standards-application.md) |
| `REQ-STR-47` | **hard** | The standards application document contains SLO definitions. | [starters/standards-application.md](../starters/standards-application.md) |
| `REQ-STR-48` | **hard** | The standards application document contains delivery health metrics. | [starters/standards-application.md](../starters/standards-application.md) |
| `REQ-STR-49` | **hard** | The standards application document contains a testing gap table. | [starters/standards-application.md](../starters/standards-application.md) |
| `REQ-STR-50` | **hard** | The standards application document contains applicable addenda identification. | [starters/standards-application.md](../starters/standards-application.md) |
| `REQ-STR-51` | **hard** | The standards application document contains a compliance review cadence. | [starters/standards-application.md](../starters/standards-application.md) |
| `REQ-STR-52` | **hard** | The standards application document contains a new person readiness check. | [starters/standards-application.md](../starters/standards-application.md) |
| `REQ-STR-53` | **hard** | The project's FMEA RPN threshold and severity threshold are documented. | [starters/standards-application.md](../starters/standards-application.md) |
| `REQ-TPL-01` | *soft* | Each countermeasure must have a §2.2 work item (type=countermeasure) with discovered-from pointing to this A3 document p... | [templates/a3.md](../templates/a3.md) |
| `REQ-TPL-02` | *soft* | {List the steps required to execute the countermeasures above. Include any dependencies.}. | [templates/a3.md](../templates/a3.md) |
| `REQ-TPL-03` | *soft* | Architectural Decision Record. Required by §4.2 for any change that introduces a new component, replaces an existing app... | [templates/adr.md](../templates/adr.md) |
| `REQ-TPL-04` | *soft* | §4.2: every rejected alternative must have a documented rejection rationale. This prevents re-evaluating the same option... | [templates/adr.md](../templates/adr.md) |
| `REQ-TPL-05` | *soft* | §4.2: what observable signal confirms this decision was correct, and what triggers the assessment? Criteria must be bina... | [templates/adr.md](../templates/adr.md) |
| `REQ-TPL-06` | *soft* | FMEA required: {yes / no}. | [templates/adr.md](../templates/adr.md) |
| `REQ-TPL-07` | *soft* | Pre-BUILD controls (must be passing before implementation begins):. | [templates/adr.md](../templates/adr.md) |
| `REQ-TPL-08` | *soft* | Required by §3.1 for every system component. Required before any significant change to this component - per §3. | [templates/architecture-doc.md](../templates/architecture-doc.md) |
| `REQ-TPL-13` | *soft* | If this component touches authentication, payments, data mutation, or external integrations, FMEA is required per §2. | [templates/architecture-doc.md](../templates/architecture-doc.md) |
| `REQ-TPL-14` | *soft* | §5.10: required for any component that stores or processes sensitive data, handles authentication, or exposes external e... | [templates/architecture-doc.md](../templates/architecture-doc.md) |
| `REQ-TPL-15` | *soft* | Starting from the primary undesired top event (service outage, SLO breach, or data loss), work down through AND/OR logic... | [templates/architecture-doc.md](../templates/architecture-doc.md) |
| `REQ-TPL-16` | *soft* | Design changes or additional controls required before BUILD: {list mitigations for identified single points of failure}. | [templates/architecture-doc.md](../templates/architecture-doc.md) |
| `REQ-TPL-17` | *soft* | Combined availability (series components): {calculated as product of individual uptimes for required components}. | [templates/architecture-doc.md](../templates/architecture-doc.md) |
| `REQ-TPL-18` | *soft* | §3.1: required where the component has explicit non-functional commitments. | [templates/architecture-doc.md](../templates/architecture-doc.md) |
| `REQ-TPL-19` | *soft* | §3.1: required if this component surfaces text to users. See W3C Internationalization. | [templates/architecture-doc.md](../templates/architecture-doc.md) |
| `REQ-TPL-20` | *soft* | Capabilities document for {Feature or Product Name}. | [templates/capabilities.md](../templates/capabilities.md) |
| `REQ-TPL-21` | *soft* | What constraints cannot change?. | [templates/capabilities.md](../templates/capabilities.md) |
| `REQ-TPL-22` | *soft* | §1.4 gate authority: capabilities must be approved before a PRD is written. | [templates/capabilities.md](../templates/capabilities.md) |
| `REQ-TPL-23` | *soft* | Per-stage requirements are documented in the §2.1 per-stage blocks. | [templates/compliance-review.md](../templates/compliance-review.md) |
| `REQ-TPL-24` | *soft* | Gate authority sign-off is blocked until all gaps in the New Gaps Found table have a filed work item ID and the Document... | [templates/compliance-review.md](../templates/compliance-review.md) |
| `REQ-TPL-26` | *soft* | Required by §2.2 for work items with type=investigation. | [templates/investigation.md](../templates/investigation.md) |
| `REQ-TPL-27` | *soft* | Document each piece of evidence with its source. Per §2.1 DISCOVER: evidence required. | [templates/investigation.md](../templates/investigation.md) |
| `REQ-TPL-28` | *soft* | Required before close. Per §2.2: when root cause is unknown, the investigation's deliverable IS root cause identificatio... | [templates/investigation.md](../templates/investigation.md) |
| `REQ-TPL-29` | *soft* | Required before close: at least one implementation work item must be filed with discovered-from pointing to this investi... | [templates/investigation.md](../templates/investigation.md) |
| `REQ-TPL-30` | *soft* | Required by §8.2 for every P0 and P1 incident. P2 at team discretion. | [templates/post-mortem.md](../templates/post-mortem.md) |
| `REQ-TPL-31` | *soft* | §8.1: every incident must produce one or more regression cases that would have caught it earlier. | [templates/post-mortem.md](../templates/post-mortem.md) |
| `REQ-TPL-32` | *soft* | §8.2: each action must become a §2.2-compliant work item with type=prevention and discovered-from pointing to this post-... | [templates/post-mortem.md](../templates/post-mortem.md) |
| `REQ-TPL-33` | *soft* | Complete this section if the incident involved data exposure, credential misuse, or unauthorized access - required by §8... | [templates/post-mortem.md](../templates/post-mortem.md) |
| `REQ-TPL-35` | *soft* | Must - blocking; feature cannot ship without it. | [templates/prd.md](../templates/prd.md) |
| `REQ-TPL-36` | *soft* | §6.3: every output type must be verified. §5.10: security controls required for any feature handling sensitive data or a... | [templates/prd.md](../templates/prd.md) |
| `REQ-TPL-37` | *soft* | §2.7: define before shipping. A system that cannot receive feedback from its users cannot improve. | [templates/prd.md](../templates/prd.md) |
| `REQ-TPL-38` | *soft* | Before writing: verify every applicable section below against the standard. | [templates/prd.md](../templates/prd.md) |
| `REQ-TPL-39` | *soft* | §2.8: stakeholders waiting on this work must be able to determine current status without asking directly. | [templates/prd.md](../templates/prd.md) |
| `REQ-TPL-40` | *soft* | §1.4 gate authority: the PRD requires explicit approval before implementation begins. | [templates/prd.md](../templates/prd.md) |
| `REQ-TPL-41` | *soft* | Prerequisite: All always-on availability requirements (N-x rows) must have linked SLO definitions before approval. | [templates/prd.md](../templates/prd.md) |
| `REQ-TPL-42` | *soft* | Full depth (§1.2 Step 1 for complex products): Complete all sections. | [templates/problem-research.md](../templates/problem-research.md) |
| `REQ-TPL-43` | *soft* | §2.1 DISCOVER: evidence required. Anecdote is weak evidence; frequency data, user sessions, and support tickets are stro... | [templates/problem-research.md](../templates/problem-research.md) |
| `REQ-TPL-44` | *soft* | What constraints cannot change?. | [templates/problem-research.md](../templates/problem-research.md) |
| `REQ-TPL-45` | *soft* | Service Level Objective definition for {Capability Name}. | [templates/slo.md](../templates/slo.md) |
| `REQ-TPL-46` | *soft* | §7.5: the SLI must be user-centered - it measures what the user experiences, not what the system does internally. | [templates/slo.md](../templates/slo.md) |
| `REQ-TPL-47` | *soft* | §7.5: actions must be pre-defined. Discovering the response during an incident compounds the problem. | [templates/slo.md](../templates/slo.md) |
| `REQ-TPL-48` | *soft* | Required by §9.1 before adopting any new technology, framework, or external service. | [templates/tech-eval.md](../templates/tech-eval.md) |
| `REQ-TPL-49` | *soft* | Security exposure - does it process sensitive data? What attack surface does it add? Per §5. | [templates/tech-eval.md](../templates/tech-eval.md) |
| `REQ-TPL-50` | *soft* | §9.1: an ADR is required for every Proceed decision - before integration begins. Per §4.2. | [templates/tech-eval.md](../templates/tech-eval.md) |
| `REQ-TPL-51` | *soft* | ADR required: templates/adr.md*. | [templates/tech-eval.md](../templates/tech-eval.md) |
| `REQ-TPL-52` | *soft* | Required by ADR-019 for projects using a private work item system. | [templates/work-item-export.md](../templates/work-item-export.md) |
| `REQ-TPL-53` | *soft* | Required by §2.2 for every work item entering the delivery system. | [templates/work-item.md](../templates/work-item.md) |
| `REQ-TPL-54` | *soft* | §2.2: all 8 fields are required at creation. A work item missing any attribute is not ready to enter the delivery system... | [templates/work-item.md](../templates/work-item.md) |
| `REQ-TPL-55` | *soft* | §2.2 root cause identification: a work item must either address a root cause directly or identify itself as a symptom fi... | [templates/work-item.md](../templates/work-item.md) |
| `REQ-TPL-56` | *soft* | §2.1 VERIFY: record what was specifically verified and the result. Required before CLOSE. | [templates/work-item.md](../templates/work-item.md) |
| `REQ-TPL-57` | *soft* | §2.1 MONITOR: "How will we know if this breaks in 30 days?" Required before CLOSE. | [templates/work-item.md](../templates/work-item.md) |
| `REQ-TPL-58` | *soft* | §2.2 and §2.3: complete the section matching this work item's type. These are required in addition to the universal DoD ... | [templates/work-item.md](../templates/work-item.md) |
| `REQ-TPL-59` | *soft* | [ ] Security review completed (§2.5). | [templates/work-item.md](../templates/work-item.md) |
| `REQ-TPL-60` | *soft* | [ ] Gate evidence attached (above). | [templates/work-item.md](../templates/work-item.md) |
| `REQ-TPL-61` | *soft* | Required by §4.6 for significant work sessions. The log is how future sessions resume context without re-discovering pri... | [templates/work-session-log.md](../templates/work-session-log.md) |
| `REQ-TPL-62` | *soft* | §2.3: every open item must have a §2.2-compliant work item ID. | [templates/work-session-log.md](../templates/work-session-log.md) |
| `REQ-TPL-63` | *soft* | §4.6: one paragraph - current state, what to do first, any blockers. The next session must be able to resume without ask... | [templates/work-session-log.md](../templates/work-session-log.md) |
| `REQ-TPL-64` | *soft* | §4.2: every significant decision about this component must have an ADR. List them here for discoverability. | [templates/architecture-doc.md](../templates/architecture-doc.md) |
| `REQ-TPL-65` | *soft* | §1.1: define before starting - not after the first incident. Per §5.7: rollback trigger must be pre-defined. | [templates/prd.md](../templates/prd.md) |

### Addendum: Continuous Improvement

| REQ-ID | Enforcement | Statement | Source |
|---|---|---|---|
| `REQ-STR-54` | *soft* | Archive convention for value stream maps supporting improvement work items. Required by [§2.6](../STANDARDS.md#26-delive... | [starters/vsm.md](../starters/vsm.md) |
| `REQ-TPL-66` | *soft* | Value stream map archives the current-state baseline for a delivery process before improvement work begins. | [templates/vsm.md](../templates/vsm.md) |
| `REQ-TPL-67` | *soft* | The improvement arc and the trigger that motivated the map are stated before measurement begins. | [templates/vsm.md](../templates/vsm.md) |
| `REQ-TPL-68` | *soft* | Observations are sourced from at least 10 completed work items with the measurement method named per item. | [templates/vsm.md](../templates/vsm.md) |
| `REQ-TPL-69` | *soft* | The three largest wait times are identified with stage name, measured duration, and the evidence that the stage binds th... | [templates/vsm.md](../templates/vsm.md) |

### Addendum: Multi-Team

| REQ-ID | Enforcement | Statement | Source |
|---|---|---|---|
| `REQ-ADD-MT-02` | **hard** | Dependent teams have a documented working agreement. | [docs/addenda/multi-team.md](addenda/multi-team.md) |
| `REQ-ADD-MT-05` | **hard** | Reviewed at least quarterly. | [docs/addenda/multi-team.md](addenda/multi-team.md) |

### Addendum: AI/ML

| REQ-ID | Enforcement | Statement | Source |
|---|---|---|---|
| `REQ-ADD-AI-12` | *soft* | Match explanation rigor to the autonomy level defined in Autonomy Boundaries: Informational models carry a lower explana... | [docs/addenda/ai-ml.md](addenda/ai-ml.md) |

### Addendum: Containerized Systems

| REQ-ID | Enforcement | Statement | Source |
|---|---|---|---|
| `REQ-ADD-CTR-15` | *soft* | Allow only the traffic required (ingress from known sources, egress to known destinations). | [docs/addenda/containerized-systems.md](addenda/containerized-systems.md) |

