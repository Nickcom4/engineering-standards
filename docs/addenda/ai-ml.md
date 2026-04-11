# Addendum: Artificial Intelligence (AI) and Machine Learning (ML) Systems

> Extends [Excellence Standards - Engineering](../../STANDARDS.md). Apply when your project trains, fine-tunes, or serves machine learning models, or builds on probabilistic AI outputs (Large Language Models (LLMs), classifiers, rankers, or similar).

> **Lifecycle stage activation.** Each section below states which §2.1 lifecycle stage triggers its requirements. The [§2.1 per-stage blocks](../../STANDARDS.md#per-stage-operational-blocks) remain authoritative; when this addendum and that table diverge, update both in the same commit.

---

## Table of Contents

- [Probabilistic Output Discipline (Required)](#probabilistic-output-discipline-required)
- [Autonomy Boundaries (Required)](#autonomy-boundaries-required)
- [Hallucination Containment (Required for Generative AI)](#hallucination-containment-required-for-generative-ai)
- [Model and Artifact Versioning (Required)](#model-and-artifact-versioning-required)
- [Evaluation Harness (Required)](#evaluation-harness-required)
- [Data Governance (Required)](#data-governance-required)
- [Monitoring Additions (Required)](#monitoring-additions-required)
- [Incident Taxonomy Addition](#incident-taxonomy-addition)
- [Model Documentation (Required)](#model-documentation-required)
- [Bias and Fairness (Required for Models Affecting People)](#bias-and-fairness-required-for-models-affecting-people)
- [Model Explainability and Interpretability (Required for Models Affecting Decisions)](#model-explainability-and-interpretability-required-for-models-affecting-decisions)
- [Model Retirement and Decommissioning (Required)](#model-retirement-and-decommissioning-required)
- [External Standards](#external-standards)
- [Testing Gap Audit Additions](#testing-gap-audit-additions)


## Probabilistic Output Discipline (Required)

> **Activates at:** DESIGN (required before BUILD begins).

AI and ML systems produce outputs that are probabilistic, not deterministic. Every design decision that depends on AI output must account for this:

<a name="REQ-ADD-AI-01"></a>
**REQ-ADD-AI-01** `gate` `design` `hard` `addendum:AI` `per-item`
Every downstream consumer of AI output has a named fallback action (default value, human escalation, rejection with explanation, or safe-state hold) documented in its architecture document.

- **Every downstream consumer of AI output has a named fallback action for incorrect output documented in its architecture document.** AI output is probabilistic: every output is an estimate with a confidence distribution, not a deterministic answer. The named action (default value, human escalation, rejection with explanation, or safe-state hold) must be specified in the consuming component's architecture document before implementation begins.
- **Every AI-consuming component has a defined fallback behavior documented in its architecture document.** "Design for graceful tolerance" is not a fallback; the specific action taken when the model is wrong (default value, human escalation, rejection with explanation, or safe-state hold) must be named.
- **The acceptable error rate for every AI-driven decision is defined and committed to the work item before BUILD begins.** "It's usually right" is not an acceptance criterion.
<a name="REQ-ADD-AI-02"></a>
**REQ-ADD-AI-02** `gate` `design` `hard` `addendum:AI` `per-item`
Every AI-consuming component distinguishes confidence score from correctness.

<a name="REQ-ADD-AI-09"></a>
**REQ-ADD-AI-09** `gate` `design` `hard` `addendum:AI` `per-item`
The architecture reflects that high-confidence wrong answers are more dangerous than low-confidence answers that trigger fallback.

- **Every AI-consuming component distinguishes the model's confidence score from its correctness.** A high-confidence wrong answer is more dangerous than a low-confidence answer that triggers a fallback; the architecture must reflect this distinction explicitly.


## Autonomy Boundaries (Required)

> **Activates at:** DESIGN (required before BUILD begins).

Define and document the autonomy level of every AI-driven action before deployment:

| Level | Definition | Requirement |
|-------|-----------|-------------|
| Informational | AI output is displayed to a human who decides | No restriction beyond standard output quality (Section 6.3) |
| Assisted | AI suggests; human approves before action is taken | Approval mechanism must be explicit and logged |
| Automated | AI acts without human approval per request | Requires defined rollback, monitoring, and anomaly detection |
| Autonomous | AI acts and learns from its own actions | Requires additional safety review - do not ship without explicit sign-off |

<a name="REQ-ADD-AI-03"></a>
**REQ-ADD-AI-03** `gate` `design` `hard` `addendum:AI` `per-item`
Every AI-driven action type is classified by autonomy level (informational, assisted, automated, autonomous).

<a name="REQ-ADD-AI-10"></a>
**REQ-ADD-AI-10** `gate` `design` `hard` `addendum:AI` `per-item`
Mixed levels require explicit boundaries.

Every action type must be classified. Mixed autonomy levels in a single system require explicit boundaries.

## Hallucination Containment (Required for Generative AI)

> **Activates at:** DESIGN (containment strategy documented before BUILD; implementation verified at VERIFY).

<a name="REQ-ADD-AI-04"></a>
**REQ-ADD-AI-04** `artifact` `design` `hard` `addendum:AI`
Grounding strategy is documented for every user-facing generative AI output.

<a name="REQ-ADD-AI-21"></a>
**REQ-ADD-AI-21** `artifact` `design` `hard` `addendum:AI`
Validation strategy is documented for every user-facing generative AI output.

<a name="REQ-ADD-AI-22"></a>
**REQ-ADD-AI-22** `artifact` `design` `hard` `addendum:AI`
Confidence communication strategy is documented for every user-facing generative AI output.

<a name="REQ-ADD-AI-23"></a>
**REQ-ADD-AI-23** `artifact` `design` `hard` `addendum:AI`
Human review gates are documented for every user-facing generative AI output.

Generative AI systems (LLMs and similar) produce plausible-sounding incorrect outputs. Containment strategies must be documented and implemented for every user-facing output:

- **Grounding:** link outputs to source documents or data. If the system cannot cite a source, it should say so.
- **Validation:** for structured outputs (code, JSON, SQL, tool calls), validate the output against a schema or parser before use. Invalid structured output is a known output state, not an exception.
- **Confidence communication:** when a system cannot reliably answer a question, it says so rather than guessing confidently. Design this behavior explicitly; it does not emerge automatically.
- **Human review gates:** any AI-generated content that will be published, executed, or acted on must have a human review stage unless confidence and validation are demonstrably sufficient.

## Model and Artifact Versioning (Required)

> **Activates at:** BUILD.

Models are software artifacts. Apply version control discipline:
- Every model artifact has a unique, immutable identifier (hash or version number)
- Training data, hyperparameters, evaluation results, and deployment version are recorded together (provenance)
- Model promotion (from evaluation to staging to production) follows the same lifecycle as code changes: tested, reviewed, deployable, and reversible
- Rollback means reverting to the previous model version with the same confidence as a code rollback

## Evaluation Harness (Required)

> **Activates at:** VERIFY (must run before any model change deploys to production).

Before any model change ships to production:
- An evaluation harness runs against a held-out test set as part of the CI pipeline on every proposed change
- The harness measures the metrics that matter to the use case (accuracy, F1, BLEU (Bilingual Evaluation Understudy), ROUGE (Recall-Oriented Understudy for Gisting Evaluation), pass@k, or domain-specific equivalents)
<a name="REQ-ADD-AI-05"></a>
**REQ-ADD-AI-05** `gate` `verify` `hard` `addendum:AI` `per-artifact`
A regression threshold is defined in a committed file before evaluation begins.

<a name="REQ-ADD-AI-11"></a>
**REQ-ADD-AI-11** `gate` `verify` `hard` `addendum:AI` `per-artifact`
CI fails (not warns) when results breach the threshold.

- A regression threshold is defined in a file committed to the repository **before** evaluation begins. Acceptable forms: an absolute score floor (F1 must remain at or above 0.80) or a relative decline ceiling (F1 must not drop more than 5% from the prior baseline). The threshold is set before reviewing results. Setting thresholds after seeing evaluation output to make results pass is not a quality gate; it is theater.
- **CI fails - not warns - when evaluation results breach the threshold.** A pipeline that reports a threshold breach but still produces a deployable artifact is not gated. The build stops.
- Evaluation results are committed alongside the model artifact and compared across versions - not just pass/fail, but trending over time

"Manual testing" is not an evaluation harness. A harness that runs only on a developer's machine is not a CI-integrated harness.

## Data Governance (Required)

> **Activates at:** BUILD (applied during data preparation and training pipeline construction).

<a name="REQ-ADD-AI-06"></a>
**REQ-ADD-AI-06** `gate` `build` `hard` `addendum:AI` `per-artifact`
Training and fine-tuning data has documented provenance.

<a name="REQ-ADD-AI-24"></a>
**REQ-ADD-AI-24** `gate` `build` `hard` `addendum:AI` `per-artifact`
Training data contains no PII without documented consent and legal basis.

<a name="REQ-ADD-AI-25"></a>
**REQ-ADD-AI-25** `gate` `monitor` `hard` `addendum:AI` `per-artifact`
Data drift between training data and production inputs is monitored with a defined threshold.

<a name="REQ-ADD-AI-26"></a>
**REQ-ADD-AI-26** `gate` `build` `hard` `addendum:AI` `per-artifact`
Training data retention policies match production data retention policies.

Training and fine-tuning data must be governed as strictly as production data:
- **Provenance:** where did the data come from? Is the source licensed for this use?
- **Personally Identifiable Information (PII) and sensitive data:** training data must not contain personal data unless consent and legal basis are documented and the model's output cannot recover the training data
- **Data drift:** monitor for distribution shift between training data and production inputs. When the gap exceeds a defined threshold, retrain or add a coverage note to the output
- **Retention and deletion:** training data is subject to the same retention policies as production data ([§5.10](../../STANDARDS.md#510-minimum-security-baseline))

## Monitoring Additions (Required)

> **Activates at:** MONITOR (required from initial DEPLOY onward).

<a name="REQ-ADD-AI-07"></a>
**REQ-ADD-AI-07** `gate` `monitor` `hard` `addendum:AI` `per-artifact`
AI systems monitor output quality metrics.

<a name="REQ-ADD-AI-27"></a>
**REQ-ADD-AI-27** `gate` `monitor` `hard` `addendum:AI` `per-artifact`
AI systems monitor input distribution drift.

<a name="REQ-ADD-AI-28"></a>
**REQ-ADD-AI-28** `gate` `monitor` `hard` `addendum:AI` `per-artifact`
AI systems monitor confidence distribution shifts.

<a name="REQ-ADD-AI-29"></a>
**REQ-ADD-AI-29** `gate` `monitor` `hard` `addendum:AI` `per-artifact`
AI systems monitor anomalous outputs.

In addition to Section 7 of the universal standard, AI systems must monitor:

- **Output quality metrics:** not just latency and error rate, but output correctness metrics over time (sampled evaluation against known cases, or user feedback signals)
- **Input distribution:** detect when production inputs drift from the training distribution. Significant drift means the model is operating outside its validated envelope.
- **Confidence distribution:** alert when the system's confidence distribution shifts (e.g., more low-confidence responses than baseline)
- **Anomalous outputs:** detect and log outputs that are unusually long, unusually short, contain prohibited content, or fail schema validation

## Incident Taxonomy Addition

> **Activates at:** DISCOVER (classification and response procedures required before DEPLOY; applied at runtime during MONITOR).

Extend Section 8.1 of the universal standard with AI-specific incident types:
- **Model regression:** a new model version performs worse on production traffic than its predecessor
- **Data poisoning:** training or fine-tuning data was corrupted or adversarially influenced
- **Prompt injection:** adversarial input caused the model to deviate from intended behavior
- **Hallucination incident:** a confident incorrect output caused user harm or incorrect system action
- **Distribution shift incident:** production inputs moved outside the model's validated envelope and outputs degraded

## Model Documentation (Required)

> **Activates at:** DOCUMENT (model card required before DEPLOY).

Every model deployed to production has a model card: a concise document describing what the model does, what it was trained on, its intended use cases, its known limitations, its performance across demographic and data subgroups, and what it should not be used for. Model cards are the AI/ML equivalent of the API contract (Section 4.1 of the universal standard) - they define the interface between the model and its consumers.

A model card that says only "accuracy: 94%" is not complete. A useful model card includes: performance disaggregated by relevant subgroups (where applicable), known failure modes, the training data distribution and its relationship to expected production inputs, and the model version and evaluation results that correspond to the deployed artifact.

## Bias and Fairness (Required for Models Affecting People)

> **Activates at:** VERIFY (evaluation required before deployment; repeats on a defined cadence during MONITOR).

Any model whose output affects decisions about people - hiring, lending, content moderation, healthcare, benefits, criminal justice, or similar - requires explicit bias and fairness evaluation before deployment and on a defined cadence thereafter.

At minimum:
- Evaluate model performance disaggregated by relevant demographic attributes (where data is available and legally permissible to use)
- Define acceptable disparity thresholds before evaluation - not after reviewing results
- Document which fairness definition applies and why: demographic parity, equalized odds, individual fairness, or another definition. Different use cases require different definitions and they are mutually exclusive; choosing one is a design decision, not a technical detail.
- Any model that fails its fairness thresholds is not production-ready regardless of aggregate accuracy

This requirement applies whether the model was trained internally or adopted from an external provider.

## Model Explainability and Interpretability (Required for Models Affecting Decisions)

> **Activates at:** DESIGN (explainability approach documented before BUILD); VERIFY (explanation faithfulness checked before DEPLOY).

<a name="REQ-ADD-AI-08"></a>
**REQ-ADD-AI-08** `artifact` `design` `hard` `addendum:AI`
Any model driving automated decisions, surfacing recommendations, or contributing to consequential outcomes has a documented explainability approach with method justification and faithfulness validation.

Any model whose output drives an automated decision, surfaces a recommendation to a user, or contributes to a consequential outcome must have a documented explainability approach.

At minimum:
- **Choose an explainability method and document why it is appropriate** for this model architecture: feature attribution (SHAP, LIME, integrated gradients), attention visualization, surrogate models, or native interpretability (decision trees, linear models). "We will use SHAP" without a latency, cost, or architecture-fit justification is not a complete choice.
- **For every output that changes a material outcome, the explanation is expressible in plain language to a non-technical stakeholder.** "The model scored this 72" is not an explanation. "The three factors most affecting this score were income-to-debt ratio, account age, and recent inquiry count" is an explanation.
- **Every explanation method is validated for faithfulness to the model's actual behavior** before production deployment. An explanation that does not reflect why the model produced the output is worse than no explanation: it creates false confidence in a rationalization. Faithfulness validation must be documented in the model card (see [Model Documentation](#model-documentation-required)).
- **The limits of the explainability method are documented:** conditions under which explanations are unreliable, cases where they should not be presented as definitive, and the recourse process when a user disputes an explanation.

<a name="REQ-ADD-AI-12"></a>
**REQ-ADD-AI-12** `advisory` `continuous` `soft` `addendum:AI`
Match explanation rigor to the autonomy level defined in Autonomy Boundaries: Informational models carry a lower explanation burden than Automated ...

Match explanation rigor to the autonomy level defined in [Autonomy Boundaries](#autonomy-boundaries-required): Informational models carry a lower explanation burden than Automated or Autonomous models, which act without per-request human review.

## Model Retirement and Decommissioning (Required)

> **Activates at:** DESIGN (retirement criteria defined before DEPLOY); CLOSE (retirement procedure executed at model end-of-life).

Every model has an end of life. Failing to plan for retirement produces models that continue to run, consume resources, and affect users after they have been superseded, invalidated by data drift, or found to have safety issues.

Before a model is deployed to production, document:

- **Retirement trigger criteria:** the specific condition that causes retirement. Examples: a successor model passes VERIFY with no regression, accuracy drops below a defined floor for N consecutive MONITOR windows, the underlying data source is decommissioned, a regulatory requirement changes. "We will retire it when it is no longer useful" is not a trigger; it is a policy that ensures the model is never retired.
- **Decommissioning checklist:** the steps to safely retire the model. Minimum: route all traffic to a successor or defined fallback, confirm zero active consumers on the retired model version, archive model artifacts and evaluation results per data retention policy, notify downstream consumers no less than [N days] before retirement.
- **Data retention:** model artifacts, training data, and evaluation results from retired models are subject to the project's standard retention policy. Document how long retired artifacts are retained and who is responsible for deletion at retention end.
- **Downstream consumer registry:** identify all consumers of the model at deployment time and maintain this list through the model's operational life. Consumers are notified of the retirement timeline before decommissioning begins. Simultaneous notice and retirement is an incident.

A retired model that is not formally decommissioned is not retired: it is forgotten. Forgotten models create security surface, cost, and liability without producing value.

## LLM-Generated Enforcement Rules

> **Activates at:** DESIGN (quality threshold and approval process defined before any LLM-generated rule is created; applied at VERIFY before any rule is promoted to active).

When an enforcement tool generates gate rules from AI/LLM inference against a standards document rather than from deterministic parsing of structured requirements, those rules carry different reliability characteristics than deterministic rules. The following requirements govern their creation, evaluation, and activation.

**Inert by default.** Every LLM-generated enforcement rule begins with `status: inert`. An inert rule is committed to the enforcement specification but produces no enforcement actions. Inert rules are visible to reviewers and can be evaluated, but they do not block or warn until explicitly promoted.

**Gate authority approval.** Configuring an F1 threshold for LLM-generated rule activation satisfies the gate authority approval requirement for that rule's promotion. The threshold must be set and committed before evaluation begins; setting thresholds after reviewing evaluation results invalidates the gate.

**Evaluation standard.** Two independent evaluation runs are required, each against a distinct labeled sample set. A rule is eligible for promotion from `status: inert` to `status: active` only when both runs individually achieve F1 >= 0.85. A rule that achieves F1 >= 0.85 in one run but not both remains `status: inert` regardless of the passing run's score.

<a name="REQ-ADD-AI-30"></a>
**REQ-ADD-AI-30** `gate` `design` `hard` `addendum:AI` `per-item`
The F1 threshold for LLM-generated enforcement rule activation is set and committed before evaluation begins.

<a name="REQ-ADD-AI-31"></a>
**REQ-ADD-AI-31** `gate` `verify` `hard` `addendum:AI` `per-artifact`
An LLM-generated enforcement gate rule has been evaluated against a minimum of 2 independent labeled sample sets before promotion from inert to active.

<a name="REQ-ADD-AI-32"></a>
**REQ-ADD-AI-32** `gate` `verify` `hard` `addendum:AI` `per-artifact`
Each of the 2 required evaluation runs achieves F1 >= 0.85 independently before the rule is promoted from inert to active.

**Promotion record.** The commit that promotes a rule from `status: inert` to `status: active` includes: the rule identifier, both evaluation run results (F1 scores and labeled set references), and the committer's explicit confirmation that the threshold was set before evaluation. This record is the gate authority approval.

<a name="REQ-ADD-AI-33"></a>
**REQ-ADD-AI-33** `gate` `commit` `hard` `addendum:AI` `per-artifact`
The promotion commit for an LLM-generated rule records the F1 score from each of the two required evaluation runs.

<a name="REQ-ADD-AI-34"></a>
**REQ-ADD-AI-34** `gate` `commit` `hard` `addendum:AI` `per-artifact`
The promotion commit for an LLM-generated rule records the labeled set reference used in each evaluation run.

<a name="REQ-ADD-AI-35"></a>
**REQ-ADD-AI-35** `gate` `commit` `hard` `addendum:AI` `per-artifact`
The promotion commit for an LLM-generated rule includes explicit confirmation that the F1 threshold was set before evaluation began.

---

## External Standards

The NIST AI Risk Management Framework (AI RMF 1.0, 2023) provides a structured approach for managing risk across the full AI lifecycle through four functions: Govern (policies and organizational accountability for AI risk), Map (identifying which risks apply in your specific deployment context), Measure (assessing and prioritizing those risks quantitatively), and Manage (implementing controls, monitoring, and response). Use the Map function as a checklist before DESIGN to identify which risk categories (safety, explainability, bias, privacy, security) apply to your system before architectural decisions lock in. See [airc.nist.gov](https://airc.nist.gov/) and [doi.org/10.6028/NIST.AI.100-1](https://doi.org/10.6028/NIST.AI.100-1), tracked in [dependencies.md](../../dependencies.md).

## Testing Gap Audit Additions

| Gap | Typical impact | Priority |
|---|---|---|
| No evaluation harness | Model regressions reach production undetected | P0 |
| No evaluation threshold committed to repository, or threshold present but CI warns instead of failing | Degraded models deploy automatically; threshold is not a gate | P0 |
| No model card | Consumers cannot determine intended use, limitations, or version | P1 |
| No bias/fairness evaluation (for people-affecting models) | Disparate impact ships without detection | P0 |
| No fairness threshold defined before evaluation | Thresholds are set post-hoc to pass; evaluation becomes theater | P0 |
| No schema validation on structured outputs | Downstream systems fail on malformed AI output | P1 |
| No confidence score surfaced in output | Consumers cannot distinguish high and low confidence outputs | P1 |
| No input distribution monitoring | Model operates outside validated envelope silently | P2 |
| No provenance tracking for training data | License violation or PII exposure undiscoverable after the fact | P1 |
| No explainability approach documented (for decision-affecting models) | Decisions cannot be explained or audited when disputed | P1 |
| Explainability method not validated for faithfulness | Explanations are post-hoc rationalization, not model behavior; creates false confidence in wrong answers | P1 |
| No retirement trigger criteria defined before deployment | Superseded or unsafe models remain in production indefinitely | P1 |
| No downstream consumer registry maintained | Retirement proceeds without notifying consumers; consumer breakage is a surprise | P1 |
| Fallback behavior for incorrect AI output not documented in architecture | Downstream failure mode is undefined; incorrect outputs cascade silently | P1 |

