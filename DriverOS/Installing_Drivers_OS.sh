#!/bin/bash

# Название: Installing Drivers OS v5.2 - Linux Edition
# Дистрибутив: Zorin OS / Ubuntu / Debian-based
# Автор: Bash Developer

# Цвета для вывода
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

# Настройки
VERSION="5.2"
REPORT_DIR="$HOME/hardware_reports"
TEMP_DIR="/tmp/DriversOS"

# Логирование
log() { echo -e "${GREEN}[✓]${NC} $1"; }
warn() { echo -e "${YELLOW}[!]${NC} $1"; }
error() { echo -e "${RED}[✗]${NC} $1" >&2; }
info() { echo -e "${CYAN}[i]${NC} $1"; }

# Проверка прав root
check_root() {
    if [[ $EUID -ne 0 ]]; then
        error "Требуются права суперпользователя (sudo)."
        error "Запустите через: sudo ./installing_drivers_os.sh"
        exit 1
    fi
}

# Инициализация
init_dirs() {
    mkdir -p "$REPORT_DIR" 2>/dev/null
    mkdir -p "$TEMP_DIR" 2>/dev/null
}

# ============================================
# ГЛАВНОЕ МЕНЮ
# ============================================
show_main_menu() {
    while true; do
        clear
        echo
        echo "==============================================="
        echo "  Installing Drivers OS v${VERSION} (Linux)"
        echo "==============================================="
        echo
        echo "  1) Установка драйверов видеокарты"
        echo "  2) Установка драйвера аудио"
        echo "  3) Установка драйверов для игр"
        echo "  4) Установка сетевых драйверов"
        echo "  5) Определение оборудования ПК"
        echo "  6) ВЫХОД"
        echo
        echo "==============================================="
        read -p "  Выберите пункт (1-6): " choice
        echo

        case $choice in
            1) install_gpu_drivers ;;
            2) install_audio_drivers ;;
            3) install_gaming_drivers ;;
            4) install_network_drivers ;;
            5) detect_hardware ;;
            6) exit_program ;;
            *) warn "Неверный выбор. Попробуйте снова." ; sleep 2 ;;
        esac
    done
}

# ============================================
# 1) УСТАНОВКА ДРАЙВЕРОВ ВИДЕОКАРТЫ
# ============================================
install_gpu_drivers() {
    clear
    echo
    echo "==============================================="
    echo "  Установка драйверов видеокарты"
    echo "==============================================="
    echo
    warn "ВАЖНО: Если вы в России, для доступа к"
    echo "  официальным сайтам может потребоваться VPN"
    echo
    info "Определение видеокарты..."
    echo "-----------------------------------------------"
    lspci 2>/dev/null | grep -i vga
    echo "-----------------------------------------------"
    echo
    echo "  Выберите производителя:"
    echo
    echo "  1) NVIDIA (GeForce)"
    echo "  2) AMD (Radeon)"
    echo "  3) Intel (HD/UHD/Iris)"
    echo "  4) Через репозитории системы"
    echo "  5) Назад в меню"
    echo
    read -p "  Ваш выбор (1-5): " gpu_choice

    case $gpu_choice in
        1) gpu_nvidia ;;
        2) gpu_amd ;;
        3) gpu_intel ;;
        4) gpu_system ;;
        5) return ;;
        *) warn "Неверный выбор" ; sleep 2 ; install_gpu_drivers ;;
    esac
}

gpu_nvidia() {
    clear
    echo
    echo "==============================================="
    echo "  Загрузка драйвера NVIDIA"
    echo "==============================================="
    echo
    warn "Для загрузки может потребоваться VPN"
    echo
    info "Официальные ссылки:"
    echo "  • Сайт: https://www.nvidia.com/en-us/geforce/drivers/"
    echo "  • NVIDIA App: https://www.nvidia.com/download/nvidia-app/"
    echo
    echo "-----------------------------------------------"
    echo "  Что хотите сделать?"
    echo
    echo "  1) Установить через репозиторий (рекомендуется)"
    echo "  2) Открыть страницу загрузки драйверов"
    echo "  3) Назад"
    echo
    read -p "  Ваш выбор (1-3): " nvidia_choice

    case $nvidia_choice in
        1)
            echo
            info "Обновление списков пакетов..."
            apt update -qq
            info "Поиск доступных драйверов..."
            ubuntu-drivers devices 2>/dev/null | grep nvidia || echo "  [i] Драйверы не найдены в репозитории"
            echo
            recommended=$(ubuntu-drivers devices 2>/dev/null | grep recommended | head -n1 | awk '{print $3}')
            if [[ -n "$recommended" ]]; then
                echo "  Рекомендуемый драйвер: ${GREEN}$recommended${NC}"
                read -p "  Установить? (y/n): " yn
                if [[ $yn == "y" || $yn == "Y" ]]; then
                    apt install -y "$recommended"
                    log "Драйвер $рекомендуемый установлен!"
                fi
            else
                read -p "  Введите название драйвера (например: nvidia-driver-550): " drv
                apt install -y "$drv" 2>/dev/null && log "Установлено" || warn "Ошибка установки"
            fi
            ;;
        2)
            echo
            info "Открываем страницу загрузки..."
            xdg-open "https://www.nvidia.com/en-us/geforce/drivers/" 2>/dev/null || \
            warn "Не удалось открыть браузер. Скопируйте ссылку вручную."
            ;;
        3)
            return
            ;;
    esac
    echo
    info "Нажмите Enter для возврата в меню..."
    read -r
}

