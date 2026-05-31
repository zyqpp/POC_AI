param(
    [string]$ProjectRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
)

$docRoot = Join-Path $ProjectRoot 'AI_Documentation'
$errors = New-Object System.Collections.Generic.List[string]
$requiredDirs = @(
    '00_START',
    '01_SYSTEM',
    '02_ARCHITEKTURA',
    '03_MODEL_DANYCH',
    '04_API',
    '05_UI_AOS',
    '06_PROCESY',
    '07_ROLE_I_UPRAWNIENIA',
    '08_TESTY',
    '09_RYZYKA_I_REKOMENDACJE',
    '10_WARSZTAT_AGENTOW'
)

foreach ($dir in $requiredDirs) {
    $path = Join-Path $docRoot $dir
    if (-not (Test-Path -LiteralPath $path)) {
        $errors.Add("Missing directory: $dir") | Out-Null
    }
}

$activeDocs = Get-ChildItem -LiteralPath $docRoot -Recurse -File -Include '*.md' |
    Where-Object { $_.FullName -notmatch '\\_archive\\' }

$badCodePoints = @(0x00C4, 0x00C5, 0x0102, 0x00C2, 0x00EF, 0x00BF, 0x00BD, 0xFFFD)

foreach ($file in $activeDocs) {
    $text = Get-Content -LiteralPath $file.FullName -Raw -Encoding UTF8
    $relative = $file.FullName.Substring($ProjectRoot.Length + 1).Replace('\', '/')

    foreach ($codePoint in $badCodePoints) {
        if ($text.IndexOf([char]$codePoint) -ge 0) {
            $errors.Add("Possible mojibake in $relative") | Out-Null
            break
        }
    }

    if ($text -match '\]\([^\)]*_archive[^\)]*\)') {
        $errors.Add("Markdown link to archive in $relative") | Out-Null
    }

    if ($text -match '(?i)(source|zrodlo).{0,80}_archive') {
        $errors.Add("Archive used near source wording in $relative") | Out-Null
    }
}

$skillRoot = Join-Path $docRoot '10_WARSZTAT_AGENTOW\skills'
$expectedSkills = @(
    'aos-documentation-from-code',
    'api-inventory-from-dotnet',
    'ef-data-model-documenter',
    'angular-screen-mapper',
    'documentation-quality-gate'
)

foreach ($skill in $expectedSkills) {
    $skillFile = Join-Path $skillRoot "$skill\SKILL.md"
    if (-not (Test-Path -LiteralPath $skillFile)) {
        $errors.Add("Missing skill: $skill") | Out-Null
    } else {
        $content = Get-Content -LiteralPath $skillFile -Raw -Encoding UTF8
        if ($content -match '\[TODO:') {
            $errors.Add("TODO placeholder in skill: $skill") | Out-Null
        }
    }
}

if ($errors.Count -gt 0) {
    Write-Host "Documentation quality check failed:" -ForegroundColor Red
    $errors | ForEach-Object { Write-Host "- $_" -ForegroundColor Red }
    exit 1
}

Write-Host "Documentation quality check passed." -ForegroundColor Green
