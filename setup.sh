#!/usr/bin/env bash
# One-time setup for parserTool (Linux / macOS).
# Run from inside the parserTool folder:
#   chmod +x setup.sh start.sh && ./setup.sh

set -euo pipefail
ROOT="$(cd "$(dirname "$0")" && pwd)"
cd "$ROOT"

echo "=== parserTool setup ==="
echo "Folder: $ROOT"

pick_python() {
  for cand in python3.12 python3.11 python3.13 python3.10 python3; do
    if command -v "$cand" >/dev/null 2>&1; then
      ver="$("$cand" -c 'import sys; print(f"{sys.version_info.major}.{sys.version_info.minor}")' 2>/dev/null || true)"
      case "$ver" in
        3.10|3.11|3.12|3.13) echo "$cand"; return 0 ;;
      esac
    fi
  done
  return 1
}

PY="$(pick_python || true)"
if [ -z "${PY}" ]; then
  echo "ERROR: Need Python 3.10–3.13 (not 3.14)."
  exit 1
fi
echo "Using: $PY ($("$PY" --version))"

if [ ! -x ".venv/bin/python" ]; then
  echo "Creating .venv ..."
  "$PY" -m venv .venv
else
  echo ".venv already exists — reusing it"
fi

# shellcheck disable=SC1091
source .venv/bin/activate
python -m pip install --upgrade pip
pip install uv

echo "Installing parserTool [pipeline] (this can take a while)..."
if ! uv pip install -e ".[pipeline]"; then
  pip install -e ".[pipeline]"
fi

if [ -f requirements-local.txt ]; then
  pip install -r requirements-local.txt
fi

if [ ! -f .env ]; then
  cp .env.example .env
  echo "Created .env from .env.example"
fi

mkdir -p output

echo ""
echo "Setup complete."
echo "Start the API with:  ./start.sh"
echo "Health check:        http://127.0.0.1:8001/health"
