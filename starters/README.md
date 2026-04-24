---
type: starters-index
implements:
  - REQ-4.3-15
last-updated: 2026-04-17
---

# ESE starters index

Starter documents that adopters copy into their projects during bootstrap or when adopting a new capability. Each starter is a non-normative template: adopters fill in the `{placeholder}` fields, edit the shape as needed, and track the instance in their own repository.

## Available starters

| Starter | Copy to | When |
|---|---|---|
| [AGENTS.md](AGENTS.md) | `AGENTS.md` (repo root) | Provider-agnostic agent context; use when targeting multiple AI coding agents (Claude Code, Cursor, Copilot CLI, etc.). Canonical cross-provider filename. |
| [standards-application.md](standards-application.md) | `docs/standards-application.md` | Always. Declares capability booleans, addenda, and compliance-review cadence. Filled during bootstrap. |
| [setup.md](setup.md) | `docs/setup.md` | Always. Onboarding instructions, prerequisites, environment variables. |
| [deployment.md](deployment.md) | `docs/deployment.md` | When `capabilities.has-runtime-service` is true AND the project deploys to production. |
| [runbook.md](runbook.md) | `docs/runbook.md` | When `capabilities.has-runtime-service` is true. Operational runbook for production incidents. |
| [intake-log.md](intake-log.md) | `docs/intake-log.md` | Level 2 adoption maturity or higher. Tracks every work item with class-of-service. |
| [lessons-learned-registry.md](lessons-learned-registry.md) | `docs/incidents/lessons-learned.md` | Always. Captures insights from incidents and A3 analyses. |
| [anti-pattern-registry.md](anti-pattern-registry.md) | `docs/incidents/anti-patterns.md` | Always. Captures repeated-failure patterns. |
| [repo-structure.md](repo-structure.md) | `docs/repo-structure.md` | Advisory. Documents the project's top-level layout. |
| [vsm.md](vsm.md) | `docs/vsms/baseline-<date>.md` | When `addenda.continuous-improvement` is true. Captures value stream map baseline. |

## Stack-specific CLAUDE.md starters

Claude Code-specific agent context starters tailored to common stacks. Copy the matching starter to `CLAUDE.md` at your repo root; fill in the `{placeholder}` fields.

| Stack | Starter |
|---|---|
| Python | [`claude-md/python.starter`](claude-md/python.starter) |
| Go | [`claude-md/go.starter`](claude-md/go.starter) |
| TypeScript / Node | [`claude-md/typescript.starter`](claude-md/typescript.starter) |

Choose one based on the project's primary language. Mixed-language projects pick the dominant stack and add sections for secondary stacks inline.

## Provider-agnostic default

If an adopter's target repo does not have a Claude-specific configuration, use [AGENTS.md](AGENTS.md) as the default. It carries the same posture as the Claude-specific variants but uses the canonical cross-provider filename that Cursor, Copilot CLI, and other AI coding tools also recognize.

## Linters and tools

Executable adopter scaffolding (linter scripts, bootstrap tool, verify harness, scaffolding tool) lives canonically in the `ese-starter` repository per [ADR-2026-04-24](../docs/decisions/ADR-2026-04-24-ese-code-canonicalization-ese-starter-as-single-source-for-adopter-facing-executable-code.md). See [docs/adoption.md](../docs/adoption.md) for the adoption protocol.
