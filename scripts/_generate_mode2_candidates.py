#!/usr/bin/env python3
"""
Mode 2 candidate generator helper (DFMEA FM-06, REQ-ADD-AI-30 through -33).

Reads unclassified obligation lines from stdin (output of lint-obligations.sh),
calls Groq LLM to generate candidate gate rules for each, and writes
enforcement-spec-mode2-candidates.yml with status: inert.

Usage: python3 _generate_mode2_candidates.py <api_key> <count> <output_path>
Stdin: unclassified obligation lines from lint-obligations.sh

Rules are status: inert. Promotion requires:
  - 2 independent evaluation runs each achieving F1 >= 0.85 (REQ-ADD-AI-32)
  - Commit recording F1 scores, labeled set refs, pre-evaluation threshold (REQ-ADD-AI-33)
"""
import sys
import json
import re
import datetime
import http.client
import ssl

api_key = sys.argv[1]
obligation_count = int(sys.argv[2])
output_path = sys.argv[3]

raw_obligations = sys.stdin.read().strip().splitlines()

MODEL = "llama-3.3-70b-versatile"
GROQ_URL = "https://api.groq.com/openai/v1/chat/completions"

SYSTEM_PROMPT = """You are an engineering standards analyst. Given an obligation statement from a software engineering standard, generate a candidate enforcement gate rule in structured YAML.

The rule must be:
- Binary (pass/fail, not a judgment call)
- Observable (a tool or reviewer can check it without inference)
- First-principles (does not reference specific tools or proprietary systems)

Output ONLY valid JSON with these fields:
{
  "candidate_id": "MODE2-NNN",
  "scope": "one of: discover|define|design|build|verify|document|deploy|monitor|close|commit|continuous",
  "applies_when": "all OR type:<type> OR addendum:<CODE>",
  "statement": "The binary, observable gate condition. One sentence. No sub-clauses.",
  "rationale": "Why this obligation warrants a gate rule (1-2 sentences)",
  "confidence": 0.0 to 1.0
}"""

def call_groq(obligation_text, idx):
    prompt = f"""Obligation statement from ESE STANDARDS.md (line context: {obligation_text})

Generate a candidate enforcement gate rule for this obligation."""

    payload = {
        "model": MODEL,
        "messages": [
            {"role": "system", "content": SYSTEM_PROMPT},
            {"role": "user", "content": prompt}
        ],
        "max_tokens": 300,
        "temperature": 0.1
    }

    body = json.dumps(payload).encode()
    try:
        ctx = ssl.create_default_context()
        conn = http.client.HTTPSConnection("api.groq.com", context=ctx, timeout=30)
        conn.request("POST", "/openai/v1/chat/completions", body=body,
                     headers={"Authorization": f"Bearer {api_key}",
                               "Content-Type": "application/json"})
        resp = conn.getresponse()
        raw = resp.read().decode()
        if resp.status != 200:
            return None, f"HTTP {resp.status}: {raw[:100]}"
        data = json.loads(raw)
        text = data["choices"][0]["message"]["content"].strip()
        # Strip markdown code fences if present
        text = re.sub(r'^```(?:json)?\s*', '', text, flags=re.MULTILINE)
        text = re.sub(r'```\s*$', '', text, flags=re.MULTILINE)
        text = text.strip()
        # Extract JSON object containing "statement"
        m = re.search(r'\{[^{}]*"statement"[^{}]*\}', text, re.DOTALL)
        if m:
            return json.loads(m.group()), None
        # Try full text as JSON
        try:
            return json.loads(text), None
        except Exception:
            return None, f"could not parse JSON from response: {text[:100]}"
    except Exception as e:
        return None, str(e)

def yaml_str(s):
    if not s:
        return '""'
    if any(c in s for c in (':', '#', '{', '}', '[', ']', ',', '&', '*', '?',
                             '|', '-', '<', '>', '=', '!', '%', '@', '`', '"', "'")):
        escaped = s.replace("\\", "\\\\").replace('"', '\\"')
        return f'"{escaped}"'
    return s

generated_at = datetime.datetime.now(datetime.timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ")
candidates = []

for idx, obligation in enumerate(raw_obligations, 1):
    if not obligation.strip():
        continue
    print(f"  [{idx}/{len(raw_obligations)}] Processing: {obligation[:80]}...", file=sys.stderr)
    result, error = call_groq(obligation, idx)
    if result:
        result["candidate_id"] = f"MODE2-{idx:03d}"
        result["source_obligation"] = obligation.strip()
        result["status"] = "inert"
        result["mode"] = "llm-generated"
        result["promotion_requirements"] = "2 independent eval runs each F1>=0.85; commit with F1 scores and pre-eval threshold confirmation (REQ-ADD-AI-31, REQ-ADD-AI-32, REQ-ADD-AI-33)"
        candidates.append(result)
        print(f"    -> generated: {result.get('statement', '')[:60]}...", file=sys.stderr)
    else:
        print(f"    -> SKIP (error: {error})", file=sys.stderr)
        candidates.append({
            "candidate_id": f"MODE2-{idx:03d}",
            "status": "inert",
            "mode": "llm-generated",
            "source_obligation": obligation.strip(),
            "statement": "",
            "error": error,
            "note": "Generation failed; manual review required before promotion"
        })

# Write YAML output
lines = []
lines.append("# ESE Enforcement Specification -- Mode 2 Candidates (LLM-generated)")
lines.append("# Auto-generated by scripts/generate-mode2-candidates.sh")
lines.append("# All rules have status: inert -- they produce NO enforcement actions.")
lines.append("# Promotion to status: active requires 2 independent eval runs each F1 >= 0.85")
lines.append("# and a commit recording both scores and pre-evaluation threshold confirmation.")
lines.append("# See ai-ml.md LLM-Generated Enforcement Rules section for the full standard.")
lines.append(f"# Generated: {generated_at}")
lines.append(f"# Source obligations: {len(raw_obligations)}")
lines.append(f"# Candidates generated: {len([c for c in candidates if c.get('statement')])}")
lines.append("")
lines.append(f"version: \"1.0\"")
lines.append(f"generated: \"{generated_at}\"")
lines.append(f"candidate_count: {len(candidates)}")
lines.append("mode2_candidates:")

for c in candidates:
    lines.append(f"  - candidate_id: {c.get('candidate_id', 'MODE2-???')}")
    lines.append(f"    status: inert")
    lines.append(f"    mode: llm-generated")
    if c.get("scope"):
        lines.append(f"    scope: {c['scope']}")
    if c.get("applies_when"):
        lines.append(f"    applies_when: {yaml_str(str(c['applies_when']))}")
    if c.get("statement"):
        lines.append(f"    statement: {yaml_str(c['statement'])}")
    if c.get("rationale"):
        lines.append(f"    rationale: {yaml_str(c['rationale'])}")
    if c.get("confidence") is not None:
        lines.append(f"    confidence: {c['confidence']}")
    lines.append(f"    source_obligation: {yaml_str(c.get('source_obligation', ''))}")
    if c.get("error"):
        lines.append(f"    error: {yaml_str(c['error'])}")
    lines.append(f"    promotion_requirements: \"2 independent eval runs each F1>=0.85; commit with F1 scores and pre-eval threshold confirmation (REQ-ADD-AI-31, REQ-ADD-AI-32, REQ-ADD-AI-33)\"")

with open(output_path, "w") as f:
    f.write("\n".join(lines) + "\n")

print(f"PASS: {output_path} written with {len(candidates)} Mode 2 candidates (all status: inert).")
