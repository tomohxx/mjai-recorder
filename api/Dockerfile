FROM node:lts-alpine AS build-stage
WORKDIR /app
COPY nuxt/package*.json ./
RUN npm install
COPY ./nuxt/ .
RUN npx nuxi build

FROM node:lts-alpine AS production-stage
WORKDIR /app
COPY --from=build-stage /app/.output /app
RUN npm install pg
CMD ["node", "./server/index.mjs"]
