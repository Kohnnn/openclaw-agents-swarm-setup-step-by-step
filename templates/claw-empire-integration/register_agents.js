import { DatabaseSync } from 'node:sqlite';
import { readFileSync, existsSync } from 'node:fs';
import { join, dirname } from 'node:path';
import { randomUUID } from 'node:crypto';
import { fileURLToPath } from 'node:url';

const __dirname = dirname(fileURLToPath(import.meta.url));
const DB_PATH = join(__dirname, '..', '..', 'claw-empire', 'claw-empire.sqlite');
const AGENTS_FILE = join(__dirname, 'agents.json');
const PACK_KEY = 'fts';

function main() {
    console.log('[FTS Integration] Starting agent registration...');

    // 1. Read agent definitions
    let agentsToRegister = [];
    try {
        agentsToRegister = JSON.parse(readFileSync(AGENTS_FILE, 'utf8'));
    } catch (err) {
        console.error('[FTS Integration] Error reading agents.json:', err.message);
        process.exit(1);
    }

    // 2. Open DB
    if (!existsSync(DB_PATH)) {
        console.error(`[FTS Integration] DB not found at ${DB_PATH}. Claw-Empire must run at least once first.`);
        process.exit(1);
    }

    const db = new DatabaseSync(DB_PATH);

    // 3. Build lookup of existing agents by name -> id
    const existingAgents = new Map(
        db.prepare('SELECT id, name FROM agents').all().map(r => [r.name, r.id])
    );

    const insertAgent = db.prepare(`
        INSERT INTO agents (id, name, name_ko, department_id, role, cli_provider, avatar_emoji, personality, workflow_pack_key)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
    `);

    const updatePackKey = db.prepare(
        `UPDATE agents SET workflow_pack_key = ?, department_id = ?, role = ?, cli_provider = ?, avatar_emoji = ?, personality = ? WHERE name = ?`
    );

    let insertedCount = 0;
    let updatedCount = 0;

    for (const agent of agentsToRegister) {
        if (existingAgents.has(agent.name)) {
            // Update existing agent to FTS pack
            try {
                updatePackKey.run(
                    PACK_KEY,
                    agent.department_id,
                    agent.role,
                    agent.cli_provider,
                    agent.avatar_emoji || '🤖',
                    agent.personality || null,
                    agent.name
                );
                console.log(`  ~ Updated to FTS pack: ${agent.name}`);
                updatedCount++;
            } catch (err) {
                console.error(`  ! Failed to update ${agent.name}:`, err.message);
            }
        } else {
            // Insert new agent
            try {
                insertAgent.run(
                    randomUUID(),
                    agent.name,
                    agent.name,
                    agent.department_id,
                    agent.role,
                    agent.cli_provider,
                    agent.avatar_emoji || '🤖',
                    agent.personality || null,
                    PACK_KEY
                );
                console.log(`  + Registered: ${agent.name} (${agent.department_id} / ${agent.role})`);
                insertedCount++;
            } catch (err) {
                console.error(`  ! Failed to register ${agent.name}:`, err.message);
            }
        }
    }

    db.close();
    console.log(`[FTS Integration] Done! Inserted: ${insertedCount}, Updated: ${updatedCount}`);
}

main();


