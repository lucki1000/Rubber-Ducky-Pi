#!/bin/bash
export work_dir="/opt/Raspberry-Rubber-Ducky-Pi"
export usr="$USER"
echo $1
echo "Running APT Update and install Vim & Git"
sudo apt update > /dev/null 2>&1
sudo apt install -y rpi-update vim git > /dev/null 2>&1

## dwc2 drivers
sudo sed -i -e "\$adtoverlay=dwc2" /boot/config.txt
echo "dwc2" | sudo tee -a /etc/modules
echo "libcomposite" | sudo tee -a /etc/modules

##Install git and download rspiducky
#wget --no-check-certificate https://raw.githubusercontent.com/lucki1000/Raspberry-Rubber-Ducky-Pi/experimental/asynchron_writing.sh https://raw.githubusercontent.com/lucki1000/Raspberry-Rubber-Ducky-Pi/experimental/LICENSE https://raw.githubusercontent.com/lucki1000/Raspberry-Rubber-Ducky-Pi/experimental/duckpi.sh https://raw.githubusercontent.com/lucki1000/Raspberry-Rubber-Ducky-Pi/experimental/g_hid.ko https://raw.githubusercontent.com/lucki1000/Raspberry-Rubber-Ducky-Pi/experimental/hid-gadget-test.c https://raw.githubusercontent.com/lucki1000/Raspberry-Rubber-Ducky-Pi/experimental/hid_usb https://raw.githubusercontent.com/lucki1000/Raspberry-Rubber-Ducky-Pi/experimental/readme.md https://raw.githubusercontent.com/lucki1000/Raspberry-Rubber-Ducky-Pi/experimental/usleep https://raw.githubusercontent.com/lucki1000/Raspberry-Rubber-Ducky-Pi/experimental/usleep.c https://raw.githubusercontent.com/lucki1000/Raspberry-Rubber-Ducky-Pi/experimental/hid-gadget-test_german.c https://raw.githubusercontent.com/lucki1000/Raspberry-Rubber-Ducky-Pi/experimental/test.sh https://raw.githubusercontent.com/lucki1000/Raspberry-Rubber-Ducky-Pi/experimental/kernel_files_copie.sh > /dev/null 2>&1
sudo git clone https://github.com/lucki1000/Raspberry-Rubber-Ducky-Pi.git /opt/
sudo chown -R "$usr":"$usr" /opt/Raspberry-Rubber-Ducky-Pi/
sleep 3

kernel="$(uname -r)"

if [[ $1 == "us" ]]
then
	echo "Your actual kernel version is: ${kernel}"
elif [[ $1 == "de" ]]
then
	echo "Dein aktueller Kernel ist: ${kernel}"
fi


if [[ $1 == "de" ]]
then
	gcc "${work_dir}/hid-gadget-test_german.c" -o "${work_dir}/hid-gadget-test"
	echo "DE DEBUG MESSAGE"
elif [[ $1 == "us" ]]
then
	gcc "${work_dir}/hid-gadget-test.c" -o "${work_dir}/hid-gadget-test"
	echo "US DEBUG MESSAGE"
fi

sleep 3

# make script executable
chmod +x "${work_dir}/asynchron_writing.sh"
#create .vars file to store important variables
echo "layout=${1}" > /opt/Raspberry-Rubber-Ducky-Pi/.vars
echo "work_dir=${work_dir}" >> /opt/Raspberry-Rubber-Ducky-Pi/.vars
# call other script
arg=hello										# It doesn't has a reason why hello :)
chmod +x "${work_dir}/kernel_files_copy.sh"		# make it executable
sudo "${work_dir}/kernel_files_copy.sh" "$arg" 	# call script

# continue with this script
#touch Raspberry-Rubber-Ducky-Pi/payload.txt

#
echo "dwc2
g_hid" |sudo tee -a /etc/modules



##Make it so that you can put the payload.dd in the /boot directory
sudo cp -r "${work_dir}/hid_usb" "/usr/bin/hid_usb"
sudo chmod +x /usr/bin/hid_usb

sudo sed -i '/exit/d' /etc/rc.local

echo "/usr/bin/hid_usb # libcomposite configuration
exit 0" | sudo tee -a /etc/rc.local

##Making the first payload

echo "GUI r
DELAY 50
STRING www.youtube.com/watch?v=dQw4w9WgXcQ
ENTER"| sudo tee -a /boot/payload.dd

#sed -i "s/\/pi\//\/$usr\//" "${work_dir}/duckpi.sh"

if [[ $1 == "de" ]]
then
	printf "Erst nach einem Neustart funktioniert dein Pi als Rubber-Ducky\n"
	read -p "Willst du dein Pi Neustarten?\n $(echo $'\n ja \n nein \n ')" choice
	if [[ $choice == "ja" ]]
	then
		sudo reboot
	fi
elif [[ $1 == "us" ]]
then
	printf "First after a reboot your Pi can working as rubber ducky\n"
	read -p "Did you will restart your Pi?\n $(echo $'\n yes \n no \n ')" choice
	if [[ $choice == "yes" ]]
	then
		sudo reboot
	fi
fi
