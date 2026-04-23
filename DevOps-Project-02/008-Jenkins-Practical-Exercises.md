# 008 - Jenkins Practical Exercises

**Module 3 - Part 8**  
**Topic:** Hands-on Jenkins CI/CD exercises

---

## Exercise 1: Set Up Jenkins Server

**Goal:** Install and configure Jenkins on AWS EC2

**Time:** ~30 minutes

### Step 1: Launch EC2 Instance

```bash
# Launch Ubuntu 22.04 t3.medium
# Security groups: Allow SSH(22), HTTP(80)

# Connect to instance
ssh -i key.pem ec2-user@<public-ip>
```

### Step 2: Install Java

```bash
sudo apt update
sudo apt install -y openjdk-11-jdk

# Verify
java -version
```

### Step 3: Install Jenkins

```bash
wget -qO - https://packages.cloud.google.com/apt/doc-signed-key.gpg | sudo tee /etc/apt/keyrings/doc-signed-key.gpg > /dev/null
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2024.key | sudo tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt update
sudo apt install jenkins

# Start Jenkins
sudo systemctl start jenkins
sudo systemctl enable jenkins
```

### Step 4: Configure Jenkins

```bash
# Get admin password
sudo cat /var/lib/jenkins/secrets/initialAdminPassword

# Access: http://<ip>:8080
# Run installer
# Install plugins (Jenkins recommends doing so)
# Set admin password
```

---

## Exercise 2: Configure Maven Build

**Goal:** Create Maven-based pipeline

**Time:** ~20 minutes

### Step 1: Create Sample Maven Project

```bash
mkdir -p myapp/{src/main/java,src/test/java}
cd myapp

# Create pom.xml
cat > pom.xml << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0">
    <modelVersion>4.0.0</modelVersion>

    <groupId>com.example</groupId>
    <artifactId>myapp</artifactId>
    <version>1.0-SNAPSHOT</version>
    <packaging>jar</packaging>

    <dependencies>
        <dependency>
            <groupId>junit</groupId>
            <artifactId>junit</artifactId>
            <version>4.13.2</version>
            <scope>test</scope>
        </dependency>
    </dependencies>

    <build>
        <plugins>
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-surefire-plugin</artifactId>
                <version>2.22.2</version>
            </plugin>
        </plugins>
    </build>
</project>
EOF
```

### Step 2: Create Jenkins Pipeline

```groovy
// Create Jenkinsfile
pipeline {
    agent any

    stages {
        stage('Clean') {
            steps {
                sh 'mvn clean'
            }
        }
        stage('Compile') {
            steps {
                sh 'mvn compile'
            }
        }
        stage('Test') {
            steps {
                sh 'mvn test'
            }
        }
        stage('Package') {
            steps {
                sh 'mvn package'
            }
        }
    }
}
```

### Step 3: Create Freestyle Job

```groovy
# Jenkins UI: New Item
# Type: Freestyle project
# Add Build Steps:
# - Execute shell: mvn clean package
# - Post-build Actions:
#   - Publish JUnit test result
#   - Archive artifacts
```

---

## Exercise 3: Build Docker Image

**Goal:** Build and push Docker image to ECR

**Time:** ~25 minutes

### Step 1: Create Dockerfile

```bash
cat > Dockerfile << 'EOF'
FROM maven:3.8-openjdk-11 AS builder
WORKDIR /app
COPY pom.xml .
RUN mvn dependency:go-offline
COPY . .
RUN mvn clean package

FROM openjdk:11-slim
WORKDIR /app
COPY --from=builder /app/target/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
EOF
```

### Step 2: Build and Push to ECR

```bash
# Login to ECR
aws ecr get-login-password | \
  docker login --username AWS --password-stdin \
  123456789012.dkr.ecr.us-east-1.amazonaws.com

# Tag image
docker tag myapp:latest \
  123456789012.dkr.ecr.us-east-1.amazonaws.com/myapp:latest

# Push
docker push 123456789012.dkr.ecr.us-east-1.amazonaws.com/myapp:latest
```

### Step 3: Jenkins Pipeline for Docker

```groovy
pipeline {
    agent any

    environment {
        ECR_REPOSITORY = 'myapp'
        AWS_REGION = 'us-east-1'
    }

    stages {
        stage('Build Image') {
            steps {
                sh '''
                    docker build -t myapp:${BUILD_NUMBER} .
                    docker tag myapp:${BUILD_NUMBER} \
                        ${ECR_REPOSITORY}:${BUILD_NUMBER}
                    docker push ${ECR_REPOSITORY}:${BUILD_NUMBER}
                    '''
                }
            }
        }
        
        stage('Push to ECR') {
            steps {
                sh '''
                    aws ecr get-login-password | \
                        docker login --username AWS --password-stdin \
                        ${AWS_REGION}.dkr.ecr.${AWS_REGION}.amazonaws.com
                    
                    docker tag myapp:${BUILD_NUMBER} \
                        ${AWS_REGION}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPOSITORY}:${BUILD_NUMBER}
                    docker push ${AWS_REGION}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPOSITORY}:${BUILD_NUMBER}
                    '''
                }
            }
        }
    }
}
```

