# MEAN CRUD App - Dockerized Deployment with CI/CD

This repository contains a MEAN stack CRUD application:
- Frontend: Angular 15
- Backend: Node.js + Express
- Database: MongoDB
- Reverse Proxy: Nginx

The app is exposed through port `80` with:
- `/` -> Angular frontend
- `/api/*` -> Node/Express backend

## 1. Repository Setup

Create a new GitHub repository and push this project:

```bash
git init
git add .
git commit -m "Initial MEAN app with Docker, Nginx, and CI/CD"
git branch -M main
git remote add origin https://github.com/<your-username>/<your-repo>.git
git push -u origin main
```

## 2. Local Containerized Run

Run the full stack locally with Docker Compose:

```bash
docker compose up -d --build
```

Open:
- `http://localhost` for UI
- `http://localhost/api/tutorials` for API

Stop:

```bash
docker compose down
```

## 3. Docker Hub Images

Build and push manually (optional, CI/CD also does this):

```bash
docker login
docker build -t <dockerhub-username>/crud-dd-backend:latest ./backend
docker build -t <dockerhub-username>/crud-dd-frontend:latest ./frontend
docker push <dockerhub-username>/crud-dd-backend:latest
docker push <dockerhub-username>/crud-dd-frontend:latest
```

## 4. Ubuntu VM Deployment (AWS EC2 or any cloud VM)

### 4.1 Provision VM
- Ubuntu 22.04 or later
- Open inbound port `80` and `22`
- SSH into VM

### 4.2 Install Docker + Compose

```bash
sudo apt update
sudo apt install -y ca-certificates curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo usermod -aG docker $USER
```

Log out and log in again for docker group changes.

### 4.3 Clone and deploy

```bash
sudo mkdir -p /opt/crud-dd-task-mean-app
sudo chown -R $USER:$USER /opt/crud-dd-task-mean-app
git clone https://github.com/<your-username>/<your-repo>.git /opt/crud-dd-task-mean-app
cd /opt/crud-dd-task-mean-app
cp .env.example .env
```

Update `.env`:

```env
DOCKERHUB_USERNAME=<your-dockerhub-username>
```

Deploy:

```bash
docker login
docker compose -f docker-compose.prod.yml pull
docker compose -f docker-compose.prod.yml up -d --remove-orphans
```

## 5. CI/CD with GitHub Actions

Workflow file: `.github/workflows/cicd.yml`

On push to `main`, it:
1. Builds backend and frontend Docker images
2. Pushes both images to Docker Hub (`latest` and short SHA tag)
3. SSHes into VM and runs `docker compose pull && docker compose up -d`

### 5.1 Required GitHub Secrets

Set these in: `GitHub Repo -> Settings -> Secrets and variables -> Actions`

- `DOCKERHUB_USERNAME`
- `DOCKERHUB_TOKEN`
- `VM_HOST`
- `VM_USER`
- `VM_SSH_KEY`

## 6. Nginx Reverse Proxy

Config file: `nginx/default.conf`

Routing:
- `location /` -> `frontend:80`
- `location /api/` -> `backend:8080`

This ensures the complete application is served from port `80`.

## 7. MongoDB Setup Choice

This project uses the official MongoDB Docker image in Compose:
- Service: `mongo`
- Data persistence: Docker volume `mongo_data`

No direct host MongoDB installation is required.

## 8. Project Files Added for DevOps Task

- `backend/Dockerfile`
- `frontend/Dockerfile`
- `docker-compose.yml`
- `docker-compose.prod.yml`
- `nginx/default.conf`
- `.github/workflows/cicd.yml`
- `deploy/deploy.sh`
- `.env.example`

## 9. Screenshots to Include in Submission

Add screenshots under `docs/screenshots/` and reference them here:

1. CI/CD configuration page (`docs/screenshots/01-github-actions-config.png`)
2. Successful GitHub Actions run (`docs/screenshots/02-github-actions-success.png`)
3. Docker Hub repositories with pushed tags (`docs/screenshots/03-dockerhub-images.png`)
4. VM containers running (`docs/screenshots/04-vm-docker-ps.png`)
5. Application UI on port 80 (`docs/screenshots/05-app-ui.png`)
6. Nginx + infrastructure proof (`docs/screenshots/06-nginx-config-vm.png`)

## 10. Notes

- Frontend API calls are configured via relative path `/api/tutorials` so that Nginx handles routing.
- Backend MongoDB URL is environment-driven via `MONGODB_URI`.
