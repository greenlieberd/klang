#!/bin/bash
# Reads active project from state/active.json and starts the graphify MCP server.
# Called by Claude Code's mcpServers config at session start.
# Note: switching active projects requires restarting Claude Code to pick up the new graph.

SCRIPT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
STATE="$SCRIPT_DIR/state/active.json"

PROJECT=$(python3 -c "
import json, sys
try:
    d = json.load(open('$STATE'))
    p = d.get('active_project') or ''
    print(p)
except Exception as e:
    print('')
" 2>/dev/null)

if [ -z "$PROJECT" ]; then
  echo "[graphify] No active project set. Create one with N from the startup menu." >&2
  # Keep alive so Claude Code doesn't error on missing MCP server
  exec tail -f /dev/null
fi

RAW="$SCRIPT_DIR/projects/$PROJECT/raw"
GRAPH="$RAW/graphify-out/graph.json"

if [ ! -f "$GRAPH" ]; then
  echo "[graphify] No graph found for '$PROJECT'. Drop files into projects/$PROJECT/raw/ and run /graphify in Claude." >&2
  exec tail -f /dev/null
fi

echo "[graphify] Serving graph for: $PROJECT" >&2
exec "$SCRIPT_DIR/.venv/bin/graphify" "$RAW" --mcp