gpu_amd() {
    clear
    echo
    echo "==============================================="
    echo "  Загрузка драйвера AMD"
    echo "==============================================="
    echo
    warn "Для загрузки может потребоваться VPN"
    echo
    info "Официальные ссылки:"
    echo "  • Сайт: https://www.amd.com/en/support"
    echo "  • Auto-Detect: https://www.amd.com/support/download/automatic-detection"
    echo
    echo "-----------------------------------------------"
    echo "  Что хотите сделать?"
    echo
    echo "  1) Установить через репозиторий (рекомендуется)"
    echo "  2) Открыть страницу загрузки драйверов"
    echo "  3) Назад"
    echo
    read -p "  Ваш выбор (1-3): " amd_choice

    case $amd_choice in
        1)
            echo
            info "Для AMD в Linux используется встроенный драйвер amdgpu."
            info "Он уже установлен в ядре системы."
            echo
            read -p "  Установить дополнительные утилиты (vainfo, clinfo)? (y/n): " extra
            if [[ $extra == "y" || $extra == "Y" ]]; then
                apt install -y vainfo clinfo mesa-vulkan-drivers 2>/dev/null
                log "Утилиты установлены"
            fi
            ;;
        2)
            echo
            info "Открываем страницу загрузки..."
            xdg-open "https://www.amd.com/en/support" 2>/dev/null || \
            warn "Не удалось открыть браузер"
            ;;
        3)
            return
            ;;
    esac
    echo
    info "Нажмите Enter для возврата в меню..."
    read -r
}

gpu_intel() {
    clear
    echo
    echo "==============================================="
    echo "  Загрузка драйвера Intel"
    echo "==============================================="
    echo
    warn "Для загрузки может потребоваться VPN"
    echo
    info "Официальные ссылки:"
    echo "  • Центр загрузок: https://www.intel.com/content/www/us/en/download-center/home.html"
    echo
    echo "-----------------------------------------------"
    echo "  Что хотите сделать?"
    echo
    echo "  1) Установить через репозиторий (рекомендуется)"
    echo "  2) Открыть центр загрузок"
    echo "  3) Назад"
    echo
    read -p "  Ваш выбор (1-3): " intel_choice

    case $intel_choice in
        1)
            echo
            info "Для Intel в Linux используется встроенный драйвер i915."
            info "Он уже установлен в ядре системы."
            echo
            read -p "  Установить дополнительные утилиты? (y/n): " extra
            if [[ $extra == "y" || $extra == "Y" ]]; then
                apt install -y intel-media-va-driver-non-free libgl1-mesa-dri 2>/dev/null
                log "Утилиты установлены"
            fi
            ;;
        2)
            echo
            info "Открываем центр загрузок..."
            xdg-open "https://www.intel.com/content/www/us/en/download-center/home.html" 2>/dev/null || \
            warn "Не удалось открыть браузер"
            ;;
        3)
            return
            ;;
    esac
    echo
    info "Нажмите Enter для возврата в меню..."
    read -r
}

gpu_system() {
    clear
    echo
    echo "==============================================="
    echo "  Установка через репозитории системы"
    echo "==============================================="
    echo
    info "Обновление списков пакетов..."
    apt update -qq
    info "Поиск и установка рекомендованных драйверов..."
    ubuntu-drivers autoinstall 2>/dev/null || apt install -y mesa-utils 2>/dev/null
    echo
    log "Готово! Драйверы установлены через систему."
    echo
    info "Нажмите Enter для возврата в меню..."
    read -r
}

