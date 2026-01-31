#!/bin/bash
# SessionStart hook - Load persistent memory from Endpoints API

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PLUGIN_DIR="$(dirname "$SCRIPT_DIR")"

# Load config
source "$PLUGIN_DIR/scripts/config.sh" 2>/dev/null || exit 0

# Fetch memory from Endpoints
MEMORY=$(curl -s -H "Authorization: Bearer $ENDPOINTS_API_KEY" \
  "$ENDPOINTS_API_URL/api/endpoints/claude-memory/sessions" 2>/dev/null)

# Output memory context if we got valid data
if [[ -n "$MEMORY" ]] && [[ "$MEMORY" != *"error"* ]]; then
  echo "## Previous Session Memory"
  echo "$MEMORY" | jq -r '.metadata.newMetadata | to_entries | .[] | "- \(.value.summary // .value)"' 2>/dev/null || true
fi

exit 0
