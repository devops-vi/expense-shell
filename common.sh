#!/bin/bash

LOG_FOLDER="/var/log/expenses/"
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
TIMESTAMP=$(date +%Y%m%D%H%M%S)
PID=$$
LOGFILE="$LOG_FOLDER/$SCRIPT_NAME_$PID_$TIMESTAMP.log"


LOG_MSG() {
    if [ ${1} = "F" -o ${1} = "E" ]; then
    echo -ne "${TIMESTAMP}-${1}-${SCRIPTNAME}-${2}" >&2 #STDERR
    else
    echo -ne "${TIMESTAMP}-${1}-${SCRIPTNAME}-${2}" >&1 #STDOUT
    fi
    return 0
}

CheckRV() {
    myrv=$?
    if [ ${myrv} -eq 0 ]; then
    return $myrv
    else
    LOG_MSG "F" "${2}"
    exit ${myrv}
    fi
}