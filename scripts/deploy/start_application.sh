#!/bin/bash
set -euo pipefail

cd /home/ubuntu/parserTool

if [ ! -x "venv/bin/python" ]; then
  echo "ERROR: venv/bin/python not found. AfterInstall may have failed."
  exit 1
fi

# shellcheck disable=SC1091
source venv/bin/activate

HOST="${MINERU_API_HOST:-0.0.0.0}"
PORT="${MINERU_API_PORT:-8001}"

if [ -f .env ]; then
  set -a
  # shellcheck disable=SC1091
  source .env
  set +a
  HOST="${MINERU_API_HOST:-$HOST}"
  PORT="${MINERU_API_PORT:-$PORT}"
fi

if [ ! -x "venv/bin/mineru-api" ]; then
  echo "ERROR: venv/bin/mineru-api not found. Pipeline install may have failed."
  exit 1
fi

echo "Starting parserTool (mineru-api) on ${HOST}:${PORT}..."
nohup venv/bin/mineru-api --host "${HOST}" --port "${PORT}" > mineru-api.log 2>&1 &

echo "Waiting for /health (models may download on first boot)..."
for _ in $(seq 1 60); do
  if curl -sf "http://127.0.0.1:${PORT}/health" > /dev/null; then
    echo "parserTool started successfully."
    exit 0
  fi
  sleep 5
done

echo "ERROR: health check failed. Last log lines:"
tail -100 mineru-api.log || true
exit 1
