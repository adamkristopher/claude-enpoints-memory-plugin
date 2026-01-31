# Recall Memories

Review what's stored in persistent memory (cc-ram index).

## Quick Lookup

List all memory entries:

```bash
"${CLAUDE_PLUGIN_ROOT}/skills/endpoints/scripts/endpoints.sh" inspect /cc-ram/index
```

## Fetch Specific Memory

If the index shows a relevant entry, fetch the full details:

```bash
"${CLAUDE_PLUGIN_ROOT}/skills/endpoints/scripts/endpoints.sh" inspect /cc-drive/{slug}
```

Replace `{slug}` with the slug from the index entry.

## Output

Present memories concisely:
- List available topics with their summaries
- If user asks about a specific topic, fetch and summarize the full entry
- Suggest relevant memories if they match the current task
