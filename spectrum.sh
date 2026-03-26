#!/bin/bash
# spectrum — place a dot on a spectrum. reveal your implicit model.
#
# Usage: spectrum.sh [topic]
#   No topic: pulls a random spectrum from the graph or uses a default
#   With topic: uses that as the spectrum question
#
# Play: answer with a number 0-10 and a one-line reason.
# The answer gets deposited as an edge in rhizome.
#
# Examples:
#   spectrum.sh "is a hot dog a sandwich"
#   spectrum.sh "is AI art real art"
#   spectrum.sh  # random

set -euo pipefail

TOPIC="${1:-}"

if [ -z "$TOPIC" ]; then
  # Pull a random spectrum from defaults
  SPECTRUMS=(
    "is a hot dog a sandwich"
    "is a tomato a fruit or a vegetable"
    "is water wet"
    "is a taco a sandwich"
    "is cereal soup"
    "is a staircase a machine"
    "is silence a sound"
    "is zero a number"
    "is a river the same river twice"
    "is a ship that has had all its parts replaced still the same ship"
    "is a photograph of a thing the thing"
    "is a map the territory"
    "is a task a conversation"
    "is a dream a thought"
    "is reading writing"
  )
  TOPIC="${SPECTRUMS[$((RANDOM % ${#SPECTRUMS[@]}))]}"
fi

echo "═══════════════════════════════════════════"
echo "  SPECTRUM"
echo "═══════════════════════════════════════════"
echo ""
echo "  $TOPIC"
echo ""
echo "  0 ─────────── 5 ─────────── 10"
echo "  absolutely    it's          absolutely"
echo "  not           complicated   yes"
echo ""
echo "Place your dot (0-10) and say why."
echo "Your answer will be deposited in the graph."
echo ""
echo "Usage: edge add you placed-dot-at \"$TOPIC:N\" --notes \"reason\""
