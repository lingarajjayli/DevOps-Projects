# 006 - Docker Integration in Jenkins

**Module 3 - Part 6**  
**Topic:** Building and testing with Docker in Jenkins pipelines

---

## Docker Pipeline Plugin

### Install Plugin

```bash
# Jenkins UI: Manage Jenkins → Plugins → Available
# Search: Docker
# Install: Docker

# Steps:
# 1. Manage Jenkins → Plugins
# 2. Available Plugins tab
# 3. Search: "Docker"
# 4. Click "Install"
```

---

## Dockerfile-based Builds

### Basic Docker Pipeline

```groovy
pipeline {
    agent none
    
    options {
        timeout(time: 1, unit: 'HOURS')
    }
    
    environment {
        DOCKER_IMAGE = 'myapp'
        DOCKER_TAG = 'latest'
        ECR_REPO = '123456789012.dkr.ecr.us-east-1.amazonaws.com/myapp'
    }
    
    stages {
        stage('Check out code') {
            steps {
                checkout scm
            }
        }
        
        stage('Build Image') {
            steps {
                dockerBuild 'Dockerfile'
                sh "docker tag ${DOCKER_IMAGE}:${DOCKER_TAG} ${ECR_REPO}:${DOCKER_TAG}"
                sh "docker push ${ECR_REPO}:${DOCKER_TAG}"
            }
        }
        
        stage('Run Tests') {
            steps {
                docker {
                    image 'myapp:${DOCKER_TAG}'
                    args '--test'
                }
            }
        }
        
        stage('Deploy') {
            steps {
                sh '''
                    aws ecs update-service \
                        --cluster my-cluster \
                        --service myapp \
                        --image ${ECR_REPO}:${DOCKER_TAG}
                    '''
                }
            }
        }
    }
    
    post {
        success {
            echo 'Pipeline succeeded!'
        }
        failure {
            echo 'Pipeline failed!'
        }
    }
}
```

---

## Multi-stage Dockerfile Support

### Dockerfile for Pipeline

```dockerfile
# Dockerfile for multi-stage build
FROM maven:3.8-openjdk-11 AS builder
WORKDIR /app
COPY pom.xml .
RUN mvn dependency:go-offline
COPY . .
RUN mvn clean package -DskipTests

FROM openjdk:11-slim
WORKDIR /app
COPY --from=builder /app/target/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
```

### Pipeline with Multi-stage Build

```groovy
pipeline {
    agent {
        docker {
            image 'maven:3.8-openjdk-11'
        }
    }
    
    stages {
        stage('Build') {
            steps {
                sh '''
                    mvn clean package
                    '''
                }
            }
        }
        
        stage('Docker Build') {
            steps {
                sh '''
                    docker build -t myapp:${BUILD_NUMBER} .
                    '''
                }
            }
        }
        
        stage('Push to ECR') {
            steps {
                sh '''
                    aws ecr get-login-password | \
                        docker login --username AWS --password-stdin \
                        123456789012.dkr.ecr.us-east-1.amazonaws.com
                    
                    docker tag myapp:${BUILD_NUMBER} \
                        123456789012.dkr.ecr.us-east-1.amazonaws.com/myapp:${BUILD_NUMBER}
                    docker push 123456789012.dkr.ecr.us-east-1.amazonaws.com/myapp:${BUILD_NUMBER}
                    '''
                }
            }
        }
    }
}
```

---

## Docker Compose Support

### Deploy with Docker Compose

```groovy
pipeline {
    agent {
        docker {
            image 'docker:20.10-dind'
        }
    }
    
    stages {
        stage('Build') {
            steps {
                sh '''
                    docker-compose build
                    '''
                }
            }
        }
        
        stage('Run') {
            steps {
                sh '''
                    docker-compose up -d
                    '''
                }
            }
        }
        
        stage('Test') {
            steps {
                sh '''
                    docker-compose logs -f
                    '''
                }
            }
        }
    }
}
```

---

## Docker Registry Integration

### ECR Authentication

```groovy
pipeline {
    agent any
    
    environment {
        ECR_REGISTRY = '123456789012.dkr.ecr.us-east-1.amazonaws.com'
        ECR_REPOSITORY = 'myapp'
    }
    
    stages {
        stage('Get ECR Auth') {
            steps {
                sh '''
                    AWS_AUTH=$(aws ecr get-login-password --region us-east-1)
                    echo "AWS_AUTH=${AWS_AUTH}" | docker login --username AWS --password-stdin \
                        ${ECR_REGISTRY}
                    '''
                }
            }
        }
        
        stage('Push Image') {
            steps {
                sh '''
                    docker tag myapp:${DOCKER_TAG} \
                        ${ECR_REGISTRY}/${ECR_REPOSITORY}:${DOCKER_TAG}
                    docker push ${ECR_REGISTRY}/${ECR_REPOSITORY}:${DOCKER_TAG}
                    '''
                }
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

*Module 3 - Part 6*
