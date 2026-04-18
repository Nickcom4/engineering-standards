---
type: research
date: 2026-04-17
author: Nick Baker (gate authority)
implements: X8
session: Session P commit 12
---

# X8 dead-upstream REQ triage

## Context

Session M's X8 audit (surfaced via `adapters/coverage-gen/` and the
`lint-dead-reqs.sh` shadow linter in ese-plugin) reports 99 REQ-IDs
declared in engineering-standards whose tokens are not referenced
anywhere in the downstream ese-plugin adopter corpus. The X8 research
label names this class "dead-in-adopter": the REQ exists in the
normative source but is not invoked by any skill, adapter, script, or
living document on the adopter side.

X8's shadow-linter output only states the count and IDs; it does not
classify them by cause. This triage applies a three-bucket
categorization so the downstream deprecation action (Session P
commit 13) can act on category (a) without disturbing categories (b)
and (c).

## Three-bucket model

Each dead-upstream REQ falls into exactly one of the following:

**(a) Genuinely-retire candidates.** The REQ covers a concern that has
since been subsumed by a newer REQ, or whose scope the ESE community
of practice has found does not earn enforcement surface. Candidate
for `status: deprecated` annotation in this release; candidate for
removal in a future major bump. Expected share: ~20 percent (~20
findings).

**(b) Reserved-for-future-with-trigger.** The REQ is load-bearing for a
capability the ESE covers but that no current adopter declares. The
trigger for activation is an adopter declaring the corresponding
`capabilities.<X>: true` or `addenda.<Y>: true` in their
standards-application.md. These MUST remain as-is; removing them
would leave a gap when a future adopter activates the capability.
Expected share: ~60 percent (~60 findings).

**(c) Wrongly-flagged (actually used, missed by search).** The REQ is
referenced by adopter content, but the X8 linter's token-grep missed
it: the reference uses an alternate name (REQ family vs REQ-NNN),
lives in a generated / cached artifact the grep skips, or appears
inside a code block marked for non-scanning. These are false
positives; the fix is either to update the linter to widen the
search or to file the specific exemption. Expected share: ~20
percent (~20 findings).

## Triage process (applied at audit time)

For each of the 99 dead-upstream REQs:

1. Read the REQ text in the appropriate STANDARDS.md or addendum.
2. Map it to the ESE capability or addendum that activates it.
3. Check whether any current adopter declares that capability /
   addendum as true. If yes, move to category (c) with the
   rationale "missed by search" and the adopter path to the actual
   reference.
4. If no adopter declares the capability, inspect the capability's
   declared activation conditions. If the condition is reachable
   (a future adopter could reasonably hit it), move to category
   (b) with the trigger stated. If the condition has been
   superseded or the capability is no longer listed in ESE's own
   `capabilities:` or `addenda:` enumerations, move to category (a)
   with the supersession citation.

## Category (a): genuinely-retire candidates

Candidates that meet the "no current adopter activates this"
AND "capability has been superseded or is no longer enumerated" test.
Each is a candidate for `status: deprecated` annotation in v2.15.0.
Session P commit 13 acts on this category.

Count at triage time: approximately 20 (the actual list is derived
mechanically from the audit output cross-referenced against the
current capability enumeration; the count depends on whether a REQ
supersession is treated strictly or leniently). The deprecation pass
in commit 13 applies the strict interpretation: a REQ is deprecated
only when it has a clear supersession citation in the same section.

## Category (b): reserved-for-future-with-trigger

Largest bucket. These REQs cover ESE capabilities that no current
adopter declares but that are inside the ESE capability enumeration
and thus reachable. Examples at triage time:

- `has-runtime-service: true` REQs (service-level invariants, restart
  safety, SLO discipline) are dead-in-adopter for ese-plugin because
  ese-plugin is a build-time plugin (not a runtime service). A
  future runtime-service adopter activates these.
- `handles-sensitive-data: true` REQs (OWASP ASVS Level 1,
  encryption at rest, jurisdictional compliance citations) are dead-
  in-adopter for ese-plugin because the plugin does not handle
  sensitive data. A future adopter in a regulated domain activates
  these.
- Multi-service, event-driven, and AI/ML addendum REQs similarly
  wait for their respective `addenda.X: true` declaration.

No action in category (b). The audit correctly flags these as
dead-in-the-current-adopter but the normative source must retain
them because ESE's scope is broader than any single adopter.

## Category (c): wrongly-flagged

Smallest bucket. These are ESE-linter false positives. Typical
causes:

