#!/bin/bash
set -euo pipefail
source return_entered_data.sh
source file_operation.sh
source sign_file_folder.sh
clear
log_file_count=1
USER_CONFIGURE_LOG_FILE=$(pwd)/configure$log_file_count.log
return_is_file=0
isFile return_is_file $USER_CONFIGURE_LOG_FILE
if [[ "$return_is_file" -eq 1 ]]; then
    while true; do
        read -p "Файл '$USER_CONFIGURE_LOG_FILE' уже есть. Создать новый (Y/N)? " answer_new_log_file
        if [[ "$answer_new_log_file" =~ ^[yY]$ ]]; then
            log_file_out=0
            while true; do
                let "log_file_count+=1"
                USER_CONFIGURE_LOG_FILE=$(pwd)/configure$log_file_count.log
                isFile return_is_file $USER_CONFIGURE_LOG_FILE
                if [[ "$return_is_file" -eq 0 ]]; then
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
    echo "Настройка конфигурации установки программы закончена"
    echo "$(date +"%A %d %B %Y %T"): Ошибка ввода имени пользователя." >> $USER_CONFIGURE_LOG_FILE
    echo "$(date +"%A %d %B %Y %T"): Заканчиваем настройку конфигурации установки программы." >> $USER_CONFIGURE_LOG_FILE
    exit 1
fi
return_entered_email email $USER_CONFIGURE_LOG_FILE
if [[ ! "$?" -eq 0 ]]; then
    echo "Ошибка ввода e-mail пользователя."
    echo "Настройка конфигурации установки программы закончена"
    echo "$(date +"%A %d %B %Y %T"): Ошибка ввода e-mail пользователя." >> $USER_CONFIGURE_LOG_FILE
    echo "$(date +"%A %d %B %Y %T"): Заканчиваем настройку конфигурации установки программы." >> $USER_CONFIGURE_LOG_FILE
    exit 1
fi
return_entered_phone phone $USER_CONFIGURE_LOG_FILE
if [[ ! "$?" -eq 0 ]]; then
    echo "Ошибка ввода телефона пользователя."
    echo "Настройка конфигурации установки программы закончена"
    echo "$(date +"%A %d %B %Y %T"): Ошибка ввода телефона пользователя." >> $USER_CONFIGURE_LOG_FILE
    echo "$(date +"%A %d %B %Y %T"): Заканчиваем настройку конфигурации установки программы." >> $USER_CONFIGURE_LOG_FILE
    exit 1
