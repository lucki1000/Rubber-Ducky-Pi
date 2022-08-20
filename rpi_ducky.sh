#!/bin/bash
#/etc/profile.d/rpi_ducky.sh
source /opt/Raspberry-Rubber-Ducky-Pi/.vars
if pidof -x "${work_dir}/asynchron_writing.sh" >/dev/null;
then
    echo "Process already running"
else
	"${work_dir}/asynchron_writing.sh" "$layout" &>/dev/null &
fi
vim "${work_dir}/payload.txt"
pid=$(pidof -x "${work_dir}"/asynchron_writing.sh)
sudo kill "$pid"
