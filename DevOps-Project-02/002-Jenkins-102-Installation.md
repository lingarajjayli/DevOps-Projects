# 002 - Jenkins Installation and Setup

**Module 3 - Part 2**  
**Topic:** Installing and configuring Jenkins on AWS EC2

---

## Prerequisites

### Required Software

- **Java JDK 11+** (Jenkins requires Java)
- **Git** (for source code management)
- **Docker** (optional, for container builds)
- **Maven** (for Java projects)
- **AWS CLI** (for AWS integration)

### AWS EC2 Setup

```bash
# 1. Launch Ubuntu 22.04 EC2 instance
# Use t3.medium or larger for Jenkins

# 2. Configure Security Group
# Allow: SSH (22), Jenkins (8080), HTTP (80)

# 3. Connect to instance
ssh -i your-key.pem ec2-user@<public-ip>
```

---

## Jenkins Installation

### Step 1: Install Java

```bash
# Update package list
sudo apt update

# Install Java JDK 11
sudo apt install -y openjdk-11-jdk

# Verify Java installation
java -version

# Check Java home
echo $JAVA_HOME
readlink -f $(dirname $(readlink -f $(which java)))
```

### Step 2: Install Jenkins

```bash
# Install wget, curl, and other dependencies
sudo apt install -y wget curl

# Install Jenkins
wget -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo tee \
  /usr/share/keyrings/jenkins-keyring.asc > /dev/null

echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian-stable binary/ | \
  sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null

sudo apt update
sudo apt install -y jenkins

# Start Jenkins
sudo systemctl start jenkins

# Enable auto-start
sudo systemctl enable jenkins
```

### Step 3: Configure Jenkins

```bash
# View default admin password
sudo cat /var/lib/jenkins/secrets/initialAdminPassword

# Access Jenkins in browser:
# http://<instance-ip>:8080

# Copy password from EC2 instance:
cat /var/lib/jenkins/secrets/initialAdminPassword
```

### Step 4: Install Jenkins Plugins

```bash
# Recommended plugins for CI/CD
# Install via Jenkins UI: Manage Jenkins → Plugins

# Must-have plugins:
# - Maven Integration Plugin
# - Docker Plugin
# - AWS Credentials Plugin
# - Amazon EC2 Plugin
# - Git Plugin
# - Pipeline: GitHub Advanced Button
# - Pipeline Utility Steps
```

---

## Jenkins Configuration

### Configure System

```bash
# Access: Manage Jenkins → System
# Configure:
# - Jenkins URL: http://<ip>:8080
# - Admin Email: admin@example.com

# Configure global tools:
# - Maven: Install from Maven repository
# - Java: JDK 11 installed automatically
```

### Configure Git

```bash
# Access: Manage Jenkins → Global Tool Configuration
# Git:
# - Name: git
# - Installer: Install automatically

# SSH Key for Git (optional):
# Generate SSH key
ssh-keygen -t ed25519

# Add to Jenkins:
# Access: Manage Jenkins → Credentials
# Add SSH username/private key
```

---

## AWS Integration

### Install AWS CLI

```bash
# Install AWS CLI
sudo apt install -y awscli

# Configure AWS credentials
aws configure
# - AWS Access Key ID
# - AWS Secret Access Key
# - Default region (us-east-1)
# - Output format (json)
```

### Configure AWS Credentials in Jenkins

```bash
# Access: Manage Jenkins → Credentials
# System → Global credentials (unrestricted)
# Add AWS Credentials:
# - ID: aws-credentials
# - Kind: AWS Credentials
# - Username: Access Key ID
# - Password: Secret Access Key
```

---

## Jenkins Docker Installation (Optional)

### Docker Installation

```bash
# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Add user to docker group
sudo usermod -aG docker ec2-user

# Start Docker
sudo systemctl start docker
sudo systemctl enable docker

# Test
docker run hello-world
```

### Jenkins with Docker Plugin

```bash
# Install Docker plugin in Jenkins UI
# Manage Jenkins → Plugins → Available
# Search: Docker → Install

# Configure Docker in Jenkins
# Manage Jenkins → Tools → Docker installation
# Add: Docker endpoint (http://localhost:2375)
```

---

## Notes

```
Date: _____________

Notes:

```

---

*Module 3 - Part 2*
