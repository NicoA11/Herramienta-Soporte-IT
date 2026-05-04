# ==============================
# Herramienta de Soporte IT
# Ejecutar como Administrador
# ==============================

function Pausa {
    Write-Host ""
    Read-Host "Presione ENTER para continuar"
}

function Mostrar-Menu {
    Clear-Host
    Write-Host "============================================" -ForegroundColor Cyan
    Write-Host "   HERRAMIENTA DE SOPORTE IT - POWERSHELL"
    Write-Host "============================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "1. Diagnostico del equipo"
    Write-Host "2. Test de conectividad a Internet"
    Write-Host "3. Limpiar archivos temporales"
    Write-Host "4. Ver informacion de red"
    Write-Host "5. Reparar sistema con SFC y DISM"
    Write-Host "6. Renovar IP y limpiar DNS"
    Write-Host "7. Test de conexion a dominio"
    Write-Host "8. Reiniciar servicios comunes"
    Write-Host "9. Salir"
    Write-Host ""
}

function Diagnostico-Equipo {
    Clear-Host
    Write-Host "=== DIAGNOSTICO DEL EQUIPO ===" -ForegroundColor Yellow

    Write-Host "`nNombre del equipo:"
    hostname

    Write-Host "`nUsuario actual:"
    whoami

    Write-Host "`nSistema operativo:"
    Get-CimInstance Win32_OperatingSystem |
    Select-Object Caption, Version, OSArchitecture |
    Format-List

    Write-Host "`nProcesador:"
    Get-CimInstance Win32_Processor |
    Select-Object Name |
    Format-List

    Write-Host "`nMemoria RAM:"
    Get-CimInstance Win32_ComputerSystem |
    Select-Object @{Name="RAM(GB)";Expression={[math]::Round($_.TotalPhysicalMemory / 1GB,2)}} |
    Format-List

    Write-Host "`nDiscos:"
    Get-CimInstance Win32_LogicalDisk -Filter "DriveType=3" |
    Select-Object DeviceID,
    @{Name="Total(GB)";Expression={[math]::Round($_.Size / 1GB,2)}},
    @{Name="Libre(GB)";Expression={[math]::Round($_.FreeSpace / 1GB,2)}} |
    Format-Table -AutoSize

    Pausa
}

function Test-Conectividad {
    Clear-Host
    Write-Host "=== TEST DE CONECTIVIDAD A INTERNET ===" -ForegroundColor Yellow

    $destino = Read-Host "Ingrese IP o dominio para testear. Enter para usar 8.8.8.8"

    if ([string]::IsNullOrWhiteSpace($destino)) {
        $destino = "8.8.8.8"
    }

    Write-Host "`nRealizando ping a $destino..."

    Test-Connection $destino -Count 4 |
    Select-Object Address, ResponseTime, StatusCode |
    Format-Table -AutoSize

    Pausa
}

function Limpiar-Temporales {
    Clear-Host
    Write-Host "=== LIMPIEZA DE ARCHIVOS TEMPORALES ===" -ForegroundColor Yellow

    $rutas = @(
        "$env:TEMP\*",
        "C:\Windows\Temp\*"
    )

    foreach ($ruta in $rutas) {
        Write-Host "Limpiando: $ruta"
        Remove-Item $ruta -Recurse -Force -ErrorAction SilentlyContinue
    }

    Write-Host "`nLimpieza finalizada." -ForegroundColor Green
    Pausa
}

function Info-Red {
    Clear-Host
    Write-Host "=== INFORMACION DE RED ===" -ForegroundColor Yellow

    Write-Host "`nConfiguracion IP:"
    ipconfig /all

    Write-Host "`nAdaptadores de red:"
    Get-NetAdapter | Select-Object Name, Status, LinkSpeed, MacAddress

    Pausa
}

function Reparar-Sistema {
    Clear-Host
    Write-Host "=== REPARACION DEL SISTEMA ===" -ForegroundColor Yellow
    Write-Host "Esto puede tardar varios minutos..."

    Write-Host "`nEjecutando DISM..."
    DISM /Online /Cleanup-Image /RestoreHealth

    Write-Host "`nEjecutando SFC..."
    sfc /scannow

    Pausa
}

function Renovar-Red {
    Clear-Host
    Write-Host "=== RENOVAR IP Y LIMPIAR DNS ===" -ForegroundColor Yellow

    ipconfig /flushdns
    ipconfig /release
    ipconfig /renew

    Write-Host "`nProceso finalizado." -ForegroundColor Green
    Pausa
}

function Test-Dominio {
    Clear-Host
    Write-Host "=== TEST DE CONEXION A DOMINIO ===" -ForegroundColor Yellow

    $dominio = Read-Host "Ingrese el dominio. Ejemplo: empresa.local"

    if ([string]::IsNullOrWhiteSpace($dominio)) {
        Write-Host "No ingresaste ningun dominio." -ForegroundColor Red
    }
    else {
        Test-Connection $dominio -Count 4
        nltest /dsgetdc:$dominio
    }

    Pausa
}

function Reiniciar-Servicios {
    Clear-Host
    Write-Host "=== REINICIAR SERVICIOS COMUNES ===" -ForegroundColor Yellow

    $servicios = @(
        "Spooler",
        "wuauserv",
        "BITS",
        "Dnscache"
    )

    foreach ($servicio in $servicios) {
        Write-Host "Reiniciando servicio: $servicio"
        Restart-Service -Name $servicio -Force -ErrorAction SilentlyContinue
    }

    Write-Host "`nServicios reiniciados." -ForegroundColor Green
    Pausa
}

do {
    Mostrar-Menu
    $opcion = Read-Host "Seleccione una opcion"

    switch ($opcion) {
        "1" { Diagnostico-Equipo }
        "2" { Test-Conectividad }
        "3" { Limpiar-Temporales }
        "4" { Info-Red }
        "5" { Reparar-Sistema }
        "6" { Renovar-Red }
        "7" { Test-Dominio }
        "8" { Reiniciar-Servicios }
        "9" { Write-Host "Saliendo..." -ForegroundColor Green }
        default {
            Write-Host "Opcion invalida." -ForegroundColor Red
            Start-Sleep -Seconds 2
        }
    }

} while ($opcion -ne "9")