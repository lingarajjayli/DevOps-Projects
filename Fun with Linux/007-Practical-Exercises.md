# 007 - Practical Exercises

**Module 1 - Part 7**  
**Topic:** Hands-on exercises to practice Linux skills

---

## Exercise 1: Set Up Development Environment

**Goal:** Create a complete development environment for a new project

**Time:** ~15 minutes

### Step 1: Create a Dev User

```bash
# 1. Create development user
sudo groupadd devops
sudo adduser devdev
sudo passwd devdev
sudo usermod -aG devops devdev
sudo usermod -aG www-data devdev

# 2. View user info
id devdev
getent passwd devdev
```

### Step 2: Create Project Directory Structure

```bash
# Create app directory
sudo mkdir -p /var/www/myapp/{src,bin,config,logs}
sudo chown -R devdev:devops /var/www/myapp
sudo chmod -R 755 /var/www/myapp
sudo chmod -R 700 /var/www/myapp/config

# Test as dev user
su - devdev
cd /var/www/myapp
ls -la
exit
```

### Step 3: Configure SSH for Git

```bash
# Generate SSH key
ssh-keygen -t ed25519 -C "devdev"
# Press Enter for all prompts

# View public key
cat ~/.ssh/id_ed25519.pub
# Copy output - paste to GitHub/GitLab
```

### Step 4: Set Up Git Configuration

```bash
# Configure git
git config --global user.name "DevUser"
git config --global user.email "devdev@example.com"
git config --global init.defaultBranch main

# Verify config
git config --list
```

### Step 5: Test Setup

```bash
# Test as dev user
su - devdev
git init
ls -la
whoami
exit
```

---

## Exercise 2: Configure Log Rotation

**Goal:** Set up proper log management

**Time:** ~10 minutes

### Step 1: Create Log Directory

```bash
# Create log directory
sudo mkdir -p /var/log/myapp
sudo chown devdev:devops /var/log/myapp
sudo chmod 750 /var/log/myapp
```

### Step 2: Create Sample Log Files

```bash
# Create sample log files
touch /var/log/myapp/app.log
touch /var/log/myapp/error.log
touch /var/log/myapp/access.log

# Set proper permissions
sudo chown devdev:devops /var/log/myapp/*.log
sudo chmod 640 /var/log/myapp/*.log
```

### Step 3: Create Logrotate Config

```bash
# Create logrotate config
sudo nano /etc/logrotate.d/myapp

# Add this content:
# /var/log/myapp/*.log {
#     daily
#     rotate 7
#     compress
#     delaycompress
#     missingok
#     notifempty
#     create 640 devdev:devops
#     sharedscripts
#     postrotate
#         systemctl reload myapp > /dev/null 2>&1 || true
#     endscript
# }

# Test config
sudo logrotate -d /etc/logrotate.d/myapp
```

### Step 4: Create Cleanup Script

```bash
# Create cleanup script
sudo nano /etc/cron.daily/cleanup

# Add this content:
#!/bin/bash
# Cleanup old temp files
find /tmp -type f -mtime +7 -delete
find /tmp -type d -mtime +14 -delete 2>/dev/null || true

# Cleanup old logs
find /var/log -name "*.log.*" -mtime +30 -delete 2>/dev/null || true

# chmod 755 /etc/cron.daily/cleanup
```

---

## Exercise 3: Set Up System Monitoring

**Goal:** Create monitoring user and setup

**Time:** ~10 minutes

### Step 1: Create Monitoring Users

```bash
# Create monitoring users
sudo useradd --system --no-create-home --shell /bin/false prometheus
sudo useradd --system --no-create-home --shell /bin/false node_exporter
sudo useradd --system --no-create-home --shell /bin/false grafana

# Verify users
id prometheus
id node_exporter
```

### Step 2: Create Monitoring Directories

```bash
# Create directories
sudo mkdir -p /etc/prometheus
sudo mkdir -p /etc/node_exporter
sudo mkdir -p /var/run/node_exporter
sudo mkdir -p /var/run/prometheus

# Set ownership
sudo chown prometheus:prometheus /etc/prometheus
sudo chown prometheus:prometheus /var/run/prometheus

sudo chown node_exporter:node_exporter /etc/node_exporter
sudo chown node_exporter:node_exporter /var/run/node_exporter

# Set permissions
sudo chmod 700 /etc/prometheus
sudo chmod 700 /etc/node_exporter
sudo chmod 755 /var/run/node_exporter
sudo chmod 755 /var/run/prometheus
```

---

## Exercise 4: Hardening System Security

**Goal:** Improve system security posture

**Time:** ~20 minutes

### Step 1: Find World-Writable Files

```bash
# Find dangerous world-writable files
find / -type f -perm -0002 2>/dev/null
find / -type d -perm -0002 2>/dev/null

# Fix found files
# For each file found:
# chmod o-w /path/to/file
```

### Step 2: Fix Ownership Issues

