$ErrorActionPreference = 'Stop'

$scriptPath = Join-Path $PSScriptRoot 'auditar-sftpgo-fase-equipo-actual-20261119.sh'
$evidencePath = Join-Path (Split-Path $PSScriptRoot -Parent) '..\05_evidencias\REVALIDACION-SFTPGO-FASE-EQUIPO-ACTUAL-2026-11-19.txt'
$evidencePath = [System.IO.Path]::GetFullPath($evidencePath)
$keyPath = Join-Path $env:USERPROFILE '.ssh\id_ed25519_srv_mm'

$scriptBytes = [System.IO.File]::ReadAllBytes($scriptPath)
$encodedScript = [Convert]::ToBase64String($scriptBytes)
$remoteCommand = "printf '%s' '$encodedScript' | base64 -d | sudo bash"

& ssh.exe `
    -tt `
    -i $keyPath `
    -o IdentitiesOnly=yes `
    -o StrictHostKeyChecking=yes `
    -o HostKeyAlias=192.168.1.30 `
    -o UpdateHostKeys=no `
    vicente@192.168.1.31 `
    $remoteCommand |
    Tee-Object -FilePath $evidencePath

if ($LASTEXITCODE -ne 0) {
    throw "La auditoría remota terminó con código $LASTEXITCODE."
}

Write-Host "Evidencia guardada en: $evidencePath"
