#! /bin/bash

sudo apt remove oem-somerville-tentacool-meta oem-somerville-meta
sudo apt remove libcamhal-ipu6ep-common libipu6 libipu6ep libcamhal-ipu6ep0 intel-ipu6-dkms
sudo apt autoremove
sudo rpm -e icamerasrc
sudo dkms remove ipu6-drivers/0.0.0
sudo find /usr/lib -xtype l -print -delete




