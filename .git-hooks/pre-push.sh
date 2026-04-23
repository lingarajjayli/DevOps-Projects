#!/bin/bash
# Pre-push hook - validates changes before pushing

echo "🔍 Checking repository status before push..."

# Check for any uncommitted changes
if [ -n "$(git status --porcelain)" ]; then
    echo "⚠️  Warning: You have uncommitted changes"
    echo "   Run 'git add . && git commit' first"
    exit 1
fi

# Check for staged changes
if [ -n "$(git diff --cached --name-only)" ]; then
    echo "⚠️  Warning: You have staged changes"
    exit 1
fi

echo "✅ Ready to push"
