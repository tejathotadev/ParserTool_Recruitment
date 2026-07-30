# One-time setup for parserTool (Windows).
# Run from inside the parserTool folder:
#   .\setup.ps1

$ErrorActionPreference = "Stop"
$Root = $PSScriptRoot
Set-Location $Root

Write-Host "=== parserTool setup ===" -ForegroundColor Cyan
Write-Host "Folder: $Root"

function Find-Python {
    $candidates = @(
        @{ Cmd = "py"; Args = @("-3.12") },
        @{ Cmd = "py"; Args = @("-3.11") },
        @{ Cmd = "py"; Args = @("-3.13") },
        @{ Cmd = "py"; Args = @("-3.10") },
        @{ Cmd = "python"; Args = @() }
    )
    foreach ($c in $candidates) {
        try {
            $versionArgs = $c.Args + @("--version")
            $out = & $c.Cmd @versionArgs 2>&1 | Out-String
            if ($LASTEXITCODE -ne 0) { continue }
            if ($out -match "Python 3\.(1[0-3])\.") {
                return @{ Cmd = $c.Cmd; Args = $c.Args }
            }
            if ($c.Cmd -eq "python" -and $out -match "Python 3\.(1[0-3])\.") {
                return @{ Cmd = $c.Cmd; Args = $c.Args }
            }
        } catch {
            continue
        }
    }
    return $null
}

$py = Find-Python
if (-not $py) {
    Write-Host "ERROR: Need Python 3.10–3.13 (not 3.14)." -ForegroundColor Red
    Write-Host "Install from https://www.python.org/downloads/ then re-run."
    exit 1
}

Write-Host "Using: $($py.Cmd) $($py.Args -join ' ')"

if (-not (Test-Path ".\.venv\Scripts\python.exe")) {
    Write-Host "Creating .venv ..."
    & $py.Cmd @($py.Args + @("-m", "venv", ".venv"))
    if ($LASTEXITCODE -ne 0) { throw "venv creation failed" }
} else {
    Write-Host ".venv already exists — reusing it"
}

$pip = ".\.venv\Scripts\python.exe"
& $pip -m pip install --upgrade pip
if ($LASTEXITCODE -ne 0) { throw "pip upgrade failed" }

& $pip -m pip install uv
if ($LASTEXITCODE -ne 0) { throw "uv install failed" }

Write-Host "Installing parserTool [pipeline] (this can take a while)..."
& ".\.venv\Scripts\uv.exe" pip install -e ".[pipeline]"
if ($LASTEXITCODE -ne 0) {
    Write-Host "uv failed — trying pip editable install..."
    & $pip -m pip install -e ".[pipeline]"
    if ($LASTEXITCODE -ne 0) { throw "pipeline install failed" }
}

if (Test-Path ".\requirements-local.txt") {
    & $pip -m pip install -r ".\requirements-local.txt"
}

if (-not (Test-Path ".\.env")) {
    Copy-Item ".\.env.example" ".\.env"
    Write-Host "Created .env from .env.example"
}

New-Item -ItemType Directory -Force -Path ".\output" | Out-Null

Write-Host ""
Write-Host "Setup complete." -ForegroundColor Green
Write-Host "Start the API with:  .\start.ps1"
Write-Host "Health check:        http://127.0.0.1:8001/health"
