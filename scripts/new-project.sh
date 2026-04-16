#!/bin/bash
# Scaffolds a new project folder with all template files.
# Usage: ./scripts/new-project.sh <id> <slug>
# Example: ./scripts/new-project.sh 001 five-channel-mixer

set -e

ID="$1"
SLUG="$2"

if [ -z "$ID" ] || [ -z "$SLUG" ]; then
  echo "Usage: $0 <id> <slug>"
  exit 1
fi

PROJECT="${ID}-${SLUG}"
DIR="projects/${PROJECT}"
TODAY=$(date +%Y-%m-%d)

if [ -d "$DIR" ]; then
  echo "Project '$PROJECT' already exists at $DIR"
  exit 1
fi

# --- Folders ---
mkdir -p "$DIR"/{raw,graphify-out,diagrams,firmware,promote}

# --- idea.md ---
cat > "$DIR/idea.md" << EOF
# Idea — ${PROJECT}

status: planning
created: ${TODAY}

## Concept
[Describe the device here]

## Questions to answer before building
-

## Decisions made
-
EOF

# --- research.md ---
cat > "$DIR/research.md" << EOF
# Research — ${PROJECT}

last_updated: ${TODAY}

## Overview

## Topologies considered

## Components

## Signal path
EOF

# --- materials.md ---
cat > "$DIR/materials.md" << EOF
# Materials — ${PROJECT}

last_updated: ${TODAY}
status: active

## ICs
| Part | Value | Package | Qty | Supplier | Price |
|---|---|---|---|---|---|

## Resistors
| Value | Tolerance | Qty | Notes |
|---|---|---|---|

## Capacitors
| Value | Type | Qty | Notes |
|---|---|---|---|

## Connectors
| Part | Qty | Notes |
|---|---|---|

## Mechanical
| Part | Qty | Notes |
|---|---|---|

## Added mid-build
| Part | Added | Reason |
|---|---|---|
EOF

# --- loop.md ---
cat > "$DIR/loop.md" << EOF
# Loop — ${PROJECT}

status: not_started
prototype: v1
last_updated: ${TODAY}

## Current state
Not started.

## Open questions
-

## Next experiment
-
EOF

# --- .graphifyignore ---
cat > "$DIR/raw/.graphifyignore" << 'EOF'
.DS_Store
*.tmp
*.part
EOF

# --- Update state/active.json ---
python3 - << EOF
import json, datetime
with open('state/active.json', 'w') as f:
    json.dump({
        "active_project": "${PROJECT}",
        "stage": "idea",
        "last_session": datetime.datetime.now().isoformat(),
        "last_agent": "start",
        "open_questions": []
    }, f, indent=2)
EOF

echo ""
echo "✓ Created: ${DIR}"
echo ""
echo "  raw/        → drop datasheets, images, links here"
echo "  idea.md     → edit your concept and questions"
echo "  loop.md     → build iteration log"
echo "  materials.md → live BOM"
echo ""
echo "Next: open BENCH and resume ${PROJECT}"
