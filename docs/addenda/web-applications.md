# Addendum: Web Applications

> Extends [Excellence Standards - Engineering](../../STANDARDS.md). Apply when your project includes a browser-rendered user interface.


<a name="REQ-ADD-WEB-11"></a>
**REQ-ADD-WEB-11** `advisory` `continuous` `soft` `addendum:WEB` `deprecated:non-first-principles`
~~Deprecated: advisory meta-req.~~

> Per-stage lifecycle activation of this addendum's requirements is documented in the [§2.1 per-stage blocks](../../STANDARDS.md#per-stage-operational-blocks). When this addendum's requirements are listed in the §2.1 table, those entries are authoritative; update both in the same commit.
---

## Lifecycle Stage Mapping

This table shows which requirements from this addendum activate at each ESE lifecycle stage. The [§2.1 per-stage table](../../STANDARDS.md#per-stage-operational-blocks) is the authoritative source; update both in the same commit when either changes.

| Stage | Requirements active |
|---|---|
| **DESIGN** | Define browser support matrix, viewport breakpoints, and performance targets (Core Web Vitals thresholds, Lighthouse minimums) in the project application document. Define i18n scope if applicable. Define CSP policy and security header set. |
| **BUILD** | Implement responsive layout for all defined viewports. Implement keyboard navigation, focus management, ARIA live regions. Implement CSP, X-Frame-Options, HSTS, and all required security headers. Implement CSRF protection and XSS escaping. Externalize all user-visible strings if i18n in scope. |
| **VERIFY** | Run automated accessibility scan (axe or Lighthouse) as CI gate. Measure Core Web Vitals at 75th percentile; fail CI if thresholds not met. Test all defined viewport breakpoints. Verify all required security headers present. Test with at least one non-English locale if i18n in scope. Run penetration test before initial launch and after significant architectural changes. |
| **DEPLOY** | Verify security headers on deployed environment. Confirm no console errors on any production page. |
| **MONITOR** | Core Web Vitals trending in production. Error rate monitoring per page/route. |

---

## Table of Contents

- [Performance Targets (Required - document in project application doc)](#performance-targets-required---document-in-project-application-doc)
- [Accessibility (Required)](#accessibility-required)
- [Viewport and Responsive Design (Required)](#viewport-and-responsive-design-required)
- [Browser Support (Required - document in project application doc)](#browser-support-required---document-in-project-application-doc)
- [Internationalization and Localization (Required when applicable)](#internationalization-and-localization-required-when-applicable)
- [Security Headers (Required)](#security-headers-required)
- [Cross-Site Scripting (XSS) and Cross-Site Request Forgery (CSRF) (Required)](#cross-site-scripting-xss-and-cross-site-request-forgery-csrf-required)
- [Penetration Testing (Required)](#penetration-testing-required)
<a name="REQ-ADD-WEB-12"></a>
**REQ-ADD-WEB-12** `advisory` `continuous` `soft` `addendum:WEB` `deprecated:non-first-principles`
~~Deprecated: meta-info.~~

- [Output Quality Gates (Web-Specific)](#output-quality-gates-web-specific)
- [Testing Gap Audit Additions](#testing-gap-audit-additions)


## Performance Targets (Required - document in project application doc)

Define and document your project's specific targets for the following. These are thresholds, not aspirations - failing a threshold means the feature is not done.

**Core Web Vitals** (tracked in [dependencies.md](../../dependencies.md)):
| Metric | Good | Needs Improvement | Poor |
|--------|------|-------------------|------|
| Largest Contentful Paint (LCP) | < 2.5s | 2.5s - 4.0s | > 4.0s |
| Interaction to Next Paint (INP) | < 200ms | 200ms - 500ms | > 500ms |
| Cumulative Layout Shift (CLS) | < 0.1 | 0.1 - 0.25 | > 0.25 |

Measure at the 75th percentile across mobile and desktop.

**Lighthouse** (tracked in [dependencies.md](../../dependencies.md)):
Document your project's minimum acceptable scores for Performance, Accessibility, Best Practices, and SEO. Typical enterprise targets: Performance 80+, Accessibility 90+, Best Practices 90+, SEO 90+.

<a name="REQ-ADD-WEB-01"></a>
**REQ-ADD-WEB-01** `artifact` `define` `hard` `addendum:WEB`
The project application document records a specific numeric threshold for LCP.

<a name="REQ-ADD-WEB-26"></a>
**REQ-ADD-WEB-26** `artifact` `define` `hard` `addendum:WEB`
The project application document records a specific numeric threshold for INP.

<a name="REQ-ADD-WEB-27"></a>
**REQ-ADD-WEB-27** `artifact` `define` `hard` `addendum:WEB`
The project application document records a specific numeric threshold for CLS.

<a name="REQ-ADD-WEB-28"></a>
**REQ-ADD-WEB-28** `artifact` `define` `hard` `addendum:WEB`
The project application document records minimum Lighthouse scores for Performance, Accessibility, Best Practices, and SEO.

Your project's standards application document must record, at minimum: the project-specific threshold for LCP (good/acceptable/poor), INP, and CLS, plus the minimum acceptable Lighthouse score for each of the four categories (Performance, Accessibility, Best Practices, SEO). Stating "we will meet Core Web Vitals" without explicit numeric thresholds does not satisfy this requirement.

## Accessibility (Required)

<a name="REQ-ADD-WEB-02"></a>
**REQ-ADD-WEB-02** `gate` `build` `hard` `addendum:WEB` `per-artifact`
Web interfaces conform to WCAG 2.2 Level AA minimum.

<a name="REQ-ADD-WEB-05"></a>
**REQ-ADD-WEB-05** `gate` `build` `hard` `addendum:WEB` `per-artifact`
Keyboard navigation meets AA thresholds.

<a name="REQ-ADD-WEB-29"></a>
**REQ-ADD-WEB-29** `gate` `build` `hard` `addendum:WEB` `per-artifact`
Focus management meets AA thresholds.

<a name="REQ-ADD-WEB-30"></a>
**REQ-ADD-WEB-30** `gate` `build` `hard` `addendum:WEB` `per-artifact`
Screen reader compatibility meets AA thresholds.

<a name="REQ-ADD-WEB-31"></a>
**REQ-ADD-WEB-31** `gate` `build` `hard` `addendum:WEB` `per-artifact`
Color is not the sole channel for conveying information.

<a name="REQ-ADD-WEB-32"></a>
**REQ-ADD-WEB-32** `gate` `build` `hard` `addendum:WEB` `per-artifact`
Text contrast meets AA thresholds.

<a name="REQ-ADD-WEB-03"></a>
**REQ-ADD-WEB-03** `gate` `commit` `hard` `addendum:WEB` `per-commit`
An automated accessibility scan runs on every pull request.

<a name="REQ-ADD-WEB-06"></a>
**REQ-ADD-WEB-06** `gate` `commit` `hard` `addendum:WEB` `per-commit`
Automated pass is a gate, not a certification.

Web interfaces must conform to [WCAG 2.2](https://www.w3.org/TR/WCAG22/) Level AA as a minimum. WCAG 2.2 defines four principles (Perceivable, Operable, Understandable, Robust) and Level AA requires satisfying all Level A and AA success criteria; auditing with an automated tool (axe, Lighthouse) plus manual keyboard and screen reader testing covers the most common gaps. Document your project's target level in the application document.

Required regardless of target level:
- Keyboard navigation: every interactive element is reachable by Tab key (and Shift+Tab in reverse) and operable by Enter or Space; no keyboard trap prevents moving focus away from any element
- Focus management: every focusable element has a visible focus indicator that meets 3:1 contrast against adjacent colors; focus order follows the visual reading order; focus does not move without an explicit user action
- Screen reader compatibility: all non-decorative images have alt text; all form controls have programmatically associated labels; dynamic content changes are announced via ARIA live regions or focus management
- Color is not the sole information channel: any state communicated by color is also communicated by text, shape, or pattern
- Text contrast meets WCAG 2.2 AA minimums: 4.5:1 for normal text, 3:1 for large text

<a name="REQ-ADD-WEB-13"></a>
**REQ-ADD-WEB-13** `advisory` `continuous` `soft` `addendum:WEB` `deprecated:non-first-principles`
~~Deprecated: restates WEB-03.~~

Run an automated accessibility scan on every pull request. Automated tools catch approximately 30% of WCAG issues - automated pass is a gate, not a certification.

## Viewport and Responsive Design (Required)

Test at minimum:
- Mobile: 375px width (iPhone SE)
- Tablet: 768px width
- Desktop: 1280px width
- Large desktop: 1920px width

No layout breakage, content truncation, or interactive element inaccessibility at any supported viewport. Test with the browser DevTools device emulator and on at least one real mobile device per release cycle.

## Browser Support (Required - document in project application doc)

Define and document your project's supported browser matrix before the first release. Typical enterprise minimum:
- Chrome: last 2 major versions
- Firefox: last 2 major versions
- Safari: last 2 major versions
- Edge: last 2 major versions
- Mobile Safari and Chrome on iOS: last 2 OS versions
- Chrome on Android: last 2 OS versions

Internet Explorer is not supported in new projects.

## Internationalization and Localization (Required when applicable)

Apply this section when any of the following is true: the application serves users in more than one language, the product roadmap includes a non-English locale within 12 months, or the application displays dates, times, numbers, or currencies to end users.

<a name="REQ-ADD-WEB-08"></a>
**REQ-ADD-WEB-08** `gate` `build` `hard` `addendum:WEB` `per-artifact`
All user-visible strings are externalized through a localization function.

<a name="REQ-ADD-WEB-33"></a>
**REQ-ADD-WEB-33** `gate` `build` `hard` `addendum:WEB` `per-artifact`
All user-visible dates and numbers are externalized through a localization function.

<a name="REQ-ADD-WEB-34"></a>
**REQ-ADD-WEB-34** `gate` `build` `hard` `addendum:WEB` `per-artifact`
All user-visible currencies are externalized through a localization function.

<a name="REQ-ADD-WEB-35"></a>
**REQ-ADD-WEB-35** `gate` `build` `hard` `addendum:WEB` `per-artifact`
All user-visible plural forms are externalized through a localization function.

<a name="REQ-ADD-WEB-09"></a>
**REQ-ADD-WEB-09** `gate` `build` `hard` `addendum:WEB` `per-artifact`
No user-visible string is assembled by string concatenation in code.

<a name="REQ-ADD-WEB-10"></a>
**REQ-ADD-WEB-10** `gate` `build` `hard` `addendum:WEB` `per-artifact`
CSP disallows inline scripts except where explicitly required and documented.

**What must be externalized:**
- All user-visible strings: labels, button text, error messages, help text, and notification content
- Date and time formats: use locale-aware formatting functions rather than hard-coded patterns such as MM/DD/YYYY
- Number and currency formats: decimal separators and digit grouping differ by locale
- Plural forms: pluralization rules differ across languages; use a pluralization library rather than appending "s"
- Units: weight, distance, and temperature may need conversion for locale audiences

<a name="REQ-ADD-WEB-14"></a>
**REQ-ADD-WEB-14** `advisory` `continuous` `soft` `addendum:WEB` `deprecated:non-first-principles`
~~Deprecated: meta-info.~~

**What must not be hard-coded in source:**
<a name="REQ-ADD-WEB-15"></a>
**REQ-ADD-WEB-15** `advisory` `continuous` `soft` `addendum:WEB` `deprecated:non-first-principles`
~~Deprecated: restates WEB-09.~~

No user-visible string may be assembled by string concatenation in code (e.g., `"Hello " + name`). All strings including those with variable substitutions must pass through the localization function so translators can reorder variables.

**Testing requirements:**
- Smoke-test the application with at least one non-English locale before each release
- Test with a locale whose translations run 30-40% longer than English (German is a common proxy) to verify no layout breakage or text truncation
- Test right-to-left (RTL) rendering if any RTL locale (Arabic, Hebrew) is in scope; verify mirrored layout, icon direction, and text alignment
- Test date, time, number, and currency formatting by switching locales in a staging environment and verifying rendered values match the target locale's conventions
- Include a locale-switching test case in your browser support matrix

**Translation management:**
Maintain a translation file per locale (e.g., JSON or PO format) in source control. Translation files are updated alongside the code change that introduces new strings, not after release. Missing translation keys must surface as a visible fallback (default-language string) rather than a blank or a key identifier shown to the user.

## Security Headers (Required)

<a name="REQ-ADD-WEB-04"></a>
**REQ-ADD-WEB-04** `gate` `deploy` `hard` `addendum:WEB` `per-artifact`
Content-Security-Policy header is emitted.

<a name="REQ-ADD-WEB-36"></a>
**REQ-ADD-WEB-36** `gate` `deploy` `hard` `addendum:WEB` `per-artifact`
X-Frame-Options header is emitted.

<a name="REQ-ADD-WEB-37"></a>
**REQ-ADD-WEB-37** `gate` `deploy` `hard` `addendum:WEB` `per-artifact`
X-Content-Type-Options header is emitted.

<a name="REQ-ADD-WEB-38"></a>
**REQ-ADD-WEB-38** `gate` `deploy` `hard` `addendum:WEB` `per-artifact`
Strict-Transport-Security (HSTS) header is emitted.

<a name="REQ-ADD-WEB-39"></a>
**REQ-ADD-WEB-39** `gate` `deploy` `hard` `addendum:WEB` `per-artifact`
Referrer-Policy header is emitted.

<a name="REQ-ADD-WEB-07"></a>
**REQ-ADD-WEB-07** `gate` `deploy` `hard` `addendum:WEB` `per-artifact`
Verified on every deployment.

All web applications must emit these HTTP response headers:
- `Content-Security-Policy` (CSP) - restrict what resources the page may load
- `X-Frame-Options: DENY` or CSP `frame-ancestors 'none'` - prevent clickjacking
- `X-Content-Type-Options: nosniff` - prevent MIME sniffing
- `Strict-Transport-Security` - enforce HTTPS
- `Referrer-Policy` - control referrer information

Verify headers on every deployment. Use a tool such as [securityheaders.com](https://securityheaders.com) to confirm configuration; the tool scans a URL, grades the response headers A through F, and lists any missing or misconfigured headers. Target a grade of B or higher before launch.

## Cross-Site Scripting (XSS) and Cross-Site Request Forgery (CSRF) (Required)

- All user-supplied content rendered in the browser is escaped. No `innerHTML` with unescaped user input.
- Forms that mutate state use CSRF protection tokens or same-site cookie policy.
<a name="REQ-ADD-WEB-16"></a>
**REQ-ADD-WEB-16** `advisory` `continuous` `soft` `addendum:WEB` `deprecated:non-first-principles`
~~Deprecated: restates WEB-10.~~

- Content Security Policy disallows inline scripts except where explicitly required and documented.

## Penetration Testing (Required)

Web applications with external users or sensitive data undergo penetration testing before initial launch and on a defined cadence thereafter (at minimum annually, or after any significant architectural change). Automated security regression tests (Section 6.5 of the universal standard) run on every build; penetration testing supplements them by finding vulnerabilities that automated tools miss - business logic flaws, authentication bypass through multi-step workflows, and authorization gaps across roles.

Penetration test scope, methodology, and findings are documented. Every finding produces either a fix with a regression test or a documented risk acceptance with a mitigation plan and review date.

## Output Quality Gates (Web-Specific)

In addition to Section 6.3 of the universal standard:
- No console errors or warnings on any user-visible page in production
- 404 and error pages are styled and helpful - not blank or raw stack traces
- Forms validate client-side for usability and server-side for security (never only one)
- Loading states are visible for any operation that may take more than 300ms
- Offline or degraded-network states are handled explicitly

## Testing Gap Audit Additions

| Gap | Typical impact | Priority |
|---|---|---|
| No Core Web Vitals measurement in CI | Performance regressions ship undetected | P1 |
| No accessibility scan in CI | Accessibility regressions ship undetected | P1 |
| No cross-browser smoke test | Browser-specific bugs reach users | P2 |
| No mobile viewport test | Mobile layout breaks ship undetected | P1 |
| No CSP or security header verification | Security regression ships silently | P1 |
| No penetration test before launch | Business logic and multi-step auth bypass vulnerabilities undiscovered | P1 |
| No locale smoke test before release | Untranslated strings, layout breakage, or wrong date/number formats reach users | P2 |

