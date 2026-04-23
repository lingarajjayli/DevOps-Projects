# 003 - File Permissions

**Module 1 - Part 3**  
**Topic:** Understanding and managing file permissions for security

---

## Understanding File Permissions

### Permission Structure

```
-rwxr-xr-- 1 devops devops 4096 Jan 1 10:00 /path/to/file
│  │   │   │     └─ Number of hard links
│  │   │   └───── Owner group
│  │   └───────── File size
└─ File type + Permissions
```

### File Type Indicators

| Symbol | Type | Description |
|--------|------|---|
| `-` | Regular file | Most common |
| `d` | Directory | Folder |
| `l` | Symbolic link | Shortcut to another path |
| `c` | Character device | Hardware device |
| `b` | Block device | Block storage |
| `s` / `S` | Socket | Network socket |
| `p` | Named pipe | FIFO |

### Permission Bits

| Symbol | Meaning | Octal Value |
|--------|---------|---|
| `r` | Read | 4 |
| `w` | Write | 2 |
| `x` | Execute | 1 |
| `---` | No permission | 0 |

---

## Permission Notation

### Symbolic Notation

```
rwx = 7   (4 + 2 + 1)
r-x = 5   (4 + 1)
r-- = 4   (4 only)
--x = 1   (1 only)
--- = 0   (nothing)

Example: -rwxr-xr-x
Owner:  rwx = 7
Group: r-x = 5
Other:  r-x = 5
Numeric: 755
```

### Group Permissions

| Notation | Result | Use Case |
|----------|--------|----------|
| `u` | User (owner) | - |
| `g` | Group | - |
| `o` | Other (world) | - |
| `a` | All (user+group+other) | - |

---

## Modifying Permissions

### Adding/Removing Permissions

```bash
# Add read permission
chmod u+r filename

# Remove write permission
chmod u-w filename

# Add execute to group
chmod g+x filename

# Remove execute from other
chmod o-x filename

# Add all permissions to all
chmod a+rwx filename

# Quick additions
chmod +r filename    # Add read to all
chmod +w filename    # Add write to all
chmod +x filename    # Add execute to all

# Quick removals
chmod -r filename    # Remove read from all
chmod -w filename    # Remove write from all
chmod -x filename    # Remove execute from all
```

### Numeric Notation

```bash
# Owner full, Group read+exec, Other read only
chmod 755 filename

# Owner read+write, Group read, Other read only (data files)
chmod 644 filename

# Private file (only owner)
chmod 600 filename

# Read only (only owner)
chmod 400 filename

# Executable by everyone (scripts, binaries)
chmod 755 script.sh

# Data files (config, text)
chmod 644 config.json
```

### Chown (Change Ownership)

```bash
# Change owner and group
sudo chown user:group filename

# Recursive (directories)
sudo chown -R user:group /directory

# Set owner only
sudo chown user filename

# Set group only
sudo chown :group filename

# Set all files in directory to user
sudo chown -R $USER:$USER /var/www/myapp

# Special cases
sudo chown root:root /etc
sudo chown www-data:www-data /var/www/html
```

---

## Special Permissions

### Setuid (SUID) - Run as owner

```bash
# Set setuid bit
chmod u+s filename
chmod 4755 filename

# Verify
ls -l filename
# Should show: -rwsr-xr-x
```

**Use case:** `sudo` command, `passwd` command

### Setgid (SGID) - Group inheritance

```bash
# Set setgid bit
chmod g+s filename
chmod 2755 filename

# Directory: new files inherit group
mkdir /shared
chmod g+s /shared
# New files in /shared get group ownership
```

### Sticky Bit - Delete restriction

```bash
# Set sticky bit on /tmp
chmod +t /tmp
chmod 1777 /tmp

# Verify
ls -ld /tmp
# Should show: drwxrwxrwt
```

**Use case:** `/tmp` directory - users can only delete their own files

---

## Finding Permission Issues

### Security Audits

