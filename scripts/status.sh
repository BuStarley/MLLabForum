#!/bin/bash

# MLLabForum Status Script
# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}     MLLabForum Status Report          ${NC}"
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

# Check if docker-compose is available
if ! command -v docker-compose &> /dev/null; then
    echo -e "${RED}Error: docker-compose not found${NC}"
    exit 1
fi

# Get service counts - используем правильный подход
TOTAL=$(docker-compose config --services 2>/dev/null | wc -l)

# Считаем контейнеры по статусам
RUNNING_COUNT=$(docker ps --filter "name=mllab" --filter "status=running" -q 2>/dev/null | wc -l)
EXITED_COUNT=$(docker ps --filter "name=mllab" --filter "status=exited" -q 2>/dev/null | wc -l)

if [ "$TOTAL" -eq 0 ]; then
    echo -e "${YELLOW}No services defined or docker-compose not running${NC}"
    exit 0
fi

echo -e "Services: ${GREEN}$RUNNING_COUNT running${NC} / ${RED}$EXITED_COUNT exited${NC} / ${BLUE}$TOTAL total${NC}\n"

# Show all services with status
echo -e "${BLUE}Service Status:${NC}\n"
docker-compose ps --format "table {{.Name}}\t{{.Status}}\t{{.Ports}}"

echo ""

# Show exited containers info (if any)
if [ "$EXITED_COUNT" -gt 0 ]; then
    echo -e "${YELLOW}Exited containers (may be init containers - this is normal):${NC}"
    docker ps -a --filter "name=mllab" --filter "status=exited" --format "table {{.Names}}\t{{.Status}}\t{{.ExitCode}}"
    echo ""
fi

# Check health of critical services
echo -e "${BLUE}Critical Services Health Check:${NC}\n"

# Function to check HTTP endpoint
check_http() {
    local url=$1
    local name=$2
    if curl -s -f -o /dev/null --max-time 5 "$url" 2>/dev/null; then
        echo -e "  ${GREEN}✓${NC} $name"
    else
        echo -e "  ${RED}✗${NC} $name"
    fi
}

# Function to check TCP port
check_tcp() {
    local port=$1
    local name=$2
    if timeout 2 bash -c "echo >/dev/tcp/localhost/$port" 2>/dev/null; then
        echo -e "  ${GREEN}✓${NC} $name"
    else
        echo -e "  ${RED}✗${NC} $name"
    fi
}

# Infrastructure services
check_http "http://localhost:8761" "Eureka Server (8761)"
check_http "http://localhost:8888/actuator/health" "Config Server (8888)"
check_http "http://localhost:9090" "Prometheus (9090)"
check_http "http://localhost:3000" "Grafana (3000)"
check_http "http://localhost:8025" "MailHog (8025)"
check_http "http://localhost:9001" "MinIO Console (9001)"
check_http "http://localhost:16686" "Jaeger (16686)"

# PostgreSQL databases
check_tcp "5433" "PostgreSQL auth-db (5433)"
check_tcp "5434" "PostgreSQL profile-db (5434)"
check_tcp "5435" "PostgreSQL post-db (5435)"
check_tcp "5436" "PostgreSQL analytics-db (5436)"
check_tcp "5437" "PostgreSQL ml-db (5437)"
check_tcp "5438" "PostgreSQL notify-db (5438)"
check_tcp "5439" "PostgreSQL registry-db (5439)"

# Redis instances
check_tcp "6379" "Redis auth-redis (6379)"
check_tcp "6381" "Redis profile-redis (6381)"
check_tcp "6382" "Redis post-redis (6382)"
check_tcp "6383" "Redis ml-redis (6383)"
check_tcp "6384" "Redis notify-redis (6384)"

# Kafka
check_tcp "9092" "Kafka (9092)"

echo ""

# Resource usage
echo -e "${BLUE}Resource Usage:${NC}\n"
docker stats --no-stream --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.NetIO}}" 2>/dev/null | head -20

echo ""

# Docker version info
echo -e "${BLUE}Environment Info:${NC}"
echo -e "  Docker: $(docker --version 2>/dev/null | cut -d' ' -f3 | cut -d',' -f1)"
echo -e "  Docker Compose: $(docker-compose --version 2>/dev/null | cut -d' ' -f3 | cut -d',' -f1)"
echo -e "  Total containers: $(docker ps -a -q 2>/dev/null | wc -l)"
echo -e "  Total images: $(docker images -q 2>/dev/null | wc -l)"

echo -e "\n${GREEN}========================================${NC}"