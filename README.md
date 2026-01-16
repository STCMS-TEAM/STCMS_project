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

🚀 Quick Start1. PrerequisitesMake sure you have Docker Desktop installed and running.2. Configure Environment VariablesCreate a file named .env in the root folder and paste the following template. You can change these values as needed:Snippet di codice# --- Server Configuration ---
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
3. Build and RunOpen your terminal in the root folder and run:Bashdocker-compose up --build -d
4. Access the ApplicationOnce the containers are running:Frontend UI: Visit http://localhost:8000API Documentation: The API is accessible via http://localhost:8000/api🛠 Architecture DetailsMonolith Container (app-stcms): This container runs the NestJS server. It also hosts the compiled Angular static files.Database Container (db-stcms): A dedicated MongoDB instance.Internal Networking: The API connects to the database using the internal Docker DNS name mongo.Port Mapping: Port 8000 on your computer is mapped to port 3000 inside the API container.📑 Useful CommandsActionCommandView Logsdocker-compose logs -f apiCheck Container Statusdocker psStop All Servicesdocker-compose downReset Databasedocker-compose down -v (Warning: deletes data)⚠️ Common IssuesPort Conflict: If port 8000 is already in use, change SERVER_DEV_PORT in your .env file.Database Connection: If the API starts before the DB is ready, it may restart once. This is normal due to the restart: always policy.
---

### One final tip for GitHub
Since your `.env` file contains passwords, you should **never** upload the actual `.env` file to GitHub. Instead:
1. Create a file called `.env.example` with the same keys but empty values.
2. Add `.env` to a file called `.gitignore` so it doesn't get uploaded.

**Would you like me to create the `.gitignore` file for you as well?**



