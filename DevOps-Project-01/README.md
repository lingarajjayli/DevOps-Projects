# DevOps-Project-01: Docker Containerization

**Module 2: Docker Fundamentals for DevOps**

---

## Project Overview

This project teaches Docker containerization with hands-on practice for AWS ECR and ECS deployment.

---

## Files Structure

| File | Topic |
|------|-------|
| **001-Docker-101.md** | Docker fundamentals, Dockerfiles |
| **002-Docker-102-Images.md** | Image building and management |
| **003-Docker-103-Container-Lifecycle.md** | Container lifecycle management |
| **004-Docker-104-Dockerfile-Best-Practices.md** | Dockerfile optimization |
| **005-Docker-105-AWS-ECR.md** | AWS ECR integration |
| **006-Docker-106-EC2-ECS.md** | EC2 and ECS deployment |
| **007-Docker-107-Compose-Practice.md** | Docker Compose exercises |

---

## Learning Path

1. Start with **001-Docker-101.md**
2. Practice each Dockerfile example
3. Build images locally
4. Push to AWS ECR
5. Deploy to ECS

---

## Quick Start

```bash
# Install Docker Desktop (if not installed)
# Download from: https://desktop.docker.com

# Install AWS CLI
# https://aws.amazon.com/cli/

# Login to ECR
aws ecr get-login-password | \
  docker login --username AWS --password-stdin \
  123456789012.dkr.ecr.us-east-1.amazonaws.com
```

---

## Exercise 1: First Dockerfile

```bash
# Create simple app
mkdir -p myapp
cd myapp

# Create Dockerfile
cat > Dockerfile << 'EOF'
FROM python:3.9-slim
WORKDIR /app
COPY app.py .
CMD ["python", "app.py"]
EOF

# Create app.py
cat > app.py << 'EOF'
print("Hello from Docker!")
EOF

# Build image
docker build -t myapp:1.0 .

# Run container
docker run myapp:1.0
```

---

## Exercise 2: Push to ECR

```bash
# Tag image
docker tag myapp:1.0 \
  123456789012.dkr.ecr.us-east-1.amazonaws.com/myapp:1.0

# Push to ECR
docker push 123456789012.dkr.ecr.us-east-1.amazonaws.com/myapp:1.0
```

---

## Resources

- **Official Docker Docs:** https://docs.docker.com/
- **ECS Documentation:** https://docs.aws.amazon.com/AmazonECS/latest/developerguide/
- **ECR Documentation:** https://docs.aws.amazon.com/AmazonECR/latest/userguide/

---

## Completion Criteria

Mark this project as complete when you can:
- ✅ Build multi-stage Docker images
- ✅ Push images to AWS ECR
- ✅ Deploy containers to ECS
- ✅ Use Docker Compose for multi-service apps
- ✅ Apply Docker security best practices

---

*Module 2 Created: 2026-04-23*
