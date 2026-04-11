---
type: starter
purpose: "Track post-mortem lessons and prevention actions"
frequency: recurring
---

# Lessons-Learned Registry

> Per [§8.3](../STANDARDS.md#83-lessons-learned-registry). Every post-mortem lesson is added here. Consult before starting any new feature - this is the institutional memory that prevents recurrence.
>
> A lessons-learned entry is specific: it records what happened in one incident, what changed as a result, and where to find the full post-mortem. It is a factual record tied to one event.
>
> If a lesson recurs across multiple incidents, or a single severe incident reveals a pattern, promote it to the [anti-pattern registry](../STANDARDS.md#84-anti-pattern-registry) - per [§8.4](../STANDARDS.md#84-anti-pattern-registry). The distinction: lessons-learned records facts from specific events; anti-patterns name generalized recurring failure modes.

| Date | What happened | What we do differently now | Source post-mortem |
|------|--------------|---------------------------|-------------------|
| YYYY-MM-DD | Example: deployed during peak traffic without a rollback plan, causing a 20-minute outage | Deployments restricted to off-peak hours; rollback plan and trigger required before any deploy begins - per [§5.7](../STANDARDS.md#57-deployment-strategies-and-release-safety) | [PM-YYYY-MM-DD](../post-mortems/YYYY-MM-DD.md) |
