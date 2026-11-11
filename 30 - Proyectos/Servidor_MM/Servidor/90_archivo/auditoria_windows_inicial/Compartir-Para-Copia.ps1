#requires -RunAsAdministrator
$ErrorActionPreference = 'Stop'
$madeUser = $false
$madeShare = $false
$madeRule = $false
try {
 if (Get-LocalUser -Name CopiaServidorTemp -ErrorAction SilentlyContinue) { throw 'La cuenta ya existe.' }
 if (Get-SmbShare -Name ServidorCopia -ErrorAction SilentlyContinue) { throw 'El recurso ya existe.' }
 if (Get-NetFirewallRule -Name ServidorCopia-192.168.2.107 -ErrorAction SilentlyContinue) { throw 'La regla ya existe.' }
 $secret = Read-Host 'Crea una contrasena temporal para copiar la carpeta (no se mostrara)' -AsSecureString
 New-LocalUser -Name CopiaServidorTemp -Password $secret -AccountExpires (Get-Date).AddDays(1) -Description 'Copia temporal del proyecto' | Out-Null
 $madeUser = $true
 $secret.Dispose()
 New-SmbShare -Name ServidorCopia -Path 'D:\Servidor' -ReadAccess "$env:COMPUTERNAME\CopiaServidorTemp" -CachingMode None -EncryptData $true | Out-Null
 $madeShare = $true
 New-NetFirewallRule -Name ServidorCopia-192.168.2.107 -DisplayName 'Copia temporal proyecto' -Direction Inbound -Action Allow -Protocol TCP -LocalPort 445 -LocalAddress 192.168.2.105 -RemoteAddress 192.168.2.107 -Profile Any | Out-Null
 $madeRule = $true
 Get-SmbShareAccess -Name ServidorCopia | Format-Table
 'Creado; pendiente comprobar copia desde el cliente.' | Set-Content 'D:\Servidor\work\estado-comparticion.txt'
 Write-Host '\\192.168.2.105\ServidorCopia'
 Write-Host "Usuario: $env:COMPUTERNAME\CopiaServidorTemp"
} catch {
 if ($madeRule) { Remove-NetFirewallRule -Name ServidorCopia-192.168.2.107 -ErrorAction Continue }
 if ($madeShare) { Remove-SmbShare -Name ServidorCopia -Force -ErrorAction Continue }
 if ($madeUser) { Remove-LocalUser -Name CopiaServidorTemp -ErrorAction Continue }
 Write-Host $_ -ForegroundColor Red
 'No completado; revisar ventana local.' | Set-Content 'D:\Servidor\work\estado-comparticion.txt'
}
Read-Host 'Pulsa Intro para cerrar'
