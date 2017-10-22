#!/system/bin/sh

__FILE=${0}

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
    echo "$(date "+%m-%d %H:%M:%S") : $TAGS : \"$__FILE\" : $2" >> $REG_LOGS 
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
    echo "" >> $REG_LOGS
    echo "$LOG_ASR\"$__FILE\"$LOG_ASR" >> $REG_LOGS
    return 0
}
## LOG_END
LOG_END()
{
    echo "$LOG_ASL\"$__FILE\"$LOG_ASL" >> $REG_LOGS
    return 0
}
