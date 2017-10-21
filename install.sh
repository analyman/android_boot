#!/system/bin/sh

bin_dir="./bin"
bin_install="/system/bin"
etc_dir="./etc"
etc_install="/system/etc"
init_dir="./init.d"
if [ -d /su/su.d ]; then
    init_install="/su/su.d"
else
    init_install="/system/etc/init.d"
fi

# remount /system
mount -o rw,remount,rw /system

# install
## bin part
for binfile in $bin_dir/*; do
    cp $binfile $bin_install
done
## etc part
for etcfile in $etc_dir/*; do
    cp $etcfile $etc_install
done
## init part
for initfile in $init_dir/*; do
    cp $initfile $init_install
done

mount -o ro,remount,ro /system

exit 0
