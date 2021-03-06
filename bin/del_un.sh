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

#{ Remove some app
APPLIST=`ls ${ANDROID_DATA}/app`
BAN_REGEX=("^.*anyview.*$"
"^com\.tencent\.tmgp\.sgame[-][0-9]$")

#{ func : app_check
app_check()
{
    for one_regex in ${BAN_REGEX[@]}; do
        if ( echo ${1} | grep $one_regex >> /dev/null ); then
            return 0
        fi
    done
    return 1
}
#} end func : app_check

# Main -- remove some app
log_output -r "Processing remove app task."
for appname in ${APPLIST[@]}; do
    if (app_check $appname); then
       pm uninstall ${appname%-*} 
       log_output -r "uninstall \"$appname\"."
    fi
done
#} end remove some app

#{ remove text file in download
WORK_DIR=${EXTERNAL_STORAGE}/Download
log_output -r "remove text file in Download"
for text_file in $(ls $WORK_DIR); do
    if ( echo $text_file | grep "^.*\.txt$" >> /dev/null ); then
        log_output -r "rm file \"$text_file\"."
        rm -rf $WORK_DIR/$text_file
    fi
done
#}

# call __exit function
__exit 0
