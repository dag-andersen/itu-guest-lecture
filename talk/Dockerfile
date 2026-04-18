FROM node:22-alpine AS build
WORKDIR /app
RUN npm install -g @slidev/cli
COPY package.json bun.lock ./
RUN npm install
COPY . .
ENV NODE_OPTIONS="--max-old-space-size=4096"
RUN slidev build --base /

FROM nginx:alpine
COPY --from=build /app/dist /usr/share/nginx/html
EXPOSE 80
