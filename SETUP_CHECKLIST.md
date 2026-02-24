# 📋 MEAN Stack Deployment - Complete Checklist & Instructions

This document provides a complete checklist and step-by-step instructions for deploying your MEAN stack CRUD application with CI/CD and cloud infrastructure.

## ✅ What's Already Done

Your project now has:

1. ✅ **Docker Setup**
   - Backend Dockerfile (Node.js multi-stage build)
   - Frontend Dockerfile (Angular multi-stage build)
   - Docker Compose files (development and production)
   - MongoDB service with persistent volume

2. ✅ **Nginx Reverse Proxy**
   - Configuration routing `/api/*` to backend and `/` to frontend
   - Single entry point on port 80

3. ✅ **GitHub Actions CI/CD Pipeline**
   - `.github/workflows/deploy.yml` - Automated build, push, and deploy workflow
   - Builds Docker images on every push to main
   - Pushes images to Docker Hub

4. ✅ **Documentation**
   - Comprehensive README.md with setup and deployment instructions
   - DEPLOYMENT_STEPS.md with detailed steps
   - Automated deployment script (deploy/deploy.sh)

5. ✅ **Git Configuration**
   - .gitignore file for ignoring dependencies and artifacts

---

## 🚀 Step-by-Step Execution Guide

### Phase 1: Local Setup & Testing (5 minutes)

#### 1.1 Test Local Deployment

```bash
# Navigate to project directory
cd c:\Users\disha\Desktop\crud-dd-task-mean-app

# Start application locally
docker compose up -d --build

# Wait for containers to start
timeout /t 30

# Check containers are running
docker compose ps

# Test the application
# Frontend: http://localhost
# API: http://localhost/api/tutorials

# Clean up
docker compose down
```

**Expected Result:** 
- All 4 containers running (mongo, backend, frontend, nginx)
- Frontend accessible at http://localhost
- API responding at http://localhost/api/tutorials

---

### Phase 2: GitHub Repository Setup (5 minutes)

#### 2.1 Initialize Git Repository

```bash
# Navigate to project
cd c:\Users\disha\Desktop\crud-dd-task-mean-app

# Initialize git
git init

# Add all files
git add .

# Create first commit
git commit -m "Initial MEAN app with Docker, Nginx, and CI/CD"

# Rename main branch
git branch -M main
```

#### 2.2 Create GitHub Repository

1. Go to https://github.com/new
2. **Note:** Repository is already created at: https://github.com/Akshat338/Devops-Assignment123.git
3. You can proceed directly to pushing code

#### 2.3 Push to GitHub

```bash
# Repository already exists
git push -u origin main

# Verify by checking GitHub
# You should see all files including:
# - backend/, frontend/, nginx/ directories
# - .github/workflows/deploy.yml
# - docker-compose.yml and docker-compose.prod.yml
# - README.md and other documentation
```

**Result:** Repository successfully created and code pushed to GitHub

---

### Phase 3: Docker Hub Setup (10 minutes)

#### 3.1 Create Docker Hub Account

1. Go to https://hub.docker.com
2. Sign up for a **FREE** account
3. Verify your email
4. Log in to Docker Hub

#### 3.2 Create Personal Access Token

