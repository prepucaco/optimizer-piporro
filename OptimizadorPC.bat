@echo off
:: ============================================================
::  OPTIMIZADOR PC - Windows 10 Low-End (Celeron / 4GB RAM)
::  Version EQUILIBRADA: mejora RAM sin romper nada.
::  Un solo Enter. Ejecutar como Administrador.
:: ============================================================
title Optimizador PC - Modo Equilibrado
color 0A

:: --- Auto-elevar a Administrador ---
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Pidiendo permisos de administrador...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

echo.
echo  ============================================
echo   OPTIMIZADOR EQUILIBRADO - WIN10 4GB RAM
echo  ============================================
echo.
echo  Se crea un punto de restauracion antes de tocar nada.
echo  Presiona ENTER para optimizar la PC...
pause >nul

:: ============================================================
:: 0. PUNTO DE RESTAURACION
:: ============================================================
echo [0/7] Creando punto de restauracion...
powershell -Command "Enable-ComputerRestore -Drive 'C:\' -ErrorAction SilentlyContinue; Checkpoint-Computer -Description 'Antes de OptimizadorPC' -RestorePointType MODIFY_SETTINGS -ErrorAction SilentlyContinue" >nul 2>&1

:: ============================================================
:: 1. SERVICIOS: solo se desactivan los realmente inutiles.
::    Los dudosos quedan en MANUAL (arrancan solo si se necesitan).
:: ============================================================
echo [1/7] Ajustando servicios...

:: SysMain (Superfetch): con 4GB hace mas dano que bien -> desactivado
sc stop "SysMain" >nul 2>&1
sc config "SysMain" start=disabled >nul 2>&1

:: Windows Search: en MANUAL, no desactivado.
:: La busqueda sigue funcionando, solo no indexa todo el dia.
sc config "WSearch" start=demand >nul 2>&1

:: Telemetria (no aporta nada al usuario) -> desactivada
sc stop "DiagTrack" >nul 2>&1
sc config "DiagTrack" start=disabled >nul 2>&1
sc config "dmwappushservice" start=disabled >nul 2>&1

:: Servicios que casi nadie usa -> MANUAL (si algo los necesita, arrancan solos)
sc config "Fax" start=demand >nul 2>&1
sc config "MapsBroker" start=demand >nul 2>&1
sc config "RetailDemo" start=demand >nul 2>&1
sc config "XblAuthManager" start=demand >nul 2>&1
sc config "XblGameSave" start=demand >nul 2>&1
sc config "XboxNetApiSvc" start=demand >nul 2>&1

:: ============================================================
:: 2. TELEMETRIA Y TAREAS PROGRAMADAS DE MICROSOFT
:: ============================================================
echo [2/7] Reduciendo telemetria...

reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f >nul 2>&1

schtasks /Change /TN "Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Customer Experience Improvement Program\Consolidator" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Customer Experience Improvement Program\UsbCeip" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Feedback\Siuf\DmClient" /Disable >nul 2>&1

:: ============================================================
:: 3. APPS EN SEGUNDO PLANO Y SUGERENCIAS
:: ============================================================
echo [3/7] Apagando apps en segundo plano y anuncios...

:: Apps de la Store en segundo plano (buen ahorro de RAM, no afecta apps abiertas)
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /v GlobalUserDisabled /t REG_DWORD /d 1 /f >nul 2>&1

:: Game DVR (graba gameplay oculto en segundo plano)
reg add "HKCU\System\GameConfigStore" /v GameDVR_Enabled /t REG_DWORD /d 0 /f >nul 2>&1

:: Sugerencias y apps que Windows instala solo
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SystemPaneSuggestionsEnabled /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SilentInstalledAppsEnabled /t REG_DWORD /d 0 /f >nul 2>&1

:: ============================================================
:: 4. EFECTOS VISUALES: solo lo que pesa.
::    Windows se sigue viendo normal (fuentes suaves, iconos bien),
::    solo se quitan transparencias y animaciones.
:: ============================================================
echo [4/7] Quitando transparencias y animaciones (se ve casi igual)...

reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v EnableTransparency /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v TaskbarAnimations /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Control Panel\Desktop\WindowMetrics" /v MinAnimate /t REG_SZ /d 0 /f >nul 2>&1
reg add "HKCU\Control Panel\Desktop" /v MenuShowDelay /t REG_SZ /d 100 /f >nul 2>&1

:: ============================================================
:: 5. AGRUPAR SVCHOST (el mejor truco para 4GB, totalmente seguro)
:: ============================================================
echo [5/7] Agrupando procesos svchost...
reg add "HKLM\SYSTEM\CurrentControlSet\Control" /v SvcHostSplitThresholdInKB /t REG_DWORD /d 0x4000000 /f >nul 2>&1

:: ============================================================
:: 6. BLOATWARE: solo apps que de verdad nadie usa.
::    NO toca: Fotos, Calculadora, Tu Telefono, Skype, Tienda.
:: ============================================================
echo [6/7] Quitando bloatware basico (puede tardar 1 min)...
powershell -Command "$apps = @('Microsoft.3DBuilder','Microsoft.BingNews','Microsoft.GetHelp','Microsoft.Getstarted','Microsoft.Microsoft3DViewer','Microsoft.MicrosoftSolitaireCollection','Microsoft.MixedReality.Portal','Microsoft.Print3D','Microsoft.WindowsFeedbackHub'); foreach ($a in $apps) { Get-AppxPackage -AllUsers $a 2>$null | Remove-AppxPackage -ErrorAction SilentlyContinue }" >nul 2>&1

:: ============================================================
:: 7. LIMPIEZA LIGERA (solo temporales del usuario y de Windows)
:: ============================================================
echo [7/7] Limpiando temporales...
del /f /s /q "%TEMP%\*.*" >nul 2>&1
del /f /s /q "C:\Windows\Temp\*.*" >nul 2>&1
ipconfig /flushdns >nul 2>&1

echo.
echo  ============================================
echo   LISTO! OPTIMIZACION COMPLETADA
echo  ============================================
echo.
echo  - SysMain y telemetria desactivados
echo  - Busqueda de Windows en manual (sigue funcionando)
echo  - Apps en segundo plano apagadas
echo  - Svchost agrupado = menos procesos
echo  - Bloatware basico eliminado
echo  - Temporales limpiados
echo.
echo  Reinicia la PC cuando puedas para aplicar todo.
echo  Si algo no te gusta, restaura el punto "Antes de OptimizadorPC".
echo.
pause
