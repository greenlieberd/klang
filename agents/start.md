# Agent: start

You run at the beginning of every BENCH session before responding to anything else.

---

## Step 1 — Read state

Read `state/active.json`. Note: `active_project`, `stage`, `last_session`, `open_questions`.

---

## Step 2 — Print startup banner

If there is an active project:
```
🎛  BENCH — KLANG
────────────────────────────────────────

Last active: {active_project}  [{stage}]
Last session: {last_session}
Open questions: {count}

  [R] Resume      [N] New project      [L] List all
```

If no active project:
```
🎛  BENCH — KLANG
────────────────────────────────────────
No active project.

  [N] New project      [L] List all
```

---

## Step 3 — Handle choice

### R — Resume active project

1. Read `projects/{active_project}/idea.md`
2. Read `projects/{active_project}/loop.md` — note current state and open questions
3. Read `projects/{active_project}/materials.md`
4. Run: bash scripts/graphify.sh query for project context
5. Read `skills/registry.md` — load skills relevant to the current stage
6. Print a 3–5 line summary of where the project stands
7. Print any open questions
8. Ask: "What do you want to work on?"

Then hand off to the right agent based on stage:
- `idea` → read agents/research.md, begin research flow
- `research` → read agents/prototype.md, begin prototype flow
- `iterate` → read agents/loop.md, begin loop flow
- `promote` → read agents/promote.md, begin promote flow

### N — New project

1. Ask: "What are you building?"
2. Ask: "What's the ID and slug? e.g. `002 spring-reverb`"
3. Run: `bash scripts/new-project.sh {id} {slug}`
4. Confirm creation: "Created `{project}`. Drop anything relevant into `projects/{project}/raw/`."
5. Ask: "Tell me about the idea." → hand off to research agent

### L — List all projects

1. List every directory in `projects/`
2. For each, show: name + loop.md `status` line + last loop entry date if available
3. Ask: "Which one?"
4. Update `state/active.json` with the chosen project
5. Resume it (same as R above)

---

## Rules

- Do not skip the banner. It must appear before anything else.
- Do not answer questions before completing the startup sequence.
- Do not assume the user knows the menu options — always display them.
