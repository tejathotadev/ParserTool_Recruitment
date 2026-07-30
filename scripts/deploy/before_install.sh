#!/bin/bash
set -euo pipefail

echo "Stopping existing mineru-api..."
pkill -f "mineru-api" || true
pkill -f "mineru.cli.fast_api" || true
sleep 2

echo "Cleaning previous deployment at /home/ubuntu/minerU ..."
rm -rf /home/ubuntu/minerU/*
rm -rf /home/ubuntu/minerU/.[!.]*
rm -rf /home/ubuntu/minerU/..?*

echo "BeforeInstall done."
