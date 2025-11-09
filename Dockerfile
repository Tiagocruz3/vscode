# Debian (glibc) base so native modules build cleanly
FROM node:22-bookworm-slim

# Build deps for node-gyp + kerberos + X11 (native-keymap) + pkg-config
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3 build-essential pkg-config git openssh-client ca-certificates \
    libkrb5-dev \
    libx11-dev libxkbfile-dev \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Install deps first (cache-friendly)
COPY package*.json ./

# Make npm/node-gyp happy
ENV npm_config_python=/usr/bin/python3
ENV NPM_CONFIG_LEGACY_PEER_DEPS=true

# Prefer lockfile; fall back to install
RUN npm ci || npm install

# Bring in the rest
COPY . .

# Build if present; otherwise no-op
RUN npm run build || echo "No build step"

EXPOSE 3000
CMD ["npm", "start"]
