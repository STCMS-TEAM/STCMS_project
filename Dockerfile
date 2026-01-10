# --- STAGE 1: Preparazione Frontend ---
FROM node:22.20.0-slim AS frontend-base
WORKDIR /app/frontend
COPY frontend/ ./
WORKDIR /app/frontend/STCMS_app
RUN npm ci

# --- STAGE 2: Preparazione Backend ---
FROM node:22.20.0-slim AS backend-base
WORKDIR /app/backend
COPY backend/package*.json ./
RUN npm install
COPY backend/ ./
RUN npm run build

# --- STAGE 3: Immagine Finale ---
FROM node:22.20.0-slim
WORKDIR /app

# Installiamo 'concurrently' per gestire due processi Node insieme
RUN npm install -g concurrently

# Copiamo tutto dai vari stage
COPY --from=frontend-base /app/frontend /app/frontend
COPY --from=backend-base /app/backend /app/backend

# Espone le porte
EXPOSE 4200
EXPOSE 3000

# Variabili d'ambiente di default (possono essere sovrascritte al run)
ENV NODE_ENV=dev

# Comando per lanciare ENTRAMBI i server
# --host 0.0.0.0 è OBBLIGATORIO per Angular in Docker per essere visto dall'esterno
CMD ["concurrently", \
    "cd /app/frontend/STCMS_app && npm run start -- --host 0.0.0.0 --port 8080", \
    "cd /app/backend && node dist/main"]
