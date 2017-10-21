#!/system/bin/sh

# load the log function script
if [ -f /system/etc/boot_function.sh ]; then
    source /system/etc/boot_function.sh
fi

#{ Remove some app
APPLIST=`ls ${ANDROID_DATA}/app`
BAN_REGEX=("^.*anyview.*$")

#{ func : app_check
app_check()
{
    for one_regex in ${BAN_REGEX[@]}; do
        if [[ ${1} =~ $one_regex ]]; then
            return 0
        fi
    done
    return 1
}
#} end func : app_check

# Main -- remove some app
log_output "Processing remove app task." ${0}
for appname in ${APPLIST[@]}; do
    if (app_check $appname); then
        rm -rf $appname
        log_output "remove \"$appname\"." ${0}
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
log_output "remove text file in Download"
for text_file in $WORK_DIR/*; do
    if [[ $text_file=~^.*\.txt$ ]]; then
        log_output "rm file \"$text_file\"." ${0}
        rm -rf $text_file
    fi
done
#}

exit 0
