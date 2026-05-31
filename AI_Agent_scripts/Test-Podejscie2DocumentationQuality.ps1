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

$requiredFiles = @(
    'AI_DATABASE_STRUCTURE.md',
    '00_START\CHECKLISTA_JAKOSCI_AOS.md',
    '00_START\PLAN_POPRAWY_DOKUMENTACJI.md',
    '00_START\STANDARD_ATOMOWEJ_DOKUMENTACJI.md',
    '03_MODEL_DANYCH\MODEL_DANYCH_ORDER_DETAIL.md',
    '03_MODEL_DANYCH\MODEL_DANYCH_SHIPMENT_DETAIL.md',
    '04_API\API_ORDER_DETAIL.md',
    '04_API\API_SHIPMENT_DETAIL.md',
    '05_UI_AOS\AOS_CHECKOUT.md',
    '05_UI_AOS\AOS_ORDER_DETAIL.md',
    '05_UI_AOS\AOS_SHIPMENT_DETAIL.md',
    '06_PROCESY\CHECKOUT_E2E.md',
    '06_PROCESY\ORDER_DETAIL_LIFECYCLE.md',
    '06_PROCESY\SHIPMENT_DETAIL_LIFECYCLE.md',
    '07_ROLE_I_UPRAWNIENIA\ROLE_ORDER_DETAIL.md',
    '07_ROLE_I_UPRAWNIENIA\ROLE_SHIPMENT_DETAIL.md',
    '08_TESTY\MACIERZ_TESTOW_ORDER_DETAIL.md',
    '08_TESTY\MACIERZ_TESTOW_SHIPMENT_DETAIL.md',
    '05_UI_AOS\EKRANY\E-000__INDEKS_EKRANOW.md',
    '10_WARSZTAT_AGENTOW\fakty\AI_AOS_TRACE_FACTS.json',
    '10_WARSZTAT_AGENTOW\fakty\AI_AOS_TRACE_REPORT.md'
)

foreach ($file in $requiredFiles) {
    $path = Join-Path $docRoot $file
    if (-not (Test-Path -LiteralPath $path)) {
        $errors.Add("Missing required documentation file: $file") | Out-Null
    }
}

