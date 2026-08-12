#!/usr/bin/env bash
# rulesync PostToolUse hook — runs Biome format on the just-written/edited file.
#
# Invoked by both Cursor and Claude Code on Write|Edit tool use. The two
# harnesses pass slightly different JSON payloads on stdin:
#   Cursor:      { "file_path": "<absolute or repo-relative path>", ... }
#   Claude Code: { "tool_input": { "file_path": "..." }, ... }
# This script handles both shapes and bails gracefully when biome is missing,
# the file is missing, or no file_path was supplied.

set -euo pipefail

WORKSPACE_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
BIOME_BIN="$WORKSPACE_ROOT/node_modules/.bin/biome"

if [[ ! -x "$BIOME_BIN" ]]; then
  exit 0
fi

if ! command -v python3 >/dev/null 2>&1; then
  exit 0
fi

FILE_PATH=$(python3 -c '
import sys, json
try:
    payload = json.load(sys.stdin)
except Exception:
    sys.exit(0)
# Cursor: top-level file_path. Claude Code: tool_input.file_path.
fp = payload.get("file_path") or payload.get("tool_input", {}).get("file_path", "")
print(fp)
')

if [[ -z "$FILE_PATH" ]]; then
  exit 0
fi

if [[ "$FILE_PATH" != /* ]]; then
  FILE_PATH="$WORKSPACE_ROOT/$FILE_PATH"
fi

if [[ ! -f "$FILE_PATH" ]]; then
  exit 0
fi

# Format silently; never fail the hook.
"$BIOME_BIN" format --write --config-path "$WORKSPACE_ROOT" "$FILE_PATH" > /dev/null 2>&1 || true

exit 0
