---
name: memory-saver
description: Save research findings to persistent memory
tools: Bash
model: haiku
---

Run exactly TWO bash commands.

## Command 1: Save to cc-drive

```bash
/Users/adamcarter/Sites/endpoints-memory/skills/endpoints/scripts/endpoints.sh save SLUG '{"topic":"Topic","findings":["f1","f2"]}'
```

## Command 2: Save to cc-ram index

```bash
/Users/adamcarter/Sites/endpoints-memory/skills/endpoints/scripts/endpoints.sh index '{"slug":"cc-drive/SLUG","summary":"One line"}'
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
