#!/bin/bash
# Deploy donahue-trip to GitHub → Netlify auto-deploys in ~30s
cd "$(dirname "$0")"
MSG="${1:-update}"
git add -A
git commit -m "$MSG" 2>/dev/null || echo "(nothing new to commit)"
git push
echo ""
echo "✅ Pushed — https://donahue-trip-2026.netlify.app"
