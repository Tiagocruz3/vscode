FROM node:22-bookworm-slim

# Native build deps (node-gyp, kerberos, native-keymap)
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3 build-essential pkg-config git openssh-client ca-certificates \
    libkrb5-dev \
    libx11-dev libxkbfile-dev \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# ⬇️ Important: copy the whole repo before install so preinstall.js exists
COPY . .

# Helpful env for node-gyp and flaky peer/optional deps
ENV npm_config_python=/usr/bin/python3
ENV NPM_CONFIG_LEGACY_PEER_DEPS=true
# (optional) if optional native deps keep failing, uncomment:
# ENV NPM_CONFIG_OPTIONAL=false

# Install deps (prefer lockfile if present)
RUN npm ci --no-audit --no-fund || npm install --no-audit --no-fund
# If you disabled optional deps above, mirror it:
# RUN npm ci --omit=optional --no-audit --no-fund || npm install --omit=optional --no-audit --no-fund

# Build if defined
RUN npm run build || echo "no build script"

EXPOSE 3000
CMD ["npm", "start"]
