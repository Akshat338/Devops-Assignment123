#!/usr/bin/env bash
set -euo pipefail

PROJECT_DIR="/opt/crud-dd-task-mean-app"

cd "$PROJECT_DIR"

docker compose -f docker-compose.prod.yml pull
docker compose -f docker-compose.prod.yml up -d --remove-orphans
