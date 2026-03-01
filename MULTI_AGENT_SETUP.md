# Multi-Agent OpenClaw Setup (Step by Step)

This guide is focused on agent customization and lifecycle operations:

- Create and customize agents (`SOUL.md`, identity, model/provider).
- Bind agents to multiple messaging accounts.
- Safely remove agents and clean up bindings/state.

---

## Step 1: Install and baseline health

Run on the Gateway host:

```bash
npm install -g openclaw@latest
openclaw onboard --install-daemon
openclaw gateway status
openclaw channels status --probe
```

---

## Step 2: Create isolated agents for your swarm

Create one agent per role:

```bash
openclaw agents add strategy --workspace ~/.openclaw/workspace-strategy
openclaw agents add coding --workspace ~/.openclaw/workspace-coding
openclaw agents add support --workspace ~/.openclaw/workspace-support
```

Inspect full inventory:

```bash
openclaw agents list --bindings --json
```

---

## Step 3: Customize agent identity (CLI)

Set user-facing identity per agent (name/emoji/avatar):

```bash
openclaw agents set-identity --agent strategy --name "Strategy Lead" --emoji "S"
openclaw agents set-identity --agent coding --name "Code Worker" --emoji "C"
openclaw agents set-identity --agent support --name "Support Desk" --emoji "H"
```

If your workspace already has an `identity` file, import it:

```bash
openclaw agents set-identity --workspace ~/.openclaw/workspace-coding --from-identity
```

Validate:

```bash
openclaw agents list --json
```

---

## Step 4: Inject and edit `SOUL.md` per agent

There is no dedicated `openclaw agents set-soul` command. The supported pattern is:

1. Use `openclaw agents list --json` to find each agent workspace.
2. Edit each workspace `SOUL.md` file directly.

Example structure to keep behavior deterministic:

```md
# SOUL

## Role

You are the Coding Agent for backend + CI fixes only.

## Hard rules

- Do not edit billing logic.
- Do not deploy directly.
- Open a PR-ready patch and summary.

## Done criteria

- Lint passes.
- Typecheck passes.
- Unit tests pass.
```

Recommended files per agent workspace:

- `SOUL.md`: persona, scope, hard constraints.
- `AGENTS.md`: execution policy and guardrails.
- `USER.md`: local team preferences.

---

## Step 5: Per-agent model/provider customization via CLI + config

### Option A: set default model quickly

```bash
openclaw models set anthropic/claude-opus-4-6
```

This sets global default. For true per-agent customization, use config paths.

### Option B: per-agent model/provider in `openclaw.json`

Read current config:

```bash
openclaw config get agents
```

Set per-agent model path (dot/bracket path supported):

```bash
openclaw config set agents.list[0].model.primary '"anthropic/claude-opus-4-6"'
openclaw config set agents.list[1].model.primary '"openai/gpt-5.1-codex"'
openclaw config set agents.list[2].model.primary '"openrouter/anthropic/claude-sonnet-4-5"'
```

Provider/API examples:

```bash
openclaw config set env.ANTHROPIC_API_KEY '"${ANTHROPIC_API_KEY}"'
openclaw config set env.OPENAI_API_KEY '"${OPENAI_API_KEY}"'
openclaw config set env.OPENROUTER_API_KEY '"${OPENROUTER_API_KEY}"'
```

Channel command behavior and routing are configured under `channels.*`, `bindings`,
`session.*`, and tool policy under `tools.*` or `agents.list[].tools`.

---

## Step 6: Advanced config edits using Gateway config RPC

Use RPC when you want audited full-replace or patch flows.

Get current hash:

```bash
openclaw gateway call config.get --params '{}'
```

Patch part of config (example pattern):

```bash
openclaw gateway call config.patch --params '{
  "raw": "{ session: { dmScope: \"per-account-channel-peer\" } }"
}'
```

Use `config.apply` for full config replace when you have a controlled payload.

---

## Step 7: Connect and manage multiple messaging accounts

### Login accounts

```bash
openclaw channels login --channel whatsapp --account personal
openclaw channels login --channel whatsapp --account biz
```

Configure Telegram/Discord/Slack accounts via onboarding or `channels.*.accounts`
in config.

### Bind accounts to agent roles

```bash
openclaw agents bind --agent strategy --bind telegram:founder
openclaw agents bind --agent coding --bind discord:engineering
openclaw agents bind --agent support --bind whatsapp:biz
```

Check routing table:

```bash
openclaw agents bindings --json
```

Binding rules that matter:

- `channel` only => default account.
- `channel:accountId` => specific account.
- `accountId: "*"` in config => fallback for all channel accounts.
- Most-specific binding wins.

---

## Step 8: Finalize swarm routing in `openclaw.json`

Use explicit multi-agent routing:

```json
{
  "session": {
    "dmScope": "per-account-channel-peer"
  },
  "bindings": [
    {
      "agentId": "strategy",
      "match": { "channel": "telegram", "accountId": "founder" }
    },
    {
      "agentId": "coding",
      "match": { "channel": "discord", "accountId": "engineering" }
    },
    {
      "agentId": "support",
      "match": { "channel": "whatsapp", "accountId": "biz" }
    }
  ]
}
```

Validate and restart if needed:

```bash
openclaw agents list --bindings
openclaw channels status --probe
openclaw gateway status
```

---

## Step 9: Remove an agent safely (delete + cleanup)

When decommissioning an agent, do cleanup in this order:

1. Remove bindings.

```bash
openclaw agents unbind --agent support --all
```

2. Verify there are no routes left.

```bash
openclaw agents bindings --agent support --json
```

3. Delete the agent and prune state/workspace.

```bash
openclaw agents delete support
```

4. Re-check global routing and health.

```bash
openclaw agents list --bindings
openclaw channels status --probe
openclaw gateway status
```

This prevents orphaned routing entries and avoids inbound traffic hitting a
deleted role.

---

## Step 10: Swarm acceptance tests

Run one turn per agent:

```bash
openclaw agent --agent strategy --message "status-check: strategy"
openclaw agent --agent coding --message "status-check: coding"
openclaw agent --agent support --message "status-check: support"
```

For orchestrator fan-out, use sub-agents:

```text
/subagents spawn coding Implement API middleware --model openai/gpt-5.1-codex --thinking high
/subagents list
/subagents log #1 200 tools
```

---

## References

- Multi-agent concept: https://docs.openclaw.ai/concepts/multi-agent
- Agents CLI: https://docs.openclaw.ai/cli/agents
- General CLI (config/models/channels): https://docs.openclaw.ai/cli
- Configuration guide: https://docs.openclaw.ai/gateway/configuration
- Configuration reference: https://docs.openclaw.ai/gateway/configuration-reference
- Provider catalog: https://docs.openclaw.ai/providers
- Sub-agents: https://docs.openclaw.ai/tools/subagents
