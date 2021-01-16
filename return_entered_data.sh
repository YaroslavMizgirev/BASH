#!/bin/bash
source file_operation.sh

function return_entered_username() {
    if [[ "$#" -eq 2 ]]; then
        local hasLogFile=1
        isFile $2
        if [[ "$?" -eq 0 ]]; then
            isWritableFile $2
            if [[ ! "$?" -eq 0 ]]; then
                chmod u+w $2
            fi
        else
            touch $2
            isWritableFile $2
            if [[ ! "$?" -eq 0 ]]; then
                chmod u+w $2
            fi
        fi
        echo "У функции два параметра: 1 - возвращаемая переменная (обязательная); 2 - 'имя лог-файла' (по требованию)."
        local USER_LOG_FILE=$2
        local -n username_func=$1
    elif [[ "$#" -eq 1 ]]; then
        echo "У функции один параметр: 1 - возвращаемая переменная (обязательная). Т.к. второго пераметра нет - лог-файл не записывается."
        local -n username_func=$1
        local hasLogFile=0
    else
        echo "Ошибка: У функции нет параметров. Всего два параметра: 1 - возвращаемая переменная (обязательная); 2 - 'имя лог-файла' (по требованию)."
        return 1
    fi
    # echo "local -n username_a = $username_a"
    if [[ "$hasLogFile" -eq 1 ]]; then
        echo "$(date +"%A %d %B %Y %T"): Начинаем вводить имя пользователя." >> $USER_LOG_FILE
    fi
    local uservar=''
    while true; do
        read -p 'Введите имя пользователя: ' uservar
        username_func=${uservar// /_}
        if [[ -z "$username_func" ]]; then
            echo "Имя пользователя не должно быть пустым."
            if [[ "$hasLogFile" -eq 1 ]]; then
                echo "$(date +"%A %d %B %Y %T"): Пользователь $USER ввел пустое значение имени пользователя." >> $USER_LOG_FILE
            fi
        elif [[ "$username_func" =~ ^[a-zA-Z0-9_]*$ ]]; then
            if [[ "$hasLogFile" -eq 1 ]]; then
                echo "$(date +"%A %d %B %Y %T"): Пользователь $USER ввел корректное значение имени пользователя '$username_func'." >> $USER_LOG_FILE
            fi
            break
        else
            echo "Имя пользователя должно содержать только буквы, цифры и символ '_'"
            if [[ "$hasLogFile" -eq 1 ]]; then
                echo "$(date +"%A %d %B %Y %T"): Пользователь $USER использовал некорректные символы '$username_func' при вводе значения имени пользователя." >> $USER_LOG_FILE
            fi
        fi
    done
    if [[ "$hasLogFile" -eq 1 ]]; then
        echo "$(date +"%A %d %B %Y %T"): Закончили вводить имя пользователя." >> $USER_LOG_FILE
    fi
    # echo ${username}
    return 0
}

function return_entered_email() {
    if [[ "$#" -eq 2 ]]; then
        local hasLogFile=1
        isFile $2
        if [[ "$?" -eq 0 ]]; then
            isWritableFile $2
            if [[ ! "$?" -eq 0 ]]; then
                chmod u+w $2
            fi
        else
            touch $2
            isWritableFile $2
            if [[ ! "$?" -eq 0 ]]; then
                chmod u+w $2
            fi
        fi
        echo "У функции два параметра: 1 - возвращаемая переменная (обязательная); 2 - 'имя лог-файла' (по требованию)."
        local USER_LOG_FILE=$2
        local -n email_func=$1
    elif [[ "$#" -eq 1 ]]; then
        echo "У функции один параметр: 1 - возвращаемая переменная (обязательная). Т.к. второго пераметра нет - лог-файл не записывается."
        local -n email_func=$1
        local hasLogFile=0
    else
        echo "Ошибка: У функции нет параметров. Всего два параметра: 1 - возвращаемая переменная (обязательная); 2 - 'имя лог-файла' (по требованию)."
        return 1
    fi
    if [[ "$hasLogFile" -eq 1 ]]; then
        echo "$(date +"%A %d %B %Y %T"): Начинаем вводить e-mail." >> $USER_LOG_FILE
    fi
    while true; do
        read -p "Введите E-mail: " email_func
        if [[ -z "$email_func" ]]; then
            echo "E-mail не должен быть пустым"
            if [[ "$hasLogFile" -eq 1 ]]; then
                echo "$(date +"%A %d %B %Y %T"): Пользователь $USER ввел пустое значение E-mail." >> $USER_LOG_FILE
            fi
        elif [[ "$email_func" =~ ^[a-zA-Z0-9._-]*@[a-zA-Z0-9._-]*\.[a-zA-Z]{2,5}$ ]]; then
            if [[ "$hasLogFile" -eq 1 ]]; then
                echo "$(date +"%A %d %B %Y %T"): Пользователь $USER ввел корректное значение E-mail '$email_func'." >> $USER_LOG_FILE
            fi
            break
        else 
            echo "Неверный формат E-mail."
            if [[ "$hasLogFile" -eq 1 ]]; then
                echo "$(date +"%A %d %B %Y %T"): Пользователь $USER использовал некорректные символы '$email_func' при вводе значения имени пользователя." >> $USER_LOG_FILE
            fi
        fi
    done
    if [[ "$hasLogFile" -eq 1 ]]; then
        echo "$(date +"%A %d %B %Y %T"): Закончили вводить e-mail." >> $USER_LOG_FILE
    fi
    # echo ${email}
    return 0
}

function return_entered_phone() {
    if [[ "$#" -eq 2 ]]; then
        local hasLogFile=1
        isFile $2
        if [[ "$?" -eq 0 ]]; then
            isWritableFile $2
            if [[ ! "$?" -eq 0 ]]; then
                chmod u+w $2
            fi
        else
            touch $2
            isWritableFile $2
            if [[ ! "$?" -eq 0 ]]; then
                chmod u+w $2
            fi
        fi
        echo "У функции два параметра: 1 - возвращаемая переменная (обязательная); 2 - 'имя лог-файла' (по требованию)."
        local USER_LOG_FILE=$2
        local -n phone_func=$1
    elif [[ "$#" -eq 1 ]]; then
        echo "У функции один параметр: 1 - возвращаемая переменная (обязательная). Т.к. второго пераметра нет - лог-файл не записывается."
        local -n phone_func=$1
        local hasLogFile=0
    else
        echo "Ошибка: У функции нет параметров. Всего два параметра: 1 - возвращаемая переменная (обязательная); 2 - 'имя лог-файла' (по требованию)."
        return 1
    fi
    if [[ "$hasLogFile" -eq 1 ]]; then
        echo "$(date +"%A %d %B %Y %T"): Начинаем вводить телефон." >> $USER_LOG_FILE
    fi
    while true; do
        read -p "Введите телефон в формате(+7-ххх-ххх-хх-хх): " phone_func
        if [[ -z "$phone_func" ]]; then
            echo "Телефон не должен быть пустым"
            if [[ "$hasLogFile" -eq 1 ]]; then
                echo "$(date +"%A %d %B %Y %T"): Пользователь $USER ввел пустое значение телефона." >> $USER_LOG_FILE
            fi
        elif [[ "$phone_func" =~ ^\+7-[0-9]{3}-[0-9]{3}-[0-9]{2}-[0-9]{2}$ ]]; then 
            if [[ "$hasLogFile" -eq 1 ]]; then
                echo "$(date +"%A %d %B %Y %T"): Пользователь $USER ввел корректное значение телефона '$phone_func'." >> $USER_LOG_FILE
            fi
            break
        else
            echo "Неверно введенный телефон"
            if [[ "$hasLogFile" -eq 1 ]]; then
                echo "$(date +"%A %d %B %Y %T"): Пользователь $USER использовал некорректные символы '$phone_func' при вводе значения телефона." >> $USER_LOG_FILE
            fi
        fi
    done
    if [[ "$hasLogFile" -eq 1 ]]; then
        echo "$(date +"%A %d %B %Y %T"): Закончили вводить телефон." >> $USER_LOG_FILE
    fi
    # echo ${phone}
    return 0
}

function return_entered_path() {
    if [[ "$#" -eq 2 ]]; then
        local hasLogFile=1
        isFile $2
        if [[ "$?" -eq 0 ]]; then
            isWritableFile $2
            if [[ ! "$?" -eq 0 ]]; then
                chmod u+w $2
            fi
        else
            touch $2
            isWritableFile $2
            if [[ ! "$?" -eq 0 ]]; then
                chmod u+w $2
            fi
        fi
        echo "У функции два параметра: 1 - возвращаемая переменная (обязательная); 2 - 'имя лог-файла' (по требованию)."
        local USER_LOG_FILE=$2
        local -n answer_install_path=$1
    elif [[ "$#" -eq 1 ]]; then
        echo "У функции один параметр: 1 - возвращаемая переменная (обязательная). Т.к. второго пераметра нет - лог-файл не записывается."
        local -n answer_install_path=$1
        local hasLogFile=0
    else
        echo "Ошибка: У функции нет параметров. Всего два параметра: 1 - возвращаемая переменная (обязательная); 2 - 'имя лог-файла' (по требованию)."
        return 1
    fi
    if [[ "$hasLogFile" -eq 1 ]]; then
        echo "$(date +"%A %d %B %Y %T"): Начинаем вводить папку установки программы." >> $USER_LOG_FILE
    fi
    while true; do
        read -p "Введите путь установки. Формат: '/home/user/some_folder_19/.program_folder': " answer_install_path
        if [[ -z "$answer_install_path" ]]; then
            if [[ "$hasLogFile" -eq 1 ]]; then
                echo "$(date +"%A %d %B %Y %T"): Ошибка: Пользователь $USER ввел пустое значение каталога установки." >> $USER_LOG_FILE
            fi
            echo "Каталог установки не может быть пустым."
        elif [[ "$answer_install_path" =~ ^/[a-z]{3,4}/[a-zA-Z./0-9_]*$ ]]; then
            if [[ "$hasLogFile" -eq 1 ]]; then
                echo "$(date +"%A %d %B %Y %T"): Введен каталог установки: $answer_install_path" >> $USER_LOG_FILE
            fi
            if [[ -d "$answer_install_path" ]]; then
                if [[ "$hasLogFile" -eq 1 ]]; then
                    echo "$(date +"%A %d %B %Y %T"): Ошибка: Введеный каталог установки: '$answer_install_path' уже существует." >> $USER_LOG_FILE
                fi
                local answer_exist_folder=''
                local get_out=0
                while true; do
                    read -p "Выбранная папка уже существует. Продолжить?(Y/N): " answer_exist_folder
                    if [[ "$answer_exist_folder" =~ ^[yY]$ ]]; then
                        get_out=1
                        if [[ "$hasLogFile" -eq 1 ]]; then
                            echo "$(date +"%A %d %B %Y %T"): Пользователь $USER продолжил установку в существующий каталог." >> $USER_LOG_FILE
                        fi
                        break
                    elif [[ "$answer_exist_folder" =~ ^[nN]$ ]]; then
                        get_out=0
                        if [[ "$hasLogFile" -eq 1 ]]; then
                            echo "$(date +"%A %d %B %Y %T"): Пользователь $USER отменил установку в существующий каталог." >> $USER_LOG_FILE
                        fi
                        break
                    else
                        echo "Некорректный символ."
                        if [[ "$hasLogFile" -eq 1 ]]; then
                            echo "$(date +"%A %d %B %Y %T"): Ошибка: Пользователь $USER не может ввести правильный символ y|Y или n|N в ответ на запрос." >> $USER_LOG_FILE
                        fi
                    fi
                done
                if [[ "$get_out" -eq 1 ]]; then
                    break
                fi
            elif [[ -f "$answer_install_path" ]]; then
                echo "Ошибка: выбранная папка уже существует как файл. Введите новую папку установки."
                if [[ "$hasLogFile" -eq 1 ]]; then
                    echo "$(date +"%A %d %B %Y %T"): Ошибка: введеный каталог установки: '$answer_install_path' является файлом." >> $USER_LOG_FILE
                fi
            else
                if [[ "$hasLogFile" -eq 1 ]]; then
                    echo "$(date +"%A %d %B %Y %T"): Все проверки прошли успешно. Введеный каталог установки '$answer_install_path' соответствует требованиям." >> $USER_LOG_FILE
                fi
                break 
            fi
        else
            echo "Каталог установки должен вводится в формате '/home/user/some_folder_19/.program_folder'."
            if [[ "$hasLogFile" -eq 1 ]]; then
                echo "$(date +"%A %d %B %Y %T"): Ошибка: Пользователь $USER ввел каталог '$answer_install_path' не соответствующий формату '/home/user/some_folder_19/.program_folder'." >> $USER_LOG_FILE
            fi
        fi
    done
    # echo ${answer_install_path}
    return 0
}
