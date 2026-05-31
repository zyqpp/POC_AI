param(
    [string]$ProjectRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path,
    [string]$RoutesJson = '',
    [string]$OutputRoot = '',
    [string]$TemplateRoot = '',
    [switch]$Force,
    [switch]$DryRun
)

$ErrorActionPreference = 'Stop'

if ([string]::IsNullOrWhiteSpace($RoutesJson)) {
    $RoutesJson = Join-Path $ProjectRoot 'AI_Documentation\10_WARSZTAT_AGENTOW\fakty\angular-routes.json'
}

if ([string]::IsNullOrWhiteSpace($OutputRoot)) {
    $OutputRoot = Join-Path $ProjectRoot 'AI_Documentation\05_UI_AOS\EKRANY'
}

if ([string]::IsNullOrWhiteSpace($TemplateRoot)) {
    $TemplateRoot = Join-Path $ProjectRoot 'AI_Documentation\10_WARSZTAT_AGENTOW\templates\atomic-frontend-screen'
}

function Convert-ToRepoRelative {
    param([string]$Path)

    if ([string]::IsNullOrWhiteSpace($Path)) {
        return 'brak w kodzie'
    }

    $full = [System.IO.Path]::GetFullPath($Path)
    $root = [System.IO.Path]::GetFullPath($ProjectRoot)
    if ($full.StartsWith($root, [System.StringComparison]::OrdinalIgnoreCase)) {
        return $full.Substring($root.Length).TrimStart('\', '/').Replace('\', '/')
    }

    return $full.Replace('\', '/')
}

function Convert-ToSafeSlug {
    param([string]$Value)

    if ([string]::IsNullOrWhiteSpace($Value)) {
        return 'do-uzupelnienia'
    }

    $normalized = $Value.Normalize([System.Text.NormalizationForm]::FormD)
    $builder = New-Object System.Text.StringBuilder
    foreach ($char in $normalized.ToCharArray()) {
        $category = [System.Globalization.CharUnicodeInfo]::GetUnicodeCategory($char)
        if ($category -ne [System.Globalization.UnicodeCategory]::NonSpacingMark) {
            [void]$builder.Append($char)
        }
    }

    $slug = $builder.ToString().ToLowerInvariant()
    $slug = $slug -replace '[^a-z0-9]+', '-'
    $slug = $slug -replace '-+', '-'
    $slug = $slug.Trim('-')
    if ([string]::IsNullOrWhiteSpace($slug)) {
        return 'do-uzupelnienia'
    }

    return $slug
}

function Convert-ToScreenSegment {
    param([string]$Route)

    $segment = $Route
    if ([string]::IsNullOrWhiteSpace($segment)) {
        $segment = 'root'
    }

    $segment = $segment -replace ':', ''
    $segment = $segment -replace '[^A-Za-z0-9]+', '_'
    $segment = $segment.Trim('_').ToUpperInvariant()
    if ([string]::IsNullOrWhiteSpace($segment)) {
        return 'ROOT'
    }

    return $segment
}

function Convert-ToDisplayName {
    param([string]$Value)

    if ([string]::IsNullOrWhiteSpace($Value)) {
        return 'do-uzupelnienia'
    }

    $text = $Value.Trim()
    $text = $text -replace '\{\{', ''
    $text = $text -replace '\}\}', ''
    $text = $text -replace '\s+', ' '
    $text = $text -replace '[\r\n\|]', ' '
    $text = $text.Trim()
    if ($text.Length -gt 120) {
        $text = $text.Substring(0, 120).Trim()
    }
    return $text
}

function Convert-ToActionName {
    param([string]$Expression)

    $name = Convert-ToDisplayName $Expression
    $name = $name -replace '\(.+\)$', ''
    $name = $name -replace '\(\)$', ''
    $name = $name -replace '^this\.', ''
    return (Convert-ToDisplayName $name)
}

function Escape-MdCell {
    param([string]$Value)

    if ([string]::IsNullOrWhiteSpace($Value)) {
        return 'do-uzupelnienia'
    }

    return ($Value -replace '\|', '\|' -replace "`r", ' ' -replace "`n", ' ')
}

function Read-Template {
    param([string]$Name)

    $path = Join-Path $TemplateRoot $Name
    if (-not (Test-Path -LiteralPath $path)) {
        throw "Template not found: $path"
    }

    return Get-Content -LiteralPath $path -Raw -Encoding UTF8
}

function Convert-Template {
    param(
        [string]$Template,
        [hashtable]$Tokens
    )

    $content = $Template
    foreach ($key in $Tokens.Keys) {
        $content = $content.Replace("{{$key}}", [string]$Tokens[$key])
    }

    return $content
}

function Write-GeneratedFile {
    param(
        [string]$Path,
        [string]$Content
    )

    $relative = Convert-ToRepoRelative $Path
    if ((Test-Path -LiteralPath $Path) -and -not $Force) {
        Write-Host "Skip existing: $relative"
        return
    }

    if ($DryRun) {
        Write-Host "Would write: $relative"
        return
    }

    $directory = Split-Path -Parent $Path
    New-Item -ItemType Directory -Force -Path $directory | Out-Null
    $normalizedContent = $Content.TrimEnd() + [Environment]::NewLine
    $utf8NoBom = New-Object System.Text.UTF8Encoding($false)
    [System.IO.File]::WriteAllText($Path, $normalizedContent, $utf8NoBom)
    Write-Host "Wrote: $relative"
}

function Add-Candidate {
    param(
        [System.Collections.Generic.List[object]]$List,
        [hashtable]$Seen,
        [string]$Name,
        [string]$Kind,
        [string]$Source
    )

    $cleanName = Convert-ToDisplayName $Name
    if ([string]::IsNullOrWhiteSpace($cleanName) -or $cleanName -eq 'do-uzupelnienia') {
        return
    }

    $key = $cleanName.ToLowerInvariant()
    if ($Seen.ContainsKey($key)) {
        return
    }

    $Seen[$key] = $true
    $List.Add([pscustomobject]@{
        Name = $cleanName
        Kind = $Kind
        Source = $Source
    }) | Out-Null
}

function Add-FallbackCandidate {
    param(
        [System.Collections.Generic.List[object]]$List,
        [string]$Name,
        [string]$Kind,
        [string]$Source
    )

    if ($List.Count -eq 0) {
        $List.Add([pscustomobject]@{
            Name = $Name
            Kind = $Kind
            Source = $Source
        }) | Out-Null
    }
}

function Get-ComponentFiles {
    param([object]$Route)

    $result = [ordered]@{
        Ts = ''
        Html = ''
    }

    if ($null -eq $Route.importPath -or [string]::IsNullOrWhiteSpace($Route.importPath)) {
        return $result
    }

    $componentPath = ($Route.importPath -replace '^\./', '').Replace('/', '\')
    $result.Ts = Join-Path $ProjectRoot "supply-chain-frontend\src\app\$componentPath.ts"
    $result.Html = Join-Path $ProjectRoot "supply-chain-frontend\src\app\$componentPath.html"
    return $result
}

function Get-TextIfExists {
    param([string]$Path)

    if ([string]::IsNullOrWhiteSpace($Path) -or -not (Test-Path -LiteralPath $Path)) {
        return ''
    }

    return Get-Content -LiteralPath $Path -Raw -Encoding UTF8
}

function Get-FieldCandidates {
    param(
        [string]$Html,
        [string]$Ts,
        [string]$HtmlSource,
        [string]$TsSource
    )

    $list = New-Object System.Collections.Generic.List[object]
    $seen = @{}

    foreach ($match in [regex]::Matches($Html, '<(?:input|select|textarea)\b(?<attrs>[^>]*)>', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)) {
        $attrs = $match.Groups['attrs'].Value
        $attrOrder = @('formControlName', '[(ngModel)]', '[ngModel]', '[checked]', 'name', 'id', 'aria-label', 'placeholder')
        foreach ($attr in $attrOrder) {
            $pattern = [regex]::Escape($attr) + '\s*=\s*["'']([^"'']+)["'']'
            $attrMatch = [regex]::Match($attrs, $pattern)
            if ($attrMatch.Success) {
                Add-Candidate $list $seen $attrMatch.Groups[1].Value $attr $HtmlSource
                break
            }
        }
    }

    foreach ($match in [regex]::Matches($Html, '\{\{\s*([A-Za-z_][A-Za-z0-9_\.]*)\s*(?:\||\}\})')) {
        Add-Candidate $list $seen $match.Groups[1].Value 'interpolation' $HtmlSource
    }

    foreach ($groupMatch in [regex]::Matches($Ts, '(?s)\.group\s*\(\s*\{(?<body>.*?)\}\s*\)')) {
        $body = $groupMatch.Groups['body'].Value
        foreach ($controlMatch in [regex]::Matches($body, '(?m)^\s*([A-Za-z_][A-Za-z0-9_]*)\s*:')) {
            Add-Candidate $list $seen $controlMatch.Groups[1].Value 'reactive-form-group' $TsSource
        }
    }

    Add-FallbackCandidate $list 'do-uzupelnienia' 'brak-detektowanych-pol' 'wymaga recznego przegladu komponentu i template'
    return $list.ToArray()
}

function Get-ActionCandidates {
    param(
        [string]$Html,
        [string]$Ts,
        [string]$HtmlSource
    )

    $list = New-Object System.Collections.Generic.List[object]
    $seen = @{}

    foreach ($match in [regex]::Matches($Html, '\(ngSubmit\)\s*=\s*["'']([^"'']+)["'']')) {
        Add-Candidate $list $seen (Convert-ToActionName $match.Groups[1].Value) 'ngSubmit' $HtmlSource
    }

    foreach ($match in [regex]::Matches($Html, '\(click\)\s*=\s*["'']([^"'']+)["'']')) {
        Add-Candidate $list $seen (Convert-ToActionName $match.Groups[1].Value) 'click' $HtmlSource
    }

    foreach ($match in [regex]::Matches($Html, '(?<!\[)routerLink\s*=\s*["'']([^"'']+)["'']')) {
        Add-Candidate $list $seen "navigate $($match.Groups[1].Value)" 'routerLink' $HtmlSource
    }

    foreach ($match in [regex]::Matches($Html, '\[routerLink\]\s*=\s*["'']([^"'']+)["'']')) {
        Add-Candidate $list $seen "navigate $($match.Groups[1].Value)" 'bound-routerLink' $HtmlSource
    }

    if ($Html -match '<button\b[^>]*type\s*=\s*["'']submit["'']') {
        Add-Candidate $list $seen 'submit' 'submit-button' $HtmlSource
    }

    Add-FallbackCandidate $list 'do-uzupelnienia' 'brak-detektowanych-akcji' 'wymaga recznego przegladu komponentu i template'
    return $list.ToArray()
}

function Get-ErrorCandidates {
    param(
        [string]$Html,
        [string]$Ts,
        [string]$HtmlSource,
        [string]$TsSource
    )

    $list = New-Object System.Collections.Generic.List[object]
    $seen = @{}

    foreach ($match in [regex]::Matches($Html, '(?is)<mat-error[^>]*>(.*?)</mat-error>')) {
        $text = ($match.Groups[1].Value -replace '<[^>]+>', ' ' -replace '\s+', ' ').Trim()
        Add-Candidate $list $seen $text 'mat-error' $HtmlSource
    }

    foreach ($match in [regex]::Matches($Html, 'hasError\s*\(\s*["'']([^"'']+)["'']\s*\)')) {
        Add-Candidate $list $seen "hasError $($match.Groups[1].Value)" 'hasError' $HtmlSource
    }

    foreach ($match in [regex]::Matches($Html, '\*ngIf\s*=\s*["''][^"'']*(error|invalid|hasError)[^"'']*["'']', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)) {
        Add-Candidate $list $seen $match.Value 'conditional-error-view' $HtmlSource
    }

    foreach ($match in [regex]::Matches($Html, '@if\s*\(([^)]*(error|invalid|errorMsg|createError)[^)]*)\)', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)) {
        Add-Candidate $list $seen $match.Groups[1].Value 'angular-if-error-view' $HtmlSource
    }

    foreach ($match in [regex]::Matches($Html, '(?is)<[^>]*class\s*=\s*["''][^"'']*(form-error|alert-error|alert alert-error)[^"'']*["''][^>]*>(.*?)</[^>]+>')) {
        $text = ($match.Groups[2].Value -replace '<[^>]+>', ' ' -replace '\s+', ' ').Trim()
        Add-Candidate $list $seen $text 'error-css-class' $HtmlSource
    }

    foreach ($match in [regex]::Matches($Ts, '(?i)(toast\.(error|warning)|snackBar\.open|errorMessage)\s*(?:=|\()\s*([^;\r\n\)]*)')) {
        Add-Candidate $list $seen $match.Groups[3].Value.Trim(' ', '"', '''') $match.Groups[1].Value $TsSource
    }

    Add-FallbackCandidate $list 'do-uzupelnienia' 'brak-detektowanych-bledow' 'wymaga recznego przegladu komponentu i template'
    return $list.ToArray()
}

function New-Row {
    param(
        [string]$Id,
        [string]$Name,
        [string]$Kind,
        [string]$Source,
        [string]$FileName
    )

    return '| `' + $Id + '` | ' + (Escape-MdCell $Name) + ' | ' + (Escape-MdCell $Kind) + ' | `' + (Escape-MdCell $Source) + '` | [' + $FileName + '](' + $FileName + ') |'
}

if (-not (Test-Path -LiteralPath $RoutesJson)) {
    $exporter = Join-Path $ProjectRoot 'AI_Agent_scripts\Export-Podejscie2AngularRoutes.ps1'
    if (-not (Test-Path -LiteralPath $exporter)) {
        throw "Routes JSON not found and exporter not found: $RoutesJson"
    }

    if ($DryRun) {
        Write-Host "Routes JSON missing. Would run: $exporter"
    } else {
        & $exporter -ProjectRoot $ProjectRoot -OutFile $RoutesJson
    }
}

$routeFacts = Get-Content -LiteralPath $RoutesJson -Raw -Encoding UTF8 | ConvertFrom-Json
$screenRoutes = @($routeFacts.routes | Where-Object {
        $null -ne $_.component `
            -and -not [string]::IsNullOrWhiteSpace($_.path) `
            -and $_.path -ne '**' `
            -and $_.component -ne 'AppShellComponent'
    })

if ($screenRoutes.Count -eq 0) {
    throw "No screen routes found in $RoutesJson"
}

if (-not $DryRun) {
    New-Item -ItemType Directory -Force -Path $OutputRoot | Out-Null
}

$screenRows = New-Object System.Collections.Generic.List[string]
$screenIndexTemplate = Read-Template 'TPL-UI-012__SCREEN_INDEX.md'

$ordinal = 0
foreach ($route in $screenRoutes) {
    $ordinal++
    $number = '{0:D3}' -f $ordinal
    $screenId = "E-$number"
    $screenSegment = Convert-ToScreenSegment $route.path
    $screenDirName = "${screenId}_$screenSegment"
    $screenDir = Join-Path $OutputRoot $screenDirName
    $componentFiles = Get-ComponentFiles $route
    $componentTsRel = Convert-ToRepoRelative $componentFiles.Ts
    $componentHtmlRel = Convert-ToRepoRelative $componentFiles.Html
    $htmlText = Get-TextIfExists $componentFiles.Html
    $tsText = Get-TextIfExists $componentFiles.Ts
    $roles = if ($route.roles.Count -gt 0) { ($route.roles -join ', ') } else { 'brak r' + [char]0x00F3 + 'l w route' }
    $guards = if ($route.canActivate.Count -gt 0) { ($route.canActivate -join ', ') } else { 'brak guard' + [char]0x00F3 + 'w w route' }

    $tokens = @{
        SCREEN_ID = $screenId
        SCREEN_NUMBER = $number
        SCREEN_NAME = $route.component
        ROUTE = "/$($route.path)"
        COMPONENT = $route.component
        GUARDS = $guards
        ROLES = $roles
        ROUTES_SOURCE = Convert-ToRepoRelative $routeFacts.source
        COMPONENT_SOURCE = $componentTsRel
        TEMPLATE_SOURCE = $componentHtmlRel
    }

    Write-GeneratedFile (Join-Path $screenDir "${screenId}__README.md") (Convert-Template (Read-Template 'TPL-UI-001__SCREEN_README.md') $tokens)
    Write-GeneratedFile (Join-Path $screenDir "${screenId}__LINKI.md") (Convert-Template (Read-Template 'TPL-UI-002__LINKS_TRACE.md') $tokens)

    $fields = Get-FieldCandidates $htmlText $tsText $componentHtmlRel $componentTsRel
    $fieldDir = Join-Path $screenDir "P-${number}_POLA"
    $testDataDir = Join-Path $screenDir "TD-${number}_DANE_TESTOWE"
    $fieldRows = New-Object System.Collections.Generic.List[string]
    $testDataRows = New-Object System.Collections.Generic.List[string]

    for ($i = 0; $i -lt $fields.Count; $i++) {
        $itemNumber = '{0:D4}' -f ($i + 1)
        $fieldId = "P-$number-$itemNumber"
        $testDataId = "TD-$number-$itemNumber"
        $fieldSlug = Convert-ToSafeSlug $fields[$i].Name
        $fieldFileName = "${fieldId}__${fieldSlug}.md"
        $testDataFileName = "${testDataId}__${fieldSlug}.md"
        $fieldTokens = $tokens.Clone()
        $fieldTokens.FIELD_ID = $fieldId
        $fieldTokens.FIELD_NAME = $fields[$i].Name
        $fieldTokens.FIELD_KIND = $fields[$i].Kind
        $fieldTokens.FIELD_SOURCE = $fields[$i].Source
        $fieldTokens.FIELD_SLUG = $fieldSlug
        $fieldTokens.TEST_DATA_ID = $testDataId

        Write-GeneratedFile (Join-Path $fieldDir $fieldFileName) (Convert-Template (Read-Template 'TPL-UI-003__FIELD_ATOM.md') $fieldTokens)
        Write-GeneratedFile (Join-Path $testDataDir $testDataFileName) (Convert-Template (Read-Template 'TPL-UI-006__TEST_DATA_ATOM.md') $fieldTokens)
        $fieldRows.Add((New-Row $fieldId $fields[$i].Name $fields[$i].Kind $fields[$i].Source $fieldFileName)) | Out-Null
        $testDataRows.Add('| `' + $testDataId + '` | [' + $fieldId + '](../P-' + $number + '_POLA/' + $fieldFileName + ') | [' + $testDataFileName + '](' + $testDataFileName + ') |') | Out-Null
    }

    $fieldIndexTokens = $tokens.Clone()
    $fieldIndexTokens.FIELD_ROWS = ($fieldRows -join [Environment]::NewLine)
    Write-GeneratedFile (Join-Path $fieldDir "P-${number}__INDEX.md") (Convert-Template (Read-Template 'TPL-UI-007__FIELD_INDEX.md') $fieldIndexTokens)

    $testDataIndexTokens = $tokens.Clone()
    $testDataIndexTokens.TEST_DATA_ROWS = ($testDataRows -join [Environment]::NewLine)
    Write-GeneratedFile (Join-Path $testDataDir "TD-${number}__INDEX.md") (Convert-Template (Read-Template 'TPL-UI-010__TEST_DATA_INDEX.md') $testDataIndexTokens)

    $actions = Get-ActionCandidates $htmlText $tsText $componentHtmlRel
    $actionDir = Join-Path $screenDir "A-${number}_AKCJE"
    $actionRows = New-Object System.Collections.Generic.List[string]
    for ($i = 0; $i -lt $actions.Count; $i++) {
        $itemNumber = '{0:D4}' -f ($i + 1)
        $actionId = "A-$number-$itemNumber"
        $actionSlug = Convert-ToSafeSlug $actions[$i].Name
        $actionFileName = "${actionId}__${actionSlug}.md"
        $actionTokens = $tokens.Clone()
        $actionTokens.ACTION_ID = $actionId
        $actionTokens.ACTION_NAME = $actions[$i].Name
        $actionTokens.ACTION_KIND = $actions[$i].Kind
        $actionTokens.ACTION_SOURCE = $actions[$i].Source
        Write-GeneratedFile (Join-Path $actionDir $actionFileName) (Convert-Template (Read-Template 'TPL-UI-004__ACTION_ATOM.md') $actionTokens)
        $actionRows.Add((New-Row $actionId $actions[$i].Name $actions[$i].Kind $actions[$i].Source $actionFileName)) | Out-Null
    }

    $actionIndexTokens = $tokens.Clone()
    $actionIndexTokens.ACTION_ROWS = ($actionRows -join [Environment]::NewLine)
    Write-GeneratedFile (Join-Path $actionDir "A-${number}__INDEX.md") (Convert-Template (Read-Template 'TPL-UI-008__ACTION_INDEX.md') $actionIndexTokens)

    $errors = Get-ErrorCandidates $htmlText $tsText $componentHtmlRel $componentTsRel
    $errorDir = Join-Path $screenDir "ERR-${number}_BLEDY"
    $errorRows = New-Object System.Collections.Generic.List[string]
    for ($i = 0; $i -lt $errors.Count; $i++) {
        $itemNumber = '{0:D4}' -f ($i + 1)
        $errorId = "ERR-$number-$itemNumber"
        $errorSlug = Convert-ToSafeSlug $errors[$i].Name
        $errorFileName = "${errorId}__${errorSlug}.md"
        $errorTokens = $tokens.Clone()
        $errorTokens.ERROR_ID = $errorId
        $errorTokens.ERROR_NAME = $errors[$i].Name
        $errorTokens.ERROR_KIND = $errors[$i].Kind
        $errorTokens.ERROR_SOURCE = $errors[$i].Source
        Write-GeneratedFile (Join-Path $errorDir $errorFileName) (Convert-Template (Read-Template 'TPL-UI-005__ERROR_ATOM.md') $errorTokens)
        $errorRows.Add((New-Row $errorId $errors[$i].Name $errors[$i].Kind $errors[$i].Source $errorFileName)) | Out-Null
    }

    $errorIndexTokens = $tokens.Clone()
    $errorIndexTokens.ERROR_ROWS = ($errorRows -join [Environment]::NewLine)
    Write-GeneratedFile (Join-Path $errorDir "ERR-${number}__INDEX.md") (Convert-Template (Read-Template 'TPL-UI-009__ERROR_INDEX.md') $errorIndexTokens)

    $testDir = Join-Path $screenDir "TC-${number}_TESTY"
    Write-GeneratedFile (Join-Path $testDir "TC-${number}__INDEX.md") (Convert-Template (Read-Template 'TPL-UI-011__TEST_CASE_INDEX.md') $tokens)

    $screenDoc = "$screenDirName/${screenId}__README.md"
    $screenRows.Add('| `' + $screenId + '` | `/' + $route.path + '` | `' + $route.component + '` | ' + (Escape-MdCell $roles) + ' | [' + $screenDoc + '](' + $screenDoc + ') |') | Out-Null
}

$indexTokens = @{
    SCREEN_ROWS = ($screenRows -join [Environment]::NewLine)
}
Write-GeneratedFile (Join-Path $OutputRoot 'E-000__INDEKS_EKRANOW.md') (Convert-Template $screenIndexTemplate $indexTokens)

Write-Host "Frontend screen scaffold finished. Screens: $($screenRoutes.Count)"
