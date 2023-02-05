FROM node:lts-alpine as build-stage
WORKDIR /app
COPY nuxt/package*.json ./
RUN npm install
COPY ./nuxt/ .
RUN npx nuxi build

FROM node:lts-alpine as production-stage
WORKDIR /app
COPY --from=build-stage /app/.output /app
RUN npm install pg
CMD ["node", "./server/index.mjs"]
