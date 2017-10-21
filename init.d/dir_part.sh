#!/system/bin/sh

# source boot function
BOOT_FUNC="/system/etc/boot_func.sh"
if [ -x $BOOT_FUNC ]; then
    source $BOOT_FUNC
else
    exit 1
fi

# check the basic command -- busybox
log_output "check the busybox." ${0}
if [ -z `which busybox` ]; then
    error_log_output "You need install busybox." ${0}
    exit 1
fi

#{ Termux /usr /bin
# check the termux
TERMUX="/data/data/com.termux/files/usr"
if [ ! -d $TERMUX ]; then
    error_log_output "The termux don't install." ${0}
    exit $EXIT_FAIL
fi

# link "/usr, /bin" from termux
log_output "make soft link from termux to root." ${0}
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
log_output "link the \"/var\" from \"termux\"." ${0}
if [ ! -e /var ]; then
    ln -s $TERMUX/var /var
fi
touch /var/spool/cron/crontabs/root
mount -o ro,remount,ro /
mount -o ro,remount,ro /system

# start crond
CRONLOG="/data/cron.logs"
log_output "start crond." ${0}
if [ -z `pgrep 'crond'` ]; then
    crond -c /var/spool/cron/crontabs -L $CRONLOG
else
    log_output "crond already start!" ${0}
fi
if [ `pgrep 'crond' | wc -l` -gt 0 ]; then
    log_output "Start crond service successfully." ${0}
else
    error_log_output "Start crond service failly." ${0}
fi
#}

log_output "Finish execute!" ${0}
exit 0
