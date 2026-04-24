# Excellence Standards - Engineering

A practical, universal engineering standard for software projects. Domain-agnostic, stack-agnostic, team-size-agnostic.

**Maintained by:** Nick Baker ([GitHub repo owner](https://github.com/Nickcom4/engineering-standards))
**Status:** Active development

## Table of Contents

- [What This Is](#what-this-is)
- [What This Is Not](#what-this-is-not)
- [How to Adopt](#how-to-adopt)
- [Structure](#structure)
- [Versioning](#versioning)
- [Contributing](#contributing)

## What This Is

Gates and practices that apply to all software work: how to scope it, how to build it, how to document it, how to deploy it, how to monitor it, how to learn from failure, and how to hand it off.

These are not aspirational guidelines. They are gates that block progress when violated.

## What This Is Not

- A tutorial or getting-started guide
- A technology-specific standard (for any particular stack)
- A project management methodology
- An ISO certification (but built to ISO-equivalent rigor for self-verification)

## How to Adopt

See [docs/adoption.md](docs/adoption.md) for full setup instructions (submodule, first steps, what your project produces).

**Fastest path:** clone [ese-starter](https://github.com/Nickcom4/ese-starter), a turnkey scaffold that ships this repo as a pinned submodule at `.standards/`, all eight vendored drift-detection linters, the scaffolding and verification tools, pre-commit hook, CI workflow, and Dependabot configuration for automatic submodule bumps. See the starter's README for the bootstrap ritual.

**Incremental path** (for projects that already exist):
1. Add this repo as a git submodule at `.standards/`
2. Read [STANDARDS.md](STANDARDS.md)
3. Create your `docs/standards-application.md` from the [template](starters/standards-application.md) and fill in the YAML applicability frontmatter
4. Identify which [addenda](docs/addenda/) apply
5. Vendor the adopter-facing linters and tools from the [ese-starter](https://github.com/Nickcom4/ese-starter) repository (canonical per [ADR-2026-04-24](docs/decisions/ADR-2026-04-24-ese-code-canonicalization-ese-starter-as-single-source-for-adopter-facing-executable-code.md))

**Migrating from an older partial adoption:** see [docs/migrating-from-partial-adoption.md](docs/migrating-from-partial-adoption.md).

## Structure

```
STANDARDS.md                           The standard (9 sections)
CHANGELOG.md                           Version history
CLAUDE.md                              Agent context for AI-assisted sessions (ESE compliance)
dependencies.md                        Versioned external standards referenced
.github/
  workflows/ci.yml                     CI pipeline (35 checks)
scripts/                               CI validation scripts and git hooks
docs/
  adoption.md                          Adoption guide and operational reference
  migrating-from-partial-adoption.md   Migration guide for projects at intermediate adoption states
  background.md                        Research corpus: why each section exists
  requirement-index.md                 Requirements organized by lifecycle scope and applies-when
  standards-application.md             This repo applying its own standard to itself
  section-anchors-baseline.txt         Heading anchor baseline for CI validation
  deployment.md                        ESE repo deployment procedure
  setup.md                             ESE repo setup instructions
  addenda/                             First-party extensions for specific contexts
    ai-ml.md                           AI and ML systems
    web-applications.md                Web applications
    event-driven.md                    Event-driven systems
    multi-service.md                   Multi-service architectures
    multi-team.md                      Multi-team organizations
    containerized-systems.md           Containerized and orchestrated systems
    continuous-improvement.md          Continuous improvement
  architecture/                        Component architecture documents
  archive/                             Superseded documents (retained for history)
  decisions/                           ADRs and FMEAs for structural decisions
  incidents/                           Lessons learned and anti-patterns
  product/                             Product documents (PRDs, capabilities, research)
  work-items/                          Exported work item records (ADR-019)
templates/                             16 reusable templates; create many instances throughout project lifecycle
  adr.md                               Architectural decision record
  a3.md                                A3 structured problem solving
  architecture-doc.md                  Component architecture document
  capabilities.md                      User capabilities definition
  compliance-review.md                 Periodic internal audit
  fmea.md                              Failure Mode and Effects Analysis
  investigation.md                     Investigation work item (root cause, implementation items)
  post-mortem.md                       Incident post-mortem
  prd.md                               Product requirements document
  problem-research.md                  Problem discovery research (also DISCOVER D2 abbreviated)
  slo.md                               Service level objectives
  tech-eval.md                         Technology evaluation
  vsm.md                               Value stream map (baseline archive per REQ-ADD-CI-01)
  work-item.md                         Work item (8 required attributes, lifecycle fields)
  work-item-export.md                  Work item export for private-system teams (ADR-019)
  work-session-log.md                  Work session log
starters/                              9 one-time adoption files; copy once at adoption, then maintain
  standards-application.md             Project compliance tracker
  repo-structure.md                    Reference directory layout and naming conventions
  deployment.md                        Deployment procedure and rollback
  runbook.md                           Service operations
  setup.md                             Install and configure
  intake-log.md                        Signal intake log for non-tracked-system projects
  lessons-learned-registry.md          Lessons-learned starter
  anti-pattern-registry.md             Anti-pattern registry starter
  vsm.md                               Value stream mapping baseline archive convention
```

## Versioning

Follows [Semantic Versioning](https://semver.org). All changes in [CHANGELOG.md](CHANGELOG.md).

See [CHANGELOG.md](CHANGELOG.md) for current version and history. Release trigger and automation policy is documented in [ADR-2026-04-14](docs/decisions/ADR-2026-04-14-automate-release-mechanics-at-close-push-remains-gate-authority-only.md) (current, automates local mechanics at CLOSE; push remains gate-authority-only) and [ADR-2026-04-11](docs/decisions/ADR-2026-04-11-release-trigger-policy.md) (partially superseded; thematic-completion trigger, semver assignment table, and breaking-change pre-release notice remain in force).

## Contributing

Propose changes via pull request. Every structural change to STANDARDS.md requires an ADR in `docs/decisions/`. Update CHANGELOG.md and dependencies.md in the same commit if affected.
