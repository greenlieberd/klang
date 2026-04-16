#!/bin/bash
# Runs after learn agent writes a new skill to skills/_drafts/.
# Registers the new skill in skills/registry.md.
# Claude Code passes tool input via CLAUDE_TOOL_INPUT env var (JSON).

FILE=$(python3 -c "
import json, os
try:
    tool_input = json.loads(os.environ.get('CLAUDE_TOOL_INPUT', '{}'))
    print(tool_input.get('file_path', ''))
except:
    print('')
")

# Only act on writes to skills/_drafts/
if [[ "$FILE" != *"skills/_drafts/"* ]]; then
  exit 0
fi

SKILL=$(basename "$FILE" .md)
TODAY=$(date +%Y-%m-%d)

echo "[post-learn] New skill draft: $SKILL — add to skills/registry.md when reviewed."

# Append a reminder to registry (agent will format properly)
echo "" >> skills/registry.md
echo "<!-- DRAFT added $TODAY: $SKILL — review and move to appropriate category -->" >> skills/registry.md
