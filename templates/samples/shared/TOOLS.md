# TOOLS.md (Shared Swarm Notes)

This file stores environment-specific tool notes shared across swarm agents.

## Discord

- Primary guild id: `<DISCORD_GUILD_ID>`
- Channel ids:
  - inbox-user: `<CHANNEL_ID_INBOX_USER>`
  - brainstorm-orchestrator: `<CHANNEL_ID_BRAINSTORM_ORCHESTRATOR>`
  - work-sub1: `<CHANNEL_ID_WORK_SUB1>`
  - work-sub2: `<CHANNEL_ID_WORK_SUB2>`
  - work-sub3: `<CHANNEL_ID_WORK_SUB3>`
  - reviewer-gate: `<CHANNEL_ID_REVIEWER_GATE>`
  - release-ready: `<CHANNEL_ID_RELEASE_READY>`

## Runtime

- Workspace root pattern: `~/.openclaw/workspace-<agent_id>`
- Config file: `~/.openclaw/openclaw.json`
- Health commands:
  - `openclaw agents list --bindings --json`
  - `openclaw channels status --probe`
  - `openclaw gateway status`

## Provider/Auth Notes

- API key env vars:
  - `OPENAI_API_KEY`
  - `ANTHROPIC_API_KEY`
  - `OPENROUTER_API_KEY`
- OAuth/token paths:
  - `openclaw models auth login --provider openai-codex`
  - `openclaw onboard --auth-choice setup-token`
  - `openclaw models auth login --provider qwen-portal --set-default`
