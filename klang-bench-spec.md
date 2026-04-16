# BENCH — Architecture Spec
### The internal design system for KLANG hardware

BENCH is a Claude Code agent system for designing and building audio hardware devices under the KLANG brand. It runs locally on Mac/Linux. You open it, talk to it, build things with it. Everything for a project lives in one folder. Knowledge accumulates across projects over time.

---

## Names

| Name | What it is |
|---|---|
| **KLANG** | The hardware brand. The thing you're building with Noel. |
| **BENCH** | This system. The internal copilot tool. |
| `bench` | The CLI command you type to open it. |
| `klang` | The GitHub repo (`git@github.com:greenlieberd/klang.git`) |

---

## Libraries this system uses

BENCH is built on top of three existing open-source libraries. Do not reinvent these — install and use them.

### graphify
`pip install graphifyy && graphify install`

Turns the project's `raw/` folder into a queryable knowledge graph. Drops anything in — PDFs, datasheets, images of schematics, YouTube links, forum threads, photos of breadboards. Run `/graphify ./raw --obsidian --obsidian-dir ../../vault` and it populates the Obsidian vault automatically. Exposes itself as an MCP server so agents query the graph directly instead of grepping flat files.

Key commands used in BENCH:
```bash
/graphify ./raw --obsidian --obsidian-dir ../../vault   # populate vault from project raw/
/graphify ./raw --update                                 # re-run on changed files only
python -m graphify.serve graphify-out/graph.json        # start MCP server for agent queries
/graphify add <url>                                      # add a URL directly to the graph
```

### llm-council
`git clone https://github.com/karpathy/llm-council && cd llm-council && uv sync`

Used when a genuine design decision exists — topology A vs B, platform choice, IC selection. The council agent calls multiple models, they critique each other, a chairman synthesises the answer. BENCH uses this via the API pattern from llm-council, not the full web app. The council call is triggered inside the research agent when a decision fork is detected.

Requires `OPENROUTER_API_KEY` in `.env`.

### autoresearch (loop pattern)
`git clone https://github.com/karpathy/autoresearch`

BENCH does not run autoresearch directly — it borrows the `program.md` loop pattern. Each project has a `loop.md` which functions like autoresearch's `program.md`: human-editable, agent-readable, the shared memory of the build iteration. The agent reads it, proposes one change, you test it, you write the result back. The agent proposes the next change. This is the build loop.

---

## Repo structure

