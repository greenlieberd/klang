#!/bin/bash
# Graphify CLI wrapper for BENCH.
# Queries run against both the global graph (raw/) and the active project graph.
#
# Agents use this — users don't run it directly.
#
# Commands:
#   query "question"     — search global + project graphs
#   explain "Node"       — explain a node (global graph)
#   update               — re-index active project raw/
#   global-update        — re-index global raw/ → vault
#   add <url>            — fetch URL → active project raw/ → re-index

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
VENV="$ROOT/.venv/bin/graphify"
STATE="$ROOT/state/active.json"
GLOBAL_RAW="$ROOT/raw"
GLOBAL_GRAPH="$GLOBAL_RAW/graphify-out/graph.json"

PROJECT=$(python3 -c "
import json
try:
    d = json.load(open('$STATE'))
    print(d.get('active_project') or '')
except:
    print('')
")

CMD="$1"

case "$CMD" in
  query)
    shift
    # Query global graph first, then project graph
    FOUND=0
    if [ -f "$GLOBAL_GRAPH" ]; then
      RESULT=$("$VENV" query "$@" --graph "$GLOBAL_GRAPH" 2>/dev/null)
      if [ -n "$RESULT" ]; then
        echo "[global] $RESULT"
        FOUND=1
      fi
    fi
    if [ -n "$PROJECT" ]; then
      PROJECT_GRAPH="$ROOT/projects/$PROJECT/raw/graphify-out/graph.json"
      if [ -f "$PROJECT_GRAPH" ]; then
        RESULT=$("$VENV" query "$@" --graph "$PROJECT_GRAPH" 2>/dev/null)
        if [ -n "$RESULT" ]; then
          echo "[project] $RESULT"
          FOUND=1
        fi
      fi
    fi
    if [ $FOUND -eq 0 ]; then
      echo "No matching nodes found in global or project graphs."
    fi
    ;;

  explain)
    shift
    if [ -f "$GLOBAL_GRAPH" ]; then
      "$VENV" explain "$@" --graph "$GLOBAL_GRAPH"
    elif [ -n "$PROJECT" ]; then
      PROJECT_GRAPH="$ROOT/projects/$PROJECT/raw/graphify-out/graph.json"
      [ -f "$PROJECT_GRAPH" ] && "$VENV" explain "$@" --graph "$PROJECT_GRAPH"
    fi
    ;;

  path)
    shift
    if [ -f "$GLOBAL_GRAPH" ]; then
      "$VENV" path "$@" --graph "$GLOBAL_GRAPH"
    fi
    ;;

  update)
    # Re-index active project raw/
    if [ -z "$PROJECT" ]; then
      echo "[graphify] No active project." >&2; exit 1
    fi
    RAW="$ROOT/projects/$PROJECT/raw"
    echo "[graphify] Indexing project raw/ for $PROJECT..."
    (cd "$RAW" && "$VENV" update .)
    echo "[graphify] Done."
    ;;

  global-update)
    # Re-index global raw/ and write notes to vault
    echo "[graphify] Indexing global raw/..."
    (cd "$GLOBAL_RAW" && "$VENV" update . --obsidian --obsidian-dir "$ROOT/vault" 2>/dev/null || "$VENV" update .)
    echo "[graphify] Rebuilding vault index..."
    bash "$ROOT/scripts/vault-index.sh"
    echo "[graphify] Global knowledge updated."
    ;;

  add)
    shift
    if [ -z "$PROJECT" ]; then
      echo "[graphify] No active project — adding to global raw/..."
      (cd "$GLOBAL_RAW" && "$VENV" add "$@")
      (cd "$GLOBAL_RAW" && "$VENV" update .)
    else
      RAW="$ROOT/projects/$PROJECT/raw"
      echo "[graphify] Adding to $PROJECT/raw/..."
      (cd "$RAW" && "$VENV" add "$@")
      (cd "$RAW" && "$VENV" update .)
    fi
    ;;

  *)
    echo "Usage: $0 {query|explain|path|update|global-update|add} [args]"
    exit 1
    ;;
esac
