#!/usr/bin/env bash
# generate-mode2-candidates.sh — the enforcement analyzer Mode 2 candidate generator
# (DFMEA FM-06, REQ-ADD-AI-30 through REQ-ADD-AI-33)
#
# Reads obligation keywords found by lint-obligations.sh that are NOT within
# 10 lines of an existing REQ-ID anchor, then uses an LLM (Groq) to generate
# candidate enforcement gate rules for each unclassified obligation.
#
# Generated rules are written to enforcement-spec-mode2-candidates.yml
# with status: inert -- they produce NO enforcement actions until promoted.
#
# Promotion to status: active requires:
#   (1) 2 independent evaluation runs each achieving F1 >= 0.85 (REQ-ADD-AI-32)
#   (2) A commit recording both F1 scores, labeled set references, and explicit
#       confirmation that the F1 threshold was set before evaluation (REQ-ADD-AI-33)
#
# Usage:
#   bash scripts/generate-mode2-candidates.sh
#
# Prerequisites:
#   GROQ_API_KEY in environment, ~/.config/fabric/.env, or config

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
OUTPUT="$REPO_ROOT/enforcement-spec-mode2-candidates.yml"
HELPER="$REPO_ROOT/scripts/_generate_mode2_candidates.py"

# Locate Groq API key
API_KEY="${GROQ_API_KEY:-}"
if [ -z "$API_KEY" ]; then
  FABRIC_ENV="$HOME/.config/fabric/.env"
  if [ -f "$FABRIC_ENV" ]; then
    API_KEY=$(grep '^GROQ_API_KEY=' "$FABRIC_ENV" 2>/dev/null | cut -d= -f2- | tr -d '"' || true)
  fi
fi

if [ -z "$API_KEY" ]; then
  echo "FAIL: GROQ_API_KEY not found. Set in environment or ~/.config/fabric/.env"
  exit 1
fi

echo "Mode 2 candidate generator: scanning for unclassified obligations..."

# Collect unclassified obligations from lint-obligations.sh output
UNCLASSIFIED=$(bash "$REPO_ROOT/scripts/lint-obligations.sh" 2>/dev/null | \
  grep '^\s' | sed 's/^\s*//' | grep -v '^$' || true)

if [ -z "$UNCLASSIFIED" ]; then
  echo "No unclassified obligations found. No Mode 2 candidates to generate."
  echo "# ESE Enforcement Specification -- Mode 2 Candidates (LLM-generated, status: inert)" > "$OUTPUT"
  echo "# Generated: $(date -u +%Y-%m-%dT%H:%M:%SZ)" >> "$OUTPUT"
  echo "# No unclassified obligations found at generation time." >> "$OUTPUT"
  echo "mode2_candidates: []" >> "$OUTPUT"
  exit 0
fi

OBLIGATION_COUNT=$(echo "$UNCLASSIFIED" | wc -l | tr -d ' ')
echo "Found $OBLIGATION_COUNT unclassified obligations. Generating candidate rules via LLM..."

python3 "$HELPER" "$API_KEY" "$OBLIGATION_COUNT" "$OUTPUT" <<< "$UNCLASSIFIED"
