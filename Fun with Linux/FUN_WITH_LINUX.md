# Fun with Linux for DevOps Engineers

## Module 1 Overview

This module covers essential Linux skills every DevOps engineer needs.

---

## Table of Contents

1. [File System Basics](#1-file-system-basics)
2. [User and Group Management](#2-user-and-group-management)
3. [File Permissions](#3-file-permissions)
4. [Process Management](#4-process-management)
5. [Package Management](#5-package-management)
6. [Networking Basics](#6-networking-basics)
7. [Practical Exercises](#8-practical-exercises)

---

## 1. File System Basics

### Navigating the File System

| Command | Description | Example |
|---------|-------------|---------|
| `pwd` | Print working directory | `pwd` |
| `ls` | List directory contents | `ls -la` |
| `cd` | Change directory | `cd /var/log` |
| `tree` | Show directory tree | `tree -L 2` |

### Viewing Files

```bash
# View file contents
cat filename
less filename          # For large files
head -20 filename      # First 20 lines
tail -f filename       # Follow file (logs)

# Search in files
grep "pattern" filename
grep -r "pattern" /path/
```

### File Operations

```bash
# Create files/directories
touch filename
mkdir directory
mkdir -p path/to/dir

# Copy/Move/Remove
cp source dest
mv source dest
rm filename
rm -rf directory

# Compress
tar -czvf archive.tar.gz directory
tar -xvzf archive.tar.gz
```

---

## 2. User and Group Management

### Create Users and Groups

```bash
# Create a group
sudo groupadd devops

# Create a user with home directory
sudo adduser devops

# Add user to group
sudo usermod -aG devops devops

# View user info
id devops
```

### Modify Users

```bash
# Change password
sudo passwd devops

# Change shell
sudo usermod -s /bin/zsh devops

# Delete user
sudo userdel devops
sudo groupdel devops
```

### Switch Users

```bash
su - devops              # Switch to user
sudo su                  # Switch to root
```

---

## 3. File Permissions

### Understanding Permissions

```
-rwxr-xr-- 1 devops devops 4096 Jan 1 10:00 /path/to/file
│   │   │    └─ Other (rwx)
│   │   └─── Group (rwx)
│   └────── Owner (rwx)
```

| Symbol | Meaning |
|--------|---------|
| `r` | Read (4) |
| `w` | Write (2) |
| `x` | Execute (1) |
| `---` | No permission (0) |

### Permission Commands

```bash
# View permissions
ls -l filename
stat filename

# Change permissions (symbolic)
chmod u+r filename          # Owner read
chmod go-w filename        # Group write
chmod o-x filename         # Remove other execute
chmod 755 filename         # Numeric: rwxr-xr-x

# Change ownership
sudo chown user:group file
sudo chown -R user:group /dir

# Special permissions
chmod +s filename          # Setuid
chmod +s filename          # Setgid
chmod u+s,g+s filename     # SUID/SGID
```

### Security Best Practices

```bash
# Find world-writable files (security risk)
find / -type f -perm -0002 -ls

# Fix ownership (root should not own user files)
find /home -user root -exec chown {} :group \;

# Remove sticky bit from /tmp
chmod o-t /tmp
```

---

## 4. Process Management

### View Processes

```bash
ps aux                    # All processes
ps -ef                    # Executive format
top                       # Real-time view
htop                     # Enhanced top
pgrep "process"           # By name
ps -u username            # By user
```

### Process Control

```bash
# Get process info
ps -p PID -o pid,ppid,user,%cpu,command

# Kill processes
kill PID                  # Graceful
kill -9 PID               # Force kill
pkill process_name        # By name
killall process_name

# Monitor process
watch -n 1 'ps aux | grep process'
```

### System Services

```bash
# Check service status
systemctl status nginx

# Start/stop/restart
sudo systemctl start nginx
sudo systemctl stop nginx
sudo systemctl restart nginx

# Enable on boot
sudo systemctl enable nginx

# View logs
journalctl -u nginx
```

---

## 5. Package Management

### Debian/Ubuntu (apt)

```bash
# Update package list
sudo apt update

# Upgrade packages
sudo apt upgrade

# Install package
sudo apt install nginx

# Remove package
sudo apt remove nginx
sudo apt autoremove       # Remove unused deps

# View installed packages
dpkg -l
apt list --installed
```

### RHEL/CentOS (yum/dnf)

```bash
sudo dnf update
sudo dnf install nginx
sudo dnf remove nginx
```

### Archive Management

```bash
# Compress files
tar -czvf archive.tar.gz folder

# Extract archive
tar -xvzf archive.tar.gz

# Gzip compression
gzip file.txt
gunzip file.txt.gz

# Zip
zip -r archive.zip folder
unzip archive.zip
```

---

## 6. Networking Basics

### Network Configuration

```bash
# IP address info
ip addr show
ifconfig                  # Alternative

# Network routes
ip route show
route -n

# DNS
cat /etc/resolv.conf
host example.com
nslookup example.com
```

### Network Diagnostics

```bash
# Connectivity
ping host
traceroute host
mtr host                  # ping + traceroute

# Port scanning
nc -zv host port
telnet host port
ssh -p port user@host

# SSH key setup
ssh-keygen -t ed25519
cat ~/.ssh/id_ed25519.pub
```

### Firewall

```bash
# UFW (Ubuntu)
sudo ufw enable
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw deny 22/tcp

# iptables
sudo iptables -L -n
sudo iptables -D INPUT port
```

---

## 8. Practical Exercises

### Exercise 1: Set Up Development Environment

```bash
# 1. Create a dev user
sudo adduser devuser
sudo usermod -aG www-data devuser
passwd devuser

# 2. Create project directory
sudo mkdir -p /var/www/myapp
sudo chown -R devuser:www-data /var/www/myapp
chmod -R 755 /var/www/myapp

# 3. Set up SSH keys for git
ssh-keygen -t ed25519
# Copy public key to GitHub/GitLab
```

### Exercise 2: Configure Monitoring

```bash
# 1. Create log rotation
sudo nano /etc/logrotate.d/myapp

# 2. Set up cron job for cleanup
sudo nano /etc/cron.daily/cleanup

# 3. Add monitoring user
sudo useradd --system --no-create-home --shell /bin/false prometheus
```

---

## ✅ Completion Checklist

- [ ] Navigate file system confidently
- [ ] Create/manipulate users and groups
- [ ] Modify file permissions securely
- [ ] Monitor and control processes
- [ ] Install packages and manage dependencies
- [ ] Diagnose network issues
- [ ] Configure basic firewall rules

---

## 📝 Notes

_Your notes here..._
