# BENCH — System Reference

Full reference for the BENCH architecture. For day-to-day usage see `PLAYBOOK.md`.

---

## System map

```
klang/
├── .claude/
│   ├── CLAUDE.md          Master agent instructions — loaded every session
│   └── settings.json      Hook config (Stop, PostToolUse)
│
├── agents/                Agent instruction files — Claude reads these as context
│   ├── start.md           Session startup: reads state, shows menu
│   ├── research.md        Queries graph + Perplexity, writes research.md
│   ├── prototype.md       Writes prototype-v{n}.md + diagrams, inits loop.md
│   ├── loop.md            One-experiment-per-turn build iteration partner
│   ├── firmware.md        C++/Daisy/Pure Data/JUCE code
│   ├── promote.md         Writes schematic-brief, bom-final, production-notes
│   ├── learn.md           Learns new skill → skills/_drafts/
│   └── vault-writer.md    Structures graphify output into vault/ notes
│
├── hooks/                 Shell scripts triggered by Claude Code hook events
│   ├── on-start.sh        Prints state context for start agent
│   ├── on-stop.sh         Stamps last_session timestamp on exit (Stop hook)
│   ├── post-research.sh   Runs graphify --update after research
│   ├── post-loop.sh       Updates state after loop.md write (PostToolUse hook)
│   └── post-learn.sh      Registers new skills in registry (PostToolUse hook)
│
├── scripts/               Internal tools — called by agents, not by user
│   ├── new-project.sh     Scaffolds projects/{id}-{slug}/ with all templates
│   ├── graphify.sh        Graphify CLI wrapper (query/explain/update/add)
│   ├── research.sh        Perplexity web research → optional vault save
│   ├── perplexity.py      Perplexity API client (sonar / sonar-pro)
│   ├── vault-index.sh     Rebuilds vault/00-index.md
│   └── promote.sh         Marks loop complete, creates promote/ folder
│
├── skills/                Reference docs agents load into context per task
│   ├── registry.md        Index — checked at the start of every task
│   ├── electronics/       opamp-audio, audio-signal-levels, passive-components,
│   │                      power-supply-design, analog-filters
│   ├── platforms/         daisy-seed, eurorack-format, arduino
│   ├── firmware/          cpp-daisy, pure-data, midi-protocol, vst-plugin
│   ├── production/        kicad-workflow, pcb-design-rules, 3d-printing-enclosures
│   └── _drafts/           Skills in review — not yet in registry
│
├── projects/              One self-contained folder per hardware project
│   └── {id}-{slug}/
│       ├── raw/           Drop zone: datasheets, schematics, images, anything
│       │   └── graphify-out/  Knowledge graph (auto-generated)
│       ├── diagrams/      Signal flow and block diagrams
│       ├── firmware/      Code files
│       ├── promote/       Created on promotion: schematic-brief, bom-final, production-notes
│       ├── idea.md        Concept, open questions, decisions
│       ├── research.md    Topologies, components, signal path
│       ├── materials.md   Live BOM — always current
│       ├── loop.md        Build iteration log
│       └── prototype-v{n}.md  Versioned build plans — never overwritten
│
├── vault/                 Global Obsidian vault — grows across all projects
│   ├── 00-index.md        Auto-rebuilt by vault-index.sh
│   ├── components/        Individual component notes (e.g. TL074.md)
│   ├── datasheets/        Datasheet summaries
│   ├── platforms/         Platform notes
│   ├── projects/          Cross-project references
│   ├── ideas/             Undeveloped ideas
│   └── references/        Forum threads, app notes, web research
│
├── state/
│   └── active.json        Active project, stage, last session, open questions
│
└── .env                   PERPLEXITY_API_KEY (gitignored)
```

---

## Agent flow

```
Session open
    │
    ▼
start.md ── reads state/active.json
    │       shows menu: R / N / L
    │
    ├── R ─▶ load project context ─▶ hand off to stage agent
    ├── N ─▶ new-project.sh ─▶ research.md
    └── L ─▶ list projects ─▶ pick one ─▶ load context

Stage agents:
  idea      ─▶ research.md
  research  ─▶ prototype.md
  iterate   ─▶ loop.md  (repeating)
  promote   ─▶ promote.md
```

---

## Knowledge lookup order

Every agent checks in this order before doing anything:

1. `skills/registry.md` — load relevant skill files
2. `bash scripts/graphify.sh query "..."` — check project graph
3. `vault/00-index.md` — check accumulated cross-project knowledge
4. `bash scripts/research.sh "..." --deep` — Perplexity web search (if key present)

---

## Graphify — two modes

| Mode | When | Command |
|---|---|---|
| Code indexing | Firmware files in raw/ | `bash scripts/graphify.sh update` |
| Full extraction | Docs, PDFs, images, datasheets | Invoke `/graphify` skill in Claude Code |

Graph lives at: `projects/{id}/raw/graphify-out/graph.json`

---

## loop.md format

```markdown
# Loop — {project}

status: active | complete
prototype: v{n}
last_updated: YYYY-MM-DD

## Current state
[1–3 sentences: where things stand right now]

## Open questions
- [unresolved items]

## Next experiment
[exactly one thing to try]

---

### Entry {n} — YYYY-MM-DD
Tried: [what was done]
Result: [what happened]
Diagnosis: [what this tells us]
Next: [one thing to try next]
```

---

## materials.md format

```markdown
# Materials — {project}

last_updated: YYYY-MM-DD
status: active | complete

## ICs
| Part | Value | Package | Qty | Supplier | Price |
...

## Added mid-build
| Part | Added | Reason |
...
```

---

## state/active.json format

```json
{
  "active_project": "001-five-channel-mixer",
  "stage": "iterate",
  "last_session": "2026-04-16T18:32:00",
  "last_agent": "loop",
  "open_questions": ["Pot taper on ch2?", "LED resistor at 12V?"]
}
```

---

## Conventions

**Components:** always include full part number, supplier, price in EUR, package type.

**Signal levels:** always state at each node — line (+4dBu / -10dBV), instrument (Hi-Z), mic (balanced), modular (±5V / 10Vpp).

**Prototype:** breadboard-first, through-hole preferred, no SMD unless asked. Power verification is always step 1.

**Firmware default:** Daisy Seed + C++ + DaisySP. Pure Data for patch work. JUCE for VST/AU.

**Never:** invent pinouts, values, or part numbers. Never propose multiple loop changes at once.
