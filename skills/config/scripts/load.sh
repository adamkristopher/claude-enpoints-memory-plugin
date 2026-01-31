#!/bin/bash
# Load Endpoints API credentials from settings.local

# Self-locate plugin root (works around CLAUDE_PLUGIN_ROOT bug in skill scripts)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLUGIN_ROOT="$(cd "$SCRIPT_DIR/../../.." && pwd)"

SETTINGS_FILE="$PLUGIN_ROOT/settings.local"

if [[ -f "$SETTINGS_FILE" ]]; then
  source "$SETTINGS_FILE"
else
  echo "Error: Plugin not configured." >&2
  echo "Run: $PLUGIN_ROOT/skills/config/scripts/setup.sh" >&2
  exit 1
fi

# Validate required variables
if [[ -z "$ENDPOINTS_API_URL" ]] || [[ -z "$ENDPOINTS_API_KEY" ]]; then
  echo "Error: Missing credentials in settings.local" >&2
  exit 1
fi

export ENDPOINTS_API_URL
export ENDPOINTS_API_KEY
