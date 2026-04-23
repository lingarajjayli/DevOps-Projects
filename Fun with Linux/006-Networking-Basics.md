# 006 - Networking Basics

**Module 1 - Part 6**  
**Topic:** Network configuration and diagnostics for DevOps

---

## Network Configuration

### Viewing Network Information

| Command | Description |
|---------|-------|
| `ip addr show` | View IP addresses and interfaces |
| `ifconfig` | Alternative to `ip addr` |
| `hostname` | View system hostname |
| `hostname -d` | Domain name |
| `ip route show` | View routing table |
| `cat /etc/resolv.conf` | DNS configuration |

```bash
# View all network interfaces
ip addr show
ip -br addr show          # Compact format
ifconfig -a              # Alternative (older)

# Network interfaces
ip link show
ip link set dev eth0 up
ip link set dev eth0 down
```

### DNS Configuration

```bash
# View DNS settings
cat /etc/resolv.conf
# Example:
# nameserver 8.8.8.8
# nameserver 8.8.4.4

# Test DNS resolution
ping -c 4 google.com
nslookup google.com
dig google.com            # More detailed
host google.com           # Simple DNS lookup
```

---

## Network Diagnostics

### Connectivity Tests

```bash
# Ping test
ping -c 4 google.com      # Ping 4 times
ping -i 5 google.com      # Wait 5 seconds between packets

# Traceroute (trace path)
traceroute google.com
tracepath google.com      # Alternative (no privilege required)

# MTR (combined ping+traceroute)
mtr google.com
mtr -r google.com         # Reverse (to host)
mtr -c 100 google.com     # 100 probes
```

### Port Checking

```bash
# TCP connect test with netcat
nc -zv google.com 443
nc -zv -w 2 host port     # Timeout after 2 seconds

# Telnet (legacy)
telnet google.com 80

# SSH port test
ssh -p 22 user@host
ssh -v user@host          # Verbose mode

# View listening ports
ss -tlnp
netstat -tlnp             # Alternative

# Check port status
sudo lsof -i :22          # Who's using port 22?
sudo lsof -i :80
```

---

## SSH Setup

### Generate SSH Keys

```bash
# Generate new SSH key
ssh-keygen -t ed25519     # Modern default (recommended)
ssh-keygen -t rsa         # Fallback (4096-bit)
ssh-keygen -t ecdsa       # Less common

# View generated keys
cat ~/.ssh/id_ed25519.pub
cat ~/.ssh/id_rsa.pub     # For RSA

# View private key
cat ~/.ssh/id_ed25519
ls -la ~/.ssh/
```

### Copy SSH Public Key

```bash
# View public key
cat ~/.ssh/id_ed25519.pub

# Copy to remote host
ssh-copy-id user@host
# Or manually:
cat ~/.ssh/id_ed25519.pub | ssh user@host "cat >> ~/.ssh/authorized_keys"
```

### SSH Configuration

```bash
# Add SSH config (edit ~/.ssh/config)
# Host myserver
#     HostName server.example.com
#     User username
#     Port 2222
#     IdentityFile ~/.ssh/id_ed25519
#     StrictHostKeyChecking no

# Add current host
ssh-add                     # Add key to agent
ssh-add -l                  # List loaded keys
ssh-add ~/.ssh/id_ed25519  # Add specific key

# Remove key
ssh-add -D id_ed25519
```

---

## Network Tools

### ARP Table

```bash
# View ARP table
ip neigh show
arp -a

# Clear ARP table
ip neigh flush all
```

### ICMP/Network Stats

```bash
# View network statistics
cat /proc/net/dev
ip -s link

# Test network speed (download)
# Requires tools like speedtest-cli or wget

# Test network speed (upload)
# Requires scp or rsync for testing
```

### Nmap Network Scan (if installed)

```bash
# Basic host scan
nmap host

# Port scan
nmap -p- host             # Scan all 65535 ports
nmap -p 22,80,443 host    # Specific ports

# Service detection
nmap -sV host             # Show service versions

# OS detection
nmap -O host              # Try to detect OS
```

