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

# check sed
if [ -z `which sed` ]; then
    log_output -e "Need sed."
    __exit 1
fi

for i in $(seq 1 100); do
    if [ ! -z `lsof | grep "\/data\/file\.list$"` ]; then
        sleep 1
        log_output -w "Wait for the <$data_base> file be closed."
        if [ $i -eq 100 ]; then
            log_output -e "Waitting too long, exit."
            __exit 1
        fi
    else
        break
    fi
done

data_base="/data/file.list"
__line=
line_count=1
line_total=`wc -l $data_base | grep -o '[0-9]'*`
while [ $line_count -le $line_total ]; do
    __line=(`sed -n "$line_count p" $data_base`)
    # remove blank file
    if [ ${__line[4]} -eq 0 ]; then
        rm -f ${__line[7]}
        log_output -r "TRY TO REMOVE FILE <${__line[7]}>."
        sed -in "$line_count d" $data_base
        line_total=$[$line_total - 1]
        continue
    fi
    # check apk file
    if [ `xxd -p -l 2 ${__line[7]}`='504b' ]; then
        __test__=(`xxd -p -l 49`)
        __str__=`echo ${__test__[1]} | xxd -pr`
        ## zip file
        if [ $__str__="META-INF/MANIFEST.M" ] || [ $__str__="AndroidMainfest.xml" ]; then
            rm -f ${__line[7]}
            log_output -r "TRY REMOVE APK FILE <${__line[7]}>."
            sed -in "$line_count d" $data_base
            line_total=$[$line_total - 1]
            continue
        fi
    fi
    line_count=$[$line_count + 1]
done

# exit
__exit 0
