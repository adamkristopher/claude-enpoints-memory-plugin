# Save

Save this session's learnings to persistent memory.

## What to Do

Review the current conversation for:
- Key discoveries or research findings
- Important decisions made
- Code patterns or architecture learned
- URLs, file paths, or references worth remembering

Then use the **memory-saver** agent to store them:

```
Use the Task tool with subagent_type "endpoints-memory:memory-saver" and include a summary of the key learnings from this conversation in the prompt.
```

## Example Prompt for Agent

When invoking memory-saver, pass the learnings in the prompt:

```
Save these findings:
- Topic: [what was researched]
- Key findings: [bullet points of discoveries]
- Sources: [URLs, files referenced]
- Context: [why this was being worked on]
```

## When to Use

- Before ending a productive session
- After completing research or exploration
- When user says "remember this" or "save to memory"
- At context compaction (PreCompact hook reminds you)

## Skip If

- Session was just Q&A with no new learnings
- Nothing worth remembering long-term
