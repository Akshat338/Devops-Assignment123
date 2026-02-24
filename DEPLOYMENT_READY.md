# 🎯 MEAN Stack Deployment - Ready to Execute

## Your Setup Information

| Item | Value |
|------|-------|
| **GitHub Repository** | https://github.com/Akshat338/Devops-Assignment123.git |
| **Docker Hub Username** | akshat919 |
| **EC2 Key File** | Akshat.pem (already in your project) |
| **Project Location** | c:\Users\disha\Desktop\crud-dd-task-mean-app |

---

##⚡ Quick Deployment Phases (65 minutes total)

### Phase 0: Pre-Deployment Checklist

✅ **Verify you have:**
- [ ] GitHub repository access: https://github.com/Akshat338/Devops-Assignment123
- [ ] Docker Hub account credentials (akshat919)
- [ ] Docker Hub personal access token saved securely
- [ ] Akshat.pem file in your project directory
- [ ] AWS account ready for EC2 instance

---

### Phase 1: Local Testing (5 minutes)

Test the application locally before deployment:

```bash
cd c:\Users\disha\Desktop\crud-dd-task-mean-app

# Build and run
docker compose up -d --build

# Wait for services to start
echo Waiting 30 seconds...
timeout /t 30

# Verify containers
docker compose ps

# Test the API
curl http://localhost/api/tutorials

# Open browser and test
# Frontend: http://localhost
# API: http://localhost/api/tutorials

# Stop containers
docker compose down
```

**Expected Results:**
- All 4 containers running (mongo, backend, frontend, nginx)
- Frontend loads in browser
- API returns JSON response

---

### Phase 2: GitHub Repository (5 minutes)

Repository is already created and code is ready!

```bash
cd c:\Users\disha\Desktop\crud-dd-task-mean-app

# Verify remote is set correctly
git remote -v
# Should show: https://github.com/Akshat338/Devops-Assignment123.git

# View current status
git status

# All code is already pushed!
# Verify on GitHub: https://github.com/Akshat338/Devops-Assignment123
```

✅ **GitHub repository is ready with:**
- All source code
- Docker configuration
- GitHub Actions CI/CD pipeline
- Complete documentation

---

### Phase 3: Docker Hub Setup (10 minutes)

Your Docker Hub username: **akshat919**

#### Step 3.1: Prepare Docker Hub Token

You have your Docker Hub personal access token set up.

**To get your token:**
1. Go to Docker Hub: https://hub.docker.com
2. Account Settings → Security → Personal access tokens
3. Copy your token (starts with `dckr_pat_`)
4. Keep it secure

#### Step 3.2: Login to Docker Hub

```bash
docker login
# Username: akshat919
# Password: [paste your Docker Hub token here]
```

#### Step 3.3: Build and Push Images

**Backend Image:**
```bash
docker build -t akshat919/crud-dd-backend:latest ./backend
docker push akshat919/crud-dd-backend:latest
```

**Frontend Image:**
```bash
docker build -t akshat919/crud-dd-frontend:latest ./frontend
docker push akshat919/crud-dd-frontend:latest
```

#### Step 3.4: Verify on Docker Hub

Visit: https://hub.docker.com/u/akshat919

You should see:
- `akshat919/crud-dd-backend:latest`
- `akshat919/crud-dd-frontend:latest`

✅ Both images pushed and ready!

---

### Phase 4: AWS EC2 Deployment (25 minutes)

#### Step 4.1: Launch EC2 Instance

1. Go to **AWS Console**: https://console.aws.amazon.com
2. Navigate to **EC2 Dashboard**
3. Click **Launch instances**

**Configuration Settings:**
- **Name**: crud-app (optional)
- **AMI**: Ubuntu 22.04 LTS (free tier eligible)
- **Instance Type**: t3.small (or t2.micro for free tier)
- **Key Pair**: 
  - If you don't have one: Create new EC2 key pair
  - Download immediately and save securely
  - **Note:** You already have Akshat.pem
- **Security Group** (Inbound Rules):
  - SSH (Port 22): Allow from your IP or 0.0.0.0/0
  - HTTP (Port 80): Allow from 0.0.0.0/0
  - HTTPS (Port 443): Allow from 0.0.0.0/0 (optional)
- **Storage**: 20 GB gp3 (default is fine)

Click **Launch instance** and wait for it to be in **Running** state.

#### Step 4.2: Get EC2 Public IP

From EC2 Dashboard:
1. Click on your instance
2. Copy the **Public IPv4 address** (e.g., 52.170.245.123)
3. Save it somewhere safe

#### Step 4.3: Connect to EC2 and Deploy

**From Windows Git Bash or PowerShell:**

```bash
# Navigate to your project directory (where Akshat.pem is)
cd c:\Users\disha\Desktop\crud-dd-task-mean-app

# Change key permissions
chmod 600 Akshat.pem

# SSH into EC2 (replace YOUR_EC2_IP)
ssh -i Akshat.pem ubuntu@YOUR_EC2_IP

# Example:
# ssh -i Akshat.pem ubuntu@52.170.245.123
```

**Once connected to EC2, run the automated deployment:**

