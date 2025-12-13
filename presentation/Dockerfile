FROM node:20-alpine AS base

WORKDIR /app
COPY . .
RUN npx revealjs-cli --build --location ./dist --open ./index.md

FROM nginx:1.25.3
COPY --from=base /app/dist /usr/share/nginx/html
EXPOSE 80