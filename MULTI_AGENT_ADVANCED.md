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

In a swarm, you almost always want different agents utilizing different models based on their role's complexity to save costs or optimize performance.

### Swarm Model & Provider Comparison Table

When deciding which "AI Plan" to wire into your agent, consider this comparison of popular providers supported natively:

| Provider | Hosting Type | Auth Pattern | Best For / Swarm Use Case | Example Prefix |
| :--- | :--- | :--- | :--- | :--- |
| **OpenAI** | Cloud | API Key & OAuth | Complex orchestration, deep reasoning, primary planning. | `openai/gpt-5.3-codex` |
| **Anthropic** | Cloud | API Key & App Token | Heavy context windows, nuanced code reviews. | `anthropic/claude-opus-4-6` |
| **Ollama** | Local | (None) | Maximum privacy, zero API cost, baseline chat/reviewer agents running on your GPU. | `ollama/llama3` |
| **OpenRouter** | Cloud (Aggregator) | API Key | Consolidating billing across multiple models (e.g., using both Anthropic and Google via one key). | `openrouter/anthropic/claude-` |
| **Qwen (Alibaba)** | Cloud | API Key & OAuth | Exceptional open-weight performance, great for specialized "coder" sub-agents. | `qwen/qwen-max` |
| **GLM (Zhipu)** | Cloud | API Key | Complex reasoning. | `glm/glm-4` |
| **MiniMax** | Cloud | API Key | General chat and workflow execution. | `minimax/abab6.5-chat` |

### Setting Models via CLI

You can explicitly set the primary model for a specific agent directly through the CLI by referencing its array index from `openclaw agents list`:

```bash
# Complex Planning Agent (Tier 1)
openclaw config set agents.list[0].model.primary '"anthropic/claude-opus-4-6"'

# Specialized Coder Agent (Tier 2 - Alibaba Qwen)
openclaw config set agents.list[1].model.primary '"qwen/qwen-max"'

# Coder via open-source OAuth portal
openclaw config set agents.list[1].model.primary '"qwen-portal/coder-model"'

# Aggregated Cost/Billing (OpenRouter Model)
openclaw config set agents.list[2].model.primary '"openrouter/anthropic/claude-3.5-sonnet"'

# Foreign Reasoning Agents (MiniMax / GLM)
openclaw config set agents.list[3].model.primary '"glm/glm-4"'
openclaw config set agents.list[4].model.primary '"minimax/abab6.5-chat"'

# Cost-Free, Private Reviewer Agent (Tier 3 - Local Ollama)
openclaw config set agents.list[5].model.primary '"ollama/llama3"'
```

### Injecting Specific Provider Tokens

If you are not using `openclaw onboard` OAuth (like `openai-codex` or `qwen-portal`), you must provide standard API keys.

You inject these securely into the `openclaw.json` `env` config using the CLI:

```bash
# Aggregator Keys
openclaw config set env.OPENROUTER_API_KEY '"YOUR_OPENROUTER_KEY"'

# Standard Cloud Keys
openclaw config set env.OPENAI_API_KEY '"YOUR_OPENAI_KEY"'
openclaw config set env.ANTHROPIC_API_KEY '"YOUR_ANTHROPIC_KEY"'

# Specialized Region Keys
openclaw config set env.DASHSCOPE_API_KEY '"YOUR_ALIBABA_QWEN_KEY"'
openclaw config set env.ZHIPU_API_KEY '"YOUR_GLM_KEY"'
openclaw config set env.MINIMAX_API_KEY '"YOUR_MINIMAX_KEY"'
```

*Note: `ollama` natively requires no API key assuming the Ollama daemon is running on your localhost gateway.*

### Advanced Provider Setups

If you want to avoid managing raw API keys entirely (especially in enterprise swarms), or if you need to rely on fully local hardware, OpenClaw provides advanced authentication paths:

#### 1. Fully Local Hardware Integration (Ollama)

To run agents entirely on your own GPU without cloud expenses:

1. **Install and run the Ollama daemon** on the same machine hosting your OpenClaw Gateway.
2. **Pull a tool-capable model** using the standard Ollama CLI:
   
   ```bash
   ollama pull llama3.3
   ollama pull qwen2.5-coder:32b
   ```

3. **Wire your agent** to the pulled model:

   ```bash
   openclaw config set agents.list[...].model.primary '"ollama/llama3"'
   ```

*If your Ollama instance runs remotely (e.g., on a dedicated GPU server rather than the Gateway host), explicitly map the base URL in your config:*
```bash
openclaw config set models.providers.ollama.baseUrl '"http://your-gpu-host:11434"'
```

#### 2. Cloud Providers via OAuth / Setup-Tokens

Rather than injecting `OPENAI_API_KEY`, you can bind individual agents using interactive Auth portals to keep credentials siloed securely.

**OpenAI (Codex Subscription)**
Use the built-in wizard or the explicit auth command to log in via your browser:
```bash
openclaw models auth login --provider openai-codex
```
*Your agent will now natively support `openai-codex/gpt-5.3-codex`.*

**Qwen (Alibaba OAuth Portal)**
First, explicitly enable the Qwen portal plugin, then authenticate:
```bash
openclaw plugins enable qwen-portal-auth
openclaw models auth login --provider qwen-portal --set-default
```
*Your agent will now natively support `qwen-portal/coder-model`.*

**Anthropic (Claude Setup-Token)**
Anthropic uses a "setup-token" workflow. First, generate a token using Anthropic's CLI tools (`claude setup-token`), then pass it to your OpenClaw agent:
```bash
openclaw models auth paste-token --provider anthropic
```
*(You can also paste this setup-token during the `openclaw onboard` interactive wizard).*

#### 3. Using Multiple OAuth Accounts
Because OAuth credentials (and setup-tokens) are saved strictly inside an agent's `agentDir` (`~/.openclaw/agents/<agentId>/agent/auth-profiles.json`), you can seamlessly use **different OAuth accounts for different agents**. 
To assign a second OpenAI Codex account to a secondary agent:
1. Ensure the gateway targets the specific agent (e.g., `openclaw shell --agent <agentId2>`).
2. Run the login flow again `openclaw models auth login --provider openai-codex`.
3. Log in with the secondary account. The credentials will save *only* to `<agentId2>`, completely avoiding conflicts with your primary orchestrator's account.

### Advanced API Key Injection & Rotation

If you are using standard API keys, OpenClaw offers native rotation and fallback mechanisms to prevent workflow halts during rate limits (e.g., getting a `429 Too Many Requests`).

You inject these securely into the `openclaw.json` `env` config.

**1. Standard Injection**
```bash
openclaw config set env.OPENAI_API_KEY '"YOUR_OPENAI_KEY"'
```

**2. Comma-Separated Key Rotation**
If you have multiple keys for the same provider, pass them as a comma-separated list. OpenClaw will automatically use the next key if the primary hits a quota/rate limit:
```bash
openclaw config set env.ANTHROPIC_API_KEYS '"KEY1,KEY2,KEY3"'
```

**3. Numbered Key Fallbacks**
You can also set explicit numbered fallbacks which the system will cycle through on `429` blockages:
```bash
openclaw config set env.OPENAI_API_KEY_1 '"FALLBACK_KEY_1"'
openclaw config set env.OPENAI_API_KEY_2 '"FALLBACK_KEY_2"'
```

**4. High-Priority Live Overrides**
When live-debugging a specific agent where you need to temporarily override the swarm's keys without deleting the configured fallbacks, use the `LIVE` prefix:
```bash
export OPENCLAW_LIVE_OPENAI_KEY="TEMP_DEBUG_KEY"
openclaw serve
```

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
