Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

. .\.venv\Scripts\Activate.ps1

python -m mkdocs build -f mkdocs-user.yml
Write-Host "User documentation built into site-user/"
