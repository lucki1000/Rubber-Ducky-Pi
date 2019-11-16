first_shasum="1"
shasum="$(shasum payload.txt)"
while true:
	shasum="$(shasum payload.txt)"
	if[ first_shasum =! shasum  ]
	then
		/home/pi/duckpi.sh de payload.txt
		first_shasum="$(shasum payload.txt)"
		echo "Execute_11"
	fi
	if[ first_shasum == shasum ]
	then
		first_shasum="$(shasum payload.txt)"
		echo "Execute_00"
	fi
	echo "EXEC."
done
