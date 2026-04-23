#!/bin/bash
# Auto-pusher monitoring script for DevOps learning repository
# Checks for changes every 5 minutes and pushes automatically

REPO_DIR="/D/DevOps-Projects"
REMOTE="origin"
BRANCH="master"
INTERVAL=300  # 5 minutes in seconds

cd "$REPO_DIR"

check_and_push() {
    echo ""
    echo "=========================================="
    echo "  Auto-Pusher: Checking for changes       "
    echo "  Branch: $BRANCH | Remote: $REMOTE        "
    echo "  Timestamp: $(date '+%Y-%m-%d %H:%M:%S') "
    echo "=========================================="

    # Check git status
    STATUS=$(git status --porcelain)

    if [ -z "$STATUS" ]; then
        echo "Status: No changes detected"
        echo "Action: Skipping push (no changes)"
        echo "=========================================="
        return 0
    fi

    echo "Status: Changes detected"
    echo "Changes:"
    echo "$STATUS"
    echo ""

    # Check for actual code changes (not just ignored files)
    CODE_CHANGES=$(echo "$STATUS" | grep -v "^??" | grep -v "Binary")

    if [ -z "$CODE_CHANGES" ]; then
        echo "Status: All changes are ignored files or binaries"
        echo "Action: Skipping push"
        echo "=========================================="
        return 0
    fi

    # Stage changes
    echo "Action: Staging changes..."
    git add -A

    # Commit if there are changes
    echo "Action: Creating commit..."
    git commit -m "Auto-push: Changes detected on $BRANCH" \
        -m "Automatic push by monitoring script $(date '+%Y-%m-%d %H:%M:%S')"

    # Push to remote
    echo "Action: Pushing to remote repository..."
    git push "$REMOTE" "$BRANCH"

    echo ""
    echo "=========================================="
    echo "  Push completed successfully!           "
    echo "=========================================="
}

# Initial check
check_and_push

# Monitor loop
echo ""
echo "Auto-pusher monitoring started!"
echo "Checking for changes every ${INTERVAL} seconds (5 minutes)"
echo "Press Ctrl+C to stop monitoring"

while true; do
    sleep $INTERVAL
    check_and_push
done
