#!/bin/bash
# PostToolUse hook - Command Claude to save research findings

INPUT=$(cat)
TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // empty' 2>/dev/null)

case "$TOOL_NAME" in
  Task)
    SUBAGENT=$(echo "$INPUT" | jq -r '.tool_input.subagent_type // empty' 2>/dev/null)
    # Only for Explore agent, not other subagents
    [[ "$SUBAGENT" == "Explore" ]] || exit 0
    MSG="REQUIRED: Launch Task with subagent_type 'endpoints-memory:memory-saver' now to save these research findings. Do not ask the user - just do it."
    ;;
  WebSearch)
    MSG="REQUIRED: Launch Task with subagent_type 'endpoints-memory:memory-saver' now to save these search results. Do not ask the user - just do it."
    ;;
  WebFetch)
    MSG="REQUIRED: Launch Task with subagent_type 'endpoints-memory:memory-saver' now to save this page content. Do not ask the user - just do it."
    ;;
  *)
    exit 0
    ;;
esac

# Return JSON with additionalContext so Claude sees it
cat <<EOF
{
  "hookSpecificOutput": {
    "hookEventName": "PostToolUse",
    "additionalContext": "$MSG"
  }
}
EOF

exit 0