---

## Firewall Basics

### UFW (Ubuntu)

```bash
# Enable firewall
sudo ufw enable
sudo ufw --force enable   # If already enabled

# Disable firewall
sudo ufw disable
sudo ufw --force disable

# View status
sudo ufw status
sudo ufw status verbose

# Allow/Deny specific port
sudo ufw allow 80/tcp     # Allow HTTP
sudo ufw allow 443/tcp    # Allow HTTPS
sudo ufw allow 22/tcp     # Allow SSH
sudo ufw deny 3306/tcp    # Deny MySQL

# Allow from specific network
sudo ufw allow from 192.168.1.0/24 to any port 22 proto tcp

# Log settings
sudo ufw logging on
sudo ufw logging off
sudo ufw status verbose    # Shows logging status

# Delete rule
sudo ufw delete allow 80/tcp
# Or:
sudo ufw delete deny 3306/tcp

# Reset
sudo ufw delete allow 22/tcp
sudo ufw delete allow 80/tcp
sudo ufw delete allow 443/tcp
sudo ufw enable           # Reset to default
```

### iptables Commands

```bash
# View rules
sudo iptables -L -n
sudo iptables -L -n -v    # Show packet/byte counters

# Add rule
sudo iptables -A INPUT -p tcp --dport 80 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 443 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 22 -j ACCEPT

# Drop rule
sudo iptables -A INPUT -p tcp --dport 3306 -j DROP

# Delete rule
sudo iptables -D INPUT rule_number

# Flush rules
sudo iptables -F          # Flush all chains
sudo iptables -X          # Delete user chains

# Save rules
sudo iptables-save        # View saved rules
sudo iptables-save > /etc/iptables/rules.v4
```

---

## Network Configuration Files

### Important Network Files

| File | Purpose |
|------|-----|
| `/etc/hostname` | System hostname |
| `/etc/hosts` | Local hostname mappings |
| `/etc/resolv.conf` | DNS nameservers |
| `/etc/network/interfaces` | Network interfaces (legacy) |
| `/etc/netplan/*.yaml` | Network config (Ubuntu 17+) |
| `/etc/ssh/sshd_config` | SSH server config |
| `/etc/sysctl.conf` | Kernel parameters |

### Edit Hosts File

```bash
# View hosts file
cat /etc/hosts

# Edit hosts file
sudo nano /etc/hosts

# Add custom mapping
192.168.1.100  myserver.local
127.0.0.1      localhost
```

### Network Configuration (Ubuntu Netplan)

```bash
# View netplan config
cat /etc/netplan/00-netcfg.yaml

# Edit config
sudo nano /etc/netplan/00-netcfg.yaml

# Example config:
# network:
#   version: 2
#   ethernets:
#     eth0:
#       dhcp4: true
#       # Or static:
#       addresses:
#       - 192.168.1.100/24
#       routes:
#       - to: default
#         via: 192.168.1.1
#       nameservers:
#         addresses:
#         - 8.8.8.8
#         - 8.8.4.8

# Apply config
sudo netplan try          # Test config
sudo netplan apply        # Apply permanently
```

---

## Networking Checklist

- [ ] Can view network interfaces and IP addresses
- [ ] Can test connectivity with ping/traceroute
- [ ] Can check port status with ss/netcat
- [ ] Can generate and manage SSH keys
- [ ] Can configure basic firewall rules
- [ ] Understand DNS resolution

---

## Practical Exercises

### Exercise 1: Configure Server Access

```bash
# 1. Set static IP
sudo nano /etc/netplan/00-netcfg.yaml
# (Edit as per example above)
sudo netplan apply

# 2. Configure DNS
echo "nameserver 8.8.8.8" | sudo tee /etc/resolv.conf

# 3. Test connectivity
ping -c 4 google.com
nslookup google.com

# 4. Configure SSH
ssh-keygen -t ed25519
# Copy public key to remote server
ssh-copy-id user@server
```

---

## Notes

```
Date: _____________

Notes:

```

---

*Module 1 - Part 6*
