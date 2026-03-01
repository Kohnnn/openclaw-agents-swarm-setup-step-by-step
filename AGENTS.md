# AGENTS.md

This file provides operating guidance for autonomous coding/documentation agents
working in `AgentsSwarm`.

## 1) Repository Purpose and Current State
- Primary artifact type: Markdown documentation (`README.md`, setup/deployment guides, use cases).
- Static assets: architecture images under `images/`.
- No first-party application source code is currently tracked.
- No package manifest (`package.json`, `pyproject.toml`, `Cargo.toml`, `go.mod`) is present.
- No CI workflow definitions were found in `.github/workflows/`.
- Treat this repo as docs + assets unless the user explicitly adds runtime code.

## 2) Repository Map
- `README.md`: main overview and onboarding.
- `OPENCLAW_SETUP.md`: model provider + messaging integration setup.
- `DEPLOYMENT_GUIDE.md`: multi-backend deployment walkthrough.
- `USECASES.md`: curated community use cases.
- `images/`: diagrams and ecosystem comparison images.
- `.agent/memory_bank/`: local agent memory (ignored by git; do not rely on it as source of truth).

## 3) Cursor / Copilot Rule Files
- Checked for `.cursor/rules/**`, `.cursorrules`, and `.github/copilot-instructions.md`.
- None were found in this repository at the time this file was generated.
- If these files are added later, treat them as highest-priority repository-specific instructions.
- Re-run discovery before major edits:
  - `glob "**/.cursor/rules/**"`
  - `glob "**/.cursorrules"`
  - `glob "**/.github/copilot-instructions.md"`

## 4) Build, Lint, and Test Commands

### 4.1 Current Reality (Important)
- There is no native build/lint/test pipeline configured in this repo today.
- Commands like `npm run build` mentioned in docs refer to external OpenClaw-family repos, not this repository itself.
- Do not claim tests passed unless you actually ran an available command in this repo.

### 4.2 Useful Local Validation Commands for This Docs Repo
- Validate Markdown formatting (all files):
  - `npx markdownlint-cli2 "**/*.md"`
- Validate one Markdown file (single-target lint):
  - `npx markdownlint-cli2 "README.md"`
- Check markdown formatting with Prettier:
  - `npx prettier --check "**/*.md"`
- Auto-format markdown:
  - `npx prettier --write "**/*.md"`
- Check for broken links in one file (if tool installed):
  - `npx markdown-link-check README.md`
- Check for broken links in all docs (PowerShell):
  - `Get-ChildItem -Filter *.md | ForEach-Object { npx markdown-link-check $_.FullName }`

### 4.3 Single-Test / Focused Verification Guidance
- There is no unit-test framework configured yet, so "single test" means targeted validation.
- Preferred targeted checks:
  - Single file lint: `npx markdownlint-cli2 "OPENCLAW_SETUP.md"`
  - Single file format check: `npx prettier --check "DEPLOYMENT_GUIDE.md"`
  - Single file link check: `npx markdown-link-check USECASES.md`
- If a test framework is introduced later, document exact single-test command here immediately.

### 4.4 Commands Documented in Repo Content (External Projects)
These appear in docs but are not executable in this repo without additional codebases:
- `npm install`
- `npm run swarm:start`
- `npm run build`
- `npm run start`
- `pm2 start ecosystem.config.js`
- `cargo build --release`
- `docker-compose up -d --build orchestrator coder reviewer`
- `go build -o picoclaw main.go`
- `poetry run python -m nanobot.swarm orchestrator coder reviewer`
- `bun start_orchestrator.ts` / `bun start_coder.ts` / `bun start_reviewer.ts`
- `ollama run llama3`

## 5) Change Scope Rules for Agents
- Prefer editing existing markdown files over adding new files unless requested.
- Preserve image references exactly; file names include intentional/legacy spelling variants.
- Do not rename or move files in `images/` unless all references are updated.
- Keep changes minimal, task-focused, and consistent with existing tone.

## 6) Documentation Style Guidelines (Current Repo Conventions)

### 6.1 Headings and Structure
- Use one `#` H1 per file.
- Use descriptive `##` section headers; `###` only when needed.
- Existing docs use emoji-rich headings; keep style consistent inside edited file.
- Separate major sections with `---` where the file already follows that pattern.
- Prefer short, skimmable sections with clear action-oriented titles.

### 6.2 Lists and Emphasis
- Use `-` bullets for unordered points.
- Use numbered lists for ordered setup steps.
- Bold only the important lead phrase, not full paragraphs.
- Avoid deeply nested lists unless they materially improve clarity.

### 6.3 Code Fences and Snippets
- Always add language tags: `bash`, `env`, `json`, etc.
- Keep commands copy/paste ready.
- Do not include machine-specific absolute paths unless required.
- For config snippets, include only relevant keys.
- Never place real credentials in examples.

### 6.4 Links and References
- Use relative links for repo-internal docs and images.
- Verify anchor text matches destination intent.
- Prefer explicit file links like `[OpenClaw Setup Guide](OPENCLAW_SETUP.md)`.
- Re-check links after renaming any heading or file.

## 7) Code Style Guidelines (For Future Code or Snippets)

### 7.1 Imports and Module Boundaries
- Prefer explicit imports; avoid wildcard imports.
- Group imports: standard library, third-party, local modules.
- Keep side-effect imports rare and documented.
- Remove unused imports before finalizing.
- Favor named exports for shared utilities.

### 7.2 Formatting
- Use consistent indentation (2 spaces for JSON/YAML, language-default elsewhere).
- Keep lines reasonably short for markdown readability.
- Use trailing commas where language tooling expects them.
- Run formatter/linter when available before final handoff.

### 7.3 Types and Data Contracts
- Prefer explicit types for public APIs and complex return values.
- Avoid `any`/untyped structures in TypeScript-like examples.
- Model config objects with stable keys and documented defaults.
- Validate external input at boundaries.
- Keep environment variable names uppercase and descriptive.

### 7.4 Naming Conventions
- Variables/functions: clear, intention-revealing names.
- Constants: uppercase snake case when language convention uses it.
- Files: match ecosystem convention (`kebab-case`, `snake_case`, etc.) consistently.
- Avoid abbreviations unless universally recognized.
- Name by domain intent, not implementation detail.

### 7.5 Error Handling and Logging
- Fail fast on missing required configuration.
- Return actionable error messages with context.
- Do not swallow exceptions silently.
- Include remediation hints in user-facing errors.
- Redact secrets/tokens from logs and error output.

### 7.6 Tests (When Introduced)
- Co-locate tests per project convention and document it.
- Add/update tests for behavioral changes.
- Prefer deterministic tests; avoid network dependency by default.
- Document exact single-test command in this file once framework exists.
- Never mark tests as passing without running them.
