# Use Node 22 to satisfy engine requirements
FROM node:22-alpine

# node-gyp build deps
RUN apk add --no-cache python3 make g++ pkgconfig libc6-compat

WORKDIR /app

# Install deps first (better caching)
COPY package*.json ./
# Use python3 for node-gyp and make peer-deps lenient
ENV npm_config_python=/usr/bin/python3
ENV NPM_CONFIG_LEGACY_PEER_DEPS=true

# If you need devDeps to build, keep this as plain install:
RUN npm ci || npm install

# Copy the rest
COPY . .

# Try to build if your project has a build script; otherwise no-op
RUN npm run build || echo "No build step"

EXPOSE 3000
CMD ["npm", "start"]
