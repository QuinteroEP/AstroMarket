# Use Node 20 (LTS)
FROM node:20-alpine AS build

WORKDIR /app

# Install deps
COPY package*.json ./
RUN npm install

# Copy full source
COPY . .

# Build Astro
RUN npm run build

# ----------------------
# Final stage: serve static files
FROM node:20-alpine

WORKDIR /app

# Install a small static server
RUN npm install -g serve

# Copy built assets from build stage
COPY --from=build /app/dist ./dist

EXPOSE 4321
CMD ["serve", "-s", "dist", "-l", "4321"]
