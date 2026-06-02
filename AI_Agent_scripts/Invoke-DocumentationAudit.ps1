# Plik zakodowany w UTF-8 z BOM (polskie znaki).
# ZASTRZEŻENIE: wyniki są heurystyczne. Skrypt używa statycznego parsowania
# i wyszukiwania tekstowego — nie zastępuje ręcznej weryfikacji w kodzie.
#Requires -Version 5.1

param(
    [string]$ProjectRoot = '',
    [string]$OutputJson = '',
    [string]$OutputMarkdown = '',
    [switch]$WhatIf
)

$ErrorActionPreference = 'Stop'

if ([string]::IsNullOrWhiteSpace($ProjectRoot)) {
    $ProjectRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
}

$faktyDir = Join-Path $ProjectRoot 'AI_Documentation\10_WARSZTAT_AGENTOW\fakty'

if ([string]::IsNullOrWhiteSpace($OutputJson)) {
    $OutputJson = Join-Path $faktyDir 'documentation-audit.json'
}

if ([string]::IsNullOrWhiteSpace($OutputMarkdown)) {
    $OutputMarkdown = Join-Path $faktyDir 'DOCUMENTATION_AUDIT_REPORT.md'
}

$utf8NoBom = New-Object System.Text.UTF8Encoding($false)

function Get-GitHead {
    try {
        $hash = & git -C $ProjectRoot rev-parse --short HEAD 2>$null
        if ($LASTEXITCODE -eq 0 -and -not [string]::IsNullOrWhiteSpace($hash)) {
            return $hash.Trim()
        }
    } catch { }
    return 'unknown'
}

