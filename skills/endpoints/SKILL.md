---
name: endpoints
description: >
  Interact with the Endpoints API to manage document endpoints, scan files, retrieve extracted data,
  and access persistent memory (cc-ram/cc-drive). Use for listing endpoints, scanning documents,
  managing memory, and checking usage stats.
---

# Endpoints API Skill

Interact with the Endpoints document management API for persistent memory (cc-ram/cc-drive).

## Helper Script (Recommended)

Use the helper script - it handles authentication automatically:

```bash
"${CLAUDE_PLUGIN_ROOT}/skills/endpoints/scripts/endpoints.sh" overview
"${CLAUDE_PLUGIN_ROOT}/skills/endpoints/scripts/endpoints.sh" inspect /job-tracker/january
"${CLAUDE_PLUGIN_ROOT}/skills/endpoints/scripts/endpoints.sh" scan-text "Meeting notes" "meeting tracker"
"${CLAUDE_PLUGIN_ROOT}/skills/endpoints/scripts/endpoints.sh" scan-file ./invoice.pdf "invoice tracker"
"${CLAUDE_PLUGIN_ROOT}/skills/endpoints/scripts/endpoints.sh" stats
```

Run with `--help` for all commands.

## Prompt Routing

The `prompt` parameter controls which endpoint items are added to:

| Prompt Format | Behavior | Example |
|---------------|----------|---------|
| `category name` | Creates new endpoint with AI-generated slug | `job tracker` -> `/job-tracker/january-2026` |
| `category - slug` | Adds to existing endpoint | `job-tracker - usds` -> `/job-tracker/usds` |

Use `category - slug` format when adding multiple documents to the same endpoint.

## Memory System

The plugin uses two special endpoints for persistent memory:

### cc-ram (Memory Index)

Quick-reference index of what you know. **Endpoint**: `cc-ram/index`

```bash
# Read index
"${CLAUDE_PLUGIN_ROOT}/skills/endpoints/scripts/endpoints.sh" inspect /cc-ram/index

# Add entry
"${CLAUDE_PLUGIN_ROOT}/skills/endpoints/scripts/endpoints.sh" index '{"slug":"cc-drive/topic-slug","summary":"What was learned","keywords":["term1"]}'
```

### cc-drive (Long-term Storage)

Full research details. **Endpoint**: `cc-drive/{slug}`

```bash
# Save research
"${CLAUDE_PLUGIN_ROOT}/skills/endpoints/scripts/endpoints.sh" save your-slug '{"topic":"Topic Name","key_findings":["Finding 1"],"sources":["url"],"context":"Why researched"}'

# Read research
"${CLAUDE_PLUGIN_ROOT}/skills/endpoints/scripts/endpoints.sh" inspect /cc-drive/your-slug
```

### Slug Naming Conventions

| Content | Pattern | Example |
|---------|---------|---------|
| General research | `{topic}` | `react-server-components` |
| Project-specific | `{project}-{topic}` | `myapp-auth-flow` |
| User preferences | `user-{topic}` | `user-code-style` |

### Memory Workflow

**Saving research:**
1. Save full data to `cc-drive/{slug}`
2. Add index entry to `cc-ram/index` with summary + reference
3. Confirm briefly to user

**Recalling research:**
1. Check cc-ram index for relevant topics
2. Fetch full data from `cc-drive/{slug}`
3. Use stored knowledge before doing new research

## Response Structure

Endpoints use the Living JSON pattern:
- `metadata.oldMetadata` - Historical items (rotated from previous scans)
- `metadata.newMetadata` - Recent items (from latest scan)
- Items are keyed by unique 8-character IDs (e.g., `abc12345`)

## Error Handling

| Status | Meaning |
|--------|---------|
| 401 | Invalid or missing API key |
| 404 | Endpoint or item not found |
| 409 | Endpoint already exists (use scan to add items) |
| 429 | Rate/usage limit exceeded |

## Additional Resources

For complete API documentation including all endpoints, request/response formats, and subscription tiers, see [references/api-reference.md](references/api-reference.md).
