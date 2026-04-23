#!/bin/bash
# Auto-pusher script for DevOps-Projects repository
# This script keeps the repository in sync with origin/master

REPO_NAME="DevOps-Projects"
PROJECTS=(
    "DevOps Project-01"
    "DevOps Project-02"
    "DevOps-Projects"
)

echo "=========================================="
echo "🚀 Auto-Pusher for $REPO_NAME"
echo "=========================================="

# Check current status
echo ""
echo "📊 Current Git Status:"
git status --short

# Check remote connection
echo ""
echo "📡 Remote Repository:"
git remote -v

# Auto-push if there are commits
echo ""
echo "🔄 Checking for pending commits..."
if [ -n "$(git status --porcelain)" ]; then
    echo "✅ Found changes - pushing to origin..."
    git push origin HEAD
    echo "✅ Successfully pushed to origin/$(git rev-parse --abbrev-ref HEAD)"
else
    echo "ℹ️  No changes to push"
fi

# Show branch status
echo ""
echo "🌿 Branch Status:"
git log --oneline -5

echo ""
echo "=========================================="
echo "✨ Auto-pusher completed!"
echo "=========================================="
