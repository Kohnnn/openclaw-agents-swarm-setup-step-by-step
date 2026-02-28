# 🛠️ Swarm Deployment & Execution Guide

This guide will walk you through the technical steps required to deploy the "CI/CD Swarm Layer" highlighted in our main architecture. By the end of this guide, you will have an Orchestrator Agent, multiple Sub-Agents, and a Reviewer coordinating together.

---

## 🛑 Step 1: Pre-Requisite Platform Setup

Before touching the code, we need to create the spaces where our AI agents will "live" and communicate. 

1. **Create a Discord Server** (or a Slack Workspace/Telegram Group).
2. **Create the following dedicated channels**:
   - `#📥-inbox` (Where you, the human, send tasks)
   - `#🧠-brainstorming` (Where the Orchestrator plans)
   - `#⚙️-execution-codex` (Where sub-agents do the work)
   - `#⚖️-code-review` (Where the Reviewer agent verifies output)
   - `#🚀-deployments` (Where successful builds are logged)
3. **Generate Bot Tokens**: Go to the Discord Developer Portal and create 3 separate applications (Bots):
   - `Swarm_Orchestrator`
   - `Swarm_Coder_Sub`
   - `Swarm_Reviewer`
4. Invite all 3 bots to your server and ensure they have read/write access to the channels created above.

---

## ⚙️ Step 2: Global Configuration & Routing

Regardless of which framework backend you use, you must map your tokens and channel IDs so the agents route correctly. This configuration is generally stored at the root of your Swarm.

```env
# AI Provider Keys
OPENAI_API_KEY="sk-..."
ANTHROPIC_API_KEY="sk-ant-..."

# Bot Integration Tokens
ORCHESTRATOR_DISCORD_TOKEN="MTEx..."
CODER_DISCORD_TOKEN="MTIy..."
REVIEWER_DISCORD_TOKEN="MTMz..."

# Channel Routing
INBOX_CHANNEL_ID="1234567890"
BRAINSTORM_CHANNEL_ID="0987654321"
EXECUTION_CHANNEL_ID="1122334455"
REVIEW_CHANNEL_ID="5544332211"
```

---

## 🚀 Step 3: Framework-Specific Deployment

Because the OpenClaw ecosystem offers highly specialized backends (ranging from edge-IoT footprints to high-security containers), your launch command depends on your chosen backend. Follow the track that applies to your framework.

### Track 1: OpenClaw (The Monolithic Orchestrator)
The default, robust TypeScript orchestrator. Best for massive SQL memories and high-tool-count environments.

1. Ensure Node.js 18+ is installed.
2. Clone the OpenClaw mono-repo and install dependencies: `npm install`
3. Since we are running multiple heavy instances, use PM2:
```bash
npm install -g pm2
pm2 start ecosystem.config.js
```
*This spins up `openclaw-orchestrator`, `openclaw-coder`, and `openclaw-reviewer` automatically.*

### Track 2: ZeroClaw
The incredibly fast, trait-based Rust backend. Perfect for high-performance financial or data backends.

1. Ensure Rust and Cargo are installed (`rustup`).
2. Build the releases natively:
```bash
cargo build --release
```
3. Run the binaries explicitly defining their roles:
```bash
./target/release/zeroclaw --role orchestrator &
./target/release/zeroclaw --role coder &
./target/release/zeroclaw --role reviewer &
```

### Track 3: IronClaw
The high-security WASM + Docker container fortress. Mandatory if your agents will execute untrusted code.

1. Ensure Docker Desktop is running.
2. IronClaw requires strict namespace definitions to prevent cross-contamination. Use Docker Compose to spin up isolated WASM networks:
```bash
docker-compose up -d --build orchestrator coder reviewer
```
*All agent communication will occur strictly through the external messaging API layer (Discord/Telegram), preventing internal container breakouts.*

### Track 4: PicoClaw
The ultra-efficient Go framework prioritizing sub-second startup times for edge utility workloads.

1. Ensure Go 1.21+ is installed.
2. Compile and run:
```bash
go build -o picoclaw main.go
./picoclaw run -c orchestrator.yaml &
./picoclaw run -c coder.yaml &
./picoclaw run -c reviewer.yaml &
```

### Track 5: Nanobot
The Python-centric data scientist friendly framework running on basic Markdown memory graphs.

1. Ensure Python 3.10+ and `poetry` (or `pip`) are installed.
2. Install dependencies: `poetry install`
3. Launch via the built-in python manager:
```bash
poetry run python -m nanobot.swarm orchestrator coder reviewer
```

### Track 6: NanoClaw
The absolutely minimal, ~500 line TypeScript bot. Ideal when running directly on a constrained environment like a Raspberry Pi targeting WhatsApp.

1. Install Bun (or Node) for massive speed improvements on constrained systems: `npm install -g bun`
2. Run directly against the single-file architectures:
```bash
bun start_orchestrator.ts &
bun start_coder.ts &
bun start_reviewer.ts &
```

---

## 🧪 Step 4: Triggering the Swarm

Head over to your Discord server and type in the `#📥-inbox` channel:

> **You:** "@Swarm_Orchestrator I need a new Python script that pulls the daily weather for Tokyo and saves it to a local CSV. Please build it."

Jump between your Discord channels and watch the magic happen automatically:
1. **Orchestrator** will reply acknowledging the receipt, and move to `#🧠-brainstorming` to post the architecture plan.
2. **Coder** will read the plan in `#⚙️-execution-codex` and write the code.
3. **Reviewer** will jump into `#⚖️-code-review`, run validations against the code, and finalize the deployment!

---
*Ready to integrate unique use cases into your new Swarm? Check out the [Community Use Cases](USECASES.md).*
