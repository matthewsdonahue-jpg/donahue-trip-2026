#!/bin/bash
# One-time script: push donahue-trip to GitHub
# Run this once from Terminal, then delete it

GH_TOKEN="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"
REPO="https://${GH_TOKEN}@github.com/matthewsdonahue-jpg/donahue-trip-2026.git"
DIR="$(dirname "$0")"

cd "$DIR"
git remote remove origin 2>/dev/null || true
git remote add origin "$REPO"
git push -u origin main

echo ""
echo "✅ Pushed to GitHub!"
echo "   https://github.com/matthewsdonahue-jpg/donahue-trip-2026"
echo ""
echo "Now go connect Netlify to this repo — see instructions from Claude."
