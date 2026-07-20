@echo off
:: ============================================================
::  OPTIMIZADOR PC - Windows 10 Low-End (Celeron / 4GB RAM)
::  Un solo Enter y optimiza todo. Ejecutar como Administrador.
:: ============================================================
title Optimizador PC - Modo Extremo
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
echo   OPTIMIZADOR EXTREMO - WIN10 CELERON 4GB
echo  ============================================
echo.
echo  Se va a crear un punto de restauracion antes de tocar nada.
echo  Presiona ENTER para optimizar la PC...
pause >nul

:: ============================================================
:: 0. PUNTO DE RESTAURACION (por si algo sale mal)
:: ============================================================
echo [0/9] Creando punto de restauracion...
powershell -Command "Enable-ComputerRestore -Drive 'C:\' -ErrorAction SilentlyContinue; Checkpoint-Computer -Description 'Antes de OptimizadorPC' -RestorePointType MODIFY_SETTINGS -ErrorAction SilentlyContinue" >nul 2>&1

:: ============================================================
:: 1. SERVICIOS INNECESARIOS -> DESACTIVADOS
::    (los que mas RAM/CPU comen en PCs lentas)
:: ============================================================
echo [1/9] Desactivando servicios que comen RAM...

:: SysMain (Superfetch) - inutil con poca RAM, come muchisimo
sc stop "SysMain" >nul 2>&1
sc config "SysMain" start=disabled >nul 2>&1

:: Windows Search (indexador) - come RAM y disco constantemente
sc stop "WSearch" >nul 2>&1
sc config "WSearch" start=disabled >nul 2>&1

:: Telemetria de Microsoft
sc stop "DiagTrack" >nul 2>&1
sc config "DiagTrack" start=disabled >nul 2>&1
sc stop "dmwappushservice" >nul 2>&1
sc config "dmwappushservice" start=disabled >nul 2>&1

:: Fax, impresion remota, mapas, etc.
sc config "Fax" start=disabled >nul 2>&1
sc config "MapsBroker" start=disabled >nul 2>&1
sc config "RemoteRegistry" start=disabled >nul 2>&1
sc config "RetailDemo" start=disabled >nul 2>&1
sc config "WerSvc" start=disabled >nul 2>&1
sc config "PcaSvc" start=disabled >nul 2>&1
sc config "WpcMonSvc" start=disabled >nul 2>&1
sc config "wisvc" start=disabled >nul 2>&1
sc config "DPS" start=disabled >nul 2>&1

:: Xbox (si no juegas juegos de Microsoft Store)
sc config "XblAuthManager" start=disabled >nul 2>&1
sc config "XblGameSave" start=disabled >nul 2>&1
sc config "XboxGipSvc" start=disabled >nul 2>&1
sc config "XboxNetApiSvc" start=disabled >nul 2>&1

:: Touch/tablet (PC de escritorio no lo usa)
sc config "TabletInputService" start=disabled >nul 2>&1

:: Windows Update -> manual (no desactivado, para poder actualizar cuando quieras)
sc config "wuauserv" start=demand >nul 2>&1

:: ============================================================
:: 2. TELEMETRIA Y TAREAS PROGRAMADAS ESPIA
:: ============================================================
echo [2/9] Matando telemetria y tareas en segundo plano...

reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f >nul 2>&1

schtasks /Change /TN "Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Application Experience\ProgramDataUpdater" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Autochk\Proxy" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Customer Experience Improvement Program\Consolidator" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Customer Experience Improvement Program\UsbCeip" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Feedback\Siuf\DmClient" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Windows Error Reporting\QueueReporting" /Disable >nul 2>&1

:: ============================================================
:: 3. APPS EN SEGUNDO PLANO + CORTANA + WIDGETS
:: ============================================================
echo [3/9] Desactivando apps en segundo plano y Cortana...

:: Apps en segundo plano (gran ahorro de RAM)
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /v GlobalUserDisabled /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /v LetAppsRunInBackground /t REG_DWORD /d 2 /f >nul 2>&1

:: Cortana
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v AllowCortana /t REG_DWORD /d 0 /f >nul 2>&1

:: Game DVR / Game Bar (graba gameplay en segundo plano, come RAM)
reg add "HKCU\System\GameConfigStore" /v GameDVR_Enabled /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\GameDVR" /v AllowGameDVR /t REG_DWORD /d 0 /f >nul 2>&1

:: Tips, sugerencias y anuncios de Windows
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SystemPaneSuggestionsEnabled /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SilentInstalledAppsEnabled /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SubscribedContent-338388Enabled /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SubscribedContent-338389Enabled /t REG_DWORD /d 0 /f >nul 2>&1

