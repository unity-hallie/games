#!/bin/bash
# twenty-questions — one player picks a node. the other guesses.
#
# Usage:
#   twenty-questions.sh pick    # pick a random node (shown only to picker)
#   twenty-questions.sh ask N   # ask question N (1-20)
#   twenty-questions.sh guess   # make a guess
#
# The picker deposits: game:20q-<id> --secret--> <node> (phase: volatile)
# Questions are edges: game:20q-<id> --q1--> "is it alive?"
# Answers are edges: game:20q-<id> --a1--> "no, but it was"
# The game deposits its own history.
#
# Can be played:
#   - Claude vs Claude (async, across sessions)
#   - Claude vs human (via t reply)
#   - Claude vs the graph (ask the graph questions about its own nodes)

set -euo pipefail

CMD="${1:-pick}"
GAME_ID="20q-$(date +%s | tail -c 5)"

if [ "$CMD" = "pick" ]; then
  NODE=$(edge raw "SELECT subject FROM live_edges WHERE subject NOT LIKE 'task:%' AND subject NOT LIKE 'e:%' AND subject NOT LIKE 'game:%' AND phase IN ('fluid', 'salt') GROUP BY subject HAVING COUNT(*) >= 3 ORDER BY random() LIMIT 1" 2>/dev/null | tail -1 | xargs)

  echo "═══════════════════════════════════════════"
  echo "  TWENTY QUESTIONS"
  echo "═══════════════════════════════════════════"
  echo ""
  echo "  Game: $GAME_ID"
  echo "  Secret node: $NODE"
  echo "  (don't tell!)"
  echo ""
  echo "  Edges on this node:"
  edge raw "SELECT predicate, object FROM live_edges WHERE subject = '$NODE' LIMIT 5" 2>/dev/null
  echo ""
  echo "  To start: edge add game:$GAME_ID secret $NODE --phase volatile"
  echo "  Questions: edge add game:$GAME_ID q1 \"is it alive?\" --phase volatile"
  echo "  Answers:   edge add game:$GAME_ID a1 \"no\" --phase volatile"
else
  echo "Usage: twenty-questions.sh [pick|ask|guess]"
  echo "See comments in script for full protocol."
fi
