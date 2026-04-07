#!/bin/bash

# MLLabForum Startup Script
# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}   MLLabForum Infrastructure Startup   ${NC}"
echo -e "${BLUE}========================================${NC}\n"

# Get the directory where the script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
COMPOSE_DIR="$SCRIPT_DIR/../docker-compose"

# Check if docker-compose directory exists
if [ ! -d "$COMPOSE_DIR" ]; then
    echo -e "${RED}Error: docker-compose directory not found at $COMPOSE_DIR${NC}"
    exit 1
fi

# Navigate to docker-compose directory
cd "$COMPOSE_DIR"

# Check if .env file exists
if [ ! -f "$SCRIPT_DIR/../.env" ]; then
    echo -e "${YELLOW}Warning: .env file not found${NC}"
    echo -e "Creating from .env.example...\n"
    cp "$SCRIPT_DIR/../.env.example" "$SCRIPT_DIR/../.env"
fi

# Check if any containers are actually running from this compose
RUNNING_CONTAINERS=$(docker-compose ps -q 2>/dev/null | wc -l)
if [ "$RUNNING_CONTAINERS" -gt 0 ]; then
    echo -e "${YELLOW}⚠ Some services are already running${NC}"
    echo -e "${YELLOW}Use './stop.sh' first if you want to restart${NC}\n"
    docker-compose ps
    exit 0
fi

echo -e "${YELLOW}Starting MLLabForum infrastructure...${NC}\n"

# Start all services
docker-compose up -d

# Check if docker-compose command succeeded
if [ $? -eq 0 ]; then
    echo -e "\n${GREEN}✓ All services started successfully!${NC}\n"

    # Wait for services to be ready
    echo -e "${YELLOW}Waiting for services to be ready...${NC}"
    sleep 10

    # Show status
    echo -e "\n${BLUE}Current services status:${NC}\n"
    docker-compose ps

    echo -e "\n${GREEN}========================================${NC}"
    echo -e "${GREEN}   Services are running!${NC}"
    echo -e "${GREEN}========================================${NC}"
    echo -e "\n${YELLOW}Access points:${NC}"
    echo -e "  PostgreSQL auth-db:     ${GREEN}localhost:5433${NC}"
    echo -e "  PostgreSQL profile-db:  ${GREEN}localhost:5434${NC}"
    echo -e "  PostgreSQL post-db:     ${GREEN}localhost:5435${NC}"
    echo -e "  PostgreSQL analytics-db:${GREEN}localhost:5436${NC}"
    echo -e "  PostgreSQL ml-db:       ${GREEN}localhost:5437${NC}"
    echo -e "  PostgreSQL notify-db:   ${GREEN}localhost:5438${NC}"
    echo -e "  PostgreSQL registry-db: ${GREEN}localhost:5439${NC}"
    echo -e "  Redis auth-redis:       ${GREEN}localhost:6379${NC}"
    echo -e "  Redis profile-redis:    ${GREEN}localhost:6381${NC}"
    echo -e "  Redis post-redis:       ${GREEN}localhost:6382${NC}"
    echo -e "  Redis ml-redis:         ${GREEN}localhost:6383${NC}"
    echo -e "  Redis notify-redis:     ${GREEN}localhost:6384${NC}"
    echo -e "  Kafka:                  ${GREEN}localhost:9092${NC}"
    echo -e "  Eureka Server:          ${GREEN}http://localhost:8761${NC}"
    echo -e "  Config Server:          ${GREEN}http://localhost:8888${NC}"
    echo -e "  MinIO:                  ${GREEN}http://localhost:9001${NC} (minioadmin/minioadmin)"
    echo -e "  Prometheus:             ${GREEN}http://localhost:9090${NC}"
    echo -e "  Grafana:                ${GREEN}http://localhost:3000${NC} (admin/admin)"
    echo -e "  Loki:                   ${GREEN}http://localhost:3100${NC}"
    echo -e "  Jaeger:                 ${GREEN}http://localhost:16686${NC}"
    echo -e "  MailHog:                ${GREEN}http://localhost:8025${NC}"
    echo -e "\n${YELLOW}Use './stop.sh' to stop all services${NC}"
    echo -e "${YELLOW}Use './status.sh' to check service status${NC}\n"
else
    echo -e "\n${RED}Error: Failed to start services${NC}"
    exit 1
fi