:: ============================================================
:: 4. EFECTOS VISUALES -> MAXIMO RENDIMIENTO
:: ============================================================
echo [4/9] Efectos visuales a maximo rendimiento...

reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v VisualFXSetting /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKCU\Control Panel\Desktop" /v DragFullWindows /t REG_SZ /d 0 /f >nul 2>&1
reg add "HKCU\Control Panel\Desktop" /v MenuShowDelay /t REG_SZ /d 0 /f >nul 2>&1
reg add "HKCU\Control Panel\Desktop\WindowMetrics" /v MinAnimate /t REG_SZ /d 0 /f >nul 2>&1
:: Transparencias fuera
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v EnableTransparency /t REG_DWORD /d 0 /f >nul 2>&1
:: Animaciones de la barra de tareas fuera
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v TaskbarAnimations /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v ListviewAlphaSelect /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v ListviewShadow /t REG_DWORD /d 0 /f >nul 2>&1

:: ============================================================
:: 5. MENOS PROCESOS SVCHOST (truco clave para 4GB)
::    Windows separa cada servicio en su propio svchost si hay
::    +3.5GB RAM. Esto los agrupa = decenas de procesos menos.
:: ============================================================
echo [5/9] Agrupando procesos svchost (menos procesos, menos RAM)...
reg add "HKLM\SYSTEM\CurrentControlSet\Control" /v SvcHostSplitThresholdInKB /t REG_DWORD /d 0x4000000 /f >nul 2>&1

:: ============================================================
:: 6. ENERGIA -> ALTO RENDIMIENTO + SIN HIBERNACION
:: ============================================================
echo [6/9] Plan de energia alto rendimiento...
powercfg -setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c >nul 2>&1
:: Hibernacion fuera (libera varios GB de disco, hiberfil.sys)
powercfg -h off >nul 2>&1

:: ============================================================
:: 7. DESINSTALAR BLOATWARE (apps preinstaladas que nadie usa)
:: ============================================================
echo [7/9] Quitando bloatware preinstalado (puede tardar 1-2 min)...
powershell -Command "$apps = @('Microsoft.3DBuilder','Microsoft.BingNews','Microsoft.BingWeather','Microsoft.GetHelp','Microsoft.Getstarted','Microsoft.Messaging','Microsoft.Microsoft3DViewer','Microsoft.MicrosoftOfficeHub','Microsoft.MicrosoftSolitaireCollection','Microsoft.MixedReality.Portal','Microsoft.OneConnect','Microsoft.People','Microsoft.Print3D','Microsoft.SkypeApp','Microsoft.Wallet','Microsoft.WindowsFeedbackHub','Microsoft.YourPhone','Microsoft.ZuneMusic','Microsoft.ZuneVideo','Microsoft.XboxApp','Microsoft.XboxTCUI','Microsoft.XboxGameOverlay','Microsoft.XboxGamingOverlay'); foreach ($a in $apps) { Get-AppxPackage -AllUsers $a 2>$null | Remove-AppxPackage -ErrorAction SilentlyContinue }" >nul 2>&1

:: ============================================================
:: 8. LIMPIEZA DE TEMPORALES Y CACHE
:: ============================================================
echo [8/9] Limpiando archivos temporales...
del /f /s /q "%TEMP%\*.*" >nul 2>&1
del /f /s /q "C:\Windows\Temp\*.*" >nul 2>&1
del /f /s /q "C:\Windows\Prefetch\*.*" >nul 2>&1
ipconfig /flushdns >nul 2>&1

:: ============================================================
:: 9. AJUSTES FINALES DE MEMORIA
:: ============================================================
echo [9/9] Ajustes de memoria...
:: No vaciar cache de sistema agresivamente, prioridad a programas
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v LargeSystemCache /t REG_DWORD /d 0 /f >nul 2>&1
:: Desactivar Ndu (fuga de RAM conocida en Win10)
reg add "HKLM\SYSTEM\ControlSet001\Services\Ndu" /v Start /t REG_DWORD /d 4 /f >nul 2>&1

echo.
echo  ============================================
echo   LISTO! OPTIMIZACION COMPLETADA
echo  ============================================
echo.
echo  - Servicios pesados desactivados (SysMain, Search, telemetria)
echo  - Bloatware eliminado
echo  - Efectos visuales al minimo
echo  - Procesos svchost agrupados
echo  - Temporales limpiados
echo.
echo  IMPORTANTE: Reinicia la PC para aplicar todo.
echo  Si algo falla, usa el punto de restauracion "Antes de OptimizadorPC".
echo.
echo  Presiona ENTER para reiniciar ahora, o cierra la ventana para reiniciar despues.
pause >nul
shutdown /r /t 5 /c "Reiniciando para aplicar optimizaciones..."
