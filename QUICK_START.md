# ⚡ QUICK START - 5 Phase Deployment (65 minutes)

**You have everything prepared! Follow these 5 phases to deploy your MEAN stack application.**

---

## Phase 1: Local Test (5 minutes)

```bash
cd c:\Users\disha\Desktop\crud-dd-task-mean-app

# Start locally
docker compose up -d --build

# Wait and test
timeout /t 30
curl http://localhost/api/tutorials

# Open browser: http://localhost

# Cleanup
docker compose down
```

✅ **Done:** Verified local deployment works

---

## Phase 2: GitHub Repository (5 minutes)

```bash
# From project root
git init
git add .
git commit -m "Initial MEAN app with Docker, Nginx, and CI/CD"
git branch -M main

# Create repo at: https://github.com/new
# Name: crud-dd-task-mean-app
# Then run:
git remote add origin https://github.com/<YOUR-USERNAME>/crud-dd-task-mean-app.git
git push -u origin main
```

✅ **Verify:** Check GitHub - all code should be there

---

## Phase 3: Docker Hub (10 minutes)

### 3A: Create Account
- Go to https://hub.docker.com
- Sign up (FREE)
- Verify email, login

### 3B: Create Access Token
- Account Settings → Security → Personal access tokens
- Generate token (copy & save it!)

### 3C: Push Images
```bash
docker login
# Username: your-docker-hub-username
# Password: [paste access token]

docker build -t <USERNAME>/crud-dd-backend:latest ./backend
docker push <USERNAME>/crud-dd-backend:latest

docker build -t <USERNAME>/crud-dd-frontend:latest ./frontend
docker push <USERNAME>/crud-dd-frontend:latest
```

✅ **Verify:** Check https://hub.docker.com - both images should be there

---

## Phase 4: AWS EC2 & Deploy (25 minutes)

### 4A: Launch EC2 Instance
1. Go to https://console.aws.amazon.com
2. EC2 → Launch instances
3. **AMI:** Ubuntu 22.04 LTS
4. **Type:** t3.small
5. **Key pair:** Create `crud-app-key` → Download .pem file
6. **Security:** Allow 22, 80, 443
7. Click Launch
8. Wait for "Running" status

### 4B: Get Public IP
- EC2 Dashboard → Instances
- Copy "Public IPv4 address"

### 4C: Connect & Deploy
```bash
# Change key permissions
chmod 600 /path/to/crud-app-key.pem

# SSH into EC2
ssh -i /path/to/crud-app-key.pem ubuntu://YOUR_EC2_IP

# Run automated deployment
cd /tmp
git clone https://github.com/<YOUR-USERNAME>/crud-dd-task-mean-app.git
bash crud-dd-task-mean-app/deploy/deploy.sh <YOUR-DOCKER-USERNAME>
```

### 4D: Manual Alternative (if script fails)
```bash
sudo apt update && sudo apt install -y docker.io docker-compose git
sudo systemctl start docker
sudo usermod -aG docker ubuntu

mkdir -p /opt/crud-app && cd /opt/crud-app
git clone https://github.com/<YOUR-USERNAME>/crud-dd-task-mean-app.git .

export DOCKERHUB_USERNAME=<YOUR-USERNAME>
docker-compose -f docker-compose.prod.yml pull
docker-compose -f docker-compose.prod.yml up -d

# Verify
sleep 20
docker-compose -f docker-compose.prod.yml ps
curl http://localhost/api/tutorials
```

✅ **Verify:** Open http://YOUR_EC2_IP in browser - you should see the app!

---

## Phase 5: GitHub Actions CI/CD (10 minutes)

### 5A: Add GitHub Secrets
1. GitHub repo → Settings → Secrets and variables → Actions
2. Add 6 secrets:

| Secret | Value |
|--------|-------|
| `DOCKERHUB_USERNAME` | Your Docker Hub username |
| `DOCKERHUB_TOKEN` | Your access token |
| `VM_HOST` | Your EC2 public IP (from Phase 4B) |
| `VM_USER` | ubuntu |
| `VM_SSH_KEY` | [Read entire .pem file content] |
| `VM_PORT` | 22 |

**How to get VM_SSH_KEY:**
```bash
# On your local machine
cat /path/to/crud-app-key.pem
# Copy entire output (including BEGIN and END lines)
# Paste into GitHub Secret
```

### 5B: Test Pipeline
```bash
# On your local machine
git pull origin main
echo "# CI/CD Test" >> README.md
git add . && git commit -m "Test CI/CD pipeline" && git push origin main
```

Watch it run:
- GitHub → Actions tab
- Pipeline should complete in 3-5 minutes
- Application automatically updated on EC2!

✅ **Verify:** Pipeline completed successfully

---

## Final Verification

```bash
# SSH into EC2 one more time
ssh -i /path/to/crud-app-key.pem ubuntu@YOUR_EC2_IP

# Check everything
cd /opt/crud-app
docker-compose -f docker-compose.prod.yml ps
curl http://localhost/api/tutorials

# Try CRUD operations
curl -X POST http://localhost/api/tutorials \
  -H "Content-Type: application/json" \
  -d '{"title":"Test","description":"Working!"}'
```

---

## 📸 Screenshots for Documentation

Capture these:
1. GitHub repo with code
2. GitHub Actions workflow success
3. Docker Hub repositories
4. EC2 instance running
5. `docker ps` output on EC2
6. Browser showing app at http://IP
7. API response: `curl http://IP/api/tutorials`
8. Infrastructure overview

---

## 🎉 Success! You're Done!

Your MEAN stack application is now:
- ✅ Containerized with Docker
- ✅ Deployed on AWS EC2
- ✅ Running with Nginx reverse proxy
- ✅ Connected to MongoDB
- ✅ Automated with GitHub Actions CI/CD
- ✅ Accessible at http://YOUR_EC2_IP

---

## Common Issues? Check These Commands

```bash
# Can't SSH into EC2?
# Check security group allows port 22
# Make sure key permissions: chmod 600 key.pem

# Docker not installed?
sudo systemctl status docker
sudo systemctl start docker

# App not accessible on port 80?
docker-compose -f docker-compose.prod.yml restart nginx

# API not responding?
docker-compose -f docker-compose.prod.yml logs backend

# MongoDB not working?
docker-compose -f docker-compose.prod.yml logs mongo
```

---

## 📚 Full Documentation

- **README.md** - Complete architecture & setup guide
- **DEPLOYMENT_STEPS.md** - Detailed step-by-step instructions
- **SETUP_CHECKLIST.md** - Complete checklist with all details
- **DEPLOYMENT_SUMMARY.md** - Project overview & resources

---

**Follow these 5 phases and you'll have a production-ready MEAN stack deployment! 🚀**

Need help? Check the detailed documentation files above.
