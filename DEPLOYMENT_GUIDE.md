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

## ⚙️ Step 2: Environment Configuration

With the repository cloned locally (`npm install` completed), open your codebase and locate the `.env` file. You will need to map your bot tokens to the respective OpenClaw instances.

```env
# AI Provider Keys
OPENAI_API_KEY="sk-..."
ANTHROPIC_API_KEY="sk-ant-..."

# Bot Integration Tokens
ORCHESTRATOR_DISCORD_TOKEN="MTEx..."
CODER_DISCORD_TOKEN="MTIy..."
REVIEWER_DISCORD_TOKEN="MTMz..."

# Channel Routing (Right click channels in Discord -> Copy Channel ID)
INBOX_CHANNEL_ID="1234567890"
BRAINSTORM_CHANNEL_ID="0987654321"
EXECUTION_CHANNEL_ID="1122334455"
REVIEW_CHANNEL_ID="5544332211"
```

---

## 🤖 Step 3: Defining the Agent Personas

In the `agents/` directory, you configure the behavior constraints. 

1. **Orchestrator (`agents/orchestrator.json`)**: Configured to only listen to the `INBOX_CHANNEL_ID`. If a human sends a prompt here, the Orchestrator breaks it down into sub-tasks and posts them to `BRAINSTORM_CHANNEL_ID`.
2. **Coder Sub-Agent (`agents/coder.json`)**: Listens to `BRAINSTORM_CHANNEL_ID`. It executes the code, uses the `github_push` skill, and pings the Reviewer in `EXECUTION_CHANNEL_ID`.
3. **Reviewer Agent (`agents/reviewer.json`)**: Listens to `EXECUTION_CHANNEL_ID`. It runs tests against the generated code. If tests fail, it scolds the Coder agent. If they pass, it merges the PR and logs to `🚀-deployments`.

---

## 🚀 Step 4: Running the Swarm

You cannot run all three agents in a single standard thread without blocking. We use a process manager like `pm2` or multiple terminal windows to run them simultaneously.

### Option A: Using PM2 (Recommended for Production)
Install PM2 globally to manage the Node processes:
```bash
npm install -g pm2
```
Start the swarm utilizing our pre-packaged ecosystem file:
```bash
pm2 start ecosystem.config.js
```
*This will spin up `orchestrator`, `coder`, and `reviewer` as background daemon processes.*

### Option B: Local Testing (Multiple Terminals)
Open three separate terminal windows in VS Code:
- **Terminal 1**: `npm run start:orchestrator`
- **Terminal 2**: `npm run start:coder`
- **Terminal 3**: `npm run start:reviewer`

---

## 🧪 Step 5: Triggering the Swarm

Head over to your Discord server and type in the `#📥-inbox` channel:

> **You:** "@Swarm_Orchestrator I need a new Python script that pulls the daily weather for Tokyo and saves it to a local CSV. Please build it."

Jump between your Discord channels and watch the magic happen automatically:
1. **Orchestrator** will reply acknowledging the receipt, and move to `#🧠-brainstorming` to post the architecture plan.
2. **Coder** will read the plan in `#⚙️-execution-codex` and write the code.
3. **Reviewer** will jump into `#⚖️-code-review`, run `flake8` and `pytest`, and finalize the deployment!

---
*Ready to integrate unique use cases into your new Swarm? Check out the [Community Use Cases](USECASES.md).*
