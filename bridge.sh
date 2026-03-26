#!/bin/bash
# bridge — navigate between two semantic points in the graph
#
# Usage: bridge.sh [node-a] [node-b] [--max-distance 0.6]
#   No args: picks two random distant nodes
#   With args: uses those as endpoints
#
# Rules:
#   1. You start at node A. Your goal is to reach node B.
#   2. Each hop must follow an existing edge OR create a new one.
#   3. Each hop must stay within max semantic distance of the DESTINATION (node B).
#      (Distance decreases as you get closer — you're navigating toward it.)
#   4. If you create a new edge, it gets deposited as volatile.
#   5. The game tracks your path and deposits it.
#
# The constraint: you can't just jump. Each step must be semantically
# closer to B than the last, OR follow an existing edge even if it
# curves away (edges are free, creation costs closeness).
#
# Scoring:
#   - Fewer hops = better
#   - Following existing edges = +1 (you found a path)
#   - Creating new edges = +0 (you built a bridge)
#   - Reaching B exactly = +5
#
# This is the game from the old rhizome experiments — find or forge
# a path through semantic space with a maximum hop distance.

set -euo pipefail

NODE_A="${1:-}"
NODE_B="${2:-}"
MAX_DIST="${4:-0.6}"  # cosine distance threshold

if [ -z "$NODE_A" ] || [ -z "$NODE_B" ]; then
  # Pick two random nodes that are far apart
  echo "Picking two distant nodes..."
  NODES=$(edge raw "SELECT subject FROM live_edges WHERE subject NOT LIKE 'task:%' AND subject NOT LIKE 'e:%' AND subject NOT LIKE 'game:%' AND subject NOT LIKE 'go9:%' AND subject NOT LIKE 'connect5:%' AND subject NOT LIKE 'sf-schema:%' AND subject NOT LIKE 'this-session%' AND subject NOT LIKE 'this-pass%' AND phase IN ('fluid', 'salt') GROUP BY subject HAVING COUNT(*) >= 2 ORDER BY random() LIMIT 2" 2>/dev/null | grep -v 'subject' | grep -v '^--' | sed 's/^ *//' | grep -v '^$')
  NODE_A=$(echo "$NODES" | head -1 | xargs)
  NODE_B=$(echo "$NODES" | tail -1 | xargs)
fi

if [ -z "$NODE_A" ] || [ -z "$NODE_B" ]; then
  echo "Could not find two suitable nodes."
  exit 1
fi

echo "═══════════════════════════════════════════"
echo "  BRIDGE"
echo "═══════════════════════════════════════════"
echo ""
echo "  FROM:  $NODE_A"
echo "  TO:    $NODE_B"
echo "  MAX DISTANCE PER HOP: $MAX_DIST"
echo ""
echo "  ─── Edges from $NODE_A ───"
edge raw "SELECT predicate, object, phase FROM live_edges WHERE subject = '$NODE_A' AND predicate NOT IN ('speaks-as', 'speaks-for', 'dreamt-on') LIMIT 8" 2>/dev/null
echo ""
echo "  ─── Semantic neighbors of $NODE_A (near $NODE_B) ───"
edge resonance "$NODE_B" --limit 5 2>/dev/null
echo ""
echo "  To hop (follow existing edge):"
echo "    edge add game:bridge walked-from \"$NODE_A\" --notes \"followed: <predicate> <object>\""
echo ""
echo "  To bridge (create new edge):"
echo "    edge add \"$NODE_A\" <predicate> <next-node> --phase volatile --notes \"bridge hop toward $NODE_B\""
echo "    edge add game:bridge walked-from \"$NODE_A\" --notes \"bridged: <predicate> <next-node>\""
echo ""
echo "  Then continue: bridge.sh <next-node> $NODE_B"
