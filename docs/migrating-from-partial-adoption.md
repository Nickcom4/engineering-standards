# Migrating from Partial ESE Adoption

> This guide is for projects that already reference ESE but are not yet in the canonical adoption state established by the current release. It covers the four common partial-adoption states, how to detect which you are in, and the exact steps to reach full compliance. Migration is never forced; you can stay where you are indefinitely, and you can also stop at any intermediate state if that is what your project requires.

## Table of Contents

- [When this guide applies](#when-this-guide-applies)
- [The four partial states](#the-four-partial-states)
- [Detecting your current state](#detecting-your-current-state)
- [State A: stale submodule pin](#state-a-stale-submodule-pin)
- [State B: missing vendored linters](#state-b-missing-vendored-linters)
- [State C: missing applicability frontmatter](#state-c-missing-applicability-frontmatter)
- [State D: missing pre-commit and CI wiring](#state-d-missing-pre-commit-and-ci-wiring)
- [Verifying a completed migration](#verifying-a-completed-migration)
- [When you should NOT migrate](#when-you-should-not-migrate)

## When this guide applies

This guide applies if any of these statements are true about your project:

- Your `.standards/` submodule is pinned at a commit older than the current ESE `v2.5.0` tag.
- Your `scripts/` directory is missing one or more of the eight vendored drift-detection linters canonically owned by `ese-starter` (per ADR-2026-04-24).
- Your `docs/standards-application.md` does not have the machine-readable YAML applicability frontmatter at the top (the block starting with `---` and containing fields like `ese-version`, `owner`, `capabilities`, `addenda`).
- Your `scripts/pre-commit` or `.github/workflows/ci.yml` does not invoke the vendored ESE linters.
- You adopted ESE before the clean-history cut at `v2.5.0` and your submodule reference points at a commit that no longer exists on `origin` (you see `fatal: reference not found` when fetching).

If none of these apply and your project is already at the canonical state, stop here: you do not need to migrate.

## The four partial states

Most partial adoptions fall into one of four buckets. Your project may be in one, several, or all of them simultaneously. Each can be resolved independently in any order, though the ordering suggested below minimizes CI noise.

| State | Symptom | Resolution complexity |
|---|---|---|
| **A. Stale submodule pin** | `.standards/` points at a commit older than the current ESE HEAD, or at a commit that no longer exists on origin (pre-rewrite SHA) | Low: one submodule bump |
| **B. Missing vendored linters** | `scripts/lint-*.sh` is missing one or more of the eight drift-detection linters | Low: re-run ese-starter bootstrap in upgrade mode, or manually copy from an ese-starter clone's `scripts/` |
| **C. Missing applicability frontmatter** | `docs/standards-application.md` has prose sections but no YAML frontmatter block at the top | Medium: copy schema from `.standards/starters/standards-application.md`, fill in values |
| **D. Missing pre-commit and CI wiring** | `scripts/pre-commit` does not exist, or `.github/workflows/ci.yml` does not run the vendored linters | Medium: copy workflow and pre-commit from `.standards/.github/workflows/ci.yml` pattern and adapt |

## Detecting your current state

Run this five-check diagnostic from your project root to surface which states apply:

```sh
# Check 1: submodule pin vs current ESE
if [ -d .standards ]; then
  git -C .standards fetch origin 2>/dev/null
  pinned=$(git -C .standards rev-parse HEAD)
  latest=$(git -C .standards rev-parse origin/main)
  if [ "$pinned" != "$latest" ]; then
    echo "State A: submodule pin $pinned differs from origin/main $latest"
  fi
  if ! git -C .standards cat-file -e "$pinned" 2>/dev/null; then
    echo "State A (severe): submodule pin $pinned is not in origin history (pre-rewrite SHA)"
  fi
fi

# Check 2: vendored linters present
expected_linters="lint-template-compliance.sh lint-standards-application-frontmatter.sh lint-fmea-congruence.sh lint-orphan-adrs.sh lint-changelog-tags.sh lint-orphan-scripts.sh lint-readme-structure.sh lint-count-congruence.sh"
for lint in $expected_linters; do
  [ -f "scripts/$lint" ] || echo "State B: missing scripts/$lint"
done

# Check 3: applicability frontmatter present
if [ -f docs/standards-application.md ]; then
  head -1 docs/standards-application.md | grep -q '^---$' || echo "State C: docs/standards-application.md has no YAML frontmatter delimiter"
  grep -q '^ese-version:' docs/standards-application.md || echo "State C: missing ese-version field in frontmatter"
fi

# Check 4: pre-commit hook wired
[ -f scripts/pre-commit ] || echo "State D: scripts/pre-commit does not exist"
[ -f .git/hooks/pre-commit ] || echo "State D: pre-commit hook not installed (symlink or copy)"

# Check 5: CI workflow invokes linters
if [ -f .github/workflows/ci.yml ]; then
  grep -q 'scripts/lint-template-compliance.sh' .github/workflows/ci.yml || echo "State D: CI workflow does not run lint-template-compliance.sh"
else
  echo "State D: .github/workflows/ci.yml does not exist"
fi
```

Save the output; it tells you which sections of this guide to apply.

## State A: stale submodule pin

### If the pinned SHA still exists on origin

Fast-forward to the current tip:

```sh
git -C .standards fetch origin
git -C .standards checkout main
git add .standards
git commit -m "chore: bump ESE submodule to latest"
```

Then re-verify your vendored files against the ese-starter canonical source (per ADR-2026-04-24, adopter-facing executable code is owned by ese-starter, not by the engineering-standards submodule). Any vendored linter that has diverged from its upstream form is a candidate for re-copy. With an ese-starter clone at `$ESE_STARTER_ROOT`:

```sh
for lint in scripts/lint-*.sh; do
  upstream="$ESE_STARTER_ROOT/scripts/$(basename $lint)"
  if [ -f "$upstream" ] && ! diff -q "$lint" "$upstream" >/dev/null; then
    echo "DRIFT: $lint differs from $upstream"
  fi
done
```

For each drift, decide: keep your local customization (and document why), or re-copy from upstream (discarding your changes). There is no correct answer; this is an engineering judgment call per script. The ese-starter `scripts/upgrade-check.sh` automates the same comparison.

### If the pinned SHA does not exist on origin

This happens if you adopted ESE before the clean-history cut. Your local submodule checkout still has the old commits, but `origin` does not. The fix:

```sh
# Force-update the submodule URL and reset to the current origin
git -C .standards fetch --all --prune
git -C .standards reset --hard origin/main
git -C .standards tag -d v2.5.0 2>/dev/null  # drop stale local tag if it differs
git -C .standards fetch --tags origin
git add .standards
git commit -m "chore: re-sync ESE submodule to clean-history v2.5.0"
```

Your submodule now points at the new `v2.5.0` root commit. Any vendored files must be re-verified as in the fast-forward path above.

## State B: missing vendored linters

The canonical source of adopter-facing linters and scaffolding tools is the `ese-starter` repository (per ADR-2026-04-24). The simplest path is to clone ese-starter and run its bootstrap in upgrade mode against your project:

```sh
git clone https://github.com/Nickcom4/ese-starter.git /tmp/ese-starter
bash /tmp/ese-starter/scripts/bootstrap.sh --upgrade --target .
```

This re-copies the full `scripts/` directory (linters, scaffolding tool, verify harness, pre-commit hook) and CI workflow into your project. It does not touch your `docs/`, your `CHANGELOG.md`, or the `.standards/` submodule.

If you prefer to copy individual files, point the source at your ese-starter clone's `scripts/` directory:

```sh
ESE_STARTER_ROOT=/tmp/ese-starter
for lint in lint-template-compliance.sh lint-standards-application-frontmatter.sh lint-fmea-congruence.sh lint-orphan-adrs.sh lint-changelog-tags.sh lint-orphan-scripts.sh lint-readme-structure.sh lint-count-congruence.sh; do
  if [ ! -f "scripts/$lint" ]; then
    cp "$ESE_STARTER_ROOT/scripts/$lint" "scripts/$lint"
    chmod +x "scripts/$lint"
    echo "copied scripts/$lint"
  fi
done
[ -f scripts/new-artifact.sh ] || cp "$ESE_STARTER_ROOT/scripts/new-artifact.sh" scripts/ && chmod +x scripts/new-artifact.sh
[ -f scripts/template-instance-mappings.txt ] || cp "$ESE_STARTER_ROOT/scripts/template-instance-mappings.txt" scripts/template-instance-mappings.txt
```

Commit:

```sh
git add scripts/
git commit -m "chore: vendor missing ESE linters from ese-starter"
```

## State C: missing applicability frontmatter

Your project's `docs/standards-application.md` is missing the machine-readable YAML frontmatter block. The schema is documented in `starters/standards-application.md` in the submodule.

1. Open `docs/standards-application.md` and `.standards/starters/standards-application.md` side by side.
2. Copy the `---` frontmatter block from the starter (the top of the file, above the H1 heading) into your own file at the same location, above your existing H1.
3. Remove the three starter-metadata keys (`type: starter`, `purpose:`, `frequency:`). These are for the starter template itself, not your instance.
4. Fill in every `{placeholder}` value with your project's actual data:
   - `ese-version`: the tag your submodule is pinned at (e.g., `"2.5.0"`)
   - `last-updated`: today's date in `YYYY-MM-DD` form
   - `owner.name`: your team or individual name
   - `owner.contact`: how to reach you
   - `compliance-review.last-review-date`: today's date
   - `compliance-review.next-review-trigger`: when you next plan a review
5. Review the `capabilities.*` booleans. Default is all `false`. Flip to `true` for every capability your project actually has. The corresponding prose table in the Component Capabilities Declaration section must match.
6. Review the `addenda.*` booleans. Default is all `false`. Flip to `true` for every addendum that applies. The Applicable Addenda prose table must match.
7. Run `bash scripts/lint-standards-application-frontmatter.sh`. If Tier 2 reports a YAML vs prose mismatch, edit the prose table cells to match the YAML booleans.

Commit:

```sh
git add docs/standards-application.md
git commit -m "docs: add applicability frontmatter schema to standards-application"
```

## State D: missing pre-commit and CI wiring

### Pre-commit hook

Copy the starter pre-commit and install it as a git hook:

```sh
# template-instance-mappings.txt is part of the ese-starter-owned toolchain
# (see ADR-2026-04-24). Vendor it from an ese-starter clone if missing:
# cp "$ESE_STARTER_ROOT/scripts/template-instance-mappings.txt" scripts/template-instance-mappings.txt
# Use the pre-commit pattern from the ese-starter repo (a reference implementation);
# a minimal adopter version is inline below.
cat > scripts/pre-commit <<'PRECOMMIT'
#!/usr/bin/env bash
set -euo pipefail
REPO_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
FAILED=0
STAGED=$(git diff --cached --name-only 2>/dev/null || true)
if echo "$STAGED" | grep -q '^docs/standards-application\.md$'; then
  bash "$REPO_ROOT/scripts/lint-standards-application-frontmatter.sh" || FAILED=1
fi
if echo "$STAGED" | grep -qE '^(docs/decisions|docs/architecture|docs/product|docs/work-items|docs/compliance-reviews|docs/incidents)/.*\.md$'; then
  bash "$REPO_ROOT/scripts/lint-template-compliance.sh" || FAILED=1
fi
if echo "$STAGED" | grep -qE '(DFMEA|PFMEA)-.*\.md$'; then
  bash "$REPO_ROOT/scripts/lint-fmea-congruence.sh" || FAILED=1
fi
[ "$FAILED" -eq 1 ] && { echo "pre-commit: BLOCKED"; exit 1; }
exit 0
PRECOMMIT
chmod +x scripts/pre-commit
ln -sf ../../scripts/pre-commit .git/hooks/pre-commit
```

### CI workflow

Add a GitHub Actions workflow that runs the vendored linters on every push and pull request. The simplest minimum-viable version:

```yaml
# .github/workflows/ci.yml
name: ESE Quality Gate
on:
  pull_request:
    branches: [main]
  push:
    branches: [main]
jobs:
  quality-gate:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with:
          submodules: recursive
      - uses: actions/setup-python@v5
        with:
          python-version: "3.11"
      - run: bash scripts/lint-template-compliance.sh
      - run: bash scripts/lint-standards-application-frontmatter.sh
      - run: bash scripts/lint-fmea-congruence.sh
      - run: bash scripts/lint-orphan-adrs.sh
        continue-on-error: true
      - run: bash scripts/lint-changelog-tags.sh
      - run: bash scripts/lint-orphan-scripts.sh
      - run: bash scripts/lint-readme-structure.sh
      - run: bash scripts/lint-count-congruence.sh
```

The ESE repo is public, so `submodules: recursive` works with the default `GITHUB_TOKEN` and no additional authentication is needed. Commit the workflow:

```sh
git add .github/workflows/ci.yml scripts/pre-commit
git commit -m "chore: wire ESE linter suite into pre-commit and CI"
```

## Verifying a completed migration

After resolving all four states, run the full linter suite locally:

```sh
for lint in scripts/lint-*.sh; do
  echo "=== $lint ==="
  bash "$lint" || echo "FAILED: $lint"
done
```

Every linter should exit 0 or print a designed-warning message (e.g., `lint-orphan-adrs.sh` is advisory only). If any linter reports a real failure, address it per the linter's own fix instructions. The `lint-standards-application-frontmatter.sh` is the most likely to report remaining work: Tier 1 rejects unfilled placeholders, Tier 2 rejects YAML vs prose mismatches, Tier 3 rejects version pin / evidence path / addendum citation drift.

Also push to GitHub and verify CI runs green. A green CI on your first post-migration push is the canonical pass condition.

## When you should NOT migrate

Migration is never forced. If any of these apply, stay where you are:

- Your project has custom linter logic that is incompatible with ESE's vendored versions, and reconciling the customization would cost more than the drift-detection value.
- Your project's artifact conventions diverge from ESE's templates (e.g., different ADR format, different FMEA structure) and you have documented the divergence as an intentional project decision.
- Your project is in a freeze window or near a release; migration that fails CI would block a shipment.
- You are not the gate authority for the project and the gate authority has not approved the migration.

In any of these cases, the correct action is to document the current state in your `docs/standards-application.md` and return to this guide when the constraints relax. Partial adoption is a valid steady state as long as you have chosen it deliberately.
