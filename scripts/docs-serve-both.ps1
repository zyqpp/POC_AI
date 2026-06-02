param(
    [string]$Address = "127.0.0.1",
    [int[]]$CandidateTechPorts = @(8100, 8110, 8120, 8130),
    [switch]$OpenWindows
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
$repoRoot = (Resolve-Path ".").Path

function Test-PortAvailable {
    param(
        [Parameter(Mandatory = $true)]
        [string]$BindAddress,
        [Parameter(Mandatory = $true)]
        [int]$BindPort
    )

    $ip = [System.Net.IPAddress]::Parse($BindAddress)
    $listener = [System.Net.Sockets.TcpListener]::new($ip, $BindPort)

    try {
        $listener.Start()
        return $true
    }
    catch {
        return $false
    }
    finally {
        if ($listener.Server -and $listener.Server.IsBound) {
            $listener.Stop()
        }
    }
}

function Wait-ForHttpReady {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Url,
        [int]$TimeoutSeconds = 60
    )

    $deadline = (Get-Date).AddSeconds($TimeoutSeconds)
    do {
        try {
            $response = Invoke-WebRequest -Uri $Url -UseBasicParsing -TimeoutSec 3
            if ($response.StatusCode -eq 200) {
                return $true
            }
        }
        catch {
            Start-Sleep -Milliseconds 500
        }
    } while ((Get-Date) -lt $deadline)

    return $false
}

$selectedTechPort = $null
$selectedUserPort = $null

foreach ($techPort in $CandidateTechPorts) {
    $userPort = $techPort + 1

    if ((Test-PortAvailable -BindAddress $Address -BindPort $techPort) -and
        (Test-PortAvailable -BindAddress $Address -BindPort $userPort)) {
        $selectedTechPort = $techPort
        $selectedUserPort = $userPort
        break
    }
}

if ($null -eq $selectedTechPort -or $null -eq $selectedUserPort) {
    throw "Brak wolnej pary portow. Zmien CandidateTechPorts albo zwolnij porty."
}

$windowStyle = if ($OpenWindows.IsPresent) { "Normal" } else { "Hidden" }

$techProc = Start-Process powershell -WindowStyle $windowStyle -ArgumentList @(
    "-ExecutionPolicy", "Bypass",
    "-File", ".\\scripts\\docs-serve-tech.ps1",
    "-Address", $Address,
    "-Port", $selectedTechPort
) -WorkingDirectory $repoRoot -PassThru

$userProc = Start-Process powershell -WindowStyle $windowStyle -ArgumentList @(
    "-ExecutionPolicy", "Bypass",
    "-File", ".\\scripts\\docs-serve-user.ps1",
    "-Address", $Address,
    "-Port", $selectedUserPort
) -WorkingDirectory $repoRoot -PassThru

$techUrl = "http://$Address`:$selectedTechPort"
$userUrl = "http://$Address`:$selectedUserPort"

$techReady = Wait-ForHttpReady -Url $techUrl
$userReady = Wait-ForHttpReady -Url $userUrl

if (-not $techReady -or -not $userReady) {
    Write-Warning "Przynajmniej jeden portal nie odpowiedzial HTTP 200 w limicie czasu."
}

Write-Host "Portale uruchomione."
Write-Host "Techniczna: $techUrl (PID: $($techProc.Id))"
Write-Host "Uzytkownika: $userUrl (PID: $($userProc.Id))"
Write-Host "Aby zatrzymac: Stop-Process -Id $($techProc.Id),$($userProc.Id)"
