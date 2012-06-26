#!/res/autoroot/sh

# DooMLoRD: relinkbusybox script (v01)

# [START] setting up
echo "[START] remounting system" > /data/local/tmp/relinkbusyboxlog.txt
/res/autoroot/busybox mount -o remount,rw /system >> /data/local/tmp/relinkbusyboxlog.txt

# [busybox binary] find existing occurances and relink
echo "[busybox binary] remove existing occurances and relink" >> /data/local/tmp/relinkbusyboxlog.txt
if /res/autoroot/busybox [ -f /system/xbin/busybox ]; 
then	
	echo "[busybox binary] found in /system/xbin/busybox " >> /data/local/tmp/relinkbusyboxlog.txt

	echo "remounting / as rw" > /data/local/tmp/relinkbusyboxlog.txt
	/res/autoroot/busybox mount -o remount,rw / >> /data/local/tmp/relinkbusyboxlog.txt

	echo "relinking /sbin/busybox to /system/xbin/busybox " >> /data/local/tmp/relinkbusyboxlog.txt
	/res/autoroot/busybox rm /sbin/busybox
	/res/autoroot/busybox ln -s /system/xbin/busybox /sbin/busybox
else
	echo "[busybox binary] not found in /system/xbin/busybox " >> /data/local/tmp/relinkbusyboxlog.txt
fi

echo "checking symlink of /sbin/busybox" >> /data/local/tmp/relinkbusyboxlog.txt
/res/autoroot/busybox ls -l /sbin/busybox >> /data/local/tmp/relinkbusyboxlog.txt

# [DONE] all done exiting
echo "[DONE] all done exiting" >> /data/local/tmp/relinkbusyboxlog.txt
