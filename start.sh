#!/usr/bin/env bash
# Start parserTool API (Linux / macOS). No machine-specific paths required.
# Run from inside the parserTool folder:
#   ./start.sh

set -euo pipefail
ROOT="$(cd "$(dirname "$0")" && pwd)"
cd "$ROOT"

if [ ! -x ".venv/bin/mineru-api" ]; then
  echo "ERROR: .venv not ready. Run ./setup.sh first."
  exit 1
fi

# shellcheck disable=SC1091
source .venv/bin/activate

HOST="${MINERU_API_HOST:-127.0.0.1}"
PORT="${MINERU_API_PORT:-8001}"

if [ -f .env ]; then
  set -a
  # shellcheck disable=SC1091
  source .env
  set +a
  HOST="${MINERU_API_HOST:-$HOST}"
  PORT="${MINERU_API_PORT:-$PORT}"
fi

echo "Starting parserTool (mineru-api) on http://${HOST}:${PORT}"
echo "Docs: http://${HOST}:${PORT}/docs"
exec .venv/bin/mineru-api --host "${HOST}" --port "${PORT}"
