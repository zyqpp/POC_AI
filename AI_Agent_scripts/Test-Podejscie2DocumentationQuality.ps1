param(
    [string]$ProjectRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
)

$docRoot = Join-Path $ProjectRoot 'AI_Documentation'
$blockingIssues = New-Object System.Collections.Generic.List[string]
$navigationIssues = New-Object System.Collections.Generic.List[string]
$contentIssues = New-Object System.Collections.Generic.List[string]

function Add-BlockingIssue {
    param([string]$Message)
    $blockingIssues.Add($Message) | Out-Null
}

function Add-NavigationIssue {
    param([string]$Message)
    $navigationIssues.Add($Message) | Out-Null
}

function Add-ContentIssue {
    param([string]$Message)
    $contentIssues.Add($Message) | Out-Null
}

function Test-IsActiveDocPath {
    param([string]$FullName)

    foreach ($pattern in @(
        '\\_archive\\',
        '\\AOS_Template\\',
        '\\10_WARSZTAT_AGENTOW\\templates\\'
    )) {
        if ($FullName -match $pattern) {
            return $false
        }
    }

    return $true
}

$canonicalFactStatuses = @(
    'potwierdzone',
    'wniosek z analizy',
    'do potwierdzenia',
    'brak w kodzie',
    ('do uzupe' + [char]0x0142 + 'nienia')
)

$activeDocs = Get-ChildItem -LiteralPath $docRoot -Recurse -File -Filter '*.md' |
    Where-Object { Test-IsActiveDocPath $_.FullName }

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
        Add-BlockingIssue "Missing directory: $dir"
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
        Add-BlockingIssue "Missing required documentation file: $file"
    }
}

$templateRoot = Join-Path $docRoot 'AOS_Template'
if (-not (Test-Path -LiteralPath $templateRoot)) {
    Add-BlockingIssue "Missing AOS template directory: AOS_Template"
}

$badCodePoints = @(0x00C4, 0x00C5, 0x0102, 0x00C2, 0x00EF, 0x00BF, 0x00BD, 0xFFFD)

foreach ($file in $activeDocs) {
    $text = Get-Content -LiteralPath $file.FullName -Raw -Encoding UTF8
    $relative = $file.FullName.Substring($ProjectRoot.Length + 1).Replace('\', '/')

    foreach ($codePoint in $badCodePoints) {
        if ($text.IndexOf([char]$codePoint) -ge 0) {
            Add-ContentIssue "Possible mojibake in $relative"
            break
        }
    }

    if ($text -match '\]\([^\)]*_archive[^\)]*\)') {
        Add-NavigationIssue "Markdown link to archive in $relative"
    }

    if ($text -match '(?i)(source|zrodlo).{0,80}_archive') {
        Add-NavigationIssue "Archive used near source wording in $relative"
    }

    if ($text -match '(?m)^\s*\|\s*Status faktu\s*\|\s*`?([^`|]+?)`?\s*\|') {
        $status = $matches[1].Trim()
        if ($canonicalFactStatuses -notcontains $status) {
            Add-ContentIssue "Non-canonical fact status '$status' in $relative"
        }
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
        Add-BlockingIssue "Missing skill: $skill"
    } else {
        $content = Get-Content -LiteralPath $skillFile -Raw -Encoding UTF8
        if ($content -match '\[TODO:') {
            Add-ContentIssue "TODO placeholder in skill: $skill"
        }
    }
}

$traceFacts = Join-Path $docRoot '10_WARSZTAT_AGENTOW\fakty\AI_AOS_TRACE_FACTS.json'
if (Test-Path -LiteralPath $traceFacts) {
    $traceText = Get-Content -LiteralPath $traceFacts -Raw -Encoding UTF8
    if ($traceText -notmatch '"gitHead"\s*:') {
        Add-ContentIssue "Trace facts missing gitHead metadata"
    }
    if ($traceText -notmatch '"scriptName"\s*:') {
        Add-ContentIssue "Trace facts missing scriptName metadata"
    }
}

$traceReport = Join-Path $docRoot '10_WARSZTAT_AGENTOW\fakty\AI_AOS_TRACE_REPORT.md'
if (Test-Path -LiteralPath $traceReport) {
    $reportText = Get-Content -LiteralPath $traceReport -Raw -Encoding UTF8
    if ($reportText -notmatch 'Git HEAD:') {
        Add-ContentIssue "Trace report missing Git HEAD line"
    }
}

$aosRoot = Join-Path $docRoot '05_UI_AOS'
$aosFiles = Get-ChildItem -LiteralPath $aosRoot -File -Filter 'AOS_*.md'
if ($aosFiles.Count -eq 0) {
    Add-BlockingIssue "No active AOS files found in 05_UI_AOS"
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
                Add-ContentIssue "AOS missing section '$section': $relative"
            }
        }
    }
}

