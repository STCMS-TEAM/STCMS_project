
# --- Stage 1: Build Angular ---

FROM node:20-alpine AS angular-build

WORKDIR /app/frontend

COPY STCMS_frontend/STCMS_app/package*.json ./

RUN npm install

COPY STCMS_frontend/STCMS_app/ ./

RUN npm run build -- --configuration production



# --- Stage 2: Build NestJS ---

FROM node:20-alpine AS nest-build

WORKDIR /app/backend

COPY STCMS_Backend/package*.json ./

RUN npm install

COPY STCMS_Backend/ ./

# Copy Angular build to a temp location

COPY --from=angular-build /app/frontend/dist/STCMS_app/browser /app/browser

RUN npm run build



# --- Stage 3: Run ---

FROM node:20-alpine

WORKDIR /app

COPY --from=nest-build /app/backend/dist ./dist

COPY --from=nest-build /app/backend/node_modules ./node_modules

COPY --from=nest-build /app/browser ./browser



EXPOSE 3000

CMD ["node", "dist/main.js"]
