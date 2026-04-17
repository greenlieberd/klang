# BENCH — Audio Hardware Copilot for KLANG

Internal design system for KLANG hardware. Talk to it, build things with it. Everything for a project lives in one folder. Knowledge accumulates across projects.

---

## What it does

BENCH is a Claude Code agent that guides you through the full hardware design cycle:

**Idea → Research → Prototype → Iterate → Promote**

- Asks clarifying questions, researches components via Perplexity, checks your skills library
- Writes a breadboard build plan with signal diagrams and BOM
- Sits with you at the bench: one experiment per turn, logs every iteration
- When it works, promotes to schematic brief, final BOM, and production notes

Scope: mixers, synths, effects, Eurorack modules, DSP devices, MIDI hardware, firmware, VST plugins.

---

## Setup

```bash
# 1. Clone
git clone git@github.com:greenlieberd/klang.git
cd klang

# 2. Create Python venv (requires Python 3.10+)
/opt/homebrew/bin/python3 -m venv .venv

# 3. Install dependencies
.venv/bin/pip install graphifyy openai

# 4. Register graphify with Claude Code
.venv/bin/graphify install

# 5. Configure keys
cp .env.example .env
# Add PERPLEXITY_API_KEY to .env

# 6. Open BENCH
alias bench='claude --project /path/to/klang'
bench
```

---

## Keys

| Key | Where to get it | Required? |
|---|---|---|
| `PERPLEXITY_API_KEY` | perplexity.ai/settings/api | No — but enables web research |

---

## Vault (Obsidian)

Open Obsidian → "Open folder as vault" → point at `klang/vault/`. Knowledge from every project accumulates here automatically.
