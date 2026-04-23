# 002 - Docker Images

**Module 2 - Part 2**  
**Topic:** Docker Images - Building and managing container images

---

## Image Fundamentals

### Image Layers

Docker images are built from layers:

```
┌─────────────────────┐
│     Layer 4         │ <- Application code
├─────────────────────┤
│     Layer 3         │ <- App dependencies
├─────────────────────┤
│     Layer 2         │ <- System packages
├─────────────────────┤
│     Layer 1         │ <- Base OS
├─────────────────────┤
│     Read-Only       │
└─────────────────────┘
           ↓
┌─────────────────────┐
│    Read-Write       │ <- Container layer
└─────────────────────┘
```

### Multi-Stage Builds

```dockerfile
# Build stage (larger)
FROM node:16 AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

# Production stage (smaller)
FROM nginx:alpine
COPY --from=builder /app/dist /usr/share/nginx/html
COPY --from=builder /app/nginx.conf /etc/nginx/conf.d/default.conf
```

---

## Pulling Images

### Pull Commands

```bash
# Pull latest
docker pull python:3.9

# Pull specific version
docker pull python:3.9-slim-bullseye

# Pull with tag
docker pull myapp:1.0
docker pull myapp:latest

# Pull multiple images
docker pull python:3.9
docker pull nginx:alpine
docker pull redis:alpine
```

### Image Tagging

```bash
# Tag image locally
docker tag myapp:1.0 localhost:5000/myapp:1.0

# Tag for registry
docker tag myapp:1.0 \
  gcr.io/myproject/myapp:1.0

# List tags
docker images myapp
```

---

## Inspecting Images

```bash
# View image details
docker inspect myapp:1.0

# View layer information
docker history myapp:1.0

# View image config
docker export $(docker create --name tmp myapp:1.0) | docker import - myapp:from-export
```

---

## Image Optimization

### Reducing Image Size

```dockerfile
# Combine RUN commands (layers)
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Use multi-stage builds
FROM node:16 AS builder
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

FROM nginx:alpine
COPY --from=builder /app/build /usr/share/nginx/html

# Use slim images
FROM python:3.9-slim
FROM node:16-slim

# Clean up apt cache
RUN apt-get update && apt-get install -y \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Use --no-cache-dir in pip/npm
RUN pip install --no-cache-dir package
RUN npm install --no-cache

# Don't use --root
ARG BUILD_VERSION
```

---

## Image Verification

```bash
# Verify image
docker inspect myapp:1.0 | grep -i "size"
docker history myapp:1.0

# Check image layers
docker image inspect myapp:1.0 --format='{{range .RootFS.Layers}}{{.}}{{"\n"}}'
```

---

## Notes

```
Date: _____________

Notes:

```

---

*Module 2 - Part 2*
