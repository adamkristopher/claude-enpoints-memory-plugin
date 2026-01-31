#!/bin/bash
# SessionEnd hook - Save session transcript to Endpoints API

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PLUGIN_DIR="$(dirname "$SCRIPT_DIR")"

# Load config
source "$PLUGIN_DIR/scripts/config.sh" 2>/dev/null || exit 0

# Read session data from stdin
INPUT=$(cat)

# Only proceed if we have valid input
if [[ -z "$INPUT" ]]; then
  exit 0
fi

# Extract transcript path from the session data
TRANSCRIPT_PATH=$(echo "$INPUT" | jq -r '.transcript_path // empty' 2>/dev/null)

# POST cleaned transcript as JSON
if [[ -n "$TRANSCRIPT_PATH" ]] && [[ -f "$TRANSCRIPT_PATH" ]]; then
  # Clean and structure the transcript as JSON
  CLEANED_JSON=$("$PLUGIN_DIR/scripts/clean-transcript.sh" "$TRANSCRIPT_PATH" 2>/dev/null)

  if [[ -n "$CLEANED_JSON" ]] && [[ "$CLEANED_JSON" != *"error"* ]]; then
    curl -s -X POST \
      -H "Authorization: Bearer $ENDPOINTS_API_KEY" \
      -F "texts=$CLEANED_JSON" \
      -F "prompt=claude-memory - sessions" \
      "$ENDPOINTS_API_URL/api/scan" > /dev/null 2>&1
  fi
fi

exit 0
