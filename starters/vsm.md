---
type: starter
purpose: "Value stream mapping baseline archive convention"
frequency: per-improvement-arc
---

# Value Stream Mapping: Baseline Archive Convention

<a name="REQ-STR-54"></a>
**REQ-STR-54** `advisory` `continuous` `soft` `addendum:CI`
Archive convention for value stream maps supporting improvement work items. Required by [§2.6](../STANDARDS.md#26-delivery-cadence) and [REQ-ADD-CI-01](../docs/addenda/continuous-improvement.md).

> Archive convention for value stream maps supporting improvement work items. [REQ-ADD-CI-01](../docs/addenda/continuous-improvement.md) requires the current-state map to draw from at least 10 completed work items before optimization. Without an on-disk archive of each baseline, cross-cycle comparison is not possible and improvement claims cannot be verified against a prior measurement. This starter documents the directory convention, the citation rule for `type:improvement` work items, and how the enforcement linter reads those citations.

---

## Table of Contents

- [Directory Convention](#directory-convention)
- [When an Improvement Work Item Must Cite a Baseline VSM](#when-an-improvement-work-item-must-cite-a-baseline-vsm)
- [Citation Format in the Dependencies Table](#citation-format-in-the-dependencies-table)
- [How the Linter Reads References](#how-the-linter-reads-references)
- [Enforcement Posture](#enforcement-posture)
- [Creating a New VSM](#creating-a-new-vsm)

---

## Directory Convention

Archive every value stream map under:

```
docs/improvement/vsm/VSM-YYYY-MM-DD-<slug>.md
```

One file per mapping exercise. The date in the filename is the current-state-as-of date, not the date the file was committed. Do not overwrite prior maps; each is a snapshot. When a later map supersedes an earlier one, set `Status: superseded` in the earlier file and cite the successor path in its `Supersedes:` field.

The archive is part of the project repository, not an external tool. Linter-based enforcement assumes the archive is reachable by relative path from the repo root.

---

## When an Improvement Work Item Must Cite a Baseline VSM

A `type: improvement` work item must cite a baseline VSM in its Dependencies table when the improvement claim rests on a before-and-after comparison of delivery stages. In practice, that covers every improvement initiative scoped against §2.6 delivery cadence or continuous-improvement addendum work, since the improvement is only verifiable against a measured baseline.

The citation is required at DEFINE (when the work item's acceptance criteria are written), not at CLOSE. Writing acceptance criteria such as "reduce PR review wait from 1.5 days to 4 hours" presumes a baseline exists; the citation makes that baseline auditable.

A work item whose improvement claim does not rest on a stage-to-stage comparison is exempt. In that case, the Dependencies table does not cite a VSM and the linter does not flag it (the linter scans only items whose frontmatter declares `type: improvement`).

---

## Citation Format in the Dependencies Table

The work item's Dependencies table has three columns: Dependency, Type, Status. Cite the VSM by its relative path:

```
| Dependency | Type | Status |
|---|---|---|
| docs/improvement/vsm/VSM-2026-04-16-pr-review-queue.md | triggered-by | closed |
```

The `Dependency` cell contains the relative path. The `Type` cell uses `triggered-by` (the baseline surfaced the bottleneck this improvement addresses); `blocks` is not appropriate because a VSM archive does not block progress. The `Status` cell reflects the VSM's own Status field (`closed` for a completed baseline; `open` for an in-progress mapping that has not yet been archived).

A work item may cite more than one VSM: one for the current-state baseline and another for the intended future-state reference if both exist. The linter verifies that at least one citation resolves to an existing file under `docs/improvement/vsm/`.

---

## How the Linter Reads References

`scripts/lint-vsm-baseline-reference.sh` (internal to ESE) and `starters/linters/lint-vsm-baseline-reference.sh` (parameterized for adopter repos) implement the same algorithm:

1. Scan all files matching the work-items glob (default: `docs/work-items/**/*.md`).
2. For each file whose YAML frontmatter declares `type: improvement`, parse the Dependencies table.
3. For each row, check whether the Dependency cell contains a relative path beginning with `docs/improvement/vsm/`.
4. If at least one such row exists AND the referenced file exists on disk, the work item passes.
5. If no such row exists OR the cited path does not resolve, the linter reports the work item name and the missing or unresolvable path.

The linter is silent when the repository has no `type: improvement` work items; it does not flag absence in the general case.

---

## Enforcement Posture

The linter lands in `# status: shadow` on first introduction. A shadow linter runs in CI and records its output for auditability but does not block the build. Promotion to gate status is evidence-based and is made by the gate authority after the shadow phase accumulates true-positive catches and zero false-positive patterns. The promotion changes the header comment from `# status: shadow` to `# status: gate` and adjusts CI to treat the linter's exit code as blocking.

The shadow-first posture is consistent with the engineering-standards policy adopted for new linter classes: an initial quiet period ensures the rule beds in before enforcement begins.

---

## Creating a New VSM

Use the scaffolding tool:

```
bash scripts/new-artifact.sh vsm "PR review queue baseline 2026-04"
```

The tool reads `scripts/template-instance-mappings.txt`, copies `templates/vsm.md` to `docs/improvement/vsm/VSM-YYYY-MM-DD-pr-review-queue-baseline-2026-04.md`, and pre-fills the date, title, and owner. Fill the remaining `{...}` placeholders by hand: the observations table must contain at least 10 rows sourced from completed work items, and the bottleneck identification must name the three largest wait times with evidence.

Commit the VSM in the same commit as the improvement work item that cites it (or in the preceding commit if the work item is filed later). Run `bash scripts/lint-template-compliance.sh` to verify the VSM's section structure matches the template, and run `bash scripts/lint-vsm-baseline-reference.sh` to verify the work-item-to-VSM citation resolves.
