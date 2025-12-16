FROM node:alpine AS build

COPY ./package.json \
    ./package-lock.json \
    ./tsconfig.json \
    ./tsconfig.app.json \
    ./tsconfig.node.json \
    ./vite.config.ts \
    ./eslint.config.js \
    /app/

COPY ./src/frontend /app/src/frontend

WORKDIR /app
RUN --mount=type=cache,target=/root/.npm \
    npm install .
RUN npm run build

FROM nginxinc/nginx-unprivileged
USER root

# Clean default nginx html folder (run as root to avoid permission errors)
RUN rm -rf /usr/share/nginx/html/*

# Ensure the build-time env is available before using it in COPY
ARG NGINX_ENV="dev"

# Copy built files into nginx and set ownership for the unprivileged nginx user
# Using `--chown` avoids needing an additional `chown` step at runtime.
COPY --from=build --chown=nginx:nginx /app/src/frontend/dist /usr/share/nginx/html

# Copy the selected nginx config into the image at build time. We copy it
# to `default.conf` so nginx has a single active config file inside
# `/etc/nginx/conf.d/`. Keep private certs out of image layers; mount them
# at runtime (dev override or host-managed certs).
COPY ./nginx/nginx-${NGINX_ENV}.conf /etc/nginx/conf.d/default.conf

# Switch back to the unprivileged nginx user provided by the base image
USER nginx

EXPOSE 80
EXPOSE 443
CMD nginx -g "daemon off;"
