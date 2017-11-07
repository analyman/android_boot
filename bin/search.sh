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

if [ -z $1 ]; then
    log_output -e "search need a regex."
    echo "search need a regex."
    __exit 1
else
    log_output -r "REGEX is /$1/"
fi

data_base="/data/file.list"
search_temp="/data/search.$$.temp"

for i in $(seq 1 10); do
    if [ ! -z `lsof | grep "\/data\/file\.list$"` ]; then
        sleep 5
        log_output -w "Wait for the <$data_base> file be closed."
        echo "Wait for the <$data_base> file be closed."
        if [ $i -eq 10 ]; then
            log_output -e "Waitting too long, exit."
            echo "Waitting too long, exit."
            __exit 1
        fi
    else
        break
    fi
done

sed -n "/$1/p" $data_base > $search_temp

if [ ! -s $search_temp ]; then
    log_output -r "not match any file."
    echo "Not match any file."
    rm -f $search_temp
    __exit 0
fi

line_total=`wc -l $search_temp | grep -o '[0-9]*'`
__str__=
out_temp="/data/$$.search"
for line_i in $(seq 1 $line_total); do
    __str__=(`sed -n "$line_i p" $search_temp`)
    if [ -f ${__str__[7]} ]; then
        ls -1l ${__str__[7]} >> $out_temp
    fi
done

if [ ! -s $out_temp ]; then
    log_output -r "No search result."
    echo "No search result."
    __exit 0
fi
rm -f $search_temp
log_output -r "search result in <$out_temp>, the file will exist 1 minute."
echo "search result in <$out_temp>, the file will exist 1 minute."
echo "########---RESULTS:"
cat $out_temp
sh -c "sleep 60; rm -f $out_temp" &

__exit 0
