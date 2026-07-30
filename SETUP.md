# parserTool — setup & CI/CD

MinerU-based document parser for the recruitment chatbot.  
**Local use:** see [QUICKSTART.md](QUICKSTART.md) (unzip → `setup` → `start`).

---

## New repository?

**Yes — keep parserTool in its own GitHub/CodeCommit repo** (separate from parserProject).

---

## Local (any laptop)

### Windows
```powershell
cd parserTool
.\setup.ps1
.\start.ps1
```

### Linux / macOS
```bash
cd parserTool
chmod +x setup.sh start.sh
./setup.sh
./start.sh
```

No path editing required. Optional: edit `.env` only to change port/host.

---

## With parserProject

```text
parent/
  parserProject/
  parserTool/
```

`parserProject` auto-finds `../parserTool/.venv/.../mineru`.  
Override only with `MINERU_PATH` in parserProject `.env` if needed.

| Service | Port |
|---------|------|
| parserProject | 8000 |
| parserTool | 8001 |

On EC2, parserProject `.env` can use:
```bash
MINERU_PATH=/home/ubuntu/parserTool/venv/bin/mineru
MINERU_API_URL=http://127.0.0.1:8001
```
(or rely on auto-detect if folders are siblings under `/home/ubuntu`)

---

## AWS CI/CD files

| File | Role |
|------|------|
| `appspec.yml` | Deploy to `/home/ubuntu/parserTool` |
| `buildspec.yml` | Light validation (no torch in CodeBuild) |
| `scripts/deploy/*.sh` | CodeDeploy hooks |

AfterInstall may take 15–40 minutes. Prefer EC2 ≥ 8 GB RAM. Open SG port **8001**.

---

## Notes

- Python **3.10–3.13** only  
- `requirements-local.txt` includes `six`  
- Do not commit `.venv/`, `.env`, `output/*`  
