<!-- template-compliance: historical-exempt -->
<!-- Reason: historical product requirements document from the v1.x era machine-readable-first restructuring work. Written before templates/prd.md was expanded to its current 14-section form; uses the earlier three-section shape (Scope, Requirements, Acceptance Criteria). The requirements this document defined shipped with ADR-2026-03-25-ese-machine-readable-first-format and the v2.0.0 restructuring release. Frozen as a historical artifact per the content-boundary convention; not retroactively restructured. -->

# PRD: ESE Machine-Readable-First Restructuring

> §1.2 Step 3 - PRD for the ESE machine-readable-first restructuring.
> Requires agreed capabilities: [capabilities-ese-machine-readable-first.md](capabilities-ese-machine-readable-first.md)
> Gate: gate authority approval required before architecture/ADRs begin.

---

## Scope

**IN SCOPE:**
- Restructure all STANDARDS.md sections (§1-§9) to machine-readable-first format: inline REQ-IDs as named HTML anchors, inline tag schema, one requirement per addressable unit
- Restructure all 7 addenda to machine-readable-first format with REQ-ADD-{CODE}-{seq} IDs
- Update all 15 templates and 8 starters with YAML frontmatter (lifecycle stage, applicable types, REQ-IDs implemented)
- Deprecate sequential ADR/FMEA/EVAL naming; adopt date-based as sole convention
- Build enforcement-spec.yml generator that reads STANDARDS.md gate-kind requirements
- Update requirement-index.md as generated view
- Update adoption.md for new structure
- Define portable work item record format, directory structure, naming convention, file-when-produced protocol, and data store model
- Resolve 5 original ESE gaps (§1.5 external imposition, §2.2 machine-derived rule quality, pi-operating-principles §4 threshold delegation, §4.2 Per-Document Impact Analysis, enforcement-spec schema documentation)
- Add §2.1 re-entry triggers
- Add §2.2 edge case AC requirement

**OUT OF SCOPE:**
- Changing any requirement's substance - restructuring makes requirements addressable, not different
- §1.2 progression documents for other projects (this PRD governs ESE itself only)
- Tracked system implementation details beyond what ESE specifies
- Changes to bd tool internals
- Changes to existing work item IDs
- Governance of requirements outside §1-§9 and 7 addenda (e.g., docs/adoption.md content beyond navigation updates)

---

## Requirements

### Format and Addressability

**REQ-PRD-01** Every discrete, binary, observable requirement in STANDARDS.md §1-§9 is expressed as a named HTML anchor + bold REQ-ID + inline tags + one-sentence statement. Verified: `grep -c '<a name="REQ-' STANDARDS.md` returns count matching total requirement units.

**REQ-PRD-02** Inline tag schema is: `kind` (gate|artifact|advisory), `scope` (ESE lifecycle stage name), `enforcement` (hard|soft|none), `applies-when` (all|type:{name}|addendum:{code}|compound). Verified: linter validates all four tags present on every REQ-ID block.

**REQ-PRD-03** REQ-IDs follow `REQ-{section}-{seq:02d}` for base sections and `REQ-ADD-{CODE}-{seq:02d}` for addenda (codes: WEB, AI, CI, EVT, MS, CTR, MT). No two requirements share an ID. Verified: `grep -o 'REQ-[A-Z0-9.-]*' STANDARDS.md | sort | uniq -d` returns empty.

**REQ-PRD-04** Every named anchor creates a navigable URL fragment. `STANDARDS.md#REQ-2.2-01` resolves to the correct requirement in GitHub-rendered markdown. Verified: spot-check 10 REQ-IDs via browser navigation.

### Completeness

**REQ-PRD-05** After restructuring, a tool reading §2.1, §2.2 type taxonomy, and all applicable addendum sections can determine the complete artifact set for any type+addenda combination without cross-section inference. Verified: repeat the 12-requirement proof for type=improvement + web + CI against restructured STANDARDS.md; all 12 must be findable from structured tags alone.

**REQ-PRD-06** All 7 addenda contain self-contained REQ-ADD-{CODE} structured requirements. §2.1 Per-Stage table is updated to reference these REQ-IDs rather than prose descriptions. Verified: `grep -c 'REQ-ADD-' docs/addenda/*.md` returns non-zero for all 7 files.

### Generated Outputs

