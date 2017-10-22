#!/system/bin/sh

# load the log function script
if [ -f /system/etc/boot_func.sh ]; then
    source /system/etc/boot_func.sh
fi

LOG_BEG ${0}

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
log_output -r ${0} "Processing remove app task."
for appname in ${APPLIST[@]}; do
    if (app_check $appname); then
        rm -rf $appname
        log_output -r ${0} "remove \"$appname\"."
        pushd ${ANDROID_DATA}/data
        if [ -d $appname ]; then
            rm -rf $appname
        fi
        popd
        pushd ${EXTERNAL_STORAGE}/Android/data
        if [ -d $appname ]; then
            rm -rf $appname
        fi
        popd
    fi
done
#} end remove some app

#{ remove text file in download
WORK_DIR=${EXTERNAL_STORAGE}/Download
log_output -r ${0} "remove text file in Download"
for text_file in $(ls $WORK_DIR); do
    if ( echo $text_file | grep "^.*\.txt$" >> /dev/null ); then
        log_output -r ${0} "rm file \"$text_file\"."
        rm -rf $text_file
    fi
done
#}

LOG_END ${0}
exit 0
