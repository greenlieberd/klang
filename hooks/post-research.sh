#!/bin/bash
# Runs after research agent writes research.md.
# Re-indexes the active project's raw/ folder and restarts the graphify MCP context.

PROJECT=$(python3 -c "
import json
try:
    d = json.load(open('state/active.json'))
    print(d.get('active_project') or '')
except:
    print('')
")

if [ -z "$PROJECT" ]; then
  echo "[post-research] No active project — skipping graphify update."
  exit 0
fi

RAW="projects/$PROJECT/raw"

if [ ! -d "$RAW" ]; then
  echo "[post-research] raw/ folder not found for $PROJECT"
  exit 0
fi

echo "[post-research] Running graphify update for $PROJECT..."
"$(dirname "$0")/../.venv/bin/graphify" update "$RAW" --obsidian --obsidian-dir vault

echo "[post-research] Rebuilding vault index..."
bash scripts/vault-index.sh

echo "[post-research] Done. Restart Claude Code to reload the MCP graph."
