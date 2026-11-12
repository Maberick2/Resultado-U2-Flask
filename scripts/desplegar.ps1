$ErrorActionPreference = 'Stop'
if (-not $env:IMAGE_TAG) { $env:IMAGE_TAG = 'local' }
docker compose up -d --no-build --wait --wait-timeout 90
if ($LASTEXITCODE -ne 0) { throw 'Despliegue sin estado saludable.' }
$health = Invoke-RestMethod http://127.0.0.1:5050/health -TimeoutSec 5
if ($health.status -ne 'ok' -or $health.version -ne $env:IMAGE_TAG) {
    throw 'La version desplegada no coincide.'
}
docker compose ps
Write-Output "Despliegue verificado: $($health.version) en http://localhost:5050"
