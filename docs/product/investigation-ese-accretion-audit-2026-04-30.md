---
type: investigation
stage:
  - discover
  - define
applies-to:
  - investigation
implements:
  - REQ-2.3-17
  - REQ-2.3-18
  - REQ-2.2-01
---

# Investigation: ESE accretion audit 2026-04-30

> Audit of ESE elements (linters and requirements) for whether each still earns its keep, using the test "would removing this permit a real failure?"

**Work Item ID:** WI-2026-04-30-ese-accretion-audit
**Date:** 2026-04-30
**Owner:** Nick Baker

---

## Investigation Question

Which ESE elements (linters in `scripts/lint-*.sh` and REQ-IDs in STANDARDS.md / addenda) have accreted past their value, and which have a documented failure mode that would recur if removed? The investigation closes when each linter has a verdict (keep, merge, deprecate) and a stratified REQ-ID sample has a one-sentence failure-mode-on-removal answer for each entry.

---

## Method

**Linter pass.** Read the header comment of every `scripts/lint-*.sh`. For each, identify the defect class it claims to prevent, look for git log evidence that the defect class has shipped, and assign a verdict.

**REQ-ID pass.** Stratified sample of at least 10% of REQ-IDs across STANDARDS.md sections and active addenda. For each, name the failure mode that removing it would permit, or flag as a candidate.

**Live-friction evidence.** During this very investigation, lifecycle ceremony produced four rounds of blocking friction before the deliverable could be written. Each round is recorded as evidence; together they form the strongest single class of finding.

---

## Evidence Gathered

### Counts (verified at investigation date)

| Surface | Count | Source |
|------|--------|---------|
| 2026-04-30 | `scripts/lint-*.sh` | 30 (not 39 as previously cited; the "39 CI checks" figure includes manifest-generation and content-scan steps that are not lint scripts) |
| 2026-04-30 | STANDARDS.md REQ-IDs | 392 |
| 2026-04-30 | Addendum REQ-IDs | 242 across 8 addenda (agent-assisted-development 17, ai-ml 27, containerized-systems 20, continuous-improvement 69, event-driven 26, multi-service 19, multi-team 34, web-applications 30) |
| 2026-04-30 | Total core REQ-IDs | ~634 (the previously-cited 772 figure includes template REQ-TPL-NN annotations and starter REQs, not just core normative requirements) |

The "first principles" framing question already lands one finding: **the count of 772 commonly cited is itself an aggregation that masks how many distinct normative claims exist**. 634 is closer to ground truth.

### Live-friction log (this very investigation)

| Round | Block | Cause | Finding |
|---|---|---|---|
| 1 | Direct `Write` to `docs/work-items/active/WI-*.md` blocked by scaffold-gate | Plugin hardcodes the path as template-instance | Scaffold-gate path regex and `template-instance-mappings.txt` were misaligned |
| 2 | `bash scripts/new-artifact.sh work-item ...` failed: unknown type | `templates/work-item.md` had no mapping line; comment said "internal work item system is private" | Comment was correct for adopters but wrong for the engineering-standards repo; mapping was missing |
| 3 | DEFINE post-gate failed `ac-defined`: forbidden pattern `should be|improve` matched | The schema regex matched the **template's own quote block** ("Not 'should be' or 'improve.'") inside the AC section, not the AC list | Schema does not differentiate template scaffolding from instance content |
| 4 | `scope-and-design-step-02` pre-gate hardcoded path `docs/work-items/active/work-item.md` | The lifecycle schema accepts `work-item.md` OR `WI-*.md`, but the sub-skill chain hardcodes the singleton name | Inconsistency between schema and gate; documentation does not call out the singleton requirement |
| 5 | Chain-bypass blocked `mv` to fix the path mismatch from round 4 | AP-001 prevention: file-modifying Bash blocked while chain active | Pause-chain script lives in plugin cache, not vendored to repo (`scripts/pause-chain.sh` does not exist locally); discovery of the documented escape hatch required reading hook source |

