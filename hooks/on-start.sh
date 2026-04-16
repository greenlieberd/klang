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
