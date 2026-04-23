# 001 - Docker Fundamentals

**Module 2 - Part 1**  
**Project:** DevOps-Project-01 - Django on AWS ECS/ECR

---

## Overview

Docker is the industry standard for containerization. This module covers:
- Container basics and lifecycle
- Images and registries
- Dockerfile best practices
- AWS ECR integration
- ECS deployment

---

## What is Docker?

### Container vs Virtual Machine

| Virtual Machines | Containers |
|-------- |---|
| Each VM has full OS | Shares host OS kernel |
| Heavy (GBs) | Lightweight (MBs) |
| Slow startup (mins) | Fast startup (seconds) |
| High resource usage | Efficient resource use |

### Docker Architecture

```
┌─────────────────────────────────────────┐
│              Host Machine                │
│  ┌─────────────────────────────────────┐│
│  │     Docker Engine                    ││
│  │  ┌─────────────────────────────────┐││
│  │  │     Docker Daemon                │││
│  │  └─────────────────────────────────┘││
│  └─────────────────────────────────────┘│
└─────────────────────────────────────────┘
            ↓
┌─────────────────────────────────────────┐
│              Docker Images               │
│  (Stored on host filesystem)             │
└─────────────────────────────────────────┘
            ↓
┌─────────────────────────────────────────┐
│         Containers (Runtime)            │
└─────────────────────────────────────────┘
```

---

## Dockerfile Basics

### Dockerfile Instructions

| Instruction | Description | Example |
|---------|-------------|---|
| `FROM` | Base image | `FROM python:3.9` |
| `LABEL` | Add metadata | `LABEL maintainer="you"` |
| `RUN` | Execute commands | `RUN apt-get update` |
| `COPY` | Copy files | `COPY . /app` |
| `ADD` | Copy + extract URLs | `ADD file.tar.gz /app/` |
| `WORKDIR` | Set working directory | `WORKDIR /app` |
| `CMD` | Default command | `CMD ["python", "app.py"]` |
| `ENTRYPOINT` | Entrypoint | `ENTRYPOINT ["python"]` |
| `ENV` | Set environment | `ENV PYTHON_VERSION=3.9` |
| `EXPOSE` | Document port | `EXPOSE 5000` |
| `VOLUME` | Mount point | `VOLUME ["/data"]` |
| `USER` | Set user | `USER appuser` |
| `ARG` | Build-time var | `ARG BUILD_VERSION` |
| `HEALTHCHECK` | Health check | `HEALTHCHECK CMD curl...` |

---

### Creating a Simple Dockerfile

```dockerfile
# Basic Python app Dockerfile
FROM python:3.9-slim

# Add labels
LABEL maintainer="dev@example.com"
LABEL version="1.0"

# Set working directory
WORKDIR /app

# Install dependencies
RUN pip install --no-cache-dir Flask

# Copy application files
COPY requirements.txt .
COPY app.py .

# Create non-root user
RUN useradd -m appuser
USER appuser

# Expose port
EXPOSE 5000

# Health check
HEALTHCHECK --interval=30s --timeout=3s \
  CMD curl -f http://localhost:5000/health || exit 1

# Set command
CMD ["python", "app.py"]
```

---

## Building Images

### Basic Build Commands

```bash
# Build image
docker build -t myapp:1.0 .

# Build with Dockerfile name
docker build -f Dockerfile.prod -t myapp:prod .

# Build with options
docker build --build-arg BUILD_VERSION=1.0 \
             --build-arg PYTHON_VERSION=3.9 \
             -t myapp:1.0 .

# Build cache
docker build --pull --ssh gcp_us-east1-mysql_tube \
             --cache-from=ghcr.io/user/myimage \
             -t user/myapp:build --progress=plain .
```

---

## Running Containers

### Basic Run Commands

```bash
# Run container
docker run myapp:1.0

# Run with name
docker run --name myapp myapp:1.0

# Run with port mapping
docker run -p 5000:5000 myapp:1.0

# Run with environment variables
docker run -e FLASK_ENV=production -e DEBUG=false myapp:1.0

# Run with volume mount
docker run -v $(pwd)/data:/app/data myapp:1.0

# Run with multiple options
docker run -d \
  --name myapp \
  -p 5000:5000 \
  -e FLASK_ENV=production \
  -v $(pwd)/data:/app/data \
  --restart unless-stopped \
  myapp:1.0
```

---

## Container Management

### Viewing Containers

```bash
# List all containers
docker ps -a

# List running containers
docker ps

# Container details
docker inspect myapp

# View logs
docker logs myapp
docker logs -f myapp      # Follow logs
docker logs --tail=100 myapp

# Exec into container
docker exec -it myapp bash

# Stop container
docker stop myapp

# Start container
docker start myapp

# Restart container
docker restart myapp

# Remove container
docker rm myapp
docker rm -vf myapp       # Force remove
```

---

## Image Management

### Image Commands

```bash
# List images
docker images
docker image ls

# Pull image
docker pull python:3.9

# Push image
docker tag myapp:1.0 registry.example.com/myapp:1.0
docker push registry.example.com/myapp:1.0

# Remove image
docker rmi myapp:1.0
docker image rm myapp:1.0

# Build cache cleanup
docker builder prune

# Full cleanup
docker system prune
docker system prune -a     # Remove all unused images
```

---

## Docker Compose

### Docker Compose Basics

```yaml
# docker-compose.yml
version: '3.8'

services:
  web:
    build: ./web
    ports:
      - "5000:5000"
    environment:
      - FLASK_ENV=production
    volumes:
      - ./data:/app/data
    depends_on:
      - db
    networks:
      - app-network

  db:
    image: postgres:13
    environment:
      - POSTGRES_USER=app
      - POSTGRES_PASSWORD=${DB_PASSWORD}
    volumes:
      - pgdata:/var/lib/postgresql/data

  redis:
    image: redis:6-alpine

volumes:
  pgdata:

networks:
  app-network:
    driver: bridge
```

### Compose Commands

```bash
# Build and start
docker compose up -d

# Stop all services
docker compose down

# Restart services
docker compose restart

# View logs
docker compose logs -f

# Run one-time command
docker compose run web python manage.py migrate

# Build with cache
docker compose build --no-cache
```

---

## Docker Security Best Practices

### Security Checklist

```dockerfile
# Use multi-stage builds (reduce image size)
FROM node:16 AS builder
FROM node:16-slim
COPY --from=builder /app /app

# Run as non-root user
USER appuser

# Don't use root in container
USER nobody

# Use official images
FROM ubuntu:20.04  # Not FROM ubuntu:latest

# Don't use sudo in container
# Always use su or direct commands

# Keep images updated
RUN apt-get update && apt-get upgrade -y && apt-get clean

# Don't include unnecessary packages
RUN apt-get remove -y openssh-server
RUN apt-get remove -y ca-certificates

# Use .dockerignore
# - .git
# - __pycache__
# - *.pyc
# - node_modules
```

---

## AWS ECR (Elastic Container Registry)

### ECR Setup

```bash
# Login to ECR
aws ecr get-login-password | docker login --username AWS --password-stdin \
  123456789012.dkr.ecr.us-east-1.amazonaws.com

# Tag image for ECR
docker tag myapp:1.0 \
  123456789012.dkr.ecr.us-east-1.amazonaws.com/myapp:1.0

# Push to ECR
docker push 123456789012.dkr.ecr.us-east-1.amazonaws.com/myapp:1.0
```

---

## Notes

```
Date: _____________

Notes:

```

---

*Module 2 - Part 1*
