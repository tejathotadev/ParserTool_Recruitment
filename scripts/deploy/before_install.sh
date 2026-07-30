#!/bin/bash
set -euo pipefail

echo "Stopping existing mineru-api / parserTool..."
pkill -f "mineru-api" || true
pkill -f "mineru.cli.fast_api" || true
sleep 2

echo "Cleaning previous deployment at /home/ubuntu/parserTool ..."
rm -rf /home/ubuntu/parserTool/*
rm -rf /home/ubuntu/parserTool/.[!.]*
rm -rf /home/ubuntu/parserTool/..?*

echo "BeforeInstall done."
