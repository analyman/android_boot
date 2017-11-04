#!/system/sh

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

HOSTS_URL="https://raw.githubusercontent.com/googlehosts/hosts/master/hosts-files/hosts"
if (uname | grep 'Android' >> /dev/null); then
    OUTPUT_FILE=/data/hosts
else
    OUTPUT_FILE=$HOME/hosts
fi
if [ -f $OUTPUT_FILE ]; then
    rm -f $OUTPUT_FILE
fi

# curl check
if !(which curl >> /dev/null); then
    log_output -e "Need install curl."
    __exit 1
fi
# ps check
if !(which ps >> /dev/null); then
    log_output -e "Need ps command."
    __exit 1
fi

# Main Process
curl -o ${OUTPUT_FILE} ${HOSTS_URL} >> /dev/null &
curl_pid=$!
__LOOP=12
for count in $(seq 1 $__LOOP); do
    if !(ps ${curl_pid} | grep '[0-9]' >> null); then
        if [ -f $OUTPUT_FILE ];then
            log_output -r "getting hosts maybe ok!"
            break
        else
            log_output -e "getting hosts fail, unknow reason."
            __exit 1
        fi
    fi
    if [ $count -eq $__LOOP ]; then
        log_output -e "timeout, when get the hosts file."
        rm -f $OUTPUT_FILE
        kill $curl_pid
        __exit 1
    fi
    sleep 5
done
## replace by get file
if [ $USER="root" ]; then
    cp -f $OUTPUT_FILE /etc/hosts
else
    echo "Maybe run this script by root"
    __exit 1
fi
if [ -f /etc/hosts.hate ]; then
    log_output -r "merge the hate hosts file to getting file."
    if [ $OUTPUT_FILE="/data/hosts" ]; then
        mount -o rw,remount,rw /system
        cat /etc/hosts.hate >> /etc/hosts
        mount -o ro,remount,ro /system
    fi
    cat /etc/hosts.hate >> /etc/hosts
fi

__exit 0
