@echo off
title Installing Drivers OS v5.2 - Windows Edition
color 0A

:: ============================================
:: ИСПРАВЛЕНИЕ КОДИРОВКИ
:: ============================================
chcp 65001 >nul
set "PYTHONIOENCODING=utf-8"

:: ============================================
:: ВКЛЮЧЕНИЕ ОТЛОЖЕННОГО РАСКРЫТИЯ ПЕРЕМЕННЫХ
:: ============================================
setlocal EnableDelayedExpansion

:: ============================================
:: НАСТРОЙКИ
:: ============================================
set "VERSION=5.2"


:: Создание временной папки
if not exist "%TEMP_DIR%" mkdir "%TEMP_DIR%"

:: ============================================
:: ПРОВЕРКА ПРАВ АДМИНИСТРАТОРА
:: ============================================
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo ============================================
    echo   ТРЕБУЮТСЯ ПРАВА АДМИНИСТРАТОРА!
    echo ============================================
    echo.
    echo Запустите этот файл от имени администратора:
    echo 1. Нажмите правой кнопкой на файл
    echo 2. Выберите "Запуск от имени администратора"
    echo.
    pause
    exit /b
)


:: ============================================
:: ГЛАВНОЕ МЕНЮ
:: ============================================
:main_menu
cls
echo.
echo ================================================
echo   Installing Drivers OS v%VERSION% (Windows)
echo ================================================
echo.
echo   1) Установка драйверов видеокарты
echo   2) Установка драйвера аудио
echo   3) Установка драйверов для игр
echo   4) Установка сетевых драйверов
echo   5) Определение оборудования ПК
echo   6) ВЫХОД
echo.
echo ================================================
set /p choice="  Выберите пункт (1-6): "

if "%choice%"=="1" goto install_gpu
if "%choice%"=="2" goto install_audio
if "%choice%"=="3" goto install_gaming
if "%choice%"=="4" goto install_network
if "%choice%"=="5" goto detect_hardware
if "%choice%"=="6" goto exit_program

echo [!] Неверный выбор
timeout /t 2 >nul
goto main_menu

:: ============================================
:: 1) УСТАНОВКА ДРАЙВЕРОВ ВИДЕОКАРТЫ
:: ============================================
:install_gpu
cls
echo.
echo ================================================
echo   Установка драйверов видеокарты
echo ================================================
echo.
echo [!] ВАЖНО: Если вы в России, для доступа к
echo     официальным сайтам может потребоваться VPN
echo.
echo [i] Определение видеокарты...
echo -----------------------------------------------
wmic path win32_VideoController get name 2>nul | findstr /v "Name"
echo -----------------------------------------------
echo.
echo   Выберите производителя:
echo.
echo   1) NVIDIA (GeForce)
echo   2) AMD (Radeon)
echo   3) Intel (HD/UHD/Iris)
echo   4) Через Центр обновлений Windows
echo   5) Назад в меню
echo.
set /p gpu_choice="  Ваш выбор (1-5): "

if "%gpu_choice%"=="1" goto gpu_nvidia
if "%gpu_choice%"=="2" goto gpu_amd
if "%gpu_choice%"=="3" goto gpu_intel
if "%gpu_choice%"=="4" goto gpu_windows
if "%gpu_choice%"=="5" goto main_menu

echo [!] Неверный выбор
timeout /t 2 >nul
goto install_gpu

:: ============================================
:: NVIDIA
:: ============================================
:gpu_nvidia
cls
echo.
echo ================================================
echo   Загрузка драйвера NVIDIA
echo ================================================
echo.
echo [!] Для загрузки может потребоваться VPN
echo.
echo [i] Официальные ссылки:
echo     • Сайт:https://www.nvidia.com/en-us/geforce/drivers/
echo     • GeForce Experience:https://us.download.nvidia.com/nvapp/client/11.0.6.383/NVIDIA_app_v11.0.6.383.exe
echo.
echo -----------------------------------------------
echo   Что хотите загрузить?
echo.
echo   1) GeForce Experience (скачивание)
echo   2) Открыть страницу загрузки драйверов
echo   3) Назад
echo.
set /p nvidia_choice="  Ваш выбор (1-3): "

