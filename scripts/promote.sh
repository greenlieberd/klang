#!/bin/bash
# Promotes active project: marks loop complete, creates promote/ folder.
# Triggered by user saying "promote this".

set -e

PROJECT=$(python3 -c "
import json
d = json.load(open('state/active.json'))
print(d.get('active_project') or '')
")

if [ -z "$PROJECT" ]; then
  echo "No active project. Cannot promote."
  exit 1
fi

DIR="projects/$PROJECT"
TODAY=$(date +%Y-%m-%d)

# Mark loop complete
python3 - << EOF
content = open('$DIR/loop.md').read()
content = content.replace('status: active', 'status: complete', 1)
open('$DIR/loop.md', 'w').write(content)
EOF

# Create promote/ folder if not exists
mkdir -p "$DIR/promote"

# Scaffold promote files if missing
[ -f "$DIR/promote/schematic-brief.md" ] || cat > "$DIR/promote/schematic-brief.md" << EOF
# Schematic Brief — ${PROJECT}

promoted: ${TODAY}

## Nets and pinouts
[Filled by promote agent]

## Power rails
[Filled by promote agent]

## Signal connections
[Filled by promote agent]
EOF

[ -f "$DIR/promote/bom-final.md" ] || cat > "$DIR/promote/bom-final.md" << EOF
# BOM Final — ${PROJECT}

promoted: ${TODAY}

## Verified parts
[Filled by promote agent — all part numbers confirmed against current stock]
EOF

[ -f "$DIR/promote/production-notes.md" ] || cat > "$DIR/promote/production-notes.md" << EOF
# Production Notes — ${PROJECT}

promoted: ${TODAY}

## Enclosure
[Filled by promote agent]

## PCB house
[Filled by promote agent]

## Mechanical notes
[Filled by promote agent]
EOF

echo "✓ Promoted: $PROJECT"
echo "  → Loop marked complete"
echo "  → promote/ folder ready — ask BENCH to fill it in"
