---
type: work-item-export
stage:
  - close
applies-to:
  - all
implements:
  - REQ-2.2-07
  - REQ-2.2-03
---

# Work Item Export: 2026-04-11-ese-starter-adopter-repo-and-portable-frontmatter-linter

<a name="REQ-TPL-52"></a>
**REQ-TPL-52** `advisory` `continuous` `soft` `all`
Required by ADR-019 for projects using a private work item system.

> Required by [ADR-019](../decisions/ADR-019-work-item-accessibility-requirement.md) for projects using a private work item system. Export closed work item records to a committed location in the project repository at close time. This template defines the minimum required fields for an exported record.
>
> Projects using a publicly accessible work item system (GitHub Issues, shared project-management tool) satisfy the accessibility requirement by default and do not need to use this template.

---

## Core Attributes

| Field | Value |
|---|---|
| **Work Item ID** | 2026-04-11-ese-starter-adopter-repo-and-portable-frontmatter-linter |
| **Title** | Ship ese-starter adopter repo and parameterized frontmatter linter, with back-port flow for starter-originated linters |
| **Type** | feature |
| **Priority** | P2 |
| **Class of Service** | standard |
| **Owner** | Nick Baker |
| **Discovery Source** | Session execution order item 3; follow-on to the Step 2 commit that shipped starter-form frontmatter. |
| **Created** | 2026-04-11 |
| **Closed** | 2026-04-14 |
| **Close Reason** | Full scope shipped across both repos: engineering-standards v2.6.0 released 2026-04-11 with applicability YAML frontmatter, three-tier validator (CI Check 34), adopter-portable frontmatter linter in `starters/linters/`, and turnkey-adoption tools (`verify.sh`, `upgrade-check.sh`, `catchup.sh`). Public `Nickcom4/ese-starter` repo stood up with 4 releases (v1.0.0 through v1.3.0) including bootstrap.sh, --upgrade mode, and starter-side lint-release-existence.sh. Bidirectional flow demonstrated by back-porting lint-release-existence.sh upstream to engineering-standards as CI Check 36. |

---

## Acceptance Criteria

1. Adopter-portable version of `lint-standards-application-frontmatter.sh` exists in `starters/linters/`, parameterized so adopters do not hand-edit it.
2. `docs/standards-application.md` carries machine-readable YAML frontmatter; `scripts/lint-standards-application-frontmatter.sh` validates presence/types/enums, YAML-prose consistency, and claim-vs-reality.
3. Public `Nickcom4/ese-starter` repo exists with: engineering-standards as submodule, all starter living documents, vendored linters, `scripts/new-artifact.sh`, pre-commit hook, CI workflow, Dependabot, CLAUDE.md/AGENTS.md, README bootstrap ritual.
4. First-commit CI on a freshly cloned starter fails until the adopter fills placeholder fields (forcing function against dummy data).
5. Engineering-standards cuts a release that packages the arc.
6. Bidirectional flow supported: starter-originated improvements can back-flow to engineering-standards.

---

## Scope

**IN SCOPE:**

- Applicability YAML frontmatter in `docs/standards-application.md` plus three-tier validator wired to CI.
- Adopter-portable `lint-standards-application-frontmatter.sh` shipped in `starters/linters/` with `PROJECT_ROOT`, `ESE_ROOT`, `APPLICATION_FILE`, `CHANGELOG_PATH`, `CI_WORKFLOW` parameterization.
- Turnkey-adoption tooling under `starters/tools/`: `verify.sh`, `upgrade-check.sh`, `catchup.sh`, `new-artifact.sh`.
- `docs/migrating-from-partial-adoption.md` migration guide.
- `Nickcom4/ese-starter` public repo: bootstrap.sh (new-project + existing-project modes), `--upgrade` mode, initial `v0.1.0` release creation, 9 vendored linters, pre-commit, CI, CLAUDE.md/AGENTS.md, README.
- Bidirectional back-port: `lint-release-existence.sh` originated in ese-starter v1.3.0 then back-flowed to engineering-standards as CI Check 36.

**OUT OF SCOPE:**

- Dependabot auto-merge policy (manual review retained).
- Additional starter-originated linters beyond `lint-release-existence.sh` (future work items as they arise).
- Migration of existing pre-ESE adopters not already using `starters/` (handled by the migration guide, not a scripted migrator).

---

## VERIFY Answer

What was verified: (1) engineering-standards v2.6.0 released 2026-04-11 with all 35 CI checks green; (2) `Nickcom4/ese-starter` public on GitHub with v1.0.0-v1.3.0 tags and clean working tree; (3) bootstrap.sh tested in both new-project and `--upgrade` modes; (4) three-tier validator tested against five negative mutations and caught all five; (5) adopter-portable frontmatter linter smoke-tested against engineering-standards itself with `ESE_ROOT=. CHANGELOG_PATH=CHANGELOG.md` and passes; (6) back-port of `lint-release-existence.sh` into engineering-standards as CI Check 36 passes full preflight 35/35 with 0 gate failures.

Result: PASS.

Evidence: release tags in both repos; `bash scripts/preflight.sh` output; CI runs on both repos green.

---

## MONITOR Answer

Detection mechanism: engineering-standards has no always-on runtime service; the ported `scripts/lint-release-existence.sh` is itself a detection mechanism for release-trigger drift. Future drift in adopter instances is detected by the vendored linters running on adopter CI. Dependabot on ese-starter opens submodule-bump PRs so adopters never silently fall behind the normative standard.

Alert configured: no. Reason: no runtime service. CI gate failures surface at commit (preflight), pre-merge (`.github/workflows/ci.yml`), and on adopter CI for vendored linters.

Who is notified: committer on local preflight failure; PR reviewer on CI failure; adopter projects on their own CI failures.

---

## Gate Evidence

| Evidence type | Artifact |
|---|---|
| Engineering-standards release | `git tag v2.6.0` (2026-04-11); 35/35 CI checks at release commit |
| Engineering-standards preflight at close | `bash scripts/preflight.sh` reports `total checks: 35, passed: 35, gate failures: 0` |
| ese-starter releases | Public repo `Nickcom4/ese-starter` tags v1.0.0, v1.1.0, v1.2.0, v1.3.0; origin/main clean |
| Applicability frontmatter validator | CI Check 34 wired in `.github/workflows/ci.yml`; negative-mutation tests caught 5/5 drift cases |
| Adopter-portable frontmatter linter | `starters/linters/lint-standards-application-frontmatter.sh` shipped in v2.6.0; starter README catalog updated |
| Turnkey-adoption tools | `starters/tools/verify.sh`, `upgrade-check.sh`, `catchup.sh` shipped in v2.6.0 |
| Bidirectional back-port | `scripts/lint-release-existence.sh` added as CI Check 36 in engineering-standards `[Unreleased]`; originated at ese-starter commit `83b3452` |

---

## Dependencies

| Dependency | Type | Status at close |
|---|---|---|
| Step 2 commit `efee832` (starter-form frontmatter) | discovered-from | closed (prerequisite) |
| ADR-2026-04-11 release trigger policy | triggered-by | closed |
| Dependabot auto-merge policy (deferred) | discovered-from | open (out of scope) |

---

*Exported by: Nick Baker*
*Export date: 2026-04-14*
*Source system: Claude Code session (ese-plugin lifecycle; no tracked-system work item)*
