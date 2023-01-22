#!/bin/bash
export layout="$1"
export work_dir="/opt/Rubber-Ducky-Pi"
export usr="$USER"
export sn="$(cat /proc/cpuinfo | grep Serial | cut -d ' ' -f 2)"
export mf="\"Raspberry Pi Foundation\""
export pd="rpi-zero"
export idV="0x1d6b"
export idP="0x0104"
export bcdD="0x0100"
export bcdU="0x0200"

func_write_to_vars () {
	#create .vars file to store important variables, used by other scripts to run this smoothly
	echo "layout=$layout" > ${work_dir}/.vars
	echo "work_dir=${work_dir}" >> ${work_dir}/.vars
	echo "interval=3" >> ${work_dir}/.vars
	echo "serialnumber=$sn" >> "$work_dir/.vars"
	echo "manufacturer=$mf" >> "$work_dir/.vars"
	echo "product=$pd" >> "$work_dir/.vars"
	echo "idVendor=$idV" >> "$work_dir/.vars"
	echo "idProduct=$idP" >> "$work_dir/.vars"
	echo "bcdDevice=$bcdD" >> "$work_dir/.vars"
	echo "bcdUSB=$bcdU" >> "$work_dir/.vars"
}

func_installing_depends_and_updates () {
	sudo apt update
	sudo apt install -y rpi-update vim git
} 2>> "$HOME/install.log" > /dev/null

func_clone_repo () {
	sudo mkdir ${work_dir}
	sudo chown -R "$usr":"$usr" ${work_dir}
	##Install git and download rspiducky
	#wget --no-check-certificate https://raw.githubusercontent.com/lucki1000/Raspberry-Rubber-Ducky-Pi/experimental/asynchron_writing.sh https://raw.githubusercontent.com/lucki1000/Raspberry-Rubber-Ducky-Pi/experimental/LICENSE https://raw.githubusercontent.com/lucki1000/Raspberry-Rubber-Ducky-Pi/experimental/duckpi.sh https://raw.githubusercontent.com/lucki1000/Raspberry-Rubber-Ducky-Pi/experimental/hid-gadget-test.c https://raw.githubusercontent.com/lucki1000/Raspberry-Rubber-Ducky-Pi/experimental/hid_usb https://raw.githubusercontent.com/lucki1000/Raspberry-Rubber-Ducky-Pi/experimental/readme.md https://raw.githubusercontent.com/lucki1000/Raspberry-Rubber-Ducky-Pi/experimental/usleep https://raw.githubusercontent.com/lucki1000/Raspberry-Rubber-Ducky-Pi/experimental/usleep.c https://raw.githubusercontent.com/lucki1000/Raspberry-Rubber-Ducky-Pi/experimental/hid-gadget-test_german.c https://raw.githubusercontent.com/lucki1000/Raspberry-Rubber-Ducky-Pi/experimental/test.sh https://raw.githubusercontent.com/lucki1000/Raspberry-Rubber-Ducky-Pi/experimental/kernel_files_copie.sh > /dev/null 2>&1
	git clone https://github.com/lucki1000/Rubber-Ducky-Pi.git ${work_dir}  
} 2>> "$HOME/install.log" > /dev/null

func_set_drivers () {
	## dwc2 drivers
	sudo sed -i -e "\$adtoverlay=dwc2" /boot/config.txt  
	echo "adding dwc2 to modules" >> "${work_dir}/install.log"
	echo "dwc2" | sudo tee -a /etc/modules
	echo "adding libcomposite to modules" >> "${work_dir}/install.log"
	echo "libcomposite" | sudo tee -a /etc/modules
	echo "adding g_hid to modules" >> "${work_dir}/install.log"
	echo "g_hid" |sudo tee -a /etc/modules
} 2>> "${work_dir}/install.log" > /dev/null

