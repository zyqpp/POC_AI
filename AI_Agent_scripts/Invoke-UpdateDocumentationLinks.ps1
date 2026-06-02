# Plik zakodowany w UTF-8 z BOM (polskie znaki).
# Mechanicznie odkrywa powiązania między dokumentami AOS i aktualizuje LINKI.md
# ZASTRZEŻENIE: wyniki są heurystyczne — dopasowanie po numerze ID i nazwach plików.
#Requires -Version 5.1

param(
    [string]$ProjectRoot = '',
    [switch]$DryRun,
    [switch]$WhatIf
)

$ErrorActionPreference = 'Stop'

if ([string]::IsNullOrWhiteSpace($ProjectRoot)) {
    $ProjectRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
}

$docRoot    = Join-Path $ProjectRoot 'AI_Documentation'
$ekranyDir  = Join-Path $docRoot '05_UI_AOS\EKRANY'
$apiDir     = Join-Path $docRoot '04_API'
$procDir    = Join-Path $docRoot '06_PROCESY'
$roleDir    = Join-Path $docRoot '07_ROLE_I_UPRAWNIENIA'
$modelDir   = Join-Path $docRoot '03_MODEL_DANYCH'

$utf8NoBom = New-Object System.Text.UTF8Encoding($false)

$updated = 0
$skipped = 0

function Find-ApiFile {
    param([string]$ScreenId, [string]$Route)
    if (-not (Test-Path -LiteralPath $apiDir)) { return $null }
    $num = ''
    if ($ScreenId -match 'E-(\d{3})') { $num = $Matches[1] }
    Get-ChildItem -LiteralPath $apiDir -Filter 'API_*.md' | ForEach-Object {
        $content = Get-Content -LiteralPath $_.FullName -Raw -Encoding UTF8
        if ($content -match [regex]::Escape($ScreenId) -or
            ($num -and $content -match "E-$num\b") -or
            (-not [string]::IsNullOrWhiteSpace($Route) -and $content -match [regex]::Escape($Route.TrimStart('/')))) {
            return $_
        }
    } | Select-Object -First 1
}

function Find-ProcFile {
    param([string]$ScreenId)
    if (-not (Test-Path -LiteralPath $procDir)) { return $null }
    $num = ''
    if ($ScreenId -match 'E-(\d{3})') { $num = $Matches[1] }
    Get-ChildItem -LiteralPath $procDir -Filter '*.md' |
        Where-Object { $_.Name -ne 'README.md' -and $_.Name -ne 'PROCESY_END_TO_END.md' } |
        ForEach-Object {
            $content = Get-Content -LiteralPath $_.FullName -Raw -Encoding UTF8
            if ($content -match [regex]::Escape($ScreenId) -or ($num -and $content -match "E-$num\b")) {
                return $_
            }
        } | Select-Object -First 1
}

function Find-RoleFile {
    param([string]$ScreenId)
    if (-not (Test-Path -LiteralPath $roleDir)) { return $null }
    $num = ''
    if ($ScreenId -match 'E-(\d{3})') { $num = $Matches[1] }
    Get-ChildItem -LiteralPath $roleDir -Filter 'ROLE_*.md' | ForEach-Object {
        $content = Get-Content -LiteralPath $_.FullName -Raw -Encoding UTF8
        if ($content -match [regex]::Escape($ScreenId) -or ($num -and $content -match "E-$num\b")) {
            return $_
        }
    } | Select-Object -First 1
}

function Find-ModelFile {
    param([string]$ScreenId, [string]$Route)
    if (-not (Test-Path -LiteralPath $modelDir)) { return $null }
    $num = ''
    if ($ScreenId -match 'E-(\d{3})') { $num = $Matches[1] }
    Get-ChildItem -LiteralPath $modelDir -Filter 'MODEL_DANYCH_*.md' | ForEach-Object {
        $content = Get-Content -LiteralPath $_.FullName -Raw -Encoding UTF8
        if ($content -match [regex]::Escape($ScreenId) -or
            ($num -and $content -match "E-$num\b") -or
            (-not [string]::IsNullOrWhiteSpace($Route) -and $content -match [regex]::Escape($Route.TrimStart('/')))) {
            return $_
        }
    } | Select-Object -First 1
}

function Get-RelativePath {
    param([string]$From, [string]$To)
    $parentDir = Split-Path -Parent $From
    $fromDir = [System.IO.Path]::GetFullPath($parentDir) + '\'
    $fromUri = New-Object System.Uri($fromDir)
    $toUri   = New-Object System.Uri([System.IO.Path]::GetFullPath($To))
    $rel = [Uri]::UnescapeDataString($fromUri.MakeRelativeUri($toUri).ToString())
    return $rel
}

