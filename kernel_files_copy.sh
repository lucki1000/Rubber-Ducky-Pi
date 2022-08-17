kernel="$(uname -r)"
##Make all nessisary files executeable
cd /home/pi
chmod 755 hid-gadget-test.c duckpi.sh usleep.c g_hid.ko usleep hid-gadget-test hid-gadget-test_german.c

\cp -r g_hid.ko /lib/modules/${kernel}/kernel/drivers/usb/gadget/legacy

if [ "$1" != "hello" ]
then    
    echo "Succses, your Raspberry Pi reboots in 5 seconds"
    sleep 10
    sudo reboot
fi