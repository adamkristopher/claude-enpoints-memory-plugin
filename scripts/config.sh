#!/bin/bash
# Shared configuration loader for endpoints-memory plugin
# Sources credentials from settings.local

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLUGIN_DIR="$(dirname "$SCRIPT_DIR")"
SETTINGS_FILE="$PLUGIN_DIR/settings.local"

if [[ -f "$SETTINGS_FILE" ]]; then
  source "$SETTINGS_FILE"
else
  echo "Error: Plugin not configured." >&2
  echo "Run: ~/.claude/plugins/endpoints-memory/scripts/setup.sh" >&2
  exit 1
fi

# Validate required variables
if [[ -z "$ENDPOINTS_API_URL" ]] || [[ -z "$ENDPOINTS_API_KEY" ]]; then
  echo "Error: Missing credentials in settings.local" >&2
  exit 1
fi

export ENDPOINTS_API_URL
export ENDPOINTS_API_KEY