if "%nvidia_choice%"=="1" (
    echo.
    echo [i] Открываем страницу загрузки GeForce Experience...
    echo     Скачайте файл вручную
    start https://us.download.nvidia.com/nvapp/client/11.0.6.383/NVIDIA_app_v11.0.6.383.exe
) else if "%nvidia_choice%"=="2" (
    echo.
    echo [i] Открываем страницу загрузки драйверов...
    start https://www.nvidia.com/en-us/geforce/drivers/
) else if "%nvidia_choice%"=="3" (
    goto install_gpu
)

echo.
echo [i] Нажмите Enter для возврата в меню...
pause >nul
goto main_menu

:: ============================================
:: AMD
:: ============================================
:gpu_amd
cls
echo.
echo ================================================
echo   Загрузка драйвера AMD
echo ================================================
echo.
echo [!] Для загрузки может потребоваться VPN
echo.
echo [i] Официальные ссылки:
echo     • Сайт: https://www.amd.com/en/support/download/drivers.html
echo     • Auto-Detect: https://www.amd.com/support/download/automatic-detection
echo.
echo -----------------------------------------------
echo   Что хотите загрузить?
echo.
echo   1) AMD Software: Adrenalin Edition (скачивание)
echo   2) Открыть страницу загрузки драйверов
echo   3) Назад
echo.
set /p amd_choice="  Ваш выбор (1-3): "

if "%amd_choice%"=="1" (
    echo.
    echo [i] Открываем страницу загрузки AMD Software...
    echo     Скачайте последнюю версию вручную
    start https://disk.yandex.ru/d/z0X0ntpaNV_s3w
) else if "%amd_choice%"=="2" (
    echo.
    echo [i] Открыть страницу загрузки драйверов....
    start https://www.amd.com/en/support/download/drivers.html
) else if "%amd_choice%"=="3" (
    goto install_gpu
)

echo.
echo [i] Нажмите Enter для возврата в меню...
pause >nul
goto main_menu

:: ============================================
:: INTEL
:: ============================================
:gpu_intel
cls
echo.
echo ================================================
echo   Загрузка драйвера Intel
echo ================================================
echo.
echo [!] Для загрузки может потребоваться VPN
echo.
echo [i] Официальные ссылки:
echo     • Центр загрузок: https://www.intel.com/content/www/us/en/download-center/home.html
echo     • Intel DSA: https://dsadata.intel.com/installer
echo.
echo -----------------------------------------------
echo   Что хотите загрузить?
echo.
echo   1) Intel Driver and Support Assistant (скачивание)
echo   2) Открыть центр загрузок
echo   3) Назад
echo.
set /p intel_choice="  Ваш выбор (1-3): "

if "%intel_choice%"=="1" (
    echo.
    echo [i] Открываем страницу Intel DSA...
    start https://dsadata.intel.com/installer
) else if "%intel_choice%"=="2" (
    echo.
    echo [i] Открываем центр загрузок Intel...
    start https://www.intel.com/content/www/us/en/download-center/home.html
) else if "%intel_choice%"=="3" (
    goto install_gpu
)

echo.
echo [i] Нажмите Enter для возврата в меню...
pause >nul
goto main_menu

:: ============================================
:: WINDOWS UPDATE
:: ============================================
:gpu_windows
cls
echo.
echo ================================================
echo   Центр обновлений Windows
echo ================================================
echo.
echo [i] Открываем Центр обновлений...
echo     Нажмите "Проверить наличие обновлений"
echo.
start ms-settings:windowsupdate
echo.
echo [i] Нажмите Enter для возврата в меню...
pause >nul
goto main_menu

:: ============================================
:: 2) УСТАНОВКА ДРАЙВЕРА АУДИО
:: ============================================
:install_audio
cls
echo.
echo ================================================
echo   Установка драйвера аудио
echo ================================================
echo.

:: === ПОЛУЧЕНИЕ ИНФОРМАЦИИ ОБ АУДИО ===
echo [i] Проверка текущего аудиодрайвера...
echo -----------------------------------------------

:: Получаем аудио устройства через sounddev
set "AUDIO_FOUND=0"
for /f "skip=1 tokens=*" %%a in ('wmic sounddev get name 2^>nul') do (
    if not "%%a"=="" if not "%%a"=="Name" (
        echo Устройство: %%a
        set "AUDIO_FOUND=1"
    )
)

