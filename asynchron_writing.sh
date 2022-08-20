#!/bin/bash
first_shasum="1"
source /opt/Raspberry-Rubber-Ducky-Pi/.vars
shasum="$(shasum ${work_dir}/payload.txt)"
while true;
do
  shasum="$(shasum ${work_dir}/payload.txt)"
  if [ "$first_shasum" != "$shasum" ]
  then
    sudo duckpi.sh "${work_dir}/payload.txt"
    echo "Execute_11"
  fi
  if [ "$first_shasum" == "$shasum" ]
  then
    echo "Execute_00"
  fi
  first_shasum="$(shasum ${work_dir}/payload.txt)"
  sleep 3
done
