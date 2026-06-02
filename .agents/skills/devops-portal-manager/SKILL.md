# Skill: devops-portal-manager

Use this skill when operating, troubleshooting, and maintaining MkDocs documentation portals in local development and pre-release workflows.

## Responsibilities

- Verify local prerequisites: Python, `.venv`, MkDocs, Material theme.
- Validate that required files exist:
  - `requirements-docs.txt`
  - `mkdocs-tech.yml`
  - `mkdocs-user.yml`
- Check port availability before startup.
- Start, verify, and stop local MkDocs portal processes.
- Build static artifacts for both portals.
- Validate output directories and basic HTTP readiness.
- Report conflicts, warnings, and exact remediation steps.
- Enforce production rule: never expose `mkdocs serve` as internet hosting.

## Standard local ports

- Technical portal: `127.0.0.1:8100`
- User portal: `127.0.0.1:8101`

If busy, use next free pair (for example `8010/8011`, `8020/8021`).

## Preferred commands

```powershell
# Environment
powershell -ExecutionPolicy Bypass -File .\scripts\docs-install.ps1
powershell -ExecutionPolicy Bypass -File .\scripts\docs-check.ps1

# Build
powershell -ExecutionPolicy Bypass -File .\scripts\docs-build-tech.ps1
powershell -ExecutionPolicy Bypass -File .\scripts\docs-build-user.ps1

# Serve
powershell -ExecutionPolicy Bypass -File .\scripts\docs-serve-tech.ps1
powershell -ExecutionPolicy Bypass -File .\scripts\docs-serve-user.ps1

# Port check
netstat -ano -p tcp | findstr LISTENING
```

## Process management pattern (PowerShell)

```powershell
# Start in background
Start-Process powershell -WindowStyle Hidden -ArgumentList '-ExecutionPolicy','Bypass','-File','.\\scripts\\docs-serve-tech.ps1' -PassThru
Start-Process powershell -WindowStyle Hidden -ArgumentList '-ExecutionPolicy','Bypass','-File','.\\scripts\\docs-serve-user.ps1' -PassThru

# Verify ports
netstat -ano -p tcp | findstr ":8100"
netstat -ano -p tcp | findstr ":8101"
```

## Output

Report:

- portal status (running / stopped),
- chosen ports and URLs,
- build status for `site-tech/` and `site-user/`,
- warnings from MkDocs (nav/link issues),
- recommended next action (fix links, nav cleanup, deploy preparation).

## Safety rules

- Do not use `mkdocs serve` as production server.
- For publication, build static content and host `site-tech/` and `site-user/` on static hosting.
- Do not modify business/application source code while doing docs operations.
