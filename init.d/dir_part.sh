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

# remove log file when boot
rm -f ${REG_LOGS}

# LOG_BEG function
LOG_BEG

# check the basic command -- busybox
log_output -r "check the busybox."
if [ -z `which busybox` ]; then
    error_log_output -e "You need install busybox."
    __exit 1
fi

#{ Termux /usr /bin
# check the termux
TERMUX="/data/data/com.termux/files/usr"
if [ ! -d $TERMUX ]; then
    log_output -e "The termux don't install."
    exit $EXIT_FAIL
fi

# link "/usr, /bin" from termux
log_output -r "make soft link from termux to root."
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
log_output -r "link the \"/var\" from \"termux\"."
if [ ! -e /var ]; then
    ln -s $TERMUX/var /var
fi
touch /var/spool/cron/crontabs/root
mount -o ro,remount,ro /
mount -o ro,remount,ro /system

# start crond
CRONLOG="/data/cron.logs"
log_output -r "start crond."
if [ -z `pgrep 'crond'` ]; then
    crond -c /var/spool/cron/crontabs -L $CRONLOG
else
    log_output -r "crond already start!"
fi
if [ `pgrep 'crond' | wc -l` -gt 0 ]; then
    log_output -r "Start crond service successfully."
else
    error_log_output -e "Start crond service failly."
fi
#}

log_output -r "Finish execute!"

# call __exit
__exit 0
