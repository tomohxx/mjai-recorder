FROM node:lts-alpine as build-stage
WORKDIR /app
COPY nuxt/package*.json ./
RUN npm install
COPY ./nuxt/ .
RUN npx nuxi build

FROM node:lts-alpine as production-stage
RUN mkdir /app
COPY --from=build-stage /app/.output /app
CMD ["node", "/app/server/index.mjs"]
