# System Context

## Technology Stack
- **Framework/Platform**: OpenClaw / ZeroClaw
- **Communication Platforms**: Discord, Telegram, Slack, WhatsApp (and other supported IMs)
- **Documentation**: Markdown (GitHub README)

## Design Patterns & Architecture
- **Agent Roles**:
  - `Orchestrator Agent`: Top-level planner and brainstormer.
  - `Sub-agents`: Specialized agents (e.g., 1, 2, 3) to execute specific tasks limitlessly across platforms.
  - `Reviewer Agent`: QA and assessment of sub-agent outputs with strict rule enforcement.
- **Workflow / Communication**:
  - Multi-platform integrations. Bots use respective channels/rooms or groups for agent-to-agent and user-to-agent communication.
  - Seamless execution combining varied use-case patterns (e.g., Hesam's workflow patterns + Agent Swarm conceptual flows).
  - Results from the reviewer are committed or pushed directly.
  - Single runtime/computer executing multiple OpenClaw instances.

## Core Directives
1. Focus on "no-code friendly" setups.
2. Abstract and integrate our proprietary images into the documentation flow cleanly.
3. Steps should heavily detail setup and linking of multiple instances to ZeroClaw/OpenClaw across any popular chat platform.
