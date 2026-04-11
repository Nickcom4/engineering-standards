# Adopting and Operating Excellence Standards - Engineering

> How to bring these standards into your project, and the operational reference for template routing and lifecycle addenda activation.

---

## Table of Contents

- [Part 1: Adoption](#part-1-adoption)
  - [What You Get](#what-you-get)
  - [Maturity Model Positioning](#maturity-model-positioning)
  - [How to Adopt](#how-to-adopt)
  - [First Steps After Adoption](#first-steps-after-adoption)
  - [Pre-Existing Projects](#pre-existing-projects)
- [Part 2: Operating the Lifecycle](#part-2-operating-the-lifecycle)
  - [Decision Tree Extended Reference](#decision-tree-extended-reference)
  - [Template Use Guide](#template-use-guide)
  - [Cross-Cutting Activation Summary](#cross-cutting-activation-summary)
- [Part 3: Improvement and Reference](#part-3-improvement-and-reference)
  - [Connecting to Continuous Improvement](#connecting-to-continuous-improvement)
  - [Feedback and Contributions](#feedback-and-contributions)
- [Part 4: Compliance Verification](#part-4-compliance-verification)
  - [Adoption Compliance Checklist](#adoption-compliance-checklist)
  - [Ongoing Compliance Requirements](#ongoing-compliance-requirements)

---

## Part 1: Adoption

### What You Get

This repository contains:

- `STANDARDS.md` - the standard: 9 sections of requirements covering scope, methodology, architecture, documentation, code, testing, monitoring, incident response, and technology adoption
- `templates/` - 15 reusable templates (multi-instance; used repeatedly throughout the lifecycle)
- `starters/` - 8 one-time adoption files (copy once at adoption, then maintain)
- `docs/addenda/` - 7 extensions for specific contexts (AI/ML, web, event-driven, multi-service, multi-team, containerized, continuous improvement)
- `docs/decisions/` - the architectural decisions behind the standard itself

STANDARDS.md has 34 relative-path dependencies on the files above. It requires the full repository to function - copying only STANDARDS.md produces broken links.

---

### Maturity Model Positioning

<a name="REQ-ADO-06"></a>
**REQ-ADO-06** `advisory` `continuous` `soft` `all`
Adopting this standard positions your engineering processes at approximately CMMI Maturity Level 3 (Defined).

Adopting this standard positions your engineering processes at approximately CMMI Maturity Level 3 (Defined). At Level 3, delivery processes are documented, standardized, and applied consistently across projects: the lifecycle, artifact requirements, testing gates, and incident response practices are defined at the organizational level. Projects tailor these processes through their application document (see [starters/standards-application.md](../starters/standards-application.md)) rather than reinventing them for each project.

CMMI Level 4 (Quantitatively Managed) adds statistical process control on top of these defined processes. Teams measure defect rates, cycle times, and quality characteristics with enough precision to distinguish signal from noise, set quantitative performance targets, and predict future outcomes from historical data. This standard introduces the vocabulary and principles of measurement integrity in [§7.7](../STANDARDS.md#77-measurement-integrity) but does not mandate specific statistical methods. Teams operating at Level 4 can use this standard as the defined-process foundation and layer their statistical monitoring framework on top.

If your organization already operates at Level 4 or has defined quality targets, treat this standard as the Level 3 foundation and supplement it with your measurement and optimization methods.

---

### How to Adopt

#### Fastest: Clone the starter repo

If you want a turnkey ESE-compliant scaffold you can clone and rename as the starting point for a new project, use [ese-starter](https://github.com/Nickcom4/ese-starter). It ships with this repo pinned as a git submodule at `.standards/`, all eight vendored drift-detection linters, the scaffolding and verification tools, a pre-commit hook, a CI workflow, Dependabot configuration for automatic submodule bumps, and CLAUDE.md/AGENTS.md agent guidance. Clone it, fill in the placeholders in `docs/standards-application.md`, rename the remote, and push.

```bash
git clone --recurse-submodules https://github.com/Nickcom4/ese-starter.git my-project
cd my-project
# ... fill in placeholders per ese-starter/README.md Bootstrap Ritual ...
git remote set-url origin https://github.com/YOUR-ORG/my-project.git
```

This is the same submodule-based approach described below, but you do not have to assemble the pieces yourself. First-commit CI will fail intentionally on `lint-standards-application-frontmatter.sh` until you fill in the YAML placeholder values; this is the designed forcing function and is documented in the starter README.

If you already have a project and need to adopt incrementally, use the submodule approach below. If your project is already partially adopted from an older version, see [docs/migrating-from-partial-adoption.md](migrating-from-partial-adoption.md).

#### Recommended: Git Submodule

Add this repository as a git submodule in your project. Your project pins a specific version and pulls updates on its own schedule.

```bash
# Add the submodule
git submodule add {repo-url} .standards

# Pin to a specific version
cd .standards
git checkout v{version}   # see CHANGELOG.md for current version
cd ..
git add .standards
git commit -m "Add engineering-standards v{version}"
```

**To update:**
```bash
cd .standards
git fetch
git checkout v{new-version}
cd ..
git add .standards
git commit -m "Update engineering-standards to v{new-version}"
```

Updates are deliberate. Your project never receives a standards change it did not explicitly pull.

<a name="REQ-ADO-01"></a>
**REQ-ADO-01** `artifact` `continuous` `hard` `all`
The project pins ESE to a specific version via git submodule.

<a name="REQ-ADO-05"></a>
**REQ-ADO-05** `artifact` `continuous` `hard` `all`
Updates are pulled explicitly, never received automatically.

#### Staying Current

Updating the submodule pointer is step one, not the complete upgrade. The standard version changes, but every project artifact created against the previous version is now potentially out of date.

<a name="REQ-ADO-02"></a>
**REQ-ADO-02** `gate` `continuous` `hard` `all` `per-artifact`
After every ESE version update, all four steps are completed: read the CHANGELOG, audit all template-based artifacts, run a compliance review, file a work item for every gap found.

**After every version update, complete these four steps:**

1. **Read the CHANGELOG.** Open `CHANGELOG.md` in your updated `.standards/` directory and read every entry between your previous version and the new version. Identify which sections changed and which templates were updated. This tells you where to focus the audit in step 2.

2. **Audit all template-based artifacts.** Every project file derived from a template in `templates/` or `starters/` is a candidate for drift after a standard update. This includes - but is not limited to - ADRs, architecture docs, post-mortems, SLOs, work items, compliance reviews, and `docs/standards-application.md`. Do not limit the audit to `standards-application.md` alone. Every artifact that was created from a template must be checked against the updated template.

3. **Run a compliance review.** Use [templates/compliance-review.md](../templates/compliance-review.md) as the authoritative all-sections audit instrument. A compliance review checks every §1 through §9 requirement systematically. Consulting the CHANGELOG is not a substitute - a standard update can affect requirements and expected artifacts without an explicit template change.

4. **File a work item for every gap found.** Gaps discovered during the audit are filed as work items before any remediation begins. Do not fix gaps inline during the audit pass. Per [§2.1](../STANDARDS.md#21-the-lifecycle) Compliance Review Protocol: file first, then claim and fix.

**The failure mode this prevents:** Template-Standard Drift. See [docs/incidents/anti-patterns.md](incidents/anti-patterns.md) for the named pattern. Template-Standard Drift occurs when artifacts are created against an older template and left unaudited as the standard evolves. A project that updates its submodule pointer without auditing existing artifacts accumulates silent drift across every document created from a template - ADRs, post-mortems, architecture docs, compliance reviews - until the gap is discovered in a production incident or a formal audit.

**Also check for new linters.** On every ESE version bump, review [starters/linters/README.md](../starters/linters/README.md) for any linters added since your previous version (check the CHANGELOG entries between your previous and new version for `starters/linters/` additions). The linter pack evolves independently of the templates: a new drift class discovered in ESE's own self-audit becomes a new linter in `starters/linters/` in the release where it lands. Vendoring a new linter into your project on the same update cycle as the standard bump keeps your drift-detection surface as broad as ESE's own.

**Use the drift-detection tools.** After every submodule bump, run these adopter-facing tools from [starters/tools/](../starters/tools/):

```bash
bash scripts/catchup.sh                  # see what changed between your old pin and the new pin
bash scripts/upgrade-check.sh            # detect drift in three dimensions (pin, version declaration, vendored files)
bash scripts/verify.sh                   # run the full linter suite and summarize pass/fail
```

`catchup.sh` is a read-only preview of the commit log and file changes between versions, scoped to adopter-relevant paths. `upgrade-check.sh` reports on submodule pin drift, declared-version vs pinned-version drift, and per-file byte drift between your vendored copies and their upstream counterparts (so you can decide which local customizations to keep). `verify.sh` wraps the full linter suite into one command with a pass/fail summary. See [starters/tools/README.md](../starters/tools/README.md) for the full adoption protocol.

**If you are coming from an older partial adoption.** Some projects adopted ESE before the current scaffold tools existed and have not yet completed adoption. If that describes your project, follow [docs/migrating-from-partial-adoption.md](migrating-from-partial-adoption.md). It covers the four common partial-adoption states (stale submodule pin, missing vendored linters, missing applicability frontmatter, missing pre-commit and CI wiring), a diagnostic script, and step-by-step resolution per state.

#### Alternative: Fork

Fork this repository into your organization. Recommended only if you need to customize the standard text itself - most projects should use the submodule approach and customize through their `standards-application.md` instead.

#### Not Recommended: Copy

Copying individual files (STANDARDS.md, templates) breaks relative links and creates a maintenance burden when the standard updates. If you must copy, copy the entire repository.

---

<a name="REQ-ADO-03"></a>
**REQ-ADO-03** `gate` `define` `hard` `all` `per-artifact`
First steps after adoption are completed in order: copy starters, set up repo structure, identify applicable addenda, define intake channel and triage cadence, file issues for every gap, define compliance review cadence, and process first signal through the §2.1 decision tree.

### First Steps After Adoption

1. **Copy starters/ files** to create your initial project files. Required starters:
   - [starters/standards-application.md](../starters/standards-application.md) -> `docs/standards-application.md` (compliance tracker; fill in honestly including gaps)
   - [starters/repo-structure.md](../starters/repo-structure.md) -> reference for setting up `docs/` directory layout

   Also vendor any adopter-facing drift-detection linters from [starters/linters/](../starters/linters/) that apply to your project. The linter pack ships parameterized, portable versions of the linters ESE uses on itself; each one catches a specific drift class (template-instance compliance, FMEA congruence, orphan ADRs, CHANGELOG-to-tag congruence, orphan scripts, README structure, count congruence in prose). Copy individual scripts into your `scripts/` directory, configure via environment variables per your project layout, and wire into your CI pipeline. See [starters/linters/README.md](../starters/linters/README.md) for the adoption protocol, parameterization guide, and upgrade protocol.

   Also vendor the adopter-facing workflow tools from [starters/tools/](../starters/tools/). These are developer-facing helpers rather than CI gates: for example, [starters/tools/new-artifact.sh](../starters/tools/new-artifact.sh) scaffolds a new instance of any template (ADR, FMEA, investigation, PRD, etc.) with placeholders pre-filled from the template-instance mapping config, reducing the copy-paste friction of creating new artifacts from templates. See [starters/tools/README.md](../starters/tools/README.md) for the adoption protocol.

2. **Set up your repo structure** per [starters/repo-structure.md](../starters/repo-structure.md). Start with the minimum: README.md, .gitignore, docs/setup.md, docs/decisions/.

3. **Identify which addenda apply** to your project. Check each:
   - [AI and ML Systems](addenda/ai-ml.md) - if you train, fine-tune, or serve ML models
   - [Web Applications](addenda/web-applications.md) - if you have a browser-rendered UI
   - [Event-Driven Systems](addenda/event-driven.md) - if you produce or consume events via a broker
   - [Multi-Service Architectures](addenda/multi-service.md) - if you communicate with services owned by other teams
   - [Multi-Team Organizations](addenda/multi-team.md) - if more than one team contributes
   - [Containerized Systems](addenda/containerized-systems.md) - if you run in containers
   - [Continuous Improvement](addenda/continuous-improvement.md) - if you have recurring quality issues or throughput targets
<a name="REQ-ADO-07"></a>
**REQ-ADO-07** `advisory` `continuous` `soft` `all`
Consult the §2.1 per-stage blocks for when each addendum's requirements activate.

   - Consult the [§2.1 per-stage blocks](../STANDARDS.md#per-stage-operational-blocks) for when each addendum's requirements activate.

4. **Define your intake channel and triage cadence** ([§2.7](../STANDARDS.md#27-user-feedback)): where signals are captured, where they accumulate, and how often they are reviewed. Document in `docs/standards-application.md`. If you do not have a compliant tracked work item system, use [starters/intake-log.md](../starters/intake-log.md) as your intake record format.

5. **File issues for every gap** found in step 1. Do not fix them all at once - track them and resolve incrementally.

6. **Define your compliance review cadence** in standards-application.md. At minimum annually, or when significant system changes occur.

7. **Process your first signal** through the [§2.1 decision tree](../STANDARDS.md#process-decision-tree). Answer the 5 routing questions (domain, urgency, scope, type, addenda) to confirm your process is working end-to-end before production workload begins.

---

<a name="REQ-ADO-04"></a>
**REQ-ADO-04** `advisory` `define` `soft` `all`
Pre-existing projects adopt incrementally: create standards-application.md first, add missing files in priority order (README, setup, decisions, runbook), write retroactive ADRs, do not block current work on reorganization.

### Pre-Existing Projects

Do not reorganize a working project in one pass. Per [starters/repo-structure.md](../starters/repo-structure.md):

1. Create `docs/standards-application.md` - this is the gap tracker
2. Add missing files in priority order: `README.md` then `docs/setup.md` then `docs/decisions/` then `docs/runbook.md`
3. Write retroactive ADRs for decisions already made - per [§9.2](../STANDARDS.md#92-technology-adr-backlog)
<a name="REQ-ADO-08"></a>
**REQ-ADO-08** `advisory` `continuous` `soft` `all`
4. Do not block current work on the reorganization - track it, don't stop for it.

4. Do not block current work on the reorganization - track it, don't stop for it

---

## Part 2: Operating the Lifecycle

> Daily reference for template routing and addenda activation. Part 1 is read once at adoption. Part 2 is consulted on every work item.

### Decision Tree Extended Reference

The concise 5-step decision tree lives in [§2.1](../STANDARDS.md#process-decision-tree) at point of use. This section covers the edge cases that do not fit in the concise form.

<a name="REQ-ADO-12"></a>
**REQ-ADO-12** `advisory` `continuous` `soft` `all`
Edge case 1 - Reclassification mid-lifecycle. If a signal's type or addenda change after the work item is created, re-run Steps 4-5 of the decision...

**Edge case 1 - Reclassification mid-lifecycle.** If a signal's type or addenda change after the work item is created, re-run Steps 4-5 of the decision tree. New gates apply forward only; completed stages are not re-run. Update the work item with the new type and note the reclassification in a comment.

**Edge case 2 - Multiple addenda stacking.** When more than one addendum applies, their requirements are additive at each lifecycle stage. Consult the [Cross-Cutting Activation Summary](#cross-cutting-activation-summary) below to see all addenda requirements for each stage at once. No addendum requirement overrides another; if two addenda require different artifacts at the same stage, both artifacts are required.

**Edge case 3 - Complex to Complicated transition.** Work that begins in the Complex domain (probe-sense-respond) enters the full lifecycle at DEFINE after the approach is established. Session logs from the probe cycle become DISCOVER evidence; no intake log row is required for the probe phase. The work item is created at the point where AC can be written.

**Edge case 4 - Compressed triage for expedite.** For active outages (expedite class of service), D0 and D1 documentation are back-filled after resolution, not before. The fix proceeds immediately. The intake log row, triage decision, and work item are created retroactively. This matches how post-mortems work: the incident occurs first, then is documented.

**Edge case 5 - Measurement-driven investigation.** When an investigation's AC requires measured outcomes from a working prototype (the prototype is the measurement instrument), BUILD may precede investigation close. The investigation work item stays at D2 until measurement is complete; a separate implementation work item governs the prototype's BUILD. See [§1.2 measurement-driven investigations](../STANDARDS.md#12-document-progression).

---

### Template Use Guide

All 23 files (15 templates + 8 starters) organized by process phase. Use this guide to find the right file for each lifecycle activity.

#### Phase 1: Project Initialization (once; all starters/)

| File | Directory | Trigger |
|---|---|---|
| [standards-application.md](../starters/standards-application.md) | starters/ | Adopting ESE ([§1.4](../STANDARDS.md#14-project-first-principles)) |
| [repo-structure.md](../starters/repo-structure.md) | starters/ | Setting up project directory ([§4.1](../STANDARDS.md#41-what-must-be-documented)) |
| [deployment.md](../starters/deployment.md) | starters/ | First deployment procedure ([§4.1](../STANDARDS.md#41-what-must-be-documented)) |
| [runbook.md](../starters/runbook.md) | starters/ | First always-on service ([§4.8](../STANDARDS.md#48-documentation-layers)) |
| [setup.md](../starters/setup.md) | starters/ | First setup guide ([§4.1](../STANDARDS.md#41-what-must-be-documented)) |
| [lessons-learned-registry.md](../starters/lessons-learned-registry.md) | starters/ | Project start; add entries after post-mortems ([§8.3](../STANDARDS.md#83-lessons-learned-registry)) |
| [anti-pattern-registry.md](../starters/anti-pattern-registry.md) | starters/ | Project start; add entries when patterns recur ([§8.4](../STANDARDS.md#84-anti-pattern-registry)) |
| [intake-log.md](../starters/intake-log.md) | starters/ | Project start (if no compliant tracked system); append one row per signal ([§2.1 DISCOVER](../STANDARDS.md#21-the-lifecycle)) |

#### Phase 2: Problem Discovery and Scoping (significant new products; skipped for bugs and routine work)

| §1.2 Step | File | Directory | Gate |
|---|---|---|---|
| Step 1 | [problem-research.md](../templates/problem-research.md) (full depth; also DISCOVER D2 abbreviated) | templates/ | Gate authority confirms problem characterized |
| Step 2 | [capabilities.md](../templates/capabilities.md) | templates/ | Gate authority approves capability list |
| Step 3 | [prd.md](../templates/prd.md) | templates/ | Gate authority approves; SLOs linked |
| Step 4 | [architecture-doc.md](../templates/architecture-doc.md), [adr.md](../templates/adr.md) | templates/ | ADRs accepted; required FMEA complete |

#### Phase 3: Delivery Lifecycle (per work item; all templates/ except starters noted)

| Stage | File | Directory | Trigger |
|---|---|---|---|
| DISCOVER D0/D1 | [intake-log.md](../starters/intake-log.md) | starters/ | Every signal; append one row |
| DEFINE | [work-item.md](../templates/work-item.md) | templates/ | Every promoted signal; 8 §2.2 attributes |
| DEFINE (investigation) | [investigation.md](../templates/investigation.md) | templates/ | Paired with type=investigation; continuous from D2 |
| DESIGN (qualifying) | [adr.md](../templates/adr.md) | templates/ | New component, replaced approach, new dep, changed service comm |
| DESIGN (high-risk) | [fmea.md](../templates/fmea.md) | templates/ | Auth, payments, data mutation, external integrations |
| DESIGN (new component) | [architecture-doc.md](../templates/architecture-doc.md) | templates/ | New system component |
| VERIFY | [work-item.md](../templates/work-item.md) VERIFY field | templates/ | Record what was verified and result |
| DOCUMENT | [work-session-log.md](../templates/work-session-log.md) | templates/ | Every significant work session |
| DOCUMENT | [runbook.md](../starters/runbook.md) | starters/ | Always-on services (created at adoption, updated here) |
| DOCUMENT | [deployment.md](../starters/deployment.md) | starters/ | Deployment changes (created at adoption, updated here) |
| DOCUMENT | [setup.md](../starters/setup.md) | starters/ | New dependencies or configuration (created at adoption, updated here) |
| DEPLOY | [deployment.md](../starters/deployment.md) | starters/ | Per [§5.7](../STANDARDS.md#57-deployment-strategies-and-release-safety); rollout + rollback |
| MONITOR | [work-item.md](../templates/work-item.md) MONITOR field | templates/ | Detection mechanism required |
| MONITOR | [slo.md](../templates/slo.md) | templates/ | New SLO for always-on capability |
| CLOSE | [work-item.md](../templates/work-item.md) Gate Evidence field | templates/ | Artifacts proving work done |
| CLOSE (private system) | [work-item-export.md](../templates/work-item-export.md) | templates/ | [ADR-019](decisions/ADR-019-work-item-accessibility-requirement.md); generated from tracked system at close |

#### Phase 4: Learning from Failure ([§8](../STANDARDS.md#8-learning-from-failure))

| File | Directory | Trigger |
|---|---|---|
| [post-mortem.md](../templates/post-mortem.md) | templates/ | P0/P1 incident ([§8.2](../STANDARDS.md#82-post-mortem-format)); P2 discretionary |
| [a3.md](../templates/a3.md) | templates/ | Recurring quality issue, bottleneck, or process inefficiency ([§8.7](../STANDARDS.md#87-a3-structured-problem-solving)) |
| [lessons-learned-registry.md](../starters/lessons-learned-registry.md) | starters/ | After every post-mortem; append entries ([§8.3](../STANDARDS.md#83-lessons-learned-registry)) |
| [anti-pattern-registry.md](../starters/anti-pattern-registry.md) | starters/ | Pattern promotion; append entries ([§8.4](../STANDARDS.md#84-anti-pattern-registry)) |

#### Phase 5: Technology Adoption ([§9.1](../STANDARDS.md#91-evaluation-framework))

| File | Directory | Trigger |
|---|---|---|
| [tech-eval.md](../templates/tech-eval.md) | templates/ | New package, service, or behavior-category version change |

#### Phase 6: Ongoing Compliance

| File | Directory | Trigger |
|---|---|---|
| [compliance-review.md](../templates/compliance-review.md) | templates/ | Periodic review ([ADR-011](decisions/ADR-011-excellence-standards-scope-and-structural-gaps.md)); at minimum annually |

---

### Cross-Cutting Activation Summary

<a name="REQ-ADO-09"></a>
**REQ-ADO-09** `advisory` `continuous` `soft` `all`
This table answers a different question than the per-stage blocks in §2.

This table answers a different question than the per-stage blocks in §2.1. The per-stage blocks (§2.1) answer: "I'm at VERIFY: which addenda apply?" (row view). This table answers: "Where does the Web addendum apply across the lifecycle?" (column view). Use this during compliance reviews and initial addenda assessment.

**Derived from [§2.1 per-stage blocks](../STANDARDS.md#per-stage-operational-blocks). When this table and §2.1 diverge, §2.1 is authoritative. Update both in the same commit.**

| Stage | CI | AI/ML | Web | Event-Driven | Multi-Service | Multi-Team | Containerized |
|---|---|---|---|---|---|---|---|
| DISCOVER | Gemba, waste audit, constraint ID | Incident taxonomy extension | - | - | - | - | - |
| DEFINE | QFD | - | - | - | - | RFC before work item | - |
| DESIGN | DoE, SMED | Autonomy, hallucination | Browser matrix, a11y | Schema, idempotency, DLQ | API contract, circuit breaker | Agreements | Hardening, limits |
| BUILD | Kaizen execution | Versioning, governance | - | - | - | - | Image build |
| VERIFY | SPC, before/after, SMED | Eval harness, bias | Vitals, Lighthouse, viewport, a11y | Schema compat | Contract tests, tracing | Integration test, agreement verify | - |
| DOCUMENT | - | Model card | - | Arch doc additions | Arch doc additions | - | - |
| DEPLOY | - | Model promotion | Browser verify | - | - | - | Rollout, health probes |
| MONITOR | Capability, control charts | Quality, confidence, drift | Vitals ongoing | Lag, DLQ, violations | - | - | - |
| CLOSE | Kaizen post-event | - | - | - | - | - | - |

---

## Part 3: Improvement and Reference

### Connecting to Continuous Improvement

When delivery health declines ([§7.4](../STANDARDS.md#74-delivery-health)) or patterns recur ([§8.4](../STANDARDS.md#84-anti-pattern-registry)), the [Continuous Improvement addendum](addenda/continuous-improvement.md) provides the tools. Named entry points:

1. **Throughput stalls** -> waste audit and value stream mapping (CI addendum: VSM section)
2. **Systemic problem identified** -> A3 structured problem solving ([§8.7](../STANDARDS.md#87-a3-structured-problem-solving)); use [templates/a3.md](../templates/a3.md)
3. **Before any improvement initiative** -> value stream map to identify constraint before implementing (CI addendum: VSM section)
4. **Time-boxed bounded improvement** -> Kaizen event (CI addendum: Kaizen section)

<a name="REQ-ADO-10"></a>
**REQ-ADO-10** `advisory` `continuous` `soft` `all`
The §2.1 per-stage blocks show exactly where in the lifecycle each CI tool activates.

The [§2.1 per-stage blocks](../STANDARDS.md#per-stage-operational-blocks) show exactly where in the lifecycle each CI tool activates. Consult the per-stage blocks before starting any CI activity to confirm the right stage and artifact.

---

### Feedback and Contributions

Found a gap in the standard? Something unclear or impractical?

**GitHub Issues** are the feedback channel for external adopters. Open an issue at the repository URL to report: requirements that are unclear or impractical, scenarios not covered by the standard or existing addenda, corrections to examples or templates, and questions about applying the standard to your context.

<a name="REQ-ADO-13"></a>
**REQ-ADO-13** `advisory` `continuous` `soft` `all`
Every issue is reviewed against the standards decision log (ADRs) before any change is made to STANDARDS.

Every issue is reviewed against the standards decision log (ADRs) before any change is made to STANDARDS.md. The gate authority (see [docs/standards-application.md](standards-application.md)) reviews all changes before merge.

If you want to propose a structural change to STANDARDS.md, open an issue first. Changes require an ADR documenting context, decision, consequences, and alternatives considered.

---

## Part 4: Compliance Verification

> This part provides the auditable path for adoption. Each requirement below is binary (done or not done) and cites the governing ESE section and the evidence artifact that proves compliance. When REQ-IDs are assigned during the §4.9 migration (B3-B12), each item will be updated with the specific REQ-ID(s) it satisfies. The table structure is designed for that tagging without requiring restructuring.

### Adoption Compliance Checklist

Use this checklist to verify an adopting project meets the minimum baseline. An auditor checking compliance needs to see the evidence artifact for each row. Each REQ-ID links to the governing requirement in STANDARDS.md.

#### Group 1: Project Foundation

| # | Requirement | Evidence artifact | ESE section | REQ-ID |
|---|---|---|---|---|
| 1.1 | `docs/standards-application.md` exists and all 7 active §1.4 first principles are answered (REQ-1.4-05 deprecated) | `docs/standards-application.md` | [§1.4](../STANDARDS.md#14-project-first-principles) | REQ-1.4-01, REQ-STR-17 |
| 1.2 | Repository directory structure matches the documented layout | `starters/repo-structure.md` applied to `docs/` | [§4.1](../STANDARDS.md#41-what-must-be-documented) | REQ-4.1-01 |
| 1.3 | Named owner for the project is discoverable without asking anyone | `docs/standards-application.md` Named Owner section | [§2.4](../STANDARDS.md#24-shared-ownership) | REQ-2.4-01 |
| 1.4 | Component architecture backlog is maintained and reviewed before significant work periods | `docs/standards-application.md` architecture backlog table | [§3.3](../STANDARDS.md#33-architecture-doc-backlog) | REQ-3.3-01 |
| 1.5 | Applicable addenda identified and documented | `docs/standards-application.md` addenda section | [§2.1 Step 5](../STANDARDS.md#21-the-lifecycle) | REQ-2.1-14 |
| 1.6 | Every documented artifact created from a template contains every required section from that template | Template-compliance linter output (`starters/linters/lint-template-compliance.sh`) or compliance review entry | [§4.1](../STANDARDS.md#41-what-must-be-documented) | REQ-4.1-02 |
| 1.7 | Template-compliance verification mode (automated or compliance-review step) chosen and documented | `docs/standards-application.md` §4.1 Template Compliance Verification Mode section | [§4.1](../STANDARDS.md#41-what-must-be-documented) | REQ-4.1-03 |

#### Group 2: Work Item System

| # | Requirement | Evidence artifact | ESE section | REQ-ID |
|---|---|---|---|---|
| 2.1 | Intake capture format and filing location defined | `docs/standards-application.md` user feedback section | [§2.7](../STANDARDS.md#27-user-feedback) | REQ-2.7-01 |
| 2.2 | Intake accumulation channel defined | `docs/standards-application.md` user feedback section | [§2.7](../STANDARDS.md#27-user-feedback) | REQ-2.7-02 |
| 2.3 | Triage cadence defined | `docs/standards-application.md` user feedback section | [§2.7](../STANDARDS.md#27-user-feedback) | REQ-2.7-03 |
| 2.4 | Promotion process from intake to work item defined | `docs/standards-application.md` user feedback section | [§2.7](../STANDARDS.md#27-user-feedback) | REQ-2.7-04 |
| 2.5 | User notification process defined | `docs/standards-application.md` user feedback section | [§2.7](../STANDARDS.md#27-user-feedback) | REQ-2.7-05 |
| 2.6 | Work item system captures all 8 required §2.2 attributes | Tracked system or `templates/work-item.md` | [§2.2](../STANDARDS.md#22-work-item-discipline) | REQ-2.2-01 |
| 2.7 | Closed work items are accessible to authorized reviewers (public system or export to repo) | Tracked system access or `templates/work-item-export.md` at close | [§2.2](../STANDARDS.md#22-work-item-discipline) | REQ-2.2-05 |

#### Group 3: Delivery Lifecycle

| # | Requirement | Evidence artifact | ESE section | REQ-ID |
|---|---|---|---|---|
| 3.1 | §2.1 5-step decision tree verified end-to-end on a representative work item | First closed work item record | [§2.1](../STANDARDS.md#21-the-lifecycle) | REQ-2.1-14 |
| 3.2 | Definition of Done checklist applied at close of each work item | `templates/work-item.md` Gate Evidence field | [§2.3](../STANDARDS.md#23-definition-of-done) | REQ-2.3-01 |
| 3.3 | ADR written for every qualifying change (new component, replaced approach, new dep, changed service comm) | `docs/decisions/` directory | [§4.2](../STANDARDS.md#42-adr-format) | REQ-2.1-03 |
| 3.4 | FMEA completed before BUILD on all qualifying work items (auth, payments, data mutation, external integrations) | Linked FMEA in work item DESIGN section | [§2.1 DESIGN](../STANDARDS.md#21-the-lifecycle) | REQ-2.1-04 |
| 3.5 | Compliance review cadence defined and first review scheduled | `docs/standards-application.md` compliance review section | [§4.1](../STANDARDS.md#41-what-must-be-documented) | REQ-4.1-01 |

#### Group 4: Quality Gates

| # | Requirement | Evidence artifact | ESE section | REQ-ID |
|---|---|---|---|---|
| 4.1 | Pre-commit gate active: linting, formatting, type checks | `.pre-commit-config.yaml` or equivalent CI check | [§5.1](../STANDARDS.md#51-version-control-discipline) | REQ-5.1-01 |
| 4.2 | CI pipeline active: compile, full test suite, dependency vulnerability scan, pre-commit gate | CI pipeline configuration | [§5.5](../STANDARDS.md#55-continuous-integration-and-delivery) | REQ-5.5-01 |
| 4.3 | All runtime and build dependencies explicitly declared and version-pinned | `package.json`, `mix.exs`, `requirements.txt`, or equivalent | [§5.2](../STANDARDS.md#52-dependency-management) | REQ-5.2-01 |
| 4.4 | Test pyramid present: unit, integration, and system tests passing for each production feature | CI test output | [§6.1](../STANDARDS.md#61-test-layers) | REQ-6.1-01 |
| 4.5 | Health check exists for each always-on service | `docs/standards-application.md` service health table | [§7.1](../STANDARDS.md#71-service-health-checks) | REQ-7.1-01 |
| 4.6 | SLO defined for each always-on capability | `templates/slo.md` instance | [§7.5](../STANDARDS.md#75-service-level-objectives) | REQ-7.5-01 |

#### Group 5: Learning Infrastructure

| # | Requirement | Evidence artifact | ESE section | REQ-ID |
|---|---|---|---|---|
| 5.1 | Lessons-learned registry exists and is updated after every post-mortem | `docs/incidents/lessons-learned.md` | [§8.3](../STANDARDS.md#83-lessons-learned-registry) | REQ-8.3-01 |
| 5.2 | Anti-pattern registry exists and is consulted before new work begins | `docs/incidents/anti-patterns.md` | [§8.4](../STANDARDS.md#84-anti-pattern-registry) | REQ-8.4-01 |
| 5.3 | Post-mortem process defined and first template available before first P0 or P1 incident | `templates/post-mortem.md` instance path defined | [§8.2](../STANDARDS.md#82-post-mortem-format) | REQ-8.2-01 |

---

### Ongoing Compliance Requirements

<a name="REQ-ADO-11"></a>
**REQ-ADO-11** `advisory` `continuous` `soft` `all`
Beyond initial adoption, these requirements apply continuously. An audit at any point in the project lifecycle must confirm each of these.

<a name="REQ-ADO-17"></a>
**REQ-ADO-17** `artifact` `continuous` `hard` `all`
Every starter file copied into a project has its placeholder content replaced with project-specific content before the first compliance review.

<a name="REQ-ADO-18"></a>
**REQ-ADO-18** `artifact` `continuous` `hard` `all`
Compliance review is completed at the cadence defined in the project's standards-application document; no compliance review period is skipped without documented exception.

<a name="REQ-ADO-19"></a>
**REQ-ADO-19** `artifact` `continuous` `hard` `all`
When project scope changes (new technology, new team, new deployment target), applicable addenda are re-evaluated and the standards-application document is updated.

Beyond initial adoption, these requirements apply continuously. An audit at any point in the project lifecycle must confirm each of these.

<a name="REQ-ADO-14"></a>
**REQ-ADO-14** `artifact` `continuous` `hard` `all`
Every starter file copied into a project has its placeholder content replaced with project-specific content before the first compliance review.

<a name="REQ-ADO-15"></a>
**REQ-ADO-15** `artifact` `continuous` `hard` `all`
Compliance review is completed at the cadence defined in the project's standards-application document; no compliance review period is skipped without documented exception.

<a name="REQ-ADO-16"></a>
**REQ-ADO-16** `artifact` `continuous` `hard` `all`
When project scope changes (new technology, new team, new deployment target), applicable addenda are re-evaluated and the standards-application document is updated.

| # | Requirement | Cadence | Evidence | ESE section | REQ-ID |
|---|---|---|---|---|---|
| O.1 | Compliance review completed | At minimum annually, or after any significant system change | Completed `templates/compliance-review.md` instance | [§4.1](../STANDARDS.md#41-what-must-be-documented) | REQ-4.1-01 |
| O.2 | Architecture backlog reviewed | At start of every significant work period | Updated `docs/standards-application.md` architecture backlog | [§3.3](../STANDARDS.md#33-architecture-doc-backlog) | REQ-3.3-01 |
| O.3 | Service health checks verified | Continuous (automated alert when service silent beyond threshold) | Monitoring dashboard | [§7.1](../STANDARDS.md#71-service-health-checks) | REQ-7.1-01 |
| O.4 | Dependency vulnerability scan passing | Every CI pass | CI pipeline output | [§5.2](../STANDARDS.md#52-dependency-management) | REQ-5.2-02 |
| O.5 | Dependency vulnerability exceptions reviewed | At minimum quarterly | `docs/standards-application.md` exceptions table | [§5.2](../STANDARDS.md#52-dependency-management) | REQ-5.2-03 |
| O.6 | Dependency license audit | At minimum annually | `docs/standards-application.md` license section | [§5.2](../STANDARDS.md#52-dependency-management) | REQ-5.2-04 |
| O.7 | Lessons-learned registry consulted before new significant features | Before each new feature | Work item DESIGN section acknowledgment | [§8.3](../STANDARDS.md#83-lessons-learned-registry) | REQ-8.3-02 |
| O.8 | Technical debt tracked as work items; debt source documents updated when closed | Continuous | Open type=debt work items; closed work item references source doc | [§8.6](../STANDARDS.md#86-technical-debt-tracking) | REQ-8.6-01 |

**Audit evidence format:** for each checklist item, an auditor needs to see: (a) the artifact named in the Evidence column exists at the expected path, (b) its content satisfies the requirement stated, and (c) it was updated within the cadence specified. When REQ-IDs are assigned, each item's REQ-ID provides the stable identifier for tooling and automated audit systems to reference.

---

*Standard version: see [CHANGELOG.md](../CHANGELOG.md)*