```
klang-bench/
├── .claude/
│   ├── CLAUDE.md              # Master agent instructions — loaded every session
│   └── settings.json          # Claude Code tool permissions
│
├── agents/
│   ├── start.md               # Session start: reads state, shows menu
│   ├── research.md            # Queries graph + web, writes research.md
│   ├── council.md             # Multi-model design decision resolver
│   ├── prototype.md           # Breadboard plan + signal flow diagram
│   ├── loop.md                # Iteration agent — reads/writes loop.md
│   ├── promote.md             # Prototype → schematic brief + production BOM
│   ├── firmware.md            # C++/Daisy/Pure Data/VST code
│   ├── learn.md               # Learns new skill from input or web
│   └── vault-writer.md        # Structures output into vault
│
├── hooks/
│   ├── on-start.sh            # Triggers start agent on Claude Code open
│   ├── post-research.sh       # Runs graphify, updates vault index
│   ├── post-loop.sh           # Stamps loop.md entry with timestamp
│   └── post-learn.sh          # Registers new skill in registry
│
├── skills/
│   ├── registry.md            # Index of all skills — agents check this first
│   ├── electronics/
│   │   ├── opamp-audio.md
│   │   ├── passive-components.md
│   │   ├── audio-signal-levels.md
│   │   ├── power-supply-design.md
│   │   └── analog-filters.md
│   ├── platforms/
│   │   ├── daisy-seed.md
│   │   ├── arduino.md
│   │   └── eurorack-format.md
│   ├── firmware/
│   │   ├── cpp-daisy.md
│   │   ├── pure-data.md
│   │   ├── midi-protocol.md
│   │   └── vst-plugin.md
│   ├── production/
│   │   ├── kicad-workflow.md
│   │   ├── pcb-design-rules.md
│   │   └── 3d-printing-enclosures.md
│   └── _drafts/               # Skills in progress, flagged [DRAFT]
│
├── projects/
│   └── {id}-{slug}/           # One folder per project — fully self-contained
│       ├── raw/               # Drop zone: datasheets, images, links, anything
│       ├── graphify-out/      # Knowledge graph for this project (auto-generated)
│       ├── diagrams/          # Signal flow, block diagrams, visual outputs
│       ├── firmware/          # Code files (if applicable)
│       ├── promote/           # Created only when promoted
│       │   ├── schematic-brief.md
│       │   ├── bom-final.md
│       │   └── production-notes.md
│       ├── idea.md            # Brief, questions asked, decisions made
│       ├── research.md        # Components, topologies, council outputs
│       ├── materials.md       # Live BOM — updated throughout the project
│       ├── loop.md            # Full iteration log (the autoresearch pattern)
│       └── prototype-v{n}.md  # Versioned build plans — never overwritten
│
├── vault/                     # Global Obsidian vault — grows across all projects
│   ├── .obsidian/
│   ├── 00-index.md
│   ├── components/
│   ├── datasheets/
│   ├── platforms/
│   ├── projects/
│   ├── ideas/
│   └── references/
│
├── state/
│   └── active.json            # Active project, stage, open questions
│
├── scripts/
│   ├── new-project.sh         # Scaffolds project folder + vault entry
│   ├── promote.sh             # Moves project to production stage
│   └── vault-index.sh         # Rebuilds vault/00-index.md
│
├── .env                       # OPENROUTER_API_KEY (gitignored)
├── .gitignore
└── README.md
```

---

## CLAUDE.md — master agent instructions

```markdown
# BENCH — Audio Hardware Copilot for KLANG

You are the internal design copilot for KLANG, a hardware audio brand.
Your job: help design, prototype, iterate, and produce audio devices.

Scope: mixers, synthesizers, effects pedals, DSPs, oscillators, VCOs, filters,
amplifiers, MIDI devices, Eurorack modules, DAW plugins, VST plugins, and
all related hardware and firmware. Nothing outside this domain.

## Session startup
Always run the start agent on first turn. Read state/active.json.
Show the startup menu. Load the active project context before responding.

## Per-project knowledge
Every project has its own raw/ folder and graphify-out/graph.json.
Before any task, check if graph.json exists for the active project.
If yes, query it via MCP (python -m graphify.serve) before doing anything else.
If raw/ has new files since last graphify run, offer to run /graphify first.

## Global vault
vault/ accumulates knowledge across all projects.
Every component note, platform note, and build learning goes there via vault-writer.
Check vault/00-index.md and skills/registry.md at the start of every task.

## Skills
Check skills/registry.md before starting any task.
Read relevant skill files into context. If no skill exists, say so and offer to learn it.

## Unknown territory
No vault note, no skill, no graph hit for something you need:
1. Say: "I don't have notes on [X]. I can research this — want me to?"
2. If yes: use web search or /graphify add <url>. Write draft to skills/_drafts/.
3. Proceed with best effort. Mark uncertain claims [NEEDS VERIFICATION].
Never invent pinouts, values, or part numbers.

## Design decisions
If a genuine fork exists (topology A vs B, platform choice, IC selection):
Trigger council agent. 3 models answer independently, critique, synthesise.
Present the result with the dissenting view noted.

## Signal conventions
Always state: line (+4dBu / -10dBV), instrument (Hi-Z), mic (balanced low),
modular (±5V / 10Vpp). Note impedance when relevant.

## Component references
Always include: full part number, supplier (Mouser/Digi-Key/Thonk/JLCPCB),
price in EUR, package type, reason it fits the design.

## Prototype rules
Breadboard-first. Through-hole preferred. No SMD unless requested.
Power: ±12V or USB +5V unless spec says otherwise.

## Firmware
Daisy Seed + C++ + DaisySP by default.
Pure Data for patch-based audio work.
VST/DAW plugins when the project calls for it.
Always comment the audio signal path through the code.

## materials.md
This is the live BOM. Update it whenever a component is added, changed, or removed.
It is not a final document — it is always current.

## loop.md
This is the build iteration log. Write every observation, hypothesis, and result here.
Each entry: date, what was tried, what happened, what to try next.
Read the full log before proposing any change — context from earlier iterations matters.

## Diagrams
For every prototype plan, generate:
- A signal flow diagram (text-based or SVG) saved to diagrams/
- A block diagram showing power, signal, and control paths

## Production stage
Only on explicit promotion request.
Output: schematic-brief.md (nets, pinouts, power rails), bom-final.md (verified part numbers),
production-notes.md (enclosure, PCB house, mechanical notes).
```

