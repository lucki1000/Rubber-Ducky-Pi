#!/bin/bash
first_shasum="1"
shasum="$(shasum payload.txt)"
while true;
do
  shasum="$(shasum payload.txt)"
  if [ "$first_shasum" != "$shasum" ]
  then
    /home/pi/duckpi.sh {$1} payload.txt
    first_shasum="$(shasum payload.txt)"
    echo "Execute_11"
  fi
  if [ "$first_shasum" == "$shasum" ]
  then
    first_shasum="$(shasum payload.txt)"
    echo "Execute_00"
  fi
done