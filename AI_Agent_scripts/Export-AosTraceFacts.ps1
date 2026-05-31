param(
    [string]$Root = "",
    [string]$OutputJson = "",
    [string]$OutputMarkdown = "",
    [int]$MaxGapItems = 120
)

$ErrorActionPreference = "Stop"

if ([string]::IsNullOrWhiteSpace($Root)) {
    $Root = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot "..")).Path
}

if ([string]::IsNullOrWhiteSpace($OutputJson)) {
    $OutputJson = Join-Path $Root "AI_Documentation\10_WARSZTAT_AGENTOW\fakty\AI_AOS_TRACE_FACTS.json"
}

if ([string]::IsNullOrWhiteSpace($OutputMarkdown)) {
    $OutputMarkdown = Join-Path $Root "AI_Documentation\10_WARSZTAT_AGENTOW\fakty\AI_AOS_TRACE_REPORT.md"
}

$gitHead = "unknown"
try {
    $gitHead = (& git -C $Root rev-parse --short HEAD 2>$null).Trim()
    if ([string]::IsNullOrWhiteSpace($gitHead)) {
        $gitHead = "unknown"
    }
} catch {
    $gitHead = "unknown"
}

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

function Normalize-Name {
    param([string]$Value)
    return ($Value -replace '[^A-Za-z0-9]', '').ToLowerInvariant()
}

function Split-CSharpParameters {
    param([string]$Text)

    $result = New-Object System.Collections.Generic.List[string]
    $buffer = ""
    $depth = 0

    foreach ($char in $Text.ToCharArray()) {
        if ($char -eq '<' -or $char -eq '(') { $depth++ }
        if ($char -eq '>' -or $char -eq ')') { $depth = [Math]::Max(0, $depth - 1) }

        if ($char -eq ',' -and $depth -eq 0) {
            if (-not [string]::IsNullOrWhiteSpace($buffer)) {
                $result.Add($buffer.Trim())
            }
            $buffer = ""
            continue
        }

        $buffer += $char
    }

    if (-not [string]::IsNullOrWhiteSpace($buffer)) {
        $result.Add($buffer.Trim())
    }

    return $result
}

function Get-FrontendRoutes {
    $path = Join-Path $Root "supply-chain-frontend\src\app\app.routes.ts"
    if (-not (Test-Path -LiteralPath $path)) { return @() }

    $lines = Get-Content -LiteralPath $path
    $routes = New-Object System.Collections.Generic.List[object]

    for ($i = 0; $i -lt $lines.Count; $i++) {
        if ($lines[$i] -match "path:\s*'([^']*)'") {
            $routePath = $Matches[1]
            $window = ($lines[$i..([Math]::Min($lines.Count - 1, $i + 14))] -join "`n")
            $component = ""
            $roles = @()

            if ($window -match "import\('([^']+)'\)") {
                $component = $Matches[1]
            }

            if ($window -match "roles:\s*\[([^\]]+)\]") {
                $roles = @([regex]::Matches($Matches[1], 'UserRole\.([A-Za-z0-9_]+)') | ForEach-Object { $_.Groups[1].Value })
            }

            $routes.Add([pscustomobject]@{
                path = $routePath
                componentImport = $component
                roles = $roles
                file = Convert-ToRelativePath $path
            })
        }
    }

    return $routes
}

function Resolve-AngularUrlExpression {
    param(
        [string]$Expression,
        [hashtable]$Constants
    )

    $value = $Expression.Trim()
    $value = $value -replace '\.pipe\($', ''
    $value = $value -replace '\)\s*;?\s*$', ''
    $value = $value.Trim('"', "'")

    foreach ($key in $Constants.Keys) {
        $constant = [regex]::Escape($key)
        $value = $value -replace "\$\{this\.$constant\}", $Constants[$key]
        $value = $value -replace "this\.$constant", $Constants[$key]
    }

    $value = $value -replace '`', ''
    $value = $value -replace '\$\{[^}]+\}', '{param}'
    $value = $value -replace '\.pipe\($', ''
    $value = $value -replace '\)\s*;?\s*$', ''
    return $value
}

