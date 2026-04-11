<!-- template-compliance: historical-exempt -->
<!-- Reason: historical product capabilities document from the v1.x era machine-readable-first restructuring work. Written before templates/capabilities.md was expanded to its current nine-section form. The decisions this document drove shipped with ADR-2026-03-25-ese-machine-readable-first-format and the v2.0.0 restructuring release. Frozen as a historical artifact per the content-boundary convention; not retroactively restructured. -->

# Capabilities: ESE Machine-Readable-First Restructuring

> §1.2 Step 2 - Capabilities document for the ESE machine-readable-first restructuring.
> Requires completed problem research: [problem-research-ese-machine-readable-first.md](problem-research-ese-machine-readable-first.md)
> Input to PRD: [prd-ese-machine-readable-first.md](prd-ese-machine-readable-first.md)
> Gate: gate authority agreement required before PRD work begins.

---

## What practitioners will be able to DO

### C-1: Determine complete artifact requirements for any work item without cross-section reading
A practitioner with a work item of known type and known addenda context can read one location in STANDARDS.md and find the complete list of required artifacts for every lifecycle stage - including base stage requirements, type-conditional requirements (from §2.2), and addenda requirements (from all applicable addenda). No cross-referencing required.

### C-2: Address any individual ESE requirement by URL fragment
Every discrete requirement in STANDARDS.md has a permanent, stable URL fragment identifier (REQ-{section}-{seq}). A practitioner, commit message, work item, or tool can reference `STANDARDS.md#REQ-2.2-01` and navigate directly to the exact requirement. No section-level searching.

### C-3: Run automated compliance checks covering structural requirements deterministically and qualitative requirements with bounded LLM evaluation
A tool reading STANDARDS.md and all 7 addenda evaluates structural requirements (presence, format, pattern matching, count, character length) deterministically - no inference. Qualitative requirements (title clarity, AC observability, close-reason coherence) use G-Eval criterion decomposition with bounded LLM scoring at F1 ≥ 0.85 on labeled examples. When the LLM is unavailable, qualitative gates fail open - no gate silently blocks work due to LLM unavailability. Coverage target: 200+ deterministic gates; 100+ LLM-evaluated gates. Current ceiling: 31 hand-maintained gates covering structural checks only.

### C-4: Generate enforcement-spec.yml automatically from STANDARDS.md
When STANDARDS.md is updated (requirement added, modified, or removed), enforcement-spec.yml regenerates from the structured requirements. No parallel maintenance. No divergence. The file is always current by construction.

### C-5: Query work item intent and gate evidence for any repo without a running tracked system
The committed portable work item record answers questions that no other existing artifact answers: what were the acceptance criteria before BUILD began? What gate evidence proved this work done at close? Which REQ-IDs did this work item satisfy? What type and class of service was assigned and why?

This is distinct from - and not a substitute for - three other artifact types that answer different questions:
- **Git commit history** (`git log`): what code changed, when, by whom. Does not record intent, AC, or gate evidence.
- **CHANGELOG**: what was released at version granularity. Does not record individual work item scope, dependencies, or per-item gate evidence.
- **ADRs, FMEAs, post-mortems**: why architectural decisions were made, what risks were assessed, what failures occurred. Do not record per-work-item AC or lifecycle status.

All four answer different questions. None substitutes for another. The portable work item record is the missing fourth artifact that makes the full lifecycle auditable from the repository alone.

### C-6: Transfer work item history across domain transitions without loss
When a repo leaves the tracked system's domain, its complete work item history exports to a portable committed format. When the repo returns, the tracked system imports that history and resumes. Multiple transitions are additive - history accumulates across all domain periods. No gaps.

### C-7: Adopt ESE with any work item system
A team using GitHub Issues, Linear, Jira, Shortcut, or no tracked system can satisfy all ESE work item accessibility requirements. System-native IDs (``#1047``, ``ENG-1047``) are valid. REQ-IDs are the universal cross-system identifiers that link work items to requirements regardless of tool.

### C-8: Navigate the lifecycle without re-reading the standard
A practitioner at any lifecycle stage sees - in one table - the artifacts required at that stage, the addenda requirements that activate, and the entry condition. No back-and-forth across sections for a specific type+addenda context.

### C-9: Know when the standard re-applies after leaving a lifecycle stage
When BUILD discovers DEFINE was incomplete, or VERIFY reveals DESIGN was wrong, the standard explicitly names the re-entry trigger and the correct path back. No implicit expectation that practitioners "know" to go back.

### C-10: Detect the absence of failure/boundary acceptance criteria for feature/epic work items
The standard requires at least one acceptance criterion covering a failure condition, edge case, or boundary input for feature/epic work items. A gate detects the *absence* of any such criterion - a signal that failure coverage was not considered. Absence detection is deterministic and requires no inference.

This capability is not validation of AC quality. A gate cannot determine whether a provided edge-case criterion is meaningful, observable, or well-scoped - that requires human review. Presence detection is a necessary signal, not a sufficient one. Human review remains the mechanism for AC quality assessment.

### C-11: Enforce §1.2 document progression as a machine-checkable DESIGN gate
For work items whose declared metadata indicates significant scope (type=epic, or work item has child items, or a practitioner-declared scope indicator), the existence of completed §1.2 progression documents with recorded gate authority approval is a machine-checkable precondition before DESIGN-stage activities begin. The gate is deterministic - it checks for the presence of required documents and an approval record, not for their quality. This makes §1.2 compliance verifiable rather than advisory.

The gate trigger is keyed on explicit declared metadata, not inferred significance. A practitioner who classifies a work item as an epic or declares child items accepts that §1.2 is required. A practitioner who does not make either declaration proceeds without the §1.2 gate. This avoids inference while enforcing the progression for work items where scope warrants it.

---

## What automated tools will be able to DO

### C-11: Parse STANDARDS.md to extract a complete requirement set for any scenario
Given: work item type + active addenda list. Output: complete set of required artifacts and enforcement gates per lifecycle stage. No LLM required. Deterministic.

### C-12: Validate STANDARDS.md structural compliance
A linter can verify: every requirement block has a valid REQ-ID, all four inline tags are present and valid, prose blocks contain no embedded requirement-like statements without REQ-IDs, addenda cross-references are consistent.

### C-13: Import repo work item history on re-entry
The tracked system reads the portable committed format from a returning repo and reconstructs the full work item history in its data store. New work appends to the existing record.

---

## What this does NOT enable (explicit non-capabilities)

- Does not mandate a specific work item tracking tool - any tool satisfying §2.2 attributes is valid
- Does not automate the writing of acceptance criteria - practitioners write AC; gates validate it
- Does not cover §1.2 product progression documents (problem-research, capabilities, PRD) with REQ-IDs - those are narrative documents, not enforcement gates
- Does not change any requirement's substance - restructuring makes existing requirements addressable, not different

---

*Date: 2026-03-25*
*Agreed by: [gate authority approval required before PRD begins]*
