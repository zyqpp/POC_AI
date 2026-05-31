param(
    [string]$ProjectRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path,
    [string]$OutFile = ''
)

if ([string]::IsNullOrWhiteSpace($OutFile)) {
    $OutFile = Join-Path $ProjectRoot 'AI_Documentation\10_WARSZTAT_AGENTOW\fakty\dotnet-api.json'
}

$controllerFiles = Get-ChildItem -LiteralPath (Join-Path $ProjectRoot 'services') -Recurse -Filter '*Controller.cs'
$controllers = New-Object System.Collections.Generic.List[object]

foreach ($file in $controllerFiles) {
    $lines = Get-Content -LiteralPath $file.FullName
    $relative = $file.FullName.Substring($ProjectRoot.Length + 1).Replace('\', '/')
    $baseRoute = $null
    $className = $null
    $classAuthorize = @()
    $pendingHttp = $null
    $pendingAuthorize = @()
    $endpoints = New-Object System.Collections.Generic.List[object]

    foreach ($line in $lines) {
        if ($line -match '\[Route\("([^"]+)"\)\]') {
            if ($null -eq $className) {
                $baseRoute = $matches[1]
            }
        }

        if ($line -match '\[Authorize(?:\(Roles\s*=\s*"([^"]*)"\))?\]') {
            $roles = @()
            if ($matches[1]) {
                $roles = @(($matches[1] -split ',') | ForEach-Object { $_.Trim() } | Where-Object { $_ })
            } else {
                $roles = @('Authenticated')
            }
            if ($null -eq $className -and $null -eq $pendingHttp) {
                $classAuthorize = $roles
            } else {
                $pendingAuthorize = $roles
            }
        }

        if ($line -match 'public\s+(?:sealed\s+)?class\s+([A-Za-z0-9_]+)') {
            $className = $matches[1]
        }

        if ($line -match '\[Http(Get|Post|Put|Delete|Patch)(?:\("([^"]*)"\))?\]') {
            $pendingHttp = [ordered]@{
                method = $matches[1].ToUpperInvariant()
                route = if ($matches[2]) { $matches[2] } else { '' }
            }
            $pendingAuthorize = @()
        }

        if ($pendingHttp -ne $null -and $line -match 'public\s+(?:async\s+)?(?:Task<)?IActionResult') {
            $roles = if ($pendingAuthorize.Count -gt 0) { $pendingAuthorize } elseif ($classAuthorize.Count -gt 0) { $classAuthorize } else { @('PublicOrCustom') }
            $endpoint = [ordered]@{
                method = $pendingHttp.method
                route = $pendingHttp.route
                fullRoute = (($baseRoute, $pendingHttp.route) | Where-Object { $_ -ne '' }) -join '/'
                roles = @($roles)
                source = $relative
            }
            $endpoints.Add($endpoint) | Out-Null
            $pendingHttp = $null
            $pendingAuthorize = @()
        }
    }

    $controllers.Add([ordered]@{
        controller = $className
        baseRoute = $baseRoute
        classRoles = $classAuthorize
        source = $relative
        endpoints = $endpoints
    }) | Out-Null
}

$result = [ordered]@{
    generatedAtUtc = (Get-Date).ToUniversalTime().ToString('o')
    controllerCount = $controllers.Count
    controllers = $controllers
}

$outDir = Split-Path -Parent $OutFile
New-Item -ItemType Directory -Force -Path $outDir | Out-Null
$result | ConvertTo-Json -Depth 10 | Set-Content -LiteralPath $OutFile -Encoding UTF8
Write-Host "Wrote $OutFile"
