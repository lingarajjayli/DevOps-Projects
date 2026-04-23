# 007 - Docker Compose Practice Exercises

**Module 2 - Part 7**  
**Topic:** Hands-on Docker Compose exercises

---

## Exercise 1: Simple Web App with Database

**Goal:** Create a web app with PostgreSQL database

**Time:** ~15 minutes

### Step 1: Create Project Directory

```bash
mkdir -p webapp/{src,data}
cd webapp
```

### Step 2: Create requirements.txt

```bash
# Create requirements.txt
cat > requirements.txt << EOF
Flask==2.3.0
gunicorn==21.2.0
psycopg2-binary==2.9.9
EOF
```

### Step 3: Create Dockerfile

```bash
# Create Dockerfile
cat > Dockerfile << EOF
FROM python:3.9-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

RUN useradd -m appuser && chown -R appuser:appuser /app

USER appuser

EXPOSE 5000

CMD ["gunicorn", "--bind", "0.0.0.0:5000", "app:app"]
EOF
```

### Step 4: Create docker-compose.yml

```yaml
# docker-compose.yml
version: '3.8'

services:
  web:
    build: .
    ports:
      - "5000:5000"
    environment:
      - FLASK_ENV=production
      - DATABASE_URL=postgresql://user:password@db:5432/myapp
    volumes:
      - ./src:/app/src
    depends_on:
      - db
    networks:
      - app-network

  db:
    image: postgres:13
    environment:
      - POSTGRES_USER=user
      - POSTGRES_PASSWORD=password
      - POSTGRES_DB=myapp
    volumes:
      - db-data:/var/lib/postgresql/data
    networks:
      - app-network

volumes:
  db-data:

networks:
  app-network:
    driver: bridge
```

### Step 5: Run Services

```bash
# Start services
docker compose up -d

# View logs
docker compose logs -f

# Check health
docker compose ps
```

---

## Exercise 2: Multi-Service Application

**Goal:** Create a full-stack application with Redis cache

**Time:** ~20 minutes

### docker-compose.yml

```yaml
# docker-compose.yml
version: '3.8'

services:
  web:
    build: .
    ports:
      - "5000:5000"
    environment:
      - REDIS_URL=redis://redis:6379/0
      - DATABASE_URL=postgresql://user:password@db:5432/myapp
    volumes:
      - ./src:/app/src
    depends_on:
      - redis
      - db
    networks:
      - app-network
    deploy:
      resources:
        limits:
          memory: 512M

  redis:
    image: redis:6-alpine
    volumes:
      - redis-data:/data
    networks:
      - app-network

  db:
    image: postgres:13
    environment:
      - POSTGRES_USER=user
      - POSTGRES_PASSWORD=password
      - POSTGRES_DB=myapp
    volumes:
      - db-data:/var/lib/postgresql/data
    networks:
      - app-network

  adminer:
    image: adminer:latest
    ports:
      - "8080:8080"
    environment:
      - ADMINER_DEFAULT_SERVER=db
    depends_on:
      - db
    networks:
      - app-network

volumes:
  redis-data:
  db-data:

networks:
  app-network:
    driver: bridge
```

---

## Exercise 3: Build for ECR

**Goal:** Build multi-stage image for production

**Time:** ~20 minutes

### Dockerfile

```dockerfile
# multi-stage Dockerfile
FROM python:3.9-slim AS builder

WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .
RUN python -m compileall src

# Production stage
FROM python:3.9-slim

WORKDIR /app
COPY --from=builder /app/src /app/src
COPY --from=builder /usr/local/lib/python3.9/site-packages /usr/local/lib/python3.9/site-packages

RUN useradd -m appuser && chown -R appuser:appuser /app

USER appuser

EXPOSE 5000

HEALTHCHECK --interval=30s --timeout=3s \
  CMD curl -f http://localhost:5000/health || exit 1

CMD ["gunicorn", "--bind", "0.0.0.0:5000", "src.app:app"]
```

### Push to ECR

