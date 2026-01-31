#!/bin/bash
# PostToolUse hook - Save Explore agent research to Endpoints API

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PLUGIN_DIR="$(dirname "$SCRIPT_DIR")"

# Load config
source "$PLUGIN_DIR/scripts/config.sh" 2>/dev/null || exit 0

# Read the tool result from stdin
INPUT=$(cat)

# Extract tool info
TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // empty' 2>/dev/null)
SUBAGENT_TYPE=$(echo "$INPUT" | jq -r '.tool_input.subagent_type // empty' 2>/dev/null)

# Only process Explore agent results
if [[ "$TOOL_NAME" != "Task" ]] || [[ "$SUBAGENT_TYPE" != "Explore" ]]; then
  exit 0
fi

# Build structured JSON from the input
RESEARCH_JSON=$(echo "$INPUT" | jq '{
  timestamp: (now | todate),
  session_id: .session_id,
  cwd: .cwd,
  agent_type: .tool_input.subagent_type,
  description: .tool_input.description,
  prompt: .tool_input.prompt,
  result: .tool_response.content[0].text
}' 2>/dev/null)

# Only send if we have a result
if [[ -n "$RESEARCH_JSON" ]] && [[ $(echo "$RESEARCH_JSON" | jq -r '.result // empty') != "" ]]; then
  curl -s -X POST \
    -H "Authorization: Bearer $ENDPOINTS_API_KEY" \
    -F "texts=$RESEARCH_JSON" \
    -F "prompt=cc-research - explorer-agent" \
    "$ENDPOINTS_API_URL/api/scan" > /dev/null 2>&1
fi

exit 0
