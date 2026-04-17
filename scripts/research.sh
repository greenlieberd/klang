#!/bin/bash
# Research a topic via Perplexity and optionally write result to vault.
#
# Usage:
#   bash scripts/research.sh "TL074 opamp summing mixer circuit"
#   bash scripts/research.sh "Moog ladder filter transistor matching" --deep
#   bash scripts/research.sh "TL074 opamp" --save components/TL074
#
# --deep       uses sonar-pro for deeper research (slower, more thorough)
# --save PATH  writes result to vault/PATH.md (relative to vault/)

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
QUERY="$1"
shift

DEEP_FLAG=""
SAVE_PATH=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --deep) DEEP_FLAG="--deep"; shift ;;
    --save) SAVE_PATH="$2"; shift 2 ;;
    *) shift ;;
  esac
done

if [ -z "$QUERY" ]; then
  echo "Usage: $0 \"your research question\" [--deep] [--save vault/path]"
  exit 1
fi

echo "[research] Querying Perplexity: $QUERY"
echo ""

RESULT=$("$ROOT/.venv/bin/python3" "$ROOT/scripts/perplexity.py" "$QUERY" $DEEP_FLAG 2>&1)
EXIT_CODE=$?

if [ $EXIT_CODE -ne 0 ]; then
  echo "$RESULT"
  exit $EXIT_CODE
fi

echo "$RESULT"

# Optionally save to vault
if [ -n "$SAVE_PATH" ]; then
  VAULT_FILE="$ROOT/vault/${SAVE_PATH}.md"
  mkdir -p "$(dirname "$VAULT_FILE")"
  TODAY=$(date +%Y-%m-%d)

  cat > "$VAULT_FILE" << EOF
# ${SAVE_PATH##*/}

type: reference
source: perplexity
query: ${QUERY}
added: ${TODAY}

---

${RESULT}
EOF

  echo ""
  echo "[research] Saved to vault/${SAVE_PATH}.md"

  # Rebuild vault index
  bash "$ROOT/scripts/vault-index.sh"
fi
