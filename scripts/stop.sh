#!/bin/bash

# MLLabForum Shutdown Script
# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}   MLLabForum Infrastructure Shutdown   ${NC}"
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

# Check if any containers are actually running from this compose
RUNNING_CONTAINERS=$(docker-compose ps -q 2>/dev/null | wc -l)
if [ "$RUNNING_CONTAINERS" -eq 0 ]; then
    echo -e "${YELLOW}No services are currently running${NC}\n"
    exit 0
fi

echo -e "${BLUE}Currently running services:${NC}"
docker-compose ps --services 2>/dev/null | head -15
echo ""

echo -e "${YELLOW}Stopping MLLabForum infrastructure...${NC}\n"

# Parse arguments
CLEAN_VOLUMES=false
if [ "$1" == "--clean" ] || [ "$1" == "-c" ]; then
    CLEAN_VOLUMES=true
    echo -e "${YELLOW}⚠ Clean mode: volumes will be removed (all data will be lost!)${NC}\n"
fi

# Stop services
if [ "$CLEAN_VOLUMES" = true ]; then
    docker-compose down -v
else
    docker-compose down
fi

# Check if docker-compose command succeeded
if [ $? -eq 0 ]; then
    echo -e "\n${GREEN}✓ All services stopped successfully!${NC}\n"

    # Show remaining containers (should be none)
    REMAINING=$(docker ps -q)
    if [ -z "$REMAINING" ]; then
        echo -e "${GREEN}No containers remaining${NC}"
    else
        echo -e "${YELLOW}Warning: Some containers still running:${NC}"
        docker ps
    fi

    if [ "$CLEAN_VOLUMES" = true ]; then
        echo -e "\n${YELLOW}Volumes removed. Next start will create fresh databases.${NC}"
    fi

    echo -e "\n${GREEN}========================================${NC}"
    echo -e "${GREEN}   Infrastructure stopped${NC}"
    echo -e "${GREEN}========================================${NC}\n"
else
    echo -e "\n${RED}Error: Failed to stop services${NC}"
    exit 1
fi