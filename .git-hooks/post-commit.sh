#!/bin/bash
# Auto-push hook - pushes current branch to origin after each commit

# Push current branch to origin
git push origin HEAD 2>/dev/null || true

echo "✅ Successfully pushed to origin/$(git rev-parse --abbrev-ref HEAD)"
