#!/bin/bash
# это файл? да-0/нет-1
function isFile() {
    set -euo pipefail
    if [[ $# -eq 3 ]]; then
        if [[ ! -f "$3" ]]; then
            printf "Ошибка: Некорректный лог-файл.\n"
            return 23
        fi
        if [[ ! -w "$3" ]]; then
            printf "Ошибка: Лог-файл не записываемый.\n"
            return 24
        fi
        local hasLogFile=1
        local USER_LOG_FILE=$3
        local -n is_file=$1
        echo "$(date +"%A %d %B %Y %T"): Начинаем проверку файла '$2' на соответствие." >> $USER_LOG_FILE
    elif [[ $# -eq 2 ]]; then
        local hasLogFile=0
        local -n is_file=$1
    else
        printf "Ошибка: Некорректные параметры функции.\n"
        printf "У функции может быть три параметра:\n"
        printf "    1ый (обязательный) - 'имя переменной возвращаемого значения функции';\n"
        printf "    2ой (обязательный) - 'проверяемый файл с абсолютным путем';\n"
        printf "    3ий (не обязательный) - 'имя существующего лог-файла'.\n"
        return 22
    fi
    if [[ -f "$2" ]]; then
        if [[ "$hasLogFile" -eq 1 ]]; then
            echo "$(date +"%A %d %B %Y %T"): Успешная проверка: '$2' - это файл." >> $USER_LOG_FILE
            echo "$(date +"%A %d %B %Y %T"): Заканчиваем проверку файла '$2' на соответствие." >> $USER_LOG_FILE
        fi
        printf "Успешная проверка: '%s' - это файл.\n" "$2"
        is_file=1
        return 0
    else
        if [[ "$hasLogFile" -eq 1 ]]; then
            echo "$(date +"%A %d %B %Y %T"): Успешная проверка: '$2' - это не существующий файл." >> $USER_LOG_FILE
            echo "$(date +"%A %d %B %Y %T"): Заканчиваем проверку файла '$2' на соответствие." >> $USER_LOG_FILE
        fi
        printf "Успешная проверка: '%s' - это не существующий файл.\n" "$2"
        is_file=0
        return 0
    fi
}

# этот файл доступен для записи? да-0/нет-1
function isWritableFile() {
    set -euo pipefail
    if [[ $# -eq 3 ]]; then
        if [[ ! -f "$3" ]]; then
            printf "Ошибка: Некорректный лог-файл.\n"
            return 23
        fi
        if [[ ! -w "$3" ]]; then
            printf "Ошибка: Лог-файл не записываемый.\n"
            return 24
        fi
        local hasLogFile=1
        local USER_LOG_FILE=$3
        local -n is_writable_file=$1
        echo "$(date +"%A %d %B %Y %T"): Начинаем проверку на доступность записи в файл '$2'." >> $USER_LOG_FILE
    elif [[ $# -eq 2 ]]; then
        local hasLogFile=0
        local -n is_writable_file=$1
    else
        printf "Ошибка: Некорректные параметры функции.\n"
        printf "У функции может быть три параметра:\n"
        printf "    1ый (обязательный) - 'имя переменной возвращаемого значения функции';\n"
        printf "    2ой (обязательный) - 'проверяемый файл с абсолютным путем';\n"
        printf "    3ий (не обязательный) - 'имя существующего лог-файла'.\n"
        return 22
    fi
    if [[ -f "$2" ]]; then
        if [[ -w "$2" ]]; then
            if [[ "$hasLogFile" -eq 1 ]]; then
                echo "$(date +"%A %d %B %Y %T"): Успешная проверка: '$2' - это файл доступный для записи." >> $USER_LOG_FILE
                echo "$(date +"%A %d %B %Y %T"): Заканчиваем проверку на доступность записи в файл '$2'." >> $USER_LOG_FILE
            fi
            printf "Успешная проверка: '%s' - это файл доступный для записи.\n" "$2"
            is_writable_file=1
            return 0
        else
            if [[ "$hasLogFile" -eq 1 ]]; then
                echo "$(date +"%A %d %B %Y %T"): Успешная проверка: '$2' - это файл не доступный для записи." >> $USER_LOG_FILE
                echo "$(date +"%A %d %B %Y %T"): Заканчиваем проверку на доступность записи в файл '$2'." >> $USER_LOG_FILE
            fi
            printf "Успешная проверка: '%s' - это файл не доступный для записи.\n" "$2"
            is_writable_file=0
            return 0
        fi
    else
        if [[ "$hasLogFile" -eq 1 ]]; then
            echo "$(date +"%A %d %B %Y %T"): Ошибка: '$2' - это не существующий файл." >> $USER_LOG_FILE
            echo "$(date +"%A %d %B %Y %T"): Заканчиваем проверку на доступность записи в файл '$2'." >> $USER_LOG_FILE
        fi
        printf "Ошибка: '%s' - это не существующий файл.\n" "$2"
        return 1
    fi
}

# это директория? да-0/нет-1
function isFolder() {
    set -euo pipefail
    if [[ $# -eq 3 ]]; then
        if [[ ! -f "$3" ]]; then
            printf "Ошибка: Некорректный лог-файл.\n"
            return 23
        fi
        if [[ ! -w "$3" ]]; then
            printf "Ошибка: Лог-файл не записываемый.\n"
            return 24
        fi
        local hasLogFile=1
        local USER_LOG_FILE=$3
        local -n is_folder=$1
        echo "$(date +"%A %d %B %Y %T"): Начинаем проверку директории '$2' на соответствие." >> $USER_LOG_FILE
    elif [[ $# -eq 2 ]]; then
        local hasLogFile=0
        local -n is_folder=$1
    else
        printf "Ошибка: Некорректные параметры функции.\n"
        printf "У функции может быть три параметра:\n"
        printf "    1ый (обязательный) - 'имя переменной возвращаемого значения функции';\n"
        printf "    2ой (обязательный) - 'проверяемая папка с абсолютным путем';\n"
        printf "    3ий (не обязательный) - 'имя существующего лог-файла'.\n"
        return 22
    fi
    if [[ -d "$2" ]]; then
        if [[ "$hasLogFile" -eq 1 ]]; then
            echo "$(date +"%A %d %B %Y %T"): Успешная проверка: '$2' - это директория." >> $USER_LOG_FILE
            echo "$(date +"%A %d %B %Y %T"): Заканчиваем проверку директории '$2' на соответствие." >> $USER_LOG_FILE
        fi
        printf "Успешная проверка: '%s' - это директория.\n" "$2"
        is_folder=1
        return 0
    else
        if [[ "$hasLogFile" -eq 1 ]]; then
            echo "$(date +"%A %d %B %Y %T"): Успешная проверка: '$2' - это не существующая директория." >> $USER_LOG_FILE
            echo "$(date +"%A %d %B %Y %T"): Заканчиваем проверку директории '$2' на соответствие." >> $USER_LOG_FILE
        fi
        printf "Успешная проверка: '%s' - это не существующая директория.\n" "$2"
        is_folder=0
        return 0
    fi
}
