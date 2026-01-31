#!/bin/bash
# Endpoints API helper script
# Loads credentials from config skill

set -e

# Self-locate plugin root (works around CLAUDE_PLUGIN_ROOT bug in skill scripts)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLUGIN_ROOT="$(cd "$SCRIPT_DIR/../../.." && pwd)"

# Load config if ENDPOINTS_API_KEY not already set
if [[ -z "$ENDPOINTS_API_KEY" ]]; then
  source "$PLUGIN_ROOT/skills/config/scripts/load.sh"
fi

# Validate environment
if [[ -z "$ENDPOINTS_API_URL" ]]; then
  echo "Error: ENDPOINTS_API_URL not set" >&2
  echo "Run setup: $PLUGIN_ROOT/skills/config/scripts/setup.sh" >&2
  exit 1
fi

if [[ -z "$ENDPOINTS_API_KEY" ]]; then
  echo "Error: ENDPOINTS_API_KEY not set" >&2
  echo "Run setup: $PLUGIN_ROOT/skills/config/scripts/setup.sh" >&2
  exit 1
fi

AUTH="Authorization: Bearer $ENDPOINTS_API_KEY"

usage() {
  cat <<EOF
Endpoints API Helper

Usage: endpoints.sh <command> [arguments]

Commands:
  overview                      List all endpoints by category
  inspect <path>                Get endpoint details (e.g., /category/slug)
  scan-text <text> <prompt>     Scan text content with prompt
  scan-file <file> <prompt>     Scan file with prompt
  create <path>                 Create new empty endpoint
  delete <path>                 Delete endpoint and all its data
  delete-item <itemId> <path>   Delete individual item by ID
  file-url <key>                Get presigned URL for file
  stats                         Show usage statistics

Memory:
  save <slug> <json>            Save to cc-drive/{slug}
  index <json>                  Add entry to cc-ram/index

Examples:
  endpoints.sh overview
  endpoints.sh inspect /job-tracker/january
  endpoints.sh save my-topic '{"topic":"My Topic","key_findings":["finding1"]}'
  endpoints.sh index '{"slug":"cc-drive/my-topic","summary":"What I learned"}'
EOF
}

case "${1:-}" in
  overview)
    curl -s -H "$AUTH" "$ENDPOINTS_API_URL/api/endpoints/tree"
    ;;
  inspect)
    [[ -z "$2" ]] && { echo "Error: path required (e.g., /category/slug)"; exit 1; }
    path="${2#/}"  # Remove leading slash if present
    curl -s -H "$AUTH" "$ENDPOINTS_API_URL/api/endpoints/$path"
    ;;
  scan-text)
    [[ -z "$2" || -z "$3" ]] && { echo "Error: text and prompt required"; exit 1; }
    curl -s -X POST -H "$AUTH" \
      -F "texts=$2" \
      -F "prompt=$3" \
      "$ENDPOINTS_API_URL/api/scan"
    ;;
  scan-file)
    [[ -z "$2" || -z "$3" ]] && { echo "Error: file and prompt required"; exit 1; }
    [[ ! -f "$2" ]] && { echo "Error: file not found: $2"; exit 1; }
    curl -s -X POST -H "$AUTH" \
      -F "files=@$2" \
      -F "prompt=$3" \
      "$ENDPOINTS_API_URL/api/scan"
    ;;
  create)
    [[ -z "$2" ]] && { echo "Error: path required (e.g., /category/slug)"; exit 1; }
    curl -s -X POST -H "$AUTH" -H "Content-Type: application/json" \
      -d "{\"path\": \"$2\", \"items\": []}" \
      "$ENDPOINTS_API_URL/api/endpoints"
    ;;
  delete)
    [[ -z "$2" ]] && { echo "Error: path required (e.g., /category/slug)"; exit 1; }
    path="${2#/}"
    curl -s -X DELETE -H "$AUTH" "$ENDPOINTS_API_URL/api/endpoints/$path"
    ;;
  delete-item)
    [[ -z "$2" || -z "$3" ]] && { echo "Error: itemId and path required (e.g., abc12345 /category/slug)"; exit 1; }
    curl -s -X DELETE -H "$AUTH" "$ENDPOINTS_API_URL/api/items/$2?path=$3"
    ;;
  file-url)
    [[ -z "$2" ]] && { echo "Error: file key required"; exit 1; }
    curl -s -H "$AUTH" "$ENDPOINTS_API_URL/api/files/$2?format=json"
    ;;
  stats)
    curl -s -H "$AUTH" "$ENDPOINTS_API_URL/api/billing/stats"
    ;;
  save)
    [[ -z "$2" || -z "$3" ]] && { echo "Error: slug and json required"; exit 1; }
    # Escape the JSON for originalText and wrap in MetadataItem format
    ESCAPED=$(echo "$3" | jq -c '.' | jq -Rs '.')
    ITEM=$(jq -n --argjson orig "$ESCAPED" '{filePath:null,fileType:"text-only",originalText:$orig,summary:"Research findings",entities:[]}')
    curl -s -X POST -H "$AUTH" -H "Content-Type: application/json" \
      -d "{\"items\":[$ITEM]}" \
      "$ENDPOINTS_API_URL/api/endpoints/cc-drive/$2"
    ;;
  index)
    [[ -z "$2" ]] && { echo "Error: json required"; exit 1; }
    # Escape the JSON for originalText and wrap in MetadataItem format
    ESCAPED=$(echo "$2" | jq -c '.' | jq -Rs '.')
    ITEM=$(jq -n --argjson orig "$ESCAPED" '{filePath:null,fileType:"text-only",originalText:$orig,summary:"Memory index entry",entities:[]}')
    curl -s -X POST -H "$AUTH" -H "Content-Type: application/json" \
      -d "{\"items\":[$ITEM]}" \
      "$ENDPOINTS_API_URL/api/endpoints/cc-ram/index"
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
