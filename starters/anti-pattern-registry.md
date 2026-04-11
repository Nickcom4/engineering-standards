---
type: starter
purpose: "Track recurring anti-patterns for team learning"
frequency: recurring
---

# Anti-Pattern Registry

> Per [§8.4](../STANDARDS.md#84-anti-pattern-registry). Named practices that look correct but consistently cause problems in this system. Add entries when a post-mortem reveals a recurring pattern - not every time something goes wrong.
>
> An anti-pattern is generalized and named, not tied to a single event. The point is to recognize the pattern when it recurs and name it in design reviews before it is committed to. Source each entry from the [lessons-learned registry](../STANDARDS.md#83-lessons-learned-registry) - per [§8.3](../STANDARDS.md#83-lessons-learned-registry).
>
> Use this registry before starting any new feature. If a proposed approach matches a named anti-pattern, reconsider.

| Name | Why it looks right | Why it fails here | First surfaced |
|------|--------------------|-------------------|----------------|
| Example: Skipping tests on "simple" changes | Small changes seem low-risk; tests take time | Every significant regression in this codebase started as a "simple" change; complexity is not visible before the change is made - per [§6.1](../STANDARDS.md#61-test-layers): every function with logic gets a unit test | PM-YYYY-MM-DD |