```bash
# Find user-owned root files
find /home -user root -ls 2>/dev/null

# Fix ownership
find /home -user root -exec chown {} :group \;

# Find root-owned user files
find /home -group root -exec chown root {} \;
```

### Step 3: Audit SUID Binaries

```bash
# Find SUID binaries (security audit)
find / -perm -4000 -type f 2>/dev/null

# Safe SUID binaries (should not be removed)
/usr/bin/sudo
/usr/bin/su
/usr/bin/mount
/usr/bin/passwd

# Fix dangerous SUID files
# chmod u-s /path/to/suidfile
```

### Step 4: Remove Unused SSH Keys

```bash
# List SSH keys
ls -la ~/.ssh/

# Remove unused keys
rm ~/.ssh/unused_key_1
rm ~/.ssh/unused_key_2

# Remove unused known_hosts
cat ~/.ssh/known_hosts
# Remove old or unused hosts
```

### Step 5: Check for Vulnerable Files

```bash
# Find insecure configurations
find /etc -perm -666 2>/dev/null
find /etc -perm -777 2>/dev/null

# Find world-writable config files
find /etc -type f -perm -002 2>/dev/null

# Check for sensitive files
find / -name "*.pem" -o -name "*.key" -o -name "*.p12" 2>/dev/null
# Verify permissions are 600 or 640
```

---

## Exercise 5: Create a Simple Web Application Setup

**Goal:** Set up a web app with proper permissions

**Time:** ~20 minutes

### Step 1: Create Application User

```bash
# Create app user
sudo groupadd myapp
sudo adduser myappuser
sudo usermod -aG myapp myappuser
sudo passwd myappuser
```

### Step 2: Create App Directory

```bash
# Create app directory
sudo mkdir -p /var/www/myapp/{public,assets,uploads,logs}
sudo chown -R myappuser:myapp /var/www/myapp
sudo chmod -R 755 /var/www/myapp

# Special permissions
sudo chmod 700 /var/www/myapp/logs
sudo chmod 644 /var/www/myapp/public/*
sudo chmod 644 /var/www/myapp/assets/*
```

### Step 3: Create Index File

```bash
# Create test page
sudo nano /var/www/myapp/public/index.html

# Add content:
# <!DOCTYPE html>
# <html>
#   <head><title>My App</title></head>
#   <body><h1>Hello, World!</h1></body>
# </html>

# Set permissions
sudo chown myappuser:myapp /var/www/myapp/public/index.html
sudo chmod 644 /var/www/myapp/public/index.html
```

---

## Exercise 6: Process Monitoring Setup

**Goal:** Set up process monitoring

**Time:** ~15 minutes

### Step 1: Check Current Processes

```bash
# View all processes
ps aux | head -20
ps aux --sort=-%cpu | head -10  # Top CPU users

# Find specific process
pgrep nginx
pgrep python
```

### Step 2: Monitor System Resources

```bash
# View memory
free -h
cat /proc/meminfo

# View CPU info
lscpu | head -10
top

# View disk usage
df -h
du -sh /var/*
```

### Step 3: Set Up Process Limits

```bash
# Check current limits
ulimit -a

# Set file descriptor limit
ulimit -n 4096
```

---

## Exercise 7: Network Troubleshooting

**Goal:** Practice network diagnostics

**Time:** ~15 minutes

### Step 1: Check Network Status

```bash
# View network interfaces
ip addr show
ip -br addr show

# View routes
ip route show
netstat -rn

# View listening ports
ss -tlnp
netstat -tlnp
```

### Step 2: Test Connectivity

```bash
# Test local connectivity
ping -c 4 127.0.0.1
ping -c 4 google.com

# Test DNS
nslookup google.com
dig google.com
host google.com
```

### Step 3: Test Port Connectivity

```bash
# Test port 22 (SSH)
nc -zv 127.0.0.1 22
telnet 127.0.0.1 22
# Or:
ssh -v user@127.0.0.1
```

### Step 4: Trace Route

```bash
# Trace route to website
traceroute google.com
tracepath google.com
```

---

## Completion Checklist

- [ ] **Exercise 1:** Development environment setup
- [ ] **Exercise 2:** Log rotation configuration
- [ ] [ ] System monitoring setup
- [ ] **Exercise 4:** Security hardening
- [ ] **Exercise 5:** Web app setup
- [ ] **Exercise 6:** Process monitoring
- [ ] **Exercise 7:** Network troubleshooting

---

## Module 1 Complete!

You have now completed all 7 exercises and modules!

**What you've learned:**
- ✅ File system navigation and management
- ✅ User and group management
- ✅ File permissions and ownership
- ✅ Process monitoring and control
- ✅ Package management
- ✅ Network configuration and diagnostics
- ✅ Security best practices

**Next Steps:**
Proceed to **Module 2: Docker Containerization** (DevOps-Project-01)

---

## Notes

```
Date Completed: ___________

Notes:

```

---

*End of Module 1 - Fun with Linux*
