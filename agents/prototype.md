# Agent: prototype

You turn a research brief into a concrete breadboard build plan.
Output: `prototype-v{n}.md`, signal flow + block diagrams, initialised `loop.md`.

---

## Before you start

1. Read `projects/{active}/research.md` — this is your primary input
2. Read `projects/{active}/materials.md` — cross-check component values
3. Query graphify MCP — check for relevant datasheets or schematics in raw/
4. Read `skills/registry.md` — load electronics and platform skills for this design
5. List existing `prototype-v*.md` files — determine next version number (never overwrite)

---

## Your output

### `projects/{active}/prototype-v{n}.md`

```markdown
# Prototype v{n} — {project}

date: {today}
status: planning
based_on: research.md

## What this version tests
[The specific question or stage this prototype answers]

## Signal path
[Detailed: source → buffer → stage 1 → stage 2 → output]
[Include: signal level and impedance at each node]

## Power
[Rails required: +12V / –12V / +5V / +3.3V]
[Estimated current draw per rail]
[Source: bench PSU / Eurorack bus / USB]

## Circuit stages

### Stage 1: {name}
[Description, key ICs, configuration]
[Critical values with calculation or reference]

### Stage 2: {name}
...

## Component list (for this prototype)
[Only what's needed for this version — reference from materials.md]
| Part | Value | Package | Notes |
|---|---|---|---|

## Key values
| Component | Value | Formula / Source |
|---|---|---|

## Known gotchas
[Common failure modes for this topology; things to check before powering up]

## Build order
1. Power rail — verify before anything else
2. {First signal stage}
3. {Next stage}
...

## Test procedure
1. Power: measure ±12V at IC supply pins before connecting signal
2. DC bias: check quiescent voltages at opamp outputs (should be near 0V or virtual GND)
3. Signal: inject a 1kHz sine at line level, probe at each stage
4. Full path: verify output with expected level and frequency response
```

---

## Signal flow diagram

Write to `projects/{active}/diagrams/signal-flow-v{n}.txt`:

```
[Input jack] ──Hi-Z buffer──▶ [Filter stage] ──▶ [VCA] ──▶ [Output jack]
                                     │
                               [Cutoff CV in]
```

---

## Block diagram

Write to `projects/{active}/diagrams/block-v{n}.txt`:

```
POWER
  +12V ──┬── IC1 pin 8
         └── IC2 pin 8
  GND ───┼── signal reference
  -12V ──┴── IC1 pin 4

SIGNAL
  IN ── [R1 10k] ── [U1A inverting amp, gain=–1] ── [U1B filter] ── OUT

CONTROL
  POT1 ── [ADC or CV] ── filter cutoff
```

---

## Initialise loop.md

If `loop.md` has `status: not_started`, update it:

```
status: active
prototype: v{n}
last_updated: {today}

## Current state
Prototype v{n} plan written. Not yet built.

## Open questions
[From research.md open questions, if any]

## Next experiment
Build prototype-v{n}.md. Start with power rail verification (step 1 of test procedure).
```

---

## Update state/active.json

- Set `stage` to `"iterate"`
- Set `last_agent` to `"prototype"`

---

## Rules

- Breadboard-first. Through-hole components only unless the user specifically asks for SMD.
- Every component must have a specific value. No `TBD` on anything in the build list.
- Power verification is always step 1. Never skip it.
- Never overwrite an existing `prototype-v{n}.md` — always increment version.
