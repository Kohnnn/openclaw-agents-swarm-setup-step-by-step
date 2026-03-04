# Claw-Empire FTS Integration: Fintech Startup

This folder contains the custom source overrides and agent configurations needed to enable the **FTS: Fintech Startup** Office Pack in your Claw-Empire workspace.

## What is the FTS Office Pack?

The **FTS** (Fintech Startup) configuration replaces the standard default team with an elite 9-agent autonomous unit separated into three departments:

1. **Planning & Architecture** (PM & Security Compliance)
   - **Orchestrator** (Team Leader, Claude)
   - **Security Architect** (Senior, Gemini)
2. **Core Engineering** (Dev & Data)
   - **Sub1** (Frontend Engineer, Senior, Codex)
   - **Sub2** (Backend Engineer, Junior, Claude)
   - **Sub3** (DevOps & Cloud Engineer, Junior, Gemini)
   - **Data Engineer** (Data Pipelines, Senior, Codex)
3. **Quality & Compliance** (QA & Audit)
   - **Reviewer** (QA Lead, Team Leader, Codex)
   - **Test Automation Engineer** (E2E Testing, Senior, Claude)
   - **Compliance Auditor** (Financial Regulations, Junior, Gemini)

## How It Works

Because the `claw-empire` repository itself is git-ignored (we prefer to clone it down clean from the upstream repo), the actual source code modifications for the new themes and packs have been extracted into this directory:

- `src/types/index.ts`
- `src/app/office-workflow-pack.ts`
- `server/modules/workflow/packs/definitions.ts`
- `server/modules/routes/core/tasks/execution-run-auto-assign.ts`

### Automatic Installation

The root `setup_claw_empire.bat` script automatically manages this integration for you:

1. It `git clone`s or `git pull`s the raw `claw-empire` project.
2. It installs all `pnpm` dependencies.
3. It recursively copies all `src/` and `server/` overrides from this template folder straight into the live `claw-empire` directory to overlay the FTS settings.
4. It calls `npm run build` to re-compile the Vite frontend and the Node.js backend.
5. It runs `node --experimental-sqlite register_agents.js` to insert the 9 custom FTS agents specifically under the `workflow_pack_key: 'fts'`.

With this setup, the FTS Office Pack and its associated agent avatars will natively appear in your application without risking the loss of your changes if you delete or update the `claw-empire` folder!
