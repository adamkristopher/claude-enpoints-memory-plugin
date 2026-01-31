#!/bin/bash
# SessionStart hook - Load cc-ram (memory index) from Endpoints API

set -e

# Self-locate plugin root (CLAUDE_PLUGIN_ROOT not available at runtime)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLUGIN_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Load config
source "$PLUGIN_ROOT/skills/config/scripts/load.sh" 2>/dev/null || exit 0

# Fetch the memory index
RAM=$(curl -s -H "Authorization: Bearer $ENDPOINTS_API_KEY" \
  "$ENDPOINTS_API_URL/api/endpoints/cc-ram/index" 2>/dev/null)

# Count memories
MEMORY_COUNT=$(echo "$RAM" | jq -r '.metadata.newMetadata // {} | keys | length' 2>/dev/null || echo "0")

echo "## cc-ram loaded"
echo ""

if [[ "$MEMORY_COUNT" -gt 0 ]]; then
  echo "**$MEMORY_COUNT memories available.** Confirm cc-ram is loaded, then briefly list what you remember."
  echo ""

  # Format each memory entry
  echo "$RAM" | jq -r '
    .metadata.newMetadata // {} | to_entries[] |
    "- **\(.value.slug // "cc-drive/\(.key)")**: \(.value.summary // "No summary")"
  ' 2>/dev/null || true

  echo ""
  echo "**Before launching Explore, WebSearch, or WebFetch**: Check if cc-drive already has relevant research. Use the /endpoints skill to fetch from cc-drive/{slug} first."
else
  echo "**No memories yet.** Confirm cc-ram is loaded (empty). Use memory-saver after research to start building memory."
fi

exit 0
