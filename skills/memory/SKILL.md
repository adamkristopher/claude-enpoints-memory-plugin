---
name: memory
description: Load and search persistent memory from Endpoints API. Use when recalling previous sessions or searching for past context.
---

# Memory Skill

Access persistent memory stored in the Endpoints API.

## Commands

```bash
# Load all memories
~/.claude/plugins/endpoints-memory/scripts/memory.sh load

# Get recent N entries
~/.claude/plugins/endpoints-memory/scripts/memory.sh recent 5

# Search memories
~/.claude/plugins/endpoints-memory/scripts/memory.sh search "authentication"
```

## What Gets Saved Automatically

- **Session transcripts** - Cleaned conversations saved on exit
- **Explore agent research** - Research results captured after each Explore task

## Endpoints

- `/claude-memory/sessions` - Session transcripts
- `/cc-research/explorer-agent` - Explore agent research
