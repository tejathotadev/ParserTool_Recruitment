# parserTool — Quick start

Testing
Document parser service (MinerU-based). Works on any laptop **without editing paths**, as long as you run the scripts from this folder.

## Requirements

- Python **3.10–3.13** (not 3.14)
- Internet (first install downloads packages / models)

## Windows CMD (recommended)

```cmd
cd /d "D:\ChatBot\AI Recuritement ChatBot\parser\parserTool"
setup.bat
start.bat
```

Or without scripts (same result):

```cmd
cd /d "D:\ChatBot\AI Recuritement ChatBot\parser\parserTool"
.venv\Scripts\python.exe -m mineru.cli.fast_api --host 127.0.0.1 --port 8001
```

## Windows PowerShell

```powershell
cd parserTool
.\setup.ps1
.\start.ps1
```

## Linux / macOS

```bash
cd parserTool
chmod +x setup.sh start.sh
./setup.sh
./start.sh
```

## Check

- Health: http://127.0.0.1:8001/health  
- Docs: http://127.0.0.1:8001/docs  

## Optional (almost never needed)

Copy `.env.example` → `.env` only if you want to change host/port. Defaults already work.

## With parserProject

Keep folders as siblings:

```text
parser/
  parserProject/
  parserTool/
```

Then `parserProject` auto-finds `parserTool` — **no path edit**.  
Only set `MINERU_PATH` in parserProject `.env` if you put `parserTool` somewhere else.
