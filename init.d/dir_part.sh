#!/system/bin/sh

# source boot function
BOOT_FUNC="/system/etc/boot_func.sh"
if [ -x $BOOT_FUNC ]; then
    source $BOOT_FUNC
else
    exit 1
fi

LOG_BEG ${0}

# check the basic command -- busybox
log_output -r ${0} "check the busybox."
if [ -z `which busybox` ]; then
    error_log_output -r ${0} "You need install busybox."
    exit 1
fi

#{ Termux /usr /bin
# check the termux
TERMUX="/data/data/com.termux/files/usr"
if [ ! -d $TERMUX ]; then
    log_output -e ${0} "The termux don't install."
    exit $EXIT_FAIL
fi

# link "/usr, /bin" from termux
log_output -r ${0} "make soft link from termux to root."
mount -o rw,remount,rw /
if [ ! -e /usr ]; then
    ln -s $TERMUX /usr
fi
if [ ! -e /bin ]; then
    ln -s $TERMUX/bin /bin
fi
mount -o ro,remount,ro /
#}

#{ crontab
mount -o rw,remount,rw /
mount -o rw,remount,rw /system
# link /var from termux
log_output -r ${0} "link the \"/var\" from \"termux\"."
if [ ! -e /var ]; then
    ln -s $TERMUX/var /var
fi
touch /var/spool/cron/crontabs/root
mount -o ro,remount,ro /
mount -o ro,remount,ro /system

# start crond
CRONLOG="/data/cron.logs"
log_output -r ${0} "start crond."
if [ -z `pgrep 'crond'` ]; then
    crond -c /var/spool/cron/crontabs -L $CRONLOG
else
    log_output -r ${0} "crond already start!"
fi
if [ `pgrep 'crond' | wc -l` -gt 0 ]; then
    log_output -r ${0} "Start crond service successfully."
else
    error_log_output -r ${0} "Start crond service failly."
fi
#}

log_output -r ${0} "Finish execute!"

LOG_END ${0}
exit 0
