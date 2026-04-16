# BENCH — Audio Hardware Copilot for KLANG

Internal design system for KLANG hardware. Talk to it, build things with it.

## Setup

```bash
# Clone
git clone git@github.com:greenlieberd/klang.git
cd klang

# Install dependencies
pip install graphifyy && graphify install
git clone https://github.com/karpathy/llm-council && cd llm-council && uv sync && cd ..
pip install openrouter

# Configure
cp .env.example .env
# Add OPENROUTER_API_KEY to .env

# Open
claude   # or: alias bench='claude --project .'
```

## What it does

BENCH is a Claude Code agent that helps design and prototype audio hardware — mixers, synths, effects, Eurorack modules, DSP devices, and firmware. Everything for a project lives in one folder. Knowledge accumulates across projects.

See `klang-bench-spec.md` for the full architecture spec.