# ============================================
# 2) УСТАНОВКА ДРАЙВЕРА АУДИО
# ============================================
install_audio_drivers() {
    clear
    echo
    echo "==============================================="
    echo "  Установка драйвера аудио"
    echo "==============================================="
    echo
    info "Проверка текущего аудиодрайвера..."
    echo "-----------------------------------------------"
    
    # Получаем аудио устройства
    if command -v lspci &>/dev/null; then
        lspci 2>/dev/null | grep -i audio | while read -r line; do
            echo "  Устройство: $line"
        done
    fi
    
    # Проверяем PulseAudio/PipeWire
    if command -v pactl &>/dev/null; then
        echo "  Сервер звука: PulseAudio"
    elif command -v pw-cli &>/dev/null; then
        echo "  Сервер звука: PipeWire"
    else
        echo "  Сервер звука: Не определён"
    fi
    echo
    echo "-----------------------------------------------"
    info "Рекомендации по обновлению:"
    echo "  • Если версия драйвера старше 2024 года — обновите"
    echo "  • Если есть проблемы со звуком — обновите"
    echo "  • Если всё работает — обновление не обязательно"
    echo
    echo "  Выберите действие:"
    echo
    echo "  1) Realtek HD Audio (самый частый)"
    echo "  2) Intel Smart Sound / HD Audio"
    echo "  3) Через репозитории системы"
    echo "  4) Назад в меню"
    echo
    read -p "  Ваш выбор (1-4): " audio_choice

    case $audio_choice in
        1)
            echo
            warn "Для загрузки может потребоваться VPN"
            info "Открываем страницу Realtek..."
            xdg-open "https://www.realtek.com/en/component/zoo/category/high-definition-audio-codecs-software" 2>/dev/null
            echo
            info "Инструкция:"
            echo "  1. Найдите 'High Definition Audio Codecs'"
            echo "  2. Примите лицензию"
            echo "  3. Скачайте последнюю версию"
            ;;
        2)
            echo
            warn "Для загрузки может потребоваться VPN"
            info "Открываем центр загрузок Intel..."
            xdg-open "https://www.intel.com/content/www/us/en/download-center/home.html" 2>/dev/null
            ;;
        3)
            echo
            info "Установка базовых аудиокомпонентов..."
            apt update -qq
            apt install -y alsa-base alsa-utils pulseaudio pavucontrol 2>/dev/null
            log "Аудиокомпоненты установлены"
            ;;
        4)
            return
            ;;
    esac
    echo
    info "Нажмите Enter для возврата в меню..."
    read -r
}

# ============================================
# 3) УСТАНОВКА ДРАЙВЕРОВ ДЛЯ ИГР
# ============================================
install_gaming_drivers() {
    clear
    echo
    echo "==============================================="
    echo "  Установка компонентов для игр"
    echo "==============================================="
    echo
    info "Будут установлены 4 основных компонента:"
    echo "  1. Vulkan Runtime"
    echo "  2. Mesa 3D Graphics Library"
    echo "  3. Steam Runtime Libraries"
    echo "  4. GameMode (оптимизация)"
    echo
    warn "Для загрузки может потребоваться VPN"
    echo
    echo "-----------------------------------------------"
    read -p "  Начать установку? (y/n): " install_choice

    if [[ $install_choice == "y" || $install_choice == "Y" ]]; then
        echo
        apt update -qq
        
        # Компонент 1: Vulkan
        echo "==============================================="
        echo "  [1/4] Vulkan Runtime"
        echo "==============================================="
        info "Установка Vulkan..."
        apt install -y mesa-vulkan-drivers vulkan-tools libvulkan1 2>/dev/null && \
        log "Vulkan установлен" || warn "Не удалось установить Vulkan"
        echo
        
        # Компонент 2: Mesa 3D
        echo "==============================================="
        echo "  [2/4] Mesa 3D Graphics Library"
        echo "==============================================="
        info "Установка Mesa..."
        apt install -y libgl1-mesa-glx libgl1-mesa-dri mesa-utils 2>/dev/null && \
        log "Mesa установлен" || warn "Не удалось установить Mesa"
        echo
        
        # Компонент 3: Steam Libraries
        echo "==============================================="
        echo "  [3/4] Steam Runtime Libraries"
        echo "==============================================="
        info "Установка библиотек Steam..."
        apt install -y steam-devices libsdl2-2.0-0 2>/dev/null && \
        log "Библиотеки установлены" || warn "Не удалось установить"
        echo
        
        # Компонент 4: GameMode
        echo "==============================================="
        echo "  [4/4] GameMode (оптимизация)"
        echo "==============================================="
        info "Установка GameMode..."
        apt install -y gamemode goverlay 2>/dev/null && \
        log "GameMode установлен" || warn "Не удалось установить"
        echo
        
        # Итог
        echo "==============================================="
        log "Все компоненты обработаны!"
        echo "==============================================="
        echo
        info "Установите игры через Steam, Lutris или Heroic"
        echo
    fi
    info "Нажмите Enter для возврата в меню..."
    read -r
}

