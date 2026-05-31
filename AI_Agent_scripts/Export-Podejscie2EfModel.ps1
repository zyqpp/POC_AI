param(
    [string]$ProjectRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path,
    [string]$OutFile = ''
)

if ([string]::IsNullOrWhiteSpace($OutFile)) {
    $OutFile = Join-Path $ProjectRoot 'AI_Documentation\10_WARSZTAT_AGENTOW\fakty\ef-model.json'
}

$contextFiles = Get-ChildItem -LiteralPath (Join-Path $ProjectRoot 'services') -Recurse -Filter '*DbContext.cs'
$contexts = New-Object System.Collections.Generic.List[object]

foreach ($file in $contextFiles) {
    $content = Get-Content -LiteralPath $file.FullName -Raw
    $relative = $file.FullName.Substring($ProjectRoot.Length + 1).Replace('\', '/')
    $contextName = if ($content -match 'class\s+([A-Za-z0-9_]*DbContext)') { $matches[1] } else { $file.BaseName }

    $dbSets = @()
    foreach ($match in [regex]::Matches($content, 'DbSet<([A-Za-z0-9_]+)>\s+([A-Za-z0-9_]+)')) {
        $dbSets += [ordered]@{
            entity = $match.Groups[1].Value
            dbSet = $match.Groups[2].Value
        }
    }

    $tables = @()
    foreach ($match in [regex]::Matches($content, 'ToTable\("([^"]+)"\)')) {
        $tables += $match.Groups[1].Value
    }

    $indexes = @()
    foreach ($match in [regex]::Matches($content, 'HasIndex\(([^\)]*)\)(\.IsUnique\(\))?')) {
        $indexes += [ordered]@{
            expression = $match.Groups[1].Value.Trim()
            isUnique = -not [string]::IsNullOrWhiteSpace($match.Groups[2].Value)
        }
    }

    $contexts.Add([ordered]@{
        dbContext = $contextName
        source = $relative
        dbSets = $dbSets
        tables = $tables
        indexes = $indexes
    }) | Out-Null
}

$result = [ordered]@{
    generatedAtUtc = (Get-Date).ToUniversalTime().ToString('o')
    dbContextCount = $contexts.Count
    contexts = $contexts
}

$outDir = Split-Path -Parent $OutFile
New-Item -ItemType Directory -Force -Path $outDir | Out-Null
$result | ConvertTo-Json -Depth 10 | Set-Content -LiteralPath $OutFile -Encoding UTF8
Write-Host "Wrote $OutFile"

