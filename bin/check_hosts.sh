#!/system/bin/sh

# merge the log function
if [ -f /system/etc/boot_func.sh ]; then
    source /system/etc/boot_func.sh
fi

HOSTS="/system/etc/hosts"
HOSTS_HATE="/system/etc/hosts.hate"
#{ function : easy_check
easy_check()
{
    log_output "easy check the hosts file" ${0}
    if [[ ! $HOSTS -nt $HOSTS_HATE ]]; then
        log_output "Merge hosts.hate to hosts."
        mount -o rw,remount,rw /system
        echo "" >> $HOSTS
        cat $HOSTS_HATE >> $HOSTS
        mount -o ro,remount,ro /system
    fi
    return 0
}
#} end function : easy_check

#{ function : nice_check
nice_check()
{
    log_output "nice check is working."
    if !(cat $HOSTS | grep "Priv[-]ADD" >> /dev/null); then
        log_output "Merge hosts.hate to hosts."
        mount -o rw,remount,rw /system
        echo "" >> $HOSTS
        cat $HOSTS_HATE >> $HOSTS
        mount -o ro,remount,ro /system
    fi
    return 0
}
#}

# Main
if [ ! -f ${HOSTS_HATE} ]; then
    error_log_output "the file \"${HOSTS_HATE}\" don't exist." ${0}
    exit 1
fi
if [ $(date "+%M") -lt 5 ]; then
    nice_check
else
    easy_check
fi

exit 0
