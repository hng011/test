# Production-ready container for the Vue task list static site.
#
# The app is fully static: Vue 3 is loaded from a CDN in index.html and
# app.js/styles.css are plain files. There is no package.json, bundler,
# or compile step, so a multi-stage build would add a stage with nothing
# to build. The final image is therefore a single, minimal nginx stage.

# nginx:alpine is a small (~50MB) production-grade web server image.
FROM nginx:1.27-alpine

# Copy the static site into nginx's web root.
COPY index.html /usr/share/nginx/html/index.html
COPY styles.css  /usr/share/nginx/html/styles.css
COPY app.js      /usr/share/nginx/html/app.js

# Serve with long-lived caching for the immutable-ish static assets
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

# Default HTTP port.
EXPOSE 80

# Health check so orchestrators can tell the container is serving.
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD wget -q -O /dev/null http://127.0.0.1/ || exit 1

# The official nginx image runs nginx in the foreground by default,
# so no CMD override is required.
