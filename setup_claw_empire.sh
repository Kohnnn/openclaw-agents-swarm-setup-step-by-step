#!/usr/bin/env bash

# ============================================================
#  Claw-Empire 1-Click Setup for OpenClaw Discord Swarm
#  Target OS  : macOS / Linux
#  Repository : https://github.com/GreenSheep01201/claw-empire
# ============================================================

set -e

echo ""
echo "========================================================"
echo "   Claw-Empire  -  1-Click Setup Script"
echo "   OpenClaw Discord Swarm Edition"
echo "========================================================"
echo ""

# ============================================================
# 1. PREREQUISITE CHECKS
# ============================================================
echo "[1/4] Checking prerequisites..."
echo ""

# Check Node.js
if ! command -v node >/dev/null 2>&1; then
    echo "[ERROR] Node.js is not installed or not in PATH."
    echo "        Please install Node.js v22+ from https://nodejs.org/"
    exit 1
fi

NODE_VER=$(node -v | sed 's/v//' | cut -d'.' -f1)
if [ "$NODE_VER" -lt 22 ]; then
    echo "[ERROR] Node.js v22+ is required. Detected: v$NODE_VER."
    echo "        Please upgrade from https://nodejs.org/"
    exit 1
fi
echo "  [OK] Node.js v$NODE_VER detected"

# Check Git
if ! command -v git >/dev/null 2>&1; then
    echo "[ERROR] Git is not installed or not in PATH."
    echo "        Please install Git from https://git-scm.com/"
    exit 1
fi
GIT_VER=$(git --version | awk '{print $3}')
echo "  [OK] Git $GIT_VER detected"

# Check pnpm
echo ""
if command -v pnpm >/dev/null 2>&1; then
    PNPM_CMD="pnpm"
    echo "  [OK] pnpm found natively"
else
    echo "  pnpm not found. Attempting corepack enable..."
    corepack enable >/dev/null 2>&1 || true
    if command -v pnpm >/dev/null 2>&1; then
        PNPM_CMD="pnpm"
        echo "  [OK] pnpm enabled via corepack"
    else
        echo "[ERROR] pnpm is not available. Install it with:"
        echo "          npm install -g pnpm"
        echo "        Or download from https://pnpm.io/installation"
        exit 1
    fi
fi
echo ""

# ============================================================
# 2. CLONE & INSTALL
# ============================================================
echo "[2/4] Cloning and installing claw-empire..."
echo ""

if [ -d "claw-empire" ]; then
    echo "  [INFO] Directory 'claw-empire' already exists."
    CLAW_EMPIRE_EXISTS=1
else
    echo "  Cloning repository https://github.com/GreenSheep01201/claw-empire ..."
    git clone https://github.com/GreenSheep01201/claw-empire.git
    echo "  [OK] Repository cloned"
    CLAW_EMPIRE_EXISTS=0
fi

cd claw-empire

if [ "$CLAW_EMPIRE_EXISTS" -eq 1 ]; then
    echo "  [UPDATE] Checking for updates from remote repository..."
    if ! git pull; then
        echo "  [WARN] Could not pull latest changes. Continuing with existing files."
    else
        echo "  [OK] Repository updated"
    fi
fi

# Init submodules
echo "  Initializing submodules..."
git submodule update --init --recursive || echo "  [WARN] Submodule update returned a warning."
echo "  [OK] Submodules initialized"

# Install dependencies
echo ""
echo "  Installing dependencies..."
$PNPM_CMD install
echo "  [OK] Dependencies installed"

# --- FTS Custom Integration Step ---
echo "  Applying FTS Office Pack custom integration..."
cp -r ../templates/claw-empire-integration/src/* src/ 2>/dev/null || true
cp -r ../templates/claw-empire-integration/server/* server/ 2>/dev/null || true
echo "  [OK] Applied custom FTS source code"

echo "  Building with custom FTS integration..."
$PNPM_CMD run build
echo "  [OK] Build complete"

echo "  Registering FTS agents..."
node --experimental-sqlite ../templates/claw-empire-integration/register_agents.js
echo "  [OK] Agents registered"
# -----------------------------------

echo ""

# ============================================================
# 3. ENVIRONMENT CONFIGURATION
# ============================================================
echo "[3/4] Configuring environment variables..."
echo ""

if [ ! -f ".env" ]; then
    if [ -f ".env.example" ]; then
        cp .env.example .env
        echo "  [OK] Created .env from .env.example"
    else
        echo "  Creating minimal .env ..."
        cat <<EOF > .env
# Claw-Empire environment configuration
OAUTH_ENCRYPTION_SECRET=
INBOX_WEBHOOK_SECRET=
OPENCLAW_CONFIG=
PORT=8790
HOST=127.0.0.1
EOF
        echo "  [OK] Created minimal .env"
    fi
else
    echo "  [OK] .env already exists"
fi

# ---- Inject / update OPENCLAW_CONFIG ----
OPENCLAW_PATH="$HOME/.openclaw/openclaw.json"

if grep -q "^OPENCLAW_CONFIG=" .env; then
    sed -i.bak "s|^OPENCLAW_CONFIG=.*|OPENCLAW_CONFIG=$OPENCLAW_PATH|" .env
    rm -f .env.bak
    echo "  [OK] Updated OPENCLAW_CONFIG in .env"
else
    echo "OPENCLAW_CONFIG=$OPENCLAW_PATH" >> .env
    echo "  [OK] Added OPENCLAW_CONFIG to .env"
fi

# ---- Inject / update INBOX_WEBHOOK_SECRET ----
if command -v openssl >/dev/null 2>&1; then
    RANDOM_SECRET=$(openssl rand -hex 32)
else
    RANDOM_SECRET=$(head -c 32 /dev/urandom | xxd -p | tr -d '\n')
fi

if grep -q "^INBOX_WEBHOOK_SECRET=" .env; then
    SECRET_VAL=$(grep "^INBOX_WEBHOOK_SECRET=" .env | cut -d '=' -f2)
    if [ -z "$SECRET_VAL" ]; then
        sed -i.bak "s|^INBOX_WEBHOOK_SECRET=.*|INBOX_WEBHOOK_SECRET=$RANDOM_SECRET|" .env
        rm -f .env.bak
        echo "  [OK] Generated secure INBOX_WEBHOOK_SECRET"
    else
        echo "  [OK] INBOX_WEBHOOK_SECRET already configured"
    fi
else
    echo "INBOX_WEBHOOK_SECRET=$RANDOM_SECRET" >> .env
    echo "  [OK] Generated secure INBOX_WEBHOOK_SECRET"
fi

echo ""

# ============================================================
# 4. FINALIZATION
# ============================================================
echo "[4/4] Finalizing..."
echo ""

echo "  Verifying configuration:"
echo "  ---"
grep "^OPENCLAW_CONFIG=" .env
grep "^INBOX_WEBHOOK_SECRET=" .env
echo "  ---"
echo ""

echo "========================================================"
echo "   Setup complete!"
echo "========================================================"
echo ""
echo "  OPTION 1 - Use the launcher (recommended):"
echo "    ./start_claw_empire.sh"
echo ""
echo "  OPTION 2 - Manual start from claw-empire directory:"
echo "    export NODE_OPTIONS=--experimental-sqlite"
echo "    pnpm dev:local"
echo ""
echo "  Then open:  http://127.0.0.1:8800  in your browser"
echo ""
echo "  Quick health check (from another terminal):"
echo "    curl -s http://127.0.0.1:8790/healthz"
echo ""
echo "  Your OpenClaw config:  $OPENCLAW_PATH"
echo ""
echo "  Happy building with your AI agent swarm!"
echo ""
