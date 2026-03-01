# Multi-Agent OpenClaw Setup (Step by Step)

This is a focused, copy-paste friendly walkthrough for running multiple agents
on one OpenClaw Gateway and routing traffic to each agent deterministically.

---

## Step 1: Install and Onboard (Gateway Host)

```bash
npm install -g openclaw@latest
openclaw onboard --install-daemon
openclaw gateway status
```

---

## Step 2: Create Isolated Agents

Create one agent per role. Each agent gets its own workspace, identity,
credentials, and session store.

```bash
openclaw agents add strategy --workspace ~/.openclaw/workspace-strategy
openclaw agents add coding --workspace ~/.openclaw/workspace-coding
openclaw agents add support --workspace ~/.openclaw/workspace-support
```

Check what exists:

```bash
openclaw agents list --bindings
```

---

## Step 3: Connect Messaging Accounts

Log in to each channel account you want to map to a role. WhatsApp supports
multiple accounts; each one gets its own `accountId`.

```bash
openclaw channels login --channel whatsapp --account personal
openclaw channels login --channel whatsapp --account biz
```

For Telegram and Discord, set tokens in `~/.openclaw/openclaw.json` or via
`openclaw onboard`.

---

## Step 4: Bind Accounts to Agents

Bindings route inbound traffic by channel, account, and optional peer.

```bash
openclaw agents bind --agent strategy --bind telegram:founder
openclaw agents bind --agent coding --bind discord:engineering
openclaw agents bind --agent support --bind whatsapp:biz
```

List bindings:

```bash
openclaw agents bindings --json
```

---

## Step 5: Add Explicit Routing Rules (Config)

Edit `~/.openclaw/openclaw.json` and add explicit bindings plus session scoping:

```json
{
  "session": {
    "dmScope": "per-account-channel-peer"
  },
  "bindings": [
    {
      "agentId": "strategy",
      "match": {
        "channel": "telegram",
        "accountId": "founder"
      }
    },
    {
      "agentId": "coding",
      "match": {
        "channel": "discord",
        "accountId": "engineering"
      }
    },
    {
      "agentId": "support",
      "match": {
        "channel": "whatsapp",
        "accountId": "biz"
      }
    }
  ]
}
```

Restart when needed:

```bash
openclaw gateway restart
openclaw channels status --probe
```

---

## Step 6: Verify with Direct Agent Calls

```bash
openclaw agent --agent strategy --message "status check"
openclaw agent --agent coding --message "status check"
openclaw agent --agent support --message "status check"
```

---

## Step 7: Optional: Multi-Bot Slack Pattern

Some teams use different bot accounts for each agent. These examples show how
others structure multi-agent routing by platform:

- Slack multi-bot setup: one bot per team role, each bound to a dedicated agent.

See the linked GitHub guides in the References section below for the exact
examples.

---

## Step 8: Burst Workloads with Sub-Agents

When the orchestrator needs parallel workers, use sub-agents:

```text
/subagents spawn coding Implement API auth middleware --model openai/gpt-5.1-codex --thinking high
/subagents list
/subagents log #1 200 tools
/subagents kill all
```

Recommended sub-agent defaults:

```json
{
  "agents": {
    "defaults": {
      "subagents": {
        "maxSpawnDepth": 2,
        "maxChildrenPerAgent": 5,
        "runTimeoutSeconds": 900,
        "archiveAfterMinutes": 60
      }
    }
  }
}
```

---

## References

- Multi-agent routing: https://docs.openclaw.ai/multi-agent
- Agents CLI: https://docs.openclaw.ai/cli
- Config reference: https://docs.openclaw.ai/gateway/configuration-reference
- Official sub-agents doc: https://docs.openclaw.ai/tools/subagents
- Multi-agent overview: https://howtouseopenclaw.com/blog/openclaw-multi-agent
- Slack multi-bot guide (GitHub Gist): https://gist.github.com/rafaelquintanilha/9ca5ae6173cd0682026754cfefe26d3f
