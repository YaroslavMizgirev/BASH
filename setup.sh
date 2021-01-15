#!/bin/bash
source return_entered_data.sh
source file_operation.sh
clear
USER_SETUP_LOG_FILE=$(pwd)/setup.log
USER_SAVE_CONFIGURE=$(pwd)/install.conf
error_count=0
echo "Производится установка программы"
echo "$(date +"%A %d %B %Y %T"): Начинаем установку программы." >> $USER_SETUP_LOG_FILE
echo "$(date +"%A %d %B %Y %T"): Проверяем наличие конфигурационного файла." >> $USER_SETUP_LOG_FILE
if [[ -f "$USER_SAVE_CONFIGURE" ]]; then
    exec 5<&0
    exec 0<$USER_SAVE_CONFIGURE
    SAVE_IFS=$IFS
    IFS=$'\n'
    echo "$(date +"%A %d %B %Y %T"): В конфигурационном файле считываем папку с сертификатом." >> $USER_SETUP_LOG_FILE
    read SOFT_SERT_FILE
    SOFT_SERT_FILE+="/certificate.lic"
    if [[ -z "$SOFT_SERT_FILE" ]]; then
        echo "В конфигурационном файле нет местоположения сертификата."
        echo "$(date +"%A %d %B %Y %T"): Ошибка: В конфигурационном файле нет местоположения сертификата." >> $USER_SETUP_LOG_FILE
        echo "$(date +"%A %d %B %Y %T"): Ошибка: Установка завершена." >> $USER_SETUP_LOG_FILE
        let "error_count++"
    fi
    echo "$(date +"%A %d %B %Y %T"): В конфигурационном файле считываем остальные установочные папки." >> $USER_SETUP_LOG_FILE
    read SOFT_INSTALL_PATH
    if [[ -z "$SOFT_INSTALL_PATH" ]]; then
        echo "В конфигурационном файле нет основной папки установки программы."
        echo "$(date +"%A %d %B %Y %T"): Ошибка: В конфигурационном файле нет основной папки установки программы." >> $USER_SETUP_LOG_FILE
        echo "$(date +"%A %d %B %Y %T"): Ошибка: Установка завершена." >> $USER_SETUP_LOG_FILE
        let "error_count++"
    fi
    read SOFT_BIN_PATH
    if [[ -z "$SOFT_BIN_PATH" ]]; then
        echo "В конфигурационном файле нет папки с исполняемыми файлами."
        echo "$(date +"%A %d %B %Y %T"): Ошибка: В конфигурационном файле нет папки с исполняемыми файлами." >> $USER_SETUP_LOG_FILE
        echo "$(date +"%A %d %B %Y %T"): Ошибка: Установка завершена." >> $USER_SETUP_LOG_FILE
        let "error_count++"
    fi
    read SOFT_DOCS_PATH
    if [[ -z "$SOFT_DOCS_PATH" ]]; then
        echo "В конфигурационном файле нет папки с документами."
        echo "$(date +"%A %d %B %Y %T"): Ошибка: В конфигурационном файле нет папки с документами." >> $USER_SETUP_LOG_FILE
        echo "$(date +"%A %d %B %Y %T"): Ошибка: Установка завершена." >> $USER_SETUP_LOG_FILE
        let "error_count++"
    fi
    read SOFT_TEMP_PATH
    if [[ -z "$SOFT_TEMP_PATH" ]]; then
        echo "В конфигурационном файле нет папки с временными файлами."
        echo "$(date +"%A %d %B %Y %T"): Ошибка: В конфигурационном файле нет папки с временными файлами." >> $USER_SETUP_LOG_FILE
        echo "$(date +"%A %d %B %Y %T"): Ошибка: Установка завершена." >> $USER_SETUP_LOG_FILE
        let "error_count++"
    fi
    read SOFT_INPUT_PATH
    if [[ -z "$SOFT_INPUT_PATH" ]]; then
        echo "В конфигурационном файле нет папки с файлами для обработки."
        echo "$(date +"%A %d %B %Y %T"): Ошибка: В конфигурационном файле нет папки с файлами для обработки." >> $USER_SETUP_LOG_FILE
        echo "$(date +"%A %d %B %Y %T"): Ошибка: Установка завершена." >> $USER_SETUP_LOG_FILE
        let "error_count++"
    fi
    read SOFT_OUTPUT_PATH
    if [[ -z "$SOFT_OUTPUT_PATH" ]]; then
        echo "В конфигурационном файле нет папки с файлами - хранилище результатов обработки."
        echo "$(date +"%A %d %B %Y %T"): Ошибка: В конфигурационном файле нет папки с файлами - хранилище результатов обработки." >> $USER_SETUP_LOG_FILE
        echo "$(date +"%A %d %B %Y %T"): Ошибка: Установка завершена." >> $USER_SETUP_LOG_FILE
        let "error_count++"
    fi
    exec 0<&5
    IFS=$SAVE_IFS
    if [[ "$error_count" -gt 0 ]]; then
        exit 1
    fi
    if [[ -f "$SOFT_SERT_FILE" ]]; then
        username=$(return_entered_username $USER_SETUP_LOG_FILE)
        email=$(return_entered_email $USER_SETUP_LOG_FILE)
        phone=$(return_entered_phone $USER_SETUP_LOG_FILE)
        year=$(date +%Y)
        username_count=0
        email_count=0
        phone_count=0
        year_count=0
        echo "$(date +"%A %d %B %Y %T"): В сертификате проверяем совпадение введенных пользователем $USER данных." >> $USER_SETUP_LOG_FILE
        while read LINE; do
            if [[ "$username_count" -lt 1 ]]; then
                echo "$LINE" | grep "$username"; result=$?
                if [[ "$result" -eq 0 ]]; then
                    echo "Поле '$username' присутствует в сертификате."
                    echo "$(date +"%A %d %B %Y %T"): Поле '$username' присутствует в сертификате." >> $USER_SETUP_LOG_FILE
                    let "username_count++"
                fi
            fi
            if [[ "$email_count" -lt 1 ]]; then
                echo "$LINE" | grep "$email"; result=$?
                if [[ "$result" -eq 0 ]]; then
                    echo "Поле '$email' присутствует в сертификате."
                    echo "$(date +"%A %d %B %Y %T"): Поле '$email' присутствует в сертификате." >> $USER_SETUP_LOG_FILE
                    let "email_count++"
                fi
            fi
            if [[ "$phone_count" -lt 1 ]]; then
                echo "$LINE" | grep "$phone"; result=$?
                if [[ "$result" -eq 0 ]]; then
                    echo "Поле '$phone' присутствует в сертификате."
                    echo "$(date +"%A %d %B %Y %T"): Поле '$phone' присутствует в сертификате." >> $USER_SETUP_LOG_FILE
                    let "phone_count++"
                fi
            fi
            if [[ "$year_count" -lt 1 ]]; then
                echo "$LINE" | grep "$year"; result=$?
                if [[ "$result" -eq 0 ]]; then
                    echo "Поле '$year' присутствует в сертификате."
                    echo "$(date +"%A %d %B %Y %T"): Поле '$year' присутствует в сертификате." >> $USER_SETUP_LOG_FILE
                    let "year_count++"
                fi
            fi
        done < $SOFT_SERT_FILE
        if [[ "$username_count" -gt 0 && "email_count" -gt 0 && "phone_count" -gt 0 && "year_count" -gt 0 ]]; then
            echo "Создаем папки указанные в конфигурационном файле."
            echo "$(date +"%A %d %B %Y %T"): Создаем установочные папки указанные в конфигурационном файле." >> $USER_SETUP_LOG_FILE
            sudo mkdir -p $SOFT_INSTALL_PATH
            sudo mkdir -p $SOFT_BIN_PATH
            sudo mkdir -p $SOFT_DOCS_PATH
            sudo mkdir -p $SOFT_TEMP_PATH
            sudo mkdir -p $SOFT_INPUT_PATH
            sudo mkdir -p $SOFT_OUTPUT_PATH
            echo "$(date +"%A %d %B %Y %T"): Разносим файлы по созданным папкам." >> $USER_SETUP_LOG_FILE
            sudo mv -f ∗.run $SOFT_BIN_PATH/
            sudo mv -f ∗.sh $SOFT_BIN_PATH/
            sudo mv -f ∗.pdf $SOFT_DOCS_PATH/
            sudo mv -f ∗.txt $SOFT_DOCS_PATH/
            sudo mv -f ∗.log $SOFT_TEMP_PATH/
            sudo mv -f ∗.task $SOFT_INPUT_PATH/
            echo "$(date +"%A %d %B %Y %T"): Создаем символические ссылки в /usr/bin/." >> $USER_SETUP_LOG_FILE
            sudo ln -s $SOFT_BIN_PATH/polynom_calc.run /usr/bin/polynom_calc.exe
            sudo ln -s $SOFT_BIN_PATH/remove.sh /usr/bin/uninstall_polynom_calc.exe
            echo "Установка завершена."
            echo "$(date +"%A %d %B %Y %T"): Установка завершена успешно." >> $USER_SETUP_LOG_FILE
        else
            echo "Введенные данные отсутствуют в сертификате."
            echo "$(date +"%A %d %B %Y %T"): Ошибка: Введенные пользователем $USER данные username: '$username', email: '$email',  phone: '$phone', year: '$year' отсутствуют в сертификате '$SOFT_SERT_FILE'." >> $USER_SETUP_LOG_FILE
            echo "$(date +"%A %d %B %Y %T"): Ошибка: Установка завершена." >> $USER_SETUP_LOG_FILE
            exit 1
        fi
    else
        echo "Отсутствует файл-сертификат '$SOFT_SERT_FILE'. Запустите скрипт 'configure.sh' для создания сертификата."
        echo "$(date +"%A %d %B %Y %T"): Ошибка: Отсутствует файл-сертификат '$SOFT_SERT_FILE'." >> $USER_SETUP_LOG_FILE
        echo "$(date +"%A %d %B %Y %T"): Ошибка: Установка завершена." >> $USER_SETUP_LOG_FILE
        exit 1
    fi
else
    echo "Отсутствует конфигурационный файл '$USER_SAVE_CONFIGURE'."
    echo "$(date +"%A %d %B %Y %T"): Ошибка: Отсутствует конфигурационный файл '$USER_SAVE_CONFIGURE'." >> $USER_SETUP_LOG_FILE
    echo "$(date +"%A %d %B %Y %T"): Ошибка: Установка завершена." >> $USER_SETUP_LOG_FILE
    exit 1
fi
