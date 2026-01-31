---
name: memory
description: >
  Save this session's learnings to persistent memory (cc-drive + cc-ram index).
  Run before exiting or when prompted at context compaction.
---

# Save Session to Memory

Capture what was learned in this session to persistent memory.

## What to Do

Use the **memory-saver** agent (subagent_type: `endpoints-memory:memory-saver`) to:

1. Review the current conversation for key learnings, discoveries, or research findings
2. Save detailed findings to `cc-drive/{slug}` via the Endpoints API
3. Update the `cc-ram/index` with a summary entry pointing to that slug

## When to Use

- Before exiting a productive session
- When prompted at context compaction
- After completing research or exploration
- When the user says "remember this" or "save this"

## Invoke the Agent

```
Use the Task tool with subagent_type "endpoints-memory:memory-saver" to save this session's learnings.
```

The agent has access to:
- Bash and Read tools to review context
- The endpoints skill to save to cc-drive and cc-ram

## Skip If

- Session was just Q&A with no new learnings
- Nothing worth remembering long-term
- User declines when asked