function Get-AngularApis {
    $apiDir = Join-Path $Root "supply-chain-frontend\src\app\core\api"
    if (-not (Test-Path -LiteralPath $apiDir)) { return @() }

    $items = New-Object System.Collections.Generic.List[object]

    Get-ChildItem -LiteralPath $apiDir -Filter "*.ts" | ForEach-Object {
        $filePath = $_.FullName
        $fileRelativePath = Convert-ToRelativePath $filePath
        $lines = Get-Content -LiteralPath $filePath
        $class = ""
        $constants = @{}

        for ($i = 0; $i -lt $lines.Count; $i++) {
            if ($lines[$i] -match "export\s+class\s+([A-Za-z0-9_]+)") {
                $class = $Matches[1]
                $constants = @{}
                continue
            }

            if ($lines[$i] -match "private\s+readonly\s+([A-Za-z0-9_]+)\s*=\s*'([^']+)'") {
                $constants[$Matches[1]] = $Matches[2]
                continue
            }

            $signature = [regex]::Match($lines[$i], "^\s*([A-Za-z0-9_]+)\s*\((.*?)\)\s*:\s*Observable<(.+)>\s*\{")
            if (-not $signature.Success) { continue }

            $windowEnd = [Math]::Min($lines.Count - 1, $i + 14)
            $body = ($lines[$i..$windowEnd] -join "`n")
            $http = [regex]::Match($body, "this\.http\.(get|post|put|delete|patch)(?:<(.+)>)?\(([^,\r\n]+)")
            if (-not $http.Success) { continue }

            $items.Add([pscustomobject]@{
                file = $fileRelativePath
                class = $class
                method = $signature.Groups[1].Value
                parameters = ($signature.Groups[2].Value -replace '\s+', ' ').Trim()
                observableType = ($signature.Groups[3].Value -replace '\s+', ' ').Trim()
                httpMethod = $http.Groups[1].Value.ToUpperInvariant()
                urlExpression = $http.Groups[3].Value.Trim()
                resolvedUrl = Resolve-AngularUrlExpression -Expression $http.Groups[3].Value -Constants $constants
            })
        }
    }

    return $items
}

function Join-Route {
    param([string]$Base, [string]$Child)
    $basePath = ""
    $childPath = ""
    if ($null -ne $Base) { $basePath = $Base.Trim('/') }
    if ($null -ne $Child) { $childPath = $Child.Trim('/') }
    if ([string]::IsNullOrWhiteSpace($childPath)) { return "/$basePath" }
    if ([string]::IsNullOrWhiteSpace($basePath)) { return "/$childPath" }
    return "/$basePath/$childPath"
}

function Get-Controllers {
    $items = New-Object System.Collections.Generic.List[object]

    Get-ChildItem -LiteralPath $Root -Recurse -Filter "*Controller.cs" |
        Where-Object { $_.FullName -notmatch "\\(bin|obj|node_modules)\\" } |
        ForEach-Object {
            $filePath = $_.FullName
            $fileRelativePath = Convert-ToRelativePath $filePath
            $text = Read-Text $filePath
            $classRoute = ""
            $classRoles = @()

            if ($text -match '\[Route\("([^"]+)"\)\]') {
                $classRoute = $Matches[1]
            }

            if ($text -match '\[Authorize\(Roles\s*=\s*"([^"]+)"\)\]') {
                $classRoles = $Matches[1].Split(',') | ForEach-Object { $_.Trim() }
            } elseif ($text -match '\[Authorize\]') {
                $classRoles = @("authenticated")
            }

            $endpointMatches = [regex]::Matches($text, '\[Http(Get|Post|Put|Delete|Patch)(?:\("([^"]*)"\))?\]')
            for ($i = 0; $i -lt $endpointMatches.Count; $i++) {
                $start = $endpointMatches[$i].Index
                $end = if ($i + 1 -lt $endpointMatches.Count) { $endpointMatches[$i + 1].Index } else { $text.Length }
                $segment = $text.Substring($start, $end - $start)

                $roles = $classRoles
                if ($segment -match '\[Authorize\(Roles\s*=\s*"([^"]+)"\)\]') {
                    $roles = $Matches[1].Split(',') | ForEach-Object { $_.Trim() }
                } elseif ($segment -match '\[AllowAnonymous\]') {
                    $roles = @("anonymous")
                }

                $action = ""
                if ($segment -match 'public\s+async\s+Task<[^>]+>\s+([A-Za-z0-9_]+)\s*\(') {
                    $action = $Matches[1]
                } elseif ($segment -match 'public\s+[A-Za-z0-9_<>,\s]+\s+([A-Za-z0-9_]+)\s*\(') {
                    $action = $Matches[1]
                }

                $commands = @([regex]::Matches($segment, 'new\s+([A-Za-z0-9_]+(?:Command|Query))') | ForEach-Object { $_.Groups[1].Value } | Sort-Object -Unique)

                $items.Add([pscustomobject]@{
                    file = $fileRelativePath
                    classRoute = $classRoute
                    action = $action
                    httpMethod = $endpointMatches[$i].Groups[1].Value.ToUpperInvariant()
                    methodPath = $endpointMatches[$i].Groups[2].Value
                    fullPath = Join-Route -Base $classRoute -Child $endpointMatches[$i].Groups[2].Value
                    roles = @($roles)
                    commandsOrQueries = $commands
                })
            }
        }

    return $items
}

