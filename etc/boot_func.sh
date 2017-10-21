#!/system/bin/sh

#{ Regular output
REG_LOGS="/data/regular_output.logs"
log_output()
{
    echo "$(date) : \"$2\" : $1" >> $REG_LOGS
    return 0
}
#}

#{ Error part
LEAST_ERROR=""
ERROR_LOGS="/data/errors_output.logs"
## arg 1 : Error message.
## arg 2 : Error file.
error_log_output()
{
    LEAST_ERROR=${1}
    echo "$(date) : ERROR \"${2}\" : $LEAST_ERROR" >> $ERROR_LOGS
    return 0
}
#} End Error part
