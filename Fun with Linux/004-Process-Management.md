# 004 - Process Management

**Module 1 - Part 4**  
**Topic:** Monitoring and controlling system processes

---

## Process Concepts

### What is a Process?

A process is an instance of a program running in memory. Each process has:

- **PID (Process ID)**: Unique identifier
- **PPID (Parent Process ID)**: Parent's PID
- **User**: Owner of the process
- **CPU/Memory usage**: Resource consumption
- **State**: Running, sleeping, stopped, zombie

### Process States

```bash
# Process state symbols
R = Running
S = Sleeping (interruptible)
D = Uninterruptible sleep
Z = Zombie (terminated, waiting for parent to collect)
T = Stopped
t = Tracing stop
X = Dead
```

---

## Viewing Processes

### ps Command Options

| Option | Description | Example Output |
|--------|-------------|---|
| `ps aux` | All processes (detailed) | Full format with %CPU, %MEM |
| `ps -ef` | Executive format | Compact format |
| `ps -u user` | Processes by user | User's processes only |
| `ps -p PID` | Specific process | Single process info |

```bash
# View all processes
ps aux
# Columns: USER PID %CPU %MEM VSZ RSS TTY STAT START TIME COMMAND

# View without header
ps aux --no-headers

# Compact view
ps -eo pid,ppid,user,%cpu,%mem,stat,cmd
```

### top/htop

```bash
# Interactive process viewer
top
# Press 'P' to sort by CPU
# Press 'M' to sort by Memory
# Press 'k' to kill process (enter PID)
# Press 'q' to quit

# Enhanced top with colors
htop
# Press 'F6' to enable colors
# Press 'F4' to select process filters
```

### pgrep/pkill

```bash
# Find process by name
pgrep nginx
pgrep -a nginx          # Show arguments
pgrep -P PID            # Children of PID
pgrep -u username       # By user

# Kill by name
pkill nginx
pkill -9 nginx          # Force kill

# Kill all instances
killall nginx
killall nginx 9         # Force all instances
```

---

## Process Control

### Getting Process Info

```bash
# Get process info
ps -p PID -o pid,ppid,user,%cpu,%mem,ni,stat,command

# Check if process is running
pgrep nginx || echo "Not running"

# Get process status
cat /proc/PID/status

# View process file descriptors
ls -l /proc/PID/fd
```

### Killing Processes

```bash
# Graceful kill (SIGTERM - 15)
kill PID
kill -15 PID

# Force kill (SIGKILL - 9)
kill -9 PID
kill -KILL PID

# Common signals
kill -1 PID       # HUP
kill -2 PID       # INT
kill -9 PID       # KILL
kill -15 PID      # TERM
kill -29 PID      # CONT

# Kill process tree
kill -9 $(pgrep -P PID)
```

### Process Monitoring

```bash
# Watch process over time
watch -n 1 'ps aux | grep nginx'
watch -n 5 'top -bn1 | head -20'

# Monitor specific process
watch -n 1 'cat /proc/PID/stat'

# Count process instances
pgrep -c nginx

# List process tree
pstree -p PID
pstree -pa           # All processes as tree
```

---

## System Services (systemd)

### Service Commands

```bash
# Check service status
systemctl status nginx
systemctl is-active nginx

# Start/stop/restart
sudo systemctl start nginx
sudo systemctl stop nginx
sudo systemctl restart nginx
sudo systemctl reload nginx

# Enable on boot
sudo systemctl enable nginx
sudo systemctl disable nginx

# List all services
systemctl list-units --type=service
systemctl list-unit-files --type=service

# Check service dependencies
systemctl list-dependencies nginx
```

### Service Logs

```bash
# View service logs
journalctl -u nginx
journalctl -u nginx -f    # Follow logs
journalctl -u nginx -n 50 # Last 50 lines

# Clear logs
journalctl -p -u nginx

# View by boot
journalctl -b            # Current boot
journalctl -b -1         # Previous boot
```

---

## Process Limits

### Checking Limits

```bash
# View all limits
ulimit -a
# Common limits:
# open files: 1024
# max processes: 4096
# stack size: 8MB

# View current limits
ulimit -n              # File descriptors
ulimit -u              # Max processes
ulimit -t              # CPU time (seconds)
```

### Setting Limits

```bash
# Set limits for current session
ulimit -n 4096
ulimit -u 4096

# Set in /etc/security/limits.conf
# Syntax: username soft hard
* soft nofile 2048
* hard nofile 4096
* soft nproc 2048
* hard nproc 4096
```

---

## Service Configuration

### Creating a Service

```bash
# Create service file
sudo nano /etc/systemd/system/myapp.service

# Content:
[Unit]
Description=My Application Service
After=network.target

[Service]
Type=simple
User=www-data
WorkingDirectory=/var/www/myapp
ExecStart=/usr/bin/python3 /var/www/myapp/app.py
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target

# Reload systemd
sudo systemctl daemon-reload
sudo systemctl enable myapp
sudo systemctl start myapp
```

---

## Troubleshooting Processes

### High CPU Usage

```bash
# Find high CPU processes
ps aux --sort=-%cpu | head -10

# Check if it's a one-off or continuous
top
# Press 'Shift+'P' for CPU sort

# Identify the code location
# Use strace or ltrace to trace syscalls
```

### High Memory Usage

```bash
# Find high memory processes
ps aux --sort=-%mem | head -10

# Check memory pressure
cat /proc/meminfo
free -h

# Identify memory leaks
# Monitor over time
watch -n 60 'ps aux --sort=-%mem | head -5'
```

### Zombie Processes

```bash
# Find zombie processes
ps aux | grep 'Z+'

# Kill the parent process
# Or reparent to init (PID 1)
```

---

## Process Management Checklist

- [ ] Use `ps aux` to view all processes
- [ ] Use `top` or `htop` for interactive monitoring
- [ ] Use `pgrep` to find processes by name
- [ ] Use `pkill` to kill processes by name
- [ ] Use `systemctl` to manage services
- [ ] Use `journalctl` to view logs
- [ ] Set appropriate process limits
- [ ] Monitor for resource issues

---

## Practical Exercises

### Exercise 1: Create and Monitor a Service

```bash
# 1. Create a simple Python service
sudo mkdir -p /var/www/myapp
sudo echo "print('Hello')" > /var/www/myapp/app.py
sudo chown www-data:www-data /var/www/myapp

# 2. Create service file
sudo nano /etc/systemd/system/myapp.service
# (Use template from above)

# 3. Enable and start
sudo systemctl daemon-reload
sudo systemctl enable myapp
sudo systemctl start myapp

# 4. Monitor
watch -n 2 'systemctl status myapp'
```

---

## Notes

```
Date: _____________

Notes:

```

---

*Module 1 - Part 4*