function Get-OcelotRoutes {
    $path = Join-Path $Root "gateway\OcelotGateway\ocelot.json"
    if (-not (Test-Path -LiteralPath $path)) { return @() }

    $json = Get-Content -LiteralPath $path -Raw | ConvertFrom-Json
    return @($json.Routes | ForEach-Object {
        [pscustomobject]@{
            key = $_.Key
            upstream = $_.UpstreamPathTemplate
            downstream = $_.DownstreamPathTemplate
            methods = @($_.UpstreamHttpMethod)
            auth = [bool]$_.AuthenticationOptions
        }
    })
}

function Get-TypeScriptDtos {
    $modelDir = Join-Path $Root "supply-chain-frontend\src\app\core\models"
    if (-not (Test-Path -LiteralPath $modelDir)) { return @() }

    $dtos = New-Object System.Collections.Generic.List[object]
    Get-ChildItem -LiteralPath $modelDir -Filter "*.ts" | ForEach-Object {
        $filePath = $_.FullName
        $fileRelativePath = Convert-ToRelativePath $filePath
        $text = Read-Text $filePath
        [regex]::Matches($text, '(?ms)export\s+interface\s+([A-Za-z0-9_]+)\s*\{(.*?)^\}') | ForEach-Object {
            $body = $_.Groups[2].Value
            $fields = @([regex]::Matches($body, '(?m)^\s*([A-Za-z0-9_]+)(\?)?:\s*([^;]+);') | ForEach-Object {
                [pscustomobject]@{
                    name = $_.Groups[1].Value
                    optional = $_.Groups[2].Success
                    type = ($_.Groups[3].Value -replace '\s+', ' ').Trim()
                }
            })

            $dtos.Add([pscustomobject]@{
                file = $fileRelativePath
                name = $_.Groups[1].Value
                fields = $fields
            })
        }
    }

    return $dtos
}

function Get-CSharpDtos {
    $dtos = New-Object System.Collections.Generic.List[object]

    Get-ChildItem -LiteralPath $Root -Recurse -Filter "*Dtos.cs" |
        Where-Object { $_.FullName -notmatch "\\(bin|obj|node_modules)\\" } |
        ForEach-Object {
            $filePath = $_.FullName
            $fileRelativePath = Convert-ToRelativePath $filePath
            $text = Read-Text $filePath
            [regex]::Matches($text, '(?ms)public\s+sealed\s+record\s+([A-Za-z0-9_]+)\s*\((.*?)\);') | ForEach-Object {
                $fields = @(Split-CSharpParameters $_.Groups[2].Value | ForEach-Object {
                    if ($_ -match '(.+?)\s+([A-Za-z0-9_]+)(\s*=.*)?$') {
                        [pscustomobject]@{
                            name = $Matches[2]
                            type = ($Matches[1] -replace '\s+', ' ').Trim()
                        }
                    }
                })

                $dtos.Add([pscustomobject]@{
                    file = $fileRelativePath
                    name = $_.Groups[1].Value
                    fields = $fields
                })
            }
        }

    return $dtos
}