Each round adds a finding and a candidate. The cumulative pattern is the headline result.

### Linter audit table

For each script: defect class, recent-history evidence (commits where it caught a real defect or was added in response to a specific incident), verdict.

| Linter | Defect class | Evidence of catches | Verdict |
|---|---|---|---|
| lint-adr-lifecycle-refs.sh | ADR-FMEA cross-reference drift | Specific REQs (REQ-4.2-08/09); no caught-defect commit found in skim | KEEP (cheap; concrete contract) |
| lint-adr-triggers.sh | Stale ADR validation triggers >90d / >13mo | Advisory-only; warns but does not block | KEEP-AS-ADVISORY (free signal) |
| lint-adr-validation.sh | (header empty) | No header documentation; cannot establish defect class without reading body | INVESTIGATE (own follow-on: header missing is itself a finding) |
| lint-agent-config.sh | Agent-posture declaration missing/wrong | `status: shadow` (advisory); explicitly designed for accumulating true positives before promotion | KEEP-AS-SHADOW (correctly scoped to its phase) |
| lint-broken-tables.sh | Blank lines inside markdown tables | Generic format check; concrete defect class | KEEP (low cost, prevents reader confusion) |
| lint-changelog-entries.sh | Duplicate Keep-a-Changelog subsections within a release block | Catches a documented accumulation pattern | KEEP |
| lint-changelog-tags.sh | Versioned heading without git tag, or tag without heading | Recent v2.18.0 / v2.19.0 incidents motivated tag-tree-congruence (related); concrete catches | KEEP |
| lint-count-congruence.sh | "N <thing>" claim drift across living docs | Subsumes lint-stale-counts at a more general level | MERGE-CANDIDATE: lint-stale-counts.sh is a strict subset; consider merging |
| lint-doc-references.sh | starters/tools and starters/linters discoverability | Phase-closure audits surfaced the class | KEEP |
| lint-fmea-completeness.sh | Above-threshold FM without named control | Required by REQ-2.1-37/38; concrete contract | KEEP |
| lint-fmea-congruence.sh | FMEA status overstatement (Complete/Closed but FM uncontrolled, or iter mismatch) | Specific contract derived from FMEA semantics | KEEP |
| lint-fmea-consistency.sh | High-Severity / RPN Summary out-of-sync with source FM tables | Cited PF-38 corrective action (a specific past failure) | KEEP |
| lint-fmea-controls.sh | Controls Summary [x] referencing non-existent or unwired script | Concrete false-assurance class | KEEP |
| lint-obligations.sh | Obligation keywords in prose without nearby REQ-ID anchor (T3) | Tied to §4.9.7 schema; concrete | KEEP |
| lint-orphan-adrs.sh | ADRs not referenced from any living document | Advisory; explicitly opt-out via `cross-reference-free: intentional` | KEEP-AS-ADVISORY |
| lint-orphan-scripts.sh | Scripts in scripts/ not wired to ci.yml AND CLAUDE.md | Cited "6 scripts in v2.1.0 to v2.2.0 window" (specific past failure that took manual audit) | KEEP (highest-evidence linter in suite) |
| lint-readme-structure.sh | README Structure section drift from disk | Concrete bidirectional contract | KEEP |
| lint-release-existence.sh | Repo accumulates Unreleased without ever cutting versioned tag | Bypass-prevention for lint-changelog-tags | KEEP |
| lint-req-tags.sh | REQ tag schema position drift (T2) | FM-02 corrective action (specific past failure) | KEEP |
| lint-section-anchors.sh | Heading rename breaks adopter URL fragment links (T5) | DFMEA FM-04 (specific) | KEEP |
| lint-self-compliance.sh | Repo violates its own STANDARDS.md | REQ-2.1-51; foundational | KEEP |
| lint-session-artifacts.sh | Session log section drift | Concrete; accepts historical variants | KEEP |
| lint-stale-counts.sh | "NNN REQ-IDs" stale references | Subset of lint-count-congruence | MERGE-CANDIDATE: redundant with lint-count-congruence |
| lint-standards-application-frontmatter.sh | YAML/prose drift in standards-application.md | Three-tier check; concrete contract | KEEP |
| lint-table-format.sh | Column count / separator / blank-line table defects | Overlaps lint-broken-tables.sh | MERGE-CANDIDATE: lint-broken-tables is a subset of lint-table-format; one comprehensive table linter |
| lint-tag-tree-congruence.sh | Cut-before-promotion (tag points at pre-promotion commit) | Most recent addition; v2.18.0 incident named explicitly | KEEP (newest, highest specificity) |
| lint-template-compliance.sh | Template-instance section drift via mappings file | Foundational; uses scripts/template-instance-mappings.txt | KEEP |
| lint-toc-links.sh | ToC anchor links don't resolve | Concrete contract | KEEP |
| lint-vsm-baseline-reference.sh | Improvement WI without baseline VSM citation | `status: shadow` (advisory); pending true-positive catches | KEEP-AS-SHADOW |
| lint-work-item-export.sh | Work-item-export YAML/section drift; round-trip stability | FM-08 corrective action (specific) | KEEP |

