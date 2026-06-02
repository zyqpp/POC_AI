[CmdletBinding()]
param(
    [string]$ConfigFile = "mkdocs-tech.yml",
    [string]$DocsDir = "AI_Documentation",
    [string]$SiteDir = "site-tech",
    [string]$PythonExe = ".\.venv\Scripts\python.exe",
    [switch]$SkipBuild
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Test-ConfigContains {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Content,
        [Parameter(Mandatory = $true)]
        [string]$Pattern
    )

    $options = [System.Text.RegularExpressions.RegexOptions]::IgnoreCase -bor [System.Text.RegularExpressions.RegexOptions]::Multiline
    return [regex]::IsMatch($Content, $Pattern, $options)
}

function Get-HtmlFilesSafe {
    param(
        [Parameter(Mandatory = $true)]
        [string]$RootPath
    )

    $files = New-Object System.Collections.Generic.List[string]
    $pending = New-Object System.Collections.Generic.Stack[string]
    $pending.Push((Resolve-Path $RootPath).Path)

    while ($pending.Count -gt 0) {
        $current = $pending.Pop()

        try {
            foreach ($dir in [System.IO.Directory]::EnumerateDirectories($current)) {
                $pending.Push($dir)
            }
        }
        catch {
            Write-Warning "Pomijam katalog niedostepny dla enumeracji: $current"
            continue
        }

        try {
            foreach ($file in [System.IO.Directory]::EnumerateFiles($current, "*.html")) {
                $files.Add($file)
            }
        }
        catch {
            Write-Warning "Pomijam pliki HTML niedostepne dla enumeracji: $current"
        }
    }

    return $files
}

if (-not (Test-Path $ConfigFile)) {
    throw "Brak pliku konfiguracji: $ConfigFile"
}

if (-not (Test-Path $DocsDir)) {
    throw "Brak katalogu dokumentacji: $DocsDir"
}

if (-not (Test-Path $PythonExe)) {
    throw "Brak interpretera Python w .venv: $PythonExe"
}

$configRaw = Get-Content -Path $ConfigFile -Raw

$mermaidConfigOk = Test-ConfigContains -Content $configRaw -Pattern 'name:\s*mermaid[\s\S]*class:\s*mermaid[\s\S]*fence_code_format'
$plantUmlConfigOk = Test-ConfigContains -Content $configRaw -Pattern '^\s*-\s*plantuml_markdown\s*:'

$mdFiles = Get-ChildItem -Path $DocsDir -Recurse -Filter *.md

$mermaidFiles = [System.Collections.Generic.List[string]]::new()
$plantUmlFiles = [System.Collections.Generic.List[string]]::new()

foreach ($file in $mdFiles) {
    $raw = Get-Content -Path $file.FullName -Raw

    if ($raw -match '(?ms)```\s*mermaid\b') {
        $mermaidFiles.Add($file.FullName)
    }

    if (($raw -match '(?ms)```\s*(plantuml|puml|uml)\b') -or ($raw -match '(?ms)^::uml::')) {
        $plantUmlFiles.Add($file.FullName)
    }
}

if (-not $SkipBuild.IsPresent) {
    Write-Host "Build dokumentacji: $ConfigFile"
    & $PythonExe -m mkdocs build -f $ConfigFile | Out-Host
}

if (-not (Test-Path $SiteDir)) {
    throw "Brak katalogu wyjściowego build: $SiteDir"
}

$htmlFiles = Get-HtmlFilesSafe -RootPath $SiteDir
$renderedMermaidBlocks = 0
$rawMermaidBlocks = 0
$rawPlantBlocks = 0
$rawUmlContentBlocks = 0

foreach ($html in $htmlFiles) {
    $htmlRaw = Get-Content -Path $html -Raw

    $renderedMermaidBlocks += ([regex]::Matches($htmlRaw, '<(div|pre)\s+class="mermaid">')).Count
    $rawMermaidBlocks += ([regex]::Matches($htmlRaw, 'language-mermaid')).Count
    $rawPlantBlocks += ([regex]::Matches($htmlRaw, 'language-(plantuml|puml|uml)')).Count
    $rawUmlContentBlocks += ([regex]::Matches($htmlRaw, '@startuml')).Count
}

$plantUmlPkg = "brak"
try {
    $show = & $PythonExe -m pip show plantuml-markdown 2>$null
    if ($LASTEXITCODE -eq 0 -and $show) {
        $versionLine = $show | Where-Object { $_ -like 'Version:*' } | Select-Object -First 1
        if ($versionLine) {
            $plantUmlPkg = $versionLine.Replace('Version:', '').Trim()
        }
        else {
            $plantUmlPkg = "zainstalowany"
        }
    }
}
catch {
    $plantUmlPkg = "nieznany"
}

Write-Host ""
Write-Host "=== Raport diagramow ==="
Write-Host "Konfiguracja Mermaid OK: $mermaidConfigOk"
Write-Host "Konfiguracja PlantUML OK: $plantUmlConfigOk"
Write-Host "Pakiet plantuml-markdown: $plantUmlPkg"
Write-Host "Pliki z Mermaid: $($mermaidFiles.Count)"
Write-Host "Pliki z PlantUML: $($plantUmlFiles.Count)"
Write-Host "Wyrenderowane bloki Mermaid w HTML: $renderedMermaidBlocks"
Write-Host "Niewyrenderowane bloki Mermaid (language-mermaid): $rawMermaidBlocks"
Write-Host "Niewyrenderowane bloki PlantUML (language-plantuml/puml/uml): $rawPlantBlocks"
Write-Host "Niewyrenderowane bloki z @startuml: $rawUmlContentBlocks"

if ($mermaidFiles.Count -gt 0) {
    Write-Host ""
    Write-Host "Pliki Mermaid:"
    $mermaidFiles | ForEach-Object { Write-Host " - $_" }
}

if ($plantUmlFiles.Count -gt 0) {
    Write-Host ""
    Write-Host "Pliki PlantUML:"
    $plantUmlFiles | ForEach-Object { Write-Host " - $_" }
}

if ($rawMermaidBlocks -gt 0 -or $rawPlantBlocks -gt 0 -or $rawUmlContentBlocks -gt 0) {
    Write-Warning "Wykryto surowe bloki diagramow w HTML. Sprawdz konfiguracje lub skladnie blokow w plikach .md."
}
else {
    Write-Host "OK: brak surowych blokow diagramow w wygenerowanym HTML."
}
