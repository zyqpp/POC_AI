# Skill: mkdocs-environment

Use this skill when setting up the local Python environment for MkDocs / Material for MkDocs.

## Responsibilities

- Check Python availability.
- Check pip availability.
- Check Git availability.
- Create local `.venv` if missing.
- Install documentation dependencies from `requirements-docs.txt`.
- Avoid global Python package installation.
- Verify `python -m mkdocs --version`.
- Do not modify Markdown documentation content.

## Preferred commands

```powershell
py --version
python --version
pip --version
git --version

py -m venv .venv
.\.venv\Scripts\Activate.ps1

python -m pip install --upgrade pip
python -m pip install -r requirements-docs.txt
python -m mkdocs --version
```

## Output

Report:

- Python version,
- whether `.venv` exists,
- installed MkDocs version,
- installed Material for MkDocs version,
- any errors and exact remediation steps.
