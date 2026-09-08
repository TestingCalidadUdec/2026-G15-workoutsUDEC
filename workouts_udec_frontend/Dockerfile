# ===== Etapa 1: build =====
# Imagen con Node completo, solo para compilar. No viaja a producción.
FROM node:20-alpine AS builder
WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .

# Vite incrusta las variables VITE_* en el bundle al momento del build,
# no en tiempo de ejecución. Por eso va como build arg, y por eso queda
# relativa (/api): nginx la reescribe hacia el backend, sin acoplar la
# imagen a un puerto de host específico.
ARG VITE_API_BASE_URL=/api
ENV VITE_API_BASE_URL=$VITE_API_BASE_URL
RUN npm run build

# ===== Etapa 2: producción =====
# Imagen ligera, solo el estático + nginx. Sin node_modules ni código fuente.
# nginx-unprivileged corre como usuario no-root desde el arranque.
FROM nginxinc/nginx-unprivileged:1.27-alpine AS production

COPY --from=builder /app/dist /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 8080

HEALTHCHECK --interval=10s --timeout=5s --start-period=10s --retries=5 \
    CMD wget -qO- http://127.0.0.1:8080/ || exit 1