$templateRoot = Join-Path $docRoot 'AOS_Template'
if (-not (Test-Path -LiteralPath $templateRoot)) {
    $errors.Add("Missing AOS template directory: AOS_Template") | Out-Null
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

    if ($relative -notmatch '^AI_Documentation/AOS_Template/' -and $text -match '<[^>\r\n]+>') {
        $errors.Add("Placeholder-like token in $relative") | Out-Null
    }

    if ($relative -notmatch '^AI_Documentation/10_WARSZTAT_AGENTOW/templates/' -and $text -match '\{\{[^}\r\n]+\}\}') {
        $errors.Add("Unresolved template token in $relative") | Out-Null
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

$traceFacts = Join-Path $docRoot '10_WARSZTAT_AGENTOW\fakty\AI_AOS_TRACE_FACTS.json'
if (Test-Path -LiteralPath $traceFacts) {
    $traceText = Get-Content -LiteralPath $traceFacts -Raw -Encoding UTF8
    if ($traceText -notmatch '"gitHead"\s*:') {
        $errors.Add("Trace facts missing gitHead metadata") | Out-Null
    }
    if ($traceText -notmatch '"scriptName"\s*:') {
        $errors.Add("Trace facts missing scriptName metadata") | Out-Null
    }
}

$traceReport = Join-Path $docRoot '10_WARSZTAT_AGENTOW\fakty\AI_AOS_TRACE_REPORT.md'
if (Test-Path -LiteralPath $traceReport) {
    $reportText = Get-Content -LiteralPath $traceReport -Raw -Encoding UTF8
    if ($reportText -notmatch 'Git HEAD:') {
        $errors.Add("Trace report missing Git HEAD line") | Out-Null
    }
}

$aosRoot = Join-Path $docRoot '05_UI_AOS'
$aosFiles = Get-ChildItem -LiteralPath $aosRoot -File -Filter 'AOS_*.md'
if ($aosFiles.Count -eq 0) {
    $errors.Add("No active AOS files found in 05_UI_AOS") | Out-Null
} else {
    $requiredAosSections = @(
        'End-To-End',
        'Model Danych',
        'API I Kontrakty',
        'Testy I Luki',
        'Ryzyka'
    )

    foreach ($aosFile in $aosFiles) {
        $aosText = Get-Content -LiteralPath $aosFile.FullName -Raw -Encoding UTF8
        $relative = $aosFile.FullName.Substring($ProjectRoot.Length + 1).Replace('\', '/')
        foreach ($section in $requiredAosSections) {
            if ($aosText -notmatch [regex]::Escape($section)) {
                $errors.Add("AOS missing section '$section': $relative") | Out-Null
            }
        }
    }
}

$screenRoot = Join-Path $docRoot '05_UI_AOS\EKRANY'
if (-not (Test-Path -LiteralPath $screenRoot)) {
    $errors.Add("Missing atomic frontend screen directory: 05_UI_AOS/EKRANY") | Out-Null
} else {
    $screenDirs = @(Get-ChildItem -LiteralPath $screenRoot -Directory | Where-Object { $_.Name -match '^E-\d{3}_' })
    if ($screenDirs.Count -eq 0) {
        $errors.Add("No atomic frontend screen directories found in 05_UI_AOS/EKRANY") | Out-Null
    }

    $routesJson = Join-Path $docRoot '10_WARSZTAT_AGENTOW\fakty\angular-routes.json'
    if (Test-Path -LiteralPath $routesJson) {
        try {
            $routeFacts = Get-Content -LiteralPath $routesJson -Raw -Encoding UTF8 | ConvertFrom-Json
            $screenRoutes = @($routeFacts.routes | Where-Object {
                    $null -ne $_.component `
                        -and -not [string]::IsNullOrWhiteSpace($_.path) `
                        -and $_.path -ne '**' `
                        -and $_.component -ne 'AppShellComponent'
                })
            if ($screenDirs.Count -ne $screenRoutes.Count) {
                $errors.Add("Atomic screen count mismatch. Directories: $($screenDirs.Count), Angular routes: $($screenRoutes.Count)") | Out-Null
            }
        } catch {
            $errors.Add("Cannot parse angular-routes.json for atomic screen count") | Out-Null
        }
    }

    foreach ($screenDir in $screenDirs) {
        if ($screenDir.Name -notmatch '^(E-(\d{3}))_') {
            $errors.Add("Invalid atomic screen directory name: $($screenDir.Name)") | Out-Null
            continue
        }

        $screenId = $matches[1]
        $number = $matches[2]
        $relativeDir = $screenDir.FullName.Substring($ProjectRoot.Length + 1).Replace('\', '/')
        $requiredScreenFiles = @(
            "$screenId`__README.md",
            "$screenId`__LINKI.md",
            "P-$number`_POLA\P-$number`__INDEX.md",
            "A-$number`_AKCJE\A-$number`__INDEX.md",
            "ERR-$number`_BLEDY\ERR-$number`__INDEX.md",
            "TD-$number`_DANE_TESTOWE\TD-$number`__INDEX.md",
            "TC-$number`_TESTY\TC-$number`__INDEX.md"
        )

        foreach ($screenFile in $requiredScreenFiles) {
            $path = Join-Path $screenDir.FullName $screenFile
            if (-not (Test-Path -LiteralPath $path)) {
                $errors.Add("Missing atomic screen file: $relativeDir/$($screenFile.Replace('\', '/'))") | Out-Null
            }
        }

        $fieldFiles = @(Get-ChildItem -LiteralPath (Join-Path $screenDir.FullName "P-$number`_POLA") -File -Filter "P-$number-*.md" -ErrorAction SilentlyContinue)
        foreach ($fieldFile in $fieldFiles) {
            $fieldText = Get-Content -LiteralPath $fieldFile.FullName -Raw -Encoding UTF8
            $fieldRelative = $fieldFile.FullName.Substring($ProjectRoot.Length + 1).Replace('\', '/')
            foreach ($requiredTerm in @('Wymagal', 'Kolumna SQL', 'Dane Do Test')) {
                if ($fieldText -notmatch [regex]::Escape($requiredTerm)) {
                    $errors.Add("Atomic field missing section '$requiredTerm': $fieldRelative") | Out-Null
                }
            }
        }
    }
}

if ($errors.Count -gt 0) {
    Write-Host "Documentation quality check failed:" -ForegroundColor Red
    $errors | ForEach-Object { Write-Host "- $_" -ForegroundColor Red }
    exit 1
}

Write-Host "Documentation quality check passed." -ForegroundColor Green
