param(
    [string]$Root = (Resolve-Path -LiteralPath "$PSScriptRoot\..").Path,
    [string]$OutputPath = (Join-Path (Resolve-Path -LiteralPath "$PSScriptRoot\..\AI_Documentation").Path "AI_CODE_FACTS.json")
)

$ErrorActionPreference = "Stop"

function Convert-ToRelativePath {
    param([string]$Path)
    $rootPath = [System.IO.Path]::GetFullPath($Root).TrimEnd('\') + '\'
    $targetPath = [System.IO.Path]::GetFullPath($Path)
    $rootUri = New-Object System.Uri($rootPath)
    $targetUri = New-Object System.Uri($targetPath)
    return [System.Uri]::UnescapeDataString($rootUri.MakeRelativeUri($targetUri).ToString()).Replace('\', '/')
}

function Read-Text {
    param([string]$Path)
    return Get-Content -LiteralPath $Path -Raw
}

$controllers = Get-ChildItem -LiteralPath $Root -Recurse -Filter "*Controller.cs" |
    Where-Object { $_.FullName -notmatch "\\(bin|obj|node_modules)\\" } |
    ForEach-Object {
        $text = Read-Text $_.FullName
        $route = [regex]::Match($text, '\[Route\("([^"]+)"\)\]').Groups[1].Value
        $methods = [regex]::Matches($text, '\[Http(Get|Post|Put|Delete|Patch)(?:\("([^"]*)"\))?\]') |
            ForEach-Object {
                [pscustomobject]@{
                    method = $_.Groups[1].Value.ToUpperInvariant()
                    path = $_.Groups[2].Value
                }
            }

        [pscustomobject]@{
            file = Convert-ToRelativePath $_.FullName
            route = $route
            methods = $methods
        }
    }

$dtos = Get-ChildItem -LiteralPath $Root -Recurse -Filter "*Dtos.cs" |
    Where-Object { $_.FullName -notmatch "\\(bin|obj|node_modules)\\" } |
    ForEach-Object {
        $text = Read-Text $_.FullName
        [pscustomobject]@{
            file = Convert-ToRelativePath $_.FullName
            records = @([regex]::Matches($text, 'public\s+sealed\s+record\s+([A-Za-z0-9_]+)') | ForEach-Object { $_.Groups[1].Value })
        }
    }

$dbContexts = Get-ChildItem -LiteralPath $Root -Recurse -Filter "*DbContext.cs" |
    Where-Object { $_.FullName -notmatch "\\(bin|obj|node_modules)\\" } |
    ForEach-Object {
        $text = Read-Text $_.FullName
        [pscustomobject]@{
            file = Convert-ToRelativePath $_.FullName
            dbSets = @([regex]::Matches($text, 'DbSet<([^>]+)>\s+([A-Za-z0-9_]+)') | ForEach-Object {
                [pscustomobject]@{
                    entity = $_.Groups[1].Value
                    property = $_.Groups[2].Value
                }
            })
            tables = @([regex]::Matches($text, 'ToTable\("([^"]+)"\)') | ForEach-Object { $_.Groups[1].Value } | Sort-Object -Unique)
        }
    }

$frontendApis = Get-ChildItem -LiteralPath (Join-Path $Root "supply-chain-frontend/src/app/core/api") -Filter "*.ts" |
    ForEach-Object {
        $text = Read-Text $_.FullName
        [pscustomobject]@{
            file = Convert-ToRelativePath $_.FullName
            paths = @([regex]::Matches($text, "['""](/[^'""]+)['""]") | ForEach-Object { $_.Groups[1].Value } | Sort-Object -Unique)
        }
    }

$facts = [pscustomobject]@{
    generatedAtUtc = (Get-Date).ToUniversalTime().ToString("o")
    controllers = $controllers
    dtos = $dtos
    dbContexts = $dbContexts
    frontendApis = $frontendApis
}

$facts | ConvertTo-Json -Depth 12 | Set-Content -LiteralPath $OutputPath -Encoding UTF8
Write-Host "Wrote $OutputPath"
