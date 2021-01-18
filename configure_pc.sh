#!/bin/bash
source return_entered_data.sh
source file_operation.sh
clear
USER_CONFIGURE_LOG_FILE=$(pwd)/configure.log
if [[ -f "$USER_CONFIGURE_LOG_FILE" ]]; then
    while true; do
        read -p "Файл '$USER_CONFIGURE_LOG_FILE' уже есть. Создать новый (Y/N)? " answer_new_log_file
        if [[ "$answer_new_log_file" =~ ^[yY]$ ]]; then
            log_file_count=0
            log_file_out=0
            while true; do
                let "log_file_count++"
                USER_CONFIGURE_LOG_FILE=$(pwd)/configure$log_file_count.log
                if [[ ! -f "$USER_CONFIGURE_LOG_FILE" ]]; then
                    if [[ $(stat --printf='%U\n' $(pwd)) = "root" ]]; then
                        sudo touch "$USER_CONFIGURE_LOG_FILE"
                    else
                        touch "$USER_CONFIGURE_LOG_FILE"
                    fi
                    log_file_out=1
                    break
                fi
            done
            if [[ "$log_file_out" -eq 1 ]]; then
                break
            fi
        elif [[ "$answer_new_log_file" =~ ^[nN]$ ]]; then
            log_file_out=0
            while true; do
                read -p "Очистить лог-файл '$USER_CONFIGURE_LOG_FILE' (Y/N)? " answer_clean_log_file
                if [[ "$answer_clean_log_file" =~ ^[yY]$ ]]; then
                    if [[ $(stat --printf='%U\n' $(pwd)) = "root" ]]; then
                        sudo cp /dev/null "$USER_CONFIGURE_LOG_FILE"
                    else
                        cp /dev/null "$USER_CONFIGURE_LOG_FILE"
                    fi
                    log_file_out=1
                    break
                elif [[ "$answer_clean_log_file" =~ ^[nN]$ ]]; then
                    log_file_out=1
                    break
                fi
            done
            if [[ "$log_file_out" -eq 1 ]]; then
                break
            fi
        fi
    done
else
    if [[ $(stat --printf='%U\n' $(pwd)) = "root" ]]; then
        sudo touch "$USER_CONFIGURE_LOG_FILE"
    else
        touch "$USER_CONFIGURE_LOG_FILE"
    fi
fi
echo "Производится настройка конфигурации установки программы"
echo "$(date +"%A %d %B %Y %T"): Начинаем настройку конфигурации установки программы." >> $USER_CONFIGURE_LOG_FILE
return_entered_username username $USER_CONFIGURE_LOG_FILE
if [[ ! "$?" -eq 0 ]]; then
    echo "Ошибка ввода имени пользователя."
    exit 1
fi
return_entered_email email $USER_CONFIGURE_LOG_FILE
if [[ ! "$?" -eq 0 ]]; then
    echo "Ошибка ввода e-mail пользователя."
    exit 1
fi
return_entered_phone phone $USER_CONFIGURE_LOG_FILE
if [[ ! "$?" -eq 0 ]]; then
    echo "Ошибка ввода телефона пользователя."
    exit 1
