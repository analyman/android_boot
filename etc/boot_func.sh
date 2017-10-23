#!/system/bin/sh

__FILE=${0}
__TEMP=`mktemp`

#{ Regular output
REG_LOGS="/data/priv_output.logs"
log_output()
{
    if [ ${1} = "-e" ]; then
        TAGS=" ERROR!"
    elif [ ${1} = "-w" ]; then
        TAGS="WARNING!"
    else
        TAGS="   OK!  "
    fi
    echo "$(date "+%m-%d %H:%M:%S") : $TAGS : \"$__FILE\" : $2" >> $__TEMP
    return 0 
}
#}

# Log Begin And Log End
LOG_ASR=""
LOG_ASL=""
FINAL=15
for i in $(seq 1 $FINAL); do
    LOG_ASR=$LOG_ASR">"
    LOG_ASL=$LOG_ASL"<"
done
## LOG_BEG
LOG_BEG()
{
    echo "" >> $__TEMP
    echo "$LOG_ASR\"$__FILE\"$LOG_ASR" >> $__TEMP
    return 0
}

## __exit function
__exit()
{
    echo "$LOG_ASL\"$__FILE\"$LOG_ASL" >> $__TEMP
    cat $__TEMP >> $REG_LOGS
    rm $__TEMP
    exit $1
}
