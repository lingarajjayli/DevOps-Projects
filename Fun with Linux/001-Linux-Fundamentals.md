# 001 - Linux Fundamentals for DevOps Engineers

**Module 1 of the DevOps Learning Path**  
**Project:** Fun with Linux for Cloud & DevOps Engineers

---

## Overview

This module covers essential Linux skills every DevOps engineer must master.

---

## Table of Contents

1. [File System Basics](#1-file-system-basics)
2. [002 - User and Group Management](#2-user-and-group-management)
3. [003 - File Permissions](#3-file-permissions)
4. [004 - Process Management](#4-process-management)
5. [005 - Package Management](#5-package-management)
6. [006 - Networking Basics](#6-networking-basics)
7. [007 - Practical Exercises](#7-practical-exercises)

---

## 001 - File System Basics

### Navigating the File System

| Command | Description | Example |
|---------|-------------|---|
| `pwd` | Print working directory | `pwd` |
| `ls` | List directory contents | `ls -la` |
| `cd` | Change directory | `cd /var/log` |
| `tree` | Show directory tree | `tree -L 2` |

### Viewing Files

```bash
# View file contents
cat filename              # View entire file
less filename             # For large files (scrollable)
head -20 filename         # First 20 lines
tail -20 filename         # Last 20 lines
tail -f filename          # Follow file (useful for logs)

# Search in files
grep "pattern" filename
grep -r "pattern" /path/ # Recursive search
grep -i "pattern" file   # Case insensitive
grep -v "pattern" file   # Inverse match
```

### File Operations

```bash
# Create files/directories
touch filename
mkdir directory
mkdir -p path/to/nested/dir

# Copy/Move/Remove
cp source dest            # Copy file
cp -r source dest         # Copy directory
mv source dest            # Move/Rename
rm filename               # Remove file
rm -r directory           # Remove directory
rm -rf directory          # Force remove

# View and manage clipboard (copy/paste)
xclip -sel clip           # Copy to clipboard
xclip -sel clip -o        # Paste from clipboard
```

### Directory Management

```bash
# Create temp directory
mkdir -p /tmp/mymodule1
cd /tmp/mymodule1

# Create subdirectories
mkdir -p {src,bin,config}

# Cleanup
rm -rf /tmp/mymodule1
```

---

## 002 - User and Group Management

### Create Users and Groups

```bash
# Create a group
sudo groupadd devops

# Create a user with home directory
sudo adduser devops
# This creates:
# - Home directory at /home/devops
# - Default shell (/bin/bash)
# - User ID (UID)

# View user info
id devops                 # Shows UID, GID, groups
getent passwd devops      # View user entry

# Add user to existing groups
sudo usermod -aG devops devops

# Copy from existing user
cp -f /etc/passwd /home/username/etc/passwd
# Then modify entries...
```

### Modify Users

```bash
# Change password
sudo passwd devops       # Interactive password change

# Change user's shell
sudo usermod -s /bin/zsh devops

# Add home directory
mkdir /home/custom/home
chown devops:devops /home/custom/home

# Delete user and home
sudo userdel devops
sudo userdel -r devops   # Also remove home directory
```

### Switch Users

```bash
su - devops              # Switch to user (load .bash_profile)
sudo su                  # Switch to root
whoami                   # Current user
groups                   # List all groups
```

---

## 003 - File Permissions

### Understanding Permissions

```
-rwxr-xr-- 1 devops devops 4096 Jan 1 10:00 /path/to/file
│   │   │    └─ Other (rwx)
│   │   └─── Group (rwx)
│   └────── Owner (rwx)
└─ File type (r = regular)
```

| Symbol | Meaning | Octal |
|--------|---------|-------|
| `r` | Read | 4 |
| `w` | Write | 2 |
| `x` | Execute | 1 |
| `---` | No permission | 0 |

### Permission Commands

```bash
# View permissions
ls -l filename           # Long format
ls -ld directory         # Directory itself
stat filename            # Detailed stats

# Change permissions (symbolic)
chmod u+r filename       # Owner add read
chmod u-r filename       # Owner remove read
chmod g+w filename       # Group add write
chmod o-x filename       # Other remove execute
chmod a=rwx filename     # All: rwx
chmod g=r,o=r filename   # Group and other: read only

# Change permissions (numeric)
chmod 755 filename       # rwxr-xr-x
chmod 744 filename       # rwxr--r--
chmod 644 filename       # rw-r--r-- (default for files)
chmod 700 filename       # rwx------ (private)
chmod 600 filename       # rw------- (sensitive)

# Special permissions
chmod +s filename        # Setuid (root only)
chmod +s filename        # Setgid
chmod u+s,g+s filename   # SUID+SGID

# Change ownership
sudo chown user:group file
sudo chown -R user:group /dir  # Recursive

# Find special permission files
find / -perm -4000 -ls   # SUID files (security risk)
find / -perm -2000 -ls   # SGID files
```

### Security Best Practices

```bash
# Find world-writable files (security risk!)
find / -type f -perm -0002 -ls
find / -type d -perm -0002 -ls

# Fix ownership (root should not own user files)
find /home -user root -exec chown {} :group \;

# Remove sticky bit from /tmp
chmod o-t /tmp           # More secure

# Set proper permissions for web app
chmod -R 755 /var/www/html
chmod -R 644 /var/www/config/*

# Create secure log directory
sudo mkdir -p /var/log/myapp
sudo chown syslog:adm /var/log/myapp
sudo chmod 750 /var/log/myapp
```

### Permission Matrix

| Command | Result |
|---------|--------|
| `chmod 777 file` | Anyone can read/write/execute (dangerous!) |
| `chmod 755 file` | Owner: full, Others: read+execute (standard) |
| `chmod 744 file` | Owner: full, Others: read only |
| `chmod 644 file` | Owner: read/write, Others: read (data files) |
| `chmod 600 file` | Owner: read/write only (secrets) |
| `chmod 400 file` | Owner: read only (keys) |
| `chmod +x file` | Make executable |
| `chmod -x file` | Remove execute |

---

## 004 - Process Management

### View Processes

```bash
ps aux                    # All processes (detailed)
ps -ef                    # Executive format (compact)
top                       # Real-time interactive view
htop                     # Enhanced top (colors, tabs)
pgrep "nginx"             # Find by name
ps -u username            # By user
pidof nginx              # Get PID
```

### Process Control

```bash
# Get process info
ps -p PID -o pid,ppid,user,%cpu,command

# Find process by name
ps -ef | grep nginx
pgrep nginx

# Kill processes
kill PID                  # Graceful (SIGTERM)
kill -15 PID              # SIGTERM (same as kill)
kill -9 PID               # Force kill (SIGKILL)
pkill nginx               # Kill by name
killall nginx             # Kill all instances

# Monitor process CPU
watch -n 1 'ps aux | grep nginx'

# Check process status
ps aux | grep -E 'PID|COMMAND|%CPU'
```

### System Services (systemd)

```bash
# Check service status
systemctl status nginx
systemctl is-active nginx

# Start/stop/restart
sudo systemctl start nginx
sudo systemctl stop nginx
sudo systemctl restart nginx
sudo systemctl reload nginx

# Enable on boot (auto-start)
sudo systemctl enable nginx
sudo systemctl disable nginx

# Check enabled services
systemctl list-unit-files --type=service

# View logs
journalctl -u nginx
journalctl -f -u nginx    # Follow logs

# Reload systemd daemon
sudo systemctl daemon-reload
```

### Process Limits

```bash
# View limits
ulimit -a                 # All limits
ulimit -n                 # Max file descriptors

# Set limits
ulimit -n 4096           # File descriptors
ulimit -u 4096           # Max processes
```

---

## 005 - Package Management

### Debian/Ubuntu (apt)

```bash
# Update package list
sudo apt update           # Fetch latest package lists

# Upgrade packages
sudo apt upgrade          # Upgrade all packages
sudo apt dist-upgrade     # Handle dependencies
sudo apt full-upgrade     # Remove packages if needed

# Install package
sudo apt install nginx    # Install package
sudo apt install -y pkg   # Auto-confirm

# Remove package
sudo apt remove nginx     # Remove package
sudo apt autoremove       # Remove unused deps
sudo apt clean            # Clean package cache

# View installed packages
dpkg -l                   # List all packages
apt list --installed      # Human readable
apt showsources pkg       # View package source
```

### RHEL/CentOS/Fedora (dnf/yum)

```bash
sudo dnf update           # Update packages
sudo dnf install nginx    # Install
sudo dnf remove nginx     # Remove
sudo yum search httpd     # Search packages
```

### Archive Management

```bash
# Create tar archive
tar -czvf archive.tar.gz folder      # Compress
tar -cf archive.tar folder           # Uncompressed
tar -cjvf archive.tar.bz2 folder     # Bzip2

# Extract archive
tar -xvzf archive.tar.gz     # Extract
tar -tzvf archive.tar.gz     # List contents
tar -tvf archive.tar.gz      # Verify

# Gzip compression
gzip file.txt                # Creates file.txt.gz
gunzip file.txt.gz           # Decompress
zcat file.txt.gz             # View without extracting
zmore file.txt.gz            # Paged view

# Zip/Unzip
zip -r archive.zip folder    # Compress with zip
unzip archive.zip            # Extract
zipinfo archive.zip          # Show info

# Split large archives
split -b 100m large.tar.gz parts.tar.gz
cat parts.tar.gz* > large.tar.gz
```

---

## 006 - Networking Basics

### Network Configuration

```bash
# IP address info
ip addr show                # All interfaces
ip -br addr show            # Compact
ifconfig                    # Alternative (older)
hostname                    # System hostname

# Network routes
ip route show               # Routing table
route -n                    # Numerical routing
netstat -rn                 # Routing table

# DNS configuration
cat /etc/resolv.conf       # Nameservers
hostname -d                 # Domain name
getent hosts example.com   # Resolve hostname
```

### Network Diagnostics

```bash
# Connectivity tests
ping -c 4 google.com       # Ping with count
traceroute google.com      # Trace route
tracepath google.com       # Alternative traceroute
mtr google.com             # Combined ping/traceroute

# Port checking
nc -zv google.com 443      # TCP connect test
telnet google.com 80       # Port test (legacy)
ssh -p 22 user@host        # SSH port test
netstat -tlnp              # Listening ports
ss -tlnp                   # Alternative to netstat

# DNS resolution
nslookup google.com        # NSlookup
dig google.com             # DNS lookup (advanced)
host google.com            # Simple DNS
```

### SSH Setup

```bash
# Generate SSH key
ssh-keygen -t ed25519      # Modern default
ssh-keygen -t rsa          # Fallback

# Copy public key
cat ~/.ssh/id_ed25519.pub | ssh user@host "cat >> ~/.ssh/authorized_keys"
ssh-copy-id user@host       # Copy key (if available)

# Test SSH connection
ssh -v user@host           # Verbose mode
ssh user@host              # Normal

# SSH config
ssh-add                    # Add private key to agent
ssh-add -l                 # List keys
```

### Firewall

```bash
# UFW (Ubuntu)
sudo ufw enable
sudo ufw disable
sudo ufw status
sudo ufw allow 80/tcp      # Allow HTTP
sudo ufw allow 443/tcp     # Allow HTTPS
sudo ufw deny 22/tcp       # Deny SSH
sudo ufw delete allow 80/tcp

# iptables
sudo iptables -L -n        # List rules
sudo iptables -D INPUT 1    # Delete rule 1
sudo iptables -A INPUT -p tcp --dport 80 -j ACCEPT
```

---

## 007 - Practical Exercises

### Exercise 1: Set Up Development Environment

**Goal:** Create a development environment for a new project

```bash
# 1. Create a dev user (if not exists)
sudo adduser devuser
sudo passwd devuser        # Set password
sudo usermod -aG www-data devuser  # Add to web group
sudo adduser devuser sudo  # Add to sudo group

# 2. Create project directory structure
sudo mkdir -p /var/www/myapp/{src,bin,config,logs}
sudo chown -R devuser:www-data /var/www/myapp
sudo chmod -R 755 /var/www/myapp
sudo chmod -R 644 /var/www/myapp/config

# 3. Configure SSH for git
ssh-keygen -t ed25519 -C "devuser"
cat ~/.ssh/id_ed25519.pub
# Copy output to GitHub/GitLab

# 4. Set up git configuration
git config --global user.name "DevUser"
git config --global user.email "dev@example.com"
git config --global init.defaultBranch main

# 5. Test your setup
su - devuser
cd /var/www/myapp
ls -la
git init
```

### Exercise 2: Configure File Monitoring

**Goal:** Set up log rotation and monitoring

```bash
# 1. Create log rotation config
sudo nano /etc/logrotate.d/myapp

# Add this content:
# /var/log/myapp/*.log {
#     daily
#     rotate 7
#     compress
#     delaycompress
#     missingok
#     notifempty
#     create 640 devuser:www-data
# }

# 2. Create cron cleanup job
sudo nano /etc/cron.daily/cleanup

# Add this content:
#!/bin/bash
# Cleanup old temp files
find /tmp -type f -mtime +7 -delete
# Create log rotation
find /var/log -name "*.log.*" -mtime +30 -delete
# chmod 755 /etc/cron.daily/cleanup
```

### Exercise 3: Set Up System Monitoring

**Goal:** Create monitoring user and setup

```bash
# 1. Create monitoring user
sudo useradd --system --no-create-home --shell /bin/false prometheus
sudo useradd --system --no-create-home --shell /bin/false node_exporter

# 2. Create monitoring directory
sudo mkdir -p /etc/prometheus
sudo mkdir -p /etc/node_exporter
sudo chown prometheus:prometheus /etc/prometheus
sudo chmod 700 /etc/prometheus

# 3. Create metrics port forwarding
sudo mkdir -p /var/run/node_exporter
sudo chown prometheus:prometheus /var/run/node_exporter
sudo chmod 755 /var/run/node_exporter

# 4. Set up alerting scripts
sudo nano /usr/local/bin/check-cpu
sudo nano /usr/local/bin/check-memory
```

### Exercise 4: Hardening System Security

**Goal:** Improve system security posture

```bash
# 1. Disable password auth (if using SSH keys only)
sudo nano /etc/ssh/sshd_config
# Set: PasswordAuthentication no
# Set: PermitRootLogin no

# 2. Restrict SSH to specific IPs
sudo nano /etc/ssh/sshd_config
# Set: AllowUsers devuser

# 3. Remove unused accounts
for user in $(awk -F: '$3>=1000 && $3!="*" {print $1}' /etc/passwd); do
    if ! grep -q "$user" /etc/group; then
        echo "User $user not in any group, removing..."
        sudo userdel -r $user
    fi
done

# 4. Audit world-writable files
find / -type f -perm -0002 2>/dev/null

# 5. Check for SUID binaries
find / -perm -4000 -type f 2>/dev/null | grep -v -E "^/(usr|bin)/sbin"
```

---

## ✅ Module 1 Completion Checklist

- [ ] Navigate file system confidently (`ls`, `cd`, `pwd`, `tree`)
- [ ] View and manage files (`cat`, `less`, `head`, `tail`, `grep`)
- [ ] Create files and directories (`touch`, `mkdir`, `tar`)
- [ ] Create/manipulate users and groups (`adduser`, `usermod`, `groupadd`)
- [ ] Modify file permissions (`chmod`, `chown`)
- [ ] Monitor and control processes (`ps`, `top`, `kill`, `systemctl`)
- [ ] Install packages and manage dependencies (`apt`, `dnf`, `tar`, `gzip`)
- [ ] Diagnose network issues (`ping`, `traceroute`, `ss`, `firewall`)
- [ ] Set up SSH key authentication
- [ ] Complete Exercise 1 (Development Environment)
- [ ] Complete Exercise 2 (File Monitoring)
- [ ] Complete Exercise 3 (System Monitoring)
- [ ] Complete Exercise 4 (Security Hardening)

---

## 📝 Your Notes

```
Date Completed: ___________

Notes:

```

---

## Next Steps

**Module 1 Complete!** Ready to proceed to:
- **Module 2:** Docker Containerization (DevOps-Project-01)
- **OR:** Practice more Linux commands
- **OR:** Review any sections

---

**Status:** ⬜ Not Started | ⬜ In Progress | ✅ Completed

---

*Created: 2026-04-23*
