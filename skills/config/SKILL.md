---
name: config
description: >
  Load Endpoints API configuration and credentials. Use before making any API calls.
  Provides ENDPOINTS_API_URL and ENDPOINTS_API_KEY environment variables.
---

# Config Skill

Load credentials for the Endpoints API.

## Load Configuration

Source the config script to get API credentials:

```bash
source "${CLAUDE_PLUGIN_ROOT}/skills/config/scripts/load.sh"
# Provides: $ENDPOINTS_API_URL, $ENDPOINTS_API_KEY
```

Then use in API calls:

```bash
curl -s -H "Authorization: Bearer $ENDPOINTS_API_KEY" \
  "$ENDPOINTS_API_URL/api/endpoints"
```

## First-Time Setup

If credentials aren't configured, run the setup script:

```bash
"${CLAUDE_PLUGIN_ROOT}/skills/config/scripts/setup.sh"
```

This prompts for:
- `ENDPOINTS_API_URL` - Base URL (e.g., `https://endpoints.work`)
- `ENDPOINTS_API_KEY` - API key with `ep_` prefix

Credentials are saved to `settings.local` (gitignored).

## Verify Configuration

Check if credentials are configured:

```bash
"${CLAUDE_PLUGIN_ROOT}/skills/config/scripts/verify.sh"
```

## Environment Variables

After loading config:

| Variable | Description |
|----------|-------------|
| `ENDPOINTS_API_URL` | Base URL for API calls |
| `ENDPOINTS_API_KEY` | Bearer token for authentication |