fi
# выбор пути установки
while true; do
    read -p "Произвести установку программы с настройками по умолчанию?(Y/N): " answervar
    if [[ "$answervar" =~ ^[yY]$ ]]; then
        SOFT_INSTALL_PATH="$HOME/.polynom_calculator" # Папка установки программы
        echo "По умолчанию папка установки программы: $SOFT_INSTALL_PATH"
        echo "$(date +"%A %d %B %Y %T"): Пользователь $USER выбрал по умолчанию папку установки программы: $SOFT_INSTALL_PATH" >> $USER_CONFIGURE_LOG_FILE
        SOFT_BIN_PATH="$SOFT_INSTALL_PATH/bin"        # Папка с исполняемыми файлами
        echo "По умолчанию папка с исполняемыми файлами: $SOFT_BIN_PATH"
        echo "$(date +"%A %d %B %Y %T"): Пользователь $USER выбрал по умолчанию папку с исполняемыми файлами: $SOFT_BIN_PATH" >> $USER_CONFIGURE_LOG_FILE
        SOFT_DOCS_PATH="$SOFT_INSTALL_PATH/docs"      # Папка с документами
        echo "По умолчанию папка с документами: $SOFT_DOCS_PATH"
        echo "$(date +"%A %d %B %Y %T"): Пользователь $USER выбрал по умолчанию папку с документами: $SOFT_DOCS_PATH" >> $USER_CONFIGURE_LOG_FILE
        SOFT_TEMP_PATH="$SOFT_INSTALL_PATH/temp"      # Папка с временными файлами
        echo "По умолчанию папка с временными файлами: $SOFT_TEMP_PATH"
        echo "$(date +"%A %d %B %Y %T"): Пользователь $USER выбрал по умолчанию папку с временными файлами: $SOFT_TEMP_PATH" >> $USER_CONFIGURE_LOG_FILE
        SOFT_LOG_PATH="$SOFT_INSTALL_PATH/log"      # Папка с лог-файлами
        echo "По умолчанию папка с лог-файлами: $SOFT_LOG_PATH"
        echo "$(date +"%A %d %B %Y %T"): Пользователь $USER выбрал по умолчанию папку с лог-файлами: $SOFT_LOG_PATH" >> $USER_CONFIGURE_LOG_FILE
        SOFT_TASK_PATH="$SOFT_INSTALL_PATH/task"    # Папка с файлами для обработки
        echo "По умолчанию папка с файлами для обработки: $SOFT_TASK_PATH"
        echo "$(date +"%A %d %B %Y %T"): Пользователь $USER выбрал по умолчанию папку с файлами для обработки: $SOFT_TASK_PATH" >> $USER_CONFIGURE_LOG_FILE
        SOFT_OUTPUT_PATH="$SOFT_INSTALL_PATH/output"  # Папка с файлами - хранилище результатов обработки
        echo "По умолчанию папка с файлами - хранилище результатов обработки: $SOFT_OUTPUT_PATH"
        echo "$(date +"%A %d %B %Y %T"): Пользователь $USER выбрал по умолчанию папку с файлами - хранилище результатов обработки: $SOFT_OUTPUT_PATH" >> $USER_CONFIGURE_LOG_FILE
        SOFT_SERT_PATH='/usr/etc/.polynom_calculator' # Папка с сертификатами
        echo "По умолчанию папка с сертификатами: $SOFT_SERT_PATH"
        echo "$(date +"%A %d %B %Y %T"): Пользователь $USER выбрал по умолчанию папку с сертификатами: $SOFT_SERT_PATH" >> $USER_CONFIGURE_LOG_FILE
        break
    elif [[ "$answervar" =~ ^[nN]$ ]]; then
        echo "Вводится папка установки программы"
        return_entered_path SOFT_INSTALL_PATH $USER_CONFIGURE_LOG_FILE
        if [[ ! "$?" -eq 0 ]]; then
            echo "Ошибка ввода папки установки программы."
            exit 1
        fi
        echo "Введена папка установки программы: $SOFT_INSTALL_PATH"
        echo "$(date +"%A %d %B %Y %T"): Пользователь $USER ввел папку установки программы: $SOFT_INSTALL_PATH" >> $USER_CONFIGURE_LOG_FILE
        SOFT_BIN_PATH="$SOFT_INSTALL_PATH/bin"                          # Папка с исполняемыми файлами
        echo "Введена папка с исполняемыми файлами: $SOFT_BIN_PATH"
        echo "$(date +"%A %d %B %Y %T"): Пользователь $USER ввел папку с исполняемыми файлами: $SOFT_BIN_PATH" >> $USER_CONFIGURE_LOG_FILE
        SOFT_DOCS_PATH="$SOFT_INSTALL_PATH/docs"                        # Папка с документами
        echo "Введена папка с документами: $SOFT_DOCS_PATH"
        echo "$(date +"%A %d %B %Y %T"): Пользователь $USER ввел папку с документами: $SOFT_DOCS_PATH" >> $USER_CONFIGURE_LOG_FILE
        SOFT_TEMP_PATH="$SOFT_INSTALL_PATH/temp"                        # Папка с временными файлами
        echo "Введена папка с временными файлами: $SOFT_TEMP_PATH"
        echo "$(date +"%A %d %B %Y %T"): Пользователь $USER ввел папку с временными файлами: $SOFT_TEMP_PATH" >> $USER_CONFIGURE_LOG_FILE
        SOFT_LOG_PATH="$SOFT_INSTALL_PATH/log"                          # Папка с лог-файлами
        echo "По умолчанию папка с лог-файлами: $SOFT_LOG_PATH"
        echo "$(date +"%A %d %B %Y %T"): Пользователь $USER выбрал по умолчанию папку с лог-файлами: $SOFT_LOG_PATH" >> $USER_CONFIGURE_LOG_FILE
        SOFT_TASK_PATH="$SOFT_INSTALL_PATH/task"                        # Папка с файлами для обработки
        echo "Введена папка с файлами для обработки: $SOFT_TASK_PATH"
        echo "$(date +"%A %d %B %Y %T"): Пользователь $USER ввел папку с файлами для обработки: $SOFT_TASK_PATH" >> $USER_CONFIGURE_LOG_FILE
        SOFT_OUTPUT_PATH="$SOFT_INSTALL_PATH/output"                    # Папка с файлами - хранилище результатов обработки
        echo "Введена папка с файлами - хранилище результатов обработки: $SOFT_OUTPUT_PATH"
        echo "$(date +"%A %d %B %Y %T"): Пользователь $USER ввел папку с файлами - хранилище результатов обработки: $SOFT_OUTPUT_PATH" >> $USER_CONFIGURE_LOG_FILE
        echo "Вводится папка установки сертификатов"
        return_entered_path SOFT_SERT_PATH $USER_CONFIGURE_LOG_FILE     # Папка с сертификатами
        if [[ ! "$?" -eq 0 ]]; then
            echo "Ошибка ввода папки установки сертификатов."
            exit 1
        fi
        echo "Введена папка местоположения сертификатов: $SOFT_SERT_PATH"
        echo "$(date +"%A %d %B %Y %T"): Пользователь $USER ввел папку местоположения сертификатов: $SOFT_SERT_PATH" >> $USER_CONFIGURE_LOG_FILE
        break
    else
        echo "Неверный ввод. Повторите."
        echo "$(date +"%A %d %B %Y %T"): Пользователь $USER не может ввести правильный символ y|Y или n|N в ответ на запрос." >> $USER_CONFIGURE_LOG_FILE
    fi
