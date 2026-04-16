# BENCH Build Plan

Source of truth: `klang-bench-spec.md`

---

## Phase 1 — Skeleton
*Goal: `claude` opens, startup menu appears, N creates a project folder.*

- [ ] Scaffold all folders: `.claude/`, `agents/`, `hooks/`, `skills/electronics/`, `skills/platforms/`, `skills/firmware/`, `skills/production/`, `skills/_drafts/`, `projects/`, `vault/.obsidian/`, `vault/components/`, `vault/datasheets/`, `vault/platforms/`, `vault/projects/`, `vault/ideas/`, `vault/references/`, `state/`, `scripts/`
- [ ] Write `.claude/CLAUDE.md` — master agent instructions (content from spec § CLAUDE.md)
- [ ] Write `.claude/settings.json` — hook permissions + graphify MCP server config
- [ ] Write `state/active.json` — empty initial state
- [ ] Write `scripts/new-project.sh` — scaffolds `projects/{id}-{slug}/` with all template files (raw/, graphify-out/, diagrams/, firmware/, idea.md, research.md, materials.md, loop.md)
- [ ] Write `hooks/on-start.sh` — starts graphify MCP server for active project, reads state/active.json, prints startup menu (Resume / New / List), handles input
- [ ] Write `hooks/on-stop.sh` — kills graphify MCP server process on session end
- [ ] Add placeholder `agents/*.md` files (empty, to be filled in later phases)

---

## Phase 2 — Knowledge Layer
*Goal: Drop a datasheet into raw/, graphify runs, vault note appears.*

- [ ] Write `.graphifyignore` template inside project scaffold
- [ ] Write `hooks/post-research.sh` — runs `graphify ./raw --update`, restarts MCP server with fresh graph, calls vault-writer agent
- [ ] Write `agents/vault-writer.md` — structures graphify output into vault/ notes
- [ ] Write `vault/00-index.md` template
- [ ] Write `scripts/vault-index.sh` — rebuilds vault/00-index.md from vault contents
- [ ] Write `skills/registry.md` — index of all skill files
- [ ] Write initial skill files:
  - `skills/electronics/opamp-audio.md`
  - `skills/electronics/audio-signal-levels.md`
  - `skills/electronics/passive-components.md`
  - `skills/electronics/power-supply-design.md`
  - `skills/electronics/analog-filters.md`
  - `skills/platforms/daisy-seed.md`
  - `skills/platforms/eurorack-format.md`
  - `skills/platforms/arduino.md`
  - `skills/firmware/cpp-daisy.md`
  - `skills/firmware/pure-data.md`
  - `skills/firmware/midi-protocol.md`
  - `skills/firmware/vst-plugin.md`
  - `skills/production/kicad-workflow.md`
  - `skills/production/pcb-design-rules.md`
  - `skills/production/3d-printing-enclosures.md`

---

## Phase 3 — Research Loop
*Goal: Describe idea → agent asks questions → research.md and materials.md written.*

- [ ] Write `agents/research.md` — checks skills/registry.md, queries graphify MCP server for project context, falls back to web search, asks clarifying questions, writes research.md and initialises materials.md

---

## Phase 4 — Prototype + Iterate
*Goal: Full system from idea → research → prototype → loop iterations.*

- [ ] Write `agents/prototype.md` — reads research.md, writes prototype-v{n}.md with breadboard layout, BOM, signal path, gotchas; writes diagrams/signal-flow and diagrams/block; initialises loop.md
- [ ] Write `agents/loop.md` — reads full loop.md history before every response, proposes one change per turn, writes timestamped entry; re-queries MCP if new files dropped into raw/
- [ ] Write `hooks/post-loop.sh` — stamps each loop.md entry with ISO timestamp on write

---

## Phase 5 — Firmware + Promote
*Goal: Mark loop complete → promote folder generated.*

- [ ] Write `agents/firmware.md` — Daisy Seed + C++ + DaisySP default; Pure Data for patch work; VST when called for; always comments audio signal path through code
- [ ] Write `agents/promote.md` — reads active prototype and loop.md, creates promote/ folder with schematic-brief.md, bom-final.md, production-notes.md
- [ ] Write `scripts/promote.sh` — sets loop.md status: complete, creates promote/ folder, triggers promote agent

---

## Phase 6 — Polish
*Goal: Full system complete, ready to use on a real project.*

- [ ] Write `agents/learn.md` — learns new skill from user input or web, writes draft to skills/_drafts/
- [ ] Write `hooks/post-learn.sh` — registers new skill in skills/registry.md
- [ ] Write `agents/start.md` — full session startup: reads state/active.json, shows menu, loads project context
- [ ] Write `.env.example` with placeholder keys
- [ ] Verify all hooks are wired in `.claude/settings.json`
- [ ] Full read-through of every agent file for consistency
