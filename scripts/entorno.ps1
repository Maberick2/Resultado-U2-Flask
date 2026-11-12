$ErrorActionPreference = 'Stop'
if (-not $env:IMAGE_TAG) { $env:IMAGE_TAG = 'local' }
docker info | Out-Null
if ($LASTEXITCODE -ne 0) { throw 'Inicia Docker Desktop.' }
docker compose version
if ($LASTEXITCODE -ne 0) { throw 'Docker Compose no disponible.' }
docker compose build
if ($LASTEXITCODE -ne 0) { throw 'Fallo la construccion.' }
