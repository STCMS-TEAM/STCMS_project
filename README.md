Here is the complete **README.md** file tailored specifically for your folder structure. I have added clear sections so your friends (or anyone on GitHub) can get the project running in minutes.

You can copy the block below and save it as `README.md`.

---

```markdown
# STCMS - Tournament Management System

This repository contains a full-stack tournament management system containerized with Docker. It features a **NestJS** backend, an **Angular** frontend, and a **MongoDB** database.

## 📂 Project Structure

To ensure the Docker build works correctly, please keep the following structure:

```text
.
├── STCMS_Backend/       # NestJS source code
├── STCMS_frontend/      # Angular source code
├── Dockerfile           # Multi-stage build for API + UI
├── docker-compose.yml   # Orchestration for API and Mongo
└── .env                 # Environment variables (to be created)

```

---

## 🚀 Quick Start

### 1. Prerequisites

Make sure you have [Docker Desktop](https://www.docker.com/products/docker-desktop/) installed and running.

### 2. Configure Environment Variables

Create a file named `.env` in the root folder and paste the following template. You can change these values as needed:

```env
# --- Server Configuration ---
SERVER_DEV_PORT=8000
NODE_ENV=production
JWT_SECRET=your_super_secret_key_change_this

# --- MongoDB Configuration ---
MONGO_USERNAME=stcms_user
MONGO_PASSWORD=stcms_password
MONGO_PORT=27017

# --- Initial Admin Setup ---
ADMIN_EMAIL=admin@example.com
ADMIN_PASSWORD=AdminPassword123
ADMIN_NAME=Admin
ADMIN_LASTNAME=User

```

### 3. Build and Run

Open your terminal in the root folder and run:

```bash
docker-compose up --build -d

```

### 4. Access the Application

Once the containers are running:

* **Frontend UI:** Visit [http://localhost:8000](https://www.google.com/search?q=http://localhost:8000)
* **API Documentation:** The API is accessible via [http://localhost:8000/api](https://www.google.com/search?q=http://localhost:8000/api)

---

## 🛠 Architecture Details

* **Monolith Container (`app-stcms`):** This container runs the NestJS server. It also hosts the compiled Angular static files.
* **Database Container (`db-stcms`):** A dedicated MongoDB instance.
* **Internal Networking:** The API connects to the database using the internal Docker DNS name `mongo`.
* **Port Mapping:** Port `8000` on your computer is mapped to port `3000` inside the API container.

---

## 📑 Useful Commands

| Action | Command |
| --- | --- |
| **View Logs** | `docker-compose logs -f api` |
| **Check Container Status** | `docker ps` |
| **Stop All Services** | `docker-compose down` |
| **Reset Database** | `docker-compose down -v` (Warning: deletes data) |

---

## ⚠️ Common Issues

* **Port Conflict:** If port 8000 is already in use, change `SERVER_DEV_PORT` in your `.env` file.
* **Database Connection:** If the API starts before the DB is ready, it may restart once. This is normal due to the `restart: always` policy.

```

---

### One final tip for GitHub
Since your `.env` file contains passwords, you should **never** upload the actual `.env` file to GitHub. Instead:
1. Create a file called `.env.example` with the same keys but empty values.
2. Add `.env` to a file called `.gitignore` so it doesn't get uploaded.

**Would you like me to create the `.gitignore` file for you as well?**

```
