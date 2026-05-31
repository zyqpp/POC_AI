param(
    [string]$ProjectRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path,
    [string]$OutFile = ''
)

$routesFile = Join-Path $ProjectRoot 'supply-chain-frontend\src\app\app.routes.ts'
if (-not (Test-Path -LiteralPath $routesFile)) {
    throw "Routes file not found: $routesFile"
}

if ([string]::IsNullOrWhiteSpace($OutFile)) {
    $OutFile = Join-Path $ProjectRoot 'AI_Documentation\10_WARSZTAT_AGENTOW\fakty\angular-routes.json'
}

$lines = Get-Content -LiteralPath $routesFile
$routes = New-Object System.Collections.Generic.List[object]
$current = $null

function Add-CurrentRoute {
    param([object]$Route)
    if ($null -ne $Route) {
        $routes.Add($Route) | Out-Null
    }
}

foreach ($line in $lines) {
    if ($line -match "path:\s*'([^']*)'") {
        Add-CurrentRoute -Route $current
        $current = [ordered]@{
            path = $matches[1]
            component = $null
            importPath = $null
            roles = @()
            canActivate = @()
            source = 'supply-chain-frontend/src/app/app.routes.ts'
        }
    }

    if ($null -eq $current) {
        continue
    }

    if ($line -match "canActivate:\s*\[([^\]]+)\]") {
        $current.canActivate = @(($matches[1] -split ',') | ForEach-Object { $_.Trim() } | Where-Object { $_ })
    }

    if ($line -match "data:\s*\{\s*roles:\s*\[([^\]]*)\]") {
        $current.roles = @([regex]::Matches($matches[1], 'UserRole\.([A-Za-z0-9_]+)') | ForEach-Object { $_.Groups[1].Value })
    }

    if ($line -match "import\('([^']+)'\).*?then\(m\s*=>\s*m\.([A-Za-z0-9_]+)\)") {
        $current.importPath = $matches[1]
        $current.component = $matches[2]
    }
}

Add-CurrentRoute -Route $current

$result = [ordered]@{
    generatedAtUtc = (Get-Date).ToUniversalTime().ToString('o')
    source = $routesFile
    routeCount = $routes.Count
    routes = $routes
}

$outDir = Split-Path -Parent $OutFile
New-Item -ItemType Directory -Force -Path $outDir | Out-Null
$result | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath $OutFile -Encoding UTF8
Write-Host "Wrote $OutFile"
