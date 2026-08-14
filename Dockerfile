# Production-ready container for the Vue task list web app.
#
# Multi-stage build:
#   1. node stage  — install dependencies and run `vite build` to compile
#      src/App.vue into a static bundle in /app/dist (index.html + app.js).
#   2. nginx stage — serve the built static files from a minimal image.

# ---------- Build stage ----------
# Vite 6 supports Node ^18 || ^20 || >=22; 20-alpine is an LTS with a small image.
FROM node:20-alpine AS build

WORKDIR /app

# Install dependencies first so layer caching survives source changes.
COPY package.json package-lock.json ./
RUN npm ci

# Compile the app (src/App.vue) into the static bundle under dist/.
COPY . .
RUN npm run build

# ---------- Serve stage ----------
# nginx:alpine is a small (~50MB) production-grade web server image.
FROM nginx:1.27-alpine

# Copy the built static site into nginx's web root.
COPY --from=build /app/dist /usr/share/nginx/html

# Serve with long-lived caching for the immutable static assets
# and no-cache for the entry document, via a minimal server config.
COPY <<'EOF' /etc/nginx/conf.d/default.conf
server {
    listen       80;
    server_name  _;

    root  /usr/share/nginx/html;
    index index.html;

    # The HTML entry must always be revalidated so updates show up.
    location = /index.html {
        add_header Cache-Control "no-cache";
    }

    # Fingerprinted-by-hand static assets: cache aggressively.
    location ~* \.(css|js)$ {
        add_header Cache-Control "public, max-age=31536000, immutable";
    }
}
EOF

# Default HTTP port (matches the k8s Service targetPort).
EXPOSE 80

# Health check so orchestrators can tell the container is serving.
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD wget -q -O /dev/null http://127.0.0.1/ || exit 1

# The official nginx image runs nginx in the foreground by default,
# so no CMD override is required.