fi
# выбор пути установки
while true; do
    read -p "Произвести установку программы с настройками по умолчанию?(Y/N): " answervar
    if [[ "$answervar" =~ ^[yY]$ ]]; then
        SOFT_INSTALL_PATH="$HOME/.polynom_calculator" # Папка установки программы
        echo "По умолчанию папка установки программы: '$SOFT_INSTALL_PATH'"
        echo "$(date +"%A %d %B %Y %T"): Пользователь '$USER' выбрал по умолчанию папку установки программы: '$SOFT_INSTALL_PATH'" >> $USER_CONFIGURE_LOG_FILE
        SOFT_BIN_PATH="$SOFT_INSTALL_PATH/bin"        # Папка с исполняемыми файлами
        echo "По умолчанию папка с исполняемыми файлами: '$SOFT_BIN_PATH'"
        echo "$(date +"%A %d %B %Y %T"): По умолчанию папка с исполняемыми файлами: '$SOFT_BIN_PATH'" >> $USER_CONFIGURE_LOG_FILE
        SOFT_DOCS_PATH="$SOFT_INSTALL_PATH/docs"      # Папка с документами
        echo "По умолчанию папка с документами: '$SOFT_DOCS_PATH'"
        echo "$(date +"%A %d %B %Y %T"): По умолчанию папка с документами: '$SOFT_DOCS_PATH'" >> $USER_CONFIGURE_LOG_FILE
        SOFT_TEMP_PATH="$SOFT_INSTALL_PATH/temp"      # Папка с временными файлами
        echo "По умолчанию папка с временными файлами: '$SOFT_TEMP_PATH'"
        echo "$(date +"%A %d %B %Y %T"): По умолчанию папка с временными файлами: '$SOFT_TEMP_PATH'" >> $USER_CONFIGURE_LOG_FILE
        SOFT_LOG_PATH="$SOFT_INSTALL_PATH/log"      # Папка с лог-файлами
        echo "По умолчанию папка с лог-файлами: '$SOFT_LOG_PATH'"
        echo "$(date +"%A %d %B %Y %T"): По умолчанию папка с лог-файлами: '$SOFT_LOG_PATH'" >> $USER_CONFIGURE_LOG_FILE
        SOFT_TASK_PATH="$SOFT_INSTALL_PATH/task"        # Папка с файлами для обработки
        echo "По умолчанию папка с файлами для обработки: '$SOFT_TASK_PATH'"
        echo "$(date +"%A %d %B %Y %T"): По умолчанию папка с файлами для обработки: '$SOFT_TASK_PATH'" >> $USER_CONFIGURE_LOG_FILE
        SOFT_OUTPUT_PATH="$SOFT_INSTALL_PATH/output"    # Папка с файлами - хранилище результатов обработки
        echo "По умолчанию папка с файлами - хранилище результатов обработки: '$SOFT_OUTPUT_PATH'"
        echo "$(date +"%A %d %B %Y %T"): По умолчанию папка с файлами - хранилище результатов обработки: '$SOFT_OUTPUT_PATH'" >> $USER_CONFIGURE_LOG_FILE
        SOFT_SERT_PATH='/usr/etc/pc'                    # Папка с сертификатами
        echo "По умолчанию папка с сертификатами: '$SOFT_SERT_PATH'"
        echo "$(date +"%A %d %B %Y %T"): Пользователь '$USER' выбрал по умолчанию папку с сертификатами: '$SOFT_SERT_PATH'" >> $USER_CONFIGURE_LOG_FILE
        break
    elif [[ "$answervar" =~ ^[nN]$ ]]; then
        echo "Вводится папка установки программы"
        return_entered_path SOFT_INSTALL_PATH $USER_CONFIGURE_LOG_FILE
        if [[ ! "$?" -eq 0 ]]; then
            echo "Ошибка ввода папки установки программы."
            echo "Настройка конфигурации установки программы закончена"
            echo "$(date +"%A %d %B %Y %T"): Ошибка ввода папки установки программы." >> $USER_CONFIGURE_LOG_FILE
            echo "$(date +"%A %d %B %Y %T"): Заканчиваем настройку конфигурации установки программы." >> $USER_CONFIGURE_LOG_FILE
            exit 1
        fi
        echo "Введена папка установки программы: '$SOFT_INSTALL_PATH'"
        echo "$(date +"%A %d %B %Y %T"): Пользователь '$USER' ввел папку установки программы: '$SOFT_INSTALL_PATH'" >> $USER_CONFIGURE_LOG_FILE
        SOFT_BIN_PATH="$SOFT_INSTALL_PATH/bin"                          # Папка с исполняемыми файлами
        echo "Введена папка с исполняемыми файлами: '$SOFT_BIN_PATH'"
        echo "$(date +"%A %d %B %Y %T"): Папка с исполняемыми файлами: '$SOFT_BIN_PATH'" >> $USER_CONFIGURE_LOG_FILE
        SOFT_DOCS_PATH="$SOFT_INSTALL_PATH/docs"                        # Папка с документами
        echo "Введена папка с документами: '$SOFT_DOCS_PATH'"
        echo "$(date +"%A %d %B %Y %T"): Папка с документами: '$SOFT_DOCS_PATH'" >> $USER_CONFIGURE_LOG_FILE
        SOFT_TEMP_PATH="$SOFT_INSTALL_PATH/temp"                        # Папка с временными файлами
        echo "Введена папка с временными файлами: '$SOFT_TEMP_PATH'"
        echo "$(date +"%A %d %B %Y %T"): Папка с временными файлами: '$SOFT_TEMP_PATH'" >> $USER_CONFIGURE_LOG_FILE
        SOFT_LOG_PATH="$SOFT_INSTALL_PATH/log"                          # Папка с лог-файлами
        echo "По умолчанию папка с лог-файлами: '$SOFT_LOG_PATH'"
        echo "$(date +"%A %d %B %Y %T"): Папка с лог-файлами: '$SOFT_LOG_PATH'" >> $USER_CONFIGURE_LOG_FILE
        SOFT_TASK_PATH="$SOFT_INSTALL_PATH/task"                        # Папка с файлами для обработки
        echo "Введена папка с файлами для обработки: '$SOFT_TASK_PATH'"
        echo "$(date +"%A %d %B %Y %T"): Папка с файлами для обработки: '$SOFT_TASK_PATH'" >> $USER_CONFIGURE_LOG_FILE
        SOFT_OUTPUT_PATH="$SOFT_INSTALL_PATH/output"                    # Папка с файлами - хранилище результатов обработки
        echo "Введена папка с файлами - хранилище результатов обработки: '$SOFT_OUTPUT_PATH'"
        echo "$(date +"%A %d %B %Y %T"): Папка с файлами - хранилище результатов обработки: '$SOFT_OUTPUT_PATH'" >> $USER_CONFIGURE_LOG_FILE
        echo "Вводится папка установки сертификатов"
        SOFT_SERT_PATH='/usr/etc/pc'                    # Папка с сертификатами
        echo "По умолчанию папка с сертификатами: '$SOFT_SERT_PATH'"
        echo "$(date +"%A %d %B %Y %T"): Пользователь '$USER' выбрал по умолчанию папку с сертификатами: '$SOFT_SERT_PATH'" >> $USER_CONFIGURE_LOG_FILE
        break
    fi
