param(
    [string]$Root = (Resolve-Path -LiteralPath "$PSScriptRoot\..").Path,
    [string]$OutputPath = (Join-Path (Resolve-Path -LiteralPath "$PSScriptRoot\..\AI_Documentation").Path "AI_PROJECT_TREE.md"),
    [switch]$IncludeDependencies,
    [int]$MaxDepth = 0
)

$ErrorActionPreference = "Stop"

$excludeNames = @(
    ".git", ".vs", "bin", "obj", "Debug", "Release", "dist", ".angular",
    ".cache", "coverage", "artifacts"
)

if (-not $IncludeDependencies) {
    $excludeNames += @("node_modules", "packages")
}

function Should-Skip {
    param([System.IO.FileSystemInfo]$Item)
    return $excludeNames -contains $Item.Name
}

function Write-Tree {
    param(
        [string]$Path,
        [string]$Prefix = "",
        [int]$Depth = 0
    )

    if ($MaxDepth -gt 0 -and $Depth -ge $MaxDepth) {
        return @()
    }

    $items = Get-ChildItem -LiteralPath $Path -Force |
        Where-Object { -not (Should-Skip $_) } |
        Sort-Object @{ Expression = { -not $_.PSIsContainer } }, Name

    $lines = @()
    for ($i = 0; $i -lt $items.Count; $i++) {
        $item = $items[$i]
        $isLast = $i -eq ($items.Count - 1)
        $connector = if ($isLast) { "+-- " } else { "|-- " }
        $suffix = if ($item.PSIsContainer) { "/" } else { "" }
        $lines += "$Prefix$connector$($item.Name)$suffix"

        if ($item.PSIsContainer) {
            $nextPrefix = if ($isLast) { "$Prefix    " } else { "$Prefix|   " }
            $lines += Write-Tree -Path $item.FullName -Prefix $nextPrefix -Depth ($Depth + 1)
        }
    }

    return $lines
}

$rootInfo = Get-Item -LiteralPath $Root
$treeLines = @("$($rootInfo.Name)/") + (Write-Tree -Path $rootInfo.FullName)
$generatedAt = (Get-Date).ToUniversalTime().ToString("yyyy-MM-dd HH:mm:ss 'UTC'")
$dependencyNote = if ($IncludeDependencies) {
    "Tryb: z zależnościami."
} else {
    "Tryb: bez zależności i artefaktów build/cache; użyj -IncludeDependencies, gdy potrzebny jest pełny vendor tree."
}

$content = @"
# AI Project Tree

Wygenerowano: $generatedAt

$dependencyNote

~~~text
$($treeLines -join "`r`n")
~~~

"@

$utf8NoBom = New-Object System.Text.UTF8Encoding($false)
[System.IO.File]::WriteAllText($OutputPath, $content, $utf8NoBom)
Write-Host "Wrote $OutputPath"
