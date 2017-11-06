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

HOSTS="/system/etc/hosts"
HOSTS_HATE="/system/etc/hosts.hate"
HOSTS_SRC="/data/hosts"
github_src="https://raw.githubusercontent.com/analyman/android_boot/master/etc/hosts.hate"

#{ Checking...
checking()
{
    if [ ! -f $HOSTS ]; then
        if [ -f ${HOSTS_SRC} ]; then
            cp ${HOSTS_SRC} $HOSTS
        fi
    else
        log_output -w "Don't exist a hosts file."
        if [ ! -z `which get_hosts.sh` ]; then
            log_output -r "Get hosts from internet by script, after 1 minute."
            sh -c "sleep 60; get_hosts.sh && sleep 60; check_hosts.sh" &
        fi
    fi
    # Main...
    if [ ! -f ${HOSTS_HATE} ]; then
        log_output -w "The file <${HOSTS_HATE}> don't exist, try to get it from github."
        curl -o ${HOSTS_HATE} ${github_src}
        if [ $? -ne 0 ]; then
            log_output -w "Get hosts.hate file fail."
        fi
    fi
    if [ ! -f ${HOSTS_HATE} ] && [ ! -f ${HOSTS} ]; then
        log_output -e "Both hosts and hosts.hate file don't exist."
        __exit 1
    elif [ ! -f ${HOSTS_HATE} ]; then
        log_output -w "The hosts.hate don't exist, exit."
        __exit 1
    elif [ ! -f ${HOSTS} ]; then
        log_output -w "The hosts file don't exist, copy hosts.hate to it."
        cp $HOSTS_HATE $HOSTS
        __exit 1
    else
        if [[ ! $HOSTS -nt $HOSTS_HATE ]]; then
            log_output -r "<$HOSTS> is older than <HOSTS_HATE>."
            log_output -r "Merge <$HOSTS_HATE> to <$HOSTS>."
            mount -o rw,remount,rw /system
            echo "" >> $HOSTS
            cat $HOSTS_HATE >> $HOSTS
            sort $HOSTS | uniq > $HOSTS.temp
            mv $HOSTS.temp $HOSTS
            mount -o ro,remount,ro /system
            __exit 0
        fi
        if ( ! cat $HOSTS | grep "Priv[-]ADD" >> /dev/null ); then
            log_output -r "<$HOSTS> don't contain <$HOSTS_HATE>."
            log_output -r "Merge <$HOSTS_HATE> to <$HOSTS>."
            mount -o rw,remount,rw /system
            echo "" >> $HOSTS
            cat $HOSTS_HATE >> $HOSTS
            sort $HOSTS | uniq > $HOSTS.temp
            mv $HOSTS.temp $HOSTS
            mount -o ro,remount,ro /system
            __exit 0
        fi
    fi
    return 0
}
#} end Checking

# Main
checking

# __exit function
__exit 0
