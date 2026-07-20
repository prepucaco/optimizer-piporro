@echo off
:: ============================================================
::  OPTIMIZADOR UI EXTREMO - Windows 10
::  RENDIMIENTO PURO: quita sombras, animaciones, miniaturas,
::  transparencias, fondo de pantalla y suavizado.
::  La PC se ve fea pero responde al instante.
:: ============================================================
title Optimizador UI - RENDIMIENTO PURO
color 0C

echo.
echo  ============================================
echo   OPTIMIZADOR UI - MODO RENDIMIENTO PURO
echo  ============================================
echo.
echo  AVISO: esto sacrifica TODA la apariencia bonita:
echo   - Sin animaciones, sombras ni transparencias
echo   - Sin miniaturas de fotos/videos (solo iconos)
echo   - Sin fondo de pantalla (color solido negro)
echo   - Sin suavizado de letras
echo.
echo  Todo es reversible desde Configuracion.
echo  Presiona ENTER para aplicar...
pause >nul

:: ============================================================
:: 1. EFECTOS VISUALES: TODO APAGADO
:: ============================================================
echo [1/7] Apagando TODOS los efectos visuales...

:: Modo "Ajustar para obtener el mejor rendimiento"
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v VisualFXSetting /t REG_DWORD /d 2 /f >nul 2>&1

:: Mascara maestra: apaga animaciones de menus, tooltips, fades,
:: sombras del puntero, suavizado de scroll... todo de un golpe
reg add "HKCU\Control Panel\Desktop" /v UserPreferencesMask /t REG_BINARY /d 9000038010000000 /f >nul 2>&1

:: Animacion de minimizar/maximizar ventanas
reg add "HKCU\Control Panel\Desktop\WindowMetrics" /v MinAnimate /t REG_SZ /d 0 /f >nul 2>&1
:: Animaciones de la barra de tareas
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v TaskbarAnimations /t REG_DWORD /d 0 /f >nul 2>&1
:: Arrastrar ventanas mostrando solo el borde
reg add "HKCU\Control Panel\Desktop" /v DragFullWindows /t REG_SZ /d 0 /f >nul 2>&1
:: Menus sin retraso
reg add "HKCU\Control Panel\Desktop" /v MenuShowDelay /t REG_SZ /d 0 /f >nul 2>&1
:: Sombras de iconos y seleccion translucida fuera
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v ListviewAlphaSelect /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v ListviewShadow /t REG_DWORD /d 0 /f >nul 2>&1
:: Transparencias fuera
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v EnableTransparency /t REG_DWORD /d 0 /f >nul 2>&1
:: Aero Peek fuera
reg add "HKCU\Software\Microsoft\Windows\DWM" /v EnableAeroPeek /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\DWM" /v AlwaysHibernateThumbnails /t REG_DWORD /d 0 /f >nul 2>&1

:: Suavizado de fuentes FUERA (las letras se ven pixeladas pero
:: la GPU integrada del Celeron trabaja menos)
reg add "HKCU\Control Panel\Desktop" /v FontSmoothing /t REG_SZ /d 0 /f >nul 2>&1

:: ============================================================
:: 2. SIN MINIATURAS NI FONDO DE PANTALLA
:: ============================================================
echo [2/7] Quitando miniaturas y fondo de pantalla...

:: Solo iconos, nunca miniaturas de fotos/videos (gran ahorro en carpetas llenas)
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v IconsOnly /t REG_DWORD /d 1 /f >nul 2>&1
:: No guardar cache de miniaturas
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v DisableThumbnailCache /t REG_DWORD /d 1 /f >nul 2>&1

:: Fondo de pantalla fuera -> color solido negro (0 RAM en wallpaper)
reg add "HKCU\Control Panel\Desktop" /v Wallpaper /t REG_SZ /d "" /f >nul 2>&1
reg add "HKCU\Control Panel\Colors" /v Background /t REG_SZ /d "0 0 0" /f >nul 2>&1

:: ============================================================
:: 3. BARRA DE TAREAS MINIMA
:: ============================================================
echo [3/7] Barra de tareas al minimo...

:: Iconos pequenos
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v TaskbarSmallIcons /t REG_DWORD /d 1 /f >nul 2>&1
:: Sin caja de busqueda (solo lupa)
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v SearchboxTaskbarMode /t REG_DWORD /d 1 /f >nul 2>&1
:: Sin vista de tareas, Cortana, contactos
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v ShowTaskViewButton /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v ShowCortanaButton /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People" /v PeopleBand /t REG_DWORD /d 0 /f >nul 2>&1
:: Sin noticias/clima (widget que come RAM)
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Feeds" /v ShellFeedsTaskbarViewMode /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Feeds" /v EnableFeeds /t REG_DWORD /d 0 /f >nul 2>&1

:: ============================================================
:: 4. MENU INICIO RAPIDO Y SIN ANUNCIOS
:: ============================================================
echo [4/7] Menu inicio sin anuncios y busqueda solo local...

reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SystemPaneSuggestionsEnabled /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SubscribedContent-338388Enabled /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v PreInstalledAppsEnabled /t REG_DWORD /d 0 /f >nul 2>&1
:: Busqueda SOLO en la PC, nada de Bing (mucho mas rapida)
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v BingSearchEnabled /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v CortanaConsent /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Policies\Microsoft\Windows\Explorer" /v DisableSearchBoxSuggestions /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\SearchSettings" /v IsDynamicSearchBoxEnabled /t REG_DWORD /d 0 /f >nul 2>&1

:: ============================================================
:: 5. EXPLORADOR DIRECTO
:: ============================================================
echo [5/7] Explorador de archivos directo...

:: Abrir en "Este equipo"
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v LaunchTo /t REG_DWORD /d 1 /f >nul 2>&1
:: Mostrar extensiones
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v HideFileExt /t REG_DWORD /d 0 /f >nul 2>&1
:: Sin recientes/frecuentes
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer" /v ShowRecent /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer" /v ShowFrequent /t REG_DWORD /d 0 /f >nul 2>&1
:: Sin anuncios de OneDrive/Office en el explorador
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v ShowSyncProviderNotifications /t REG_DWORD /d 0 /f >nul 2>&1

:: ============================================================
:: 6. NOTIFICACIONES Y TIPS FUERA
:: ============================================================
echo [6/7] Apagando tips y notificaciones...

reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SoftLandingEnabled /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SubscribedContent-310093Enabled /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\UserProfileEngagement" /v ScoobeSystemSettingEnabled /t REG_DWORD /d 0 /f >nul 2>&1

:: ============================================================
:: 7. REINICIAR EXPLORER
:: ============================================================
echo [7/7] Reiniciando Explorer (parpadea unos segundos, es normal)...
taskkill /f /im explorer.exe >nul 2>&1
start explorer.exe

echo.
echo  ============================================
echo   LISTO! MODO RENDIMIENTO PURO ACTIVADO
echo  ============================================
echo.
echo  - Cero animaciones, sombras y transparencias
echo  - Sin miniaturas (solo iconos) y sin cache de miniaturas
echo  - Fondo negro solido, sin wallpaper
echo  - Letras sin suavizado (se ven pixeladas, es normal)
echo  - Barra de tareas e inicio al minimo
echo  - Busqueda solo local, sin Bing
echo.
echo  Cierra sesion y vuelve a entrar para que aplique el 100%%
echo  (algunas cosas como las letras lo necesitan).
echo.
echo  PARA REVERTIR: Configuracion ^> Personalizacion, y en
echo  "Configuracion avanzada del sistema" ^> Rendimiento ^>
echo  "Dejar que Windows elija".
echo.
pause
