#!/sbin/sh

# DooMLoRD: autoroot script (v13)

export PATH=/sbin

# [START] setting up
echo "[START] remounting system" > /data/local/tmp/autorootlog.txt
mount -o remount,rw /system >> /data/local/tmp/autorootlog.txt

# [CHECK] searching if autoroot was done before
echo "[CHECK] searching for autorooted file " >> /data/local/tmp/autorootlog.txt
if [ ! -f /system/autorooted ]; then
	echo "[NOT FOUND] autorooted file not found, removing existing root files ... " >> /data/local/tmp/autorootlog.txt
	rm /system/bin/su
	rm /system/xbin/su
	rm /system/app/Superuser.apk
	rm /data/app/Superuser.apk
	rm /system/xbin/busybox
	rm /system/bin/busybox
fi

# [CHECK] verify /system/xbin
echo "[CHECK] verifying /system/xbin " >> /data/local/tmp/autorootlog.txt
mkdir /system/xbin
chmod 755 /system/xbin

# [SU binary] remove existing occurances and push su
if [ ! -f /system/xbin/su ]; then
	echo "[SU binary] pushing su ..." >> /data/local/tmp/autorootlog.txt
	cp /res/autoroot/su /system/xbin/su
fi
echo "[SU binary] fixing su perms and owners ..." >> /data/local/tmp/autorootlog.txt
chown root.root /system/xbin/su
chmod 06755 /system/xbin/su

# [Superuser app] remove existing occurances and push app

if [ ! -f /system/app/Superuser.apk ]; then
	echo "[Superuser app] pushing app ..." >> /data/local/tmp/autorootlog.txt
	cp /res/autoroot/Superuser.apk /system/app/Superuser.apk
fi
echo "[Superuser app] fixing su perms and owners ..." >> /data/local/tmp/autorootlog.txt
chown root.root /system/app/Superuser.apk
chmod 0644 /system/app/Superuser.apk

# [busybox binary] remove existing occurances and push busybox
if [ ! -f /system/xbin/busybox ];
then
	echo "[busybox binary] pushing busybox ..." >> /data/local/tmp/autorootlog.txt
	cp /res/autoroot/busybox /system/xbin/busybox
fi
echo "[busybox] fixing busybox perms and owners ..." >> /data/local/tmp/autorootlog.txt
chown root.root /system/xbin/busybox
chmod 4777 /system/xbin/busybox
/system/xbin/busybox --install -s /system/xbin/

# [DONE] placing flag
echo "[DONE] placing flag" >> /data/local/tmp/autorootlog.txt
touch /system/autorooted

# [DONE] all done exiting
echo "[DONE] all done exiting" >> /data/local/tmp/autorootlog.txt 
