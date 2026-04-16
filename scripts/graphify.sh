#!/bin/bash
# Graphify CLI wrapper for BENCH.
# Runs graphify commands against the active project's graph.
#
# Usage:
#   bash scripts/graphify.sh query "TL074 opamp"
#   bash scripts/graphify.sh explain "ProcessFilter"
#   bash scripts/graphify.sh path "NodeA" "NodeB"
#   bash scripts/graphify.sh update          # re-index raw/ for active project
#
# Graphify output is in: projects/{active}/raw/graphify-out/graph.json

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
VENV="$ROOT/.venv/bin/graphify"
STATE="$ROOT/state/active.json"

PROJECT=$(python3 -c "
import json
try:
    d = json.load(open('$STATE'))
    print(d.get('active_project') or '')
except:
    print('')
")

if [ -z "$PROJECT" ]; then
  echo "[graphify] No active project. Set one first." >&2
  exit 1
fi

RAW="$ROOT/projects/$PROJECT/raw"
GRAPH="$RAW/graphify-out/graph.json"
CMD="$1"

case "$CMD" in
  query)
    if [ ! -f "$GRAPH" ]; then
      echo "[graphify] No graph yet for $PROJECT. Drop files into raw/ and run: bash scripts/graphify.sh update" >&2
      exit 1
    fi
    shift
    "$VENV" query "$@" --graph "$GRAPH"
    ;;

  explain)
    if [ ! -f "$GRAPH" ]; then
      echo "[graphify] No graph yet for $PROJECT." >&2; exit 1
    fi
    shift
    "$VENV" explain "$@" --graph "$GRAPH"
    ;;

  path)
    if [ ! -f "$GRAPH" ]; then
      echo "[graphify] No graph yet for $PROJECT." >&2; exit 1
    fi
    shift
    "$VENV" path "$@" --graph "$GRAPH"
    ;;

  update)
    echo "[graphify] Indexing raw/ for $PROJECT..."
    (cd "$RAW" && "$VENV" update .)
    echo "[graphify] Graph updated: $GRAPH"
    ;;

  add)
    shift
    echo "[graphify] Adding URL to $PROJECT/raw/..."
    (cd "$RAW" && "$VENV" add "$@")
    echo "[graphify] Re-indexing..."
    (cd "$RAW" && "$VENV" update .)
    ;;

  *)
    echo "Usage: $0 {query|explain|path|update|add} [args]"
    echo "  query   \"your question\"       — BFS search through graph"
    echo "  explain \"NodeName\"            — plain-language node explanation"
    echo "  path    \"NodeA\" \"NodeB\"       — shortest path between nodes"
    echo "  update                        — re-index raw/ folder"
    echo "  add     <url>                 — fetch URL → raw/ → re-index"
    exit 1
    ;;
esac
