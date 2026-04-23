# 002 - User and Group Management

**Module 1 - Part 2**  
**Topic:** Creating, managing users and groups for DevOps

---

## Overview

User and group management is critical for DevOps security. Understanding who has access to what is essential for audit compliance and security best practices.

---

## User Concepts

### User Account Structure

```
User Account
├── UID (Unique Identifier)
├── Username
├── Home Directory
├── Default Shell
└── Groups (Primary + Secondary)
```

### Group Concepts

- **Primary Group:** User's main group (usually same name as username)
- **Secondary Groups:** User can belong to multiple groups
- **System Groups:** UID < 1000 (e.g., www-data, adm, docker)
- **User Groups:** UID >= 1000

---

## Creating Users and Groups

### Create a Group First

```bash
# Basic group creation
sudo groupadd devops

# Group with GID (numeric ID)
sudo groupadd -g 2000 devops

# Group description (optional)
sudo groupadd -g 2000 -c "DevOps Engineers Group" devops

# Verify group
getent group devops
# Output: devops:x:2000:
#        - x = GID placeholder
#        - 2000 = GID
#        - empty = no members yet
```

### Create a User

```bash
# Basic user creation
sudo adduser devops
# Creates:
# - Home directory at /home/devops
# - Default shell (/bin/bash)
# - Primary group (devops)
# - User ID (usually starts at 1000)

# User with custom settings
sudo adduser devops \
    --shell /bin/zsh \
    --home /home/devops \
    --gid devops \
    --groups www-data

# View created user
id devops
# Output: uid=1001(devops) gid=1001(devops) groups=1001(devops),1002(www-data)

getent passwd devops
# Output: devops:x:1001:1001::/home/devops:/bin/bash
```

### User Creation Options

| Option | Description |
|--------|-----|
| `--gid` | Primary group ID (or name) |
| `--groups` | Secondary groups (comma-separated) |
| `--shell` | Default shell |
| `--home` | Custom home directory |
| `--gecos` | Full name field |
| `--no-create-home` | Don't create home directory |
| `--disabled-password` | Don't create password |

---

## Adding Users to Groups

### Add User to Secondary Groups

```bash
# Add user to existing group
sudo usermod -aG www-data devops
sudo usermod -aG adm devops
sudo usermod -aG sudo devops   # If sudo group exists

# View user groups
id devops
# Output: uid=1001(devops) gid=1001(devops) groups=1001(devops),1002(www-data),1003(adm),1011(sudo)
```

### Multiple Secondary Groups

```bash
# Add to multiple groups at once
sudo usermod -aG www-data,adm,sudo devops

# Add user to docker group (allows running docker without sudo)
sudo usermod -aG docker devops
```

---

## Managing User Accounts

### Change User Password

```bash
# Change password for another user
sudo passwd devops
# This prompts for new password
# Lockout after too many failures (configurable)

# Set specific password (not recommended)
echo "devops:newpassword" | sudo chpasswd

# Change root password
sudo passwd root

# Verify password change
su - devops
```

### Change User Shell

```bash
# Change to zsh
sudo usermod -s /bin/zsh devops

# Change to bash
sudo usermod -s /bin/bash devops

# Change to shellread-only
sudo usermod -s /bin/false devops   # No shell access
sudo usermod -s /usr/sbin/nologin devops

# List available shells
cat /etc/shells
```

### Modify User Settings

```bash
# Change username
sudo usermod -l newusername devops

# Change home directory
sudo usermod -d /home/newhome devops
sudo chown newusername:newgroup /home/newhome

# Lock account (disable login)
sudo usermod -L devops             # Adds * to password field
sudo passwd -l devops              # Alternative

# Unlock account
sudo usermod -U devops
sudo passwd -u devops

# View locked accounts
grep -E "^*|^!" /etc/shadow
```

### Delete Users

```bash
# Delete user (keep home directory)
sudo userdel devops

# Delete user AND home directory
sudo userdel -r devops            # Recommended
sudo userdel -f devops            # Force if user doesn't exist

# Force delete even if user is logged in
sudo userdel -f devops

# Delete user and groups
sudo groupdel devops              # Remove group first if needed
sudo userdel -r devops
```

---

## Copying from Existing User

```bash
# Copy user account (advanced)
cp -f /etc/passwd /home/username/etc/passwd

# Modify user ID and group for new user
sed -e 's/1001/1002/g' -e 's/devops/newuser/g' /etc/passwd > /etc/passwd.new
mv /etc/passwd.new /etc/passwd
```

---

## User Account Management Checklist

- [ ] Create groups before creating users
- [ ] Use `adduser` not `useradd` (more user-friendly)
- [ ] Add users to appropriate groups (`sudo`, `docker`, `www-data`)
- [ ] Set strong passwords or use SSH keys
- [ ] Lock unused accounts
- [ ] Regularly audit user accounts
- [ ] Remove unnecessary users

---

## Common DevOps User Scenarios

### Scenario 1: Web Application User

```bash
# Create web app user
sudo groupadd www-data
sudo adduser webapp

# Add user to www-data group
sudo usermod -aG www-data webapp

# Create app directory with proper ownership
sudo mkdir -p /var/www/myapp
sudo chown webapp:www-data /var/www/myapp
sudo chmod -R 755 /var/www/myapp

# Web app can read/write logs
sudo touch /var/log/myapp.log
sudo chown webapp:www-data /var/log/myapp.log
```

### Scenario 2: Docker User

```bash
# Add user to docker group
sudo groupadd docker
sudo usermod -aG docker $USER

# Log out and back in for changes to take effect

# Verify
groups $USER
# Should include docker
```

### Scenario 3: Database User

```bash
# Create database user
sudo adduser dbadmin

# Add to sudo and docker groups
sudo usermod -aG sudo,dbadmin,adm dbadmin

# Create database directories
sudo mkdir -p /var/lib/mysql
sudo chown dbadmin:dbadmin /var/lib/mysql
```

---

## Notes

```
Date: _____________

Notes:

```

---

*Module 1 - Part 2*
