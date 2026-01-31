#!/bin/bash
# Verify Endpoints API configuration

# Self-locate plugin root (works around CLAUDE_PLUGIN_ROOT bug in skill scripts)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLUGIN_ROOT="$(cd "$SCRIPT_DIR/../../.." && pwd)"

SETTINGS_FILE="$PLUGIN_ROOT/settings.local"

if [[ ! -f "$SETTINGS_FILE" ]]; then
  echo "Not configured. Run setup.sh first."
  exit 1
fi

source "$SETTINGS_FILE"

if [[ -z "$ENDPOINTS_API_URL" ]] || [[ -z "$ENDPOINTS_API_KEY" ]]; then
  echo "Missing credentials in settings.local"
  exit 1
fi

echo "Configuration:"
echo "  URL: $ENDPOINTS_API_URL"
echo "  Key: ${ENDPOINTS_API_KEY:0:10}..."

echo ""
echo "Testing connection..."
if curl -s -f -H "Authorization: Bearer $ENDPOINTS_API_KEY" "$ENDPOINTS_API_URL/api/endpoints/tree" > /dev/null 2>&1; then
  echo "Connection OK"
else
  echo "Connection FAILED"
  exit 1
fi
