#!/usr/bin/env bash

# ========================================================
#   FTS Swarm Setup - Agent Workspace Generator (macOS/Linux)
# ========================================================

set -e

echo "========================================================"
echo "  FTS Swarm Setup - Agent Workspace Generator"
echo "========================================================"
echo ""
echo "This script will create the 9 OpenClaw agent workspaces"
echo "and inject the custom FTS identities and rules."
echo ""

OC_DIR="$HOME/.openclaw"
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "1. Creating Agent Workspaces..."
openclaw agents add orchestrator --workspace "$OC_DIR/workspace-orchestrator"
openclaw agents add security_architect --workspace "$OC_DIR/workspace-security_architect"
openclaw agents add sub1 --workspace "$OC_DIR/workspace-sub1"
openclaw agents add sub2 --workspace "$OC_DIR/workspace-sub2"
openclaw agents add sub3 --workspace "$OC_DIR/workspace-sub3"
openclaw agents add data_engineer --workspace "$OC_DIR/workspace-data_engineer"
openclaw agents add reviewer --workspace "$OC_DIR/workspace-reviewer"
openclaw agents add test_automation --workspace "$OC_DIR/workspace-test_automation"
openclaw agents add compliance_auditor --workspace "$OC_DIR/workspace-compliance_auditor"

echo ""
echo "2. Injecting Shared Rules (USER.md)..."
SHARED_DIR="$DIR/../samples/shared"
for agent in orchestrator security_architect sub1 sub2 sub3 data_engineer reviewer test_automation compliance_auditor; do
    cp "$SHARED_DIR/USER.md" "$OC_DIR/workspace-$agent/USER.md" || true
done

echo ""
echo "3. Injecting Role-Specific Rules and Identities..."
SAMPLES_DIR="$DIR/../samples"
for agent in orchestrator security_architect sub1 sub2 sub3 data_engineer reviewer test_automation compliance_auditor; do
    cp "$SAMPLES_DIR/$agent/SOUL.md" "$OC_DIR/workspace-$agent/SOUL.md" || true
    cp "$SAMPLES_DIR/$agent/AGENTS.md" "$OC_DIR/workspace-$agent/AGENTS.md" || true
    cp "$SAMPLES_DIR/$agent/IDENTITY.md" "$OC_DIR/workspace-$agent/IDENTITY.md" || true
    cp "$SAMPLES_DIR/$agent/TOOLS.md" "$OC_DIR/workspace-$agent/TOOLS.md" || true
done

echo ""
echo "4. Registering Identities..."
for agent in orchestrator security_architect sub1 sub2 sub3 data_engineer reviewer test_automation compliance_auditor; do
    openclaw agents set-identity --workspace "$OC_DIR/workspace-$agent" --from-identity
done

echo ""
echo "========================================================"
echo "  Success! 9-Agent FTS Swarm workspaces are ready."
echo "  Check your 'openclaw.json' to ensure models are set."
echo "========================================================"
echo ""