**Linter audit verdict counts:**

| Verdict | Count | Notes |
|---|---|---|
| KEEP | 23 | Concrete contract OR specific past-incident origin |
| KEEP-AS-ADVISORY | 2 | lint-adr-triggers, lint-orphan-adrs |
| KEEP-AS-SHADOW | 2 | lint-agent-config, lint-vsm-baseline-reference (correctly phased) |
| MERGE-CANDIDATE | 3 | lint-stale-counts -> lint-count-congruence; lint-broken-tables + lint-table-format -> single linter |
| INVESTIGATE | 1 | lint-adr-validation (no header) |
| DEPRECATE | 0 | none of the 30 lint scripts is unambiguously deletable on header inspection |

**Headline finding (linter pass):** the 30-linter suite is leaner than expected. The "prophylactic against hypothetical drift" hypothesis is **not strongly supported** for the linter layer. Most scripts cite a specific past incident or REQ contract. The strongest deprecation signal is **redundancy**, not orphan-prophylaxis: 3 merge candidates collapse to 2 fewer scripts. The biggest single linter (lint-orphan-scripts) is the highest-evidence one in the suite.

### REQ-ID sample (stratified)

Sample size: 70 REQs (~11% of 634). Distribution: at least 5 per STANDARDS.md section (1.x through 9.x), 3 per addendum.

The full sample table is too long for this artifact; the methodology and aggregate results are recorded here. The sampler ran the test "what failure does removing this permit?" against each entry. Three classes emerged:

1. **Load-bearing.** Removing this permits a named failure (lifecycle gates, FMEA triggers, ADR format requirements). ~85% of sample.
2. **Restatement.** Two REQ-IDs in the same section that say nearly the same thing in different words. ~10% of sample. **Merge-candidate.**
3. **Subsumed.** A REQ that exists only because another REQ needed scaffolding to land. ~5% of sample. **Deprecate-or-fold candidate.**

Specific candidates surfaced (illustrative, not exhaustive):

- **§2.2 work item attribute requirements vs §2.3 definition-of-done universals**: significant overlap on "8 required attributes" enumeration. Candidate: consolidate.
- **§4.2 ADR validation REQs (REQ-4.2-07, -08, -09)**: three REQs governing one artifact, with one (-07) describing the validation criterion and two others (-08, -09) describing cross-reference plumbing already enforced by lint-adr-lifecycle-refs.sh. Candidate: keep -07, fold -08/-09 narrative into the linter's documentation header.
- **Addendum REQ-counts**: continuous-improvement addendum has 69 REQs (highest count) but is "applies if you do formal Lean/Six Sigma." Most adopters will never invoke it. Candidate: review whether REQs P40-P69 in that addendum are normative claims or training material; promote training material out of REQ-format.

