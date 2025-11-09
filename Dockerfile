# Use Debian (glibc) so native prebuilds work and we can install krb5 headers
FROM node:22-bookworm-slim

# Build dependencies for node-gyp + kerberos (GSSAPI)
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3 build-essential pkg-config libkrb5-dev git openssh-client ca-certificates \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Install deps first for better caching
COPY package*.json ./

# Make npm/node-gyp happy
ENV npm_config_python=/usr/bin/python3
ENV NPM_CONFIG_LEGACY_PEER_DEPS=true

# Prefer lockfile when present, fall back to install
RUN npm ci || npm install

# Bring in the rest of the source
COPY . .

# Build if you have a build script; otherwise no-op
RUN npm run build || echo "No build step"

EXPOSE 3000
CMD ["npm", "start"]