---

## User journey

### 1. Open BENCH
`bench` in terminal. Start hook runs. Reads `state/active.json`.

```
🎛  BENCH — KLANG

Last active: 001-five-channel-mixer  [iterate]
2 days ago · 8 loop entries · 3 open questions

  [R] Resume      [N] New project      [L] List all
```

### 2. Idea + research (conversational)
You describe the idea. Agent asks questions back and forth until the plan is solid. You drop anything relevant into `raw/` — datasheets, reference schematics, links. Agent runs `/graphify` on `raw/`, reads the graph, uses web search for gaps. Hard decisions trigger the council agent. When you say "let's build it" — research.md and materials.md are written.

### 3. Prototype plan
Agent produces `prototype-v1.md` — breadboard layout, signal path, BOM with values, power rail, gotchas. Diagrams written to `diagrams/`. You review, ask questions, agent refines. `loop.md` initialised.

### 4. Build + iterate (the loop)
You build. You talk to it. "Output stage is oscillating." Agent reads `loop.md`, asks diagnostic questions, proposes one change. You test. You report back. Agent writes to `loop.md`, proposes next change. You drop new datasheets into `raw/` mid-loop — agent runs `/graphify`, updates `materials.md`. Loop continues until it works.

### 5. Done
You say "this works, let's lock it." Agent marks `loop.md` status: complete. `materials.md` finalised. All vault learnings written.

### 6. Promote (optional)
You say "let's promote this." `promote/` folder created. Schematic brief, final BOM, enclosure notes. You take the schematic brief into KiCad.

---

## loop.md format

```markdown
# Loop — 001-five-channel-mixer

status: active
prototype: v2
last_updated: 2026-04-16

## Current state
Output stage working. Channel 2 volume lower than others. LEDs too bright.

## Open questions
- Is the pot taper mismatch on ch2 or a resistor value?
- LED resistor value for ~2mA at 12V?

## Next experiment
Swap ch2 pot for audio taper 10k. Measure before/after.

---

### Entry 003 — 2026-04-16
Tried: R4 47k → 22k
Result: Oscillation fixed. Vce now 1.1V. Channel 2 still low.
Next: Check pot taper on ch2.

### Entry 002 — 2026-04-15
Tried: C3 100nF → 470nF
Result: Made oscillation worse.
Next: Look at bias point instead of cap.

### Entry 001 — 2026-04-14
Built v1. Output stage oscillating above 3kHz immediately.
Next: Diagnose bias — Vce on Q2 is 0.4V, should be ~1V.
```

---

## materials.md format