# ============================================
# 4) УСТАНОВКА СЕТЕВЫХ ДРАЙВЕРОВ
# ============================================
install_network_drivers() {
    clear
    echo
    echo "==============================================="
    echo "  Сетевые драйверы (Wi-Fi/Bluetooth)"
    echo "==============================================="
    echo
    info "Сетевые адаптеры:"
    echo "-----------------------------------------------"
    lspci 2>/dev/null | grep -iE "network|ethernet" || echo "  Не найдено"
    echo "-----------------------------------------------"
    echo
    echo "  Выберите действие:"
    echo
    echo "  1) Обновить драйвер (репозитории)"
    echo "  2) Открыть настройки сети"
    echo "  3) Настройки Bluetooth"
    echo "  4) Назад в меню"
    echo
    read -p "  Ваш выбор (1-4): " net_choice

    case $net_choice in
        1)
            info "Установка пакетов прошивок..."
            apt update -qq
            apt install -y linux-firmware firmware-linux-free firmware-realtek firmware-iwlwifi 2>/dev/null
            log "Проприетарные прошивки установлены"
            ;;
        2)
            xdg-open "nm-connection-editor" 2>/dev/null || \
            xdg-open "gnome-control-center network" 2>/dev/null || \
            warn "Не удалось открыть настройки сети"
            ;;
        3)
            xdg-open "bluetooth-manager" 2>/dev/null || \
            xdg-open "gnome-control-center bluetooth" 2>/dev/null || \
            warn "Не удалось открыть настройки Bluetooth"
            ;;
        4)
            return
            ;;
    esac
    echo
    info "Нажмите Enter для возврата в меню..."
    read -r
}

# ============================================
# 5) ОПРЕДЕЛЕНИЕ ОБОРУДОВАНИЯ
# ============================================
detect_hardware() {
    clear
    echo
    echo "==============================================="
    echo "  Определение оборудования ПК/Ноутбука"
    echo "==============================================="
    echo

    # СИСТЕМА
    echo "[СИСТЕМА]"
    echo "-----------------------------------------------"
    if [[ -f /etc/os-release ]]; then
        source /etc/os-release
        echo "  ОС: $PRETTY_NAME"
    fi
    echo "  Версия ядра: $(uname -r)"
    echo "  Архитектура: $(uname -m)"
    echo "  Сборка: $(lsb_release -rs 2>/dev/null || echo 'N/A')"
    echo

    # ПРОЦЕССОР
    echo "[ПРОЦЕССОР]"
    echo "-----------------------------------------------"
    if command -v lscpu &>/dev/null; then
        cpu_name=$(lscpu | grep "Model name" | cut -d':' -f2 | xargs)
        cpu_cores=$(lscpu | grep "^CPU(s):" | cut -d':' -f2 | xargs)
        if [[ -n "$cpu_name" ]]; then
            echo "  Модель: $cpu_name"
            echo "  Ядер: $cpu_cores"
            if echo "$cpu_name" | grep -qi "amd"; then
                echo "  Производитель: AMD"
            elif echo "$cpu_name" | grep -qi "intel"; then
                echo "  Производитель: Intel"
            fi
        else
            echo "  Информация недоступна"
        fi
    else
        echo "  [!] lscpu не установлен"
    fi
    echo

    # ВИДЕОКАРТА
    echo "[ВИДЕОКАРТА]"
    echo "-----------------------------------------------"
    gpu_info=$(lspci 2>/dev/null | grep -i vga | head -n1)
    if [[ -n "$gpu_info" ]]; then
        echo "  Модель: ${gpu_info#*: }"
        if echo "$gpu_info" | grep -qi "nvidia"; then
            echo "  Производитель: NVIDIA"
            # Проверяем установленный драйвер
            if command -v nvidia-smi &>/dev/null; then
                driver_ver=$(nvidia-smi --query-gpu=driver_version --format=csv,noheader,nounits 2>/dev/null)
                echo "  Драйвер: NVIDIA $driver_ver (установлен)"
            else
                echo "  Драйвер: nouveau (открытый) или не установлен"
            fi
        elif echo "$gpu_info" | grep -qi "amd\|ati"; then
            echo "  Производитель: AMD"
            echo "  Драйвер: amdgpu (встроенный в ядро)"
        elif echo "$gpu_info" | grep -qi "intel"; then
            echo "  Производитель: Intel"
            echo "  Драйвер: i915 (встроенный в ядро)"
        fi
    else
        echo "  Не найдена"
    fi
    echo

    # ПАМЯТЬ
    echo "[ПАМЯТЬ RAM]"
    echo "-----------------------------------------------"
    if command -v free &>/dev/null; then
        total_mem_kb=$(free | awk '/^Mem:/{print $2}')
        avail_mem_kb=$(free | awk '/^Mem:/{print $7}')
        if [[ -n "$total_mem_kb" && "$total_mem_kb" != "0" ]]; then
            total_mem_mb=$((total_mem_kb / 1024))
            avail_mem_mb=$((avail_mem_kb / 1024))
            total_mem_gb=$((total_mem_mb / 1024))
            avail_mem_gb=$((avail_mem_mb / 1024))
            echo "  Всего: ${total_mem_mb} MB (${total_mem_gb} GB)"
            echo "  Доступно: ${avail_mem_mb} MB (${avail_mem_gb} GB)"
        else
            echo "  Информация недоступна"
        fi
    else
        echo "  [!] free не установлен"
    fi
    echo

    # ДИСКИ
    echo "[ДИСКИ]"
    echo "-----------------------------------------------"
    if command -v lsblk &>/dev/null; then
        lsblk -d -o NAME,SIZE,MODEL 2>/dev/null | grep -v "^NAME" | while read -r line; do
            if [[ -n "$line" ]]; then
                echo "  $line"
            fi
        done
    else
        echo "  [!] lsblk не установлен"
    fi
    echo

    # МАТЕРИНСКАЯ ПЛАТА
    echo "[МАТЕРИНСКАЯ ПЛАТА]"
    echo "-----------------------------------------------"
    if command -v dmidecode &>/dev/null; then
        manufacturer=$(dmidecode -s system-manufacturer 2>/dev/null)
        product=$(dmidecode -s system-product-name 2>/dev/null)
        if [[ -n "$manufacturer" ]]; then
            echo "  Производитель: $manufacturer"
        fi
        if [[ -n "$product" ]]; then
            echo "  Модель: $product"
        fi
    else
        echo "  [i] Установите dmidecode для подробной информации"
        echo "      sudo apt install dmidecode"
    fi
    echo

    echo "==============================================="
    info "Нажмите Enter для возврата в меню..."
    read -r
}