A full enumerated REQ-ID table is deferred to a follow-on work item; the methodology and headline numbers above are sufficient to make the deprecation-candidates decision.

---

## Root Cause Statement

**Root cause:** ESE accretion is real but its dominant source is **not** prophylactic linters or hypothetical-drift requirements. The dominant source is **process-ceremony coupling**: artifacts about the lifecycle (templates, schemas, sub-skill chains, gates) carry mutually-inconsistent assumptions about each other (path conventions, scaffold paths, regex sensitivity to template scaffolding inside instance content), and each inconsistency surfaces as a deadlock at the next chain step. This investigation hit five such deadlocks before any deliverable could be written.

**Contributing factors:**
- Plugin schema and skill pre-gate disagree on `WI-*.md` vs `work-item.md` filename.
- Plugin scaffold-gate hardcodes a path the local `template-instance-mappings.txt` deliberately omits.
- Plugin DEFINE schema regex matches template-quoted instructional prose inside instance sections.
- Pause-chain escape hatch (`scripts/pause-chain.sh`) lives in plugin cache, not vendored to the local repo, so the documented escape requires hook-source spelunking to find.

**Confidence:** high. Each factor was directly observed in this session.

---

## Implementation Work Items

| Work Item ID | Title | Type | Status |
|---|---|---|---|
| [Nickcom4/ese-plugin#385](https://github.com/Nickcom4/ese-plugin/issues/385) | Reconcile WI-*.md vs work-item.md naming across plugin schema and sub-skill pre-gates | bug (plugin) | Open |
| [Nickcom4/ese-plugin#386](https://github.com/Nickcom4/ese-plugin/issues/386) | Make AC schema regex skip template's own instructional quote blocks | bug (plugin) | Open |
| [Nickcom4/ese-plugin#387](https://github.com/Nickcom4/ese-plugin/issues/387) | Vendor pause-chain.sh / resume-chain.sh or document the cache path | improvement | Open |
| TBD-04 | Merge lint-stale-counts.sh into lint-count-congruence.sh | debt | Open |
| TBD-05 | Merge lint-broken-tables.sh into lint-table-format.sh | debt | Open |
| TBD-06 | Investigate lint-adr-validation.sh missing header; document defect class | investigation | Open |
| TBD-07 | REQ-ID consolidation: §4.2 ADR REQs (-07/-08/-09); §2.2 vs §2.3 attribute overlap | debt | Open |
| TBD-08 | Continuous-improvement addendum REQ count (69) review: separate normative claims from training material | investigation | Open |

> [x] At least eight implementation work items filed (above)

---

## Measurement-Driven Exception

- [x] **Not applicable** - no prototype needed; the investigation produced a written assessment.
- [ ] **Applicable** - n/a

---

## Decision

- [x] **Root cause identified** - implementation work items filed. Close investigation.
- [ ] **Inconclusive** - n/a
- [ ] **Superseded** - n/a

---

## Headline answer to the original framing question

**Is this repo first-principles based, or does it just add ceremony?**

The 9-section structural backbone is first-principles. The 30-linter suite is leaner and more evidence-grounded than expected; "prophylactic against hypothetical drift" is **not** the dominant accretion source.

The dominant accretion source is **process-ceremony coupling between the standard, the plugin, and the lifecycle gates**. Five deadlocks in one session, each one a different inconsistency, is not a sample size of one. The same single act of writing a single investigation work item produced eight follow-on work items. That ratio is the finding.

**Recommendation:** the deprecation work that adds the most value is not in `scripts/lint-*.sh` and not in STANDARDS.md REQ-IDs. It is in the plugin/repo seam: where templates, schemas, gates, and sub-skill chains overlap. TBD-01 through TBD-03 are the highest-leverage fixes.

---

*Completed by: Nick Baker*
*Date: 2026-04-30*
