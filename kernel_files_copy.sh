#!/bin/bash
##Make all nessisary files executeable
kernel="$(uname -r)"
source "/opt/Rubber-Ducky-Pi/.vars"
cd "$work_dir"
chmod 755 duckpi.sh usleep hid-gadget-test