done
# определяем текущий год: продолжительность действия сертификата для каждого нового пользователя - один год
cur_year="$(date +%Y)"
cur_year+=""
# проверяем наличие файлов сертификатов *.lic в папке установки сертификатов
lic_file=''
count_lic_files_in_folder lic_count $SOFT_SERT_PATH $USER_CONFIGURE_LOG_FILE
if [[ ! "$?" -eq 0 ]]; then
    echo "Ошибка подсчета файлов-сертификатов в папке '$SOFT_SERT_PATH'."
    echo "Настройка конфигурации установки программы закончена"
    echo "$(date +"%A %d %B %Y %T"): Ошибка подсчета файлов-сертификатов в папке '$SOFT_SERT_PATH'." >> $USER_CONFIGURE_LOG_FILE
    echo "$(date +"%A %d %B %Y %T"): Заканчиваем настройку конфигурации установки программы." >> $USER_CONFIGURE_LOG_FILE
    exit 1
fi
echo "$(date +"%A %d %B %Y %T"): В папке установки сертификатов '$SOFT_SERT_PATH' найдено '$lic_count' сертификатов." >> $USER_CONFIGURE_LOG_FILE
if [[ "$lic_count" -gt 0 ]]; then
    for file_handler in $SOFT_SERT_PATH/*; do
        isFile return_is_file $file_handler
        if [[ "$return_is_file" -eq 1 && $(basename "$file_handler") =~ ^certificate[0-9]*\.lic$ ]]; then
            # Ищем совпадения по cur_year, username, email, phone.
            # Именно в таком порядке, т.е. если нет совпадения cur_year, то не будет искать совпадения далее по username и т.д.
            year_count=0
            username_count=0
            email_count=0
            phone_count=0
            for word_in_file in $(cat $file_handler); do
                if [[ "$year_count" -lt 1 && "$username_count" -lt 1 && "$email_count" -lt 1 && "$phone_count" -lt 1 ]]; then
                    if [[ "$word_in_file" = "$cur_year" ]]; then
                        let "year_count += 1"
                    fi
                fi
                if [[ "$year_count" -gt 0 && "$username_count" -lt 1 && "$email_count" -lt 1 && "$phone_count" -lt 1 ]]; then
                    if [[ "$word_in_file" = "$username" ]]; then
                        let "username_count += 1"
                    fi
                fi
                if [[ "$year_count" -gt 0 && "$username_count" -gt 0 && "$email_count" -lt 1 && "$phone_count" -lt 1 ]]; then
                    if [[ "$word_in_file" = "$email" ]]; then
                        let "email_count += 1"
                    fi
                fi
                if [[ "$year_count" -gt 0 && "$username_count" -gt 0 && "$email_count" -gt 0 && "$phone_count" -lt 1 ]]; then
                    if [[ "$word_in_file" = "$phone" ]]; then
                        let "phone_count += 1"
                    fi
                fi
            done
            if [[ "$year_count" -eq 1 && "$username_count" -eq 1 && "$email_count" -eq 1 && "$phone_count" -eq 1 ]]; then
                echo "Для введенных данных: user: $username, e-mail: $email, phone: $phone - есть сертификат на текущий год."
                lic_file=$SOFT_SERT_PATH/$file_handler
                echo "$(date +"%A %d %B %Y %T"): В папке установки сертификатов '$SOFT_SERT_PATH' для введенных данных: user - '$username', e-mail - '$email', phone - '$phone' есть сертификат на текущий год." >> $USER_CONFIGURE_LOG_FILE
            fi
        fi
    done
else
    sudo mkdir -p $SOFT_SERT_PATH
    sudo chown -R root:root $SOFT_SERT_PATH
fi
set +x
if [[ "$lic_count" -eq 0 ]]; then
    let "lic_count=1"
fi
if [[ -z "$lic_file" ]]; then
    echo "$(date +"%A %d %B %Y %T"): В папке установки сертификатов '$SOFT_SERT_PATH' для введенных данных: user - '$username', e-mail - '$email', phone - '$phone' нет сертификата на текущий год. Формируем его." >> $USER_CONFIGURE_LOG_FILE
    # формируем файл сертификата
    lic_file="certificate$lic_count.lic"
    sudo sed -e "s/YEAR/${cur_year}/; s/USERNAME/${username}/; s/EMAIL/${email}/; s/PHONE/${phone}/" certificate.default > $lic_file
    sudo chown -R root:root $lic_file
    sudo chmod 644 $lic_file
    sudo mv -ft $SOFT_SERT_PATH $lic_file
fi
# ищем конфигурационный файл для сертификата
conf_file="install$lic_count.conf"
echo "$(date +"%A %d %B %Y %T"): В текущей папке ищем конфигурационный файл '$conf_file' для сертификата '$lic_file'." >> $USER_CONFIGURE_LOG_FILE
rewrite_conf_file=0
isFile return_is_file $conf_file
if [[ "$return_is_file" -eq 1 ]]; then
    echo "$(date +"%A %d %B %Y %T"): В текущей папке найден конфигурационный файл '$conf_file' для сертификата '$lic_file'." >> $USER_CONFIGURE_LOG_FILE
    while true; do
        read -p "Конфигурационный файл '$conf_file' существует. Перезаписать новые данные (Y/N)?" answer_clean_conf_file
        if [[ "$answer_clean_conf_file" =~ ^[yY]$ ]]; then
            let "rewrite_conf_file=1"
            if [[ $(stat --printf='%U\n' $(pwd)) = "root" ]]; then
                sudo cp /dev/null $conf_file
            else
                cp /dev/null $conf_file
            fi
            echo "$(date +"%A %d %B %Y %T"): Конфигурационный файл '$conf_file' для сертификата '$lic_file' будет перезаписан." >> $USER_CONFIGURE_LOG_FILE
            break
        elif [[ "$answer_clean_conf_file" =~ ^[nN]$ ]]; then
            echo "$(date +"%A %d %B %Y %T"): Конфигурационный файл '$conf_file' для сертификата '$lic_file' останется прежним." >> $USER_CONFIGURE_LOG_FILE
            break
        fi
    done
elif [[ "$return_is_file" -eq 0 ]]; then
    let "rewrite_conf_file=1"
    echo "$(date +"%A %d %B %Y %T"): В текущей папке не найден конфигурационный файл '$conf_file' для сертификата '$lic_file'." >> $USER_CONFIGURE_LOG_FILE
fi
if [[ "$rewrite_conf_file" -eq 1 ]]; then
    echo "$(date +"%A %d %B %Y %T"): Записываем новый конфигурационный файл '$conf_file' для сертификата '$lic_file'." >> $USER_CONFIGURE_LOG_FILE
    USER_SAVE_CONFIGURE=$(pwd)/$conf_file
    echo "$SOFT_SERT_PATH/$lic_file" > $USER_SAVE_CONFIGURE                 # 1 строка
    echo ${SOFT_INSTALL_PATH} >> $USER_SAVE_CONFIGURE                       # 2 строка
    echo ${SOFT_BIN_PATH} >> $USER_SAVE_CONFIGURE                           # 3 строка
    echo ${SOFT_DOCS_PATH} >> $USER_SAVE_CONFIGURE                          # 4 строка
    echo ${SOFT_TEMP_PATH} >> $USER_SAVE_CONFIGURE                          # 5 строка
    echo ${SOFT_LOG_PATH} >> $USER_SAVE_CONFIGURE                           # 6 строка
    echo ${SOFT_TASK_PATH} >> $USER_SAVE_CONFIGURE                          # 7 строка
    echo ${SOFT_OUTPUT_PATH} >> $USER_SAVE_CONFIGURE                        # 8 строка
fi
echo "$(date +"%A %d %B %Y %T"): Настройка конфигурации установки программы закончена." >> $USER_CONFIGURE_LOG_FILE
echo "Настройка конфигурации установки программы закончена"
# set +x