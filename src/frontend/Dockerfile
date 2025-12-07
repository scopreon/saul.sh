FROM node:alpine AS build

COPY ./package.json \
    ./package-lock.json \
    ./tsconfig.json \
    ./tsconfig.app.json \
    ./tsconfig.node.json \
    ./vite.config.ts \
    ./eslint.config.js \
    /app/

COPY ./src /app/src

WORKDIR /app
RUN npm install .
RUN npm run build

FROM nginx:alpine

# Clean default nginx html folder
RUN rm -rf /usr/share/nginx/html/*

# Copy built files into nginx
COPY --from=build /app/src/frontend/dist /usr/share/nginx/html
COPY ./nginx/nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80
CMD nginx -g "daemon off;"
