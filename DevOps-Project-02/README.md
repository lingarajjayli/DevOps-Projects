# DevOps-Project-02: Jenkins CI/CD Fundamentals

**Module 3: Jenkins CI/CD for DevOps**

---

## Project Overview

This project teaches Jenkins CI/CD automation with:
- Maven builds
- Docker integration
- AWS integration (ECR, ECS)
- GitHub integration
- Deployment strategies

---

## Files Structure

| File | Topic |
|------|-------|
| **001-Jenkins-101-Introduction.md** | CI/CD fundamentals, Maven basics |
| **002-Jenkins-102-Installation.md** | Jenkins installation and setup |
| **003-Jenkins-Pipeline-Configuration.md** | Pipeline syntax and stages |
| **004-Jenkins-AWS-Integration.md** | EC2, S3, ECS, Route53 deployment |
| **005-Jenkins-Security-Best-Practices.md** | Security configuration |
| **006-Jenkins-Docker-Integration.md** | Docker builds and deployment |
| **007-Jenkins-GitHub-Integration.md** | GitHub webhooks and actions |
| **008-Jenkins-Practical-Exercises.md** | Hands-on exercises |

---

## Learning Path

1. Start with **001-Jenkins-101-Introduction.md**
2. Follow along with installation guide
3. Configure pipelines
4. Build Docker images
5. Deploy to AWS services
6. Practice exercises

---

## Quick Start

```bash
# 1. Setup Jenkins on EC2
# See: 002-Jenkins-102-Installation.md

# 2. Configure Maven
# See: 001-Jenkins-101-Introduction.md

# 3. Build and deploy
# See: 006-Jenkins-Docker-Integration.md
```

---

## Exercise 1: First Pipeline

```groovy
// Jenkinsfile
pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                sh 'mvn clean package'
            }
        }
        stage('Test') {
            steps {
                sh 'mvn test'
            }
        }
    }
}
```

---

## Exercise 2: Docker Deployment

```groovy
pipeline {
    agent any

    stages {
        stage('Build Image') {
            steps {
                sh 'docker build -t myapp:latest .'
            }
        }
        stage('Push to ECR') {
            steps {
                sh '''
                    aws ecr get-login-password | \
                        docker login --username AWS --password-stdin \
                        123456789012.dkr.ecr.us-east-1.amazonaws.com
                    docker push myapp:latest
                    '''
            }
        }
    }
}
```

---

## Resources

- **Jenkins Docs:** https://www.jenkins.io/doc/
- **GitHub Actions:** https://docs.github.com/actions/
- **AWS ECS:** https://docs.aws.amazon.com/AmazonECS/latest/developerguide/
- **Maven:** https://maven.apache.org/

---

## Completion Criteria

Mark this project as complete when you can:
- ✅ Create Jenkins pipelines
- ✅ Build and test with Maven
- ✅ Push images to AWS ECR
- ✅ Deploy to AWS ECS
- ✅ Configure GitHub webhooks
- ✅ Implement rollback strategies

---

*Module 3 Created: 2026-04-23*
