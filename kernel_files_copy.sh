#!/bin/bash
##Make all nessisary files executeable
kernel="$(uname -r)"
source /opt/Rubber-Ducky-Pi/.vars
cd "$work_dir"
chmod 755 hid-gadget-test.c duckpi.sh usleep.c g_hid.ko usleep hid-gadget-test hid-gadget-test_german.c

\cp -r g_hid.ko /lib/modules/${kernel}/kernel/drivers/usb/gadget/legacy

if [ "$1" != "hello" ]
then
    echo "Succses, your Raspberry Pi reboots in 5 seconds"
    sleep 10
    sudo reboot
fi
