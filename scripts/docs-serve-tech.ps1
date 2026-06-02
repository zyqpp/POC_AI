param(
    [string]$Address = "127.0.0.1",
    [int]$Port = 8100
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

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

if (-not (Test-PortAvailable -BindAddress $Address -BindPort $Port)) {
    throw "Port $Address`:$Port jest zajety. Uruchom np.: .\scripts\docs-serve-tech.ps1 -Port 8110"
}

. .\.venv\Scripts\Activate.ps1

python -m mkdocs serve -f mkdocs-tech.yml -a "$Address`:$Port"