```bash
# Find world-writable files (security risk!)
find / -type f -perm -0002 2>/dev/null
find / -type d -perm -0002 2>/dev/null

# Find SUID binaries (potential security risk)
find / -perm -4000 -type f 2>/dev/null | grep -v -E "^/(usr|bin)/sbin"

# Find SGID binaries
find / -perm -2000 -type f 2>/dev/null

# Find files owned by root (user shouldn't own)
find /home -user root -ls 2>/dev/null

# Find world-readable sensitive files
find /etc -name "*.pem" -o -name "*.key" 2>/dev/null

# Find files without read permission
find / -type f ! -perm -4 2>/dev/null | head -20
```

### Fixing Common Issues

```bash
# Fix: user shouldn't own files in /etc
find /etc -user $USER -exec chown root:$USER {} \;

# Fix: world-writable config files
find /etc -perm -002 -type f -exec chmod o-w {} \;

# Fix: world-readable private keys
find / -name "*.pem" -o -name "*.key" -exec chmod 600 {} \;

# Fix: proper web app permissions
chmod -R 755 /var/www/html
chmod -R 644 /var/www/config/*
chown -R www-data:www-data /var/www/html
```

---

## Practical Permission Scenarios

### Scenario 1: Web Application Directory Structure

```bash
# Create directory structure
mkdir -p /var/www/myapp/{public,admin,uploads,logs}

# Set permissions
chmod 755 /var/www/myapp
chmod 755 /var/www/myapp/public
chmod 700 /var/www/myapp/admin        # Admin (owner only)
chmod 755 /var/www/myapp/uploads
chmod 644 /var/www/myapp/.htaccess
chmod 600 /var/www/myapp/.env         # Sensitive (read only)

# Set ownership
chown www-data:www-data /var/www/myapp
chown root:www-data /var/www/myapp/.env

# Admin directory: owner (root) only
chown root:www-data /var/www/myapp/admin
```

### Scenario 2: Log Files

```bash
# Create log directory
mkdir -p /var/log/myapp

# Set permissions
chown syslog:adm /var/log/myapp
chmod 750 /var/log/myapp

# Log files
touch /var/log/myapp/app.log
chown syslog:adm /var/log/myapp/app.log
chmod 640 /var/log/myapp/app.log
```

### Scenario 3: SSH Keys

```bash
# Create .ssh directory
mkdir -p ~/.ssh

# Set permissions
chmod 700 ~/.ssh
chmod 600 ~/.ssh/id_rsa           # Private key (read+write)
chmod 644 ~/.ssh/id_rsa.pub       # Public key (read only)
chmod 600 ~/.ssh/known_hosts
chmod 644 ~/.ssh/config           # Read by SSH client
```

---

## Security Best Practices

### Recommended Permission Values

| File Type | Permissions | Example |
|-----------|-------------|---------|
| Executables | `755` | scripts, binaries |
| Data files | `644` | configs, logs |
| Private keys | `600` | SSH keys, passwords |
| User home | `700` | Private directories |
| `/tmp` | `1777` | World-writable with sticky |
| `.env` files | `600` | Sensitive data |
| Web content | `644` | Read by all |

### Permission Matrix Quick Reference

```
777 = rwxrwxrwx  (Everyone read/write/execute - DANGEROUS!)
755 = rwxr-xr-x  (Owner full, Others read+exec - Standard)
750 = rwxr-x---  (Owner+Group, Others none)
744 = rwxr--r--  (Owner full, Others read)
700 = rwx------  (Owner only)
644 = rw-r--r--  (Owner rw, Others r - Data files)
600 = rw-------  (Owner rw only - Sensitive)
400 = r--------  (Owner read only - Keys)
666 = rw-rw-rw-  (Everyone rw - Rarely used)
444 = r--r--r--  (Everyone read only)
```

---

## Permission Testing

```bash
# Test read permission
cat file.txt               # If works: read permission exists

# Test write permission
echo "test" > file.txt     # If works: write permission exists

# Test execute permission
./script.sh                # If works: execute permission exists

# Test directory traversal
cd /dir                    # Enter: execute permission
ls /dir                    # List: read permission
touch /dir/newfile         # Create: write permission
```

---

## Notes

```
Date: _____________

Notes:

```

---

*Module 1 - Part 3*
