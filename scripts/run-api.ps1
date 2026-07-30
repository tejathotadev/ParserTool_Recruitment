# Start MinerU API for local use with parseProject (port 8001).
# Usage: from minerU folder, with .venv activated or this script will activate it.

$ErrorActionPreference = "Stop"
$Root = Split-Path -Parent $PSScriptRoot
Set-Location $Root

if (Test-Path ".\.venv\Scripts\Activate.ps1") {
    .\.venv\Scripts\Activate.ps1
}

# Optional: load simple KEY=VALUE lines from .env (no export syntax)
$envFile = Join-Path $Root ".env"
$hostName = "127.0.0.1"
$port = "8001"
if (Test-Path $envFile) {
    Get-Content $envFile | ForEach-Object {
        $line = $_.Trim()
        if (-not $line -or $line.StartsWith("#")) { return }
        $parts = $line.Split("=", 2)
        if ($parts.Count -ne 2) { return }
        $key = $parts[0].Trim()
        $val = $parts[1].Trim()
        if ($key -eq "MINERU_API_HOST") { $hostName = $val }
        elseif ($key -eq "MINERU_API_PORT") { $port = $val }
        elseif ($key -eq "MINERU_API_OUTPUT_ROOT") { $env:MINERU_API_OUTPUT_ROOT = $val }
        elseif ($key -eq "MINERU_LOG_LEVEL") { $env:MINERU_LOG_LEVEL = $val }
        elseif ($key -eq "MINERU_MODEL_SOURCE") { $env:MINERU_MODEL_SOURCE = $val }
    }
}

Write-Host "Starting mineru-api on http://${hostName}:${port}"
mineru-api --host $hostName --port ([int]$port)
