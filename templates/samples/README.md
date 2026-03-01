# Agent Swarm Sample Pack (Discord + OpenClaw)

This sample pack provides a fixed 5-agent setup for the AI Agent Swarm use case.

## Included Agents

- `orchestrator`
- `sub1`
- `sub2`
- `sub3`
- `reviewer`

Each agent folder includes:

- `SOUL.md`: persona, scope, hard constraints.
- `AGENTS.md`: execution policy and guardrails.
- `IDENTITY.md`: public persona metadata for channel-facing behavior.
- `TOOLS.md`: role-specific tool notes and validation defaults.

Shared across all agents:

- `shared/USER.md`: local team preferences and project-level guardrails.
- `shared/TOOLS.md`: environment and channel mappings shared by the swarm.

## Discord Channel Map

Use these channels:

- `#inbox-user` (user -> orchestrator)
- `#brainstorm-orchestrator`
- `#work-sub1`
- `#work-sub2`
- `#work-sub3`
- `#reviewer-gate`
- `#release-ready`

## Binding Matrix

- `orchestrator`: intake + planning + status synthesis.
- `sub1`: execution track A (backend/API implementation).
- `sub2`: execution track B (automation/scripts/integrations).
- `sub3`: execution track C (docs/ops/support artifacts).
- `reviewer`: QA gate and release readiness decision.

## Injection Workflow

1. Create swarm agents and find workspaces.

```bash
openclaw agents add orchestrator --workspace ~/.openclaw/workspace-orchestrator
openclaw agents add sub1 --workspace ~/.openclaw/workspace-sub1
openclaw agents add sub2 --workspace ~/.openclaw/workspace-sub2
openclaw agents add sub3 --workspace ~/.openclaw/workspace-sub3
openclaw agents add reviewer --workspace ~/.openclaw/workspace-reviewer
openclaw agents list --json
```

2. Copy shared `USER.md` into each workspace.

```bash
cp templates/samples/shared/USER.md ~/.openclaw/workspace-orchestrator/USER.md
cp templates/samples/shared/USER.md ~/.openclaw/workspace-sub1/USER.md
cp templates/samples/shared/USER.md ~/.openclaw/workspace-sub2/USER.md
cp templates/samples/shared/USER.md ~/.openclaw/workspace-sub3/USER.md
cp templates/samples/shared/USER.md ~/.openclaw/workspace-reviewer/USER.md

cp templates/samples/shared/TOOLS.md ~/.openclaw/workspace-orchestrator/TOOLS.shared.md
cp templates/samples/shared/TOOLS.md ~/.openclaw/workspace-sub1/TOOLS.shared.md
cp templates/samples/shared/TOOLS.md ~/.openclaw/workspace-sub2/TOOLS.shared.md
cp templates/samples/shared/TOOLS.md ~/.openclaw/workspace-sub3/TOOLS.shared.md
cp templates/samples/shared/TOOLS.md ~/.openclaw/workspace-reviewer/TOOLS.shared.md
```

3. Copy each role's `SOUL.md`, `AGENTS.md`, `IDENTITY.md`, and `TOOLS.md`.

```bash
cp templates/samples/orchestrator/SOUL.md ~/.openclaw/workspace-orchestrator/SOUL.md
cp templates/samples/orchestrator/AGENTS.md ~/.openclaw/workspace-orchestrator/AGENTS.md
cp templates/samples/orchestrator/IDENTITY.md ~/.openclaw/workspace-orchestrator/IDENTITY.md
cp templates/samples/orchestrator/TOOLS.md ~/.openclaw/workspace-orchestrator/TOOLS.md

cp templates/samples/sub1/SOUL.md ~/.openclaw/workspace-sub1/SOUL.md
cp templates/samples/sub1/AGENTS.md ~/.openclaw/workspace-sub1/AGENTS.md
cp templates/samples/sub1/IDENTITY.md ~/.openclaw/workspace-sub1/IDENTITY.md
cp templates/samples/sub1/TOOLS.md ~/.openclaw/workspace-sub1/TOOLS.md

cp templates/samples/sub2/SOUL.md ~/.openclaw/workspace-sub2/SOUL.md
cp templates/samples/sub2/AGENTS.md ~/.openclaw/workspace-sub2/AGENTS.md
cp templates/samples/sub2/IDENTITY.md ~/.openclaw/workspace-sub2/IDENTITY.md
cp templates/samples/sub2/TOOLS.md ~/.openclaw/workspace-sub2/TOOLS.md

cp templates/samples/sub3/SOUL.md ~/.openclaw/workspace-sub3/SOUL.md
cp templates/samples/sub3/AGENTS.md ~/.openclaw/workspace-sub3/AGENTS.md
cp templates/samples/sub3/IDENTITY.md ~/.openclaw/workspace-sub3/IDENTITY.md
cp templates/samples/sub3/TOOLS.md ~/.openclaw/workspace-sub3/TOOLS.md

cp templates/samples/reviewer/SOUL.md ~/.openclaw/workspace-reviewer/SOUL.md
cp templates/samples/reviewer/AGENTS.md ~/.openclaw/workspace-reviewer/AGENTS.md
cp templates/samples/reviewer/IDENTITY.md ~/.openclaw/workspace-reviewer/IDENTITY.md
cp templates/samples/reviewer/TOOLS.md ~/.openclaw/workspace-reviewer/TOOLS.md
```

4. Import identities to agent config.

```bash
openclaw agents set-identity --workspace ~/.openclaw/workspace-orchestrator --from-identity
openclaw agents set-identity --workspace ~/.openclaw/workspace-sub1 --from-identity
openclaw agents set-identity --workspace ~/.openclaw/workspace-sub2 --from-identity
openclaw agents set-identity --workspace ~/.openclaw/workspace-sub3 --from-identity
openclaw agents set-identity --workspace ~/.openclaw/workspace-reviewer --from-identity
```

5. Apply Discord swarm config sample and validate bindings.

```bash
openclaw agents list --bindings --json
openclaw channels status --probe
openclaw gateway status
```

## Provider Setup (API + OAuth)

API-key paths:

```bash
openclaw onboard --openai-api-key "$OPENAI_API_KEY"
openclaw onboard --anthropic-api-key "$ANTHROPIC_API_KEY"
```

OAuth/setup-token paths:

```bash
openclaw onboard --auth-choice openai-codex
openclaw models auth login --provider openai-codex

claude setup-token
openclaw onboard --auth-choice setup-token

openclaw plugins enable qwen-portal-auth
openclaw models auth login --provider qwen-portal --set-default
```

Provider mapping guidance:

- Orchestrator: high-reasoning model.
- Sub agents: balanced cost/performance models.
- Reviewer: reliable model with strict quality checks.

## Config Sample

Use `openclaw.discord.swarm.sample.json5` as the base and replace placeholders.

## Prompt Starters

Use `PROMPTS.md` for role-specific task prompts.
