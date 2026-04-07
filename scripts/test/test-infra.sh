#!/bin/bash

# MLLabForum Infrastructure Test Script
# Используется в CI/CD для проверки работоспособности инфраструктуры

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}   MLLabForum Infrastructure Test      ${NC}"
echo -e "${GREEN}========================================${NC}\n"

# Get the directory where the script is located (scripts/test/)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# Go up two levels: scripts/test/ -> scripts/ -> project root
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
COMPOSE_DIR="$PROJECT_ROOT/docker-compose"

if [ ! -d "$COMPOSE_DIR" ]; then
    echo -e "${RED}Error: docker-compose directory not found${NC}"
    exit 1
fi

# Check if docker-compose is available
if ! command -v docker-compose &> /dev/null; then
    echo -e "${RED}Error: docker-compose not found${NC}"
    exit 1
fi

cd "$COMPOSE_DIR"

# 1. Validate docker-compose files
echo -e "${YELLOW}[1/6] Validating docker-compose files...${NC}"
docker-compose config > /dev/null
echo -e "${GREEN}✓ docker-compose files are valid${NC}\n"

# 2. Start infrastructure
echo -e "${YELLOW}[2/6] Starting infrastructure...${NC}"
docker-compose up -d
sleep 10
echo -e "${GREEN}✓ Infrastructure started${NC}\n"

# 3. Check all containers are running
echo -e "${YELLOW}[3/6] Checking container status...${NC}"
TOTAL=$(docker-compose config --services 2>/dev/null | wc -l)
RUNNING=$(docker-compose ps --services --filter "status=running" 2>/dev/null | wc -l)

if [ "$RUNNING" -eq "$TOTAL" ]; then
    echo -e "${GREEN}✓ All $RUNNING/$TOTAL containers are running${NC}\n"
else
    echo -e "${RED}✗ Only $RUNNING/$TOTAL containers running${NC}"
    docker-compose ps
    exit 1
fi

# 4. Check ports
echo -e "${YELLOW}[4/6] Checking ports availability...${NC}"

check_port() {
    local port=$1
    local name=$2
    if timeout 2 bash -c "echo >/dev/tcp/localhost/$port" 2>/dev/null; then
        echo -e "  ${GREEN}✓${NC} $name ($port)"
        return 0
    else
        echo -e "  ${RED}✗${NC} $name ($port)"
        return 1
    fi
}

# PostgreSQL databases
check_port 5433 "PostgreSQL auth-db"
check_port 5434 "PostgreSQL profile-db"
check_port 5435 "PostgreSQL post-db"
check_port 5436 "PostgreSQL analytics-db"
check_port 5437 "PostgreSQL ml-db"
check_port 5438 "PostgreSQL notify-db"
check_port 5439 "PostgreSQL registry-db"

# Redis instances
check_port 6379 "Redis auth-redis"
check_port 6381 "Redis profile-redis"
check_port 6382 "Redis post-redis"
check_port 6383 "Redis ml-redis"
check_port 6384 "Redis notify-redis"

# Other services
check_port 9092 "Kafka"
check_port 2181 "Zookeeper"
check_port 9001 "MinIO Console"
check_port 9090 "Prometheus"
check_port 3000 "Grafana"
check_port 8025 "MailHog"
check_port 80 "NGINX"

echo ""

# 5. Check HTTP endpoints with retry
echo -e "${YELLOW}[5/6] Checking HTTP endpoints...${NC}"

check_http_with_retry() {
    local url=$1
    local name=$2
    local max_attempts=5
    local attempt=1

    while [ $attempt -le $max_attempts ]; do
        if curl -s -f -o /dev/null --max-time 5 "$url" 2>/dev/null; then
            echo -e "  ${GREEN}✓${NC} $name"
            return 0
        fi
        sleep 2
        attempt=$((attempt + 1))
    done
    echo -e "  ${RED}✗${NC} $name"
    return 1
}

check_http_with_retry "http://localhost:9090" "Prometheus"
check_http_with_retry "http://localhost:3000" "Grafana"
check_http_with_retry "http://localhost:8025" "MailHog"
check_http_with_retry "http://localhost:9001" "MinIO Console"
check_http_with_retry "http://localhost" "NGINX"

echo ""

# 6. Stop and clean up
echo -e "${YELLOW}[6/6] Cleaning up...${NC}"
docker-compose down -v
echo -e "${GREEN}✓ Cleanup complete${NC}\n"

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}   All infrastructure tests passed!    ${NC}"
echo -e "${GREEN}========================================${NC}"