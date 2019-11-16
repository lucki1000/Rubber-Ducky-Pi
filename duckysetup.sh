#!/bin/bash
if [ $EUID -ne 0 ]; then
	echo "You must use sudo to run this script:"
	echo "sudo $0 $@"
	exit
fi
read -p "Enter Keyboard layout supported layouts: `echo $'\n de \n us \n '`" layout

if [ $layout == "us" ]; then
	echo "$Your actuall kernel version is{kernel}"
fi
if [ $layout == "de" ]; then
	echo "Dein aktueller Kernel ist: ${kernel}"
fi
sleep 5 
apt update
apt install -y rpi-update vim

## dwc2 drivers
sed -i -e "\$adtoverlay=dwc2" /boot/config.txt
echo "dwc2" | sudo tee -a /etc/modules
sudo echo "libcomposite" | sudo tee -a /etc/modules

##Install git and download rspiducky
wget --no-check-certificate https://raw.githubusercontent.com/lucki1000/Raspberry-Rubber-Ducky-Pi/experimental/LICENSE https://raw.githubusercontent.com/lucki1000/Raspberry-Rubber-Ducky-Pi/experimental/duckpi.sh https://raw.githubusercontent.com/lucki1000/Raspberry-Rubber-Ducky-Pi/experimental/g_hid.ko https://raw.githubusercontent.com/lucki1000/Raspberry-Rubber-Ducky-Pi/experimental/hid-gadget-test.c https://raw.githubusercontent.com/lucki1000/Raspberry-Rubber-Ducky-Pi/experimental/hid_usb https://raw.githubusercontent.com/lucki1000/Raspberry-Rubber-Ducky-Pi/experimental/readme.md https://raw.githubusercontent.com/lucki1000/Raspberry-Rubber-Ducky-Pi/experimental/usleep https://raw.githubusercontent.com/lucki1000/Raspberry-Rubber-Ducky-Pi/experimental/usleep.c https://raw.githubusercontent.com/lucki1000/Raspberry-Rubber-Ducky-Pi/experimental/hid-gadget-test_german.c https://raw.githubusercontent.com/lucki1000/Raspberry-Rubber-Ducky-Pi/experimental/test.sh https://raw.githubusercontent.com/lucki1000/Raspberry-Rubber-Ducky-Pi/experimental/kernel_files_copie.sh

if [[ $layout == "de" ]]
then	
	gcc hid-gadget-test_german.c -o hid-gadget-test
fi

if [[ $layout == "us" ]]
then
	gcc hid-gadget-test.c -o hid-gadget-test
fi

chmod +x /home/pi/kernel_files_copie.sh
sudo /home/pi/kernel_files_copie.sh 1

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

if [[ $layout == "de" ]]
then
	echo "Erst nach einem Neustart funktioniert dein Pi als Rubber-Ducky\n"
	read -p "Willst du dein Pi Neustarten?\n `echo $'\n ja \n nein \n '`" choice
	if [[ $choice == "ja" ]]
	then
		sudo reboot
	fi
fi

if [[ $layout == "us" ]]
then
	echo "First after a reboot your Pi can working as rubber ducky\n"
	read -p "Did you will restart your Pi?\n `echo $'\n yes \n no \n '`" choice
	if [[ $choice == "yes" ]]
	then
		sudo reboot
	fi
fi