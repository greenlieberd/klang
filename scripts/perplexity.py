#!/usr/bin/env python3
"""
Perplexity research query for BENCH.

Usage:
    python3 scripts/perplexity.py "TL074 opamp audio circuit design"
    python3 scripts/perplexity.py "Moog ladder filter transistor matching" --deep

Reads PERPLEXITY_API_KEY from .env file.
Outputs research result to stdout — agent writes it to vault.
"""

import sys
import os
import json
import argparse
from pathlib import Path

# Load .env from project root
env_path = Path(__file__).parent.parent / ".env"
if env_path.exists():
    for line in env_path.read_text().splitlines():
        line = line.strip()
        if line and not line.startswith("#") and "=" in line:
            key, _, val = line.partition("=")
            os.environ.setdefault(key.strip(), val.strip())

api_key = os.environ.get("PERPLEXITY_API_KEY", "")
if not api_key:
    print("ERROR: PERPLEXITY_API_KEY not set. Add it to .env", file=sys.stderr)
    sys.exit(1)

parser = argparse.ArgumentParser()
parser.add_argument("query", help="Research question")
parser.add_argument("--deep", action="store_true", help="Use sonar-pro for deeper research")
parser.add_argument("--domain", default="audio hardware electronics",
                    help="Domain context (default: audio hardware electronics)")
args = parser.parse_args()

model = "sonar-pro" if args.deep else "sonar"

from openai import OpenAI

client = OpenAI(
    api_key=api_key,
    base_url="https://api.perplexity.ai"
)

system_prompt = f"""You are a technical research assistant for audio hardware design.
Domain: {args.domain}

When researching components or circuits:
- Always include full part numbers (e.g. TL074CN, not just TL074)
- Include package type (DIP-8, SOT-23, TO-92 etc.)
- Include typical suppliers (Mouser, Digi-Key, Thonk, JLCPCB)
- Include price range in EUR where known
- State signal levels and impedances where relevant
- Note any gotchas or common failure modes
- Cite datasheets or application notes where possible

Be specific and practical — this research will be used to build real hardware."""

try:
    response = client.chat.completions.create(
        model=model,
        messages=[
            {"role": "system", "content": system_prompt},
            {"role": "user", "content": args.query}
        ],
    )

    result = response.choices[0].message.content

    # Print citations if available
    citations = getattr(response, 'citations', None)

    print(result)

    if citations:
        print("\n---\n## Sources")
        for i, url in enumerate(citations, 1):
            print(f"{i}. {url}")

except Exception as e:
    print(f"ERROR: Perplexity API call failed: {e}", file=sys.stderr)
    sys.exit(1)
