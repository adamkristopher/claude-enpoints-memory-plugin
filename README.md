# endpoints-memory

A Claude Code plugin that provides persistent memory across sessions using the [Endpoints API](https://endpoints.work).

## Features

- **Two-tier memory system**: Quick-reference index (cc-ram) + detailed storage (cc-drive)
- **Auto-save workflow**: Research findings saved automatically after Explore, WebSearch, or WebFetch
- **Session continuity**: Memories load at session start, persist across context compaction

## Installation

```bash
# Clone the repo
git clone git@github.com:adamkristopher/claude-enpoints-memory-plugin.git

# Or add as a Claude Code plugin
claude --plugin-dir /path/to/endpoints-memory
```

## Setup

1. Get an API key from [endpoints.work](https://endpoints.work)
2. Run the setup script:

```bash
./skills/config/scripts/setup.sh
```

3. Enter your API URL and key when prompted

## How It Works

### Hooks

| Hook | Script | Purpose |
|------|--------|---------|
| SessionStart | `load-memory.sh` | Loads cc-ram index at session start |
| PostToolUse | `notify-research.sh` | Auto-triggers memory-saver after research |
| PreCompact | `precompact-reminder.sh` | Reminds to save before context compaction |

### Skills

| Skill | Purpose |
|-------|---------|
| `config` | Manage API credentials |
| `endpoints` | Full Endpoints API client |
| `memory` | Trigger memory-saver agent |

### Commands

| Command | Purpose |
|---------|---------|
| `/endpoints-memory:recall` | Review stored memories |
| `/endpoints-memory:save` | Save session learnings to memory |

### Agents

| Agent | Purpose |
|-------|---------|
| `memory-saver` | Saves research to cc-drive and indexes in cc-ram |
| `memory-retriever` | Retrieves relevant memories before research tasks |

### Memory Structure

```
cc-ram/index          # Quick summaries with slug references
cc-drive/{slug}       # Full research details
```

## Usage

The plugin works automatically:

1. Start a session → memories load from cc-ram
2. Run research (Explore, WebSearch, WebFetch) → findings auto-saved
3. Before context compaction → reminded to save learnings

Manual commands:
```
/endpoints-memory:recall   # Review what's stored
/endpoints-memory:save     # Save current session learnings
```

## License

MIT