if (-not (Test-Path -LiteralPath $ekranyDir)) {
    Write-Host "Katalog EKRANY nie istnieje: $ekranyDir"
    exit 1
}

$screenDirs = Get-ChildItem -LiteralPath $ekranyDir -Directory |
    Where-Object { $_.Name -match '^E-\d{3}' }

Write-Host "Przetwarzam $($screenDirs.Count) ekranow..."

foreach ($dir in $screenDirs) {
    $num = ''
    if ($dir.Name -match '^E-(\d{3})') { $num = $Matches[1] }
    $screenId = "E-$num"

    $linkiPath = Join-Path $dir.FullName "${screenId}__LINKI.md"
    if (-not (Test-Path -LiteralPath $linkiPath)) {
        Write-Host "  Brak LINKI.md dla $screenId — pomijam."
        $skipped++
        continue
    }

    $readmePath = Join-Path $dir.FullName "${screenId}__README.md"
    $route = ''
    if (Test-Path -LiteralPath $readmePath) {
        $readmeContent = Get-Content -LiteralPath $readmePath -Raw -Encoding UTF8
        $routeMatch = [regex]::Match($readmeContent, '\|\s*Route\s*\|\s*`([^`]+)`')
        if ($routeMatch.Success) { $route = $routeMatch.Groups[1].Value }
    }

    $apiFile   = Find-ApiFile  -ScreenId $screenId -Route $route
    $procFile  = Find-ProcFile -ScreenId $screenId
    $roleFile  = Find-RoleFile -ScreenId $screenId
    $modelFile = Find-ModelFile -ScreenId $screenId -Route $route

    $linkiContent = Get-Content -LiteralPath $linkiPath -Raw -Encoding UTF8

    $apiLink   = if ($apiFile)   { Get-RelativePath $linkiPath $apiFile.FullName }   else { $null }
    $procLink  = if ($procFile)  { Get-RelativePath $linkiPath $procFile.FullName }  else { $null }
    $roleLink  = if ($roleFile)  { Get-RelativePath $linkiPath $roleFile.FullName }  else { $null }
    $modelLink = if ($modelFile) { Get-RelativePath $linkiPath $modelFile.FullName } else { $null }

    $changed = $false

    function Replace-LinkInTable {
        param([string]$Content, [string]$Area, [string]$Link, [string]$FileName)
        if ($null -eq $Link) { return $Content }
        $pattern = "(\|\s*$Area\s*\|)[^|]*(do uzupe[^|]*|\|)"
        $replacement = "`$1 [$FileName]($Link) |"
        $new = [regex]::Replace($Content, $pattern, $replacement)
        return $new
    }

    $newContent = $linkiContent
    if ($apiLink)   { $newContent = Replace-LinkInTable $newContent 'API'          $apiLink   $apiFile.Name }
    if ($procLink)  { $newContent = Replace-LinkInTable $newContent 'Proces'       $procLink  $procFile.Name }
    if ($roleLink)  { $newContent = Replace-LinkInTable $newContent 'Role'         $roleLink  $roleFile.Name }
    if ($modelLink) { $newContent = Replace-LinkInTable $newContent 'Model danych' $modelLink $modelFile.Name }

    if ($newContent -ne $linkiContent) {
        $changed = $true
    }

    $foundItems = @()
    if ($apiLink)   { $foundItems += "API:$($apiFile.Name)" }
    if ($procLink)  { $foundItems += "PROC:$($procFile.Name)" }
    if ($roleLink)  { $foundItems += "ROLE:$($roleFile.Name)" }
    if ($modelLink) { $foundItems += "MODEL:$($modelFile.Name)" }

    if ($foundItems.Count -gt 0) {
        $found = $foundItems -join ', '
        if ($DryRun -or $WhatIf) {
            Write-Host "  $screenId [$route]: znaleziono $found"
        } else {
            if ($changed) {
                [System.IO.File]::WriteAllText($linkiPath, $newContent, $utf8NoBom)
                Write-Host "  $screenId [$route]: zaktualizowano — $found"
                $updated++
            } else {
                Write-Host "  $screenId [$route]: znaleziono ale tabela nie pasuje — $found (sprawdz recznie)"
                $skipped++
            }
        }
    } else {
        Write-Host "  $screenId [$route]: brak pasujecych dokumentow"
        $skipped++
    }
}

Write-Host ""
Write-Host "=== WYNIK ==="
Write-Host "Zaktualizowano: $updated"
Write-Host "Pominieto/nieznaleziono: $skipped"
