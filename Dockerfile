FROM node:20-alpine

WORKDIR /app

# Copy manifests first for better layer caching
COPY package*.json ./

# ✅ Avoid peer-dep conflicts during install
ENV NPM_CONFIG_LEGACY_PEER_DEPS=true
RUN npm install

# Copy the rest
COPY . .

# Build if your project has a build step (safe no-op otherwise)
RUN npm run build || echo "No build step"

EXPOSE 3000
CMD ["npm", "start"]