**REQ-PRD-07** enforcement-spec.yml is generated (not maintained) from all kind=gate REQ-IDs in STANDARDS.md. Running the generator after any STANDARDS.md edit produces a current spec. Verified: modify one gate requirement, run generator, confirm enforcement-spec.yml reflects the change.

**REQ-PRD-08** requirement-index.md is generated (not maintained) from structured STANDARDS.md requirements. Verified: modify one requirement, run generator, confirm requirement-index.md reflects the change.

### Naming Convention

**REQ-PRD-09** Sequential ADR/FMEA/EVAL naming (`ADR-NNN`) is no longer a permissible option in the standard. Date-based (`ADR-YYYY-MM-DD-title.md`) is the sole convention. ESE's own existing ADR-001 through ADR-021+ are legacy; standards-application.md documents the legacy status. Verified: `grep -n "sequential\|ADR-{NNN\|alternative.*sequential" STANDARDS.md` returns zero matches in the normative text.

### Templates and Starters

**REQ-PRD-10** All 15 templates contain YAML frontmatter documenting: lifecycle stage(s), applicable work item types, REQ-IDs the template implements. Verified: `grep -l "^---" templates/*.md | wc -l` returns 15; each frontmatter contains `stage`, `applies-to`, `implements` fields.

**REQ-PRD-11** All 8 starters contain YAML frontmatter documenting: purpose, one-time vs. recurring. Verified: `grep -l "^---" starters/*.md | wc -l` returns 8.

### Work Item Accessibility

**REQ-PRD-12** ESE specifies one portable work item record format that travels with a repo across domain transitions. The format is queryable by REQ-ID, work item type, and date without running any project-specific tool. Verified: query the format for "all work items satisfying REQ-2.2-01" using only standard tooling.

**REQ-PRD-13** ESE specifies the file-when-produced protocol: which artifact is committed at which lifecycle stage. No artifact is deferred to close unless it cannot exist before close by definition (gate evidence). Verified: read the protocol table and confirm every stage has an explicit commit trigger.

**REQ-PRD-14** Work item IDs in committed records are system-native (whatever the team's tracked system assigns). REQ-IDs are the universal cross-system identifiers linking work items to requirements. Verified: example JSONL/record shows system-native ID field alongside req-ids field.

### Lifecycle Completeness

**REQ-PRD-15** §2.1 defines explicit re-entry triggers for at least 3 common scenarios where a later stage discovers a gap in an earlier stage. Verified: `grep -i "re-entry\|go back\|return to" STANDARDS.md` returns the new text.

**REQ-PRD-16** §2.2 requires at least one edge case, failure, or boundary condition AC item for feature/epic work items. Verified: requirement text present in §2.2; gate REQ-ID assigned.

### ESE Gap Resolutions

**REQ-PRD-17** §1.5 updated with explicit guidance on applying ESE-derived rules to repos that have not adopted ESE. Verified: `grep "external imposition\|non-adopting" STANDARDS.md` returns new text.

**REQ-PRD-18** pi-operating-principles §4 updated on threshold-based gate-authority delegation. Verified: grep confirms new text.

**REQ-PRD-19** §2.2 updated with machine-derived rule quality standard (threshold/validation requirement before activation). Verified: grep confirms new text.

**REQ-PRD-20** §4.2 updated with explicit decision on Per-Document Impact Analysis (required or explicitly not required with rationale). Verified: read §4.2.

### Verification

**REQ-PRD-21** VERIFY checklist passes for all modified files: zero em dashes, all links resolve, no formatting defects, all cross-references are hyperlinks, CHANGELOG entry written. Verified: ESE preshipment check script returns zero violations.

---

## Acceptance Criteria (summary, binary)

Done when all REQ-PRD-01 through REQ-PRD-21 pass. Key verification commands:

```bash
# REQ-PRD-03: no duplicate REQ-IDs
grep -o 'REQ-[A-Z0-9.-]*' STANDARDS.md | sort | uniq -d

# REQ-PRD-05: three-layer inference proof passes against restructured STANDARDS.md
# (manual: repeat 12-requirement type=improvement+web+CI test)

# REQ-PRD-07: enforcement-spec.yml freshness
# (run generator after STANDARDS.md edit; confirm output updated)

# REQ-PRD-21: preshipment check
bash ./scripts/ese_preshipment.sh
```

---

*Date: 2026-03-25*
*Status: Draft - gate authority approval required before DESIGN begins*
