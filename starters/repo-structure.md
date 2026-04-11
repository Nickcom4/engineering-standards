---
type: starter
purpose: "Standard directory layout for a project repository"
frequency: one-time
---

# Repo Structure: {Project Name}

<a name="REQ-STR-03"></a>
**REQ-STR-03** `advisory` `continuous` `soft` `all`
Reference layout for a repository that applies the Excellence Standards - Engineering (ESE).

> Reference layout for a repository that applies the [Excellence Standards - Engineering (ESE)](../STANDARDS.md). Use this when setting up a new project or auditing an existing one. Not every directory is required for every project - mark what does not apply and why in your [standards application document](standards-application.md). The purpose of this layout is to make documentation discoverable without asking the author.

---

## Table of Contents

- [Directory Layout](#directory-layout)
- [File Purposes](#file-purposes)
- [Naming Conventions](#naming-conventions)
- [Adoption Checklist](#adoption-checklist)
- [Applying to Pre-Existing Repos](#applying-to-pre-existing-repos)

---

## Directory Layout

```
{project-name}/
├── README.md                        # What this is, how to run it, where everything lives
├── CHANGELOG.md                     # Version history - required for standards, APIs, evolving docs
├── .gitignore                       # Build artifacts, secrets, OS/IDE files, compiled output
│
├── docs/
│   ├── archive/                     # Superseded documents - see ADR-010
│   │   └── {original-name}-archived-{YYYY-MM-DD}.md
│   ├── decisions/                   # Architectural Decision Records (ADRs)
│   │   └── ADR-001-{title}.md       # One file per decision - see templates/adr.md
│   ├── setup.md                     # How to install, configure, and run locally from scratch
│   ├── deployment.md                # How to deploy to each environment; rollback procedure
│   ├── runbook.md                   # How to operate, monitor, and debug - see starters/runbook.md
│   ├── standards-application.md     # ESE application doc for this project - see starters/standards-application.md
│   └── addenda/                     # Project-specific ESE extensions (regulated contexts, etc.)
│
├── docs/product/                    # Product development artifacts (§1.2 progression)
│   ├── problem-research/            # Step 1 - see templates/problem-research.md
│   ├── capabilities/                # Step 2 - see templates/capabilities.md
│   └── prd/                         # Step 3 - see templates/prd.md
│
├── docs/architecture/               # Component architecture documents
│   └── {component-name}.md          # One file per component - see templates/architecture-doc.md
│
├── docs/incidents/                  # Post-mortems and lessons learned
│   ├── post-mortems/                # One file per incident - see templates/post-mortem.md
│   ├── lessons-learned.md           # Running registry - see starters/lessons-learned-registry.md
│   └── anti-patterns.md             # Named patterns that consistently fail - see starters/anti-pattern-registry.md
│
├── docs/work-sessions/              # Session logs - see templates/work-session-log.md
│   └── YYYY-MM-DD-{topic}.md
│
├── {source}/                        # Language-appropriate source directory (lib/, src/, app/, etc.)
│
├── test/                            # Tests - unit, integration, system, regression
│
└── .github/ (or equivalent CI)      # CI pipeline configuration
    └── workflows/
```

---

## File Purposes

<a name="REQ-STR-04"></a>
**REQ-STR-04** `artifact` `continuous` `hard` `all`
README.md states what the project does.

<a name="REQ-STR-34"></a>
**REQ-STR-34** `artifact` `continuous` `hard` `all`
README.md states who maintains it.

<a name="REQ-STR-35"></a>
**REQ-STR-35** `artifact` `continuous` `hard` `all`
README.md states how to run locally.

<a name="REQ-STR-36"></a>
**REQ-STR-36** `artifact` `continuous` `hard` `all`
README.md states where documentation lives.

<a name="REQ-STR-37"></a>
**REQ-STR-37** `artifact` `continuous` `hard` `all`
README.md states current status.

### README.md

Required content:
- What this project does (one paragraph)
- Who maintains it and how to reach them
- How to run it locally (or a link to `docs/setup.md`)
- Where key documentation lives
- Current status (active development / maintenance mode / deprecated)

### CHANGELOG.md

<a name="REQ-STR-05"></a>
**REQ-STR-05** `advisory` `continuous` `soft` `all`
Required when: the project has versioned releases, external consumers, or is an evolving standard.

Required when: the project has versioned releases, external consumers, or is an evolving standard.
Not required when: the project is a one-time script or stable internal tool with no consumers.

Format: newest entry first. Per [§4.3](../STANDARDS.md#43-changelogs).

### docs/archive/

Superseded documents. When a document is replaced by a newer version, move it here using the naming convention `{original-name}-archived-{YYYY-MM-DD}.md`. Add the three-field frontmatter schema:

```yaml
status: archived
superseded-by: {relative path to the active document}
date-archived: {YYYY-MM-DD}
```

Update all cross-references to point to the new active document. Per ADR-010.

### docs/decisions/

One ADR per significant decision. Decisions that belong here: new components, replaced approaches, new external dependencies, changes to service communication. Per [§4.2](../STANDARDS.md#42-adr-format).

Name format: `{PREFIX}-{id}-{kebab-case-title}.md`. Prefix ADRs with `ADR-`, FMEAs with `FMEA-`, technology evaluations with `EVAL-`. The numbering scheme is date-based. See [Naming Conventions](#naming-conventions) below.

Status field: `Proposed | Accepted | Superseded by ADR-NNN`

<a name="REQ-STR-06"></a>
**REQ-STR-06** `artifact` `document` `hard` `all`
docs/setup.md lists prerequisites (tools, versions, accounts).

<a name="REQ-STR-38"></a>
**REQ-STR-38** `artifact` `document` `hard` `all`
docs/setup.md has step-by-step instructions from clone to running.

<a name="REQ-STR-39"></a>
**REQ-STR-39** `artifact` `document` `hard` `all`
docs/setup.md has an environment variable reference.

<a name="REQ-STR-40"></a>
**REQ-STR-40** `artifact` `document` `hard` `all`
docs/setup.md lists common setup failures and solutions.

### docs/setup.md

Required content:
- Prerequisites (tools, versions, accounts)
- Step-by-step from clone to running locally
- Environment variable reference (every variable: purpose, example, required/optional)
- Common setup failures and how to resolve them

<a name="REQ-STR-07"></a>
**REQ-STR-07** `artifact` `deploy` `hard` `all`
docs/deployment.md describes how to deploy to each environment.

<a name="REQ-STR-41"></a>
**REQ-STR-41** `artifact` `deploy` `hard` `all`
docs/deployment.md states what is automated vs manual.

<a name="REQ-STR-42"></a>
**REQ-STR-42** `artifact` `deploy` `hard` `all`
docs/deployment.md includes rollback procedure with specific steps.

<a name="REQ-STR-43"></a>
**REQ-STR-43** `artifact` `deploy` `hard` `all`
docs/deployment.md defines the rollback trigger condition.

### docs/deployment.md

Required content:
- How to deploy to each environment (staging, production)
- What automated steps run vs. what requires human action
- Rollback procedure - specific steps, not "revert the change"
- Rollback trigger - the condition that requires rollback (per [§5.7](../STANDARDS.md#57-deployment-strategies-and-release-safety))

<a name="REQ-STR-08"></a>
**REQ-STR-08** `artifact` `document` `hard` `all`
docs/runbook.md exists for every always-on service with all required documentation layers per §4.8.

### docs/runbook.md

Required for always-on services. Per [§4.8](../STANDARDS.md#48-documentation-layers).
Template: [starters/runbook.md](runbook.md).

### docs/standards-application.md

How this project applies ESE: current state, gaps, project-specific constraints.
Template: [starters/standards-application.md](standards-application.md).

### docs/product/

Product development artifacts produced during the [§1.2 Document Progression](../STANDARDS.md#12-document-progression):
- `problem-research/` - evidence the problem is real (Step 1)
- `capabilities/` - what users will be able to do (Step 2)
- `prd/` - requirements, scope, acceptance criteria (Step 3)

Architecture and implementation artifacts live in `docs/decisions/` and `docs/architecture/` (Steps 4-5).

---

## Naming Conventions

All artifact filenames: kebab-case, ISO 8601 date prefix (for dated artifacts), `.md` extension, typed prefix on artifacts sharing a directory.

### Numbering scheme

The typed prefix and kebab-case title are universal. The numbering scheme is a **project decision** documented in `docs/standards-application.md`.

| Scheme | Format | Notes |
|---|---|---|
| **Date-based** (sole convention) | `{PREFIX}-YYYY-MM-DD-{title}.md` | Solo or distributed teams; scales without coordination or migration. Sorts chronologically. |
| ~~Sequential~~ (deprecated) | `{PREFIX}-NNN-{title}.md` | Do not use for new projects. Requires central number assignment; incurs migration cost if the team grows or becomes distributed. Existing projects that already use sequential may retain it. |

### Per-directory conventions

| Directory | Convention | Example |
|---|---|---|
| `docs/decisions/` ADRs | `ADR-{id}-{title}.md` | `ADR-2026-03-24-section-order.md` |
| `docs/decisions/` FMEAs | `FMEA-{id}-{title}.md` | `FMEA-2026-03-24-payment-tokens.md` |
| `docs/decisions/` evaluations | `EVAL-{id}-{title}.md` | `EVAL-2026-03-24-message-broker.md` |
| `docs/architecture/` | `{component-name}.md` | `api-gateway.md` |
| `docs/product/` subdirs | `{product-or-feature}.md` | `notification-system.md` |
| `docs/incidents/post-mortems/` | `YYYY-MM-DD-{title}.md` | `2026-03-15-payment-api-timeout.md` |
| `docs/incidents/` A3s | `A3-YYYY-MM-DD-{title}.md` | `A3-2026-03-20-deployment-bottleneck.md` |
| `docs/incidents/` registries | Fixed: `lessons-learned.md`, `anti-patterns.md` | |
| `docs/work-sessions/` | `YYYY-MM-DD-{topic}.md` | `2026-03-24-deep-audit.md` |
| `docs/archive/` | `{original-name}-archived-YYYY-MM-DD.md` | `capabilities-v1-archived-2026-03-20.md` |
| `docs/` compliance reviews | `compliance-review-YYYY-MM-DD.md` | |
| `docs/` intake log | `intake-log.md` | Non-tracked-system projects only |

### Conditional directories (create only when applicable)

| Directory | When to create |
|---|---|
| `docs/work-items/` | When using ADR-019 private-system exports |
| `docs/intake-log.md` | When not using a compliant tracked work item system |
| `docs/compliance-review-YYYY-MM-DD.md` | At periodic review cadence |
| `docs/slos/` | When SLO volume exceeds what fits in `docs/runbook.md` |
| `docs/reviews/` | When compliance review volume exceeds 3 files |

---

## Adoption Checklist

For new projects, complete each item before the first production deployment.
For pre-existing projects, track gaps in `docs/standards-application.md`.

### Minimum at Project Start

- [ ] `README.md` - what it is, how to run it
- [ ] `.gitignore` - excludes build artifacts, secrets, OS/IDE files
- [ ] `docs/setup.md` - clone to running in under 15 minutes without asking anyone
- [ ] `docs/decisions/` directory created (even if empty)
- [ ] `docs/standards-application.md` - gaps tracked, not assumed to not exist
- [ ] **Naming scheme confirmed** - date-based (the sole convention); documented in `docs/standards-application.md`
- [ ] **Intake channel defined** - where signals are captured (§2.7 element 1-2); see [starters/intake-log.md](intake-log.md) if no tracked system
- [ ] **Triage cadence defined** - how often intake records are reviewed (§2.7 element 3); documented in `docs/standards-application.md`

### Required Before First Production Deployment

- [ ] `docs/deployment.md` - deployment procedure and rollback
- [ ] `docs/runbook.md` - how to operate and debug (for always-on services)
- [ ] At least one ADR for every significant architectural decision made to date
- [ ] Monitoring configured and noted in the application doc

### Required Before Handing Off

- [ ] `docs/incidents/lessons-learned.md` - any lessons from development or early operation
- [ ] All ADRs accepted and linked from the component they govern
- [ ] New person readiness test passed - per [§2.3](../STANDARDS.md#23-definition-of-done)

---

## Applying to Pre-Existing Repos

Do not reorganize a working repo in one pass. File a work item for the structure gap and resolve incrementally:

1. Create `docs/standards-application.md` from the template - this is the gap tracker
2. Add the missing files in priority order: `README.md` → `docs/setup.md` → `docs/decisions/` → `docs/runbook.md`
3. Retroactive ADRs for decisions already made - per [§9.2](../STANDARDS.md#92-technology-adr-backlog)
<a name="REQ-STR-09"></a>
**REQ-STR-09** `advisory` `continuous` `soft` `all`
4. Do not block current work on the reorganization - track it, don't stop for it.

4. Do not block current work on the reorganization - track it, don't stop for it

---

*ESE reference: [§4.1 What Must Be Documented](../STANDARDS.md#41-what-must-be-documented), [§4.3 Changelogs](../STANDARDS.md#43-changelogs), [§4.8 Documentation Layers](../STANDARDS.md#48-documentation-layers)*
