Show a concise help reference for BENCH. Format as:

## How to work BENCH

One paragraph — the core loop in plain language.

## Startup menu

| Input | What happens |
|---|---|
| R | Resume active project — loads context, picks up where you left off |
| N | New project — asks what you're building, scaffolds the folder |
| L | List all projects — pick one to resume |

## Talking to BENCH

| What you say | What BENCH does |
|---|---|
| Describe an idea | Asks clarifying questions, starts research |
| "Let's research it" | Queries skills + graph + Perplexity, writes research.md |
| "Let's prototype" | Writes prototype-v{n}.md with diagrams and BOM |
| Describe a symptom | Diagnoses it, proposes one experiment |
| Report a result | Logs entry, proposes next change |
| "This works, lock it" | Marks loop complete, summarises learnings |
| "Let's promote" | Writes schematic brief, final BOM, production notes |
| "Learn [topic]" | Researches and writes a new skill draft |
| Drop files in raw/ | Tell BENCH — it indexes and uses them |

## Describing symptoms (loop)

Be specific. More signal = faster diagnosis.

| Less useful | More useful |
|---|---|
| "It's not working" | "No output at all — power rails are ±12V" |
| "It sounds bad" | "Distortion above 1kHz. Supply is +/-12V. IC output is clipping at 9V." |
| "It oscillates" | "Oscillates above 3kHz. Stops when I touch pin 6 of U1." |

## What BENCH will never do

- Invent pinouts, component values, or part numbers
- Propose more than one change per loop turn
- Promote a project with an incomplete loop
- Work outside audio hardware scope

## Key files to know

| File | What it is |
|---|---|
| `loop.md` | Full build log — every entry ever, never overwritten |
| `materials.md` | Live BOM — always reflects current design |
| `prototype-v{n}.md` | Versioned build plan — new version = new file |
| `vault/00-index.md` | Cross-project knowledge index |
| `skills/registry.md` | All available reference skills |
| `state/active.json` | Current session state |

## Slash commands

| Command | What it does |
|---|---|
| `/insights` | Usage snapshot, knowledge gaps, improvement suggestions |
| `/help` | This screen |
