#!/usr/bin/env bash

# MEAN Stack CRUD Application - Deployment Script
# This script deploys the application on AWS EC2

set -euo pipefail

PROJECT_DIR="/opt/crud-app"
DOCKER_USERNAME="${1:-your-dockerhub-username}"

# Update system
sudo apt update && sudo apt upgrade -y

# Install Docker
sudo apt install -y docker.io docker-compose git curl
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker ubuntu

# Setup application
mkdir -p $PROJECT_DIR && cd $PROJECT_DIR
git clone https://github.com/your-username/crud-dd-task-mean-app.git . || git pull origin main

# Deploy
export DOCKERHUB_USERNAME=$DOCKER_USERNAME
docker compose -f docker-compose.prod.yml pull
docker compose -f docker-compose.prod.yml up -d --remove-orphans

# Verify
sleep 30
docker compose -f docker-compose.prod.yml ps
curl -f http://localhost/api/tutorials && echo "✓ Application healthy!" || echo "⚠ Still starting..."
