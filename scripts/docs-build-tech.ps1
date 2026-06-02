Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

. .\.venv\Scripts\Activate.ps1

python -m mkdocs build -f mkdocs-tech.yml
Write-Host "Technical documentation built into site-tech/"
