@echo off
:: ============================================================
::  OPTIMIZADOR UI - Windows 10
::  Interfaz mas simple, limpia y rapida.
::  Un solo Enter. No necesita reiniciar (solo reinicia Explorer).
:: ============================================================
title Optimizador de Interfaz - Win10
color 0E

echo.
echo  ============================================
echo   OPTIMIZADOR DE INTERFAZ / UI - WIN10
echo  ============================================
echo.
echo  Deja la interfaz mas simple y ligera:
echo  barra de tareas limpia, menu inicio sin anuncios,
echo  explorador directo y sin animaciones pesadas.
echo.
echo  Presiona ENTER para aplicar...
pause >nul

:: ============================================================
:: 1. BARRA DE TAREAS LIMPIA
:: ============================================================
echo [1/6] Limpiando barra de tareas...

:: Quitar la caja de busqueda gigante (queda solo el icono de lupa)
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v SearchboxTaskbarMode /t REG_DWORD /d 1 /f >nul 2>&1

:: Quitar boton de Vista de tareas
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v ShowTaskViewButton /t REG_DWORD /d 0 /f >nul 2>&1

:: Quitar boton de Cortana
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v ShowCortanaButton /t REG_DWORD /d 0 /f >nul 2>&1

:: Quitar icono de Contactos (People)
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People" /v PeopleBand /t REG_DWORD /d 0 /f >nul 2>&1

:: Quitar Noticias e Intereses (el widget del clima que come RAM)
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Feeds" /v ShellFeedsTaskbarViewMode /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Feeds" /v EnableFeeds /t REG_DWORD /d 0 /f >nul 2>&1

:: Quitar "Conocer a Windows" / boton de escritorios
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v TaskbarMn /t REG_DWORD /d 0 /f >nul 2>&1

:: ============================================================
:: 2. MENU INICIO SIN ANUNCIOS NI SUGERENCIAS
:: ============================================================
echo [2/6] Limpiando menu inicio...

:: Sin apps sugeridas / promocionadas
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SystemPaneSuggestionsEnabled /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SubscribedContent-338388Enabled /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v PreInstalledAppsEnabled /t REG_DWORD /d 0 /f >nul 2>&1

:: Buscar SOLO en la PC, sin resultados de Bing/internet
:: (la busqueda del menu inicio se vuelve mucho mas rapida)
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v BingSearchEnabled /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v CortanaConsent /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Policies\Microsoft\Windows\Explorer" /v DisableSearchBoxSuggestions /t REG_DWORD /d 1 /f >nul 2>&1

:: Sin "destacados de busqueda" (imagenes/noticias en el buscador)
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\SearchSettings" /v IsDynamicSearchBoxEnabled /t REG_DWORD /d 0 /f >nul 2>&1

:: ============================================================
:: 3. EXPLORADOR DE ARCHIVOS MAS DIRECTO
:: ============================================================
echo [3/6] Simplificando explorador de archivos...

:: Abrir en "Este equipo" en vez de "Acceso rapido"
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v LaunchTo /t REG_DWORD /d 1 /f >nul 2>&1

:: Mostrar extensiones de archivos (.exe, .txt, etc.)
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v HideFileExt /t REG_DWORD /d 0 /f >nul 2>&1

:: No mostrar archivos recientes ni frecuentes en Acceso rapido
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer" /v ShowRecent /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer" /v ShowFrequent /t REG_DWORD /d 0 /f >nul 2>&1

:: Sin anuncios de OneDrive/Office dentro del explorador
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v ShowSyncProviderNotifications /t REG_DWORD /d 0 /f >nul 2>&1

:: ============================================================
:: 4. SIN ANIMACIONES NI TRANSPARENCIAS (UI instantanea)
::    Se mantienen fuentes suaves y miniaturas: se ve normal.
:: ============================================================
echo [4/6] Quitando animaciones y transparencias...

reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v EnableTransparency /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v TaskbarAnimations /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Control Panel\Desktop\WindowMetrics" /v MinAnimate /t REG_SZ /d 0 /f >nul 2>&1
reg add "HKCU\Control Panel\Desktop" /v MenuShowDelay /t REG_SZ /d 0 /f >nul 2>&1
reg add "HKCU\Control Panel\Desktop" /v DragFullWindows /t REG_SZ /d 0 /f >nul 2>&1
:: Sombras y efectos de listas fuera
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v ListviewAlphaSelect /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v ListviewShadow /t REG_DWORD /d 0 /f >nul 2>&1
:: Tooltips y ventanas sin animacion de "fade"
reg add "HKCU\Control Panel\Desktop" /v UserPreferencesMask /t REG_BINARY /d 9012038010000000 /f >nul 2>&1

:: ============================================================
:: 5. NOTIFICACIONES MAS TRANQUILAS
:: ============================================================
echo [5/6] Calmando notificaciones...

:: Sin tips ni sugerencias de Windows
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SoftLandingEnabled /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SubscribedContent-310093Enabled /t REG_DWORD /d 0 /f >nul 2>&1
:: Sin pantalla de "bienvenida" despues de actualizaciones
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\UserProfileEngagement" /v ScoobeSystemSettingEnabled /t REG_DWORD /d 0 /f >nul 2>&1

:: ============================================================
:: 6. REINICIAR EXPLORER PARA APLICAR TODO
:: ============================================================
echo [6/6] Reiniciando Explorer (la pantalla parpadea 2 segundos, es normal)...
taskkill /f /im explorer.exe >nul 2>&1
start explorer.exe

echo.
echo  ============================================
echo   LISTO! INTERFAZ SIMPLIFICADA
echo  ============================================
echo.
echo  - Barra de tareas: sin caja de busqueda, sin Cortana,
echo    sin vista de tareas, sin noticias/clima
echo  - Menu inicio: sin anuncios, busqueda solo local (mas rapida)
echo  - Explorador: abre en Este equipo, muestra extensiones
echo  - Sin animaciones ni transparencias
echo  - Menos notificaciones molestas
echo.
echo  Todo es reversible desde Configuracion si algo no te gusta.
echo.
pause
