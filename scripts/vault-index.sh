#!/bin/bash
# Rebuilds vault/00-index.md from current vault contents.
# Run after vault-writer adds new notes.

VAULT="vault"
INDEX="$VAULT/00-index.md"
TODAY=$(date +%Y-%m-%d)

cat > "$INDEX" << EOF
# BENCH Vault — Index

last_updated: ${TODAY}

---

## Components
$(ls "$VAULT/components/"*.md 2>/dev/null | while read f; do echo "- [[$(basename "$f" .md)]]"; done)

## Datasheets
$(ls "$VAULT/datasheets/"*.md 2>/dev/null | while read f; do echo "- [[$(basename "$f" .md)]]"; done)

## Platforms
$(ls "$VAULT/platforms/"*.md 2>/dev/null | while read f; do echo "- [[$(basename "$f" .md)]]"; done)

## Projects
$(ls "$VAULT/projects/"*.md 2>/dev/null | while read f; do echo "- [[$(basename "$f" .md)]]"; done)

## Ideas
$(ls "$VAULT/ideas/"*.md 2>/dev/null | while read f; do echo "- [[$(basename "$f" .md)]]"; done)

## References
$(ls "$VAULT/references/"*.md 2>/dev/null | while read f; do echo "- [[$(basename "$f" .md)]]"; done)
EOF

echo "✓ Rebuilt $INDEX"
