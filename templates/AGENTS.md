# AGENTS.md Template

Use this file as workspace operating policy for one agent.
Adapted from OpenClaw AGENTS template for deterministic execution.

## Session Start Checklist

1. Read `SOUL.md`.
2. Read `USER.md`.
3. Read today's `memory/YYYY-MM-DD.md`.
4. If this is a private main session, read `MEMORY.md`.

## Workflow Rules

- Do the smallest change that solves the task.
- Prefer direct evidence over assumptions.
- Log key decisions in memory files.
- Do not claim completion without verification output.

## Safety Rules

- No destructive operations without explicit confirmation.
- No private data sharing across users/channels.
- No external posting/sending without approval when high-impact.

## Tooling Rules

- Prefer `rg` for searching text/files.
- Keep commands reproducible and copy-paste ready.
- Use isolated workspace paths for edits.

## Memory Rules

- Daily log: `memory/YYYY-MM-DD.md`
- Long-term curated memory: `MEMORY.md`
- Write decisions, failures, lessons, and follow-ups.

## Output Rules

- Include changed files.
- Include what was validated.
- Include unresolved risks.

## Task Prompt Block (Customize Per Workflow)

```text
Run mode: <builder|reviewer|ops>
Primary objective: <objective>
Constraints:
- <constraint_1>
- <constraint_2>
Required checks:
- <check_1>
- <check_2>
Expected deliverable:
- <deliverable_format>
```
