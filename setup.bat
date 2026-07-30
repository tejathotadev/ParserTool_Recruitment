@echo off
REM One-time setup for parserTool (Windows CMD).
REM Run from inside the parserTool folder:
REM   setup.bat

setlocal EnableExtensions
cd /d "%~dp0"

echo === parserTool setup ===
echo Folder: %CD%

set PY_CMD=
set PY_ARGS=

REM Prefer py launcher with 3.10-3.13
for %%V in (3.12 3.11 3.13 3.10) do (
  py -%%V --version >nul 2>&1
  if not errorlevel 1 (
    set "PY_CMD=py"
    set "PY_ARGS=-%%V"
    goto :found_py
  )
)

python --version >nul 2>&1
if errorlevel 1 (
  echo ERROR: Need Python 3.10-3.13 ^(not 3.14^).
  echo Install from https://www.python.org/downloads/ then re-run.
  exit /b 1
)
set "PY_CMD=python"
set "PY_ARGS="

:found_py
echo Using: %PY_CMD% %PY_ARGS%

if not exist ".venv\Scripts\python.exe" (
  echo Creating .venv ...
  %PY_CMD% %PY_ARGS% -m venv .venv
  if errorlevel 1 (
    echo venv creation failed
    exit /b 1
  )
) else (
  echo .venv already exists — reusing it
)

".venv\Scripts\python.exe" -m pip install --upgrade pip
if errorlevel 1 exit /b 1

".venv\Scripts\python.exe" -m pip install uv
if errorlevel 1 exit /b 1

echo Installing parserTool [pipeline] ^(this can take a while^)...
if exist ".venv\Scripts\uv.exe" (
  ".venv\Scripts\uv.exe" pip install -e ".[pipeline]"
  if errorlevel 1 (
    echo uv failed — trying pip editable install...
    ".venv\Scripts\python.exe" -m pip install -e ".[pipeline]"
    if errorlevel 1 exit /b 1
  )
) else (
  ".venv\Scripts\python.exe" -m pip install -e ".[pipeline]"
  if errorlevel 1 exit /b 1
)

if exist "requirements-local.txt" (
  ".venv\Scripts\python.exe" -m pip install -r "requirements-local.txt"
)

if not exist ".env" (
  copy /Y ".env.example" ".env" >nul
  echo Created .env from .env.example
)

if not exist "output" mkdir output

echo.
echo Setup complete.
echo Start the API with:  start.bat
echo Health check:        http://127.0.0.1:8001/health
endlocal
