FROM node:21-alpine3.18 AS builder
WORKDIR /youtube-live-app
COPY . .
RUN npm ci --silent
RUN npm run build
RUN npm prune --omit=dev

FROM node:21-alpine3.18 AS runner
WORKDIR /youtube-live-app

COPY --from=builder /youtube-live-app/.next /youtube-live-app/.next
COPY --from=builder /youtube-live-app/node_modules /youtube-live-app/node_modules
COPY --from=builder /youtube-live-app/package.json /youtube-live-app/
COPY --from=builder /youtube-live-app/public /youtube-live-app/public

ENV PORT 80
EXPOSE 80

ENTRYPOINT ["npm", "start"]

