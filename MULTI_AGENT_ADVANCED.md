# Advanced Multi-Agent OpenClaw Setup

This guide dives into advanced configurations for an OpenClaw swarm. It covers connecting specific agents to messaging platforms (like Discord), explicit model provider configurations down to the agent level (including local Ollama), understanding strict auth isolation, and skill scoping.

The OpenClaw Gateway natively supports hosting either a single agent (the common default) or **many isolated agents side-by-side** on the same machine.

---

## 1. Advanced Messaging App Wiring (Focus on Discord)

When deploying a multi-agent swarm, you rarely want all agents fighting to answer every message in every channel. You need to explicitly "wire" each AI model/agent to specific parts of your messaging application.

While OpenClaw supports WhatsApp, Telegram, Slack, and others, **Discord** offers the most robust swarm environment due to its guild (server) and channel structures.

### The Wiring Hierarchy

Messages are routed to agents based on the rules defined in your `openclaw.json` under the `bindings` array. The routing follows this priority (most-specific wins):
1. **Peer Match**: Exact DM, Group, or specific text channel ID.
2. **Guild + Roles**: Specific Discord server combined with specific user roles.
3. **Guild Match**: Any channel inside a specific Discord server.
4. **Account Match**: A specific bot token account.
5. **Channel Match**: The entire platform (e.g., *any* Discord message).
6. **Fallback Default**: If no match, it hits the default agent (usually `main`).

### Example: Wiring a Discord Swarm

Assume you have three agents: an `orchestrator`, a `coder`, and a `reviewer`. You want:
- The `orchestrator` to answer DMs.
- The `coder` to only respond in the `#backend-dev` text channel.
- The `reviewer` to only respond in the `#code-reviews` text channel.

Your `openclaw.json` bindings would look like this:

```json
{
  "bindings": [
    {
      "agentId": "orchestrator",
      "match": { 
        "channel": "discord",
        "peer": { "kind": "direct" }
      }
    },
    {
      "agentId": "coder",
      "match": { 
        "channel": "discord",
        "guildId": "123456789012345678",
        "peer": { "kind": "channel", "id": "999999999999999991" } 
      }
    },
    {
      "agentId": "reviewer",
      "match": { 
        "channel": "discord",
        "guildId": "123456789012345678",
        "peer": { "kind": "channel", "id": "999999999999999992" } 
      }
    }
  ]
}
```
*(You must replace `guildId` and `id` with your actual Discord server and channel IDs).*

---

## 2. Per-Agent Model & API Provider Configuration

In a swarm, you often want different agents utilizing different models based on their role's complexity to save costs or optimize performance.

For example, your `orchestrator` might need the deep logic of `anthropic/claude-opus-4-6`, while a basic `reviewer` agent might run perfectly fine (and cheaply) on a local `ollama` model.

### Setting Models via CLI

You can explicitly set the primary model for a specific agent directly through the CLI by referencing its array index from `openclaw agents list`:

```bash
# Set Orchestrator (Agent 0) to Claude Opus
openclaw config set agents.list[0].model.primary '"anthropic/claude-opus-4-6"'

# Set Coder (Agent 1) to OpenAI Codex via OAuth
openclaw config set agents.list[1].model.primary '"openai-codex/gpt-5.3-codex"'

# Set Reviewer (Agent 2) to Local Ollama
openclaw config set agents.list[2].model.primary '"ollama/llama3"'
```

### Supported Provider Connections

- **Standard Cloud APIs**: Use raw API keys (e.g., `openai/gpt-4o`, `anthropic/claude-3-5-sonnet`).
- **OAuth / Setup-Tokens**: Advanced paths like `openai-codex` or `anthropic` setup-tokens allow connecting without managing raw, easily leaked API keys.
- **Local Providers**: Providers like `ollama` allow you to run models entirely on your own hardware, free of API costs, assuming your gateway host has the GPU resources.

---

## 3. Strict Identity and Authentication Isolation

The most critical rule of managing a side-by-side OpenClaw swarm is isolation. 

Every AI vendor connection, OAuth session, and integration token a specific agent uses is stored in its **Auth Profiles**.

### The `auth-profiles.json` File

These profiles are fundamentally **per-agent**. Each agent reads exclusively from its own directory:

`~/.openclaw/agents/<agentId>/agent/auth-profiles.json`

Because of this architecture:
1. **Credentials are not shared**: The Main agent's credentials (like an OpenAI key or a GitHub OAuth session) are not automatically shared with Sub-agent 1.
2. **Never reuse `agentDir`**: You must **never** point multiple agents to the same `agentDir` in your `openclaw.json`. Doing so will cause immediate authentication, memory, and session collisions, corrupting the agents' state.

### Sharing Credentials (Manual Override)

If you absolutely must share a logged-in session (e.g., an expensive OAuth seat) across two agents, you have to manually copy the auth profile from one isolated directory to the other:

```bash
cp ~/.openclaw/agents/orchestrator/agent/auth-profiles.json ~/.openclaw/agents/coder/agent/auth-profiles.json
```
*(Doing this manually ensures you are explicitly aware of the shared state, rather than relying on dangerous systemic bleed-over).*

---

## 4. Skill Scoping (Workspace vs Shared)

"Skills" in OpenClaw (custom code, binaries, or logical extensions) operate on a similar isolation principle.

- **Per-Agent Skills**: By default, skills are scoped exclusively to an agent's workspace. If you drop a custom skill script into `~/.openclaw/workspace-coder/skills/`, **only the Coder agent** can access and execute that skill.
- **Shared Master Skills**: If you have a skill that the entire swarm needs (e.g., a custom system file-reader or a shared web-scraper), you install it globally. Global skills reside at `~/.openclaw/skills/` and are available to any agent that has execution tool permissions enabled.
