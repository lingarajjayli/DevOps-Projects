# 007 - Jenkins GitHub Integration

**Module 3 - Part 7**  
**Topic:** Setting up CI/CD with GitHub webhooks

---

## GitHub Account Setup

### 1. Create Repository

```bash
# Create repository on GitHub
git remote add origin https://github.com/username/repo.git
git push -u origin main
```

### 2. Create Personal Access Token

```bash
# GitHub → Settings → Developer Settings → Personal Access Tokens
# Generate new token with scopes:
# - repo: Full control of private repositories
# - workflows: Read/write access to actions
# - read:repo_hook: Read and hooks
```

### 3. Configure Jenkins with GitHub

```groovy
// Jenkins UI: Manage Jenkins → Credentials
// Add:
// - ID: github-token
// - Type: Secret text
// - Value: PAT token

// Or: Add SSH key for Git operations
```

---

## Jenkins GitHub Plugin

### Install Plugin

```bash
# Jenkins UI: Manage Jenkins → Plugins
# Search: "GitHub"
# Install:
# - GitHub plugin
# - GitHub API integration
```

### Configure GitHub Plugin

```groovy
// Manage Jenkins → Tools
// GitHub:
// - Name: github
// - Server: GitHub Enterprise / GitHub.com
// - URL: https://api.github.com/
```

---

## GitHub Webhook Setup

### Create Webhook in GitHub

```bash
# GitHub → Repository → Settings → Webhooks
# Add webhook:
# - Payload URL: http://jenkins:8080/github-webhook
# - Content type: application/json
# - Secret: your-secret-key
# - Events:
#   - Pull requests
#   - Pushes
#   - Issues
#   - Deployments
```

### Jenkins Webhook Receiver

```groovy
// Jenkinsfile
pipeline {
    agent any
    
    triggers {
        webhook([
            name: 'github',
            payload: '.*',
            content: 'application/json'
        ])
        
        git {
            branches {
                branch "main"
            }
            remote {
                name: 'origin'
                url: 'https://github.com/username/repo.git'
            }
            credentialsId: 'github'
        }
    }
    
    stages {
        stage('Build') {
            steps {
                sh 'mvn clean package'
            }
        }
    }
}
```

---

## GitHub Actions Alternative

### Using GitHub Actions

```yaml
# .github/workflows/deploy.yml
name: Deploy to AWS

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Setup Java
        uses: actions/setup-java@v3
        with:
          java-version: '11'
          distribution: 'adopt'
      
      - name: Build with Maven
        run: mvn clean install
      
      - name: Deploy to ECS
        run: |
          aws ecr get-login-password | \
            docker login --username AWS --password-stdin \
            123456789012.dkr.ecr.us-east-1.amazonaws.com
      
      - name: Build and push Docker image
        run: |
          docker build -t myapp:${{ github.sha }} .
          docker push myapp:${{ github.sha }}
      
      - name: Deploy to ECS
        run: |
          aws ecs update-service \
            --cluster my-cluster \
            --service myapp \
            --force-new-deployment
```

---

## Deployment Approaches

### 1. Manual Deploy

```groovy
pipeline {
    agent any
    
    stages {
        stage('Deploy to ECS') {
            steps {
                input message: 'Deploy to production?', \
                       ok: 'Deploy', \
                       submit: [
                           class: 'Deploy',
                           script: {
                               sh 'deploy.sh'
                           }
                       ]
            }
        }
    }
}
```

### 2. Blue-Green Deploy

```groovy
pipeline {
    agent any
    
    stages {
        stage('Deploy Blue') {
            steps {
                sh '''
                    aws ecs update-service \
                        --cluster my-cluster \
                        --service myapp \
                        --task-definition my-task-def-blue \
                        --force-new-deployment
                    '''
            }
        }
        
        stage('Verify Health') {
            steps {
                sh 'healthcheck.sh'
            }
        }
        
        stage('Switch Traffic') {
            steps {
                sh '''
                    # Update load balancer to route to blue
                    aws ec2 modify-route-table-association \
                        --route-table-id rt-xxxx \
                        --association-route-id route-id
                    '''
            }
        }
    }
}
```

---

## Rollback Strategy

```groovy
pipeline {
    agent any
    
    stages {
        stage('Build') {
            steps {
                sh 'mvn clean package'
            }
        }
        
        stage('Deploy') {
            steps {
                sh 'deploy.sh'
            }
        }
        
        stage('Verify') {
            steps {
                sh 'verify.sh'
            }
        }
        
        stage('Rollback (on failure)') {
            when {
                expression {
                    return currentBuild.result == 'FAILURE'
                }
            }
            steps {
                sh '''
                    aws ecs update-service \
                        --cluster my-cluster \
                        --service myapp \
                        --task-definition my-task-def-prev \
                        --force-new-deployment
                    '''
            }
        }
    }
}
```

---

## Notes

```
Date: _____________

Notes:

```

---

*Module 3 - Part 7*
