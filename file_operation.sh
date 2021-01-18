#!/bin/bash
# информация о файле через команду stat
function file_info() {
    if [[ ! $# -eq 1 ]]; then
        # echo "Параметр должен быть один: имя файла."
        return 22
    fi
    if [[ -f "$1" || -d "$1" ]]; then
        # SAVE_IFS=$IFS
        # IFS="\n"
        # тип файла
        printf "Тип: %s\n" $(stat --printf='%F\n' $1)
        # данные группы-владельца
        printf "Группа-владельца:\n"
        printf "      ID: %s\n" $(stat --printf='%g\n' $1)
        printf "      Имя: %s\n" $(stat --printf='%G\n' $1)
        # данные владельца файла
        printf "Пользователь-владелец:\n"
        printf "      ID: %s\n" $(stat --printf='%u\n' $1)
        printf "      Имя: %s\n" $(stat --printf='%U\n' $1)
        # кол-во жестких ссылок
        printf "Количество жестких ссылок: %s\n" $(stat --printf='%h\n' $1)
        # время создания
        printf "Время:\n"
        printf "      создание: %s\n" $(stat --printf='%w\n' $1)
        # время последнего доступа
        printf "      последний доступ: %s\n" $(stat --printf='%x\n' $1)
        # время последней модификации данных
        printf "      последняя модификация данных: %s\n" $(stat --printf='%y\n' $1)
        # IFS=$SAVE_IFS
        return 0
    else
        return 1
    fi
}

# это файл? да-0/нет-1
function isFile() {
    if [[ $# -eq 2 ]]; then
        if [[ ! -f "$2" ]]; then
            printf "Ошибка: Некорректный лог-файл.\n"
            return 23
        fi
        if [[ ! -w "$2" ]]; then
            printf "Ошибка: Лог-файл не записываемый.\n"
            return 24
        fi
        local hasLogFile=1
        local USER_LOG_FILE=$2
        echo "$(date +"%A %d %B %Y %T"): Начинаем проверку файла на соответствие '$1'." >> $USER_LOG_FILE
    elif [[ $# -eq 1 ]]; then
        local hasLogFile=0
    else
        printf "Ошибка: Некорректные параметры функции.\n"
        printf "У функции может быть два параметра:\n"
        printf "    1ый (обязательный) - 'проверяемый файл с абсолютным путем';\n"
        printf "    2ой (не обязательный) - 'имя существующего лог-файла'.\n"
        return 22
    fi
    if [[ -f "$1" ]]; then
        if [[ "$hasLogFile" -eq 1 ]]; then
            echo "$(date +"%A %d %B %Y %T"): Успешная проверка: '$1' - это файл." >> $USER_LOG_FILE
        fi
        printf "Успешная проверка: '%s' - это файл.\n" "$1"
        return 0
    else
        if [[ "$hasLogFile" -eq 1 ]]; then
            echo "$(date +"%A %d %B %Y %T"): Ошибка: '$1' - это не существующий файл." >> $USER_LOG_FILE
        fi
        printf "Ошибка: '%s' - это не существующий файл.\n" "$1"
        return 1
    fi
}

# этот файл доступен для записи? да-0/нет-1
function isWritableFile() {
    if [[ $# -eq 2 ]]; then
        if [[ ! -f "$2" ]]; then
            printf "Ошибка: Некорректный лог-файл.\n"
            return 23
        fi
        if [[ ! -w "$2" ]]; then
            printf "Ошибка: Лог-файл не записываемый.\n"
            return 24
        fi
        local hasLogFile=1
        local USER_LOG_FILE=$2
        echo "$(date +"%A %d %B %Y %T"): Начинаем проверку на доступность записи в файл '$1'." >> $USER_LOG_FILE
    elif [[ $# -eq 1 ]]; then
        local hasLogFile=0
    else
        printf "Ошибка: Некорректные параметры функции.\n"
        printf "У функции может быть два параметра:\n"
        printf "    1ый (обязательный) - 'проверяемый файл с абсолютным путем';\n"
        printf "    2ой (не обязательный) - 'имя существующего лог-файла'.\n"
        return 22
    fi
    if [[ -f "$1" ]]; then
        if [[ -w "$1" ]]; then
            if [[ "$hasLogFile" -eq 1 ]]; then
                echo "$(date +"%A %d %B %Y %T"): Успешная проверка: '$1' - это файл доступный для записи." >> $USER_LOG_FILE
            fi
            printf "Успешная проверка: '%s' - это файл доступный для записи.\n" "$1"
            return 0
        else
            if [[ "$hasLogFile" -eq 1 ]]; then
                echo "$(date +"%A %d %B %Y %T"): Ошибка: '$1' - это файл не доступный для записи." >> $USER_LOG_FILE
            fi
            printf "Ошибка: '%s' - это файл не доступный для записи.\n" "$1"
            return 1
        fi
    else
        if [[ "$hasLogFile" -eq 1 ]]; then
            echo "$(date +"%A %d %B %Y %T"): Ошибка: '$1' - это не файл." >> $USER_LOG_FILE
        fi
        printf "Ошибка: '%s' - это не файл.\n" "$1"
        return 1
    fi
}

# это директория? да-0/нет-1
function isFolder() {
    if [[ $# -eq 2 ]]; then
        if [[ ! -f "$2" ]]; then
            printf "Ошибка: Некорректный лог-файл.\n"
            return 23
        fi
        if [[ ! -w "$2" ]]; then
            printf "Ошибка: Лог-файл не записываемый.\n"
            return 24
        fi
        local hasLogFile=1
        local USER_LOG_FILE=$2
        echo "$(date +"%A %d %B %Y %T"): Начинаем проверку директории на соответствие '$1'." >> $USER_LOG_FILE
    elif [[ $# -eq 1 ]]; then
        local hasLogFile=0
    else
        printf "Ошибка: Некорректные параметры функции.\n"
        printf "У функции может быть два параметра:\n"
        printf "    1ый (обязательный) - 'проверяемая папка с абсолютным путем';\n"
        printf "    2ой (не обязательный) - 'имя существующего лог-файла'.\n"
        return 22
    fi
    if [[ -d "$1" ]]; then
        if [[ "$hasLogFile" -eq 1 ]]; then
            echo "$(date +"%A %d %B %Y %T"): Успешная проверка: '$1' - это директория." >> $USER_LOG_FILE
        fi
        printf "Успешная проверка: '%s' - это директория.\n" "$1"
        return 0
    else
        if [[ "$hasLogFile" -eq 1 ]]; then
            echo "$(date +"%A %d %B %Y %T"): Ошибка: '$1' - это не существующая директория." >> $USER_LOG_FILE
        fi
        printf "Ошибка: '%s' - это не существующая директория.\n" "$1"
        return 1
    fi
}

function count_all_files_in_folder() {
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
        local -n file_count_func=$1
        echo "$(date +"%A %d %B %Y %T"): Начинаем подсчет файлов в директории '$2'." >> $USER_LOG_FILE
    elif [[ $# -eq 2 ]]; then
        local hasLogFile=0
        local -n file_count_func=$1
    else
        printf "Ошибка: Некорректные параметры функции.\n"
        printf "У функции может быть три параметра:\n"
        printf "    1ый (обязательный) - 'имя переменной возвращаемого значения функции';\n"
        printf "    2ой (обязательный) - 'проверяемая папка с абсолютным путем';\n"
        printf "    3ий (не обязательный) - 'имя существующего лог-файла'.\n"
        return 22
    fi
    if [[ "$hasLogFile" -eq 1 ]]; then
        isFolder $2 $USER_LOG_FILE
    else
        isFolder $2
    fi
    if [[ ! "$?" -eq 0 ]]; then
        return 1
    fi
    file_count_func=0
    for file_handler in $2; do
        if [[ "$hasLogFile" -eq 1 ]]; then
            isFile $file_handler $USER_LOG_FILE
        else
            isFile $file_handler
        fi
        if [[ "$?" -eq 0 ]]; then
            let "file_count_func++"
        fi
    done
    if [[ "$hasLogFile" -eq 1 ]]; then
        echo "$(date +"%A %d %B %Y %T"): Успешное выполнение: Найдено '$file_count_func' файлов в директории." >> $USER_LOG_FILE
        echo "$(date +"%A %d %B %Y %T"): Подсчет файлов в директории '$2' закончен." >> $USER_LOG_FILE
    fi
    printf "Успешное выполнение: Найдено '%u' файлов в директории.\n" "$file_count_func"
    return 0
}

function count_lic_files_in_folder() {
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
        local -n file_count_func=$1
        echo "$(date +"%A %d %B %Y %T"): Начинаем подсчет файлов-сертификатов в директории '$2'." >> $USER_LOG_FILE
    elif [[ $# -eq 2 ]]; then
        local hasLogFile=0
        local -n file_count_func=$1
    else
        printf "Ошибка: Некорректные параметры функции.\n"
        printf "У функции может быть три параметра:\n"
        printf "    1ый (обязательный) - 'имя переменной возвращаемого значения функции';\n"
        printf "    2ой (обязательный) - 'проверяемая папка с абсолютным путем';\n"
        printf "    3ий (не обязательный) - 'имя существующего лог-файла'.\n"
        return 22
    fi
    if [[ "$hasLogFile" -eq 1 ]]; then
        isFolder $2 $USER_LOG_FILE
    else
        isFolder $2
    fi
    if [[ ! "$?" -eq 0 ]]; then
        return 1
    fi
    file_count_func=0
    for file_handler in $2; do
        if [[ "$hasLogFile" -eq 1 ]]; then
            isFile $file_handler $USER_LOG_FILE
        else
            isFile $file_handler
        fi
        if [[ "$?" -eq 0 && "$file_handler" =~ ^certificate[0-9]*\.lic$ ]]; then
            let "file_count_func++"
        fi
    done
    if [[ "$hasLogFile" -eq 1 ]]; then
        echo "$(date +"%A %d %B %Y %T"): Успешное выполнение: Найдено '$file_count_func' файлов-сертификатов в директории." >> $USER_LOG_FILE
        echo "$(date +"%A %d %B %Y %T"): Подсчет файлов-сертификатов в директории '$2' закончен." >> $USER_LOG_FILE
    fi
    printf "Успешное выполнение: Найдено '%u' файлов-сертификатов в директории.\n" "$file_count_func"
    return 0
}