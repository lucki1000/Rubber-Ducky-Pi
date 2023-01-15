#!/bin/bash
##Make all nessisary files executeable
kernel="$(uname -r)"
source "/opt/Rubber-Ducky-Pi/.vars"
cd "$work_dir"
chmod 755 duckpi.sh usleep hid-gadget-test

if [ "$1" != "hello" ]
then
    echo "Succses, your Raspberry Pi reboots in 5 seconds"
    sleep 10
    sudo reboot
fi
