# Deployment Steps - MEAN Stack App

## Complete Deployment Guide

This guide covers:
1. GitHub Repository Setup
2. Docker Hub Configuration
3. Local Development
4. AWS EC2 Setup
5. GitHub Actions CI/CD Configuration
6. Verification & Testing
7. Troubleshooting

## 1. GitHub Repository Setup

### Initialize Git Repository

```bash
cd c:\Users\disha\Desktop\crud-dd-task-mean-app
git init
git add .
git commit -m "Initial MEAN app with Docker, Nginx, and CI/CD"
git branch -M main
```

### Create GitHub Repository

1. Go to https://github.com/new
2. Create repository (e.g., `crud-dd-task-mean-app`)
3. Do NOT initialize with README, .gitignore, or license

### Push to GitHub

```bash
git remote add origin https://github.com/<your-username>/crud-dd-task-mean-app.git
git push -u origin main
```

## 2. Docker Hub Configuration

### Create Docker Hub Account

1. Go to https://hub.docker.com
2. Sign up for free account
3. Create Personal Access Token in Account Settings → Security

### Build and Push Images

```bash
docker login
docker build -t <dockerhub-username>/crud-dd-backend:latest ./backend
docker push <dockerhub-username>/crud-dd-backend:latest

docker build -t <dockerhub-username>/crud-dd-frontend:latest ./frontend
docker push <dockerhub-username>/crud-dd-frontend:latest
```

## 3. Local Development

```bash
# Run locally
docker compose up -d --build

# Access at http://localhost
# API at http://localhost/api/tutorials

# Stop
docker compose down
```

## 4. AWS EC2 Setup

### Launch Instance

1. AWS Console → EC2 → Launch instances
2. AMI: Ubuntu 22.04 LTS
3. Instance Type: t3.small
4. Key pair: Create or select existing
5. Security Group: Allow ports 22, 80, 443
6. Storage: 20 GB gp3

### Connect and Setup Docker

```bash
chmod 600 your-key.pem
ssh -i your-key.pem ubuntu@<EC2-PUBLIC-IP>

# Install Docker
sudo apt update && sudo apt install -y docker.io docker-compose git curl
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker ubuntu
newgrp docker
```

### Deploy Application

```bash
mkdir -p /opt/crud-app && cd /opt/crud-app
git clone https://github.com/<your-username>/crud-dd-task-mean-app.git .

export DOCKERHUB_USERNAME=<your-dockerhub-username>
docker-compose -f docker-compose.prod.yml pull
docker-compose -f docker-compose.prod.yml up -d
```

### Access Application

Open browser: `http://<EC2-PUBLIC-IP>`

## 5. GitHub Actions CI/CD Configuration

### Add GitHub Secrets

Go to GitHub repository → Settings → Secrets and variables → Actions

Add:
- `DOCKERHUB_USERNAME` - Your Docker Hub username
- `DOCKERHUB_TOKEN` - Personal access token
- `VM_HOST` - EC2 public IP
- `VM_USER` - ubuntu
- `VM_SSH_KEY` - Contents of .pem file
- `VM_PORT` - 22

### Trigger Pipeline

Push any change to main branch, workflow will:
1. Build Docker images
2. Push to Docker Hub
3. Deploy to VM
4. Health check API

## 6. Verification & Testing

```bash
# SSH into VM
ssh -i your-key.pem ubuntu@<EC2-PUBLIC-IP>

# Check containers
docker-compose -f /opt/crud-app/docker-compose.prod.yml ps

# Test API
curl http://localhost/api/tutorials

# View logs
docker-compose -f /opt/crud-app/docker-compose.prod.yml logs -f backend
```

## 7. Troubleshooting

### Cannot SSH into EC2

```bash
# Check:
# 1. Security group allows port 22
# 2. Key permissions: chmod 600 your-key.pem
# 3. Correct username for AMI (ubuntu, ec2-user, etc)
ssh -v -i your-key.pem ubuntu@<EC2-PUBLIC-IP>
```

### Docker not starting

```bash
sudo systemctl status docker
sudo systemctl start docker
sudo journalctl -u docker -n 50
```

### Application not accessible on port 80

```bash
# Check if port listening
sudo lsof -i :80

# Check Nginx logs
docker-compose -f docker-compose.prod.yml logs nginx

# Restart Nginx
docker-compose -f docker-compose.prod.yml restart nginx
```

### MongoDB connection error

```bash
docker-compose -f docker-compose.prod.yml logs mongo
docker-compose -f docker-compose.prod.yml exec mongo mongosh --eval "db.adminCommand('ping')"
```

### CI/CD Pipeline Failing

Check GitHub Actions logs for:
- Wrong VM_SSH_KEY (missing BEGIN/END lines)
- Incorrect VM_HOST (EC2 IP)
- Security group blocking SSH

## Useful Commands

```bash
# Local
docker compose up -d --build
docker compose ps
docker compose logs -f backend
docker compose down

# VM
ssh -i your-key.pem ubuntu@<IP>
cd /opt/crud-app
docker-compose -f docker-compose.prod.yml ps
docker-compose -f docker-compose.prod.yml logs -f
docker-compose -f docker-compose.prod.yml pull && docker-compose -f docker-compose.prod.yml up -d
```

## Deployment Checklist

- ✅ GitHub repository created
- ✅ Docker Hub account created
- ✅ Docker images pushed
- ✅ AWS EC2 instance launched
- ✅ Docker installed on EC2
- ✅ Application deployed
- ✅ GitHub Secrets configured
- ✅ CI/CD pipeline tested
- ✅ Application accessible
- ✅ API responding

## IMPORTANT: Always navigate to the project folder first!

When you SSH into the VM, you MUST go to `/opt/crud-dd-task-mean-app` before running docker compose.

## Step-by-Step Instructions (Git Bash on Windows)

### Step 1: Navigate to your project directory (Git Bash)
```
cd /c/Users/disha/Desktop/crud-dd-task-mean-app
```

### Step 2: Connect to the VM
```
ssh -i "Akshat.pem" ubuntu@13.63.159.184
```

### Step 3: CRITICAL - Navigate to project directory on VM
```
cd /opt/crud-dd-task-mean-app
```
⚠️ **NEVER run docker compose from your home directory (~)**

### Step 4: Verify Docker is running
```
sudo docker ps
```

If Docker is not running, start it:
```
sudo service docker start
```

### Step 5: Build and start containers
```
sudo docker compose -f docker-compose.yml up -d --build
```

### Step 6: Verify containers are running
```
sudo docker ps
```

You should see 4 containers:
- crud-mongo (MongoDB)
- crud-backend (Node.js API)
- crud-frontend (Angular app)
- crud-nginx (Reverse proxy)

### Step 7: Access the application
Open your browser:
```
http://13.63.159.184/
```

### Step 8: Test the API
```
http://13.63.159.184/api/tutorials
```

## One-liner Command (Runs everything from your machine)

If you want to run the deployment from your local machine without SSH first:
```
ssh -i "Akshat.pem" ubuntu@13.63.159.184 "cd /opt/crud-dd-task-mean-app && sudo docker compose -f docker-compose.yml up -d --build"
```

## Useful Commands

### View logs
```
sudo docker logs crud-nginx
sudo docker logs crud-backend
```

### Stop the application
```
sudo docker compose down
```

### Restart the application
```
sudo docker compose restart
```

## Troubleshooting

### If you get "no such file or directory":
- You're in the wrong directory!
- Run: `cd /opt/crud-dd-task-mean-app` first

### If containers don't start:
```
sudo docker compose logs
