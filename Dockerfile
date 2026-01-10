# --- STAGE 1: Build Angular ---
FROM node:22.20.0-slim AS frontend-builder
WORKDIR /build/frontend

# 1. Copy the WHOLE frontend folder (maintaining the STCMS_app structure)
COPY frontend/ ./

# 2. Move into the actual app folder where package.json lives
WORKDIR /build/frontend/STCMS_app

# 3. Now run the commands inside that specific folder
RUN npm install
RUN npm run build -- --configuration=production

# --- STAGE 2: Build NestJS ---
FROM node:22.20.0-slim AS backend-builder
WORKDIR /build/backend
COPY backend/package*.json ./
RUN npm install
COPY backend/ ./
RUN npm run build

# --- STAGE 3: Final Monolith Image ---
FROM node:22.20.0-slim
WORKDIR /app

# Set production environment
ENV NODE_ENV=production

# Copy Backend
COPY --from=backend-builder /build/backend/dist ./dist
COPY --from=backend-builder /build/backend/node_modules ./node_modules
COPY --from=backend-builder /build/backend/package*.json ./

# Copy Frontend (The /browser part is the most common fix needed)
# Try /dist/STCMS_app/browser first if /dist/STCMS_app doesn't work
COPY --from=frontend-builder /build/frontend/dist/STCMS_app/browser ./client

EXPOSE 3000

# Start the NestJS server
CMD ["node", "dist/main"]
