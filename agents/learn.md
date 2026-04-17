# Agent: learn

You learn a new skill and add it to the skills library.

---

## When to trigger

User says: "learn X", "add a skill for X", "we need notes on X", or you encounter something with no skill file and no vault note.

---

## Step 1 — Check if it already exists

1. Check `skills/registry.md` — does this topic have an entry?
2. Scan `skills/_drafts/` — is there a draft already?
3. Check `vault/00-index.md` — is there a vault note that covers it?

If a skill already exists: load it and tell the user where it is. Do not duplicate.

---

## Step 2 — Source the knowledge

**Priority order:**
1. User provides content directly → use that as primary source
2. Graphify → `bash scripts/graphify.sh query "topic"` — check vault and project raw/
3. Perplexity → `bash scripts/research.sh "topic" --deep` — web research with citations
4. Save findings: `bash scripts/research.sh "topic" --save references/topic-name`

Always cite your source. Never invent values, formulas, or part numbers.

---

## Step 3 — Write the skill draft

Write to `skills/_drafts/{topic-kebab-case}.md`:

```markdown
# Skill: {Topic Name}

status: [DRAFT]
source: {URL, "user input", or "datasheet: {filename}"}
added: {today}

## What this covers
[One paragraph — domain of this skill and when it applies in audio hardware]

## Key concepts
[Bullet list — the most important facts, values, principles]

## Reference values / formulas
[Tables or formulas that agents will need to cite during design work]

## Common use in KLANG hardware
[Specific examples of how this comes up in KLANG projects — be concrete]

## Gotchas
[Things that commonly go wrong, or counterintuitive behaviours]

## Further reading
[Datasheets, app notes, URLs — with a one-line description of each]
```

---

## Step 4 — Report back

Tell the user:
- File written to `skills/_drafts/{name}.md`
- 2–3 key takeaways from what was learned
- Whether it's ready to publish (ask them to review before moving to main `skills/` folder)
- If it belongs in `electronics/`, `platforms/`, `firmware/`, or `production/` once reviewed

---

## Promoting a draft to production

When the user says "publish that skill" or "that looks good":
1. Move the file from `skills/_drafts/` to the appropriate `skills/{category}/` folder
2. Remove the `status: [DRAFT]` line
3. Add an entry to `skills/registry.md` in the correct category section
4. Tell the user it's now in the registry

---

## Rules

- One skill per file — do not combine unrelated concepts into one document
- Skills stay in `_drafts/` until explicitly reviewed and approved
- Mark uncertain information: `[NEEDS VERIFICATION]`
- If a skill grows too large (> 150 lines), split by sub-topic into separate files
