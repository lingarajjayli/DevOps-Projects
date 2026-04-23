#!/bin/bash
# Setup script for auto-pusher system
# Sets up git hooks, monitoring, and background process

set -e

REPO_DIR="/D/DevOps-Projects"

echo "=========================================="
echo "  DevOps Auto-Pusher Setup"
echo "=========================================="
echo ""

cd "$REPO_DIR"

# Step 1: Install pre-push hook
echo "[Step 1/4] Installing pre-push hook..."
if [ ! -f ".git/hooks/pre-push" ]; then
    echo "  ERROR: pre-push hook not found!"
    exit 1
fi
if [ ! -x ".git/hooks/pre-push" ]; then
    chmod +x ".git/hooks/pre-push"
    echo "  Fixed: pre-push hook permissions"
else
    echo "  OK: pre-push hook exists and is executable"
fi

# Step 2: Install post-checkout hook
echo "[Step 2/4] Installing post-checkout hook..."
if [ ! -f ".git/hooks/post-checkout" ]; then
    echo "  WARNING: post-checkout hook not found (optional)"
else
    if [ ! -x ".git/hooks/post-checkout" ]; then
        chmod +x ".git/hooks/post-checkout"
        echo "  Fixed: post-checkout hook permissions"
    else
        echo "  OK: post-checkout hook exists and is executable"
    fi
fi

# Step 3: Create log file
echo "[Step 3/4] Setting up logging..."
LOG_FILE="$REPO_DIR/.git/auto-pusher.log"
mkdir -p "$(dirname "$LOG_FILE")"
echo "  Log file: $LOG_FILE"
touch "$LOG_FILE"

# Step 4: Start monitoring in background
echo "[Step 4/4] Starting background monitor..."

# Kill any existing process
if pgrep -f "auto-pusher.sh" > /dev/null 2>&1; then
    echo "  WARNING: Existing process found, restarting..."
    pkill -f "auto-pusher.sh"
    sleep 1
fi

# Start the monitor in background with output to terminal
nohup "$REPO_DIR/auto-pusher.sh" >> "$LOG_FILE" 2>&1 &
MONITOR_PID=$!

echo "  Process started with PID: $MONITOR_PID"

# Create process control script
CONTROL_SCRIPT="$REPO_DIR/.git/auto-pusher-control.sh"
cat > "$CONTROL_SCRIPT" << 'EOF'
#!/bin/bash
# Control script for auto-pusher
# Usage:
#   .git/auto-pusher-control.sh start
#   .git/auto-pusher-control.sh stop
#   .git/auto-pusher-control.sh status
#   .git/auto-pusher-control.sh restart

REPO_DIR="/D/DevOps-Projects"
SCRIPT="$REPO_DIR/auto-pusher.sh"
LOG="$REPO_DIR/.git/auto-pusher.log"

case "$1" in
    start)
        echo "Starting auto-pusher..."
        if pgrep -f "$SCRIPT" > /dev/null 2>&1; then
            echo "Already running (PID: $(pgrep -f "$SCRIPT"))"
        else
            nohup "$SCRIPT" >> "$LOG" 2>&1 &
            echo "Started (PID: $!)"
        fi
        ;;
    stop)
        echo "Stopping auto-pusher..."
        if pgrep -f "$SCRIPT" > /dev/null 2>&1; then
            pkill -f "$SCRIPT"
            echo "Stopped"
        else
            echo "Not running"
        fi
        ;;
    restart)
        .git/auto-pusher-control.sh stop
        sleep 1
        .git/auto-pusher-control.sh start
        ;;
    status)
        echo "Auto-pusher status:"
        if pgrep -f "$SCRIPT" > /dev/null 2>&1; then
            echo "  Running (PID: $(pgrep -f "$SCRIPT"))"
            echo "  Last log entry:"
            tail -5 "$LOG"
        else
            echo "  Not running"
        fi
        ;;
    *)
        echo "Usage: $0 {start|stop|restart|status}"
        ;;
esac
EOF

chmod +x "$CONTROL_SCRIPT"
echo "  Control script created: $CONTROL_SCRIPT"

# Step 5: Show summary
echo ""
echo "=========================================="
echo "  Setup Complete!"
echo "=========================================="
echo ""
echo "Auto-pusher is now monitoring the repository."
echo "It will check for changes every 5 minutes"
echo "and push automatically when detected."
echo ""
echo "=== Commands ==="
echo "  Start:  .git/auto-pusher-control.sh start"
echo "  Stop:   .git/auto-pusher-control.sh stop"
echo "  Restart:.git/auto-pusher-control.sh restart"
echo "  Status: .git/auto-pusher-control.sh status"
echo ""
echo "=== Logs ==="
echo "  View logs: tail -f .git/auto-pusher.log"
echo ""
echo "=== Git Hooks Installed ==="
echo "  .git/hooks/pre-push"
echo "  .git/hooks/post-checkout"
echo ""
echo "=========================================="

# Test the monitor
echo ""
echo "Test run: Checking current status..."
sleep 2
tail -5 "$LOG" 2>/dev/null || echo "No log entries yet"
