#!/bin/bash
# Runs after any Write tool call.
# If the file written is a loop.md, stamps the last entry with the current timestamp.
# Claude Code passes tool input via CLAUDE_TOOL_INPUT env var (JSON).

FILE=$(python3 -c "
import json, os, sys
try:
    tool_input = json.loads(os.environ.get('CLAUDE_TOOL_INPUT', '{}'))
    print(tool_input.get('file_path', ''))
except:
    print('')
")

# Only act on loop.md writes
if [[ "$FILE" != *"/loop.md" ]]; then
  exit 0
fi

TODAY=$(date -u +%Y-%m-%dT%H:%M:%SZ)

# Also update last_updated in state/active.json
python3 - << EOF
import json, datetime
try:
    with open('state/active.json', 'r') as f:
        d = json.load(f)
    d['last_session'] = datetime.datetime.now().isoformat()
    d['last_agent'] = 'loop'
    with open('state/active.json', 'w') as f:
        json.dump(d, f, indent=2)
except:
    pass
EOF

echo "[post-loop] loop.md updated at $TODAY"