function Get-EntityPropertiesByName {
    $map = @{}
    Get-ChildItem -LiteralPath $Root -Recurse -Filter "*.cs" |
        Where-Object { $_.FullName -notmatch "\\(bin|obj|node_modules|Migrations)\\" } |
        ForEach-Object {
            $filePath = $_.FullName
            $fileRelativePath = Convert-ToRelativePath $filePath
            $text = Read-Text $filePath
            [regex]::Matches($text, '(?ms)public\s+sealed\s+class\s+([A-Za-z0-9_]+).*?\{(.*)\}\s*$') | ForEach-Object {
                $className = $_.Groups[1].Value
                $body = $_.Groups[2].Value
                $props = @([regex]::Matches($body, '(?m)^\s*public\s+([A-Za-z0-9_<>,\?\.\[\]\s]+)\s+([A-Za-z0-9_]+)\s*\{\s*get;') | ForEach-Object {
                    $type = ($_.Groups[1].Value -replace '\s+', ' ').Trim()
                    $name = $_.Groups[2].Value
                    if ($type -notmatch '^(ICollection|IReadOnlyCollection|List|HashSet|IEnumerable)<') {
                        [pscustomobject]@{ name = $name; type = $type }
                    }
                })
                if ($props.Count -gt 0) {
                    $map[$className] = [pscustomobject]@{
                        file = $fileRelativePath
                        properties = $props
                    }
                }
            }
        }
    return $map
}

function Get-EfModel {
    $entityMap = Get-EntityPropertiesByName
    $tables = New-Object System.Collections.Generic.List[object]

    Get-ChildItem -LiteralPath $Root -Recurse -Filter "*DbContext.cs" |
        Where-Object { $_.FullName -notmatch "\\(bin|obj|node_modules)\\" } |
        ForEach-Object {
            $filePath = $_.FullName
            $fileRelativePath = Convert-ToRelativePath $filePath
            $text = Read-Text $filePath
            [regex]::Matches($text, '(?ms)modelBuilder\.Entity<([A-Za-z0-9_]+)>\(builder\s*=>\s*\{(.*?)\n\s*\}\);') | ForEach-Object {
                $entity = $_.Groups[1].Value
                $body = $_.Groups[2].Value
                $table = $entity
                if ($body -match 'ToTable\("([^"]+)"\)') {
                    $table = $Matches[1]
                }

                $ignored = @([regex]::Matches($body, 'Ignore\(x\s*=>\s*x\.([A-Za-z0-9_]+)\)') | ForEach-Object { $_.Groups[1].Value })
                $configured = @([regex]::Matches($body, 'Property\(x\s*=>\s*x\.([A-Za-z0-9_]+)\)') | ForEach-Object { $_.Groups[1].Value })
                $properties = @()
                if ($entityMap.ContainsKey($entity)) {
                    $properties = @($entityMap[$entity].properties | Where-Object { $ignored -notcontains $_.name })
                }

                $tables.Add([pscustomobject]@{
                    dbContext = $fileRelativePath
                    entity = $entity
                    entityFile = if ($entityMap.ContainsKey($entity)) { $entityMap[$entity].file } else { "" }
                    table = $table
                    columns = @($properties | ForEach-Object { $_.name })
                    configuredProperties = $configured
                    ignoredProperties = $ignored
                })
            }
        }

    return $tables
}

function Get-AngularUiFields {
    $featureDir = Join-Path $Root "supply-chain-frontend\src\app\features"
    if (-not (Test-Path -LiteralPath $featureDir)) { return @() }

    $items = New-Object System.Collections.Generic.List[object]
    Get-ChildItem -LiteralPath $featureDir -Recurse -Filter "*.component.html" |
        Where-Object { $_.FullName -notmatch "\\node_modules\\" } |
        ForEach-Object {
            $filePath = $_.FullName
            $fileRelativePath = Convert-ToRelativePath $filePath
            $text = Read-Text $filePath

            $fieldMatches = @()
            $fieldMatches += [regex]::Matches($text, 'formControlName\s*=\s*"([^"]+)"')
            $fieldMatches += [regex]::Matches($text, '\[\(ngModel\)\]\s*=\s*"([^"]+)"')
            $fieldMatches += [regex]::Matches($text, '\bname\s*=\s*"([^"]+)"')

            foreach ($match in $fieldMatches) {
                $name = $match.Groups[1].Value
                if ([string]::IsNullOrWhiteSpace($name)) { continue }
                if ($name -match '[\.\(\)\[\]]') { continue }

                $items.Add([pscustomobject]@{
                    file = $fileRelativePath
                    name = $name
                })
            }
        }

    return @($items | Sort-Object file, name -Unique)
}

