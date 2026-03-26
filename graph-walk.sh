#!/bin/bash
# graph-walk — start at a random node. follow edges by feel.
#
# Usage: graph-walk.sh [starting-node]
#   No arg: picks a random node from the graph
#   With arg: starts there
#
# At each node, you see its edges. Pick one to follow.
# The walk deposits edges: walker walked-from A --to--> B
#
# The game ends when you want it to, or when you reach a dead end.

set -euo pipefail

START="${1:-}"

if [ -z "$START" ]; then
  # Pick a random node that has at least 2 edges
  START=$(edge raw "SELECT subject FROM live_edges WHERE subject NOT LIKE 'task:%' AND subject NOT LIKE 'e:%' AND phase IN ('fluid', 'salt') GROUP BY subject HAVING COUNT(*) >= 2 ORDER BY random() LIMIT 1" 2>/dev/null | tail -1 | xargs)
fi

if [ -z "$START" ]; then
  echo "No suitable starting node found."
  exit 1
fi

echo "═══════════════════════════════════════════"
echo "  GRAPH WALK"
echo "═══════════════════════════════════════════"
echo ""
echo "  Starting at: $START"
echo ""
echo "  Edges from here:"
edge raw "SELECT predicate, object, phase FROM live_edges WHERE subject = '$START' AND predicate NOT IN ('speaks-as', 'speaks-for', 'dreamt-on') LIMIT 10" 2>/dev/null
echo ""
echo "To walk: edge add walker walked-from \"$START\" --notes \"chose: <predicate> <object>\""
echo "Then run: graph-walk.sh <destination-node>"
