# 004 - Dockerfile Best Practices

**Module 2 - Part 4**  
**Topic:** Writing optimal Dockerfiles for production

---

## Dockerfile Optimization

### Principle: Multi-Stage Builds

```dockerfile
# ❌ BAD: Single-stage (large image)
FROM python:3.9
WORKDIR /app
COPY requirements.txt .
RUN pip install -r requirements.txt
COPY . .
RUN pip install -r requirements.txt  # Duplicate!
# Image includes: build tools, dependencies, source code

# ✅ GOOD: Multi-stage (small image)
FROM python:3.9-slim AS builder
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

FROM python:3.9-slim
WORKDIR /app
COPY --from=builder /app /app
COPY . .
# Image includes: only runtime dependencies and source
```

---

## Layer Caching

### Principle: Reorder Instructions for Better Cache

```dockerfile
# ❌ BAD: Source copied first (invalidates cache)
FROM python:3.9-slim
WORKDIR /app
COPY . .                                    # Any code change invalidates cache
RUN pip install -r requirements.txt         # Re-installs every time

# ✅ GOOD: Dependencies first (better cache)
FROM python:3.9-slim
WORKDIR /app
COPY requirements.txt .                     # Cache dependencies first
RUN pip install --no-cache-dir -r requirements.txt
COPY . .                                    # Changes less frequently
```

---

## Image Size Reduction

### Remove Unnecessary Files

```dockerfile
# Remove package lists (apt)
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Remove cache (npm)
RUN npm install && npm cache clean --force

# Remove cache (pip)
RUN pip install --no-cache-dir package

# Remove unneeded tools
RUN apt-get remove -y openssh-server
RUN apt-get remove -y ca-certificates

# Clean up during build
RUN apt-get clean && rm -rf /var/cache/apt/*

# Clean up package manager cache
RUN yum clean all && rm -rf /var/cache/yum/*
```

---

## Security Best Practices

### Non-Root User

```dockerfile
# ❌ BAD: Running as root
FROM python:3.9
WORKDIR /app
COPY . .
CMD ["python", "app.py"]

# ✅ GOOD: Run as non-root user
FROM python:3.9-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY . .
RUN useradd -m appuser
USER appuser                          # Switch to non-root
CMD ["python", "app.py"]
```

### Use Specific Versions

```dockerfile
# ❌ BAD: Using latest
FROM python
FROM node
FROM ubuntu

# ✅ GOOD: Using specific versions
FROM python:3.9-slim-bullseye
FROM node:16.13.2-alpine
FROM ubuntu:20.04
```

---

## .dockerignore

### Excluding Unnecessary Files

```dockerfile
# .dockerignore file
# git
.git
.gitignore

# python
__pycache__
*.pyc
*.pyo
.pytest_cache
.coverage

# node
node_modules
npm-debug.log

# documentation
*.md
LICENSE

# env
.env
.env.*
.dockerignore

# IDE
.idea
.vscode
*.swp
*.swo

# docker
docker-compose.override.yml

# secrets
*.pem
*.key
```

---

## Environment Variables

```dockerfile
# ❌ BAD: Hardcoded secrets
ENV DB_PASSWORD=mysecretpassword

# ✅ GOOD: Use build args or env files
ARG DB_PASSWORD
ENV DB_PASSWORD=${DB_PASSWORD}
```

---

## Notes

```
Date: _____________

Notes:

```

---

*Module 2 - Part 4*