function Get-AngularRoutes {
    $routesJson = Join-Path $ProjectRoot 'AI_Documentation\10_WARSZTAT_AGENTOW\fakty\angular-routes.json'
    if (Test-Path -LiteralPath $routesJson) {
        try {
            $data = Get-Content -LiteralPath $routesJson -Raw -Encoding UTF8 | ConvertFrom-Json
            $routes = @($data.routes | Where-Object {
                $null -ne $_.component `
                    -and -not [string]::IsNullOrWhiteSpace($_.path) `
                    -and $_.path -ne '**' `
                    -and $_.component -ne 'AppShellComponent'
            })
            return $routes
        } catch { }
    }

    $appRoutes = Join-Path $ProjectRoot 'supply-chain-frontend\src\app\app.routes.ts'
    if (-not (Test-Path -LiteralPath $appRoutes)) {
        return @()
    }

    $content = Get-Content -LiteralPath $appRoutes -Raw -Encoding UTF8
    $paths = [regex]::Matches($content, "path\s*:\s*['""]([^'""]+)['""]") | ForEach-Object {
        $_.Groups[1].Value
    } | Where-Object {
        -not [string]::IsNullOrWhiteSpace($_) -and $_ -ne '**'
    }
    return $paths | ForEach-Object { [pscustomobject]@{ path = $_ } }
}

function Get-ScreenCoverage {
    $ekranyDir = Join-Path $ProjectRoot 'AI_Documentation\05_UI_AOS\EKRANY'
    $angularRoutes = Get-AngularRoutes
    $totalRoutes = $angularRoutes.Count

    $screens = @()
    if (-not (Test-Path -LiteralPath $ekranyDir)) {
        return @{
            totalAngularRoutes = $totalRoutes
            totalScreenDirs = 0
            screensComplete = 0
            screensSkeleton = @()
            screens = @()
            summary = 'Katalog 05_UI_AOS/EKRANY nie istnieje.'
        }
    }

    $screenDirs = Get-ChildItem -LiteralPath $ekranyDir -Directory |
        Where-Object { $_.Name -match '^E-\d{3}' }

    foreach ($dir in $screenDirs) {
        $num = ''
        if ($dir.Name -match '^E-(\d{3})') { $num = $Matches[1] }

        $readmePath = Join-Path $dir.FullName "E-$num`__README.md"
        $linkiPath  = Join-Path $dir.FullName "E-$num`__LINKI.md"
        $pIndex     = Join-Path $dir.FullName "P-$num`_POLA\P-$num`__INDEX.md"
        $aIndex     = Join-Path $dir.FullName "A-$num`_AKCJE\A-$num`__INDEX.md"
        $errIndex   = Join-Path $dir.FullName "ERR-$num`_BLEDY\ERR-$num`__INDEX.md"
        $tdIndex    = Join-Path $dir.FullName "TD-$num`_DANE_TESTOWE\TD-$num`__INDEX.md"
        $tcIndex    = Join-Path $dir.FullName "TC-$num`_TESTY\TC-$num`__INDEX.md"

        $hasStructure = (Test-Path -LiteralPath $readmePath) -and
                        (Test-Path -LiteralPath $linkiPath) -and
                        (Test-Path -LiteralPath $pIndex) -and
                        (Test-Path -LiteralPath $aIndex) -and
                        (Test-Path -LiteralPath $errIndex) -and
                        (Test-Path -LiteralPath $tdIndex) -and
                        (Test-Path -LiteralPath $tcIndex)

        $readmeStatus = 'brak'
        if (Test-Path -LiteralPath $readmePath) {
            $readmeContent = Get-Content -LiteralPath $readmePath -Raw -Encoding UTF8
            $statusMatch = [regex]::Match($readmeContent, 'Status:\s*`([^`]+)`')
            if ($statusMatch.Success) { $readmeStatus = $statusMatch.Groups[1].Value.Trim() }
        }

        $fieldDir = Join-Path $dir.FullName "P-$num`_POLA"
        $actionDir = Join-Path $dir.FullName "A-$num`_AKCJE"
        $tcDir = Join-Path $dir.FullName "TC-$num`_TESTY"

        $fieldCount = 0
        $actionCount = 0
        $tcCount = 0

        if (Test-Path -LiteralPath $fieldDir) {
            $fieldCount = @(Get-ChildItem -LiteralPath $fieldDir -Filter "P-$num-*.md" -ErrorAction SilentlyContinue).Count
        }
        if (Test-Path -LiteralPath $actionDir) {
            $actionCount = @(Get-ChildItem -LiteralPath $actionDir -Filter "A-$num-*.md" -ErrorAction SilentlyContinue).Count
        }
        if (Test-Path -LiteralPath $tcDir) {
            $tcCount = @(Get-ChildItem -LiteralPath $tcDir -Filter "TC-$num-*.md" -ErrorAction SilentlyContinue).Count
        }

        $completionLevel = if ($readmeStatus -eq 'szkielet') { 'szkielet' } else { 'kompletny' }

        $screens += [pscustomobject]@{
            screenId         = "E-$num"
            directoryName    = $dir.Name
            hasRequiredStructure = $hasStructure
            readmeStatus     = $readmeStatus
            fieldCount       = $fieldCount
            actionCount      = $actionCount
            tcCount          = $tcCount
            completionLevel  = $completionLevel
        }
    }

    $skeletonScreens = @($screens | Where-Object { $_.completionLevel -eq 'szkielet' } | ForEach-Object { $_.screenId })
    $completeScreens = @($screens | Where-Object { $_.completionLevel -eq 'kompletny' } | ForEach-Object { $_.screenId })

    return @{
        totalAngularRoutes = $totalRoutes
        totalScreenDirs    = $screens.Count
        screensComplete    = $completeScreens.Count
        screensSkeleton    = $skeletonScreens
        screens            = $screens
    }
}

function Get-ProcessCoverage {
    $procDir = Join-Path $ProjectRoot 'AI_Documentation\06_PROCESY'
    if (-not (Test-Path -LiteralPath $procDir)) {
        return @{
            totalProcessFiles = 0
            processesComplete = 0
            processesPartial  = 0
            processesSkeleton = 0
            processes         = @()
        }
    }

    $excludeFiles = @('README.md', 'PROCESY_END_TO_END.md')
    $procFiles = Get-ChildItem -LiteralPath $procDir -Filter '*.md' |
        Where-Object { $excludeFiles -notcontains $_.Name }

    $processes = @()

    foreach ($file in $procFiles) {
        $content = Get-Content -LiteralPath $file.FullName -Raw -Encoding UTF8

        $isE2E = $file.Name -match '_E2E\.md$|_LIFECYCLE\.md$'
        $fileType = if ($isE2E) { 'e2e' } else { 'proc' }

        $hasCel     = $content -match '##\s+Cel'
        $hasOpis    = $content -match '##\s+(Opis|Przepływ|Przepl[^\s]*)'
        $hasKroki   = ($content -match '\|\s*\d+') -or ($content -match '##\s+(Kroki|Happy Path|Etap\s)')
        $hasBledy   = $content -match '##\s+[^#]*(Bl[^\s]*d|Error|błęd|B[lł][eę]d)'
        $screenRefs = ([regex]::Matches($content, 'E-\d{3}')).Count
        $apiRefs    = ([regex]::Matches($content, '/api/')).Count

        $sectionsFilled = @($hasCel, $hasOpis, $hasKroki, $hasBledy) | Where-Object { $_ } | Measure-Object | Select-Object -ExpandProperty Count

        $completionLevel = switch ($sectionsFilled) {
            { $_ -ge 4 }              { 'kompletny' }
            { $_ -ge 2 }              { 'częściowy' }
            default                    { 'szkielet' }
        }

        $processes += [pscustomobject]@{
            fileName         = $file.Name
            fileType         = $fileType
            hasCel           = $hasCel
            hasOpis          = $hasOpis
            hasKroki         = $hasKroki
            hasBledy         = $hasBledy
            screenRefs       = $screenRefs
            apiRefs          = $apiRefs
            completionLevel  = $completionLevel
        }
    }

    return @{
        totalProcessFiles = $processes.Count
        processesComplete = @($processes | Where-Object { $_.completionLevel -eq 'kompletny' }).Count
        processesPartial  = @($processes | Where-Object { $_.completionLevel -eq 'częściowy' }).Count
        processesSkeleton = @($processes | Where-Object { $_.completionLevel -eq 'szkielet' }).Count
        processes         = $processes
    }
}

function Get-DocCorpus {
    $docRoot = Join-Path $ProjectRoot 'AI_Documentation'
    $excludeDirs = @('_archive', 'AOS_Template', 'templates')

    $allContent = New-Object System.Text.StringBuilder

    Get-ChildItem -LiteralPath $docRoot -Recurse -Filter '*.md' -ErrorAction SilentlyContinue |
        Where-Object {
            $excluded = $false
            foreach ($ex in $excludeDirs) {
                if ($_.FullName -match [regex]::Escape($ex)) { $excluded = $true; break }
            }
            -not $excluded
        } | ForEach-Object {
            try {
                $txt = Get-Content -LiteralPath $_.FullName -Raw -Encoding UTF8
                [void]$allContent.Append($txt)
                [void]$allContent.AppendLine()
            } catch { }
        }

    return $allContent.ToString()
}

function Get-AlgorithmCoverage {
    param([string]$DocCorpus)

    $servicesRoot = Join-Path $ProjectRoot 'services'
    $handlers = @()
    $validators = @()

    if (Test-Path -LiteralPath $servicesRoot) {
        $csFiles = Get-ChildItem -LiteralPath $servicesRoot -Recurse -Filter '*.cs' -ErrorAction SilentlyContinue |
            Where-Object { $_.FullName -notmatch '\\(bin|obj)\\' }

        foreach ($file in $csFiles) {
            try {
                $content = Get-Content -LiteralPath $file.FullName -Raw -Encoding UTF8

                $handlerMatches = [regex]::Matches($content, 'class\s+(\w+Handler)\b')
                foreach ($m in $handlerMatches) {
                    $handlerClass = $m.Groups[1].Value
                    $baseName = $handlerClass -replace 'Handler$', ''
                    $requestMatch = [regex]::Match($content, 'IRequestHandler<\s*(\w+)')
                    $requestType = if ($requestMatch.Success) { $requestMatch.Groups[1].Value } else { 'do uzupełnienia' }
                    $inDocs = $DocCorpus.IndexOf($baseName, [System.StringComparison]::OrdinalIgnoreCase) -ge 0
                    $handlers += [pscustomobject]@{
                        handlerClass            = $handlerClass
                        requestType             = $requestType
                        file                    = $file.FullName.Replace($ProjectRoot + '\', '').Replace('\', '/')
                        baseNameForSearch       = $baseName
                        appearsInDocumentation  = $inDocs
                    }
                }

                $validatorMatches = [regex]::Matches($content, 'class\s+(\w+Validator)\b[^{]*AbstractValidator')
                foreach ($m in $validatorMatches) {
                    $validatorClass = $m.Groups[1].Value
                    $baseName = $validatorClass -replace 'Validator$', ''
                    $inDocs = $DocCorpus.IndexOf($baseName, [System.StringComparison]::OrdinalIgnoreCase) -ge 0
                    $validators += [pscustomobject]@{
                        validatorClass          = $validatorClass
                        file                    = $file.FullName.Replace($ProjectRoot + '\', '').Replace('\', '/')
                        baseNameForSearch       = $baseName
                        appearsInDocumentation  = $inDocs
                    }
                }
            } catch { }
        }
    }

    $undocumentedHandlers = @($handlers | Where-Object { -not $_.appearsInDocumentation } | ForEach-Object { $_.handlerClass })
    $undocumentedValidators = @($validators | Where-Object { -not $_.appearsInDocumentation } | ForEach-Object { $_.validatorClass })

    return @{
        totalHandlers           = $handlers.Count
        documentedHandlers      = @($handlers | Where-Object { $_.appearsInDocumentation }).Count
        undocumentedHandlers    = $undocumentedHandlers
        handlers                = $handlers
        totalValidators         = $validators.Count
        documentedValidators    = @($validators | Where-Object { $_.appearsInDocumentation }).Count
        undocumentedValidators  = $undocumentedValidators
        validators              = $validators
    }
}

# --- Główny blok wykonawczy ---

Write-Host "Invoke-DocumentationAudit.ps1 — uruchamiam audyt..."
Write-Host "ProjectRoot: $ProjectRoot"

$gitHead = Get-GitHead
Write-Host "Git HEAD: $gitHead"

Write-Host "Analizuję pokrycie ekranów..."
$screenCoverage = Get-ScreenCoverage

Write-Host "Analizuję pokrycie procesów..."
$processCoverage = Get-ProcessCoverage

Write-Host "Buduję korpus dokumentacji..."
$docCorpus = Get-DocCorpus

Write-Host "Analizuję handlery i walidatory..."
$algorithmCoverage = Get-AlgorithmCoverage -DocCorpus $docCorpus

$auditResult = [ordered]@{
    generatedAtUtc    = (Get-Date).ToUniversalTime().ToString('yyyy-MM-ddTHH:mm:ssZ')
    scriptName        = 'Invoke-DocumentationAudit.ps1'
    scriptVersion     = 'audit_v1'
    gitHead           = $gitHead
    disclaimer        = 'Wyniki są heurystyczne. Parser statyczny nie zastępuje ręcznej weryfikacji w kodzie.'
    screenCoverage    = $screenCoverage
    processCoverage   = $processCoverage
    algorithmCoverage = $algorithmCoverage
}

$jsonText = $auditResult | ConvertTo-Json -Depth 10
if (-not $WhatIf) {
    New-Item -ItemType Directory -Force -Path (Split-Path -Parent $OutputJson) | Out-Null
    [System.IO.File]::WriteAllText($OutputJson, $jsonText, $utf8NoBom)
    Write-Host "JSON zapisany: $OutputJson"
}

# --- Budowanie raportu Markdown ---

$sc = $screenCoverage
$pc = $processCoverage
$ac = $algorithmCoverage

$screenPct  = if ($sc.totalScreenDirs -gt 0) { [math]::Round(100 * $sc.screensComplete / $sc.totalScreenDirs) } else { 0 }
$procPct    = if ($pc.totalProcessFiles -gt 0) { [math]::Round(100 * $pc.processesComplete / $pc.totalProcessFiles) } else { 0 }
$handlerPct = if ($ac.totalHandlers -gt 0)   { [math]::Round(100 * $ac.documentedHandlers / $ac.totalHandlers) } else { 0 }
$validPct   = if ($ac.totalValidators -gt 0) { [math]::Round(100 * $ac.documentedValidators / $ac.totalValidators) } else { 0 }

$md = New-Object System.Collections.Generic.List[string]

$md.Add("# Raport Audytu Dokumentacji")
$md.Add("")
$md.Add("Wygenerowano: $($auditResult.generatedAtUtc)")
$md.Add("Git HEAD: ``$gitHead``")
$md.Add("Generator: Invoke-DocumentationAudit.ps1 (audit_v1)")
$md.Add("")
$md.Add("> **Zastrzeżenie:** wyniki są heurystyczne — parser statyczny i wyszukiwanie tekstowe.")
$md.Add("> Raport jest materiałem pomocniczym; fakty należy potwierdzić ręcznie w kodzie.")
$md.Add("")
$md.Add("## Podsumowanie Wykonawcze")
$md.Add("")
$md.Add("| Obszar | Razem | Kompletne | Szkielety / Luki | Pokrycie % |")
$md.Add("|---|---:|---:|---:|---:|")
$md.Add("| Ekrany (E-NNN) | $($sc.totalScreenDirs) | $($sc.screensComplete) | $($sc.screensSkeleton.Count) | $screenPct% |")
$md.Add("| Procesy (PROC + E2E) | $($pc.totalProcessFiles) | $($pc.processesComplete) | $($pc.processesSkeleton + $pc.processesPartial) | $procPct% |")
$md.Add("| Handlery MediatR | $($ac.totalHandlers) | $($ac.documentedHandlers) | $($ac.undocumentedHandlers.Count) | $handlerPct% |")
$md.Add("| Walidatory | $($ac.totalValidators) | $($ac.documentedValidators) | $($ac.undocumentedValidators.Count) | $validPct% |")
$md.Add("")
$md.Add("## Macierz Pokrycia Ekranów")
$md.Add("")
$md.Add("| ID | Katalog | Struktura | Status README | Pola | Akcje | TC | Poziom |")
$md.Add("|---|---|---|---|---:|---:|---:|---|")
foreach ($s in $sc.screens) {
    $struct = if ($s.hasRequiredStructure) { 'tak' } else { 'brak' }
    $md.Add("| ``$($s.screenId)`` | $($s.directoryName) | $struct | $($s.readmeStatus) | $($s.fieldCount) | $($s.actionCount) | $($s.tcCount) | **$($s.completionLevel)** |")
}
$md.Add("")
$md.Add("## Luki Procesów")
$md.Add("")
$md.Add("| Plik | Typ | Cel | Opis/Przepływ | Kroki | Błędy | Ref. Ekranów | Poziom |")
$md.Add("|---|---|---|---|---|---|---:|---|")
foreach ($p in $pc.processes) {
    $cel   = if ($p.hasCel)   { 'tak' } else { '—' }
    $opis  = if ($p.hasOpis)  { 'tak' } else { '—' }
    $kroki = if ($p.hasKroki) { 'tak' } else { '—' }
    $bledy = if ($p.hasBledy) { 'tak' } else { '—' }
    $md.Add("| $($p.fileName) | $($p.fileType) | $cel | $opis | $kroki | $bledy | $($p.screenRefs) | **$($p.completionLevel)** |")
}
$md.Add("")

if ($ac.undocumentedHandlers.Count -gt 0) {
    $md.Add("## Nieudokumentowane Handlery MediatR")
    $md.Add("")
    $md.Add("| Klasa Handlera | Typ Żądania | Plik |")
    $md.Add("|---|---|---|")
    foreach ($h in ($ac.handlers | Where-Object { -not $_.appearsInDocumentation })) {
        $md.Add("| ``$($h.handlerClass)`` | ``$($h.requestType)`` | ``$($h.file)`` |")
    }
    $md.Add("")
}

if ($ac.undocumentedValidators.Count -gt 0) {
    $md.Add("## Nieudokumentowane Walidatory")
    $md.Add("")
    $md.Add("| Klasa Walidatora | Plik |")
    $md.Add("|---|---|")
    foreach ($v in ($ac.validators | Where-Object { -not $_.appearsInDocumentation })) {
        $md.Add("| ``$($v.validatorClass)`` | ``$($v.file)`` |")
    }
    $md.Add("")
}

$md.Add("## Jak Używać")
$md.Add("")
$md.Add("1. Sprawdź ekrany oznaczone ``szkielet`` — użyj skilla ``aos-documentation-from-code`` do uzupełnienia AOS.")
$md.Add("2. Dla procesów z lukami wypełnij brakujące sekcje (Cel, Opis/Przepływ, Kroki, Błędy).")
$md.Add("3. Dla nieudokumentowanych handlerów sprawdź, czy są objęte istniejącym PROC lub E2E.")
$md.Add("4. Wyniki potwierdź w kodzie przed zmianą statusu faktu na ``potwierdzone``.")
$md.Add("5. Po uzupełnieniu uruchom ``Test-Podejscie2DocumentationQuality.ps1`` jako bramkę jakości.")
$md.Add("")

$mdText = ($md -join [Environment]::NewLine).TrimEnd() + [Environment]::NewLine
if (-not $WhatIf) {
    [System.IO.File]::WriteAllText($OutputMarkdown, $mdText, $utf8NoBom)
    Write-Host "Markdown zapisany: $OutputMarkdown"
}

Write-Host ""
Write-Host "=== PODSUMOWANIE ==="
Write-Host "Ekrany:   $($sc.screensComplete)/$($sc.totalScreenDirs) kompletnych ($screenPct%)"
Write-Host "Procesy:  $($pc.processesComplete)/$($pc.totalProcessFiles) kompletnych ($procPct%)"
Write-Host "Handlery: $($ac.documentedHandlers)/$($ac.totalHandlers) udokumentowanych ($handlerPct%)"
Write-Host "Walidatory: $($ac.documentedValidators)/$($ac.totalValidators) udokumentowanych ($validPct%)"
if ($ac.undocumentedHandlers.Count -gt 0) {
    Write-Host "Nieudokumentowane handlery: $($ac.undocumentedHandlers -join ', ')"
}