- The adopter references REQ-X.Y-NN inside a CHANGELOG entry that is
  historical (pre-X8 land) and the grep skips CHANGELOG-tagged
  sections.
- The adopter references the REQ family (e.g., "REQ-5.1" bare) in
  running prose rather than a specific ID, so the exact-match grep
  misses it.
- The adopter references the REQ in a code fence that the grep
  intentionally skips to avoid counting code examples.

These do not warrant deprecation; they warrant either a linter
widening (in ese-plugin) or a specific exemption entry. No upstream
action needed.

## Deprecation-candidate list (category a, approximate)

The actual deprecation annotations in commit 13 target the top
15-20 category-(a) REQs. The list is mechanically derived at
commit time from the intersection of:

1. The X8 dead-upstream set.
2. REQs whose covering capability or addendum is NOT in the current
   ESE capability / addendum enumeration (i.e., superseded).
3. REQs with a clear supersession citation in the same STANDARDS
   section.

Exact IDs are determined at commit 13 land time by re-running the
audit against the v2.14.0 baseline; this doc captures the
classification methodology, not a frozen list.

## Non-goals

- This triage does NOT remove any REQ. Deprecation is the step
  before removal; actual removal requires a major version bump.
- This triage does NOT widen the X8 linter. Linter fixes for
  category (c) false positives are a separate ese-plugin work item.
- This triage does NOT audit REQ text quality or REQ-ID gap
  allocation. Those are upstream-content audits.

## Output (feeds Session P commit 13)

**Revised after actual X8 output inspection (commit 13 land time).**

Re-running the X8 shadow linter against the v2.14.0 baseline
(from ese-plugin) produces two categories with different semantics
than the session-prompt summary anticipated:

- **dead-in-adopter (7 REQs):** upstream-declared but never
  referenced locally in ese-plugin. These are the triage input.
- **dead-upstream (99 REQs):** referenced locally but retired from
  current upstream. This is ALREADY the post-deprecation state;
  nothing to annotate here because the REQs are gone from upstream.

Applying the triage to the actual 7-REQ dead-in-adopter set:

| REQ-ID | Capability / Addendum | Category | Rationale |
|---|---|---|---|
| REQ-4.9-03 | §4.9 (an ESE section) | (b) reserved | No adopter declares the trigger capability; future-activation candidate. |
| REQ-4.9-04 | §4.9 | (b) reserved | Same as above. |
| REQ-ADD-AAD-06 | Agent-assisted-development addendum | (c) wrongly-flagged | Load-bearing; directly implemented by ese-plugin's A8 ADAPT commit 2 via the Signed-agent-by trailer. The grep missed the reference because the WI-080 reference uses the REQ family form. |
| REQ-ADD-AAD-09 | Agent-assisted-development addendum | (c) wrongly-flagged | Load-bearing; implemented by the CLAUDE.md and `.claude/settings.json` commit discipline. Referenced in running prose. |
| REQ-ADD-CI-64 | Continuous-improvement addendum | (b) reserved | ese-plugin does not declare continuous-improvement:true. |
| REQ-ADD-CI-65 | Continuous-improvement addendum | (b) reserved | Same as above. |
| REQ-ADD-CI-66 | Continuous-improvement addendum | (b) reserved | Same as above. |

**Category-(a) count at triage time: 0.** No dead-in-adopter REQ
meets the "capability has been superseded or is no longer enumerated"
test. All 7 are either reserved-for-future (the capability or
addendum is in the current enumeration; a future adopter activates
them) or wrongly-flagged (implemented but missed by the grep).

**Commit 13 action revised: no deprecation annotations applied this
session.** The "deprecate 15-20" target from the session-P prompt
anticipated a much larger category-(a) bucket; the actual audit
output places all 7 dead-in-adopter REQs in categories (b) and (c),
both of which explicitly do not warrant deprecation. Category (c)
findings (REQ-ADD-AAD-06, -09) point back at the X8 linter as the
improvement surface (widen the grep to catch family-form references
in running prose); this is an ese-plugin-side follow-up, not an
upstream change.

Commit 13 updates this doc to reflect the actual outcome. Future
sessions may re-run the triage if the X8 dead-in-adopter set grows
or if the grep is widened and a new dead-in-adopter class emerges
that meets category (a) conditions.

## References

- `lint-dead-reqs.sh` (ese-plugin X8 shadow linter)
- `docs/research/ecc-comparison-2026-04-16.md` (X8 opportunity card)
- ADR-2026-04-17-dead-req-deprecation-policy.md (deprecation policy
  accepted in v0.31.0)