func_kernel_check () {
	kernel="$(uname -r)"
	if [[ "$layout" = "de" ]]
	then
		echo "Dein aktueller Kernel ist: ${kernel}"
	else
		echo "Your actual kernel version is: ${kernel}"
	fi
}

func_compile_hid_gadget () {
	gcc "${work_dir}/hid-gadget-test_"$layout".c" -o "${work_dir}/hid-gadget-test"
	echo "Your Keyboard Layout is: ${layout}" >> "${work_dir}/install.log"
}> /dev/null

func_make_needed_executable () {
	# make script executable 
	cd "$work_dir"
	chmod +x "${work_dir}/asynchron_writing.sh"
	chmod +x "${work_dir}/hid_usb"
	chmod +x "${work_dir}/rpi_ducky.sh"
	chmod 755 duckpi.sh usleep hid-gadget-test #Testing
} >> "${work_dir}/install.log" 

func_cp_stuff () {
	#copy duckpi.sh to /usr/sbin/
	sudo cp "${work_dir}/duckpi.sh" "/usr/sbin/"
	sudo cp -r "${work_dir}/hid_usb" "/usr/bin/hid_usb"
	#Setup Profile script
	sudo cp "${work_dir}/rpi_ducky.sh" "/etc/profile.d/"
} >> "${work_dir}/install.log"

func_modify_startup_script () {
	sudo sed -i '/exit/d' /etc/rc.local
	echo "/usr/bin/hid_usb # libcomposite configuration
	exit 0" | sudo tee -a /etc/rc.local
} 2>> "${work_dir}/install.log" > /dev/null

func_create_payload () {
	##Making the first payload
	echo "GUI r
	DELAY 50
	STRING www.youtube.com/watch?v=dQw4w9WgXcQ
	ENTER"| sudo tee -a "${work_dir}/payload.txt"
} 2>> "${work_dir}/install.log" > /dev/null

func_disable_autologin () {
	#Disable autologin 
	#dirty version thats why it's commented
	#sudo mv /etc/systemd/system/getty@tty1.service.d/autologin.conf /etc/systemd/system/getty@tty1.service.d/autologin.conf.old
	#clean version to disable autologin
	sudo raspi-config nonint do_boot_behaviour B1
} >> "${work_dir}/install.log"

func_ask_for_reboot () {
	if [[ $layout == "de" ]]
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
}
#Start debugging into install.log
echo "$(date '+%Y-%m-%d %H:%M:%S'): ${work_dir}"  >> "$HOME/install.log"
echo "$(date '+%Y-%m-%d %H:%M:%S'): ${usr}"  >> "$HOME/install.log"
echo "$(date '+%Y-%m-%d %H:%M:%S'): ${1}"  >> "$HOME/install.log"

echo "Running APT Update and install Vim & Git" |& tee -a "$HOME/install.log"
func_installing_depends_and_updates
echo "Clone Github repo to $work_dir" |& tee -a "$HOME/install.log"
func_clone_repo
mv "$HOME/install.log" "${work_dir}/install.log"
echo "Set drivers in boot.txt" |& tee -a "$work_dir/install.log"
func_set_drivers
echo "Check your current Kernel" |& tee -a "$work_dir/install.log"
func_kernel_check
echo "Compile hid gadget" |& tee -a "$work_dir/install.log"
func_compile_hid_gadget
echo "Make scripts executable" |& tee -a "$work_dir/install.log"
func_make_needed_executable
echo "Copy necessary files" |& tee -a "$work_dir/install.log"
func_cp_stuff
echo "Run hid_usb on any startup" |& tee -a "$work_dir/install.log"
func_modify_startup_script
echo "Create first Payload" |& tee -a "$work_dir/install.log"
func_create_payload
echo "Disable autologin of your PI" |& tee -a "$work_dir/install.log"
func_disable_autologin
echo "Writing important variables to .vars file" |& tee -a "$work_dir/install.log"
func_write_to_vars
echo "Complete" |& tee -a "$work_dir/install.log"
func_ask_for_reboot