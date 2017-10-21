#!/system/bin/sh

boot_func="./etc/boot_func.sh"
dir_part="./init.d/dir_part.sh"
sysinit="./bin/sysinit"

# remount /system
mount -o rw,remount,rw /system

# install
cp $boot_func /system/etc
if [ ! -d /su/su.d ]; then
    echo "You should use \"/su/su.d\" instead of \"/system/etc/init.d\" by installing SuperSU."
    cp $dir_part /system/etc/init.d
    chmod 755 /system/etc/boot_func.sh /system/etc/init.d/dir_part.sh
else
    echo "Install dir_part to \"/su/su.d\". and remove same file in \"/system/etc/init.d\" if it exists."
    cp $dir_part /su/su.d
    if [ -f /system/etc/init.d/dir_part.sh ]; then
        rm /system/etc/init.d/dir_part.sh
    fi
    chmod 755 /su/su.d/dir_part.sh /system/etc/boot_func.sh
fi
cp $sysinit /system/bin
chmod 755 /system/bin/sysinit
