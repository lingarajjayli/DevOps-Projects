# Auto-Pusher Setup Documentation

This repository now has an automatic push system that monitors for changes and pushes to the remote repository.

## Features

- **Automatic Monitoring**: Checks for changes every 5 minutes (300 seconds)
- **Smart Push Detection**: Only pushes actual code changes (respects `.gitignore`)
- **Status Updates**: Provides clear status messages for each check
- **Handles Empty State**: Gracefully handles cases where there are no changes

## What Was Installed

### Git Hooks

1. **`.git/hooks/pre-push`**
   - Intercepts push operations
   - Checks for staged changes
   - Filters out ignored files and binaries
   - Creates commit if changes are detected
   - Pushes to remote repository

2. **`.git/hooks/post-checkout`**
   - Logs checkout events
   - Tracks branch transitions
   - Useful for audit trails

### Monitoring Script

**`auto-pusher.sh`**
- Main monitoring script
- Runs continuously in background
- Checks for changes every 5 minutes
- Pushes automatically when changes detected
- Logs all activities to `.git/auto-pusher.log`

### Control Script

**`.git/auto-pusher-control.sh`**
- Manage the auto-pusher process
- Commands:
  - `start` - Start monitoring
  - `stop` - Stop monitoring
  - `restart` - Restart monitoring
  - `status` - Check current status

## Usage

### Start Auto-Pusher
```bash
.D/DevOps-Projects/.git/auto-pusher-control.sh start
```

### Stop Auto-Pusher
```bash
.D/DevOps-Projects/.git/auto-pusher-control.sh stop
```

### Check Status
```bash
.D/DevOps-Projects/.git/auto-pusher-control.sh status
```

### Restart Auto-Pusher
```bash
.D/DevOps-Projects/.git/auto-pusher-control.sh restart
```

### View Logs
```bash
tail -f .git/auto-pusher.log
```

## How It Works

1. **Monitor Loop**: Runs a continuous loop checking every 5 minutes
2. **Change Detection**: Uses `git status --porcelain` to detect changes
3. **Smart Filtering**: Ignores:
   - Untracked files (shown with `??`)
   - Binary files
   - Files in `.gitignore`
4. **Automatic Push**: When code changes are detected:
   - Stages all changes
   - Creates commit
   - Pushes to remote repository
5. **Logging**: All activities logged with timestamps

## Files Created

```
.git/
├── hooks/
│   ├── pre-push           # Intercepts push, commits and pushes changes
│   └── post-checkout      # Logs checkout events
├── auto-pusher.sh         # Main monitoring script
├── auto-pusher-control.sh # Control script (start/stop/restart)
├── auto-pusher.service    # Systemd service file (optional)
└── auto-pusher.log        # Activity log
```

## Setup Script

Run the setup script to configure everything:

```bash
./setup-auto-pusher.sh
```

This will:
1. Install git hooks
2. Create logging infrastructure
3. Start background monitoring
4. Create control scripts

## Customization

### Change Check Interval

Edit `auto-pusher.sh` and modify the `INTERVAL` variable:

```bash
INTERVAL=300  # 5 minutes (default)
INTERVAL=60   # 1 minute
INTERVAL=600  # 10 minutes
```

### Change Remote/Branch

Edit the `REMOTE` and `BRANCH` variables:

```bash
REMOTE="origin"
BRANCH="master"
```

### Add Hooks

You can add additional hooks:

- `pre-commit`: Validate before committing
- `post-merge`: Run tests after merge
- `pre-rebase`: Warn before rebasing

## Troubleshooting

### No Changes Detected but Expecting Push

Check for ignored files:
```bash
git status
```

### Process Not Running

```bash
.D/DevOps-Projects/.git/auto-pusher-control.sh start
```

### View Recent Activity

```bash
tail -100 .git/auto-pusher.log
```

## Example Log Output

```
==========================================
  Auto-Pusher: Checking for changes       
  Branch: master | Remote: origin         
  Timestamp: 2026-04-23 22:57:01         
==========================================
Status: No changes detected
Action: Skipping push (no changes)
==========================================
```

## Notes

- The monitor runs in background with `nohup`
- Logs are written to `.git/auto-pusher.log`
- Process can be controlled via control script
- Automatically restarts on system reboot (if using systemd)
