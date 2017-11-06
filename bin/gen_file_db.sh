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

# gennerate file data_base
log_output -r "generate file data base in <$data_base>."
find $__sdcard -f -exec ls -1l {} >> $data_base \;

__exit 0
