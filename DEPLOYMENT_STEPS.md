# Deployment Steps - MEAN Stack App to AWS VM

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