```bash
# Tag for ECR
aws ecr get-login-password | \
  docker login --username AWS --password-stdin \
  123456789012.dkr.ecr.us-east-1.amazonaws.com

docker tag myapp:1.0 \
  123456789012.dkr.ecr.us-east-1.amazonaws.com/myapp:1.0
docker push 123456789012.dkr.ecr.us-east-1.amazonaws.com/myapp:1.0
```

---

## Exercise 4: Complete Project Setup

**Goal:** Set up Django project with proper Docker support

**Time:** ~30 minutes

### Project Structure

```
django-app/
├── Dockerfile
├── docker-compose.yml
├── requirements.txt
├── .dockerignore
├── manage.py
├── app/
│   ├── __init__.py
│   └── views.py
├── templates/
└── static/
```

### Requirements

```bash
# requirements.txt
Django==4.2.0
gunicorn==21.2.0
psycopg2-binary==2.9.9
Pillow==9.5.0
```

### Dockerfile

```dockerfile
FROM python:3.9-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

RUN useradd -m appuser && chown -R appuser:appuser /app
USER appuser

EXPOSE 8000

HEALTHCHECK --interval=30s --timeout=3s \
  CMD curl -f http://localhost:8000/health || exit 1

CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
```

### docker-compose.yml

```yaml
version: '3.8'

services:
  web:
    build: .
    ports:
      - "8000:8000"
    environment:
      - DEBUG=false
      - DB_URL=postgres://user:password@db:5432/myapp
    volumes:
      - ./app:/app
    depends_on:
      - db
    networks:
      - app-network
    deploy:
      resources:
        limits:
          memory: 512M
        reservations:
          memory: 128M

  db:
    image: postgres:13
    environment:
      - POSTGRES_USER=user
      - POSTGRES_PASSWORD=password
      - POSTGRES_DB=myapp
    volumes:
      - db-data:/var/lib/postgresql/data
    networks:
      - app-network

volumes:
  db-data:

networks:
  app-network:
    driver: bridge
```

---

## Exercise 5: Environment-Specific Compose Files

**Goal:** Create development and production configs

**Time:** ~20 minutes

### docker-compose.yml (Base)

```yaml
# docker-compose.yml
version: '3.8'

services:
  web:
    build: .
    ports:
      - "8000:8000"
    environment:
      - DEBUG=${DEBUG:-true}
      - DB_URL=postgres://${POSTGRES_USER:-user}:${POSTGRES_PASSWORD:-password}@db:5432/myapp
    volumes:
      - ./app:/app
    depends_on:
      - db
    networks:
      - app-network

  db:
    image: postgres:13
    environment:
      - POSTGRES_USER=${POSTGRES_USER:-user}
      - POSTGRES_PASSWORD=${POSTGRES_PASSWORD:-password}
      - POSTGRES_DB=myapp
    volumes:
      - db-data:/var/lib/postgresql/data
    networks:
      - app-network

volumes:
  db-data:

networks:
  app-network:
    driver: bridge
```

### .env (Development)

```env
# .env
DEBUG=true
POSTGRES_USER=dev
POSTGRES_PASSWORD=dev123
```

### .env.production (Production)

```env
# .env.production
DEBUG=false
POSTGRES_USER=prod
POSTGRES_PASSWORD=prodsecret123
```

### Run with Different Environments

```bash
# Development
docker compose -f docker-compose.yml -f docker-compose.dev.yml up -d

# Production
docker compose -f docker-compose.yml -f docker-compose.prod.yml up -d
```

---

## Exercise 6: Complete Module 2 Checklist

- [ ] Created basic Dockerfile
- [ ] Built and ran containers
- [ ] Tagged and pushed to ECR
- [ ] Deployed to EC2 (or ECS)
- [ ] Used Docker Compose
- [ ] Created multi-stage build
- [ ] Set up environment variables
- [ ] Created .dockerignore
- [ ] Configured health checks
- [ ] Set up non-root user

---

## Module 2 Complete!

**You've mastered:**
- ✅ Docker fundamentals
- ✅ Image building and optimization
- ✅ Container lifecycle management
- ✅ Dockerfile best practices
- ✅ AWS ECR integration
- ✅ EC2/ECS deployment
- ✅ Docker Compose

**Next Step:** Module 3: CI/CD Fundamentals

---

*Module 2 Complete!*
