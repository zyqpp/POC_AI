[CmdletBinding()]
param(
    [string]$DocsDir = "AI_Documentation",
    [string]$FoldersOutput = "AI_Documentation/NAV_FOLDER_TREE.md",
    [string]$FilesOutput = "AI_Documentation/NAV_FILES_BY_FOLDER.md"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Write-Utf8BomFile {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Path,
        [Parameter(Mandatory = $true)]
        [string]$Content
    )

    $encoding = [System.Text.UTF8Encoding]::new($true)
    [System.IO.File]::WriteAllText((Resolve-Path (Split-Path -Parent $Path)).Path + [System.IO.Path]::DirectorySeparatorChar + (Split-Path -Leaf $Path), $Content, $encoding)
}

if (-not (Test-Path $DocsDir)) {
    throw "Brak katalogu dokumentacji: $DocsDir"
}

$docsRoot = (Resolve-Path $DocsDir).Path

$skipDirs = @("assets", "_archive", "AOS_Template", "templates")
$skipPathPatterns = @(
    '\\_archive\\',
    '\\AOS_Template\\',
    '\\10_WARSZTAT_AGENTOW\\templates\\'
)

function Get-RelPath([string]$fullPath) {
    $rel = $fullPath.Substring($docsRoot.Length).TrimStart('\\')
    return $rel -replace '\\', '/'
}

function Test-IsSkippedPath {
    param([string]$FullPath)

    foreach ($pattern in $skipPathPatterns) {
        if ($FullPath -match $pattern) {
            return $true
        }
    }

    return $false
}

$allDirs = Get-ChildItem -Path $DocsDir -Recurse -Directory |
    Where-Object { $skipDirs -notcontains $_.Name -and -not (Test-IsSkippedPath -FullPath $_.FullName) } |
    Sort-Object FullName

$folderSb = [System.Text.StringBuilder]::new()
[void]$folderSb.AppendLine("# Drzewo katalogów")
[void]$folderSb.AppendLine("")
[void]$folderSb.AppendLine("Automatycznie wygenerowany widok folderów i podfolderów dokumentacji technicznej.")
[void]$folderSb.AppendLine("")
[void]$folderSb.AppendLine("- ./")

foreach ($dir in $allDirs) {
    $rel = Get-RelPath -fullPath $dir.FullName
    $depth = ($rel.Split('/').Count)
    $indent = ('  ' * $depth)
    $folderLine = $indent + '- ' + $rel + '/'
    [void]$folderSb.AppendLine($folderLine)
}

$filesSb = [System.Text.StringBuilder]::new()
[void]$filesSb.AppendLine("# Pliki w katalogach")
[void]$filesSb.AppendLine("")
[void]$filesSb.AppendLine("Automatycznie wygenerowana lista plików Markdown pogrupowana według katalogów.")

$rootFiles = @(Get-ChildItem -Path $DocsDir -File -Filter *.md | Sort-Object Name)
if ($rootFiles.Count -gt 0) {
    [void]$filesSb.AppendLine("")
    [void]$filesSb.AppendLine("## /")
    foreach ($file in $rootFiles) {
        $relFile = Get-RelPath -fullPath $file.FullName
        [void]$filesSb.AppendLine("- [$($file.Name)]($relFile)")
    }
}

$dirsForFiles = Get-ChildItem -Path $DocsDir -Recurse -Directory |
    Where-Object { $skipDirs -notcontains $_.Name -and -not (Test-IsSkippedPath -FullPath $_.FullName) } |
    Sort-Object FullName

foreach ($dir in $dirsForFiles) {
    $files = @(Get-ChildItem -Path $dir.FullName -File -Filter *.md | Sort-Object Name)
    if ($files.Count -eq 0) {
        continue
    }

    $relDir = Get-RelPath -fullPath $dir.FullName
    [void]$filesSb.AppendLine("")
    [void]$filesSb.AppendLine("## /$relDir/")

    foreach ($file in $files) {
        $relFile = Get-RelPath -fullPath $file.FullName
        [void]$filesSb.AppendLine("- [$($file.Name)]($relFile)")
    }
}

Write-Utf8BomFile -Path $FoldersOutput -Content $folderSb.ToString()
Write-Utf8BomFile -Path $FilesOutput -Content $filesSb.ToString()

Write-Host "Wygenerowano:"
Write-Host " - $FoldersOutput"
Write-Host " - $FilesOutput"
