# BENCH Playbook

How to use BENCH session by session.

---

## Opening a session

```bash
bench
```

BENCH reads `state/active.json` and shows the startup menu:

```
🎛  BENCH — KLANG
────────────────────────────────────────

Last active: 001-five-channel-mixer  [iterate]
Last session: 2026-04-16
Open questions: 2

  [R] Resume      [N] New project      [L] List all
```

Type your choice. BENCH loads the project context and picks up where you left off.

---

## Starting a new project

Choose **N**. BENCH asks:
1. What are you building?
2. What's the ID and name? (e.g. `002 spring-reverb`)

It scaffolds the project folder, asks research questions, and gets to work.

---

## The five stages

### 1. Idea
Describe what you want. BENCH asks up to 3 clarifying questions at a time — signal path, format, constraints, quality level. Answer them. Keep going until you say "let's research it."

### 2. Research
BENCH checks its skills library, queries anything you've dropped into `raw/`, and uses Perplexity for gaps. It comes back with 2–3 topology options, a recommendation, and an initial BOM. You review and say "looks good, let's prototype."

### 3. Prototype
BENCH writes `prototype-v1.md` — breadboard layout, signal flow diagram, block diagram, component list with exact values, and a step-by-step test procedure. `loop.md` is initialised.

### 4. Iterate (the loop)
This is where most time is spent.

- You build something
- You tell BENCH what happened: *"output stage is oscillating above 3kHz"*
- BENCH reads the full loop history, diagnoses, proposes **one change**
- You try it, report back
- BENCH logs the entry and proposes the next change

One variable at a time. This is how you isolate causes.

**Adding datasheets mid-loop:** drop anything into `projects/{id}/raw/`. Tell BENCH — it indexes it and uses it in the next diagnosis.

**When it works:** say "this works, let's lock it." BENCH marks the loop complete and summarises what was learned.

### 5. Promote (optional)
Say "let's promote this." BENCH creates the `promote/` folder with:
- `schematic-brief.md` — net list, pinouts, power rails (take this into KiCad)
- `bom-final.md` — verified part numbers, current Mouser prices
- `production-notes.md` — enclosure, PCB house, assembly notes

---

## Dropping files into raw/

Drop anything into `projects/{id}/raw/` at any time:
- Datasheets (PDF)
- Reference schematics
- Photos of breadboards
- Handwritten notes (photo)
- YouTube links (BENCH can add via Perplexity)

Tell BENCH you've dropped something in. It indexes it and uses it immediately.

---

## Learning a new skill

Say: "learn [topic]" or "add a skill for [topic]."

BENCH researches it, writes a draft to `skills/_drafts/`. You review, then say "publish it" to move it into the main skills library.

---

## What BENCH won't do

- Invent pinouts, part numbers, or values — it will say so and look them up
- Work outside audio hardware scope
- Propose multiple changes at once in the loop
- Promote a project with an active (incomplete) loop

---

## Tips

- **Be specific about symptoms.** "It oscillates" is less useful than "output oscillates above 3kHz, stops when I touch the opamp."
- **Mention measurements.** Vce, signal level at each probe point, supply rail voltages — the more data, the faster the diagnosis.
- **Drop in datasheets early.** Before research is better than mid-loop.
- **One project at a time.** BENCH tracks one active project. Switch with L → pick.
