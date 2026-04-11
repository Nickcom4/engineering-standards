# External Standards Dependencies

Review annually (every January). For the update process, see STANDARDS.md Section 9.3.

**Annual review protocol:** Each January, update the Last Reviewed date for each entry and check whether the referenced version is still current. File a work item for any entry where the version has changed materially. This file is reviewed as part of the compliance review cadence in standards-application.md. If the compliance review date in standards-application.md falls in January or later in the year, treat it as the annual review for this file and update Last Reviewed dates.

**Last annual review:** 2026-04-09 (combined with compliance review covering v2.0.0-v2.1.0)

| Standard | Version | URL | Last Reviewed | Notes |
|---|---|---|---|---|
| ISO 9001 | 2015 (6th ed.) | https://www.iso.org/standard/62085.html | 2026-03-24 | Quality management systems standard. §4.4 (process management: each process requires defined inputs, outputs, criteria, and responsibilities) grounds the ESE §2.1 per-stage Input/Artifact/Addenda format. Referenced in STANDARDS.md §1 scope statement (rigor equivalence), §2.1 PDCA alignment, ADR-011, and ADR-021 D4. |
| ISO 27001 | 2022 (3rd ed.) | https://www.iso.org/standard/27001 | 2026-03-24 | Information security management systems standard. Referenced in STANDARDS.md §1 scope statement (rigor equivalence) and ADR-011. ESE §5.10 minimum security baseline is informed by this standard's principles. For formal ISO 27001 certification, supplement ESE with the full statement of applicability and control set. |
| NIST AI Risk Management Framework (RMF) | 1.0 (2023) | https://airc.nist.gov/ | 2026-03-19 | Authoritative US government framework for AI risk management. Four functions: Govern, Map, Measure, Manage. Referenced by AI and ML addendum. |
| OWASP ASVS | v5.0.0 | https://owasp.org/www-project-application-security-verification-standard/ | 2026-03-19 | v5.0.0 released May 2025. Restructured around modern architectures; Level 1/2/3 concept preserved. Review STANDARDS.md Section 5.10 against v5.0 Level 1 requirements. |
| DORA State of DevOps | 2025 report | https://dora.dev/research/2025/ | 2026-03-19 | Four core metrics (deployment frequency, lead time, change failure rate, time to restore) stable across report years. |
| Google SRE Book | 1st ed. (2016) | https://sre.google/sre-book/table-of-contents/ | 2026-03-19 | |
| Google SRE Workbook | 1st ed. (2018) | https://sre.google/workbook/table-of-contents/ | 2026-03-19 | |
| The Twelve-Factor App | 2011-2018 | https://12factor.net | 2026-03-19 | |
| Test Pyramid (Fowler/Vocke) | 2018 | https://martinfowler.com/articles/practical-test-pyramid.html | 2026-03-19 | |
| OpenTelemetry Specification | v1.x | https://opentelemetry.io/docs/specs/otel/ | 2026-03-19 | Current stable: v1.55.0. Intentionally pinned to v1.x range. |
| Semantic Versioning | v2.0.0 | https://semver.org | 2026-03-19 | |
| WCAG | 2.2 (2023) | https://www.w3.org/TR/WCAG22/ | 2026-03-19 | 2.2 is the current W3C Recommendation. Backward-compatible with 2.1. WCAG 3.0 in progress (expected 2026+) - new conformance model. When 3.0 finalizes, review STANDARDS.md Section 6.3. |
| Nielsen's Usability Heuristics | 1994, revised 2020 | https://www.nngroup.com/articles/ten-usability-heuristics/ | 2026-03-19 | Page last modified Oct 2024. Core heuristics unchanged. |
| Google Core Web Vitals | 2024 thresholds | https://web.dev/articles/vitals | 2026-03-19 | Project-level dependency. INP replaced FID in March 2024. Thresholds reviewed annually by Google - check each January. |
| Google Lighthouse | v13.x | https://developer.chrome.com/docs/lighthouse/ | 2026-03-19 | Project-level dependency. |
| W3C Internationalization | Living standard | https://www.w3.org/International/ | 2026-03-19 | |
| CommonMark | 0.31.2 (2024) | https://commonmark.org | 2026-03-19 | |
| Conway's Law | Principle (Conway, 1968) | https://martinfowler.com/bliki/ConwaysLaw.html | 2026-03-23 | "Organizations design systems that mirror their communication structure." No versioned standard; secondary source (Fowler's wiki) may update. Referenced in §3.4. Review: confirm URL resolves and page content unchanged. |
| Hyrum's Law | Principle (Wright, ~2012) | https://www.hyrumslaw.com | 2026-03-23 | "With enough consumers, every observable behavior of an API becomes depended on." No versioned standard; single-page reference. Referenced in §5.8. Review: confirm URL resolves and content unchanged. |
| CMMI for Development | V2.0 (ISACA, 2018) | https://cmmiinstitute.com/learning/appraisals/levels | 2026-03-23 | Capability Maturity Model Integration. Five maturity levels: Initial (1), Managed (2), Defined (3), Quantitatively Managed (4), Optimizing (5). Adopting ESE positions engineering processes at approximately Level 3 (Defined). Referenced in docs/adoption.md. |
| Cynefin Framework | Snowden and Boone (2007) | https://hbr.org/2007/11/a-leaders-framework-for-decision-making | 2026-03-23 | Domain model for decision-making. Complicated domain: cause-effect knowable through expert analysis; apply good practices. Complex domain: cause-effect only apparent in retrospect; probe-sense-respond. ESE §1.5 uses this vocabulary to define the standard's applicability boundary. Referenced in STANDARDS.md §1.5 and ADR-017. |
| Deming System of Profound Knowledge (SoPK) | Deming (1993, The New Economics) | https://deming.org/explore/sopk/ | 2026-03-23 | Four-component framework: appreciation for a system, knowledge of variation, theory of knowledge, psychology. Provides the theoretical basis for blameless post-mortems and systemic cause analysis. Referenced in STANDARDS.md §8.2. |
| Theory of Constraints | Goldratt (1984, The Goal) | https://www.toc-goldratt.com/en/product/the-goal | 2026-03-23 | Five focusing steps: identify the constraint, exploit it, subordinate everything else, elevate it, prevent inertia from reinstating it. Foundational for constraint-based throughput optimization. Referenced in STANDARDS.md §2.6 and docs/addenda/continuous-improvement.md. |
| Miller's Law (working memory) | Miller (1956) | https://doi.org/10.1037/h0043158 | 2026-04-08 | "The Magical Number Seven, Plus or Minus Two." Human working memory capacity is bounded at roughly 7 items. Generates the §2.8 scale trigger (status visibility becomes load-bearing when concurrent items exceed working memory) and the §4.7 document length principle (readability degrades when document structure exceeds working memory). Referenced in STANDARDS.md §2.8 and §4.7. |
| Parkinson's Law | Parkinson (1955) | https://doi.org/10.1111/j.1468-0289.1955.tb01205.x | 2026-04-08 | "Work expands to fill the time available for its completion." Generates the §9.1 time-box principle for research and proof-of-concept phases: without a time constraint, evaluation expands indefinitely. Referenced in STANDARDS.md §9.1. |
