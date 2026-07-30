# MinerU — local & AWS CI/CD setup (this workspace)

This folder is the **MinerU** document parser (open source).  
It runs as a **separate service** from `parserProject`.

Upstream docs: see `README.md`.

> parseProject talks to MinerU at `http://127.0.0.1:8001` (see parseProject `.env`).

---

## Should you create a new GitHub / CodeCommit repository?

**Yes — use a separate repository for MinerU.**

| Approach | Recommendation |
|----------|----------------|
| New repo just for `minerU` | **Preferred** — own pipeline, own deploy timeouts, own EC2 path |
| Same repo as parserProject | Avoid — different deps, 30–40 min installs, different ports |

Use either:
- **AWS CodeCommit** (matches your current parserProject pipeline), or  
- **GitHub** + CodePipeline source connection  

Do **not** commit `.venv/`, `.env`, or `output/*`.

---

## Local setup (Windows)

```powershell
cd minerU
py -3.11 -m venv .venv
.\.venv\Scripts\Activate.ps1
python -m pip install --upgrade pip
pip install uv
uv pip install -e ".[pipeline]"
pip install -r requirements-local.txt
copy .env.example .env
```

Python must be **3.10–3.13** (not 3.14).

### Start API (port 8001)

```powershell
.\scripts\run-api.ps1
# or: mineru-api --host 127.0.0.1 --port 8001
```

- Health: http://127.0.0.1:8001/health  
- Docs: http://127.0.0.1:8001/docs  

---

## Pair with parseProject

| Service | Port | Path on EC2 |
|---------|------|-------------|
| parseProject | 8000 | `/home/ubuntu/parserProject` |
| MinerU API | 8001 | `/home/ubuntu/minerU` |

On EC2, parserProject `.env` should include:

```bash
MINERU_PATH=/home/ubuntu/minerU/venv/bin/mineru
MINERU_API_URL=http://127.0.0.1:8001
MINERU_BACKEND=pipeline
```

---

## AWS CI/CD files (added in this folder)

| File | Role |
|------|------|
| `appspec.yml` | CodeDeploy → `/home/ubuntu/minerU` |
| `buildspec.yml` | CodeBuild validation only (no torch install) |
| `scripts/deploy/before_install.sh` | Stop old API, clean dir |
| `scripts/deploy/after_install.sh` | `venv` + `.[pipeline]` (timeout up to 1 hour) |
| `scripts/deploy/start_application.sh` | `mineru-api` on 8001 + health wait |

### Pipeline outline

1. Create **new** CodeCommit/GitHub repo → push this `minerU` tree  
2. CodeBuild project using `buildspec.yml`  
3. CodeDeploy app/deployment group → **same EC2** as parserProject (recommended)  
4. CodePipeline: Source → Build → Deploy  
5. Security Group: inbound **TCP 8001**  
6. EC2: prefer **≥8 GB RAM** (t3.large+) for pipeline/torch  

### After first deploy

```bash
curl http://127.0.0.1:8001/health
tail -50 /home/ubuntu/minerU/mineru-api.log
```

From your PC: `http://YOUR_EC2_IP:8001/docs`

---

## Notes

- First AfterInstall can take **15–40+ minutes** (torch download)  
- `requirements-local.txt` installs `six`  
- `pdf_text_tool.py` includes PageChars compatibility for pdftext 0.7  
- Reboot does not auto-restart `nohup` — start again or add systemd later  