function Get-TestCorpus {
    $parts = New-Object System.Collections.Generic.List[string]
    Get-ChildItem -LiteralPath $Root -Recurse -File |
        Where-Object {
            $_.FullName -notmatch "\\(bin|obj|node_modules|dist|coverage)\\" -and
            ($_.FullName -match "\\tests\\" -or $_.Name -match '\.(spec|test)\.(ts|js|cs)$' -or $_.FullName -match "\.Tests\\") -and
            $_.Extension -in @(".cs", ".ts", ".js")
        } |
        ForEach-Object {
            $parts.Add((Read-Text $_.FullName).ToLowerInvariant())
        }

    return ($parts -join "`n")
}

function Get-HandlerIndex {
    $handlers = @{}
    Get-ChildItem -LiteralPath $Root -Recurse -Filter "*.cs" |
        Where-Object { $_.FullName -match "\.Application\\Features\\" -and $_.FullName -notmatch "\\(bin|obj)\\" } |
        ForEach-Object {
            $filePath = $_.FullName
            $fileRelativePath = Convert-ToRelativePath $filePath
            $text = Read-Text $filePath

            $services = @([regex]::Matches($text, '\b([A-Za-z0-9_]+Service)\b') | ForEach-Object { $_.Groups[1].Value } | Sort-Object -Unique)
            $handlerMatches = [regex]::Matches($text, '(?ms)class\s+([A-Za-z0-9_]+Handler)\b.*?IRequestHandler<\s*([A-Za-z0-9_]+)')

            foreach ($match in $handlerMatches) {
                $className = $match.Groups[1].Value
                $request = $match.Groups[2].Value
                $handlers[$request] = [pscustomobject]@{
                    file = $fileRelativePath
                    class = $className
                    services = $services
                }
            }
        }

    return $handlers
}

function Get-DiffDtos {
    param($TsDtos, $CsDtos)

    $csByName = @{}
    foreach ($dto in $CsDtos) { $csByName[$dto.name] = $dto }

    $diffs = New-Object System.Collections.Generic.List[object]
    foreach ($ts in $TsDtos) {
        if (-not $csByName.ContainsKey($ts.name)) { continue }
        $cs = $csByName[$ts.name]
        $tsNames = @($ts.fields | ForEach-Object { Normalize-Name $_.name })
        $csNames = @($cs.fields | ForEach-Object { Normalize-Name $_.name })

        $missingInTs = @($cs.fields | Where-Object { $tsNames -notcontains (Normalize-Name $_.name) } | ForEach-Object { $_.name })
        $missingInCs = @($ts.fields | Where-Object { $csNames -notcontains (Normalize-Name $_.name) } | ForEach-Object { $_.name })

        if ($missingInTs.Count -gt 0 -or $missingInCs.Count -gt 0) {
            $diffs.Add([pscustomobject]@{
                dto = $ts.name
                tsFile = $ts.file
                csFile = $cs.file
                missingInTypeScript = $missingInTs
                missingInCSharp = $missingInCs
            })
        }
    }

    return $diffs
}

function Convert-PathTemplateToRegex {
    param([string]$Path)

    $escaped = [regex]::Escape($Path)
    $escaped = $escaped -replace '\\\{[^}]+\\\}', '[^/]+'
    $escaped = $escaped -replace '\\\{[^}]+\}', '[^/]+'
    return '^' + $escaped + '$'
}

function Find-ControllerForAngularApi {
    param($Api, $Controllers)

    $url = $Api.resolvedUrl
    $downstream = $url
    if ($downstream -match '^/(identity|catalog|orders|logistics|payments|notifications)/(.*)$') {
        $downstream = "/" + $Matches[2]
    }

    foreach ($controller in $Controllers) {
        $controllerPath = $controller.fullPath
        $controllerPattern = Convert-PathTemplateToRegex $controllerPath
        if ($controller.httpMethod -eq $Api.httpMethod -and $downstream -match $controllerPattern) {
            return $controller
        }
    }

    foreach ($controller in $Controllers) {
        if ($controller.httpMethod -eq $Api.httpMethod -and $downstream.StartsWith($controller.classRoute.TrimStart('/'))) {
            return $controller
        }
    }

    return $null
}

