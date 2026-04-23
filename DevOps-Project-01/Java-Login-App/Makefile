# =====================================================
# Makefile - DevOps Automation for Java Login App
# =====================================================
# Usage: make <target>
# Targets: build, test, deploy, kind, etc.
# =====================================================

# Variables
APP_NAME=dptweb
IMAGE_NAME=dptweb
DOCKER_REGISTRY=your-registry.com
FULL_IMAGE=${DOCKER_REGISTRY}/${IMAGE_NAME}

# =====================================================
# Development targets
# =====================================================
.PHONY: help build test run deploy

help:
	@echo "Available targets:"
	@echo "  build       - Build Maven project"
	@echo "  test        - Run tests"
	@echo "  run         - Run application locally"
	@echo "  docker-build  - Build Docker image"
	@echo "  docker-push  - Push Docker image"
	@echo "  kind-create - Create kind cluster"
	@echo "  kind-deploy - Deploy to kind cluster"
	@echo "  kind-clean  - Clean kind cluster"
	@echo "  clean       - Clean build artifacts"

# =====================================================
# Build Maven Project
# =====================================================
build:
	mvn clean package

# =====================================================
# Run Tests
# =====================================================
test:
	mvn test

# =====================================================
# Run Application Locally
# =====================================================
run:
	mvn spring-boot:run

# =====================================================
# Build Docker Image
# =====================================================
docker-build:
	docker build -t ${FULL_IMAGE}:latest .

# =====================================================
# Push Docker Image
# =====================================================
docker-push:
	docker push ${FULL_IMAGE}:latest

# =====================================================
# Deploy to Docker Compose
# =====================================================
deploy: docker-build
	docker-compose up -d

# =====================================================
# Deploy to kind Cluster
# =====================================================
kind-create:
	@echo "Creating kind cluster..."
	kind create cluster --config=k8s-kind/kind.yaml

kind-deploy: kind-create
	@echo "Deploying to kind cluster..."
	docker build -t ${FULL_IMAGE}:latest .
	docker push ${FULL_IMAGE}:latest
	kubectl apply -f k8s/
	@echo "Deployment complete! Access at http://localhost:30080"

# =====================================================
# Clean kind cluster
# =====================================================
kind-clean:
	@echo "Deleting kind cluster..."
	kind delete cluster

# =====================================================
# Clean build artifacts
# =====================================================
clean:
	mvn clean
	rm -rf target/*.war
	rm -rf target/*.jar

# =====================================================
# Stop docker containers
# =====================================================
stop:
	docker-compose down

# =====================================================
# View logs
# =====================================================
logs:
	docker-compose logs -f

# =====================================================
# Show docker stats
# =====================================================
stats:
	docker stats --no-stream