if !AUDIO_FOUND! equ 0 (
    echo Устройство: Не найдено
)

:: Получаем версию драйвера через driverquery
echo.
echo [i] Информация о драйвере:
echo -----------------------------------------------
driverquery /v /fo list 2>nul | findstr /i "audio sound realtek high definition" | findstr "Driver Version" > "%TEMP_DIR%\audio_drv.txt"

if exist "%TEMP_DIR%\audio_drv.txt" (
    for /f "tokens=2 delims=:" %%a in (%TEMP_DIR%\audio_drv.txt) do (
        set "DRV_VER=%%a"
        set "DRV_VER=!DRV_VER:~1!"
        echo Текущая версия: !DRV_VER!
    )
) else (
    echo Текущая версия: Не определена
)
del "%TEMP_DIR%\audio_drv.txt" 2>nul

:: === ПРОВЕРКА АКТУАЛЬНОСТИ ===
echo.
echo -----------------------------------------------
echo [i] Рекомендации по обновлению:
echo     • Если версия драйвера старше 2024 года — обновите
echo     • Если есть проблемы со звуком — обновите
echo     • Если всё работает — обновление не обязательно
echo.

:: === МЕНЮ ВЫБОРА ===
echo   Выберите действие:
echo.
echo   1) Realtek HD Audio (самый частый)
echo   2) Intel Smart Sound / HD Audio
echo   3) Через Центр обновлений Windows
echo   4) Назад в меню
echo.
set /p audio_choice="  Ваш выбор (1-4): "

if "%audio_choice%"=="1" (
    echo.
    echo [!] Для загрузки может потребоваться VPN
    echo [i] Открываем страницу загрузки Realtek...
    start https://www.realtek.com/en/component/zoo/category/high-definition-audio-codecs-software
    echo.
    echo [i] Инструкция:
    echo     1. Найдите "High Definition Audio Codecs"
    echo     2. Примите лицензию
    echo     3. Скачайте последнюю версию
) else if "%audio_choice%"=="2" (
    echo.
    echo [!] Для загрузки может потребоваться VPN
    echo [i] Открываем центр загрузок Intel...
    start https://www.intel.com/content/www/us/en/download-center/home.html
) else if "%audio_choice%"=="3" (
    echo.
    echo [i] Открываем Центр обновлений Windows...
    start ms-settings:windowsupdate
) else if "%audio_choice%"=="4" (
    goto main_menu
)

echo.
echo [i] Нажмите Enter для возврата в меню...
pause >nul
goto main_menu

:: ============================================
:: 3) УСТАНОВКА ДРАЙВЕРОВ ДЛЯ ИГР
:: ============================================
:install_gaming
cls
echo.
echo ================================================
echo   Установка компонентов для игр
echo ================================================
echo.
echo [i] Будут установлены 4 основных компонента:
echo     1. DirectX End-User Runtime
echo     2. Visual C++ Redistributable x64
echo     3. Visual C++ Redistributable x86
echo     4. .NET Framework 4.8
echo.
echo [!] Для загрузки может потребоваться VPN
echo.
echo -----------------------------------------------
set /p install_choice="  Начать установку? (y/n): "

