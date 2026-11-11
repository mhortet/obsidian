# Copia temporal del proyecto
Proposito: permitir copiar D:\Servidor antes de instalar Linux.
Recurso: ServidorCopia, lectura para CopiaServidorTemp y cifrado SMB.
Regla adicional TCP 445: local 192.168.2.105, remoto 192.168.2.107. No modifica reglas anteriores ni router ni perfil publico.
Riesgo: acceso temporal a documentacion con la cuenta creada, que caduca en un dia. Retirar los recursos al terminar.
Aceptacion: copiar desde el cliente y leer los documentos; verificar que no permite escribir en el recurso.
Reversion en PowerShell administrador (solo recursos creados por este procedimiento):

    Remove-SmbShare -Name ServidorCopia -Force
    Remove-NetFirewallRule -Name ServidorCopia-192.168.2.107
    Remove-LocalUser -Name CopiaServidorTemp

Ver LEER-ANTES-DE-INSTALAR.md para reparto provisional y decisiones. Verificar copia externa antes de borrar discos.
