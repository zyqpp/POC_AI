# Skill: mkdocs-runner

Use this skill when running, building, or preparing deployment for MkDocs documentation.

## Responsibilities

- Run local dev server for technical documentation.
- Run local dev server for user documentation.
- Build static sites.
- Validate that generated directories exist.
- Create helper PowerShell scripts if useful.
- Do not expose `mkdocs serve` as a production internet server.

## Local commands

Technical docs:

```powershell
python -m mkdocs serve -f mkdocs-tech.yml -a 127.0.0.1:8100
```

User docs:

```powershell
python -m mkdocs serve -f mkdocs-user.yml -a 127.0.0.1:8101
```

Build:

```powershell
python -m mkdocs build -f mkdocs-tech.yml
python -m mkdocs build -f mkdocs-user.yml
```

## Production rule

For production or network access:

- use `mkdocs build`,
- publish `site-tech/` and `site-user/` as static files,
- use GitHub Pages, nginx, IIS, Apache, intranet hosting, or another static hosting platform,
- never rely on `mkdocs serve` as production hosting.

## Output

Report:

- local URLs,
- build output directories,
- whether build succeeded,
- deployment recommendation.
