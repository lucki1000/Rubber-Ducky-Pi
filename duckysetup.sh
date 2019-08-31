#!/bin/bash
if [ $EUID -ne 0 ]; then
	echo "You must use sudo to run this script:"
	echo "sudo $0 $@"
	exit
fi
read -p "Enter Keyboard layout supported layouts: `echo $'\n de \n us \n '`" layout

apt update
apt upgrade -y
apt install -y rpi-update vim
echo "y" | rpi-update

## dwc2 drivers
sed -i -e "\$adtoverlay=dwc2" /boot/config.txt
echo "dwc2" | sudo tee -a /etc/modules
sudo echo "libcomposite" | sudo tee -a /etc/modules

##Install git and download rspiducky
wget --no-check-certificate https://raw.githubusercontent.com/lucki1000/Raspberry-Rubber-Ducky-Pi/master/LICENSE https://raw.githubusercontent.com/lucki1000/Raspberry-Rubber-Ducky-Pi/master/duckpi.sh https://raw.githubusercontent.com/lucki1000/Raspberry-Rubber-Ducky-Pi/master/g_hid.ko https://raw.githubusercontent.com/lucki1000/Raspberry-Rubber-Ducky-Pi/master/hid-gadget-test.c https://raw.githubusercontent.com/lucki1000/Raspberry-Rubber-Ducky-Pi/master/hid_usb https://raw.githubusercontent.com/lucki1000/Raspberry-Rubber-Ducky-Pi/master/readme.md https://raw.githubusercontent.com/lucki1000/Raspberry-Rubber-Ducky-Pi/master/usleep https://raw.githubusercontent.com/lucki1000/Raspberry-Rubber-Ducky-Pi/master/usleep.c https://raw.githubusercontent.com/lucki1000/Raspberry-Rubber-Ducky-Pi/master/hid-gadget-test_german.c

if [[ $layout == "de" ]]
then	
	gcc hid-gadget-test_german.c -o hid-gadget-test
fi

if [[ $layout == "us" ]]
then
	gcc gcc hid-gadget-test.c -o gcc hid-gadget-test
fi

##Make all nessisary files executeable
cd /home/pi
chmod 755 hid-gadget-test.c duckpi.sh usleep.c g_hid.ko usleep hid-gadget-test hid-gadget-test_german.c

\cp -r g_hid.ko /lib/modules/4.??.??+/kernel/drivers/usb/gadget/legacy

cat <<'EOF'>>/etc/modules
dwc2
g_hid
EOF

##Make it so that you can put the payload.dd in the /boot directory
sudo cp -r /home/pi/hid_usb /usr/bin/hid_usb
sudo chmod +x /usr/bin/hid_usb

sed -i '/exit/d' /etc/rc.local

cat <<EOF>>/etc/rc.local
/usr/bin/hid_usb # libcomposite configuration
sleep 3
cat /boot/payload.dd > /home/pi/payload.dd
sleep 1
tr -d '\r' < /home/pi/payload.dd > /home/pi/payload2.dd
sleep 1
/home/pi/duckpi.sh ${layout} /home/pi/payload2.dd
exit 0
EOF

##Making the first payload
cat <<'EOF'>>/boot/payload.dd
GUI r
DELAY 50
STRING www.youtube.com/watch?v=dQw4w9WgXcQ
ENTER
EOF
