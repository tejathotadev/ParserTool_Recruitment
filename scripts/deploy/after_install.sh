#!/bin/bash
set -euo pipefail

cd /home/ubuntu/minerU

chmod +x scripts/deploy/*.sh || true

echo "Creating virtual environment..."
python3 -m venv venv
# shellcheck disable=SC1091
source venv/bin/activate

echo "Upgrading pip and installing uv..."
pip install --upgrade pip
pip install uv

echo "Installing MinerU [pipeline] (may take 15–40 minutes)..."
uv pip install -e ".[pipeline]"
pip install -r requirements-local.txt

mkdir -p output

if [ ! -f .env ]; then
  cat > .env <<'EOF'
MINERU_API_HOST=0.0.0.0
MINERU_API_PORT=8001
MINERU_API_OUTPUT_ROOT=./output
MINERU_LOG_LEVEL=INFO
MINERU_MODEL_SOURCE=huggingface
EOF
  echo "Created default .env"
fi

echo "AfterInstall complete."
