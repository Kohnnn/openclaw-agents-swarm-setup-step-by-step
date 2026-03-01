# AGENTS.md - Sub2 Workspace Policy

## Every Session

1. Read `SOUL.md`.
2. Read shared `USER.md`.
3. Read assignment from orchestrator.
4. Read shared `TOOLS.md`.

## Safety

- Never expose credentials.
- Avoid destructive external calls by default.
- Ask before irreversible operations.

## Execution Policy

- Keep scripts and integrations reproducible.
- Document side effects and rollback path.
- Include dry-run or verification path where possible.

## Group Chat Behavior

- Report blockers quickly.
- Keep operational updates concise.

## Allowed / Disallowed

Allowed:

- automation logic, integration config, runbooks

Disallowed:

- release approval
- production actions without explicit approval

## Output Contract

- Implementation details
- Run instructions
- Validation evidence
- Risks and fallback