done
# определяем текущий год: продолжительность действия сертификата для каждого нового пользователя - один год
cur_year=$(date +%Y)
# проверяем наличие файлов сертификатов *.lic в папке установки сертификатов
count_lic_files_in_folder lic_count $SOFT_SERT_PATH
lic_file=''
if [[ -d "$SOFT_SERT_PATH" ]]; then
    for file_handler in $SOFT_SERT_PATH; do
        if [[ -f "$file_name" && "$file_handler" =~ ^certificate[0-9]*\.lic$ ]]; then
            let "lic_count++"
            # Ищем совпадения по cur_year, username, email, phone.
            # Именно в таком порядке, т.е. если нет совпадения cur_year, то не будет искать совпадения далее по username и т.д.
            year_count=0
            username_count=0
            email_count=0
            phone_count=0
            for word_in_file in $(cat $file_handler); do
                if [[ "$year_count" -lt 1 && "$username_count" -lt 1 && "$email_count" -lt 1 && "$phone_count" -lt 1 ]]; then
                    if [[ "$word_in_file" -eq "$cur_year" ]]; then
                        let "year_count++"
                    fi
                fi
                if [[ "$year_count" -gt 0 && "$username_count" -lt 1 && "$email_count" -lt 1 && "$phone_count" -lt 1 ]]; then
                    if [[ "$word_in_file" -eq "$username" ]]; then
                        let "username_count++"
                    fi
                fi
                if [[ "$year_count" -gt 0 && "$username_count" -gt 0 && "$email_count" -lt 1 && "$phone_count" -lt 1 ]]; then
                    if [[ "$word_in_file" -eq "$email" ]]; then
                        let "email_count++"
                    fi
                fi
                if [[ "$year_count" -gt 0 && "$username_count" -gt 0 && "$email_count" -gt 0 && "$phone_count" -lt 1 ]]; then
                    if [[ "$word_in_file" -eq "$phone" ]]; then
                        let "phone_count++"
                    fi
                fi
            done
            if [[ "$year_count" -eq 1 && "$username_count" -eq 1 && "$email_count" -eq 1 && "$phone_count" -eq 1 ]]; then
                echo "Для введенных данных: user: $username, e-mail: $email, phone: $phone - есть сертификат на текущий год."
                lic_file=$SOFT_SERT_PATH/$file_handler
            fi
        fi
    done
