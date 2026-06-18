#!/bin/bash
cd "$(dirname "$0")"
echo "🔧 Removing stale git locks..."
rm -f .git/HEAD.lock .git/index.lock .git/refs/heads/main.lock
echo "📦 Committing..."
GH_TOKEN="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"
git remote set-url origin "https://${GH_TOKEN}@github.com/matthewsdonahue-jpg/donahue-trip-2026.git"
git add -A
git commit -m "owner command center: nav, stop checklist, fuel stats"
echo "🚀 Pushing to GitHub..."
git push origin main
echo ""
echo "✅ Done — Netlify will deploy in ~30 seconds"
echo "   https://donahue-trip-2026.netlify.app/?owner=true"
