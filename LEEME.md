# Resultado de aprendizaje U2 — Flask y Docker

Caso: la API Flask utilizada en las actividades de despliegue.
Destino: Docker Desktop local, http://localhost:5050.

## Primera prueba en Windows PowerShell
Abre Docker Desktop (contenedores Linux) y una terminal en esta carpeta:

```powershell
$env:IMAGE_TAG = 'local'
powershell -ExecutionPolicy Bypass -File scripts/entorno.ps1
powershell -ExecutionPolicy Bypass -File scripts/pruebas.ps1
powershell -ExecutionPolicy Bypass -File scripts/desplegar.ps1
powershell -ExecutionPolicy Bypass -File scripts/monitorear.ps1
```
Bypass se aplica solo a ese proceso, no cambia la política permanente.
Los puertos 5050 (aplicación) y 5051 (candidato) deben estar libres.

## GitHub Actions y entorno de despliegue
1. Crea un repositorio privado llamado Resultado-U2-Flask, sin README inicial.
2. Sube el contenido completo de esta carpeta, incluida .github/workflows/cd.yml.
3. El entorno de despliegue es Docker Desktop del runner; no necesitas crear un Environment de GitHub ni contratar un plan adicional.
4. Settings > Actions > Runners > New self-hosted runner: Windows, x64.
5. En PowerShell, fuera del repositorio (por ejemplo C:\actions-runner), ejecuta los comandos que muestra GitHub. El token es temporal y personal: no se incluye en los archivos.
6. En config.cmd agrega la etiqueta ra-flask cuando pregunte por etiquetas adicionales.
7. Para la práctica elige no instalarlo como servicio y arranca .\run.cmd en la misma sesión de Windows donde corre Docker Desktop. Mantén la ventana abierta.
8. En GitHub comprueba el runner Idle/Online. Actions > Liberacion y despliegue local > Run workflow > main.
9. Tras la primera ejecución, cada push a main inicia el flujo. No se ejecuta en pull requests de terceros.

El servicio se ejecuta EN TU PC; un runner alojado por GitHub no podría desplegar en tu Docker Desktop. La URL localhost solo abre en ese mismo equipo.

## Subir desde una carpeta nueva (terminal CMD)
```bat
git init
git add .
git commit -m "Configurar pipeline de liberacion y despliegue Flask"
git branch -M main
git remote add origin https://github.com/Maberick2/Resultado-U2-Flask.git
git push -u origin main
```
Si ya está inicializada y tiene origin, no repitas init/remote: usa git status y git remote -v primero.

## Demostrar una segunda publicación
Cambia el texto de la ruta / conservando las palabras API funcionando; guarda, realiza commit y push. Observa Actions en verde y abre /health. version debe coincidir con el SHA del commit desplegado.

## Recuperación
Si un despliegue falla, revisa docker compose logs --tail 50. Para volver a una imagen anterior que siga almacenada:
```powershell
$env:IMAGE_TAG = 'SHA_ANTERIOR_COMPLETO'
powershell -ExecutionPolicy Bypass -File scripts/desplegar.ps1
```
No hay rollback automático. No elimines las imágenes anteriores antes de la revisión.

## Evidencias
Captura runner conectado, workflow y etapas en verde, Docker Desktop con ra-flask healthy, navegador / y /health, artifact monitoreo y segundo commit publicado. Consulta el documento para su ubicación.

## Validación del paquete
Se ejecutaron correctamente las 3 pruebas unitarias con Python 3.12 y las dependencias indicadas. Docker y PowerShell no están disponibles en el entorno de preparación: la construcción, scripts PowerShell y el workflow requieren verificación en el equipo del alumno. No se adjuntan capturas ni resultados inventados.
