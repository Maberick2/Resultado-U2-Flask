param([int]$Muestras = 10, [int]$Intervalo = 5)
$ErrorActionPreference = 'Stop'
New-Item -ItemType Directory -Force evidencias | Out-Null
$rows = for ($i = 0; $i -lt $Muestras; $i++) {
    $timer = [Diagnostics.Stopwatch]::StartNew()
    $ok = $false; $version = ''; $status = 0
    try {
        $r = Invoke-WebRequest http://127.0.0.1:5050/health -UseBasicParsing -TimeoutSec 5
        $status = [int]$r.StatusCode
        $body = $r.Content | ConvertFrom-Json
        $ok = ($status -eq 200 -and $body.status -eq 'ok')
        $version = $body.version
    } catch { }
    $timer.Stop()
    [pscustomobject]@{fecha=(Get-Date -Format o); disponible=$ok; codigo=$status; ms=$timer.ElapsedMilliseconds; version=$version}
    if ($i -lt ($Muestras - 1)) { Start-Sleep -Seconds $Intervalo }
}
$rows | Export-Csv evidencias/monitoreo.csv -NoTypeInformation
$rows | Format-Table
Write-Output 'El porcentaje de disponibilidad corresponde solo a estas muestras.'
