#!/bin/bash
source file_operation.sh

function return_entered_username() {
    local username=''
    local uservar=''
    local USER_LOG_FILE=''
    local hasLogFile=0
    if [[ "$#" -eq 1 ]]; then
        hasLogFile=1
        isFile $1
        if [[ "$?" -eq 0 ]]; then
            isWritableFile $1
            if [[ ! "$?" -eq 0 ]]; then
                chmod u+w $1
            fi
        else
            touch $1
            isWritableFile $1
            if [[ ! "$?" -eq 0 ]]; then
                chmod u+w $1
            fi
        fi
        USER_LOG_FILE=$1
    elif [[ "$#" -gt 1 ]]; then
        echo "Нужен только один параметр: 'имя лог-файла'. Лог не ведется."
        hasLogFile=0
    fi
    if [[ "$hasLogFile" -eq 1 ]]; then
        echo "$(date +"%A %d %B %Y %T"): Начинаем вводить имя пользователя." >> $USER_LOG_FILE
    fi
    while true; do
        read -p 'Введите имя пользователя: ' uservar
        local username=${uservar// /_}
        if [[ -z "$username" ]]; then
            echo "Имя пользователя не должно быть пустым."
            if [[ "$hasLogFile" -eq 1 ]]; then
                echo "$(date +"%A %d %B %Y %T"): Пользователь $USER ввел пустое значение имени пользователя." >> $USER_LOG_FILE
            fi
        elif [[ "$username" =~ ^[a-zA-Z0-9_]*$ ]]; then
            if [[ "$hasLogFile" -eq 1 ]]; then
                echo "$(date +"%A %d %B %Y %T"): Пользователь $USER ввел корректное значение имени пользователя '$username'." >> $USER_LOG_FILE
            fi
            break
        else
            echo "Имя пользователя должно содержать только буквы, цифры и символ '_'"
            if [[ "$hasLogFile" -eq 1 ]]; then
                echo "$(date +"%A %d %B %Y %T"): Пользователь $USER использовал некорректные символы '$username' при вводе значения имени пользователя." >> $USER_LOG_FILE
            fi
        fi
    done
    if [[ "$hasLogFile" -eq 1 ]]; then
        echo "$(date +"%A %d %B %Y %T"): Закончили вводить имя пользователя." >> $USER_LOG_FILE
    fi
    echo ${username}
}

function return_entered_email() {
    local email=''
    local USER_LOG_FILE=''
    local hasLogFile=0
    if [[ "$#" -eq 1 ]]; then
        hasLogFile=1
        isFile $1
        if [[ "$?" -eq 0 ]]; then
            isWritableFile $1
            if [[ ! "$?" -eq 0 ]]; then
                chmod u+w $1
            fi
        else
            touch $1
            isWritableFile $1
            if [[ ! "$?" -eq 0 ]]; then
                chmod u+w $1
            fi
        fi
        USER_LOG_FILE=$1
    elif [[ "$#" -gt 1 ]]; then
        echo "Нужен только один параметр: 'имя лог-файла'. Лог не ведется."
        hasLogFile=0
    fi
    if [[ "$hasLogFile" -eq 1 ]]; then
        echo "$(date +"%A %d %B %Y %T"): Начинаем вводить e-mail." >> $USER_LOG_FILE
    fi
    while true; do
        read -p "Введите E-mail: " email
        if [[ -z "$email" ]]; then
            echo "E-mail не должен быть пустым"
            if [[ "$hasLogFile" -eq 1 ]]; then
                echo "$(date +"%A %d %B %Y %T"): Пользователь $USER ввел пустое значение E-mail." >> $USER_LOG_FILE
            fi
        elif [[ "$email" =~ ^[a-zA-Z0-9._-]*@[a-zA-Z0-9._-]*\.[a-zA-Z]{2,5}$ ]]; then
            if [[ "$hasLogFile" -eq 1 ]]; then
                echo "$(date +"%A %d %B %Y %T"): Пользователь $USER ввел корректное значение E-mail '$email'." >> $USER_LOG_FILE
            fi
            break
        else 
            echo "Неверный формат E-mail."
            if [[ "$hasLogFile" -eq 1 ]]; then
                echo "$(date +"%A %d %B %Y %T"): Пользователь $USER использовал некорректные символы '$email' при вводе значения имени пользователя." >> $USER_LOG_FILE
            fi
        fi
    done
    if [[ "$hasLogFile" -eq 1 ]]; then
        echo "$(date +"%A %d %B %Y %T"): Закончили вводить e-mail." >> $USER_LOG_FILE
    fi
    echo ${email}
}

function return_entered_phone() {
    local phone=''
    local USER_LOG_FILE=''
    local hasLogFile=0
    if [[ "$#" -eq 1 ]]; then
        hasLogFile=1
        isFile $1
        if [[ "$?" -eq 0 ]]; then
            isWritableFile $1
            if [[ ! "$?" -eq 0 ]]; then
                chmod u+w $1
            fi
        else
            touch $1
            isWritableFile $1
            if [[ ! "$?" -eq 0 ]]; then
                chmod u+w $1
            fi
        fi
        USER_LOG_FILE=$1
    elif [[ "$#" -gt 1 ]]; then
        echo "Нужен только один параметр: 'имя лог-файла'. Лог не ведется."
        hasLogFile=0
    fi
    if [[ "$hasLogFile" -eq 1 ]]; then
        echo "$(date +"%A %d %B %Y %T"): Начинаем вводить телефон." >> $USER_LOG_FILE
    fi
    while true; do
        read -p "Введите телефон в формате(+7-ххх-ххх-хх-хх): " phone
        if [[ -z "$phone" ]]; then
            echo "Телефон не должен быть пустым"
            if [[ "$hasLogFile" -eq 1 ]]; then
                echo "$(date +"%A %d %B %Y %T"): Пользователь $USER ввел пустое значение телефона." >> $USER_LOG_FILE
            fi
        elif [[ "$phone" =~ ^\+7-[0-9]{3}-[0-9]{3}-[0-9]{2}-[0-9]{2}$ ]]; then 
            if [[ "$hasLogFile" -eq 1 ]]; then
                echo "$(date +"%A %d %B %Y %T"): Пользователь $USER ввел корректное значение телефона '$phone'." >> $USER_LOG_FILE
            fi
            break
        else
            echo "Неверно введенный телефон"
            if [[ "$hasLogFile" -eq 1 ]]; then
                echo "$(date +"%A %d %B %Y %T"): Пользователь $USER использовал некорректные символы '$phone' при вводе значения телефона." >> $USER_LOG_FILE
            fi
        fi
    done
    if [[ "$hasLogFile" -eq 1 ]]; then
        echo "$(date +"%A %d %B %Y %T"): Закончили вводить телефон." >> $USER_LOG_FILE
    fi
    echo ${phone}
}

function return_entered_path() {
    local answer_install_path=''
    local answer_exist_folder=''
    local USER_LOG_FILE=''
    local hasLogFile=0
    if [[ "$#" -eq 1 ]]; then
        hasLogFile=1
        isFile $1
        if [[ "$?" -eq 0 ]]; then
            isWritableFile $1
            if [[ ! "$?" -eq 0 ]]; then
                chmod u+w $1
            fi
        else
            touch $1
            isWritableFile $1
            if [[ ! "$?" -eq 0 ]]; then
                chmod u+w $1
            fi
        fi
        USER_LOG_FILE=$1
    elif [[ ! "$#" -eq 1 ]]; then
        echo "Для ведения лог-файла нужно указать его имя с абсолютным путем. Лог не ведется."
        hasLogFile=0
    fi
    while true; do
        read -p "Введите путь установки. Формат: '/home/user/some_folder_19/.program_folder': " answer_install_path
        if [[ -z "$answer_install_path" ]]; then
            if [[ "$hasLogFile" -eq 1 ]]; then
                echo "Пользователь $USER ввел пустое значение каталога установки." >> $USER_LOG_FILE
            fi
            echo "Каталог установки не может быть пустым."
        elif [[ "$answer_install_path" =~ ^/[a-z]{3,4}/[a-zA-Z./0-9_]*$ ]]; then
            if [[ "$hasLogFile" -eq 1 ]]; then
                echo "Введен каталог установки: $answer_install_path" >> $USER_LOG_FILE
            fi
            if [[ -d "$answer_install_path" ]]; then
                if [[ "$hasLogFile" -eq 1 ]]; then
                    echo "Введеный каталог установки: '$answer_install_path' уже существует." >> $USER_LOG_FILE
                fi
                while true; do
                    read -p "Выбранная папка уже существует. Продолжить?(Y/N): " answer_exist_folder
                    if [[ "$answer_exist_folder" =~ ^[yY]$ ]]; then
                        local get_out=1
                        if [[ "$hasLogFile" -eq 1 ]]; then
                            echo "Пользователь $USER продолжил установку в существующий каталог." >> $USER_LOG_FILE
                        fi
                        break
                    elif [[ "$answer_exist_folder" =~ ^[nN]$ ]]; then
                        local get_out=0
                        if [[ "$hasLogFile" -eq 1 ]]; then
                            echo "Пользователь $USER отменил установку в существующий каталог." >> $USER_LOG_FILE
                        fi
                        break
                    else
                        echo "Некорректный символ."
                        if [[ "$hasLogFile" -eq 1 ]]; then
                            echo "Пользователь $USER не может ввести правильный символ y|Y или n|N в ответ на запрос." >> $USER_LOG_FILE
                        fi
                    fi
                done
                if [[ "$get_out" -eq 1 ]]; then
                    break
                fi
            elif [[ -f "$answer_install_path" ]]; then
                echo "Ошибка: выбранная папка уже существует как файл. Введите новую папку установки."
                if [[ "$hasLogFile" -eq 1 ]]; then
                    echo "Ошибка: введеный каталог установки: '$answer_install_path' является файлом." >> $USER_LOG_FILE
                fi
            else
                if [[ "$hasLogFile" -eq 1 ]]; then
                    echo "Все проверки прошли успешно. Введеный каталог установки '$answer_install_path' соответствует требованиям." >> $USER_LOG_FILE
                fi
                break 
            fi
        else
            echo "Каталог установки должен вводится в формате '/home/user/some_folder_19/.program_folder'."
            if [[ "$hasLogFile" -eq 1 ]]; then
                echo "Пользователь $USER ввел каталог '$answer_install_path' не соответствующий формату '/home/user/some_folder_19/.program_folder'." >> $USER_LOG_FILE
            fi
        fi
    done
    echo ${answer_install_path}
}
