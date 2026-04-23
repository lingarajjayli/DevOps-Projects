#!/bin/bash
# =====================================================
# Quick Start Script - Java Login App
# =====================================================
# Usage: ./start.sh
# =====================================================

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}======================================${NC}"
echo -e "${GREEN}  Java Login App - Quick Start        ${NC}"
echo -e "${GREEN}======================================${NC}"
echo ""

# Check if .env exists
if [ ! -f .env ]; then
    echo -e "${YELLOW}Warning: .env file not found!${NC}"
    echo "Please create .env file with your database credentials."
    echo ""
    echo "Example .env file:"
    echo "DB_URL=jdbc:mysql://your-db-host:3306/UserDB"
    echo "DB_USERNAME=admin"
    echo "DB_PASSWORD=your_password"
    echo ""
    read -p "Press Enter to continue or Ctrl+C to exit..."
fi

# Check Docker
if ! command -v docker &> /dev/null; then
    echo -e "${RED}Error: Docker is not installed. Please install Docker first.${NC}"
    exit 1
fi

echo -e "${GREEN}✓ Docker is installed${NC}"

# Check if kind is installed
if command -v kind &> /dev/null; then
    echo -e "${GREEN}✓ kind is installed${NC}"
    KIND_AVAILABLE=true
else
    echo -e "${YELLOW}⚠ kind is not installed (optional)${NC}"
    KIND_AVAILABLE=false
fi

# Check if kubectl is installed
if ! command -v kubectl &> /dev/null; then
    echo -e "${RED}Error: kubectl is not installed. Please install kubectl for k8s deployment.${NC}"
    exit 1
fi

echo -e "${GREEN}✓ kubectl is installed${NC}"
echo ""

# Menu
echo -e "${GREEN}Select an option:${NC}"
echo "  1. Build Docker image and run with Docker Compose"
echo "  2. Create kind cluster and deploy"
echo "  3. Clean all containers and clusters"
echo "  4. View logs"
echo "  5. Stop containers"
echo "  0. Exit"
echo ""

read -p "Enter your choice: " choice

case $choice in
    1)
        echo -e "${GREEN}Building Docker image...${NC}"
        make docker-build

        echo -e "${GREEN}Starting Docker Compose...${NC}"
        make deploy

        echo ""
        echo -e "${GREEN}Application is running at: http://localhost:8080${NC}"
        echo -e "${GREEN}MySQL is running at: localhost:3306${NC}"
        ;;
    2)
        if [ "$KIND_AVAILABLE" = true ]; then
            echo -e "${GREEN}Creating kind cluster...${NC}"
            make kind-create

            echo -e "${GREEN}Deploying to kind cluster...${NC}"
            make kind-deploy

            echo ""
            echo -e "${GREEN}Deployment complete!${NC}"
            echo -e "${GREEN}Access application at: http://localhost:32000${NC}"
        else
            echo -e "${RED}kind is not installed. Install kind first:${NC}"
            echo "  curl -Lo ./kind https://kind.sigs.k8s.io/dl/latest/darwin-amd64"
            echo ""
            read -p "Press Enter to exit..."
        fi
        ;;
    3)
        echo -e "${YELLOW}Stopping and cleaning...${NC}"
        make stop
        make kind-clean
        echo ""
        echo -e "${GREEN}All containers and clusters stopped.${NC}"
        ;;
    4)
        echo -e "${GREEN}Viewing logs...${NC}"
        make logs
        ;;
    5)
        echo -e "${YELLOW}Stopping containers...${NC}"
        make stop
        ;;
    0)
        echo "Exiting..."
        exit 0
        ;;
    *)
        echo -e "${RED}Invalid choice. Please try again.${NC}"
        ;;
esac
