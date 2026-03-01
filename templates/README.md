# Agent Template Pack

This folder contains starter templates for per-agent injection:

- `SOUL.md`
- `AGENTS.md`
- `IDENTITY.md`
- `USER.md`
- `TOOLS.md`

Use-case packs:

- `samples/` contains a complete 5-agent swarm template set for Discord:
  `orchestrator`, `sub1`, `sub2`, `sub3`, `reviewer`, plus shared `USER.md`
  and shared `TOOLS.md`.

## Quick Inject Workflow

1. Create agent and find workspace path.

```bash
openclaw agents add coding --workspace ~/.openclaw/workspace-coding
openclaw agents list --json
```

2. Copy templates into that workspace.

```bash
cp templates/SOUL.md ~/.openclaw/workspace-coding/SOUL.md
cp templates/AGENTS.md ~/.openclaw/workspace-coding/AGENTS.md
cp templates/IDENTITY.md ~/.openclaw/workspace-coding/IDENTITY.md
cp templates/USER.md ~/.openclaw/workspace-coding/USER.md
cp templates/TOOLS.md ~/.openclaw/workspace-coding/TOOLS.md
```

3. Replace placeholders (`<...>`) with project-specific values.

4. Apply identity into agent config.

```bash
openclaw agents set-identity --workspace ~/.openclaw/workspace-coding --from-identity
```

5. Validate with a direct turn.

```bash
openclaw agent --agent coding --message "status-check: identity and soul loaded"
```
