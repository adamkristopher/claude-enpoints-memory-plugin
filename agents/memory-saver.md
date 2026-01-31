---
description: Save research findings to persistent memory (cc-drive + cc-ram index)
capabilities: ["save research to cc-drive", "update cc-ram index", "summarize session learnings"]
---

# Memory Saver

Save session learnings to persistent memory via the Endpoints API.

## Commands

Run exactly TWO bash commands:

### 1. Save to cc-drive

```bash
"${CLAUDE_PLUGIN_ROOT}/skills/endpoints/scripts/endpoints.sh" save SLUG '{"topic":"Topic","key_findings":["f1","f2"],"sources":["source"],"context":"Why researched"}'
```

### 2. Update cc-ram index

```bash
"${CLAUDE_PLUGIN_ROOT}/skills/endpoints/scripts/endpoints.sh" index '{"slug":"cc-drive/SLUG","summary":"One line summary","keywords":["term1","term2"]}'
```

Replace SLUG with kebab-case name. Put your findings in the JSON.

## What to Capture

- **topic**: Human readable name
- **key_findings**: The important discoveries (be specific, include code patterns, file paths, URLs)
- **sources**: Where the information came from
- **context**: Why this was being researched
- **summary**: One concise line for the index

## Output

After saving, briefly confirm:
- Slug used
- Key points captured

Keep it concise - the user cares about their task, not memory mechanics.
