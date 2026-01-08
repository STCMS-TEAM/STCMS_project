FROM node:18-alpine AS frontend-builder
WORKDIR /build/frontend

# 1. Reach into the subfolder for the package files
COPY frontend/STCMS_app/package*.json ./
RUN npm install

# 2. Copy everything from that subfolder into the container
COPY frontend/STCMS_app/ ./

# 3. Run the build (this creates the /dist folder)
RUN npm run build -- --configuration=production

# --- STAGE 2: Build NestJS ---
FROM node:18-alpine AS backend-builder
WORKDIR /build/backend
COPY backend/package*.json ./
RUN npm install
COPY backend/ ./
RUN npm run build

# --- STAGE 3: Final Monolith Image ---
FROM node:18-alpine
WORKDIR /app

COPY --from=backend-builder /build/backend/dist ./dist
COPY --from=backend-builder /build/backend/node_modules ./node_modules
COPY --from=backend-builder /build/backend/package*.json ./

# --- CRITICAL PATH ADJUSTMENT ---
# Angular builds to dist/[app-name]. 
# Since your folder is STCMS_app, the build usually goes to dist/STCMS_app
COPY --from=frontend-builder /build/frontend/dist/STCMS_app ./client

EXPOSE 3000
CMD ["node", "dist/main"]
