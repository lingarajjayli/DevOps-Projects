#!/bin/bash
# Post-commit hook - sync with origin

echo "🔄 Syncing changes with origin. .."

# Push current commit
git push origin HEAD

# Fetch latest from remote
git fetch origin

echo "✅ Repository is now synced with origin"
