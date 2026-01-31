#!/bin/bash
# Memory helper script for endpoints-memory plugin

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/config.sh"

AUTH="Authorization: Bearer $ENDPOINTS_API_KEY"

usage() {
  cat <<EOF
Endpoints Memory Helper

Usage: memory.sh <command> [arguments]

Commands:
  load                    Fetch all stored memories
  save <json>             Save a new memory entry
  recent [count]          Get recent N memories (default: 5)
  search <term>           Search memories for a term

Examples:
  memory.sh load
  memory.sh recent 3
  memory.sh search "authentication"
EOF
}

case "${1:-}" in
  load)
    curl -s -H "$AUTH" "$ENDPOINTS_API_URL/api/endpoints/claude-memory/sessions"
    ;;
  save)
    [[ -z "$2" ]] && { echo "Error: JSON content required"; exit 1; }
    curl -s -X POST -H "$AUTH" \
      -F "texts=$2" \
      -F "prompt=claude-memory - sessions" \
      "$ENDPOINTS_API_URL/api/scan"
    ;;
  recent)
    count="${2:-5}"
    curl -s -H "$AUTH" "$ENDPOINTS_API_URL/api/endpoints/claude-memory/sessions" | \
      jq --arg count "$count" '.metadata.newMetadata | to_entries | sort_by(.value.timestamp) | reverse | .[:($count|tonumber)]'
    ;;
  search)
    [[ -z "$2" ]] && { echo "Error: search term required"; exit 1; }
    curl -s -H "$AUTH" "$ENDPOINTS_API_URL/api/endpoints/claude-memory/sessions" | \
      jq --arg term "$2" '[.metadata.newMetadata, .metadata.oldMetadata] | add | to_entries | map(select(.value | tostring | test($term; "i")))'
    ;;
  --help|-h|"")
    usage
    ;;
  *)
    echo "Unknown command: $1" >&2
    usage
    exit 1
    ;;
esac
