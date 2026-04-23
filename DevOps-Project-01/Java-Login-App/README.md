# Java Login Application - DevOps Project
# Full CI/CD Pipeline with Docker, Jenkins, and Kubernetes

## ==📋 TABLE OF CONTENTS

1. [Project Architecture](#project-architecture)
2. [Technologies Used](#technologies-used)
3. [DevOps Components](#devops-components)
4. [Quick Start Guide](#quick-start-guide)
5. [Jenkins CI/CD Pipeline](#jenkins-cicd-pipeline)
6. [Docker Compose Setup](#docker-compose-setup)
7. [Kubernetes Deployment](#kubernetes-deployment)
8. [Kind Cluster Setup](#kind-cluster-setup)
9. [Troubleshooting](#troubleshooting)

---

## ==PROJECT ARCHITECTURE

```
┌───────────────────────────────────────────────────────────────┐
│                    Java Login Application                      │
│                    (Spring Boot + MySQL)                       │
└───────────────────────────────────────────────────────────────┘
                               │
                ┌─┴──┬─┴──┐
        ┌──────────┼──┼────────┐
        │ Docker   │  │ Jenkins│  │ k8s/
        │ Image    │  │ Pipeline│  │ manifests
        └──┬───────┘  └────┬────┘  └────┬───┘
           │               │            │
           └─────┬─────────┴─────┬─────┘
                 │               │
           ┌─────┴──────┬────────┴──────┐
           │ Docker      │  Kubernetes   │
           │ Compose    │  Cluster (kind)│
           │ + MySQL    │                │
           └─────┬──────┴────────┬───────┘
                 │               │
                 └───────┬───────┘
                         ▼
                 ┌──────────────────┐
                 │  AWS RDS MySQL   │
                 │  UserDB          │
                 └──────────────────┘
```

## ==TECHNOLOGIES USED

| Technology | Version | Purpose |
|------------|---------|---------|
| Java | 1.8 | Application Runtime |
| Spring Boot | 2.2.4.RELEASE | Application Framework |
| Maven | 3.8+ | Build Tool |
| Docker | Latest | Containerization |
| MySQL | 8.0 | Database (AWS RDS) |
| Jenkins | LTS | CI/CD Automation |
| Kubernetes | 1.28+ | Container Orchestration |
| kind | 0.20+ | Local Kubernetes |

## ==DEVOPS COMPONENTS

### ==1. Docker Multi-Stage Build
- Stage 1: Maven Build (Compile → WAR)
- Stage 2: Tomcat Runtime (Serve WAR)
- Health Checks included

### ==2. Docker Compose
- app: Spring Boot container
- mysql: Local development DB
- Environment variables

### ==3. Jenkins CI/CD Pipeline
- Stage 1: Checkout code
- Stage 2: Maven Build
- Stage 3: Unit Tests
- Stage 4: Docker Build
- Stage 5: Push to Registry
- Stage 6: Deploy to k8s

### ==4. Kubernetes Manifests
- deployment.yaml - App Deployment
- service.yaml - ClusterIP Service
- configmap.yaml - App Config
- serviceaccount.yaml - SA & ResourceQuota

### ==5. Kind Cluster
- kind.yaml - kind cluster config

## ==QUICK START GUIDE

### ==1. Setup Environment Variables

```bash
# Edit .env file with your credentials
vi .env
```

### ==2. Build and Run Locally

```bash
# Using Makefile
make docker-build
make deploy

# Or manual commands
docker build -t dptweb:latest .
docker-compose up -d
```

### ==3. Access Application

```bash
# Open browser:
# http://localhost:8080

# Features:
# - Login Page
# - Register New User
# - View User Dashboard
```

### ==4. Build for Production

```bash
# Build with AWS RDS credentials
export DB_URL=jdbc:mysql://your-rds-endpoint:3306/UserDB
export DB_USERNAME=admin
export DB_PASSWORD=your-password

# Deploy to Kubernetes
make kind-create
make kind-deploy
```

## ==JENKINS CI/CD PIPELINE

### ==1. Setup Jenkins

```bash
# Install plugins:
# - Maven Integration
# - Docker
# - Kubernetes CLI
# - Pipeline: Groovy

# Configure credentials:
# 1. Docker Hub credentials
# 2. Kubernetes cluster access
# 3. Repository URL (this repo)
```

### ==2. Pipeline Configuration

The Jenkinsfile is at `.jenkins/Jenkinsfile`

**Important**: Update in Jenkinsfile:
```groovy
DOCKER_REGISTRY = 'your-docker-hub-username'
```

### ==3. Pipeline Stages

```
📦 Checkout       → Pull latest code
🔨 Build           → Maven compile & package
🧪 Test            → Run unit tests
🐳 Build Docker    → Create image
📤 Push            → Push to registry
🚀 Deploy          → Apply k8s manifests
```

### ==4. Jenkins Job Setup

```bash
# Job Type: Pipeline
# Source: Jenkinsfile at .jenkins/
# Trigger: Scheduled or Git webhook
```

## ==DOCKER COMPOSE SETUP

### ==1. Configure Database

```bash
# For AWS RDS (Production)
# Edit .env file with your RDS credentials

# For local MySQL (Development)
# Comment out RDS vars, uncomment local vars
```

### ==2. Build and Run

```bash
# Build
docker-compose build

# Run with Docker
docker-compose up -d

# View logs
docker-compose logs -f app
```

### ==3. Environment Variables

| Variable | Development | Production (AWS RDS) |
|--|--|--|
| DB_URL | jdbc:mysql://mysql:3306/UserDB | jdbc:mysql://rds-endpoint:3306/UserDB |
| DB_USERNAME | root | admin |
| DB_PASSWORD | password | Admin123 |
| EXPOSE_MYSQL | 3306 | 0 |

## ==KUBERNETES DEPLOYMENT

### ==1. Apply Kubernetes Manifests

```bash
# Create namespace
kubectl create namespace default

# Apply all manifests
kubectl apply -f k8s/

# Check deployment
kubectl get deployments
kubectl get pods

# Check service
kubectl get services
```

### ==2. Port Forward (for local testing)

```bash
kubectl port-forward svc/dptweb-service 30080:80
# Access: http://localhost:30080
```

### ==3. AWS RDS Configuration

```yaml
env:
  - name: SPRING_DATASOURCE_URL
    value: "jdbc:mysql://rds-endpoint:3306/UserDB"
  - name: SPRING_DATASOURCE_USERNAME
    value: "admin"
  - name: SPRING_DATASOURCE_PASSWORD
    valueFrom:
      secretKeyRef:
        name: db-secret
        key: password
```

### ==4. Deployment YAML Structure

```yaml
Deployment:
  - replicas: 2           # High availability
  - imagePullPolicy: Always
  - resources:            # Resource limits
      requests: 256Mi
      limits: 512Mi
  - livenessProbe:        # Health checks
      - initialDelaySeconds: 60
      - periodSeconds: 30
  - readinessProbe:
      - initialDelaySeconds: 30
```

## ==KIND CLUSTER SETUP

### ==1. Install kind

```bash
# Install kind (macOS)
brew install kind

# or (Linux)
curl -Lo ./kind https://kind.sigs.k8s.io/dl/latest/linux-amd64
chmod +x ./kind
mv ./kind /usr/local/bin/kind

# Verify
kind version
```

### ==2. Create Cluster

```bash
# Using kind.yaml
kind create cluster --config=k8s-kind/kind.yaml

# Or default
kind create cluster
```

### ==3. Deploy Application

```bash
# Build image
docker build -t dptweb:latest .

# Push to registry
docker push dptweb:latest

# Deploy
kubectl apply -f k8s/

# Access
curl http://localhost:32000
```

### ==4. Delete Cluster

```bash
kind delete cluster
```

## ==TROUBLESHOOTING

### ==Deployment Fails

```bash
# Check pod status
kubectl get pods

# Check events
kubectl describe pod <pod-name>

# Check logs
kubectl logs <pod-name>
```

### ==Database Connection Issues

```bash
# Verify RDS endpoint
export DB_URL=jdbc:mysql://rds-endpoint:3306/UserDB

# Test connection
mysql -h rds-endpoint -u admin -p -e "SHOW DATABASES;"
```

### ==Docker Build Errors

```bash
# Clear Maven cache
mvn clean

# Rebuild
docker build --no-cache -t dptweb:latest .
```

### ==Service Not Accessible

```bash
# Check service port
kubectl get svc

# Port forward
kubectl port-forward svc/dptweb-service 8080:80

# Check ingress
kubectl get ingress
```

## ==COMMAND REFERENCE

```bash
# Build and deploy
make docker-build
make deploy

# Run tests
make test

# Kubernetes commands
kubectl get pods
kubectl get services
kubectl get deployments
kubectl logs -f <pod-name>
kubectl delete pod <pod-name>
```

## ==FILE STRUCTURE

```
Java-Login-App/
├── .env                          # Environment variables
├── .jenkins/
│   └── Jenkinsfile               # CI/CD Pipeline
├── .gitignore
├── Dockerfile                    # Multi-stage Docker build
├── docker-compose.yml            # Docker Compose setup
├── Makefile                      # Automation tasks
├── README.md                     # This file
├── k8s/
│   ├── deployment.yaml           # K8s Deployment
│   ├── service.yaml              # K8s Service
│   ├── configmap.yaml            # App Config
│   └── serviceaccount.yaml       # SA & Quota
├── k8s-kind/
│   └── kind.yaml                 # kind cluster config
└── k8s-rds/
    └── deployment-rds.yaml       # AWS RDS deployment
```

---

## ==🎯 GETTING STARTED

1. **Clone/Download** this repository
2. **Configure** `.env` with your database credentials
3. **Build**: `make docker-build`
4. **Deploy**: `make deploy`
5. **Access**: http://localhost:8080

---

## ==NEXT STEPS

1. Configure Jenkins pipeline
2. Set up AWS RDS credentials
3. Create Docker Hub repository
4. Configure kubectl for k8s cluster
5. Set up monitoring (Prometheus/Grafana)
6. Add security scanning (Trivy)
7. Implement blue-green deployment
