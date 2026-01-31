#!/bin/bash
# Clean a Claude Code transcript for memory storage
# Outputs structured JSON with conversation content

# Get input file
if [[ -n "$1" ]] && [[ -f "$1" ]]; then
  TRANSCRIPT_FILE="$1"
else
  echo '{"error": "No transcript file provided"}' >&2
  exit 1
fi

# Extract session metadata from first few lines
SESSION_ID=$(head -20 "$TRANSCRIPT_FILE" | jq -r 'select(.sessionId) | .sessionId' 2>/dev/null | head -1)
CWD=$(head -20 "$TRANSCRIPT_FILE" | jq -r 'select(.cwd) | .cwd' 2>/dev/null | head -1)
TIMESTAMP=$(head -20 "$TRANSCRIPT_FILE" | jq -r 'select(.timestamp) | .timestamp' 2>/dev/null | head -1)

# Extract conversation as array of messages
MESSAGES=$(cat "$TRANSCRIPT_FILE" | jq -c '
  select(.type == "user" or .type == "assistant") |
  if .message.content then
    if (.message.content | type) == "array" then
      .message.content[] |
      select(.type == "text") |
      {role: "assistant", content: .text}
    elif (.message.content | type) == "string" then
      if (.message.content | test("^<local-command|^<system-reminder|^<command-name>/login|^<local-command-stdout>")) then
        empty
      else
        {role: "user", content: (.message.content | gsub("<[^>]+>"; "") | gsub("\\s+"; " ") | ltrimstr(" ") | rtrimstr(" "))}
      end
    else
      empty
    end
  else
    empty
  end
' 2>/dev/null | jq -s '.' 2>/dev/null)

# Build final JSON object
jq -n \
  --arg session_id "$SESSION_ID" \
  --arg cwd "$CWD" \
  --arg timestamp "$TIMESTAMP" \
  --argjson messages "${MESSAGES:-[]}" \
  '{
    session_id: $session_id,
    cwd: $cwd,
    timestamp: $timestamp,
    messages: $messages
  }'
