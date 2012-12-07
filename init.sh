#!/sbin/busybox sh

export PATH=/sbin

mkdir /proc
mkdir /sys
mount -t proc proc /proc
mount -t sysfs sys /sys

mkdir /dev
mknod /dev/null c 1 3
mknod /dev/zero c 1 5
mknod /dev/urandom c 1 9
mkdir /dev/block
mkdir /dev/input
mknod /dev/input/event0 c 13 64
mknod /dev/block/mmcblk0p13 b 179 13
mknod /dev/block/mmcblk0p12 b 179 12

mkdir /cache
mkdir /system
mount -t ext4 -o nodev,nosuid /dev/block/mmcblk0p13 /cache

if [ ! -f /cache/recovery/boot ]; then
	# trigger blue LED
	echo '255' > /sys/devices/i2c-3/3-0040/leds/blue/brightness
	# trigger button-backlight
	echo '255' > /sys/class/leds/button-backlight/brightness
	cat /dev/input/event0 > /dev/keycheck&
	sleep 3

	# trigger blue LED
	echo '0' > /sys/devices/i2c-3/3-0040/leds/blue/brightness
	# trigger button-backlight
	echo '0' > /sys/class/leds/button-backlight/brightness
fi

if [ -s /dev/keycheck -o -e /cache/recovery/boot ]
then
	rm /cache/recovery/boot
	umount /cache
	mkdir /etc
	
	# We avoid to have an etc folder directly in the ramdisk because
	# of the symlink /system/etc -> /etc with Sony's init.rc
	cp recovery.fstab /etc/recovery.fstab
	
	ln -s ../init_ics /sbin/ueventd
	rm /init.rc
	rm /init.semc.rc
	rm /init.usbmode.sh
	mv /recovery.rc /init.rc
	
	/init_ics
else
	umount /cache
	ln -s ../init_ics /sbin/ueventd
	
	# Change the build number according to the build.prop
	mount -t ext4 -o nodev,nosuid /dev/block/mmcblk0p12 /system
	NUM_VERSION=`cat /system/build.prop | grep ro.build.id | cut -d '=' -f2`
	sed -i "s/\(ro.semc.version.sw_revision=\)\(.*\)/\1$NUM_VERSION/" default.prop
	echo "${NUM_VERSION}-LT26" > crashtag
	umount /system

	# Boot stock ICS
	/init_ics
fi
