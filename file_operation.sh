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
    if [[ ! $# -eq 1 ]]; then
        printf "Параметр должен быть один: имя файла.\n"
        return 22
    fi
    if [[ -f "$1" ]]; then
        local access_file=''
        if [[ -r "$1" ]]; then
            access_file+="r"
        fi
        if [[ -w "$1" ]]; then
            access_file+="w"
        fi
        if [[ -x "$1" ]]; then
            access_file+="x"
        fi
        printf "'%s' - это файл с правами доступа '%s'.\n" "$1" "$access_file"
        return 0
    elif [[ -e "$1" ]]; then
        printf "'%s' - это не файл.\n" "$1"
        return 1
    else
        printf "'%s' - файла не существует.\n" "$1"
        return 1
    fi
}

# этот файл доступен для записи? да-0/нет-1
function isWritableFile() {
    if [[ ! $# -eq 1 ]]; then
        printf "Параметр должен быть один: имя файла.\n"
        return 22
    fi
    if [[ -f "$1" ]]; then
        if [[ -w "$1" ]]; then
            printf "'%s' - это файл доступный для записи.\n" "$1"
            return 0
        fi
        printf "'%s' - это файл не доступный для записи.\n" "$1"
        return 1
    else
        printf "'%s' - это не файл.\n" "$1"
        return 1
    fi
}

# это директория? да-0/нет-1
function isFolder() {
    if [[ ! $# -eq 1 ]]; then
        printf "Параметр должен быть один: имя файла.\n"
        return 22
    fi
    if [[ -d "$1" ]]; then
        printf "'%s' - это директория.\n" "$1"
        return 0
    else
        printf "'%s' - это не директория.\n" "$1"
        return 1
    fi
}
