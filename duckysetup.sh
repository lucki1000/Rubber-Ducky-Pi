#!/bin/bash
export work_dir="/opt/Rubber-Ducky-Pi"
export usr="$USER"
sudo mkdir ${work_dir}
sudo chown -R "$usr":"$usr" ${work_dir}
echo "$(date '+%Y-%m-%d %H:%M:%S'): ${work_dir}"  >> "$HOME/install.log"
echo "$(date '+%Y-%m-%d %H:%M:%S'): ${usr}"  >> "$HOME/install.log"
echo "$(date '+%Y-%m-%d %H:%M:%S'): ${1}"  >> "$HOME/install.log"
echo "Running APT Update and install Vim & Git"
sudo apt update > /dev/null 2>&1
sudo apt install -y rpi-update vim git > /dev/null 2>&1

## dwc2 drivers
sudo sed -i -e "\$adtoverlay=dwc2" /boot/config.txt  
echo "dwc2" | sudo tee -a /etc/modules
echo "libcomposite" | sudo tee -a /etc/modules
echo "g_hid" |sudo tee -a /etc/modules

##Install git and download rspiducky
#wget --no-check-certificate https://raw.githubusercontent.com/lucki1000/Raspberry-Rubber-Ducky-Pi/experimental/asynchron_writing.sh https://raw.githubusercontent.com/lucki1000/Raspberry-Rubber-Ducky-Pi/experimental/LICENSE https://raw.githubusercontent.com/lucki1000/Raspberry-Rubber-Ducky-Pi/experimental/duckpi.sh https://raw.githubusercontent.com/lucki1000/Raspberry-Rubber-Ducky-Pi/experimental/hid-gadget-test.c https://raw.githubusercontent.com/lucki1000/Raspberry-Rubber-Ducky-Pi/experimental/hid_usb https://raw.githubusercontent.com/lucki1000/Raspberry-Rubber-Ducky-Pi/experimental/readme.md https://raw.githubusercontent.com/lucki1000/Raspberry-Rubber-Ducky-Pi/experimental/usleep https://raw.githubusercontent.com/lucki1000/Raspberry-Rubber-Ducky-Pi/experimental/usleep.c https://raw.githubusercontent.com/lucki1000/Raspberry-Rubber-Ducky-Pi/experimental/hid-gadget-test_german.c https://raw.githubusercontent.com/lucki1000/Raspberry-Rubber-Ducky-Pi/experimental/test.sh https://raw.githubusercontent.com/lucki1000/Raspberry-Rubber-Ducky-Pi/experimental/kernel_files_copie.sh > /dev/null 2>&1
git clone https://github.com/lucki1000/Rubber-Ducky-Pi.git ${work_dir}  
mv "$HOME/install.log" "${work_dir}/install.log"
sleep 3

kernel="$(uname -r)"


if [[ "$1" = "de" ]]
then
	echo "Dein aktueller Kernel ist: ${kernel}"
else
	echo "Your actual kernel version is: ${kernel}"

fi

gcc "${work_dir}/hid-gadget-test_"${1}".c" -o "${work_dir}/hid-gadget-test"
echo ""${1}" DEBUG MESSAGE"

sleep 3

# make script executable 
chmod +x "${work_dir}/asynchron_writing.sh"
#create .vars file to store important variables, used by other scripts to run this smoothly
echo "layout=${1}" > ${work_dir}/.vars
echo "work_dir=${work_dir}" >> ${work_dir}/.vars
echo "interval=3 #Means that interval for asynchron writing default value is 3 seconds" >> ${work_dir}/.vars

# call other script
arg=hello										# It doesn't has a reason why hello :)
chmod +x "${work_dir}/kernel_files_copy.sh"		# make it executable
sudo "${work_dir}/kernel_files_copy.sh" "$arg" 	# call script

# continue with this script
#touch Raspberry-Rubber-Ducky-Pi/payload.txt

#

#copy duckpi.sh to /usr/sbin/
sudo cp "${work_dir}/duckpi.sh" "/usr/sbin/"
sudo cp -r "${work_dir}/hid_usb" "/usr/bin/hid_usb"
sudo chmod +x /usr/bin/hid_usb

sudo sed -i '/exit/d' /etc/rc.local

echo "/usr/bin/hid_usb # libcomposite configuration
exit 0" | sudo tee -a /etc/rc.local

##Making the first payload

echo "GUI r
DELAY 50
STRING www.youtube.com/watch?v=dQw4w9WgXcQ
ENTER"| sudo tee -a "${work_dir}/payload.txt"

#Setup Profile script
sudo cp "${work_dir}/rpi_ducky.sh" "/etc/profile.d/"

#sed -i "s/\/pi\//\/$usr\//" "${work_dir}/duckpi.sh"
#Disable autologin 
#dirty version thats why it's commented
#sudo mv /etc/systemd/system/getty@tty1.service.d/autologin.conf /etc/systemd/system/getty@tty1.service.d/autologin.conf.old
#clean version to disable autologin
sudo raspi-config nonint do_boot_behaviour B1

if [[ $1 == "de" ]]
then
	printf "Erst nach einem Neustart funktioniert dein Pi als Rubber-Ducky\n"
	read -p "Möchtest du dein Pi Neustarten?\n $(echo $'\n ja \n nein \n ')" choice
	if [[ $choice == "ja" ]]
	then
		sudo reboot
	fi	
else
	printf "First after a reboot your Pi can working as rubber ducky\n"
	read -p "Did you want to restart your Pi?\n $(echo $'\n yes \n no \n ')" choice
	if [[ $choice == "yes" ]]
	then
		sudo reboot
	fi
fi
