# 003 - Container Lifecycle Management

**Module 2 - Part 3**  
**Topic:** Creating, running, and managing containers

---

## Container Creation

### Dockerfile to Container

```dockerfile
# Example Dockerfile for Django app
FROM python:3.9-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

RUN useradd -m appuser
USER appuser

EXPOSE 8000

CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
```

### Run Container

```bash
# Create and start container
docker run -d \
  --name django-app \
  -p 8000:8000 \
  --restart unless-stopped \
  myapp:1.0

# Interactive container
docker run -it \
  --name dev-env \
  --rm \
  python:3.9-slim /bin/bash
```

---

## Container Viewing

```bash
# List running containers
docker ps

# All containers
docker ps -a

# Container status
docker inspect django-app
# Returns JSON with:
# - Container ID
# - Image
# - Ports
# - State (running/stopped)
# - Created
# - Command
```

### Container ID Prefix

```bash
# Run returns container ID (first 12 chars)
docker run myapp
# Output: a1b2c3d4e5f6

# Filter by ID prefix
docker ps -f "id=a1b2c3d4e5f6"

# List by name (not available in short format)
# Use full inspection for name
docker inspect --format='{{.Name}}' a1b2c3d4e5f6
```

---

## Container Logs

```bash
# View logs
docker logs myapp

# Last 100 lines
docker logs --tail=100 myapp

# Follow logs (like tail -f)
docker logs -f myapp
docker logs -f --tail=50 myapp

# Specific timestamps
docker logs --since 30m myapp
docker logs --since 2026-04-23T10:00:00 myapp

# Container and image logs
docker inspect myapp | grep -i log-config
```

---

## Container Execution

```bash
# Execute command inside running container
docker exec myapp python --version
docker exec myapp ls -la

# Interactive exec
docker exec -it myapp bash
docker exec -it myapp python

# Run one-time command
docker exec myapp /bin/sh -c "apt-get update && apt-get install -y curl"

# Copy files to container
docker cp file.txt myapp:/app/file.txt
docker cp myapp:/app/app.py ./app.py

# Copy files from container
docker cp myapp:/app/logs/app.log ./logs/app.log

# Copy with remote path
docker cp myapp:/app/./archive/backup.war myapp-backup.war
```

---

## Container Networking

### Port Mapping

```bash
# Publish specific port
docker run -p 8000:8000 myapp

# Port range
docker run -p 8000-8010:8000-8010 myapp

# IP binding
docker run -p 127.0.0.1:8000:8000 myapp
docker run -p 0.0.0.0:8000:8000 myapp

# Multiple ports
docker run -p 8000:8000 -p 8080:8080 myapp
```

### Container Networks

```bash
# Create custom network
docker network create mynetwork

# Connect container to network
docker network connect mynetwork myapp

# List networks
docker network ls

# View network details
docker network inspect mynetwork

# Remove container from network
docker network disconnect mynetwork myapp
```

---

## Container Environment Variables

```bash
# Run with environment variables
docker run -e FLASK_ENV=production \
           -e DEBUG=false \
           -e DB_URL=postgres://user:pass@db:5432/app \
           myapp

# Mount env file
docker run --env-file ./.env myapp

# View environment
docker inspect myapp | grep -i Env
```

---

## Container Volumes

### Volume Types

| Type | Description |
|------|---|
| **Bind Mount** | Host directory → Container path |
| **Named Volume** | Docker managed volume |
| **Anonymous Volume** | Docker managed (no name) |

### Volume Commands

```bash
# Run with bind mount
docker run -v $(pwd)/data:/app/data myapp

# Run with named volume
docker run -v myapp-data:/app/data myapp

# Run with specific permissions
docker run -v myapp-data:/app/data:ro myapp  # Read-only
docker run -v myapp-data:/app/data:z myapp   # Transparent huge pages (macOS)

# List volumes
docker volume ls

# Inspect volume
docker volume inspect myapp-data

# Remove volume
docker volume rm myapp-data

# Create volume
docker volume create myapp-data
```

---

## Container Restart Policies

```bash
# No restart (default)
docker run myapp

# Always restart
docker run --restart always myapp

# Unless stopped
docker run --restart unless-stopped myapp

# On failure only
docker run --restart on-failure myapp
docker run --restart on-failure:5 myapp  # 5 retries

# On failure with max retries
docker run --restart on-failure:3 myapp
```

---

## Container Limits

### Resource Constraints

```bash
# Memory limit
docker run -m 512m myapp

# Memory limit with swap
docker run --memory=512m --memory-swap=1g myapp

# CPU limit
docker run --cpus="0.5" myapp        # 50% of one CPU
docker run --cpu-shares=512 myapp    # CPU shares (relative)

# Both limits
docker run -m 512m --cpus="0.5" myapp
```

### PIDs Limit

```bash
# Limit PIDs (prevent zombie processes)
docker run --pids-limit=100 myapp

# Default: unlimited (-1)
```

---

## Container Health Checks

```dockerfile
# In Dockerfile
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:8000/health || exit 1
```

```bash
# View health status
docker inspect myapp | grep -i "Health"

# Output:
# "HealthStatus": {
#   "Status": "healthy",
#   "FailingStreak": 0,
#   "Start": "2026-04-23T10:00:00Z",
#   "Output": "HTTP/1.1 200 OK\n"
# }
```

---

## Container Cleanup

```bash
# Stop and remove container
docker stop myapp
docker rm myapp

# Remove stopped containers (prune)
docker container prune

# Remove unused images
docker image prune

# Full cleanup
docker system prune -a
# Warning: Removes all unused images, containers, volumes
```

---

## Container State

```bash
# View container status
docker inspect myapp | grep -i state

# Output:
# "State": {
#   "Status": "running",
#   "Running": true,
#   "Paused": false,
#   "Restarting": false,
#   "OOMKilled": false,
#   "Dead": false,
#   "Pid": 12345,
#   "ExitCode": 0,
#   "Error": "",
#   "StartedAt": "2026-04-23T10:00:00Z",
#   "FinishedAt": "2026-04-23T09:59:00Z"
# }
```

---

## Notes

```
Date: _____________

Notes:

```

---

*Module 2 - Part 3*
