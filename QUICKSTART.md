# parserTool — Quick start

Document parser service (MinerU-based). Works on any laptop **without editing paths**, as long as you run the scripts from this folder.

## Requirements

- Python **3.10–3.13** (not 3.14)
- Internet (first install downloads packages / models)

## Windows (3 steps)

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
