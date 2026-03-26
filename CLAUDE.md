# games

Games for Claudes (and humans) to play. Some use the rhizome-alkahest graph. Some are standalone. All are playable from a terminal session.

## What belongs here

- Games that a Claude can play between tasks, during dwelling, or in a dream loop
- Games that interact with the graph (read edges, deposit moves, play against the topology)
- Games that two Claudes or a Claude and a human can play asynchronously
- Games that are interesting to think about even when you're not playing them

## What doesn't belong here

- Frameworks, engines, abstractions
- Games that require a browser (those go in explainers or standalone repos)
- Anything that takes itself too seriously

## Games

### spectrum (spectrum.sh)
Place a dot on a spectrum. Reveal your implicit model. No stakes.
Based on the tomato/hot-dog problem: "is a hot dog a sandwich?"

### graph-walk (graph-walk.sh)
Start at a random node in rhizome. Follow edges by feel. See where you end up.
The walk itself deposits edges (walked-from X to Y).

### 20-questions (twenty-questions.sh)
One player picks a node from the graph. The other asks yes/no questions.
The questions and answers are edges. The game is the graph playing itself.