---

## Exercise 4: Deploy to ECS

**Goal:** Deploy container to AWS ECS

**Time:** ~30 minutes

### Step 1: Create ECS Cluster

```bash
# Create ECS cluster
aws ecs create-cluster --cluster-name my-cluster

# Create task definition
cat > task-definition.json << 'EOF'
{
  "family": "myapp-task",
  "networkMode": "awsvpc",
  "requiresCompatibilities": ["FARGATE"],
  "cpu": "256",
  "memory": "512",
  "containerDefinitions": [
    {
      "name": "web",
      "image": "123456789012.dkr.ecr.us-east-1.amazonaws.com/myapp:latest",
      "essential": true,
      "portMappings": [
        {
          "containerPort": 8080,
          "hostPort": 8080
        }
      ]
    }
  ]
}
EOF

# Register task definition
aws ecs register-task-definition --cli-input-json file://task-definition.json
```

### Step 2: Create ECS Service

```bash
# Create service
aws ecs create-service \
  --cluster my-cluster \
  --service-name myapp \
  --task-definition myapp-task \
  --desired-count 2 \
  --launch-type FARGATE \
  --network-configuration \
    'awsvpcConfiguration=subnets=sub-xxx,securityGroups=sg-xxx,assignPublicIp=ENABLED'

# Wait for service
aws ecs wait services-stable \
  --cluster my-cluster \
  --services myapp
```

### Step 3: Jenkins Pipeline for ECS

```groovy
pipeline {
    agent any

    stages {
        stage('Deploy to ECS') {
            steps {
                sh '''
                    aws ecs update-service \
                        --cluster my-cluster \
                        --service myapp \
                        --task-definition myapp-task \
                        --force-new-deployment
                    '''
                }
            }
        }
    }
}
```

---

## Exercise 5: GitHub Webhook Integration

**Goal:** Configure GitHub webhooks for CI/CD

**Time:** ~20 minutes

### Step 1: Generate GitHub Token

```bash
# GitHub → Settings → Developer Settings → Personal Access Tokens
# Create token with scopes:
# - repo: Full control of private repositories
# - read:repo_hook: Read and hooks
```

### Step 2: Configure Jenkins with GitHub

```bash
# Jenkins UI: Credentials → System
# Add GitHub credentials
# ID: github-token
# Type: Secret text
# Value: GitHub PAT token
```

### Step 3: Configure GitHub Webhook

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
```

### Step 4: Update Jenkins Pipeline

```groovy
pipeline {
    agent any

    triggers {
        github([
            [class: 'WebhookTrigger', 
             webhook: [
                 name: 'github',
                 payload: '.*',
                 content: 'application/json',
                 secret: 'your-secret-key'
             ]],
            [class: 'SCMTrigger', 
             scm: [
                 branches: ['main'],
                 remote: ['origin'],
                 url: 'https://github.com/username/repo.git'
             ]
            ]
        ])
        
        git {
            branches {
                branch "main"
            }
            remote {
                name: 'origin'
                url: 'https://github.com/username/repo.git'
            }
            credentialsId: 'github-token'
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

## Exercise 6: Create Deployment Strategy

**Goal:** Implement blue-green deployment

**Time:** ~25 minutes

### Step 1: Create Task Definitions

```bash
# Blue task definition
cat > task-definition-blue.json << 'EOF'
{
  "family": "myapp-blue",
  "containerDefinitions": [
    {
      "name": "web",
      "image": "123456789012.dkr.ecr.us-east-1.amazonaws.com/myapp:latest",
      "essential": true
    }
  ]
}
EOF

# Green task definition
cat > task-definition-green.json << 'EOF'
{
  "family": "myapp-green",
  "containerDefinitions": [
    {
      "name": "web",
      "image": "123456789012.dkr.ecr.us-east-1.amazonaws.com/myapp:${BUILD_NUMBER}",
      "essential": true
    }
  ]
}
EOF
```

### Step 2: Jenkins Pipeline

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
                        --task-definition myapp-blue \
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
                    # Update service to use green
                    aws ecs update-service \
                        --cluster my-cluster \
                        --service myapp \
                        --task-definition myapp-green \
                        --force-new-deployment
                    '''
            }
        }
        
        stage('Blue-Green Complete') {
            steps {
                echo 'Deployment complete!'
            }
        }
    }
}
```

---

## Exercise 7: Complete Module 3 Checklist

- [ ] Installed Jenkins on EC2
- [ ] Configured Maven builds
- [ ] Created Docker pipeline
- [ ] Built and pushed to ECR
- [ ] Deployed to ECS
- [ ] Configured GitHub webhooks
- [ ] Implemented rollback strategy
- [ ] Used deployment strategies

---

## Module 3 Complete!

**You've mastered:**
- ✅ Jenkins installation and setup
- ✅ CI/CD pipeline concepts
- ✅ Maven build automation
- ✅ Docker integration
- ✅ AWS integration (EC2, ECR, ECS)
- ✅ GitHub integration
- ✅ Security best practices
- ✅ Deployment strategies

**Next Step:** Module 4: Infrastructure as Code with Terraform

---

*Module 3 Complete!*