```markdown
# Materials — 001-five-channel-mixer

last_updated: 2026-04-16
status: active

## ICs
| Part | Value | Package | Qty | Supplier | Price |
|---|---|---|---|---|---|
| TL074CN | Quad opamp | DIP-14 | 2 | Mouser | €0.80 |

## Resistors
| Value | Tolerance | Qty | Notes |
|---|---|---|---|
| 10kΩ | 1% | 20 | Input summing |

## Capacitors
...

## Connectors
...

## Mechanical
...

## Added mid-build
| Part | Added | Reason |
|---|---|---|
| 3mm red LED | Entry 004 | Channel indicator |
| 470Ω resistor | Entry 004 | LED current limiting |
```

---

## state/active.json format

```json
{
  "active_project": "001-five-channel-mixer",
  "stage": "iterate",
  "last_session": "2026-04-16T18:32:00",
  "last_agent": "loop",
  "open_questions": [
    "Pot taper mismatch on ch2?",
    "LED resistor value at 12V?"
  ]
}
```

---

## Installation and setup

```bash
# 1. Clone the repo
git clone git@github.com:greenlieberd/klang.git
cd klang-bench

# 2. Install graphify
pip install graphifyy
graphify install   # installs Claude Code skill + PreToolUse hook

# 3. Install llm-council dependencies
pip install openrouter   # or follow llm-council setup for council API calls

# 4. Set up environment
cp .env.example .env
# Add OPENROUTER_API_KEY to .env

# 5. Install Claude Code hook
# Add to .claude/settings.json — hooks.on-start → scripts/on-start.sh

# 6. Open BENCH
claude   # Claude Code reads .claude/CLAUDE.md automatically
# or alias: bench='claude --project .'
```

---

## Build plan for coding agent

This is what the coding agent builds in order. Each step is independently testable.

### Phase 1 — Skeleton (get it opening)
1. Create repo structure — all folders, empty placeholder files
2. Write `CLAUDE.md` with full master instructions
3. Write `state/active.json` with empty state
4. Write `scripts/new-project.sh` — scaffolds project folder with all template files
5. Write `on-start.sh` hook — reads state, prints startup menu, handles R/N/L input
6. Test: `claude` opens, menu appears, N creates a project folder

### Phase 2 — Knowledge layer (get graphify working)
7. Write `.graphifyignore` template for project raw/ folders
8. Write `post-research.sh` hook — runs graphify on project raw/, calls vault-writer
9. Write `vault-writer.md` agent instructions
10. Write `vault/00-index.md` template and `scripts/vault-index.sh`
11. Write initial skill files: opamp-audio.md, audio-signal-levels.md, daisy-seed.md
12. Write `skills/registry.md` with initial entries
13. Test: drop a datasheet PDF into a project raw/, graphify runs, vault note appears

### Phase 3 — Research loop (get ideation working)
14. Write `agents/research.md` — queries graph via MCP, web search fallback
15. Write `agents/council.md` — OpenRouter multi-model call pattern
16. Test: start a new project, describe idea, agent asks questions, research.md written

### Phase 4 — Prototype and iterate (core loop)
17. Write `agents/prototype.md` — reads research.md, writes prototype-v1.md + diagrams
18. Write `agents/loop.md` — reads/writes loop.md, proposes one change per turn
19. Write `hooks/post-loop.sh` — timestamps loop entries
20. Test: full flow from idea → research → prototype → 3 loop iterations

### Phase 5 — Firmware + promote
21. Write `agents/firmware.md` — C++/Daisy/Pure Data/VST
22. Write `agents/promote.md` — reads prototype, writes promote/ folder
23. Write `scripts/promote.sh`
24. Test: mark loop complete, run promote, check output files

### Phase 6 — Polish
25. Write `agents/learn.md` — learn new skill from input or web
26. Write `hooks/post-learn.sh` — registers in registry
27. Write `README.md` with setup instructions
28. Write remaining skill files
29. End-to-end test: full project from idea to promoted output

---

## What is explicitly out of scope

- Consumer electronics repair
- RF / radio hardware
- Anything outside audio signal path and related control hardware
- Building new versions of graphify, llm-council, or autoresearch
```
