#!/system/bin/sh

#{ Regular output
REG_LOGS="/data/priv_output.logs"
log_output()
{
    if [ ${1}="-e" ]; then
        TAGS=" ERROR!"
    elif [ ${1}="-w" ]; then
        TAGS="WARNING!"
    else
        TAGS="   OK!  "
    fi
    echo "$(date "+%m-%d %H:%M:%S") : $TAGS : \"$2\" : $3" >> $REG_LOGS 
    return 0 
}
#}

# Log Begin And Log End
LOG_ASR=""
LOG_ASL=""
FINAL=15
i=0
while [ $i -lt $FINAL ]; do
    LOG_ASR=$LOG_ASR">"
    LOG_ASL=$LOG_ASL"<"
done
## LOG_BEG
LOG_BEG()
{
    echo "" >> $REG_LOGS
    echo "$LOG_ASR\"$1\"$LOG_ASR" >> $REG_LOGS
    return 0
}
## LOG_END
LOG_END()
{
    echo "$LOG_ASL\"$1\"$LOG_ASL" >> $REG_LOGS
    return 0
}
