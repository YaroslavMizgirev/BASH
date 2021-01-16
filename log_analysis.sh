#!/bin/bash
USER_SAVE_CONFIGURE=$(pwd)/install.conf
LOG_DIR=$(cd ..; cd temp; pwd)
LOG=$LOG_DIR
param_count=0
while [ -n "$1" ]; do
    case "$1" in
    -h)
        if [[ "$param_count" -ne 0 ]]; then
            echo "Ошибка: При вызове скрипта использовался больше чем один параметр."
            exit 1
        fi
        param_count=1
        ;;
    -d)
        if [[ "$param_count" -ne 0 ]]; then
            echo "Ошибка: При вызове скрипта использовался больше чем один параметр."
            exit 1
        fi
        param_count=2
        log_time=$(echo "$2") | $(awk '/^0[1-9]|1[0-9]|2[0-9]|3[0-1]\.0[1-9]|1[0-2]\.[0-9][0-9]$/{print $0}')
        if [[ ! -n "$log_time" ]]; then
            echo "Некорректное значение даты."
            exit 1
        fi
        shift
        ;;
    -f)
        if [[ "$param_count" -ne 0 ]]; then
            echo "Ошибка: При вызове скрипта использовался больше чем один параметр."
            exit 1
        fi
        param_count=3
        LOG+="/$2"
        if [[ -f "$LOG" ]]; then
            f="$LOG"
        else
            echo "Указанный лог-файл не найден."
            exit 1
        fi
        shift
        ;;
    *)
        echo "Ошибка: Неподдерживаемый параметр."
        echo "Используйте: '$0 -h' - для показа справки."
        exit 1
    esac
    shift
done
if [[ $param_count -eq 1 ]]; then
    echo "Используйте: '$0 -h' - для показа этой справки."
    echo "Используйте: '$0 -d dd_mm_yy' - поиск производится во всех файлах только на заданный пользователем день."
    echo "Используйте: '$0 -f filename.log' - поиск производится только в заданном лог-файле."
    echo "Вы можете использовать только один ключ при каждом запуске скрипта."
    exit 0
fi

LOG+=/*.log
if [[ $param_count -ne 2 ]]; then
        log_counter="$LOG_DIR/counter"
        count=$(awk '{print $0}' "$log_counter")
        if [[ $param_count -ne 3 ]]
        then
            echo "Программа была запущена - $count раз."
        fi
else
    count=0
    LOG="$LOG_DIR/$log_time*.log"
fi

    OPEN=0
    KEY=0
    INERROR=0
    mon=0
    tue=0
    wed=0
    thu=0
    fri=0
    sat=0
    sun=0
    timing=0
    for (( i = 0; i < 24; i++ )); do
        let "timing += i"
    done
    pro=0
    for file in $LOG; do
        if [[ $param_count -eq 3 ]]; then
            file="$f"
        fi
        echo "$file"
        if [[ -f "$file" ]]; then
            count=$(( $count + 1 ))
            error=$(awk '/(-4: OPENFILE ERROR)$/{print $0}' "$file")
            if [[ -n "$error" ]]; then
                OPEN=$(( $OPEN + 1 ))
            fi
            error=$(awk '/(-3: KEY ERROR)$/{print $0}' "$file")
            if [[ -n "$error" ]]; then
                KEY=$(( $KEY + 1 ))
            fi
            error=$(awk '/(-6: INERROR)$/{print $0}' "$file")
            if [[ -n "$error" ]]; then
                INERROR=$(( $INERROR + 1 ))
            fi
            day=$(awk '/(Mon)$/{if (FNR == 1){print $NF} }' "$file")
            if [[ -n $day ]]; then
                mon=$(( $mon + 1 ))
            fi
            day=$(awk '/(Tue)$/{if (FNR == 1){print $NF} }' "$file")
            if [[ -n $day ]]; then
                tue=$(( $tue + 1 ))
            fi
            day=$(awk '/(Wed)$/{if (FNR == 1){print $NF} }' "$file")
            if [[ -n $day ]]; then
                wed=$(( $wed + 1 ))
            fi
            day=$(awk '/(Thu)$/{if (FNR == 1){print $NF} }' "$file")
            if [[ -n $day ]]; then
                thu=$(( $thu + 1 ))
            fi
            day=$(awk '/(Fri)$/{if (FNR == 1){print $NF} }' "$file")
            if [[ -n $day ]]; then
                fri=$(( $fri + 1 ))
            fi
            day=$(awk '/(Sat)$/{if (FNR == 1){print $NF} }' "$file")
            if [[ -n $day ]]; then
                sat=$(( $sat + 1 ))
            fi
            day=$(awk '/(Sun)$/{if (FNR == 1){print $NF} }' "$file")
            if [[ -n $day ]]; then
                sun=$(( $sun + 1 ))
            fi
            hour=$(awk '{if (FNR == 1){print $3}}' "$file" | awk 'BEGIN{FS=":"} {print $1}')
            timing[$(( $hour ))]=$(( ${timing[$(( $hour ))]} + 1 ))
            pro=$(awk '{last3 = last2; last2 = last1; last1 = this; this = $0} END {print last3}' "$file" | awk '/^(PROCESSED FILE:)/{print $0}')
            if [[ -n $proc ]]; then
                pro=$(( $pro + 1 ))
            fi
        fi
        if [[ $param_count -eq 3 ]]; then
            break
        fi
    done
    if [[ $param_count -eq 2 ]]; then
        echo "Программа была запущена $count раз сегодня."
    fi
    echo "Ошибка использования ключей при запуске программы: $KEY."
    echo "Ошибка открытия файла: $OPEN."
    echo "Ошибка входных данных: $INERROR."
    echo "Понедельник - '$mon' запусков."
    echo "Вторник - '$tue' запусков."
    echo "Среда - '$wed' запусков."
    echo "Четверг - '$thu' запусков."
    echo "Пятница - '$fri' запусков."
    echo "Суббота - '$sat' запусков."
    echo "Воскресенье - '$sun' запусков."
    for ((i = 0; i < 24; i++)); do
        if [[ ${timing[$i]} -ne 0 ]]; then
            echo "$i час - ${timing[$i]} запусков."
        fi
    done
    echo "Входящих файлов обработано - $procount."
