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
for binfile in $(ls $bin_dir); do
    cp $bin_dir/$binfile $bin_install
    chmod 755 $bin_install/$binfile
done
## etc part
for etcfile in $(ls $etc_dir); do
    cp $etc_dir/$etcfile $etc_install
    chmod 755 $etc_install/$etcfile
done
## init part
for initfile in $(ls $init_dir); do
    cp $init_dir/$initfile $init_install
    chmod 755 $init_install/$initfile
done

mount -o ro,remount,ro /system

exit 0
