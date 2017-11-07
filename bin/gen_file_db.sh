#!/system/bin/sh

# merge the log function
if [ -f /system/etc/boot_func.sh ]; then
    source /system/etc/boot_func.sh
else
#{ avoid a error
    LOG_BEG()
    {
        return 0
    }
    log_output()
    {
        return 0
    }
    __exit()
    {
        exit $1
    }
#}
fi

# LOG_BEG function
LOG_BEG

data_base="/data/file.list"
__sdcard="/sdcard"

for i in $(seq 1 100); do
    if [ ! -z `lsof | grep "\/data\/file\.list$"` ]; then
        sleep 1
        log_output -w "Wait for the <$data_base> file be closed."
        if [ $i -eq 100 ]; then
            log_output -e "Waitting too long, exit."
            __exit 1
        fi
    else
        break
    fi
done

rm -f $data_base

# gennerate file data_base
log_output -r "generate file data base in <$data_base>."
find $__sdcard/* -type f -exec ls -1l {} >> $data_base \;

__exit 0
