# ⚙️ OpenClaw Detailed Setup Guide

Welcome to the definitive setup guide for **OpenClaw (The Orchestrator)**. Because OpenClaw serves as the monolithic brain of the Swarm, it carries the most extensive configuration options.

This guide will walk you through bridging OpenClaw's logic to your preferred AI models (running Locally or via the Cloud) and wiring it up to your favorite messaging platforms.

---

## 🧠 Part 1: Linking Your AI Models

OpenClaw is model-agnostic. You can power it using commercial APIs or entirely offline using local hardware.

### Option A: Cloud APIs (OpenAI / Anthropic / Gemini)
The easiest way to get started is by plugging in an existing API key.

1. Open your `agents/orchestrator.json` file.
2. Locate the `modelProvider` block.
3. Set your provider and insert the respective model name:
```json
"modelProvider": {
  "provider": "openai", 
  "model": "gpt-4-turbo" 
}
```
*(Valid providers: `openai`, `anthropic`, `google`)*

4. Store your secret key securely in the `.env` file at the root of your project:
```env
OPENAI_API_KEY="sk-proj-YOUR_KEY"
# OR
ANTHROPIC_API_KEY="sk-ant-YOUR_KEY"
```

### Option B: Local Models (Ollama)
For high privacy and zero API costs, you can run OpenClaw entirely locally.

1. Download and install [Ollama](https://ollama.com/).
2. Pull your desired model via your terminal (e.g., Llama 3):
```bash
ollama run llama3
```
3. Update your `agents/orchestrator.json` to point to your local localhost port:
```json
"modelProvider": {
  "provider": "ollama", 
  "model": "llama3",
  "endpoint": "http://localhost:11434/api/generate"
}
```

---

## 💬 Part 2: Connecting Messaging Platforms

OpenClaw supports 11+ channels. Here is how to link the most popular platforms so you can chat with your agent.

### Option A: Discord Integration
1. Go to the [Discord Developer Portal](https://discord.com/developers/applications).
2. Create a "New Application" and navigate to the "Bot" tab.
3. Reset and copy the **Bot Token**.
4. Enable all 3 **Privileged Gateway Intents** (Presence, Server Members, Message Content).
5. Generate an OAuth2 URL (Bot permission: Administrator) and invite it to your server.
6. Paste the token in your `.env`:
```env
DISCORD_TOKEN="MTIzNDU2N..."
```

### Option B: Telegram Integration
1. Open Telegram and search for `@BotFather`.
2. Send the message `/newbot` and follow the prompts to name your agent.
3. BotFather will reply with an **HTTP API Token**.
4. Paste the token in your `.env`:
```env
TELEGRAM_BOT_TOKEN="123456789:ABCDEF..."
```
5. In `agents/orchestrator.json`, change the `primaryChannel` to `"telegram"`.

### Option C: Slack Integration
1. Go to [api.slack.com](https://api.slack.com/apps) and click "Create New App".
2. Under "Features > OAuth & Permissions", add the following Bot Token Scopes:
   - `app_mentions:read`
   - `chat:write`
   - `channels:history`
3. Click "Install to Workspace" at the top of the page.
4. Copy the **Bot User OAuth Token** (starts with `xoxb-`).
5. Paste the token in your `.env`:
```env
SLACK_BOT_TOKEN="xoxb-123456..."
```
6. In `agents/orchestrator.json`, change the `primaryChannel` to `"slack"`.

---

## 🚀 Part 3: Booting Up

With your models and messaging platforms configured, you are ready to launch!

```bash
npm run build
npm run start
```
Go to your chosen messaging app, tag the bot, and say "Hello!". Your OpenClaw orchestrator is now live. For scaling to multiple agents simultaneously, see the **[DEPLOYMENT_GUIDE.md](DEPLOYMENT_GUIDE.md)**.
