# AGENTS.md

This file provides operating guidance for autonomous coding/documentation agents
working in `AgentsSwarm`.

## 1) Repository Snapshot
- This workspace is **mixed**: root-level docs/assets plus a full TypeScript app in `claw-empire/`.
- Root contains integration/setup docs (`README.md`, `OPENCLAW_SETUP.md`, `DEPLOYMENT_GUIDE.md`, etc.).
- `images/` contains static diagrams referenced by root docs.
- `claw-empire/` is a Node 22 + pnpm project (React/Vite frontend + Express/SQLite backend).
- `claw-empire/` has its own `.git`, CI workflow, tests, and local `AGENTS.md`.

## 2) Repository Map
- Root docs: `README.md`, `OPENCLAW_SETUP.md`, `DEPLOYMENT_GUIDE.md`, `USECASES.md`.
- Root helper docs: `CLAW_EMPIRE_SETUP.md`, `CLAW_EMPIRE_DISCORD_WIRING.md`, `MULTI_AGENT_*.md`.
- Root scripts/templates: `setup_claw_empire.bat`, `start_claw_empire.bat`, `templates/`.
- Root assets: `images/`.
- Application project: `claw-empire/`.
- App source: `claw-empire/src/` (frontend), `claw-empire/server/` (backend), `claw-empire/tests/e2e/`.

## 3) Cursor / Copilot Rule Files
- Checked for `.cursor/rules/**`, `.cursorrules`, and `.github/copilot-instructions.md`.
- Result: **none found** in this workspace at generation time.
- Re-check before major edits:
  - `glob "**/.cursor/rules/**"`
  - `glob "**/.cursorrules"`
  - `glob "**/.github/copilot-instructions.md"`
- Note: `claw-empire/AGENTS.md` exists and should be treated as local project guidance when editing inside `claw-empire/`.

## 4) Environment and Execution Baseline
- Use Node.js `>=22` for `claw-empire/` (declared in `claw-empire/package.json`).
- Use pnpm (lockfile and packageManager are present in `claw-empire/`).
- From repo root, prefer `pnpm --dir claw-empire <command>`.
- Equivalent: run the same script inside `claw-empire/` with `pnpm <command>`.
- Never claim lint/test/build success unless commands were actually run.

## 5) Build, Lint, and Test Commands

### 5.1 Root Docs Validation
- Lint all markdown: `npx markdownlint-cli2 "**/*.md"`
- Lint one file: `npx markdownlint-cli2 "OPENCLAW_SETUP.md"`
- Format check markdown: `npx prettier --check "**/*.md"`
- Auto-format markdown: `npx prettier --write "**/*.md"`
- Link check one file (if available): `npx markdown-link-check README.md`

### 5.2 Claw-Empire Install/Run/Build
- Install deps: `pnpm --dir claw-empire install --frozen-lockfile`
- Dev (web + api): `pnpm --dir claw-empire run dev`
- Dev (local host): `pnpm --dir claw-empire run dev:local`
- Dev (e2e runtime): `pnpm --dir claw-empire run dev:e2e`
- Production build: `pnpm --dir claw-empire run build`
- Preview build: `pnpm --dir claw-empire run preview`
- Start server: `pnpm --dir claw-empire run start`

### 5.3 Lint, Format, Typecheck
- ESLint: `pnpm --dir claw-empire run lint`
- ESLint auto-fix: `pnpm --dir claw-empire run lint:fix`
- Prettier check: `pnpm --dir claw-empire run format:check`
- Prettier write: `pnpm --dir claw-empire run format`
- Type check: `pnpm --dir claw-empire exec tsc -p tsconfig.json --noEmit`
- OpenAPI contract check: `pnpm --dir claw-empire run openapi:check`

### 5.4 Test Commands (Full Suites)
- Frontend unit/integration: `pnpm --dir claw-empire run test:web`
- Backend unit/integration: `pnpm --dir claw-empire run test:api`
- E2E: `pnpm --dir claw-empire run test:e2e`
- Main test suite (web + api): `pnpm --dir claw-empire run test`
- CI test suite (coverage + e2e): `pnpm --dir claw-empire run test:ci`

