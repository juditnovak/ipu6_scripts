#! /bin/bash

echo -e "\n\n******************************* system *******************************\n"
uname -a


echo -e "\n\n******************************* dpkg *******************************\n"
sudo dpkg-query -f='${Status}\t${binary:Package}\n' -W *vsc* *ipu6* *camera* *libcam* *v4l* | grep -v camel
echo 
sudo apt policy *vsc* *ipu6* *camera* *libcam* *gstream* *gst* *v4l*

echo -e "\n\n******************************* dmesg *******************************\n"
sudo dmesg | grep "\(vsc\|ipu\|ov02\|INT3472\|gst\|gstream\)" | grep -v pvscan

echo -e "\n\n******************************* syslog *******************************\n"
sudo cat /var/log/syslog | grep "\(vsc\|ipu\|ov02\|INT3472\|gst\|gstream\)" | grep -v pvscan

echo -e "\n\n******************************* device information *******************************\n"
udevadm info -a /dev/video0
udevadm info -a /dev/ipu-psys0

echo -e "\n\n******************************* gstreamer *******************************\n"
gst-device-monitor-1.0 Video/Source  2>&1

echo -e "\n\n******************************* lsmod *******************************\n"
sudo lsmod | grep "\(vsc\|ipu\|ov02\)"
lsmod | grep ipu6 | cut -d' ' -f1 | xargs modinfo