$screenRoot = Join-Path $docRoot '05_UI_AOS\EKRANY'
if (-not (Test-Path -LiteralPath $screenRoot)) {
    Add-BlockingIssue "Missing atomic frontend screen directory: 05_UI_AOS/EKRANY"
} else {
    $screenDirs = @(Get-ChildItem -LiteralPath $screenRoot -Directory | Where-Object { $_.Name -match '^E-\d{3}_' })
    if ($screenDirs.Count -eq 0) {
        Add-BlockingIssue "No atomic frontend screen directories found in 05_UI_AOS/EKRANY"
    }

    $referenceScreenNumbers = @('012', '015', '017')

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
                Add-NavigationIssue "Atomic screen count mismatch. Directories: $($screenDirs.Count), Angular routes: $($screenRoutes.Count)"
            }
        } catch {
            Add-NavigationIssue "Cannot parse angular-routes.json for atomic screen count"
        }
    }

    foreach ($screenDir in $screenDirs) {
        if ($screenDir.Name -notmatch '^(E-(\d{3}))_') {
            Add-BlockingIssue "Invalid atomic screen directory name: $($screenDir.Name)"
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
                Add-BlockingIssue "Missing atomic screen file: $relativeDir/$($screenFile.Replace('\', '/'))"
            }
        }

        $fieldFiles = @(Get-ChildItem -LiteralPath (Join-Path $screenDir.FullName "P-$number`_POLA") -File -Filter "P-$number-*.md" -ErrorAction SilentlyContinue)
        foreach ($fieldFile in $fieldFiles) {
            $fieldText = Get-Content -LiteralPath $fieldFile.FullName -Raw -Encoding UTF8
            $fieldRelative = $fieldFile.FullName.Substring($ProjectRoot.Length + 1).Replace('\', '/')
            foreach ($requiredTerm in @('Wymagal', 'Kolumna SQL', 'Dane Do Test')) {
                if ($fieldText -notmatch [regex]::Escape($requiredTerm)) {
                    Add-ContentIssue "Atomic field missing section '$requiredTerm': $fieldRelative"
                }
            }
        }

        if ($referenceScreenNumbers -contains $number) {
            $realTcFiles = @(Get-ChildItem -LiteralPath (Join-Path $screenDir.FullName "TC-$number`_TESTY") -File -Filter "TC-$number-*.md" -ErrorAction SilentlyContinue)
            if ($realTcFiles.Count -eq 0) {
                Add-ContentIssue "No real TC-* test case documents found for reference screen $relativeDir"
            }
        }
    }
}

if ($blockingIssues.Count -gt 0) {
    Write-Host "Documentation quality check failed:" -ForegroundColor Red

    if ($blockingIssues.Count -gt 0) {
        Write-Host "Blocking issues ($($blockingIssues.Count)):" -ForegroundColor Red
        $blockingIssues | ForEach-Object { Write-Host "- $_" -ForegroundColor Red }
    }

    if ($navigationIssues.Count -gt 0) {
        Write-Host "Navigation warnings ($($navigationIssues.Count)):" -ForegroundColor Yellow
        $navigationIssues | ForEach-Object { Write-Host "- $_" -ForegroundColor Yellow }
    }

    if ($contentIssues.Count -gt 0) {
        Write-Host "Substantive warnings ($($contentIssues.Count)):" -ForegroundColor Yellow
        $contentIssues | ForEach-Object { Write-Host "- $_" -ForegroundColor Yellow }
    }

    exit 1
}

Write-Host "Documentation quality check passed." -ForegroundColor Green

if ($navigationIssues.Count -gt 0) {
    Write-Host "Navigation warnings ($($navigationIssues.Count)):" -ForegroundColor Yellow
    $navigationIssues | ForEach-Object { Write-Host "- $_" -ForegroundColor Yellow }
}

if ($contentIssues.Count -gt 0) {
    Write-Host "Substantive warnings ($($contentIssues.Count)):" -ForegroundColor Yellow
    $contentIssues | ForEach-Object { Write-Host "- $_" -ForegroundColor Yellow }
}
