<div align="center">

# 🤖 AgentsSwarm (Powered by OpenClaw)

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](http://makeapullrequest.com)
[![OpenClaw](https://img.shields.io/badge/Powered%20By-OpenClaw-blue.svg)](https://github.com/SamurAIGPT/awesome-openclaw)

**A fully automated, scalable multi-agent swarm ecosystem designed for true autonomy.**
<br/>
Control and orchestrate an entire software agency or daily workflow system directly from Discord, Telegram, Slack, or WhatsApp. <b>100% Zero-Code Friendly.</b>

</div>

---

## 📖 Table of Contents
- [Features](#-features)
- [Quick Start & Installation](#-quick-start--installation)
- [Detailed Deployment Guide (New!)](DEPLOYMENT_GUIDE.md)
- [Architecture: How It Works](#-architecture-how-it-works)
    - [The Agent Progression](#the-agent-progression)
- [Advanced CI/CD Swarm Layer (Highlight)](#-advanced-cicd-swarm-layer-highlight)
- [The Claw Ecosystem](#-the-claw-ecosystem)
- [Codex Comparison](#-codex-comparison)
- [Discover Use Cases (New!)](USECASES.md)
- [Credits & Acknowledgements](#-credits--acknowledgements)

---

## ✨ Features
- **Multi-Platform Native:** Control your swarm from Discord, WhatsApp, Telegram, or Slack seamlessly.
- **Micro to Monolith:** Scale from a single 5MB background process to a massive enterprise CI/CD powerhouse.
- **Pluggable Architecture:** Effortlessly attach memory layers (SQLite, Postgres, Markdown) and external skills.
- **Automated QA Loops:** Built-in reviewer agents that lint, typecheck, and validate code autonomously.

---

## 🚀 Quick Start & Installation

Getting your first Swarm online requires absolutely no coding experience. Follow these steps.

### Prerequisites
1. **Node.js** (v18 or higher) installed on your system.
2. A **Discord Base** (or Telegram/WhatsApp) with admin privileges to add bots.

### Installation
Clone this repository and install the initial dependencies:
```bash
git clone https://github.com/your-username/AgentsSwarm.git
cd AgentsSwarm
npm install
```

### Configuration
Create a `.env` file in the root directory and add your Bot Tokens and API Keys:
```env
DISCORD_TOKEN_ORCHESTRATOR=your_token_here
DISCORD_TOKEN_SUBAGENT_1=your_token_here
OPENAI_API_KEY=your_key_here
```
Run the initialization script:
```bash
npm run swarm:start
```

> **🔥 Ready to launch the full pipeline?**  
> For detailed instructions on running multiple agents simultaneously (Orchestrator + CI/CD Reviewers) via PM2 or multiple terminals, please read the full **[Step-by-Step Deployment Guide](DEPLOYMENT_GUIDE.md)**!

---

## 🧠 Architecture: How It Works

Understanding your new Swarm begins with understanding the core anatomy of an individual Agent.

### The Agent Progression

**1. The Atom**  
Every autonomous swarm begins here—an LLM capable of making decisions and executing actions through specific tools. It is the basic bridge between thought and capability.
<p align="center">
  <img src="images/step1theatom.jpg" alt="The Atom" width="600"/>
</p>

**2. Adding the Interface**  
An agent needs to communicate where humans naturally gather. By attaching a messaging layer, we bring the agent directly to platforms like Discord, Telegram, or WhatsApp.
<p align="center">
  <img src="images/step2addingthemessaging.jpg" alt="Adding Messaging Interface" width="600"/>
</p>

**3. The Agent Loop**  
The agent evaluates the given prompt, acts by calling a tool, observes the results, and loops this process repeatedly until it is satisfied the objective is fully achieved.
<p align="center">
  <img src="images/step3theagentloop.jpg" alt="The Agent Loop" width="600"/>
</p>

**4. Memory & Skills**  
To be scalable, the agent needs persistent context. We provide it with a long-term Memory System and a Skill System (APIs, custom scripts, database access) to interact with complex external environments.
<p align="center">
  <img src="images/step4memorryandskill.jpg" alt="Memory and Skill system" width="600"/>
</p>

---

## 👑 Advanced CI/CD Swarm Layer (Highlight)

When you are ready to move beyond simple chatbots, the system evolves into extreme automation. This is the **Swarm Architecture**—where OpenClaw becomes an autonomous enterprise factory that never sleeps.

<p align="center">
  <img src="images/agentsystem.jpg" alt="Agents System CI/CD Flow" width="800"/>
</p>

### The Workflow:
1. **Input Ingestion:** The Orchestrator safely ingests real-time inputs natively (Sentry error logs, Support Tickets, user prompts, Meeting Notes).
2. **Specialized Delegation:** The Orchestrator queries long-term Obsidian/DB memories, then creates and delegates tasks simultaneously to *Codex Agents*, *Claude Agents*, and *Gemini Agents*.
3. **The Review Pipeline:** Sub-agent output is never blindly merged. It is piped directly into a GitHub CI/CD pipeline enforcing: `Lint -> Typecheck -> Unit Tests -> E2E -> AI Code Reviewers`.
4. **Resolution:** If the pipeline fails, it loops back to the sub-agents. When it passes, the manager is pinged on Telegram with the finalized deployment.

---

## 🏗️ The Claw Ecosystem

Different tasks require different foundational constraints. The open-source ecosystem provides varied framework backends tailored to your deployment strategy.

<p align="center">
  <img src="images/comparediffrentclaw.jpg" alt="Compare Different Claws" width="700"/>
</p>

Depending on your need for speed, memory constraint, or language preference, you can dynamically swap the underlying agent architectures:

| Name | Engine / Focus | Diagram |
|---|---|---|
| [**NanoClaw**](https://github.com/qwibitai/nanoclaw) | Lightweight TypeScript. Ideal for single channels like WhatsApp. | <img src="images/nanoclaw.jpg" width="300"/> |
| [**Nanobot**](https://github.com/HKUDS/nanobot) | Minimal Python agent utilizing simple Markdown memory formats. | <img src="images/nanobot.jpg" width="300"/> |
| [**PicoClaw**](https://github.com/sipeed/picoclaw) | Super efficient Go framework. Perfect for specific edge utility tasks. | <img src="images/picoclaw.jpg" width="300"/> |
| [**IronClaw**](https://github.com/nearai/ironclaw) | Secure, containerized Rust implementation utilizing WASM for strict boundaries. | <img src="images/ironclaw.jpg" width="300"/><br/><img src="images/irronclaw2.jpg" width="300"/> |
| [**ZeroClaw**](https://github.com/zeroclaw-labs/zeroclaw) | Hybrid flexible Rust architecture with powerful trait-based plugin support. | <img src="images/zeroclaw.jpg" width="300"/> |
| [**OpenClaw**](https://github.com/openclaw/openclaw) | The ultimate TypeScript mono-orchestrator. Supports 11+ channels and SQL memory. | <img src="images/openclaw.jpg" width="300"/> |

### Comprehensive Comparison Matrix
Need deep metrics to choose your base? View the data below:
<p align="center">
  <img src="images/detailtablecomparrisonallclaw.png" alt="Detailed Table Comparison" width="800"/>
</p>

---

## ⚔️ Codex Comparison

How does the OpenClaw orchestration method hold up against strict coding specialists like Codex? Extremely well, particularly in open-ended infrastructure workflows.
<p align="center">
  <img src="images/OpenClaw and Codex comparison.png" alt="OpenClaw versus Codex" width="800"/>
</p>

---

## � Credits & Acknowledgements

The foundational architectures, framework progression methodologies, and visual models powering this repository were natively drawn from invaluable contributions by the community:

- **@MisbahSy** for the underlying operational layout and agent capability progressions.
- **@elvissun** for the brilliant "Agent System Swarm" CI/CD integration architecture.
- **@hesamsheikh** for pioneering seamless multi-platform workflow integrations.
- **@123olp** and **@JXiaoLoong** for extended insights into infrastructure bounds and routing logic.