else
    sudo mkdir -p $SOFT_SERT_PATH
    sudo chown -R root:root $SOFT_SERT_PATH
fi
if [[ -z "$lic_file" || ! -f "$lic_file" ]]; then
    # формируем файл сертификата
    lic_file="certificate$lic_count.lic"
    sudo sed -e "s/YEAR/${cur_year}/; s/USERNAME/${username}/; s/EMAIL/${email}/; s/PHONE/${phone}/" certificate.default > $lic_file
    sudo chown -R root:root $lic_file
    sudo chmod 644 $lic_file
    sudo mv -ft $SOFT_SERT_PATH $lic_file
fi
# ищем конфигурационный файл для сертификата
conf_file="install$lic_count.conf"
if [[ -f "$conf_file" ]]; then
    while true; do
        read -p "Конфигурационный файл '$conf_file' существует. Перезаписать новые данные (Y/N)?" answer_clean_conf_file
        if [[ "$answer_clean_conf_file" =~ ^[yY]$ ]]; then
            USER_SAVE_CONFIGURE=$(pwd)/$conf_file
            if [[ $(stat --printf='%U\n' $(pwd)) != "root" ]]; then
                echo "$SOFT_SERT_PATH/$lic_file" > $USER_SAVE_CONFIGURE                 # 1 строка
                echo ${SOFT_INSTALL_PATH} >> $USER_SAVE_CONFIGURE                       # 2 строка
                echo ${SOFT_BIN_PATH} >> $USER_SAVE_CONFIGURE                           # 3 строка
                echo ${SOFT_DOCS_PATH} >> $USER_SAVE_CONFIGURE                          # 4 строка
                echo ${SOFT_TEMP_PATH} >> $USER_SAVE_CONFIGURE                          # 5 строка
                echo ${SOFT_LOG_PATH} >> $USER_SAVE_CONFIGURE                           # 6 строка
                echo ${SOFT_TASK_PATH} >> $USER_SAVE_CONFIGURE                          # 7 строка
                echo ${SOFT_OUTPUT_PATH} >> $USER_SAVE_CONFIGURE                        # 8 строка
            fi
            break
        elif [[ "$answer_clean_conf_file" =~ ^[nN]$ ]]; then
            break
        fi
    done
else
    USER_SAVE_CONFIGURE=$(pwd)/$conf_file
    if [[ $(stat --printf='%U\n' $(pwd)) != "root" ]]; then
        echo "$SOFT_SERT_PATH/$lic_file" > $USER_SAVE_CONFIGURE                 # 1 строка
        echo ${SOFT_INSTALL_PATH} >> $USER_SAVE_CONFIGURE                       # 2 строка
        echo ${SOFT_BIN_PATH} >> $USER_SAVE_CONFIGURE                           # 3 строка
        echo ${SOFT_DOCS_PATH} >> $USER_SAVE_CONFIGURE                          # 4 строка
        echo ${SOFT_TEMP_PATH} >> $USER_SAVE_CONFIGURE                          # 5 строка
        echo ${SOFT_LOG_PATH} >> $USER_SAVE_CONFIGURE                           # 6 строка
        echo ${SOFT_TASK_PATH} >> $USER_SAVE_CONFIGURE                          # 7 строка
        echo ${SOFT_OUTPUT_PATH} >> $USER_SAVE_CONFIGURE                        # 8 строка
    fi
fi
echo "$(date +"%A %d %B %Y %T"): Заканчиваем настройку конфигурации установки программы." >> $USER_CONFIGURE_LOG_FILE
echo "Настройка конфигурации установки программы закончена"