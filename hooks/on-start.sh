#!/bin/bash
# Reads state/active.json and prints context for the start agent.
# Output is captured by Claude Code and added to the session context.
# The start agent (agents/start.md) handles the interactive menu.

STATE="state/active.json"

PROJECT=$(python3 -c "
import json
try:
    d = json.load(open('$STATE'))
    print(d.get('active_project') or 'none')
except:
    print('none')
")

STAGE=$(python3 -c "
import json
try:
    d = json.load(open('$STATE'))
    print(d.get('stage') or 'none')
except:
    print('none')
")

LAST=$(python3 -c "
import json
try:
    d = json.load(open('$STATE'))
    print(d.get('last_session') or 'never')
except:
    print('never')
")

QUESTIONS=$(python3 -c "
import json
try:
    d = json.load(open('$STATE'))
    qs = d.get('open_questions') or []
    print(len(qs))
except:
    print(0)
")

echo "=== BENCH STATE ==="
echo "active_project: $PROJECT"
echo "stage: $STAGE"
echo "last_session: $LAST"
echo "open_questions: $QUESTIONS"
echo "==================="

# Check if global raw/ has unindexed files
GLOBAL_RAW="raw"
GLOBAL_GRAPH="$GLOBAL_RAW/graphify-out/graph.json"
GLOBAL_FILES=$(find "$GLOBAL_RAW" -type f ! -name ".gitkeep" ! -name ".graphifyignore" ! -path "*/graphify-out/*" 2>/dev/null | wc -l | tr -d ' ')

if [ "$GLOBAL_FILES" -gt 0 ] && [ ! -f "$GLOBAL_GRAPH" ]; then
  echo "=== GLOBAL RAW ==="
  echo "status: $GLOBAL_FILES files not yet indexed"
  echo "action: run 'bash scripts/graphify.sh global-update' to index into vault"
  echo "=================="
elif [ "$GLOBAL_FILES" -gt 0 ]; then
  echo "=== GLOBAL RAW ==="
  echo "files: $GLOBAL_FILES"
  echo "graph: indexed"
  echo "=================="
fi
