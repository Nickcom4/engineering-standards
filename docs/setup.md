# Setup


## Table of Contents

- [Prerequisites](#prerequisites)
- [Clone and Verify](#clone-and-verify)
- [Run Quality Gates Locally](#run-quality-gates-locally)
- [Install Git Hooks](#install-git-hooks)
- [Common Setup Issues](#common-setup-issues)

## Prerequisites

- Git
- Python 3.x (for linting scripts)
- Node.js (for markdown-link-check in CI)
- Bash shell

## Clone and Verify

```bash
git clone https://github.com/Nickcom4/engineering-standards.git
cd engineering-standards
```

## Run Quality Gates Locally

```bash
# REQ-ID validation
bash scripts/validate-req-ids.sh              # T1: uniqueness
bash scripts/lint-req-tags.sh                 # T2: tag schema
bash scripts/generate-req-manifest.sh verify  # T7: manifest integrity
bash scripts/generate-enforcement-spec.sh verify  # T6: enforcement spec freshness
bash scripts/generate-req-index.sh verify     # B15: requirement index freshness
bash scripts/lint-stale-counts.sh             # PF-37: stale count references
bash scripts/lint-obligations.sh              # T3: unclassified obligations
bash scripts/lint-section-anchors.sh          # T5: heading anchor stability

# Document quality
bash scripts/lint-broken-tables.sh            # Broken table detection
bash scripts/lint-table-format.sh             # Table column consistency
bash scripts/lint-self-compliance.sh          # Self-compliance (REQ-2.1-51)
bash scripts/lint-readme-structure.sh         # README structure accuracy (bidirectional)
bash scripts/lint-toc-links.sh                # ToC anchor consistency
bash scripts/lint-template-compliance.sh     # Generic template-instance section compliance

# FMEA validation
bash scripts/lint-fmea-consistency.sh         # Internal consistency
bash scripts/lint-fmea-controls.sh            # Controls implementation
bash scripts/lint-fmea-completeness.sh        # Above-threshold FMs have controls
bash scripts/lint-fmea-congruence.sh          # Status/iteration/table/controls congruence

# ADR validation
bash scripts/lint-adr-lifecycle-refs.sh       # Cross-reference consistency
bash scripts/lint-adr-triggers.sh             # Validation trigger staleness (advisory)
bash scripts/lint-adr-validation.sh           # Validation section presence
bash scripts/lint-orphan-adrs.sh              # Orphan ADR detection (advisory)

# Drift detection (beyond templates and FMEAs)
bash scripts/lint-orphan-scripts.sh           # Scripts not wired to CI + CLAUDE.md
bash scripts/lint-count-congruence.sh         # Gate/check/script count claims
bash scripts/lint-changelog-tags.sh           # CHANGELOG version to git tag mapping
bash scripts/lint-standards-application-frontmatter.sh  # Applicability frontmatter ↔ prose ↔ repo state

# Work item validation
bash scripts/lint-work-item-export.sh         # Export format round-trip
```

## Install Git Hooks

```bash
ln -sf ../../scripts/pre-commit .git/hooks/pre-commit
ln -sf ../../scripts/commit-msg .git/hooks/commit-msg
```

The `pre-commit` hook runs REQ-ID validation, tag schema linting, and manifest regeneration on every commit touching STANDARDS.md or addenda. The `commit-msg` hook rejects commits containing AI co-authorship trailers or AI tool attribution lines; ESE commits are authored by the human gate authority.

## Common Setup Issues

- **Pre-commit not running:** verify symlink exists at `.git/hooks/pre-commit`
- **Commit rejected for AI attribution:** remove any `Co-Authored-By` or `Generated with` lines referencing AI tools
- **Python not found:** scripts require Python 3.x in PATH
- **Manifest verify fails:** run `bash scripts/generate-req-manifest.sh generate` to regenerate

<!-- omit-section: Clone and Run -->
<!-- Reason: ESE has no "run" step. Section is "Clone and Verify" instead; content covers cloning and verifying the quality gates. -->

<!-- omit-section: Environment Variables -->
<!-- Reason: ESE is a documentation standard with no environment variables, secrets, or runtime configuration. -->

<!-- omit-section: Common Setup Failures -->
<!-- Reason: Section is "Common Setup Issues" instead; same content, project-appropriate naming. -->

<!-- omit-section: Verify Your Setup -->
<!-- Reason: Section is "Run Quality Gates Locally" instead; verification is running the CI scripts. -->