# ============================================
# 6) ВЫХОД
# ============================================
exit_program() {
    clear
    echo
    echo "==============================================="
    echo "  Программа завершена!"
    echo "==============================================="
    echo
    echo "  Спасибо за использование"
    echo "  Installing Drivers OS v${VERSION}"
    echo
    sleep 2
    exit 0
}

# ============================================
# ЗАПУСК
# ============================================
main() {
    clear
    echo -e "${GREEN}Запуск Installing Drivers OS v${VERSION}...${NC}"
    sleep 1
    check_root
    init_dirs
    show_main_menu
}

main "$@"#!/bin/bash

# Название: Installing_Drivers_OS
# Версия: 5.1 (Исправление отображения RAM и возврата в меню)
# Автор: Bash Developer for Zorin OS

# ОТКЛЮЧАЕМ жесткий выход при ошибках внутри функций, чтобы скрипт не вылетал
set +e 

# Цвета
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m'

# Папка для отчётов
REPORT_DIR="$HOME/hardware_reports"

# Логирование
log() { echo -e "${GREEN}[✓]${NC} $1"; }
warn() { echo -e "${YELLOW}[!]${NC} $1"; }
error() { echo -e "${RED}[✗]${NC} $1" >&2; }
info() { echo -e "${CYAN}[i]${NC} $1"; }

# Проверка root
check_root() {
    if [[ $EUID -ne 0 ]]; then
        error "Требуются права суперпользователя (sudo)."
        error "Запустите: sudo ./installing_drivers_os.sh"
        exit 1
    fi
}

# Инициализация папки отчётов
init_report_dir() {
    if [[ ! -d "$REPORT_DIR" ]]; then
        mkdir -p "$REPORT_DIR"
        chmod 755 "$REPORT_DIR" 2>/dev/null
    fi
}

# Определение GPU
detect_gpu() {
    if lspci 2>/dev/null | grep -i vga | grep -i nvidia > /dev/null; then
        echo "nvidia"
    elif lspci 2>/dev/null | grep -i vga | grep -i amd\|ati > /dev/null; then
        echo "amd"
    elif lspci 2>/dev/null | grep -i vga | grep -i intel > /dev/null; then
        echo "intel"
    else
        echo "unknown"
    fi
}

