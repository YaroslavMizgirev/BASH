#!/bin/bash
source return_entered_data.sh
source file_operation.sh
clear
USER_CONFIGURE_LOG_FILE=$(pwd)/configure.log
USER_SAVE_CONFIGURE=$(pwd)/install.conf
echo "Производится настройка конфигурации установки программы"
echo "$(date +"%A %d %B %Y %T"): Начинаем настройку конфигурации установки программы." >> $USER_CONFIGURE_LOG_FILE
return_entered_username username $USER_CONFIGURE_LOG_FILE
return_entered_email email $USER_CONFIGURE_LOG_FILE
return_entered_phone phone $USER_CONFIGURE_LOG_FILE
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
        echo "Вводится папка местоположения сертификатов"
        return_entered_path SOFT_SERT_PATH $USER_CONFIGURE_LOG_FILE     # Папка с сертификатами
        echo "Введена папка местоположения сертификатов: $SOFT_SERT_PATH"
        echo "$(date +"%A %d %B %Y %T"): Пользователь $USER ввел папку местоположения сертификатов: $SOFT_SERT_PATH" >> $USER_CONFIGURE_LOG_FILE
        break
    else
        echo "Неверный ввод. Повторите."
        echo "$(date +"%A %d %B %Y %T"): Пользователь $USER не может ввести правильный символ y|Y или n|N в ответ на запрос." >> $USER_CONFIGURE_LOG_FILE
    fi
done
# формируем файл сертификата
cur_year=$(date +%Y)
sudo sed -e "s/YEAR/${cur_year}/; s/USERNAME/${username}/; s/EMAIL/${email}/; s/PHONE/${phone}/" certificate.default > certificate.lic
sudo chown -R root:root certificate.lic
sudo chmod 644 certificate.lic
# формируем папку сертификата
if [[ ! -d "$SOFT_SERT_PATH" ]]; then
    sudo mkdir -p $SOFT_SERT_PATH
    sudo chown -R root:root $SOFT_SERT_PATH
fi
sudo mv -ft $SOFT_SERT_PATH certificate.lic
# записываем конфигурационный файл для установки
echo ${SOFT_SERT_PATH} > $USER_SAVE_CONFIGURE                           # 1 строка
echo ${SOFT_INSTALL_PATH} >> $USER_SAVE_CONFIGURE                       # 2 строка
echo ${SOFT_BIN_PATH} >> $USER_SAVE_CONFIGURE                           # 3 строка
echo ${SOFT_DOCS_PATH} >> $USER_SAVE_CONFIGURE                          # 4 строка
echo ${SOFT_TEMP_PATH} >> $USER_SAVE_CONFIGURE                          # 5 строка
echo ${SOFT_LOG_PATH} >> $USER_SAVE_CONFIGURE                           # 6 строка
echo ${SOFT_TASK_PATH} >> $USER_SAVE_CONFIGURE                          # 7 строка
echo ${SOFT_OUTPUT_PATH} >> $USER_SAVE_CONFIGURE                        # 8 строка
echo "$(date +"%A %d %B %Y %T"): Заканчиваем настройку конфигурации установки программы." >> $USER_CONFIGURE_LOG_FILE
echo "Настройка конфигурации установки программы закончена"