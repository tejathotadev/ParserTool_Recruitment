@echo off
REM Start parserTool API (Windows CMD). Run from inside the parserTool folder:
REM   start.bat

cd /d "%~dp0"

if not exist ".venv\Scripts\python.exe" (
  echo ERROR: .venv not ready. Run setup.bat first.
  exit /b 1
)

set HOST=127.0.0.1
set PORT=8001

if exist ".env" (
  for /f "usebackq tokens=1,* delims==" %%A in (".env") do (
    if /I "%%A"=="MINERU_API_HOST" set HOST=%%B
    if /I "%%A"=="MINERU_API_PORT" set PORT=%%B
  )
)

echo Starting parserTool on http://%HOST%:%PORT%
echo Docs: http://%HOST%:%PORT%/docs
".venv\Scripts\python.exe" -m mineru.cli.fast_api --host %HOST% --port %PORT%