### 5.5 Single-Test / Focused Verification (Important)
- Single frontend test file: `pnpm --dir claw-empire run test:web -- src/hooks/usePolling.test.tsx`
- Single frontend test by name: `pnpm --dir claw-empire run test:web -- src/hooks/usePolling.test.tsx -t "initial"`
- Single backend test file: `pnpm --dir claw-empire run test:api -- server/security/auth.test.ts`
- Single backend test by name: `pnpm --dir claw-empire run test:api -- server/security/auth.test.ts -t "세션 발급"`
- Single e2e spec: `pnpm --dir claw-empire run test:e2e -- tests/e2e/smoke.spec.ts`
- Single e2e test by title: `pnpm --dir claw-empire run test:e2e -- --grep "loads application shell"`
- Single file lint: `pnpm --dir claw-empire exec eslint server/security/auth.ts`
- Single file format check: `pnpm --dir claw-empire exec prettier --check server/security/auth.ts`
- Focused docs check: `npx markdownlint-cli2 "DEPLOYMENT_GUIDE.md"`

### 5.6 CI-Equivalent Local Sequence (`claw-empire/`)
- `pnpm run format:check`
- `pnpm run lint`
- `pnpm run openapi:check`
- `pnpm exec tsc -p tsconfig.json --noEmit`
- `pnpm run build`
- `pnpm exec playwright install --with-deps` (if browser deps missing)
- `pnpm run test:ci`

## 6) Change Scope and Safety
- Keep edits minimal and task-focused; avoid opportunistic refactors.
- Do not delete/overwrite user data files (`*.sqlite`, logs, `.env`) unless explicitly requested.
- Do not commit secrets/tokens from env files or runtime logs.
- Preserve docs links/image references when editing markdown.
- If changing commands in docs, prefer commands that are runnable in this workspace.

## 7) Code Style Guidelines (TypeScript + React + Node)

### 7.1 Imports and Module Boundaries
- Use explicit imports; avoid wildcard imports.
- Group imports logically: third-party, then local modules.
- Prefer `import type` for type-only imports (`@typescript-eslint/consistent-type-imports` is enabled).
- In `server/**/*.ts`, keep local import paths with `.ts` extensions, matching existing files.
- In `src/api.ts` and `src/api/**/*.ts`, respect strict import order and avoid restricted UI-layer imports.

### 7.2 Formatting and Linting
- Prettier baseline (`claw-empire/.prettierrc.json`): print width 120, semicolons, double quotes, trailing commas.
- Run `pnpm --dir claw-empire run format` and `pnpm --dir claw-empire run lint` after non-trivial edits.
- Keep diffs clean; do not reformat unrelated files.
- Honor existing ESLint constraints before adding new exceptions.

### 7.3 Types and Data Contracts
- TypeScript is `strict`; preserve strict-safe patterns.
- Prefer explicit return/input types for exported functions and shared utilities.
- Validate untrusted input at boundaries (API payloads, env vars, external responses).
- Avoid new `any` unless unavoidable; contain and document boundary casts.
- Keep config/env identifiers uppercase and descriptive.

### 7.4 Naming Conventions
- React components: `PascalCase` filenames and symbols (e.g., `TaskBoard.tsx`).
- Hooks: `useXxx` naming in `camelCase` (e.g., `usePolling.ts`).
- Server modules and utility files: descriptive `kebab-case` (e.g., `meeting-prompt-tools.ts`).
- Constants: `UPPER_SNAKE_CASE` for true constants, otherwise clear `camelCase` names.
- Tests: colocated `*.test.ts` / `*.test.tsx` or `*.spec.ts` / `*.spec.tsx`.

### 7.5 Error Handling and Logging
- Fail fast on missing/invalid required config, with actionable messages.
- Use structured API errors (`{ error: "..." }`) for HTTP handlers.
- Prefer typed/custom errors for domain failures (example pattern: `ApiRequestError`).
- Never silently swallow unexpected errors; if intentionally ignored, keep it narrowly scoped.
- Never log secrets (`API_AUTH_TOKEN`, `INBOX_WEBHOOK_SECRET`, OAuth tokens, cookies).

### 7.6 Testing Expectations
- Add or update tests with behavior changes.
- Prefer deterministic tests (mock timers/network where practical).
- Keep frontend tests under `src/**/*.{test,spec}.{ts,tsx}` and backend tests under `server/**/*.{test,spec}.ts`.
- Keep e2e scenarios under `tests/e2e/*.spec.ts`.
- For bug fixes, include at least one regression test or explain why not feasible.

## 8) Documentation Style Guidelines (Root Docs)
- Use one `#` H1 per markdown file.
- Prefer short sections with descriptive `##`/`###` headers.
- Use `-` bullets for unordered lists and numbered lists for procedures.
- Use language-tagged code fences (`bash`, `json`, `env`, etc.).
- Use relative links for repo-local docs/assets and verify targets after edits.
