# Start parserTool API (Windows). No machine-specific paths required.
# Run from inside the parserTool folder:
#   .\start.ps1

$ErrorActionPreference = "Stop"
$Root = $PSScriptRoot
Set-Location $Root

if (-not (Test-Path ".\.venv\Scripts\python.exe")) {
    Write-Host "ERROR: .venv not ready. Run .\setup.ps1 first." -ForegroundColor Red
    exit 1
}

$hostName = "127.0.0.1"
$port = "8001"
$envFile = Join-Path $Root ".env"
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
        elseif ($key -eq "HF_TOKEN") { $env:HF_TOKEN = $val }
    }
}

Write-Host "Starting parserTool on http://${hostName}:${port}"
Write-Host "Docs: http://${hostName}:${port}/docs"
# Use python -m (avoids broken uv trampoline on some Windows installs)
& ".\.venv\Scripts\python.exe" -m mineru.cli.fast_api --host $hostName --port ([int]$port)
