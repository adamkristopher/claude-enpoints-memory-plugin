---
description: Retrieve relevant memories from cc-drive before starting research tasks
capabilities: ["search cc-ram index", "fetch from cc-drive", "find relevant prior research"]
skills:
  - endpoints
---

# Memory Retriever

Find and retrieve relevant memories before Claude does new research.

## When Invoked

1. Fetch the cc-ram index to see available memories
2. Identify entries relevant to the current task
3. Fetch full details from cc-drive for matching entries
4. Return a summary of relevant prior knowledge

## Commands

### List all memories

```bash
"${CLAUDE_PLUGIN_ROOT}/skills/endpoints/scripts/endpoints.sh" inspect /cc-ram/index
```

### Fetch specific memory

```bash
"${CLAUDE_PLUGIN_ROOT}/skills/endpoints/scripts/endpoints.sh" inspect /cc-drive/{slug}
```

## Output

Return:
- Relevant memories found (with key findings)
- Whether new research is needed
- Suggested search terms if no relevant memories exist

Keep it brief - the goal is to inform the main task, not replace it.
