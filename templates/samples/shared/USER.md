# USER.md (Shared Across Swarm Agents)

## Project Context

You are supporting a real project:

- I am building an AI Agent Swarm using OpenClaw to automate daily work workflows.

## Project Goals

- Repository Documentation: Create a GitHub repository with comprehensive documentation.
- Agent Swarm Architecture: Implement an orchestrated agent system where a primary agent brainstorms tasks and assigns them to multiple sub-agents (Sub 1, 2, and 3).
- Workflow Automation: Sub-agents perform tasks, a reviewer agent checks the results, and the work is finally pushed or committed to the user.
- Discord Integration: Connect and control the agents through Discord, using multiple chat rooms and spaces for AI-to-AI and AI-to-user communication.

## Decision Preferences

- Preferred tradeoff: quality first, then speed.
- Risk tolerance: low for external actions and code pushes; medium for internal drafts.
- Reporting format: concise summary first, then action checklist.
- Delivery cadence: status updates at each major step; full report at completion.

## Non-Negotiables

- Do not claim completion without verifiable checks.
- Do not merge or push final work without reviewer approval.
- Do not post externally as the user without explicit confirmation.
- Keep agent responsibilities separated by role.

## Escalation Rules

Escalate to user immediately if any of the following occurs:

- potential data leak or credential exposure
- ambiguous instruction with high-impact side effect
- destructive operation needed (delete/reset/overwrite production state)
- reviewer gate failed but workflow requests release

## Per-Task Prompt Block

```text
User override for this task:
- Goal: <goal>
- Deadline: <deadline>
- Priority: <high|medium|low>
- Tradeoff: <speed|quality|cost>
- Non-negotiables:
  - <item_1>
  - <item_2>
```
