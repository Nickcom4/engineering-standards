---
type: starter
purpose: "Installation and configuration instructions"
frequency: one-time
---

# Setup: {Project Name}

<a name="REQ-STR-16"></a>
**REQ-STR-16** `advisory` `continuous` `soft` `all`
Setup documentation for {Project Name}. Required by §4.

> Setup documentation for {Project Name}. Required by [§4.1](../STANDARDS.md#41-what-must-be-documented) for any new dependency or configuration. Per [§2.3](../STANDARDS.md#23-definition-of-done): a new person must be able to set it up and run it locally without asking anyone. Target: clone to running in under 15 minutes.

---

## Table of Contents

- [Prerequisites](#prerequisites)
- [Clone and Run](#clone-and-run)
- [Environment Variables](#environment-variables)
- [Common Setup Failures](#common-setup-failures)
- [Verify Your Setup](#verify-your-setup)

---

## Prerequisites

| Tool | Version | Install |
|------|---------|---------|
| {Language runtime} | {version} | {install command or link} |
| {Database} | {version} | {install command or link} |
| {Other dependency} | {version} | {install command or link} |

---

## Clone and Run

```bash
# 1. Clone the repository
git clone {repo URL}
cd {project-name}

# 2. Install dependencies
{install command}

# 3. Set up environment
cp .env.example .env
# Edit .env with your values - see Environment Variables below

# 4. Set up database (if applicable)
{database setup command}

# 5. Run the application
{run command}

# 6. Verify it works
{verification command - e.g., curl localhost:PORT, open browser to URL}
```

**Expected output after step 6:** {what you should see - specific text, page, or response}

---

## Environment Variables

> [§5.9](../STANDARDS.md#59-runtime-and-deployability): secrets and environment-specific configuration live outside code. No exceptions.

| Variable | Purpose | Example | Required |
|----------|---------|---------|----------|
| {VAR_NAME} | {what it does} | {example value - never a real secret} | yes / no |

---

## Common Setup Failures

| Symptom | Cause | Fix |
|---------|-------|-----|
| {Error message or behavior} | {Why it happens} | {Exact command or step to fix} |

---

## Verify Your Setup

Run these checks to confirm everything is working:

```bash
# Run tests
{test command}

# Check health
{health check command}
```

**All checks pass when:** {what success looks like - e.g., "all tests green", "HTTP 200 from health endpoint"}

---

*Owner: {team or individual}*
*Last updated: {date}*
