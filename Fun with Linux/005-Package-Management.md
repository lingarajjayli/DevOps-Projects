# 005 - Package Management

**Module 1 - Part 5**  
**Topic:** Installing, managing software packages on Linux

---

## Package Managers Overview

### Linux Distributions and Package Managers

| Distribution | Package Manager | Command Prefix |
|--------------|--- |---|
| **Debian** | apt | `sudo apt` |
| **Ubuntu** | apt | `sudo apt` |
| **Linux Mint** | apt | `sudo apt` |
| **RHEL/CentOS 7** | yum | `sudo yum` |
| **RHEL/CentOS 8+/Fedora** | dnf | `sudo dnf` |
| **Arch Linux** | pacman | `sudo pacman` |
| **openSUSE** | zypper | `sudo zypper` |

### Package Repository Structure

```
/var/cache/apt/archives/        # Deb packages
/var/cache/yum/packages/        # RPM packages
/var/cache/dnf/packages/        # DNF packages
```

---

## Debian/Ubuntu (apt) Commands

### Update Package Lists

```bash
# Update package lists
sudo apt update              # Fetch latest package lists from sources

# Upgrade all packages
sudo apt upgrade             # Upgrade to newer versions
sudo apt dist-upgrade        # Handle dependencies
sudo apt full-upgrade        # Remove packages if needed

# Upgrade automatically
sudo apt autoremove          # Remove unused dependencies
```

### Install Packages

```bash
# Install single package
sudo apt install nginx        # Install nginx

# Install with automatic confirmation
sudo apt install -y nginx

# Install multiple packages
sudo apt install nginx curl wget

# Install package from file
sudo apt install ./nginx.deb

# Install with download only (simulate)
sudo apt install --download-only nginx

# Show package info
apt show nginx
apt policy nginx              # Show versions
```

### Remove Packages

```bash
# Remove package only
sudo apt remove nginx

# Remove package + config files
sudo apt purge nginx

# Remove package + unused dependencies
sudo apt remove nginx
sudo apt autoremove

# Clean package cache
sudo apt clean               # Remove all cached packages
sudo apt autoclean           # Remove outdated packages
```

### Query Packages

```bash
# Search for packages
apt search keyword
apt cache search keyword

# List installed packages
dpkg -l                       # List all packages
dpkg -l | grep nginx         # Filter output
apt list --installed          # Human readable
apt list --upgradable         # Upgradable packages

# Check package dependencies
apt depends nginx
dpkg -S filename             # Find which package owns a file
```

### Advanced apt Operations

```bash
# Download package without installing
apt download nginx           # Downloads to ./packages/

# Install from local file
sudo apt install ./package.deb

# Configure packages
sudo apt install <package> --configure

# Upgrade specific package
sudo apt upgrade nginx

# Show upgrade info
apt upgrade --simulate       # Dry run
```

---

## RHEL/CentOS/Fedora (dnf) Commands

### Update Packages

```bash
# List available updates
sudo dnf updateinfo list-updates

# Update all packages
sudo dnf update

# Upgrade with dependency resolution
sudo dnf distro-sync

# Dry run
sudo dnf upgrade --downloadonly --downloadroot=/tmp/updates
```

### Install Packages

```bash
# Install package
sudo dnf install nginx

# Install from file
sudo dnf install ./nginx.rpm

# Install with dependencies
sudo dnf install nginx httpd

# Show package info
dnf info nginx
dnf repolist                  # List repositories
```

### Remove Packages

```bash
# Remove package
sudo dnf remove nginx

# Remove with dependencies
sudo dnf remove nginx --alldeps
```

### Query Packages

```bash
# Search packages
dnf search keyword

# List installed packages
dnf list installed
dnf list updates

# Check dependencies
dnf repoquery -R nginx
```

---

## Package Management Best Practices

### Create Package Lists

```bash
# Generate package list (audit/restore)
dpkg --list > /backup/packages-before.txt
rpm -qa > /backup/rpm-packages-before.txt

# Revert to previous state
dpkg --list --force-depends < /backup/packages-before.txt
```

### Pinning Package Versions

```bash
# Create /etc/apt/preferences.d/
sudo mkdir -p /etc/apt/preferences.d
sudo nano /etc/apt/preferences.d/pin-nginx

# Content:
Package: nginx
Pin: release a=.*
Pin-Priority: 1000  # Default
Pin-Priority: 900   # From trusted repos
Pin-Priority: 500   # From untrusted repos
```

---

## Archive Management

### Tar Archives

```bash
# Create archive
tar -czvf archive.tar.gz folder

# Create without compression
tar -cf archive.tar folder

# Create with bzip2 (better compression)
tar -cjvf archive.tar.bz2 folder

# Create with xz (best compression)
tar -Jcf archive.tar.xz folder

# Extract archive
tar -xvzf archive.tar.gz
tar -xvf archive.tar

# Extract with options
tar -xvzf archive.tar.gz -C /destination/path

# List archive contents
tar -tzvf archive.tar.gz

# Extract specific files
tar -xvzf archive.tar.gz -C /path file1 file2

# Append to archive
tar -rzvf archive.tar.gz -C /path folder2

# Remove empty directories
tar -xvzf archive.tar.gz --strip-components=1
```

### Gzip/Zcat

```bash
# Compress file
gzip file.txt                    # Creates file.txt.gz
gzip -k file.txt                 # Keep original

# Decompress
gunzip file.txt.gz               # Removes .gz
gunzip -k file.txt.gz            # Keep original

# View without decompressing
zcat file.txt.gz
zgrep "pattern" file.txt.gz      # Search in compressed file
zmore file.txt.gz                # Paged view

# Compress multiple files
gzip *.log

# Use zsh/gzip in pipeline
command | gzip > output.txt.gz
```

### Zip/Unzip

```bash
# Create zip archive
zip -r archive.zip folder
zip -j archive.zip file1 file2   # Flatten structure

# Extract zip
unzip archive.zip
unzip archive.zip -d destination  # Extract to directory

# List zip contents
unzip -l archive.zip
zipinfo archive.zip              # Detailed info

# Create password-protected zip
zip -e archive.zip folder
# Enter password when prompted

# View password-protected zip contents
zipinfo archive.zip
```

---

## Package Security

### Verify Package Integrity

```bash
# Check GPG signatures
apt verify package
dpkg -V /usr/bin/package        # Check installed files

# Verify RPM packages
rpm -K package.rpm              # Check signature
rpm -V package                  # Verify installed package
```

### Update Package Lists Regularly

```bash
# Schedule apt update via cron
echo "0 2 * * * root apt update" | sudo tee /etc/cron.d/apt-update
```

---

## Package Manager Checklist

- [ ] Use `apt update` before installing packages
- [ ] Review package info before installing
- [ ] Use `--simulate` before upgrading production
- [ ] Regularly clean package cache (`apt clean`)
- [ ] Use package lists for audits
- [ ] Verify GPG signatures for RPM packages

---

## Practical Exercises

### Exercise 1: Install Monitoring Stack

```bash
# 1. Update packages
sudo apt update

# 2. Install Prometheus components
sudo apt install prometheus node-exporter blackbox-exporter

# 3. Install Grafana
wget -q -O - https://packagecloud.io/garden/cadvisor/gpgkey | sudo apt-key add -
echo "deb https://packagecloud.io/garden/cadvisor/debian/$(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/cadvisor.list
sudo apt update
sudo apt install grafana
```

---

## Notes

```
Date: _____________

Notes:

```

---

*Module 1 - Part 5*
