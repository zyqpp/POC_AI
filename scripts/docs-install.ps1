Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

Write-Host "Setting up MkDocs documentation environment..."

if (-not (Test-Path ".venv")) {
    Write-Host "Creating .venv..."
    py -m venv .venv
}

Write-Host "Activating .venv..."
. .\.venv\Scripts\Activate.ps1

Write-Host "Upgrading pip..."
python -m pip install --upgrade pip

Write-Host "Installing documentation requirements..."
python -m pip install -r requirements-docs.txt

Write-Host "MkDocs version:"
python -m mkdocs --version