if /i "%install_choice%"=="y" (
    echo.
    
    :: === КОМПОНЕНТ 1: DIRECTX ===
    echo ================================================
    echo   [1/4] DirectX End-User Runtime
    echo ================================================
    echo [i] Загрузка DirectX...
    
    set "DX_URL=https://download.microsoft.com/download/8/4/A/84A35BF1-DAFE-4AE8-82AF-AD2AE20B6B14/directx_Jun2010_redist.exe"
    set "DX_FILE=%USERPROFILE%\Desktop\directx_redist.exe"
    
    powershell -Command "$ProgressPreference='SilentlyContinue'; Invoke-WebRequest -Uri '%DX_URL%' -OutFile '%DX_FILE%' -UseBasicParsing" 2>nul
    
    if exist "%DX_FILE%" (
        echo [OK] DirectX загружен: %DX_FILE%
    ) else (
        echo [!] Не удалось загрузить автоматически
        echo [i] Открываем страницу загрузки...
        start https://www.microsoft.com/en-us/download/details.aspx?id=35
    )
    echo.
    
    :: === КОМПОНЕНТ 2: Visual C++ x64 ===
    echo ================================================
    echo   [2/4] Visual C++ Redistributable x64
    echo ================================================
    echo [i] Загрузка Visual C++ x64...
    
    set "VC64_URL=https://aka.ms/vs/17/release/vc_redist.x64.exe"
    set "VC64_FILE=%USERPROFILE%\Desktop\vc_redist.x64.exe"
    
    powershell -Command "$ProgressPreference='SilentlyContinue'; Invoke-WebRequest -Uri '%VC64_URL%' -OutFile '%VC64_FILE%' -UseBasicParsing" 2>nul
    
    if exist "%VC64_FILE%" (
        echo [OK] Visual C++ x64 загружен: %VC64_FILE%
    ) else (
        echo [!] Не удалось загрузить автоматически
        echo [i] Открываем страницу загрузки...
        start https://aka.ms/vs/17/release/vc_redist.x64.exe
    )
    echo.
    
    :: === КОМПОНЕНТ 3: Visual C++ x86 ===
    echo ================================================
    echo   [3/4] Visual C++ Redistributable x86
    echo ================================================
    echo [i] Загрузка Visual C++ x86...
    
    set "VC86_URL=https://aka.ms/vs/17/release/vc_redist.x86.exe"
    set "VC86_FILE=%USERPROFILE%\Desktop\vc_redist.x86.exe"
    
    powershell -Command "$ProgressPreference='SilentlyContinue'; Invoke-WebRequest -Uri '%VC86_URL%' -OutFile '%VC86_FILE%' -UseBasicParsing" 2>nul
    
    if exist "%VC86_FILE%" (
        echo [OK] Visual C++ x86 загружен: %VC86_FILE%
    ) else (
        echo [!] Не удалось загрузить автоматически
        echo [i] Открываем страницу загрузки...
        start https://aka.ms/vs/17/release/vc_redist.x86.exe
    )
    echo.
    
    :: === КОМПОНЕНТ 4: .NET Framework 4.8 ===
    echo ================================================
    echo   [4/4] .NET Framework 4.8
    echo ================================================
    echo [i] Загрузка .NET Framework 4.8...
    
    set "NET_URL=https://go.microsoft.com/fwlink/?LinkId=2085155"
    
    powershell -Command "$ProgressPreference='SilentlyContinue'; Invoke-WebRequest -Uri '%NET_URL%' -OutFile '%NET_FILE%' -UseBasicParsing" 2>nul
    
    if exist "%NET_FILE%" (
        echo [OK] .NET Framework 4.8 загружен: %NET_FILE%
    ) else (
        echo [!] Не удалось загрузить автоматически
        echo [i] Открываем страницу загрузки...
        start https://dotnet.microsoft.com/download/dotnet-framework/net48
    )
    echo.
    
    :: === ИТОГ ===
    echo ================================================
    echo [OK] Все компоненты обработаны!
    echo ================================================
    echo.
    echo [i] Файлы сохранены на рабочем столе:
    echo     • directx_redist.exe
    echo     • vc_redist.x64.exe
    echo     • vc_redist.x86.exe
    echo     • ndp48-installer.exe
    echo.
    echo [i] Установите их в указанном порядке
    echo.
    
    set /p run_all="  Запустить установку всех? (y/n): "
    if /i "%run_all%"=="y" (
        echo [i] Запуск установщиков по порядку...
        if exist "%DX_FILE%" (
            echo [→] Установка DirectX...
            start "" /wait "%DX_FILE%"
        )
        if exist "%VC64_FILE%" (
            echo [→] Установка Visual C++ x64...
            start "" /wait "%VC64_FILE%"
        )
        if exist "%VC86_FILE%" (
            echo [→] Установка Visual C++ x86...
            start "" /wait "%VC86_FILE%"
        )
        if exist "%NET_FILE%" (
            echo [→] Установка .NET Framework 4.8...
            start "" /wait "%NET_FILE%"
        )
        echo [OK] Все компоненты установлены!
    )
)

