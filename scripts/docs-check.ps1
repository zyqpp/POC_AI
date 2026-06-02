Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

. .\.venv\Scripts\Activate.ps1

Write-Host "Checking MkDocs..."
python -m mkdocs --version

Write-Host "Checking Material for MkDocs..."
python -m pip show mkdocs-material
