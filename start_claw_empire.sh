#!/usr/bin/env bash

# ============================================================
#  Claw-Empire Daily Launcher
#  Target OS: macOS / Linux
# ============================================================

set -e

cd "$(dirname "$0")/claw-empire" || {
    echo "[ERROR] Could not enter claw-empire directory."
    echo "        Run ./setup_claw_empire.sh first."
    exit 1
}

# Find pnpm
if command -v pnpm >/dev/null 2>&1; then
    PNPM_CMD="pnpm"
else
    echo "[ERROR] pnpm not found. Please ensure it is installed and in your PATH."
    exit 1
fi

export NODE_OPTIONS="--experimental-sqlite"

echo ""
echo "========================================================"
echo "   Claw-Empire  -  Starting dev:local server"
echo "   UI will be at: http://127.0.0.1:8800"
echo "========================================================"
echo ""

$PNPM_CMD dev:local
