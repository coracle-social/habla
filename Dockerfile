# Habla is a static SPA: Node builds build/client, nginx serves it.

FROM node:26-alpine AS build
# Node 25+ no longer bundles corepack. It installs the pnpm pinned by
# package.json's packageManager, so the version lives in one place.
ENV COREPACK_ENABLE_DOWNLOAD_PROMPT=0
RUN npm install -g corepack && corepack enable
WORKDIR /app
COPY package.json pnpm-lock.yaml ./
RUN pnpm install --frozen-lockfile
COPY . .
RUN pnpm build

FROM nginx:stable-alpine
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=build /app/build/client /usr/share/nginx/html
EXPOSE 3000
