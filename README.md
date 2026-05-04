# Herramienta de Soporte IT en PowerShell

Script interactivo en PowerShell diseñado para automatizar tareas comunes de soporte técnico IT en entornos Windows.

## Funcionalidades

- Diagnóstico del equipo
- Test de conectividad a Internet
- Limpieza de archivos temporales
- Información de red
- Reparación del sistema con SFC y DISM
- Renovación de IP y limpieza de DNS
- Test de conexión a dominio
- Reinicio de servicios comunes

## Requisitos

- Windows 10/11
- PowerShell
- Ejecutar como Administrador

## Uso

1. Descargar o clonar el repositorio.
2. Abrir PowerShell como Administrador.
3. Ir a la carpeta del script:

``powershell
cd "C:\Ruta\Del\Script"

Ejecutar:
.\Soporte.ps1

--Permisos de ejecución--
Si PowerShell bloquea el script, ejecutar:

Set-ExecutionPolicy RemoteSigned -Scope CurrentUser

Luego volver a ejecutar el script.