function Get-Gaps {
    param($Routes, $AngularApis, $Controllers, $DtoDiffs, $EfTables, $TypeScriptDtos, $CSharpDtos, $UiFields, $TestCorpus)

    $gaps = New-Object System.Collections.Generic.List[object]
    $columns = @($EfTables | ForEach-Object { $_.columns } | ForEach-Object { Normalize-Name $_ }) | Sort-Object -Unique
    $entitiesAndTables = @($EfTables | ForEach-Object { $_.entity; $_.table } | ForEach-Object { Normalize-Name $_ }) | Sort-Object -Unique
    $dtoFields = @($TypeScriptDtos + $CSharpDtos | ForEach-Object { $_.fields } | ForEach-Object { Normalize-Name $_.name }) | Sort-Object -Unique

    foreach ($route in $Routes | Where-Object { $_.path -and $_.roles.Count -eq 0 -and $_.path -notin @("login", "register", "forgot-password", "unauthorized", "", "**") }) {
        $gaps.Add([pscustomobject]@{
            type = "route-without-explicit-role"
            severity = "review"
            item = $route.path
            evidence = $route.file
        })
    }

    foreach ($field in $UiFields) {
        $normalizedField = Normalize-Name $field.name
        if ($dtoFields -notcontains $normalizedField -and $columns -notcontains $normalizedField) {
            $gaps.Add([pscustomobject]@{
                type = "ui-field-without-obvious-data-lineage"
                severity = "review"
                item = $field.name
                evidence = $field.file
            })
        }
    }

    foreach ($diff in $DtoDiffs) {
        $gaps.Add([pscustomobject]@{
            type = "dto-field-mismatch-ts-csharp"
            severity = "medium"
            item = $diff.dto
            evidence = "missing TS: $($diff.missingInTypeScript -join ', '); missing C#: $($diff.missingInCSharp -join ', ')"
        })
    }

    foreach ($dto in @($TypeScriptDtos + $CSharpDtos)) {
        $baseName = $dto.name -replace '(Dto|Request|Response|Command|Query|ListItem|Summary|Detail|Result)$', ''
        $normalizedDto = Normalize-Name $baseName
        if ([string]::IsNullOrWhiteSpace($normalizedDto)) { continue }

        $hasTable = $false
        foreach ($entity in $entitiesAndTables) {
            if ($entity -eq $normalizedDto -or $entity.Contains($normalizedDto) -or $normalizedDto.Contains($entity)) {
                $hasTable = $true
                break
            }
        }

        if (-not $hasTable -and $dto.name -match '(Dto|Request|Response)$') {
            $gaps.Add([pscustomobject]@{
                type = "dto-without-obvious-sql-table"
                severity = "review"
                item = $dto.name
                evidence = $dto.file
            })
        }
    }

    foreach ($controller in $Controllers) {
        $actionNeedle = $controller.action.ToLowerInvariant()
        $pathNeedle = ($controller.fullPath -replace '\{[^}]+\}', '').ToLowerInvariant()
        if (-not [string]::IsNullOrWhiteSpace($actionNeedle) -and -not $TestCorpus.Contains($actionNeedle) -and -not $TestCorpus.Contains($pathNeedle)) {
            $gaps.Add([pscustomobject]@{
                type = "api-without-obvious-test"
                severity = "review"
                item = "$($controller.httpMethod) $($controller.fullPath)"
                evidence = $controller.file
            })
        }
    }

    foreach ($api in $AngularApis) {
        $match = Find-ControllerForAngularApi -Api $api -Controllers $Controllers
        if ($null -eq $match) {
            $gaps.Add([pscustomobject]@{
                type = "frontend-api-without-controller-match"
                severity = "review"
                item = "$($api.httpMethod) $($api.resolvedUrl)"
                evidence = $api.file
            })
        }
    }

    foreach ($api in $AngularApis | Where-Object { $_.observableType -match 'Request|Dto|Response' }) {
        $candidate = $api.observableType -replace '\[\]', ''
        if ($candidate -match 'PagedResult<([^>]+)>') { $candidate = $Matches[1] }
        if ($columns -notcontains (Normalize-Name $candidate)) {
            $gaps.Add([pscustomobject]@{
                type = "api-contract-needs-data-lineage-review"
                severity = "review"
                item = "$($api.class).$($api.method) -> $($api.observableType)"
                evidence = $api.file
            })
        }
    }

    return @($gaps | Select-Object -First $MaxGapItems)
}

