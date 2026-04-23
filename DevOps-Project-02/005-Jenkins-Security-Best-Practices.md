# 005 - Jenkins Security Best Practices

**Module 3 - Part 5**  
**Topic:** Securing Jenkins installations

---

## Security Checklist

### 1. Disable Default Security Realm

```groovy
// Manage Jenkins → Security
// Remove: "Use Jenkins' own user database"
// Use: "LDAP/Active Directory" or "Jenkins"

// Or in pipeline:
withCredentials([usernamePassword(
    usernameCredentials('admin'),
    passwordCredentials('password'),
    passwordVariable='JENKINS_PASSWORD'
)
]) {
    // Use credentials
}
```

### 2. Configure Role-Based Access Control (RBAC)

```groovy
// Manage Jenkins → Roles
// Create roles:
// - admin: Full access
// - deploy: Deploy only
// - build: Build only
// - read: View only
```

### 3. Restrict Plugin Installation

```groovy
// Disable: "Jenkins administrators can install plugins"
// Enable: "Restrict plugin installation to specific admins"
```

### 4. Configure Token-based Authentication

```bash
# Enable token triggers
# Manage Jenkins → Credentials → Token
# Add tokens: build-token, deploy-token

// Use in pipeline:
withCredentials([string(credentials: 'build-token')]) {
    sh 'build-artifact.sh'
}
```

---

## Credential Management

### Jenkins Credentials Plugin

```groovy
// Store sensitive data securely
pipeline {
    agent any
    
    credentials([
        usernameCredentials('git-username'),
        passwordCredentials('git-password'),
        string(credentials: 'ecr-password')
    ]) {
        stages {
            stage('Build') {
                steps {
                    // Use credentials
                }
            }
        }
    }
}
```

### External Secret Management

```groovy
// Use HashiCorp Vault
withVault([
    engineURL: 'http://vault.internal:8200',
    method: 'token',
    token: vault('app-deploy-token')
]) {
    sh 'deploy.sh'
}
```

---

## Pipeline Security

### Validate Pipeline Scripts

```groovy
// Scan pipeline for security issues
pipeline {
    agent any
    
    options {
        timeout(time: 1, unit: 'HOURS')
        disableConcurrentBuilds()
    }

    stages {
        stage('Security Scan') {
            steps {
                sh '''
                    # Run dependency check
                    dependency-check --scan target/*.jar
                    
                    # Run trivy
                    trivy fs --security-checks vuln,config \
                        target/myapp.jar
                    
                    # Fail if vulnerabilities found
                    exit $?
                    '''
                }
            }
        }
    }
}
```

---

## Network Security

### Restrict Jenkins Access

```bash
# EC2 Security Group
# Only allow:
# - SSH from trusted IPs: 192.168.1.0/24
# - Jenkins HTTP: 0.0.0.0/0 (HTTPS only)
# - Jenkins API: Trusted IPs only
```

### Use SSL/TLS

```groovy
// Configure HTTPS for Jenkins
// Manage Jenkins → Configure System
// Generate self-signed certificate or use Let's Encrypt
```

---

## Notes

```
Date: _____________

Notes:

```

---

*Module 3 - Part 5*