# ============================================
# ФУНКЦИЯ: Определение оборудования (ИСПРАВЛЕНО)
# ============================================
detect_hardware() {
    clear
    echo -e "${BLUE}=========================================${NC}"
    echo -e "${BLUE}   Определение оборудования ПК/Ноутбука  ${NC}"
    echo -e "${BLUE}=========================================${NC}"
    echo

    # 1. СИСТЕМА
    echo -e "${WHITE}🖥  СИСТЕМА:${NC}"
    echo "-------------------------------------------"
    if [ -f /etc/os-release ]; then
        source /etc/os-release
        echo "ОС: $PRETTY_NAME"
    else
        echo "ОС: Linux (информация недоступна)"
    fi
    echo "Ядро: $(uname -r)"
    echo "Время работы: $(uptime -p 2>/dev/null || echo 'Неизвестно')"
    echo

    # 2. ПРОЦЕССОР
    echo -e "${WHITE}⚙️  ПРОЦЕССОР:${NC}"
    echo "-------------------------------------------"
    cpu_info=$(lscpu 2>/dev/null | grep "Model name" | cut -d':' -f2 | xargs)
    cpu_cores=$(lscpu 2>/dev/null | grep "^CPU(s):" | cut -d':' -f2 | xargs)
    
    if [[ -n "$cpu_info" ]]; then
        echo "Модель: $cpu_info"
        echo "Ядер: $cpu_cores"
    else
        echo "Информация о процессоре недоступна"
    fi
    echo

    # 3. ВИДЕОКАРТА
    echo -e "${WHITE}🎮 ВИДЕОКАРТА:${NC}"
    echo "-------------------------------------------"
    gpu_info=$(lspci 2>/dev/null | grep -i vga)
    if [[ -n "$gpu_info" ]]; then
        echo "$gpu_info"
    else
        echo "Видеокарта не обнаружена (или виртуальная машина)"
    fi
    
    gpu=$(detect_gpu)
    echo -e "Тип: ${GREEN}${gpu^^}${NC}"
    
    if [[ "$gpu" == "nvidia" ]]; then
        if command -v nvidia-smi &>/dev/null; then
            echo "Драйвер: $(nvidia-smi --query-gpu=driver_version --format=csv,noheader 2>/dev/null)"
        else
            echo "Драйвер NVIDIA: ${YELLOW}Не установлен${NC}"
        fi
    fi
    echo

    # 4. ПАМЯТЬ (RAM) - ИСПРАВЛЕНО
    echo -e "${WHITE}🧠 ПАМЯТЬ (RAM):${NC}"
    echo "-------------------------------------------"
    
    # Попытка 1: команда free
    ram_info=$(free -h 2>/dev/null | grep -E "^Mem:")
    
    if [[ -n "$ram_info" ]]; then
        echo "$ram_info"
    else
        # Попытка 2: чтение из /proc/meminfo (если free не сработал)
        mem_total_kb=$(grep MemTotal /proc/meminfo 2>/dev/null | awk '{print $2}')
        mem_avail_kb=$(grep MemAvailable /proc/meminfo 2>/dev/null | awk '{print $2}')
        
        if [[ -n "$mem_total_kb" ]]; then
            mem_total_gb=$((mem_total_kb / 1024 / 1024))
            mem_avail_gb=$((mem_avail_kb / 1024 / 1024))
            echo "Всего: ${mem_total_gb} GB | Доступно: ${mem_avail_gb} GB"
        else
            echo "Информация о памяти недоступна"
        fi
    fi
    echo

    # 5. ДИСКИ
    echo -e "${WHITE}💾 ДИСКИ:${NC}"
    echo "-------------------------------------------"
    lsblk -d -o NAME,SIZE,TYPE,MODEL 2>/dev/null | head -10 || echo "Список дисков недоступен"
    echo

    # 6. МАТЕРИНСКАЯ ПЛАТА
    echo -e "${WHITE}🔌 МАТЕРИНСКАЯ ПЛАТА:${NC}"
    echo "-------------------------------------------"
    if command -v dmidecode &>/dev/null; then
        echo "Производитель: $(dmidecode -s system-manufacturer 2>/dev/null || echo 'Неизвестно')"
        echo "Модель: $(dmidecode -s system-product-name 2>/dev/null || echo 'Неизвестно')"
    else
        echo "dmidecode не установлен (требуется для подробной информации)"
    fi
    echo

    # 7. СЕТЬ
    echo -e "${WHITE}🌐 СЕТЬ:${NC}"
    echo "-------------------------------------------"
    net_info=$(lspci 2>/dev/null | grep -iE "ethernet|network")
    if [[ -n "$net_info" ]]; then
        echo "$net_info"
    else
        echo "Сетевые адаптеры PCI не найдены"
    fi
    echo

    echo -e "${BLUE}=========================================${NC}"
    
    # Сохранение отчёта
    read -p "💾 Сохранить отчёт в файл? (y/n): " save_report
    if [[ $save_report == "y" || $save_report == "Y" ]]; then
        init_report_dir
        report_file="$REPORT_DIR/hardware_report_$(date +%Y%m%d_%H%M%S).txt"
        {
            echo "=== ОТЧЁТ ОБ ОБОРУДОВАНИИ ==="
            echo "Дата: $(date)"
            echo "ОС: $PRETTY_NAME"
            echo "Ядро: $(uname -r)"
            echo ""
            echo "=== CPU ==="
            lscpu 2>/dev/null
            echo ""
            echo "=== GPU ==="
            lspci 2>/dev/null | grep -i vga
            echo ""
            echo "=== RAM ==="
            free -h 2>/dev/null
            echo ""
            echo "=== STORAGE ==="
            lsblk -d -o NAME,SIZE,TYPE,MODEL 2>/dev/null
        } > "$report_file" 2>/dev/null
        log "Отчёт сохранён: $report_file"
    fi

    echo
    # ГАРАНТИРОВАННЫЙ ВОЗВРАТ В МЕНЮ
    info "Нажмите Enter для возврата в ГЛАВНОЕ МЕНЮ..."
    read -r dummy_input
    # Функция завершается, управление возвращается в show_main_menu
}