echo.
echo [i] Нажмите Enter для возврата в меню...
pause >nul
goto main_menu
:: ============================================
:: 4) УСТАНОВКА СЕТЕВЫХ ДРАЙВЕРОВ
:: ============================================
:install_network
cls
echo.
echo ================================================
echo   Сетевые драйверы (Wi-Fi/Bluetooth)
echo ================================================
echo.
echo [i] Сетевые адаптеры:
echo -----------------------------------------------
ipconfig /all | findstr "Description" | findstr /v "Microsoft"
echo -----------------------------------------------
echo.
echo   Выберите действие:
echo.
echo   1) Обновить драйвер (Центр обновлений)
echo   2) Открыть Диспетчер устройств
echo   3) Настройки Bluetooth
echo   4) Назад в меню
echo.
set /p net_choice="  Ваш выбор (1-4): "

if "%net_choice%"=="1" (
    start ms-settings:windowsupdate
) else if "%net_choice%"=="2" (
    devmgmt.msc
) else if "%net_choice%"=="3" (
    start ms-settings:bluetooth
) else if "%net_choice%"=="4" (
    goto main_menu
)

echo.
echo [i] Нажмите Enter для возврата в меню...
pause >nul
goto main_menu

:: ============================================
:: 5) ОПРЕДЕЛЕНИЕ ОБОРУДОВАНИЯ
:: ============================================
:detect_hardware
cls
echo.
echo ================================================
echo   Определение оборудования ПК/Ноутбука
echo ================================================
echo.

:: ============================================
:: СИСТЕМА
:: ============================================
echo [СИСТЕМА]
echo -----------------------------------------------

:: Шаг 1: Получаем ОС
set "val="
for /f "tokens=2 delims=:" %%a in ('systeminfo ^| findstr /C:"Имя ОС" /C:"OS Name"') do (
    if not defined val set "val=%%a"
)
if defined val (
    for /f "tokens=* delims= " %%b in ("!val!") do echo   ОС: %%b
)

:: Шаг 2: Получаем Версию
set "val="
for /f "tokens=2 delims=:" %%a in ('systeminfo ^| findstr /C:"Версия ОС" /C:"OS Version" ^| findstr /v "BIOS" ^| findstr /v "American"') do (
    if not defined val set "val=%%a"
)
if defined val (
    for /f "tokens=* delims= " %%b in ("!val!") do echo   Версия: %%b
)

:: Шаг 3: Получаем Тип системы
set "val="
for /f "tokens=2 delims=:" %%a in ('systeminfo ^| findstr /C:"Тип системы" /C:"System Type"') do (
    if not defined val set "val=%%a"
)
if defined val (
    for /f "tokens=* delims= " %%b in ("!val!") do echo   Тип: %%b
)

:: Шаг 4: Получаем Сборку ОС
set "val="
for /f "tokens=2 delims=:" %%a in ('systeminfo ^| findstr /C:"Сборка ОС" /C:"OS Build"') do (
    if not defined val set "val=%%a"
)
if defined val (
    for /f "tokens=* delims= " %%b in ("!val!") do echo   Сборка: %%b
)

echo.

:: ============================================
:: ПРОЦЕССОР
:: ============================================
echo [ПРОЦЕССОР]
echo -----------------------------------------------

:: Получаем информацию о процессоре
wmic cpu get Name /value 2>nul | find "=" > "%TEMP_DIR%\cpu_name.txt"
wmic cpu get NumberOfCores /value 2>nul | find "=" > "%TEMP_DIR%\cpu_cores.txt"
wmic cpu get NumberOfLogicalProcessors /value 2>nul | find "=" > "%TEMP_DIR%\cpu_threads.txt"

:: Читаем значения
set "CPU_NAME=" & set "CPU_CORES=" & set "CPU_THREADS="
for /f "tokens=2 delims==" %%a in (%TEMP_DIR%\cpu_name.txt) do set "CPU_NAME=%%a"
for /f "tokens=2 delims==" %%a in (%TEMP_DIR%\cpu_cores.txt) do set "CPU_CORES=%%a"
for /f "tokens=2 delims==" %%a in (%TEMP_DIR%\cpu_threads.txt) do set "CPU_THREADS=%%a"

:: Выводим
if defined CPU_NAME echo   Модель: !CPU_NAME!
if defined CPU_CORES echo   Ядер: !CPU_CORES!
if defined CPU_THREADS echo   Потоков: !CPU_THREADS!

:: Определяем производителя
if defined CPU_NAME (
    echo !CPU_NAME! | findstr /i "AMD" >nul 2>&1 && echo   Производитель: AMD
    echo !CPU_NAME! | findstr /i "Intel" >nul 2>&1 && echo   Производитель: Intel
)

