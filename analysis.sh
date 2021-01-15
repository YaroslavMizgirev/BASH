#!/bin/bash
USER_SAVE_CONFIGURE=$(pwd)/install.conf
LOG_DIR=$(cd ..; cd temp; pwd)
argv=0
while [ -n "$1" ]; do
    case "$1" in
    -h)
        if [[ $argv -ne 0 ]]; then
            echo "Error. More than one key"
            exit 1
        fi
        argv=1
        ;;
    -d)
        if [[ $argv -ne 0 ]]; then
            echo "Error. More than one key"
            exit 1
        fi
        argv=2
        t="$(echo "$2" | awk '/^[0-9]{2}_[0-9]{2}_[0-9]{2}$/{print $0}')"
        if [[ ! -n "$t" ]]; then
            echo "Wrong data format."
            echo "Exit."
            exit 1
        fi
        shift
        ;;
    -f)
        if [[ $argv -ne 0 ]]; then
            echo "Error. More than one key"
            exit 1
        fi
        argv=3
        f="$2"
        if [[ -f "$log$f" ]]; then
            f="$log$f"
        else
            echo "File not found."
            echo "Exit."
            exit 1
        fi
        shift
        ;;
    *)
        echo "Error key."
        echo " \"-h\" -  for help "
        echo "Exit."
        exit 1
    esac
    shift
done
if [[ $argv -eq 1 ]]; then
    echo "Используйте: $0 '-h' - для показа этой справки."
    echo "Используйте: $0 '-d dd_mm_yy' - поиск производится во всех файлах только на заданный пользователем день."
    echo "Используйте: $0 '-f filename.log' - поиск производится только в заданном лог-файле."
    echo "Вы можете использовать только один ключ при каждом запуске этого скрипта."
    exit 0
fi
LOG_DIR+=/*.log
if [[ $argv -ne 2 ]]; then
        logs="/var/log/calculator/counter"
        count=$(awk '{print $0}' "$logs")
        if [[ $argv -ne 3 ]]
        then
            echo "The program was running $count times."
        fi
else
    count=0
    logdir="/var/log/calculator/$t*.log"
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
    timing=()
    for ((i = 0; i < 24; i++)); do
        timing+=( 0 )
    done
    pro=0
    for file in $logdir; do
        if [[ $argv -eq 3 ]]; then
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
        if [[ $argv -eq 3 ]]; then
            break
        fi
    done
    if [[ $argv -eq 2 ]]; then
        echo "The program was running $count times at this day"
    fi
    echo "KEY ERROR: $KEY"
    echo "OPEN ERROR: $OPEN"
    echo "INERROR: $INERROR"
    echo "MON $mon LAUNCHES"
    echo "TUE $tue LAUNCHES"
    echo "WED $wed LAUNCHES"
    echo "THU $thu LAUNCHES"
    echo "FRI $fri LAUNCHES"
    echo "SAT $sat LAUNCHES"
    echo "SUN $sun LAUNCHES"
    for ((i = 0; i < 24; i++)); do
        if [[ ${timing[$i]} -ne 0 ]]; then
            echo "$i HOUR - ${timing[$i]} LAUNCHES"
        fi
    done
    echo "INPUT FILES $procount"
