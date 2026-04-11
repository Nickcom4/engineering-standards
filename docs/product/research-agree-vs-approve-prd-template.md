# Research: Agree vs Approve in PRD Template

**Date:** 2026-03-23
**Status:** Complete; recommendation below; implementation work item filed

---

## Table of Contents

- [Problem](#problem)
- [Analysis](#analysis)
- [Recommendation](#recommendation)
- [Implementation](#implementation)
- [Conclusion](#conclusion)

---

## Problem

`templates/prd.md` uses an "Agreement" section with multi-party sign-off lines:

```
- [ ] Product agreed - {name, date}
- [ ] Engineering agreed - {name, date}
- [ ] Design agreed (if applicable) - {name, date}
```

For single-operator projects, this is semantically incorrect. A single person cannot "agree" with themselves; they make a decision. They approve or reject. Using "agreed" for solo decision-making obscures gate authority and makes the document feel like a compliance exercise rather than a deliberate checkpoint.

---

## Analysis

### ESE §1.4 Gate Authority

> "For ESE itself, the person who owns the standard is the gate authority: changes to the standard require their explicit review before merge."

Gate authority is singular and named. The ESE framing is approval (one person with authority), not agreement (multiple parties reaching consensus).

### Agreement vs Approval

| Context | Correct term | Why |
|---|---|---|
| Single operator | **Approval** | One person with gate authority; they decide yes/no |
| Multi-party teams | **Agreement** or **Sign-off** | Multiple stakeholders reach consensus |
| Mixed (PM + eng lead) | **Approval** per role | Each approver approves from their domain |

### Framework Precedents

- **ISO 9001** uses "approval" throughout for document control: a named approver, not consensus
- **RACI models** separate Responsible (does the work) from Accountable (approves) from Consulted/Informed; approval is singular
- **Product frameworks (dual-track, Shape Up)** use "bet" or "approve" for scope decisions: language of decision, not consensus

### Recommendation

**Change the prd-template.md Agreement section to Approval.** The pattern should be:

```markdown
## Approval

> For single-operator projects: the gate authority approves the PRD as complete and ready for implementation. For multi-party projects: each stakeholder approves from their domain (product, engineering, design).

- [ ] Approved - {name, role, date}
```

This:
- Works correctly for single-operator (one approval line)
- Works correctly for multi-party (multiple approval lines, one per domain)
- Aligns with ESE §1.4 language ("gate authority")
- Makes the PRD a deliberate checkpoint, not a sign-off ritual

**Same change needed in `templates/capabilities.md`** if an Agreement section exists there.

---

## Implementation

File a work item to update `prd-template.md` and check `capabilities-template.md` for the same pattern.

This is a templates-only change. No STANDARDS.md update needed; the principle is already correct in §1.4.

---

## Conclusion

The template should use "Approval" not "Agreement." Agreement is multi-party consensus language. Approval is gate authority language, correct for both single-operator and multi-party contexts. The gate authority structure ESE §1.4 already describes is approval, not agreement.
