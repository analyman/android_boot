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

HOSTS_URL="https://raw.githubusercontent.com/googlehosts/hosts/master/hosts-files/hosts"
if [ -d /system/app ]; then
    OUTPUT_FILE=/data/hosts
else
    OUTPUT_FILE=$HOME/hosts
fi
if [ -f $OUTPUT_FILE ]; then
    rm -f $OUTPUT_FILE
fi

#{ prepare check
# root check
if [ ! $USER="root" ]; then
    echo "Maybe run this script by root"
    __exit 1
fi

# curl check
if [ -z `which curl` ]; then
    log_output -e "Need install curl."
    __exit 1
fi
# ps check
if [ -z `which ps` ]; then
    log_output -e "Need ps command."
    __exit 1
fi
#}

# Main Process
## get hosts file
curl -o ${OUTPUT_FILE} ${HOSTS_URL} &
curl_pid=$!
__LOOP=12
for count in $(seq 1 $__LOOP); do
    if [ -z `ps ${curl_pid} | grep "$curl_pid"` ]; then
        if [ -f $OUTPUT_FILE ];then
            log_output -r "Get hosts maybe ok!"
            break
        else
            log_output -e "Get hosts fail, unknow reason."
            __exit 1
        fi
    fi
    if [ $count -eq $__LOOP ]; then
        log_output -e "Timeout, when get the hosts file."
        rm -f $OUTPUT_FILE
        kill $curl_pid
        __exit 1
    fi
    sleep 5
done

## install hosts file
if [ -d /system/app ]; then
    mount -o rw,remount,rw /system
    cp -f $OUTPUT_FILE /system/etc
    if [ -f /system/etc/hosts.hate ]; then
        log_output -r "Merge the hate hosts file to getting file."
        cat /system/etc/hosts.hate >> /system/etc/hosts
    fi
    mount -o ro,remount,ro /system
else
    cp -f $OUTPUT_FILE /system/etc
    log_output -r "Merge the hate hosts file to getting file."
    cat /etc/hosts.hate >> /etc/hosts
fi

__exit 0