function New-TraceMatrix {
    param($AngularApis, $Controllers, $EfTables, $HandlerIndex)

    $matrix = New-Object System.Collections.Generic.List[object]
    foreach ($api in $AngularApis) {
        $controller = Find-ControllerForAngularApi -Api $api -Controllers $Controllers
        $serviceArea = if ($api.resolvedUrl -match '^/([^/]+)/') { $Matches[1] } else { "" }
        $candidateEfTables = @($EfTables | Where-Object { $_.dbContext -match $serviceArea -or $_.dbContext -match ($serviceArea.TrimEnd('s')) })
        $tables = @($candidateEfTables | Select-Object -ExpandProperty table -Unique)
        $entities = @($candidateEfTables | Select-Object -ExpandProperty entity -Unique)
        $commands = if ($null -ne $controller) { @($controller.commandsOrQueries) } else { @() }
        $handlers = New-Object System.Collections.Generic.List[string]
        $services = New-Object System.Collections.Generic.List[string]

        foreach ($command in $commands) {
            if ($HandlerIndex.ContainsKey($command)) {
                $handler = $HandlerIndex[$command]
                if (-not [string]::IsNullOrWhiteSpace($handler.class)) {
                    $handlers.Add("$($handler.class) ($($handler.file))")
                } else {
                    $handlers.Add($handler.file)
                }

                foreach ($service in $handler.services) {
                    if (-not $services.Contains($service)) {
                        $services.Add($service)
                    }
                }
            }
        }

        $matrix.Add([pscustomobject]@{
            frontend = "$($api.class).$($api.method)"
            http = "$($api.httpMethod) $($api.resolvedUrl)"
            controller = if ($null -ne $controller) { "$($controller.action) ($($controller.file))" } else { "NO MATCH" }
            commandsOrQueries = $commands
            handlers = @($handlers)
            services = @($services)
            candidateEntities = $entities
            candidateSqlTables = $tables
        })
    }
    return $matrix
}

$routes = Get-FrontendRoutes
$angularApis = Get-AngularApis
$controllers = Get-Controllers
$ocelot = Get-OcelotRoutes
$tsDtos = Get-TypeScriptDtos
$csDtos = Get-CSharpDtos
$dtoDiffs = Get-DiffDtos -TsDtos $tsDtos -CsDtos $csDtos
$efTables = Get-EfModel
$uiFields = Get-AngularUiFields
$testCorpus = Get-TestCorpus
$handlerIndex = Get-HandlerIndex
$gaps = Get-Gaps -Routes $routes -AngularApis $angularApis -Controllers $controllers -DtoDiffs $dtoDiffs -EfTables $efTables -TypeScriptDtos $tsDtos -CSharpDtos $csDtos -UiFields $uiFields -TestCorpus $testCorpus
$matrix = New-TraceMatrix -AngularApis $angularApis -Controllers $controllers -EfTables $efTables -HandlerIndex $handlerIndex

$facts = [pscustomobject]@{
    generatedAtUtc = (Get-Date).ToUniversalTime().ToString("o")
    scriptName = "Export-AosTraceFacts.ps1"
    scriptVersion = "podejscie_2_trace_v2"
    gitHead = $gitHead
    generatorLimitations = @(
        "Parser statyczny używa heurystyk i wyrażeń regularnych.",
        "Wyniki trace są punktem startowym i wymagają potwierdzenia w kodzie.",
        "Relacje między mikroserwisami są oznaczane jako kandydackie, jeśli brak fizycznego FK w tej samej bazie."
    )
    routes = $routes
    angularApis = $angularApis
    ocelotRoutes = $ocelot
    controllers = $controllers
    typeScriptDtos = $tsDtos
    cSharpDtos = $csDtos
    dtoDiffs = $dtoDiffs
    efTables = $efTables
    uiFields = $uiFields
    handlers = $handlerIndex
    gaps = $gaps
    traceMatrix = $matrix
}

$utf8NoBom = New-Object System.Text.UTF8Encoding($false)
$jsonText = $facts | ConvertTo-Json -Depth 20
[System.IO.File]::WriteAllText($OutputJson, $jsonText, $utf8NoBom)

