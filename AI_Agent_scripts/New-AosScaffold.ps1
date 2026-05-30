param(
    [Parameter(Mandatory = $true)]
    [string]$Module,

    [Parameter(Mandatory = $true)]
    [string]$FeatureId,

    [string]$Title = "",
    [string]$Route = "",
    [string]$ComponentPath = "",
    [string]$ApiPath = "",
    [string]$Root = "",
    [string]$OutputRoot = "",
    [string]$TemplateDir = "",
    [switch]$DryRun
)

$ErrorActionPreference = "Stop"

if ([string]::IsNullOrWhiteSpace($Root)) {
    $Root = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot "..")).Path
}

if ([string]::IsNullOrWhiteSpace($OutputRoot)) {
    $OutputRoot = Join-Path $Root "AI_Documentation\AOS"
}

if ([string]::IsNullOrWhiteSpace($TemplateDir)) {
    $TemplateDir = Join-Path $Root "AI_Documentation\AOS_Template"
}

if ([string]::IsNullOrWhiteSpace($Title)) {
    $Title = $FeatureId
}

function Convert-ToSafeSegment {
    param([string]$Value)
    $normalized = $Value.Trim().ToLowerInvariant()
    $normalized = $normalized -replace '[^a-z0-9_\-]+', '-'
    $normalized = $normalized -replace '-+', '-'
    return $normalized.Trim('-')
}

function Read-Template {
    param([string]$Path)
    return Get-Content -LiteralPath $Path -Raw
}

function Convert-TemplateContent {
    param(
        [string]$Content,
        [string]$Kind
    )

    $content = $Content
    $content = $content -replace '^# AOS .+ Template', "# AOS $Title - $Kind"
    $content = $content -replace 'AOS-<MOD>-<SCREEN>', "AOS-$($Module.ToUpperInvariant())-$($FeatureId.ToUpperInvariant().Replace('-', '_'))"
    $content = $content -replace '<np\. Orders, Logistics, Catalog>', $Module
    $content = $content -replace '<nazwa biznesowa i techniczna>', $Title

    if (-not [string]::IsNullOrWhiteSpace($Route)) {
        $content = $content -replace '<np\. /orders/:id>', $Route
    }

    if (-not [string]::IsNullOrWhiteSpace($ComponentPath)) {
        $content = $content -replace '<ścieżka do component\.ts>', $ComponentPath
        $content = $content -replace '<component\.ts/html/scss>', $ComponentPath
    }

    if (-not [string]::IsNullOrWhiteSpace($ApiPath)) {
        $content = $content -replace '<prefiks API / gateway>', $ApiPath
    }

    return $content
}

$moduleSegment = Convert-ToSafeSegment $Module
$featureSegment = Convert-ToSafeSegment $FeatureId
$targetDir = Join-Path (Join-Path $OutputRoot $moduleSegment) $featureSegment

$files = @(
    @{ Source = "AI_AOS_01_SCREEN_OVERVIEW_TEMPLATE.md"; Target = "00_SCREEN_OVERVIEW.md"; Kind = "Screen Overview" },
    @{ Source = "AI_AOS_02_UI_FIELDS_AND_LAYOUT_TEMPLATE.md"; Target = "01_UI_FIELDS_AND_LAYOUT.md"; Kind = "UI Fields And Layout" },
    @{ Source = "AI_AOS_03_ACTIONS_AND_PROCESS_TRACE_TEMPLATE.md"; Target = "02_ACTIONS_AND_PROCESS_TRACE.md"; Kind = "Actions And Process Trace" },
    @{ Source = "AI_AOS_04_API_AND_CONTRACTS_TEMPLATE.md"; Target = "03_API_AND_CONTRACTS.md"; Kind = "API And Contracts" },
    @{ Source = "AI_AOS_05_DATA_LINEAGE_TEMPLATE.md"; Target = "04_DATA_LINEAGE.md"; Kind = "Data Lineage" },
    @{ Source = "AI_AOS_06_RULES_VALIDATIONS_ERRORS_TEMPLATE.md"; Target = "05_RULES_VALIDATIONS_ERRORS.md"; Kind = "Rules Validations Errors" },
    @{ Source = "AI_AOS_07_TEST_MATRIX_TEMPLATE.md"; Target = "06_TEST_MATRIX.md"; Kind = "Test Matrix" },
    @{ Source = "AI_AOS_08_DEV_AI_NAVIGATION_TEMPLATE.md"; Target = "07_DEV_AI_NAVIGATION.md"; Kind = "Dev AI Navigation" },
    @{ Source = "AI_AOS_09_REQUIREMENTS_TRACEABILITY_TEMPLATE.md"; Target = "08_REQUIREMENTS_TRACEABILITY.md"; Kind = "Requirements Traceability" },
    @{ Source = "AI_AOS_10_CHANGELOG_REVIEW_GATE_TEMPLATE.md"; Target = "09_CHANGELOG_REVIEW_GATE.md"; Kind = "Changelog Review Gate" }
)

if ($DryRun) {
    Write-Host "AOS scaffold target: $targetDir"
    foreach ($file in $files) {
        Write-Host "Would create: $(Join-Path $targetDir $file.Target)"
    }
    return
}

New-Item -ItemType Directory -Path $targetDir -Force | Out-Null

foreach ($file in $files) {
    $sourcePath = Join-Path $TemplateDir $file.Source
    if (-not (Test-Path -LiteralPath $sourcePath)) {
        throw "Template not found: $sourcePath"
    }

    $targetPath = Join-Path $targetDir $file.Target
    if (Test-Path -LiteralPath $targetPath) {
        throw "Target already exists: $targetPath"
    }

    $content = Read-Template $sourcePath
    $content = Convert-TemplateContent -Content $content -Kind $file.Kind
    Set-Content -LiteralPath $targetPath -Value $content -Encoding UTF8
}

Write-Host "Created AOS scaffold: $targetDir"
