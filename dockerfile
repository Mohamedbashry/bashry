# ---- Build stage ----
FROM node:20-alpine AS build

WORKDIR /app

# Copy only manifest files first for better layer caching
COPY package*.json ./

RUN npm install

# Now copy the rest of the source and build (if you have a build step)
COPY . .
# RUN npm run build   # uncomment if this is a TS/React/etc project with a build step

# ---- Production stage ----
FROM node:20-alpine AS production

WORKDIR /app
ENV NODE_ENV=production

# Copy only package files, then install prod-only deps fresh (smaller than copying node_modules over)
COPY package*.json ./
RUN npm ci --omit=dev

# Copy built app from the build stage (adjust path if you have a dist/ build output)
COPY --from=build /app .

EXPOSE 3000

CMD ["npm", "start"]