$report = New-Object System.Collections.Generic.List[string]
$report.Add("# AI AOS Trace Report")
$report.Add("")
$report.Add("Wygenerowano: $((Get-Date).ToUniversalTime().ToString("yyyy-MM-dd HH:mm:ss 'UTC'"))")
$report.Add(("Git HEAD: {0}" -f $gitHead))
$report.Add("Generator: Export-AosTraceFacts.ps1 (podejscie_2_trace_v2)")
$report.Add("")
$report.Add("Raport jest materiałem pomocniczym dla AOS. Wyniki automatyczne trzeba potwierdzić w kodzie przed wpisaniem ich jako fakt.")
$report.Add("")
$report.Add("Ograniczenia: parser statyczny używa heurystyk; relacje kandydackie i dopasowania UI/API wymagają potwierdzenia w kodzie.")
$report.Add("")
$report.Add("## Podsumowanie")
$report.Add("")
$report.Add("| Obszar | Liczba |")
$report.Add("|---|---:|")
$report.Add("| Frontend routes | $($routes.Count) |")
$report.Add("| Angular API methods | $($angularApis.Count) |")
$report.Add("| Ocelot routes | $($ocelot.Count) |")
$report.Add("| Controller endpoints | $($controllers.Count) |")
$report.Add("| TypeScript DTO/interfaces | $($tsDtos.Count) |")
$report.Add("| C# DTO records | $($csDtos.Count) |")
$report.Add("| EF SQL tables | $($efTables.Count) |")
$report.Add("| UI fields | $($uiFields.Count) |")
$report.Add("| Handler index entries | $($handlerIndex.Count) |")
$report.Add("| Potential gaps | $($gaps.Count) |")
$report.Add("")
$report.Add("## Macierz UI -> API -> Handler -> Service -> Entity -> SQL")
$report.Add("")
$report.Add("| Frontend | HTTP | Controller | Command/Query | Handler | Service | Encje kandydackie | Tabele SQL kandydackie |")
$report.Add("|---|---|---|---|---|---|---|---|")
foreach ($row in $matrix | Select-Object -First 80) {
    $report.Add(('| `{0}` | `{1}` | `{2}` | `{3}` | `{4}` | `{5}` | `{6}` | `{7}` |' -f $row.frontend, $row.http, $row.controller, ($row.commandsOrQueries -join ', '), ($row.handlers -join ', '), ($row.services -join ', '), ($row.candidateEntities -join ', '), ($row.candidateSqlTables -join ', ')))
}
$report.Add("")
$report.Add("## Różnice DTO TypeScript / C#")
$report.Add("")
if ($dtoDiffs.Count -eq 0) {
    $report.Add("Nie wykryto różnic nazw pól dla DTO o tych samych nazwach.")
} else {
    $report.Add("| DTO | Brak w TS | Brak w C# | Pliki |")
    $report.Add("|---|---|---|---|")
    foreach ($diff in $dtoDiffs | Select-Object -First 80) {
        $report.Add(('| `{0}` | `{1}` | `{2}` | `{3}` / `{4}` |' -f $diff.dto, ($diff.missingInTypeScript -join ', '), ($diff.missingInCSharp -join ', '), $diff.tsFile, $diff.csFile))
    }
}
$report.Add("")
$report.Add("## Tabele I Kolumny SQL Z EF")
$report.Add("")
$report.Add("| DbContext | Encja | Tabela SQL | Kolumny SQL / właściwości mapowane | Ignorowane |")
$report.Add("|---|---|---|---|---|")
foreach ($table in $efTables | Sort-Object dbContext, table) {
    $report.Add(('| `{0}` | `{1}` | `{2}` | `{3}` | `{4}` |' -f $table.dbContext, $table.entity, $table.table, ($table.columns -join ', '), ($table.ignoredProperties -join ', ')))
}
$report.Add("")
$report.Add("## Raport Luk Do Review")
$report.Add("")
if ($gaps.Count -eq 0) {
    $report.Add("Brak automatycznie wykrytych luk.")
} else {
    $report.Add("| Typ | Priorytet | Element | Dowód |")
    $report.Add("|---|---|---|---|")
    foreach ($gap in $gaps) {
        $report.Add(('| `{0}` | `{1}` | `{2}` | `{3}` |' -f $gap.type, $gap.severity, $gap.item, $gap.evidence))
    }
}
$report.Add("")
$report.Add("## Jak Używać")
$report.Add("")
$report.Add("1. Wybierz ekran albo proces.")
$report.Add("2. Znajdź route i komponent w sekcji routes/API.")
$report.Add("3. Przejdź po macierzy do controller/command/query.")
$report.Add('4. Potwierdź dane w `DbContext`, encjach i migracjach.')
$report.Add("5. Dopiero wtedy wpisz fakt do AOS.")

[System.IO.File]::WriteAllText($OutputMarkdown, ($report -join "`r`n"), $utf8NoBom)

Write-Host "Wrote $OutputJson"
Write-Host "Wrote $OutputMarkdown"