1. Click your profile icon (top right)
2. Go to **Account Settings**
3. Click **Security** in the left menu
4. Click **New Access Token**
5. Name it: `github-actions-token`
6. Select **Read & Write** permissions
7. Click **Generate**
8. **COPY AND SAVE** the token (you won't see it again!)

#### 3.3 Build and Push Images (First Time)

```bash
# Log in to Docker Hub
docker login
# Username: akshat919
# Password: [paste your actual Docker Hub token - do not commit tokens!]

# Build backend image
docker build -t akshat919/crud-dd-backend:latest ./backend
docker push akshat919/crud-dd-backend:latest

# Build frontend image  
docker build -t akshat919/crud-dd-frontend:latest ./frontend
docker push akshat919/crud-dd-frontend:latest

# Verify images on Docker Hub
# Visit https://hub.docker.com/u/akshat919
# You should see both repositories with "latest" tag
```

**Result:** Both images pushed to Docker Hub and ready for deployment

---

### Phase 4: AWS EC2 Setup (15 minutes)

#### 4.1 Launch EC2 Instance

1. Log in to AWS Console (https://console.aws.amazon.com)
2. Go to **EC2** → **Instances**
3. Click **"Launch instances"**

**Configuration:**
- **Name:** `crud-app` (optional)
- **AMI:** Select "Ubuntu 22.04 LTS" (free tier eligible)
- **Instance type:** `t3.small` (or t2.micro for free tier)
- **Key pair:** 
  - If new: Click "Create new key pair"
  - Name: `crud-app-key`
  - Type: RSA
  - Format: .pem
  - Click "Create key pair" and **DOWNLOAD** immediately
- **Network settings:**
  - Click "Create security group" or "Select existing"
  - Inbound rules:
    - SSH (22) - from your IP or 0.0.0.0/0
    - HTTP (80) - from 0.0.0.0/0
    - HTTPS (443) - from 0.0.0.0/0 (optional)
- **Storage:** 20 GB gp3 (default)
- Click **"Launch instance"**

Wait for instance to be in **"Running"** state.

#### 4.2 Connect to EC2 Instance

Get your instance's **Public IPv4 address** from the EC2 dashboard.

**Using Windows Git Bash:**
```bash
# Change key permissions
chmod 600 Akshat.pem

# Connect via SSH (replace IP with your instance IP)
ssh -i Akshat.pem ubuntu@YOUR_EC2_PUBLIC_IP

# Example:
# ssh -i Akshat.pem ubuntu@52.170.245.123
```

#### 4.3 One-Click Automated Setup

Once connected to EC2, run:

```bash
# Clone repository
cd /tmp
git clone https://github.com/Akshat338/Devops-Assignment123.git
cd Devops-Assignment123

# Run deployment script
bash deploy/deploy.sh akshat919

# Example:
# bash deploy/deploy.sh akshat919
```

**OR manually:**

```bash
# Update system
sudo apt update && sudo apt upgrade -y

# Install Docker
sudo apt install -y docker.io docker-compose git curl
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker ubuntu
newgrp docker

# Clone and deploy
mkdir -p /opt/crud-app && cd /opt/crud-app
git clone https://github.com/Akshat338/Devops-Assignment123.git .

# Start application
export DOCKERHUB_USERNAME=akshat919
docker-compose -f docker-compose.prod.yml pull
docker-compose -f docker-compose.prod.yml up -d

# Check status
sleep 20
docker-compose -f docker-compose.prod.yml ps

# Test API
curl http://localhost/api/tutorials
```

**Result:** Application running on EC2!

#### 4.4 Access Application

Open in browser (replace IP with your EC2 public IP):
```
http://YOUR_EC2_PUBLIC_IP/
```

You should see the CRUD application UI!

---

### Phase 5: GitHub Actions CI/CD Setup (10 minutes)

#### 5.1 Add GitHub Secrets

1. Go to your GitHub repository
2. Settings → **Secrets and variables** → **Actions**
3. Click **"New repository secret"**

Add these 6 secrets:

| Secret Name | Value | Where to Get |
|---|---|---|
| `DOCKERHUB_USERNAME` | akshat919 | Your Docker Hub account |
| `DOCKERHUB_TOKEN` | [Your Docker Hub token] | Docker Hub → Account Settings → Security → Personal access tokens |
| `VM_HOST` | Your EC2 public IP | AWS Console → EC2 → Instances → Public IPv4 address |
| `VM_USER` | `ubuntu` | (Fixed value) |
| `VM_SSH_KEY` | Contents of Akshat.pem file | Read the entire Akshat.pem file contents |
| `VM_PORT` | `22` | (Fixed value) |

**To get VM_SSH_KEY contents:**
- On your local machine, open the Akshat.pem file with a text editor
- Select ALL text (including BEGIN and END lines)
- Copy and paste into the GitHub Secret (VM_SSH_KEY)
- Make sure line breaks are preserved

#### 5.2 Test CI/CD Pipeline

Make a small change to trigger the pipeline:

```bash
# On your local machine
git pull origin main

# Make a small change (e.g., edit README.md)
echo "" >> README.md

# Commit and push
git add .
git commit -m "Trigger CI/CD pipeline"
git push origin main
```

Watch the pipeline run:
1. Go to GitHub repository
2. Click **"Actions"** tab
3. You should see a workflow running
4. Wait 2-3 minutes for completion

**What happens:**
1. **Build job** (1 min) - Builds Docker images
2. **Push job** (2 min) - Pushes images to Docker Hub
3. **Deploy job** (1 min) - SSHes into VM and updates containers
4. **Health check** (30 sec) - Verifies API is working

---

### Phase 6: Verification & Testing (10 minutes)

#### 6.1 Verify Application is Running

**From your local machine:**
```bash
# SSH into EC2
ssh -i /path/to/crud-app-key.pem ubuntu@YOUR_EC2_PUBLIC_IP

# Check containers
cd /opt/crud-app
docker-compose -f docker-compose.prod.yml ps

# Test API
curl http://localhost/api/tutorials

# View logs
docker-compose -f docker-compose.prod.yml logs -f backend
```

#### 6.2 Test Create/Update/Delete Operations

```bash
# Create a tutorial
curl -X POST http://localhost/api/tutorials \
  -H "Content-Type: application/json" \
  -d '{"title":"My Tutorial","description":"Test CRUD"}'

# Get all tutorials
curl http://localhost/api/tutorials

# Update a tutorial (replace ID with actual ID)
curl -X PUT http://localhost/api/tutorials/ID \
  -H "Content-Type: application/json" \
  -d '{"title":"Updated","description":"Updated"}'

# Delete a tutorial
curl -X DELETE http://localhost/api/tutorials/ID
```

#### 6.3 Verify on Web Browser

Open `http://YOUR_EC2_PUBLIC_IP/` and:
- View list of tutorials
- Create a new tutorial
- Edit a tutorial
- Delete a tutorial

---

## 📸 Screenshots to Capture (for documentation)

Capture these for your submission:

1. **GitHub Repository** - Shows code is pushed
2. **GitHub Actions - Workflow Configuration** - Shows deploy.yml
3. **GitHub Actions - Successful Run** - Shows all jobs completed
4. **Docker Hub - Backend Image** - Shows tags pushed
5. **Docker Hub - Frontend Image** - Shows tags pushed
6. **EC2 Instance - Containers Running**
   ```bash
   docker-compose -f docker-compose.prod.yml ps
   ```
7. **EC2 Instance - API Response**
   ```bash
   curl http://localhost/api/tutorials
   ```
8. **Web Browser - Application UI** - Home page of CRUD app
9. **Web Browser - Create Tutorial** - Form to create new entry
10. **Nginx Configuration** - Shows reverse proxy setup
    ```bash
    cat /opt/crud-app/nginx/default.conf
    ```
11. **Application Architecture Diagram** - (Optional, can create with draw.io)

---

## 🚨 Common Issues & Solutions

### Issue: Cannot push to GitHub

```bash
# Update remote URL if using old HTTP
git remote set-url origin https://github.com/<YOUR-USERNAME>/crud-dd-task-mean-app.git

# Try pushing again
git push origin main
```

### Issue: Docker login fails

```bash
# Make sure you're using personal access token, not password
docker logout
docker login
# Username: your-docker-hub-username
# Password/Token: your-personal-access-token
```

### Issue: Cannot SSH into EC2

```bash
# Make sure:
# 1. Security group allows port 22 inbound
# 2. Key permissions are correct
chmod 600 /path/to/crud-app-key.pem

# 3. You're using correct username (ubuntu for Ubuntu AMI)
ssh -i /path/to/crud-app-key.pem ubuntu@YOUR_IP

# If still fails, try verbose mode:
ssh -v -i /path/to/crud-app-key.pem ubuntu@YOUR_IP
```

### Issue: Application not accessible on port 80

```bash
# Check if containers are running
docker-compose -f docker-compose.prod.yml ps

# Check Nginx logs
docker-compose -f docker-compose.prod.yml logs nginx

# Restart Nginx
docker-compose -f docker-compose.prod.yml restart nginx

# Check if port 80 is listening
sudo lsof -i :80
```

### Issue: API not responding

```bash
# Check backend logs
docker-compose -f docker-compose.prod.yml logs backend

# Check MongoDB connection
docker-compose -f docker-compose.prod.yml exec mongo mongosh --eval "db.adminCommand('ping')"

# Verify MongoDB URI
docker-compose -f docker-compose.prod.yml exec backend env | grep MONGODB
```

### Issue: CI/CD Pipeline Fails

Go to GitHub → Actions → Your failed workflow → Check logs:
- **Build errors** - Docker image build failed
- **Push errors** - Docker Hub authentication issue
- **Deploy errors** - SSH connection or deployment script issue

Common fixes:
- Verify all GitHub Secrets are correct
- Check EC2 security group allows SSH (port 22)
- Verify VM_SSH_KEY includes full BEGIN/END lines

---

## 📊 Environment Variables Summary

**Backend:**
- `MONGODB_URI`: mongodb://mongo:27017/dd_db
- `PORT`: 8080
- `NODE_ENV`: production

**Frontend:**
- Built as static files during Docker build
- API calls routed through Nginx to backend

**Docker Compose:**
- `DOCKERHUB_USERNAME`: Used for pulling images from Docker Hub

---

## ✨ Next Steps (Post-Deployment)

1. **Monitor Application**
   ```bash
   ssh -i your-key.pem ubuntu@YOUR_IP
   docker-compose -f /opt/crud-app/docker-compose.prod.yml logs -f
   ```

2. **Set Up Auto-Restart**
   - Containers already configured with `restart: unless-stopped`
   - They'll automatically restart if they crash

3. **Update Application**
   - Simply push to main branch
   - CI/CD pipeline will rebuild and redeploy automatically

4. **Scale Up**
   - Use load balancer (AWS ELB/ALB)
   - Deploy to multiple EC2 instances
   - Use AWS RDS for MongoDB (optional)

5. **Add HTTPS**
   - Use AWS Certificate Manager
   - Update Nginx configuration
   - Or use Let's Encrypt with certbot

6. **Backup Database**
   - Regular MongoDB backups
   - Consider AWS Backup service

---

## 🎉 Success Criteria

You've successfully completed the deployment if:

- ✅ GitHub repository contains all code
- ✅ Docker images built and pushed to Docker Hub
- ✅ EC2 instance running with Docker
- ✅ Application accessible at http://EC2_IP
- ✅ All 4 containers running (mongo, backend, frontend, nginx)
- ✅ API responding at http://EC2_IP/api/tutorials
- ✅ GitHub Actions workflow running automatically
- ✅ Changes pushed to GitHub trigger automatic redeployment
- ✅ CRUD operations working (Create, Read, Update, Delete)
- ✅ MongoDB persisting data across container restarts

---

## 📞 Quick Reference

**Important Commands:**

```bash
# GitHub
git push origin main
git pull origin main

# Docker Local
docker compose up -d --build
docker compose ps
docker compose logs -f
docker compose down

# Docker Hub
docker login
docker build -t username/image:tag .
docker push username/image:tag

# EC2 SSH
ssh -i key.pem ubuntu@IP

# EC2 Management
docker-compose -f docker-compose.prod.yml ps
docker-compose -f docker-compose.prod.yml logs -f
docker-compose -f docker-compose.prod.yml up -d
docker-compose -f docker-compose.prod.yml down

# API Testing
curl http://localhost/api/tutorials
```

---

This completes your complete MEAN stack deployment! 🚀
