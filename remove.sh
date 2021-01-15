#!/bin/bash
clear
USER_REMOVE_LOG_FILE=$HOME/remove.log
USER_SAVE_CONFIGURE=$HOME/install.conf
error_count=0
echo "Производится удаление программы"
while true; do
    read -p "Вы действительно хотите удалить программу. (Y/N): " answer_remove
    if [[ "$answervar" =~ ^[yY]$ ]]; then
        break 
    elif [[ "$answervar" =~ ^[nN]$ ]]; then
        exit 0
    else
        echo "Неверный ввод. Повторите."
    fi
done
echo "$(date +"%A %d %B %Y %T"): Начинаем удаление программы." >> $USER_REMOVE_LOG_FILE
echo "$(date +"%A %d %B %Y %T"): Проверяем наличие конфигурационного файла." >> $USER_REMOVE_LOG_FILE
if [[ -f "$USER_SAVE_CONFIGURE" ]]; then
    exec 5<&0
    exec 0<$USER_SAVE_CONFIGURE
    SAVE_IFS=$IFS
    IFS=$'\n'
    echo "$(date +"%A %d %B %Y %T"): В конфигурационном файле считываем папку с сертификатом." >> $USER_REMOVE_LOG_FILE
    read SOFT_SERT_FILE
    if [[ -z "$SOFT_SERT_FILE" ]]; then
        echo "В конфигурационном файле нет местоположения сертификата."
        echo "$(date +"%A %d %B %Y %T"): Ошибка: В конфигурационном файле нет местоположения сертификата." >> $USER_REMOVE_LOG_FILE
        echo "$(date +"%A %d %B %Y %T"): Ошибка: Удаление завершено." >> $USER_REMOVE_LOG_FILE
        let "error_count++"
    fi
    echo "$(date +"%A %d %B %Y %T"): В конфигурационном файле считываем остальные установочные папки." >> $USER_REMOVE_LOG_FILE
    read SOFT_INSTALL_PATH
    if [[ -z "$SOFT_INSTALL_PATH" ]]; then
        echo "В конфигурационном файле нет основной папки установки программы."
        echo "$(date +"%A %d %B %Y %T"): Ошибка: В конфигурационном файле нет основной папки установки программы." >> $USER_REMOVE_LOG_FILE
        echo "$(date +"%A %d %B %Y %T"): Ошибка: Удаление завершено." >> $USER_REMOVE_LOG_FILE
        let "error_count++"
    fi
    read SOFT_BIN_PATH
    if [[ -z "$SOFT_BIN_PATH" ]]; then
        echo "В конфигурационном файле нет папки с исполняемыми файлами."
        echo "$(date +"%A %d %B %Y %T"): Ошибка: В конфигурационном файле нет папки с исполняемыми файлами." >> $USER_REMOVE_LOG_FILE
        echo "$(date +"%A %d %B %Y %T"): Ошибка: Удаление завершено." >> $USER_REMOVE_LOG_FILE
        let "error_count++"
    fi
    read SOFT_DOCS_PATH
    if [[ -z "$SOFT_DOCS_PATH" ]]; then
        echo "В конфигурационном файле нет папки с документами."
        echo "$(date +"%A %d %B %Y %T"): Ошибка: В конфигурационном файле нет папки с документами." >> $USER_REMOVE_LOG_FILE
        echo "$(date +"%A %d %B %Y %T"): Ошибка: Удаление завершено." >> $USER_REMOVE_LOG_FILE
        let "error_count++"
    fi
    read SOFT_TEMP_PATH
    if [[ -z "$SOFT_TEMP_PATH" ]]; then
        echo "В конфигурационном файле нет папки с временными файлами."
        echo "$(date +"%A %d %B %Y %T"): Ошибка: В конфигурационном файле нет папки с временными файлами." >> $USER_REMOVE_LOG_FILE
        echo "$(date +"%A %d %B %Y %T"): Ошибка: Удаление завершено." >> $USER_REMOVE_LOG_FILE
        let "error_count++"
    fi
    read SOFT_INPUT_PATH
    if [[ -z "$SOFT_INPUT_PATH" ]]; then
        echo "В конфигурационном файле нет папки с файлами для обработки."
        echo "$(date +"%A %d %B %Y %T"): Ошибка: В конфигурационном файле нет папки с файлами для обработки." >> $USER_REMOVE_LOG_FILE
        echo "$(date +"%A %d %B %Y %T"): Ошибка: Удаление завершено." >> $USER_REMOVE_LOG_FILE
        let "error_count++"
    fi
    read SOFT_OUTPUT_PATH
    if [[ -z "$SOFT_OUTPUT_PATH" ]]; then
        echo "В конфигурационном файле нет папки с файлами - хранилище результатов обработки."
        echo "$(date +"%A %d %B %Y %T"): Ошибка: В конфигурационном файле нет папки с файлами - хранилище результатов обработки." >> $USER_REMOVE_LOG_FILE
        echo "$(date +"%A %d %B %Y %T"): Ошибка: Удаление завершено." >> $USER_REMOVE_LOG_FILE
        let "error_count++"
    fi
    exec 0<&5
    IFS=$SAVE_IFS
    if [[ "$error_count" -gt 0 ]]; then
        exit 1
    fi
    echo "Удаляем все папки указанные в конфигурационном файле."
    echo "$(date +"%A %d %B %Y %T"): Удаляем все папки указанные в конфигурационном файле." >> $USER_REMOVE_LOG_FILE
    sudo rm -rfv $SOFT_SERT_FILE
    sudo rm -rfv $SOFT_INSTALL_PATH
    echo "$(date +"%A %d %B %Y %T"): Удаляем символические ссылки в /usr/bin/." >> $USER_REMOVE_LOG_FILE
    sudo rm -fv /usr/bin/polynom_calc.exe
    sudo rm -fv /usr/bin/uninstall_polynom_calc.exe
    echo "$(date +"%A %d %B %Y %T"): Удаляем конфигурационный файл." >> $USER_REMOVE_LOG_FILE
    sudo rm -fv $USER_SAVE_CONFIGURE
    echo "Удаление завершено."
    echo "$(date +"%A %d %B %Y %T"): Удаление завершено успешно." >> $USER_REMOVE_LOG_FILE
else
    echo "Отсутствует конфигурационный файл '$USER_SAVE_CONFIGURE'."
    echo "$(date +"%A %d %B %Y %T"): Ошибка: Отсутствует конфигурационный файл '$USER_SAVE_CONFIGURE'." >> $USER_REMOVE_LOG_FILE
    echo "$(date +"%A %d %B %Y %T"): Ошибка: Удаление завершено." >> $USER_REMOVE_LOG_FILE
    exit 1
fi
