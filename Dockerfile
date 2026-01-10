# --- STAGE 1: Build Angular ---
FROM node:18-alpine AS frontend-builder
WORKDIR /build/frontend

# Copy package files from the subfolder to the container root
COPY frontend/STCMS_app/package*.json ./
RUN npm install

# Copy everything else from the subfolder
COPY frontend/STCMS_app/ ./

# Run build - If this fails, check if 'src' folder is actually in STCMS_app
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
