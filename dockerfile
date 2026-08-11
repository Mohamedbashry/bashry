# ---- deps: install prod packages only ----
FROM node:20-alpine AS deps
WORKDIR /app
COPY package*.json ./
RUN npm ci --omit=dev && npm cache clean --force

# ---- runtime: only what you need to run ----
FROM node:20-alpine AS production
WORKDIR /app
ENV NODE_ENV=production

COPY --from=deps /app/node_modules ./node_modules
COPY package*.json ./
COPY index.js ./
COPY public ./public

EXPOSE 3000
CMD ["node", "index.js"]