---
type: deployment
applies-to: engineering-standards
implements:
  - REQ-STR-07
  - REQ-STR-41
  - REQ-STR-42
  - REQ-STR-43
---

# Deployment: Excellence Standards - Engineering (ESE)

> Deployment documentation per ESE [§4.1](../STANDARDS.md#41-what-must-be-documented) and [§5.7](../STANDARDS.md#57-deployment-strategies-and-release-safety). ESE is a documentation standard  -  no compiled artifact, no runtime service. "Deployment" means publishing a new version to the canonical git repository.

---


## Table of Contents

- [Environments](#environments)
- [Prerequisites](#prerequisites)
- [Deployment Procedure](#deployment-procedure)
- [Rollout Strategy](#rollout-strategy)
- [Rollback Procedure](#rollback-procedure)
- [Rollback Trigger](#rollback-trigger)

## Environments

| Environment | Location | Purpose | Access |
|-------------|----------|---------|--------|
| Working copy | Local clone of origin | Development and review | Owner (gate authority) |
| Origin (canonical) | `github.com/Nickcom4/engineering-standards` | Published standard | Public read; owner push |
| Submodule consumers | Any project that `git submodule add` this repo | Adopting projects pin to a commit | Per-project |

---

## Prerequisites

> [§5.1](../STANDARDS.md#51-version-control-discipline): all CI gates pass, documentation updated, pre-commit checks pass before push.

- [ ] All CI gates pass: `git push` triggers GitHub Actions; all checks must be green
- [ ] Pre-commit checks pass locally (em dash scan, REQ-ID uniqueness, manifest verification)
- [ ] CHANGELOG.md updated with version, date, and changes (per [§4.3](../STANDARDS.md#43-changelogs))
- [ ] STANDARDS.md version header updated if applicable
- [ ] Rollback trigger confirmed (see below)

---

## Deployment Procedure

### Standard release (minor/patch)

1. Ensure all changes are committed locally:
   ```bash
   git status  # clean
   git log --oneline -5  # review commits
   ```
2. Run pre-commit checks manually if not already run:
   ```bash
   pre-commit run --all-files
   ```
3. Push to origin:
   ```bash
   git push origin main
   ```
4. Confirm GitHub Actions CI passes (all checks green)
5. Tag the release if this is a versioned release:
   ```bash
   git tag v{version}
   git push origin v{version}
   ```

### Major release (breaking change or structural reorganization)

Same as above, plus:
6. Update all submodule consumers to pin to the new version (inform adopting projects via CHANGELOG)
7. Verify [docs/adoption.md](adoption.md) is current

---

## Rollout Strategy

**Rollout type:** Immediate (documentation standard; no staged rollout needed).

**What is automated:** CI checks (em dash scan, REQ-ID validation, link checking, manifest verification) run on every push via GitHub Actions. Pre-commit hooks enforce formatting and REQ-ID integrity locally.

**What is manual:** Author review, CHANGELOG update, version bump, git push, submodule consumer notification for breaking changes.

---

## Rollback Procedure

**ESE has no runtime service**  -  "rollback" means reverting a git commit and re-publishing.

1. Identify the commit to revert:
   ```bash
   git log --oneline -10
   ```
2. Revert the problematic commit(s):
   ```bash
   git revert {commit-sha}
   ```
   Or for multiple commits: `git revert HEAD~N..HEAD`
3. Push the revert:
   ```bash
   git push origin main
   ```
4. Notify submodule consumers if the reverted content was a breaking change.

**Specific rollback steps (per REQ-STR-42):**
- Revert: `git revert {sha}`  -  creates a new commit undoing the change; preserves history
- Alternative: `git reset --hard {sha} && git push --force-with-lease`  -  only when the problematic commit is not yet consumed by submodule consumers

---

## Rollback Trigger

> Per REQ-STR-43.

Rollback is triggered by any of:
1. **CI failure** on the pushed commit: revert until root cause is fixed and CI passes
2. **REQ-ID conflict** introduced: a duplicate REQ-ID was not caught pre-commit; revert, fix, re-push
3. **Adopting project reports a breaking change** that was not declared as breaking in CHANGELOG
4. **Content error** identified by the standard owner: factually incorrect requirement statement

Rollback trigger is assessed **immediately** on notification  -  not at the next review cycle.

---

<!-- omit-section: Post-Deployment Verification -->
<!-- Reason: ESE is a documentation standard with no runtime service. There is no health check, no user flows, and no monitoring dashboard to verify post-deploy. CI passing on push is the verification. -->

<!-- omit-section: Monitoring After Deploy -->
<!-- Reason: ESE has no runtime service. There are no metrics, dashboards, or alerts to monitor. Adopter notification for breaking changes is covered in the Deployment Procedure section. -->

*Standard version applied: 2.0.0*
*Last updated: 2026-04-09*
