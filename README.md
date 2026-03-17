# Installing Drivers OS

![Linux](https://img.shields.io/badge/Linux-Debian/Ubuntu/Zorin-blue?logo=linux)
![Windows](https://img.shields.io/badge/Windows-10%2F11-blue?logo=windows)
![Version](https://img.shields.io/badge/version-5.2-green)

Универсальная утилита для автоматической установки драйверов на Windows и Linux системах.

## 📋 Описание

Утилита **Installing Drivers OS** предоставляет удобный текстовый интерфейс для:
- Установки драйверов видеокарт (NVIDIA, AMD, Intel)
- Настройки аудиодрайверов
- Установки компонентов для игр
- Настройки сетевых драйверов
- Определения оборудования ПК/ноутбука

Поддерживает **Windows 10/11** и **Linux** (Zorin OS, Ubuntu, Debian-based).

## 🖥️ Версии

### Windows Edition
- Полностью автоматическая загрузка и установка драйверов
- Поддержка GeForce Experience, AMD Adrenalin, Intel DSA
- Работает от имени администратора

### Linux Edition  
- Использование официальных репозиториев системы
- Безопасная установка через `apt` и `ubuntu-drivers`
- Поддержка проприетарных и открытых драйверов

## 🚀 Быстрый запуск

### Windows
1. Скачайте [`installing_drivers_os.bat`](DriverOS_Win)
2. Нажмите правой кнопкой → **"Запуск от имени администратора"**
3. Следуйте инструкциям в меню

### Linux
1. Скачайте [`installing_drivers_os.sh`](linux/installing_drivers_os.sh)
2. Сделайте файл исполняемым:
   ```bash
   chmod +x installing_drivers_os.sh
