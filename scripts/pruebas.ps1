$ErrorActionPreference = 'Stop'
if (-not $env:IMAGE_TAG) { $env:IMAGE_TAG = 'local' }
$image = "flask-ra:$env:IMAGE_TAG"
docker run --rm $image python -m unittest discover -s tests -v
if ($LASTEXITCODE -ne 0) { throw 'Pruebas unitarias fallidas.' }
$candidate = "ra-prueba-$([guid]::NewGuid().ToString('N'))"
try {
    docker run -d --name $candidate -p 127.0.0.1:5051:5000 -e "APP_VERSION=$env:IMAGE_TAG" $image
    if ($LASTEXITCODE -ne 0) { throw 'No inicio el candidato.' }
    $ok = $false
    for ($i = 0; $i -lt 20; $i++) {
        try {
            $health = Invoke-RestMethod http://127.0.0.1:5051/health -TimeoutSec 3
            $homeResponse = Invoke-WebRequest http://127.0.0.1:5051/ -UseBasicParsing -TimeoutSec 3
            if ($health.status -eq 'ok' -and $health.version -eq $env:IMAGE_TAG -and $homeResponse.StatusCode -eq 200) {
                $ok = $true; break
            }
        } catch { }
        Start-Sleep -Seconds 2
    }
    if (-not $ok) { docker logs $candidate; throw 'Fallo HTTP o version del candidato.' }
    Write-Output 'Pruebas unitarias y HTTP correctas.'
} finally {
    docker rm -f $candidate 2>$null | Out-Null
}