:: Чистим временные файлы
del "%TEMP_DIR%\cpu_name.txt" "%TEMP_DIR%\cpu_cores.txt" "%TEMP_DIR%\cpu_threads.txt" 2>nul
echo.

:: ============================================
:: ВИДЕОКАРТА
:: ============================================
echo [ВИДЕОКАРТА]
echo -----------------------------------------------

:: Получаем информацию о видеокарте
wmic path win32_VideoController get Name /value 2>nul | find "=" > "%TEMP_DIR%\gpu.txt"

:: Читаем и выводим
set "GPU_NAME="
for /f "tokens=2 delims==" %%a in (%TEMP_DIR%\gpu.txt) do set "GPU_NAME=%%a"
if defined GPU_NAME echo   Модель: !GPU_NAME!

:: Определяем производителя
if defined GPU_NAME (
    echo !GPU_NAME! | findstr /i "NVIDIA" >nul 2>&1 && echo   Производитель: NVIDIA
    echo !GPU_NAME! | findstr /i "AMD" >nul 2>&1 && echo   Производитель: AMD
    echo !GPU_NAME! | findstr /i "Intel" >nul 2>&1 && echo   Производитель: Intel
)

del "%TEMP_DIR%\gpu.txt" 2>nul
echo.

:: ============================================
:: ПАМЯТЬ RAM
:: ============================================
echo [ПАМЯТЬ RAM]
echo -----------------------------------------------

set "TOTAL_MB=" & set "TOTAL_GB=" & set "FREE_MB=" & set "FREE_GB="
for /f "tokens=2 delims==" %%a in ('wmic OS get TotalVisibleMemorySize /value 2^>nul ^| find "="') do (
    set /a TOTAL_MB=%%a/1024
    set /a TOTAL_GB=%%a/1024/1024
)
for /f "tokens=2 delims==" %%a in ('wmic OS get FreePhysicalMemory /value 2^>nul ^| find "="') do (
    set /a FREE_MB=%%a/1024
    set /a FREE_GB=%%a/1024/1024
)
if defined TOTAL_MB echo   Всего: !TOTAL_MB! MB ^(!TOTAL_GB! GB^)
if defined FREE_MB echo   Доступно: !FREE_MB! MB ^(!FREE_GB! GB^)
echo.

:: ============================================
:: ДИСКИ
:: ============================================
echo [ДИСКИ]
echo -----------------------------------------------
wmic diskdrive get Model 2>nul | findstr /v "^$" | findstr /v "^Model" | findstr /v "^$"
echo.

:: ============================================
:: МАТЕРИНСКАЯ ПЛАТА
:: ============================================
echo [МАТЕРИНСКАЯ ПЛАТА]
echo -----------------------------------------------

:: Получаем информацию о материнской плате
wmic baseboard get Manufacturer /value 2>nul | find "=" > "%TEMP_DIR%\mb_manuf.txt"
wmic baseboard get Product /value 2>nul | find "=" > "%TEMP_DIR%\mb_product.txt"

:: Выводим только первые найденные значения
set "MB_MANUF=" & set "MB_PRODUCT="
for /f "tokens=2 delims==" %%a in (%TEMP_DIR%\mb_manuf.txt) do (
    if not defined MB_MANUF set "MB_MANUF=%%a"
)
for /f "tokens=2 delims==" %%a in (%TEMP_DIR%\mb_product.txt) do (
    if not defined MB_PRODUCT set "MB_PRODUCT=%%a"
)

if defined MB_MANUF echo   Производитель: !MB_MANUF!
if defined MB_PRODUCT echo   Модель: !MB_PRODUCT!

del "%TEMP_DIR%\mb_manuf.txt" "%TEMP_DIR%\mb_product.txt" 2>nul
echo.

echo ================================================
echo [i] Нажмите Enter для возврата в меню...
pause >nul
goto main_menu

:: ============================================
:: 6) ВЫХОД
:: ============================================
:exit_program
cls
echo.
echo ================================================
echo   Программа завершена!
echo ================================================
echo.
echo   Спасибо за использование
echo   Installing Drivers OS v%VERSION%
echo.
timeout /t 3 >nul
exit /b