# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

---

## What this is

**BENCH** — an internal Claude Code agent system for designing and building audio hardware under the **KLANG** brand. You talk to it, build hardware with it, and it accumulates knowledge across projects.

The authoritative spec is `klang-bench-spec.md`. Read it before doing anything structural.

---

## Key names

| Name | Meaning |
|---|---|
| KLANG | The hardware brand |
| BENCH | This tool — the copilot for KLANG hardware |
| `bench` | The CLI alias: `bench='claude --project .'` |
| `klang` | This repo (`git@github.com:greenlieberd/klang.git`) |

---

## Dependencies — install, do not reinvent

```bash
pip install graphifyy && graphify install   # knowledge graph from raw/ files
git clone https://github.com/karpathy/llm-council && cd llm-council && uv sync
pip install openrouter                      # for council agent API calls
```

`autoresearch` is NOT installed — BENCH borrows only the `loop.md` iteration pattern from it.

Requires `OPENROUTER_API_KEY` in `.env`.

---

## Target repo structure

```
klang-bench/
├── .claude/
│   ├── CLAUDE.md          # Master agent instructions (content in spec § CLAUDE.md)
│   └── settings.json      # Hook permissions
├── agents/                # 8 markdown agent instruction files
├── hooks/                 # 4 shell hooks (on-start, post-research, post-loop, post-learn)
├── skills/                # registry.md + electronics/platforms/firmware/production/
├── projects/              # One self-contained folder per hardware project
├── vault/                 # Global Obsidian vault across all projects
├── state/active.json      # Active project, stage, open questions
├── scripts/               # new-project.sh, promote.sh, vault-index.sh
└── .env                   # gitignored — holds OPENROUTER_API_KEY
```

---

## Build phases (from spec)

Work through these in order — each phase is independently testable.

| Phase | What it covers |
|---|---|
| 1 — Skeleton | Repo scaffold, CLAUDE.md, state.json, new-project.sh, on-start.sh hook |
| 2 — Knowledge layer | graphify integration, vault-writer agent, initial skill files, registry |
| 3 — Research loop | research.md agent, council.md agent (OpenRouter multi-model) |
| 4 — Prototype + iterate | prototype.md agent, loop.md agent, post-loop.sh hook |
| 5 — Firmware + promote | firmware.md agent, promote.md agent, promote.sh script |
| 6 — Polish | learn.md agent, remaining skill files, README, end-to-end test |

---

## Architecture decisions

- **Agents are markdown files** — plain instruction files in `agents/`, not code. Claude Code reads them as context.
- **`.claude/CLAUDE.md`** is the master runtime instructions (different from this dev file). Its content is defined in the spec under `§ CLAUDE.md — master agent instructions`.
- **Hooks are shell scripts** — triggered by Claude Code's hooks system in `.claude/settings.json`.
- **graphify exposes an MCP server** — agents query `graphify-out/graph.json` via `python -m graphify.serve` rather than grepping flat files.
- **loop.md is the shared memory** — human writes results, agent reads full history, proposes one change per turn. Never overwrite entries.
- **skills/registry.md is always checked first** — agents load relevant skill files before any task.

---

## Key file formats

**`state/active.json`** — tracks session state (active project, stage, open questions).

**`loop.md`** — timestamped iteration log. Each entry: date, tried, result, next. Status: `active` → `complete`.

**`materials.md`** — live BOM. Updated when any component changes. Not a final doc.

**`prototype-v{n}.md`** — versioned, never overwritten. New version = new file.

---

## Signal and component conventions (apply to all agent output)

- State signal level context: line (+4dBu / -10dBV), instrument (Hi-Z), mic (balanced), modular (±5V / 10Vpp)
- All component references: full part number, supplier, price in EUR, package type
- Breadboard-first. Through-hole preferred. No SMD unless requested.
- Power: ±12V or USB +5V unless spec says otherwise
- Firmware default: Daisy Seed + C++ + DaisySP

---

## Out of scope

Consumer electronics repair, RF/radio hardware, anything outside audio signal path + control hardware. Do not build graphify, llm-council, or autoresearch from scratch.
