---
type: draft
status: pending-gate-authority-approval
reviewed-by: G-Eval 23/23 PRD-derived criteria
---

# Draft: STANDARDS.md §4.9 Machine-Readable Requirement Format

This file contains only the normative text planned for STANDARDS.md §4.9.
No implementation notes. No migration guidance. No references to files that do not yet exist.
Those belong in the ADR, FMEA, or work session log.

Gate authority approval required before this content is written to STANDARDS.md.

---

## Table of Contents

- [4.9.1 Requirement Unit Format](#491-requirement-unit-format)
- [4.9.2 Inline Tag Schema](#492-inline-tag-schema)
- [4.9.3 Eval-Scope (5th Token)](#493-eval-scope-5th-token)
- [4.9.4 Applies-When Grammar](#494-applies-when-grammar)
- [4.9.5 REQ-ID Scheme](#495-req-id-scheme)
- [4.9.6 Immutability Rule](#496-immutability-rule)
- [4.9.7 Prose vs. Requirement Distinction](#497-prose-vs-requirement-distinction)
- [4.9.8 Line Count Ceiling](#498-line-count-ceiling)

---

### 4.9 Machine-Readable Requirement Format

This section defines the canonical format for expressing enforceable requirements in
STANDARDS.md and its addenda. Structured requirement units enable linters, generators,
and enforcement tools to parse, validate, and cross-reference gates without reading
surrounding prose.

#### 4.9.1 Requirement Unit Format

Each requirement unit is exactly three lines. No additional lines appear within a unit.
Blank lines separate consecutive units.

```
<a name="REQ-2.2-01"></a>
**REQ-2.2-01** `gate` `define` `hard` `all` `per-item`
A work item title states what is wrong and what correct looks like.
```

- **Line 1:** HTML anchor: `<a name="{REQ-ID}"></a>`
- **Line 2:** Bold REQ-ID followed by four or five space-separated backtick-wrapped tokens
- **Line 3:** One binary, observable, present-tense statement with no sub-clauses

#### 4.9.2 Inline Tag Schema

| Position | Name | Valid values | Required for |
|---|---|---|---|
| 1 | `kind` | `gate` \| `artifact` \| `advisory` | all |
| 2 | `scope` | `discover` \| `define` \| `design` \| `build` \| `verify` \| `document` \| `deploy` \| `monitor` \| `close` (ESE §2.1 lifecycle stages) \| `commit` \| `session-start` \| `session-end` \| `continuous` (enforcement system extensions; see §4.9.2 note) | all |
| 3 | `enforcement` | `hard` \| `soft` \| `none` | all |
| 4 | `applies-when` | `all` \| `type:{name}` \| `addendum:{code}` \| compound expression (§4.9.4) | all |
| 5 | `eval-scope` | `per-item` \| `per-section` \| `per-artifact` \| `per-commit` | `kind:gate` only |

`kind` semantics: `gate` blocks lifecycle progression when the condition fails; `artifact`
requires a produced document or named output; `advisory` is informational with no automated
block. `enforcement` semantics: `hard` requires tooling to block on failure; `soft` produces
a warning without blocking; `none` is informational only and carries no runtime enforcement.

The four scope values without an ESE §2.1 counterpart are enforcement-system extensions:
`commit` applies at pre-commit hook execution; `session-start` applies when a work session
begins; `session-end` applies when a work session ends; `continuous` applies at all times
regardless of lifecycle stage. Adopters providing their own enforcement must implement
equivalent hooks for these four values.

Positions 1-4 are required on every requirement unit. Position 5 is required when `kind`
is `gate` and omitted otherwise. Requirements carrying only four tokens are valid as
`kind:artifact` or `kind:advisory` requirements.

Rationale for all tag values (why each was chosen and its ESE traceability) is in
[ADR-2026-03-25-ese-machine-readable-first-format.md](../decisions/ADR-2026-03-25-ese-machine-readable-first-format.md).

#### 4.9.3 Eval-Scope (5th Token)

The fifth token defines the granularity at which an automated evaluator applies a gate
requirement:

- `per-item`: the evaluator runs once per acceptance-criterion item
- `per-section`: the evaluator runs once per document section
- `per-artifact`: the evaluator runs once per complete artifact
- `per-commit`: the evaluator runs once per commit

#### 4.9.4 Applies-When Grammar

The fourth token carries an `applies-when` expression. For compound expressions, the entire
expression is contained within one backtick pair. The full grammar in PEG notation:

```peg
applies-when  <- expr EOF
expr          <- or-expr
or-expr       <- and-expr ( SP+ "OR" SP+ and-expr )*
and-expr      <- not-expr ( SP+ "AND" SP+ not-expr )*
not-expr      <- "NOT" SP+ not-expr / primary
primary       <- "(" SP* expr SP* ")" / "all" / type-pred / addendum-pred
type-pred     <- "type:" name
addendum-pred <- "addendum:" code
name          <- [a-z] [a-z0-9\-]*
code          <- [A-Z] [A-Z0-9\-]*
SP            <- [ \t]
EOF           <- !.
```

`{name}` begins with a lowercase ASCII letter; subsequent characters are lowercase letters,
decimal digits, or hyphens. `{code}` begins with an uppercase ASCII letter; subsequent
characters are uppercase letters, decimal digits, or hyphens. Neither allows a leading
hyphen or digit, preventing ambiguity with operator keywords `AND`, `OR`, `NOT` and the
literal `all`.

Precedence is encoded structurally: NOT binds tightest, AND next, OR loosest. Parentheses
override. No separate precedence table is needed; PEG ordered choice and rule stratification
make binding unambiguous by construction. This grammar maps directly to a recursive-descent
parser with one function per rule; no additional design decisions are required beyond the
grammar.

Worked examples as they appear on a tag line:

```
`all`
`type:bug`
`type:feature AND addendum:AI`
`(type:feature OR type:epic) AND NOT addendum:LEGACY`
```

#### 4.9.5 REQ-ID Scheme

- **Base requirements** (STANDARDS.md §1-§9): `REQ-{section}-{seq:02d}` e.g. `REQ-2.2-01`
- **Addenda requirements**: `REQ-ADD-{CODE}-{seq:02d}` e.g. `REQ-ADD-AI-01`; codes: `WEB`, `AI`, `CI`, `EVT`, `MS`, `CTR`, `MT`
- `{seq}` is zero-padded two digits assigned sequentially within a section or addendum
- IDs are globally unique: base IDs carry the section number; addenda IDs carry the `ADD-{CODE}-` prefix, which cannot match any section-numbered base ID
- Gaps in sequence are permitted after deprecation

#### 4.9.6 Immutability Rule

REQ-IDs are immutable once published in a released version. A released version is any
commit that appears in `CHANGELOG.md` under a versioned heading (not under `[Unreleased]`).
An ID is never renumbered, reused, or removed.

When a requirement is deprecated, a sixth optional token is appended to the tag line:

```
<a name="REQ-2.1-01"></a>
**REQ-2.1-01** `gate` `define` `hard` `all` `per-item` `deprecated:REQ-2.1-07`
~~Deprecated: superseded by REQ-2.1-07~~
```

The `deprecated:{superseding-REQ-ID}` token carries the replacing ID. For requirements with
no direct successor, use `deprecated:none`. The anchor is retained so the URL fragment
continues to resolve. Deprecated gate requirements are omitted from the generated
`enforcement-spec.yml`.

#### 4.9.7 Prose vs. Requirement Distinction

A statement earns a REQ-ID when it is (a) binary pass/fail, (b) enforcement-relevant: a gate
fires on it or an artifact is produced for it, and (c) not already captured by an existing
REQ-ID.

Four content types exist. Types 1 and 2 earn REQ-IDs. Type 3 earns a REQ-ID of
`kind:advisory`. Type 4 does not earn a REQ-ID.

**Type 1 (gate):** a condition an automated tool evaluates, returning a block or warning.
**Type 2 (artifact):** a condition satisfied by the existence of a named, inspectable output.
**Type 3 (advisory):** guidance that shapes practice but carries no pass/fail consequence.
**Type 4 (narrative):** rationale, context, examples, analogies, framework mappings.

When the type is ambiguous, assign a REQ-ID. Under-coverage at scale is more costly than
over-coverage.

A linter scans every prose block line (any line not immediately following an
`<a name="REQ-` anchor within two lines) for the obligation keywords `must`, `required`,
`shall`, `block`, `blocks`, `gate`, `cannot`. On a match the linter emits an
`unclassified-obligation` warning identifying the line, the keyword, and the classification
options.

#### 4.9.8 Line Count Ceiling

<a name="REQ-4.9-01"></a>
**REQ-4.9-01** `gate` `continuous` `hard` `all` `per-commit`
Section §4.9 does not exceed 150 lines; the CI line-count gate returns a passing exit code.

<a name="REQ-4.9-02"></a>
**REQ-4.9-02** `gate` `continuous` `hard` `all` `per-commit`
`STANDARDS.md` does not exceed 1200 lines total; the CI line-count gate returns a passing exit code.

When a migration causes `STANDARDS.md` to exceed 1200 lines, move the largest reference-material block from the affected section to `docs/req-schema.md`
and replace it with a link. Normative requirement statements remain in `STANDARDS.md`;
reference material (valid-values tables, extended grammar, extended examples) does not.