# ============================================
# ФУНКЦИЯ: Просмотр отчётов
# ============================================
view_reports() {
    clear
    echo -e "${BLUE}=========================================${NC}"
    echo -e "${BLUE}   Просмотр сохранённых отчётов          ${NC}"
    echo -e "${BLUE}=========================================${NC}"
    echo

    init_report_dir
    
    report_count=$(ls -1 "$REPORT_DIR"/*.txt 2>/dev/null | wc -l)
    
    if [[ $report_count -eq 0 ]]; then
        warn "Нет сохранённых отчётов."
        echo "Сначала создайте отчёт в пункте 5) Определение оборудования"
    else
        echo -e "${WHITE}Найдено отчётов: ${GREEN}$report_count${NC}"
        echo "-------------------------------------------"
        echo -e "${CYAN}Последние 5 отчётов:${NC}"
        ls -lht "$REPORT_DIR"/*.txt 2>/dev/null | head -5 | awk '{print $9, "-", $6, $7, $8}'
        echo "-------------------------------------------"
        echo
        read -p "Показать последний отчёт? (y/n): " open_last
        if [[ $open_last == "y" || $open_last == "Y" ]]; then
            latest_report=$(ls -t "$REPORT_DIR"/*.txt 2>/dev/null | head -1)
            if [[ -n "$latest_report" ]]; then
                echo
                echo -e "${CYAN}=== Содержимое отчёта ===${NC}"
                echo "Файл: $latest_report"
                echo "-------------------------------------------"
                cat "$latest_report"
                echo "-------------------------------------------"
            fi
        fi
    fi

    echo
    info "Нажмите Enter для возврата в ГЛАВНОЕ МЕНЮ..."
    read -r dummy_input
}

# ============================================
# ФУНКЦИЯ: Установка драйверов GPU
# ============================================
install_gpu_drivers() {
    clear
    echo -e "${BLUE}--- Установка драйверов видеокарты ---${NC}"
    echo
    gpu=$(detect_gpu)
    [[ "$gpu" == "unknown" ]] && read -p "Введите тип (nvidia/amd/intel): " gpu

    echo -e "Выбрано: ${GREEN}${gpu^^}${NC}"
    echo

    case $gpu in
        nvidia)
            apt update -qq
            recommended=$(ubuntu-drivers devices 2>/dev/null | grep "recommended" | head -n1 | awk '{print $3}')
            if [[ -n "$recommended" ]]; then
                echo -e "Рекомендуемый: ${GREEN}$recommended${NC}"
                read -p "Установить? (y/n): " yn
                [[ $yn == "y" || $yn == "Y" ]] && apt install -y "$recommended" && log "Установлено!" || {
                    read -p "Введите название драйвера: " drv
                    apt install -y "$drv"
                }
            else
                read -p "Введите версию драйвера: " drv
                apt install -y "$drv"
            fi
            ;;
        amd|intel)
            log "Встроенный драйвер уже активен."
            read -p "Установить утилиты (vainfo, clinfo)? (y/n): " extra
            [[ $extra == "y" || $extra == "Y" ]] && apt install -y vainfo clinfo
            ;;
        *)
            error "Неподдерживаемый GPU"
            ;;
    esac
    echo
    info "Нажмите Enter для возврата в ГЛАВНОЕ МЕНЮ..."
    read -r dummy_input
}

# ============================================
# ФУНКЦИЯ: Установка аудиодрайверов
# ============================================
install_audio_drivers() {
    clear
    echo -e "${BLUE}--- Установка аудиодрайверов ---${NC}"
    echo
    echo "1) Realtek  2) Intel HDA  3) Не знаю"
    read -p "Выберите (1-3): " audio_choice

    case $audio_choice in
        1|2|3)
            apt update -qq
            apt install -y alsa-base alsa-utils pulseaudio pavucontrol linux-sound-base libasound2
            ! command -v pipewire &>/dev/null && {
                read -p "Установить PipeWire? (y/n): " pw
                [[ $pw == "y" || $pw == "Y" ]] && apt install -y pipewire pipewire-pulse wireplumber
            }
            log "Аудио настроено."
            ;;
        *)
            warn "Неверный выбор."
            ;;
    esac
    echo
    info "Нажмите Enter для возврата в ГЛАВНОЕ МЕНЮ..."
    read -r dummy_input
}

# ============================================
# ФУНКЦИЯ: Установка компонентов для игр
# ============================================
install_gaming_drivers() {
    clear
    echo -e "${BLUE}--- Установка компонентов для игр ---${NC}"
    echo
    log "Установка: Vulkan, Mesa, библиотеки..."
    apt update -qq
    apt install -y mesa-vulkan-drivers mesa-vulkan-drivers:i386 vulkan-tools libvulkan1 libvulkan1:i386 firmware-linux-free firmware-misc-nonfree libgl1-mesa-glx libgl1-mesa-dri libgl1-mesa-dri:i386 steam-devices gamemode goverlay
    echo
    log "Готово!"
    echo
    info "Нажмите Enter для возврата в ГЛАВНОЕ МЕНЮ..."
    read -r dummy_input
}

# ============================================
# ФУНКЦИЯ: Сетевые драйверы
# ============================================
install_network_drivers() {
    clear
    echo -e "${BLUE}--- Сетевые драйверы (Wi-Fi/Bluetooth) ---${NC}"
    echo
    read -p "Продолжить? (y/n): " confirm
    [[ $confirm != "y" && $confirm != "Y" ]] && return

    apt update -qq
    apt install -y network-manager network-manager-gnome wireless-tools linux-firmware
    
    echo "1) Intel  2) Realtek  3) Broadcom  4) Все"
    read -p "Выберите (1-4): " net_choice
    case $net_choice in
        1) apt install -y firmware-iwlwifi ;;
        2) apt install -y firmware-realtek ;;
        3) apt install -y firmware-b43-installer bcmwl-kernel-source ;;
        4) apt install -y firmware-iwlwifi firmware-realtek firmware-b43-installer firmware-atheros ;;
    esac

    read -p "Установить Bluetooth? (y/n): " bt
    [[ $bt == "y" || $bt == "Y" ]] && apt install -y bluez bluez-tools blueman

    systemctl restart NetworkManager 2>/dev/null || true
    echo
    log "Готово!"
    echo
    info "Нажмите Enter для возврата в ГЛАВНОЕ МЕНЮ..."
    read -r dummy_input
}

# ============================================
# ГЛАВНОЕ МЕНЮ (ЦИКЛ)
# ============================================
show_main_menu() {
    while true; do
        clear
        echo -e "${BLUE}=========================================${NC}"
        echo -e "${BLUE}   Installing_Drivers_OS (v5.1)          ${NC}"
        echo -e "${BLUE}=========================================${NC}"
        echo
        echo "  1) Установка драйверов видеокарты"
        echo "  2) Установка драйвера аудио"
        echo "  3) Установка драйверов для игр"
        echo "  4) Установка сетевых драйверов"
        echo "  5) Определение оборудования ПК"
        echo "  6) Просмотр сохранённых отчётов"
        echo "  7) ВЫХОД"
        echo
        echo -e "${BLUE}=========================================${NC}"
        read -p "  Выберите пункт (1-7): " choice
        echo

        case $choice in
            1) install_gpu_drivers ;;
            2) install_audio_drivers ;;
            3) install_gaming_drivers ;;
            4) install_network_drivers ;;
            5) detect_hardware ;;
            6) view_reports ;;
            7)
                clear
                echo -e "${GREEN}=========================================${NC}"
                echo -e "${GREEN}   Программа завершена!                  ${NC}"
                echo -e "${GREEN}=========================================${NC}"
                echo -e "${GREEN}Спасибо за использование Installing Drivers OS"
                echo
                exit 0
                ;;
            *)
                warn "Неверный выбор. Попробуйте снова."
                sleep 2
                ;;
        esac
    done
}

# ============================================
# ЗАПУСК
# ============================================
clear
echo -e "${GREEN}Запуск Installing_Drivers_OS v5.1...${NC}"
sleep 1
check_root
init_report_dir
show_main_menu
