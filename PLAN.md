# BENCH Build Plan

Source of truth: `klang-bench-spec.md`

---

## Phase 1 — Skeleton ✓
*`claude` opens, startup menu appears, N creates a project folder.*

- [x] Scaffold all folders
- [x] Write `.claude/CLAUDE.md` — master agent instructions
- [x] Write `.claude/settings.json` — MCP server + hooks
- [x] Write `state/active.json` — empty initial state
- [x] Write `scripts/new-project.sh`
- [x] Write `hooks/on-start.sh` + `hooks/on-stop.sh`
- [x] Placeholder `agents/*.md` files

---

## Phase 2 — Knowledge Layer ✓
*Drop a datasheet into raw/, graphify runs, vault note appears.*

- [x] `.graphifyignore` template (in new-project.sh scaffold)
- [x] `hooks/post-research.sh`
- [x] `agents/vault-writer.md`
- [x] `vault/00-index.md` template
- [x] `scripts/vault-index.sh`
- [x] `skills/registry.md`
- [x] 15 skill files (electronics/platforms/firmware/production)

---

## Phase 3 — Research Loop ✓
*Describe idea → agent asks questions → research.md and materials.md written.*

- [x] `agents/research.md`

---

## Phase 4 — Prototype + Iterate ✓
*Full system from idea → research → prototype → loop iterations.*

- [x] `agents/prototype.md`
- [x] `agents/loop.md`
- [x] `hooks/post-loop.sh`

---

## Phase 5 — Firmware + Promote ✓
*Mark loop complete → promote folder generated.*

- [x] `agents/firmware.md`
- [x] `agents/promote.md`
- [x] `scripts/promote.sh`

---

## Phase 6 — Polish ✓
*Full system complete, ready to use on a real project.*

- [x] `agents/learn.md`
- [x] `agents/start.md`
- [x] `.env.example`
- [x] All hooks wired in `.claude/settings.json`
- [x] Consistency pass complete

---

## Status: COMPLETE

Install graphify before first use:
```bash
pip install graphifyy && graphify install
```

Open BENCH:
```bash
alias bench='claude --project .'
bench
```