```bash
cd /tmp
git clone https://github.com/Akshat338/Devops-Assignment123.git
bash Devops-Assignment123/deploy/deploy.sh akshat919

# The script will:
# 1. Update system packages
# 2. Install Docker and Docker Compose
# 3. Clone your GitHub repository
# 4. Pull Docker images from Docker Hub
# 5. Start all containers
# 6. Verify everything is running
```

**Alternative: Manual Deployment**

If the script fails:

```bash
# Update system
sudo apt update && sudo apt upgrade -y

# Install Docker
sudo apt install -y docker.io docker-compose git curl
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker ubuntu
newgrp docker

# Clone repository
mkdir -p /opt/crud-app && cd /opt/crud-app
git clone https://github.com/Akshat338/Devops-Assignment123.git .

# Set Docker Hub username
export DOCKERHUB_USERNAME=akshat919

# Pull and start application
docker-compose -f docker-compose.prod.yml pull
docker-compose -f docker-compose.prod.yml up -d

# Wait and verify
sleep 20
docker-compose -f docker-compose.prod.yml ps
curl http://localhost/api/tutorials
```

#### Step 4.4: Access Your Application

Open in web browser (replace IP with your EC2 public IP):
```
http://YOUR_EC2_IP/
```

You should see:
- **CRUD Application UI**
- Able to create, read, update, delete tutorials
- Database persisting data

**Example URLs:**
- Frontend: http://52.170.245.123/
- API: http://52.170.245.123/api/tutorials

---

### Phase 5: GitHub Actions CI/CD Setup (10 minutes)

#### Step 5.1: Add GitHub Secrets

Go to: https://github.com/Akshat338/Devops-Assignment123/settings/secrets/actions

Click **New repository secret** for each:

| Secret Name | Value |
|---|---|
| `DOCKERHUB_USERNAME` | akshat919 |
| `DOCKERHUB_TOKEN` | [Your Docker Hub personal access token] |
| `VM_HOST` | [Your EC2 public IP, e.g., 52.170.245.123] |
| `VM_USER` | ubuntu |
| `VM_SSH_KEY` | [Full contents of Akshat.pem file] |
| `VM_PORT` | 22 |

**How to get VM_SSH_KEY:**
```bash
# On your local machine (Windows Git Bash/PowerShell)
cat Akshat.pem
# Copy ENTIRE output including BEGIN and END RSA PRIVATE KEY lines
```

#### Step 5.2: Test the CI/CD Pipeline

Make a small change to trigger the workflow:

```bash
# On your local machine
cd c:\Users\disha\Desktop\crud-dd-task-mean-app

# Make a change (e.g., add a comment to README)
echo "" >> README.md

# Commit and push
git add . && git commit -m "Test CI/CD pipeline" && git push origin main
```

**Watch the pipeline execute:**
1. Go to: https://github.com/Akshat338/Devops-Assignment123/actions
2. You should see "Build and Deploy" workflow running
3. Watch the progress (5-8 minutes total)

#### Step 5.3: Verify Automatic Deployment

After pipeline completes:

```bash
# SSH into EC2
ssh -i Akshat.pem ubuntu@YOUR_EC2_IP

# Check containers are running
docker-compose -f /opt/crud-app/docker-compose.prod.yml ps

# Verify API is responsive
curl http://localhost/api/tutorials
```

✅ **CI/CD is working when:**
- New code pushed → Docker images rebuilt
- Images uploaded to Docker Hub
- EC2 automatically pulls latest images
- Application updated without manual intervention

---

## Final Verification

### Test Everything Works

```bash
# SSH into EC2
ssh -i Akshat.pem ubuntu@YOUR_EC2_IP

# Check containers
docker-compose -f /opt/crud-app/docker-compose.prod.yml ps

# Should output 4 running containers

# Test API endpoints
curl http://localhost/api/tutorials
```

### Browser Testing

Open: **http://YOUR_EC2_IP/**

Test CRUD operations:
1. **View tutorials** - See list
2. **Create** - Add new tutorial
3. **Read** - View details
4. **Update** - Edit tutorial
5. **Delete** - Remove tutorial

---

## 📸 Screenshots for Documentation

Capture and save to `/docs/screenshots/`:

1. GitHub Repository - All code
2. GitHub Actions - Successful run
3. Docker Hub - Pushed images
4. EC2 - Containers running
5. Application UI - Working CRUD
6. API Response - curl output
7. Nginx Config - Reverse proxy
8. Infrastructure overview

---

## 🎉 Success Checklist

- ✅ Code pushed to GitHub
- ✅ Docker images in Docker Hub
- ✅ EC2 instance running
- ✅ All 4 containers on EC2
- ✅ Application accessible at http://EC2_IP
- ✅ API responding with data
- ✅ CRUD operations working
- ✅ GitHub Actions deploying automatically

---

## 📚 Documentation Files

| File | Purpose |
|------|---------|
| **QUICK_START.md** | 5-phase quick reference |
| **SETUP_CHECKLIST.md** | Detailed checklist |
| **DEPLOYMENT_STEPS.md** | Step-by-step guide |
| **DEPLOYMENT_SUMMARY.md** | Project overview |
| **README.md** | Complete architecture |
| **DEPLOYMENT_READY.md** | This file - execution guide |

---

**🚀 Ready to deploy! Start with Phase 1: Local Testing**
