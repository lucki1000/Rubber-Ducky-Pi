#!/bin/bash

defdelay=0
kb="/dev/hidg0 keyboard"
last_cmd=""
last_string=""
line_num=0
LANGUAGE=$1

function convert() {
	local kbcode=""

	if [[ $LANGUAGE == "us" ]]; then
		if [[ "$1" == " " ]]; then
			kbcode='space'
		elif [[ "$1" == "!" ]]; then
			kbcode='left-shift 1'
		elif [[ "$1" == "." ]]; then
			kbcode='period'
		elif [[ "$1" == "\`" ]]; then
			kbcode='backquote'
		elif [[ "$1" == "~" ]]; then
			kbcode='left-shift tilde'
		elif [[ "$1" == "+" ]]; then
			kbcode='kp-plus'
		elif [[ "$1" == "=" ]]; then
			kbcode='equal'
		elif [[ "$1" == "_" ]]; then
			kbcode='left-shift minus'
		elif [[ "$1" == "-" ]]; then
			kbcode='minus'
		elif [[ "$1" == "\"" ]]; then
			kbcode='left-shift quote'
		elif [[ "$1" == "'" ]]; then
			kbcode='quote'
		elif [[ "$1" == ":" ]]; then
			kbcode='left-shift semicolon'
		elif [[ "$1" == ";" ]]; then
			kbcode='semicolon'
		elif [[ "$1" == "<" ]]; then
			kbcode='left-shift comma'
		elif [[ "$1" == "," ]]; then
			kbcode='comma'
		elif [[ "$1" == ">" ]]; then
			kbcode='left-shift period'
		elif [[ "$1" == "?" ]]; then
			kbcode='left-shift slash'
		elif [[ "$1" == "\\" ]]; then
			kbcode='backslash'
		elif [[ "$1" == "|" ]]; then
			kbcode='left-shift backslash'
		elif [[ "$1" == "/" ]]; then
			kbcode='slash'
		elif [[ "$1" == "{" ]]; then
			kbcode='left-shift lbracket'
		elif [[ "$1" == "}" ]]; then
			kbcode='left-shift rbracket'
		elif [[ "$1" == "(" ]]; then
			kbcode='left-shift 9'
		elif [[ "$1" == ")" ]]; then
			kbcode='left-shift 0'
		elif [[ "$1" == "[" ]]; then
			kbcode='lbracket'
		elif [[ "$1" == "]" ]]; then
			kbcode='rbracket'
		elif [[ "$1" == "#" ]]; then
			kbcode='left-shift 3'
		elif [[ "$1" == "@" ]]; then
			kbcode='left-shift 2'
		elif [[ "$1" == "$" ]]; then
			kbcode='left-shift 4'
		elif [[ "$1" == "%" ]]; then
			kbcode='left-shift 5'
		elif [[ "$1" == "^" ]]; then
			kbcode='left-shift 6'
		elif [[ "$1" == "&" ]]; then
			kbcode='left-shift 7'
		elif [[ "$1" == "*" ]]; then
			kbcode='kp-multiply'

		fi # end keys if

	elif [[ $LANGUAGE == "de" ]]; then
		if [[ "$1" == " " ]]; then
			kbcode='space'
		elif [[ "$1" == "!" ]]; then
			kbcode='left-shift 1'
		elif [[ "$1" == "." ]]; then
			kbcode='period'
		elif [[ "$1" == "§" ]]; then
			kbcode='left-shift 3'
		elif [[ "$1" == "ß" ]]; then
			kbcode='ß'
		elif [[ "$1" == "\`" ]]; then
			kbcode='left-shift equal'
		elif [[ "$1" == "\´" ]]; then
			kbcode='equal'
		elif [[ "$1" == "~" ]]; then
			kbcode='right-alt rbracket'
		elif [[ "$1" == "+" ]]; then
			kbcode='rbracket'
		elif [[ "$1" == "=" ]]; then
			kbcode='left-shift 0'
		elif [[ "$1" == "_" ]]; then
			kbcode='left-shift slash'
		elif [[ "$1" == "-" ]]; then
			kbcode='slash'
		elif [[ "$1" == "\"" ]]; then
			kbcode='left-shift 2'
		elif [[ "$1" == "'" ]]; then
			kbcode='left-shift backslash'
		elif [[ "$1" == ":" ]]; then
			kbcode='left-shift period'
		elif [[ "$1" == ";" ]]; then
			kbcode='left-shift comma'
		elif [[ "$1" == "<" ]]; then
			kbcode='<'
		elif [[ "$1" == "," ]]; then
			kbcode='comma'
		elif [[ "$1" == ">" ]]; then
			kbcode='left-shift non-us-100'
		elif [[ "$1" == "?" ]]; then
			kbcode='left-shift minus'
		elif [[ "$1" == "\\" ]]; then
			kbcode='right-alt minus'
		elif [[ "$1" == "|" ]]; then
			kbcode='right-alt non-us-100'
		elif [[ "$1" == "/" ]]; then
			kbcode='left-shift 7'
		elif [[ "$1" == "{" ]]; then
			kbcode='right-alt 7'
		elif [[ "$1" == "}" ]]; then
			kbcode='right-alt 0'
		elif [[ "$1" == "(" ]]; then
			kbcode='left-shift 8'
		elif [[ "$1" == ")" ]]; then
			kbcode='left-shift 9'
		elif [[ "$1" == "[" ]]; then
			kbcode='right-alt 8'
		elif [[ "$1" == "]" ]]; then
			kbcode='right-alt 9'
		elif [[ "$1" == "#" ]]; then
			kbcode='backslash'
		elif [[ "$1" == "@" ]]; then
			kbcode='right-alt q'
		elif [[ "$1" == "$" ]]; then
			kbcode='left-shift 4'
		elif [[ "$1" == "%" ]]; then
			kbcode='left-shift 5'
		elif [[ "$1" == "^" ]]; then
			kbcode='^'
		elif [[ "$1" == "°" ]]; then
			kbcode='left-shift ^'
		elif [[ "$1" == "&" ]]; then
			kbcode='left-shift 6'
		elif [[ "$1" == "*" ]]; then
			kbcode='left-shift rbracket'

		fi # and keys if
	fi # and lang if

	case $1 in
	[[:upper:]])
		tmp=$1
		kbcode="left-shift ${tmp,,}"
		;;
	*) if [ -z "${kbcode}" ]; then kbcode="$1"; fi ;;
	esac

	echo "$kbcode"
}

while IFS='' read -r line || [[ -n "$line" ]]; do
	((line_num++))
	read -r cmd info <<<"$line"
	if [ "$cmd" == "STRING" ]; then
		last_string="$info"
		last_cmd="$cmd"

		for ((i = 0; i < ${#info}; i++)); do
			kbcode=$(convert "${info:$i:1}")

			if [ "$kbcode" != "" ]; then
				echo "$kbcode" | /home/pi/Raspberry-Rubber-Ducky-Pi/hid-gadget-test $kb >/dev/null
			fi
		done
	elif [ "$cmd" == "ENTER" ]; then
		last_cmd="enter"
		echo "$last_cmd" | /home/pi/Raspberry-Rubber-Ducky-Pi/hid-gadget-test $kb >/dev/null

	elif [ "$cmd" == "DELAY" ]; then
		last_cmd="UNS"
		((info = info * 1000))
		/home/pi/Raspberry-Rubber-Ducky-Pi/usleep $info

	elif [ "$cmd" == "WINDOWS" -o "$cmd" == "GUI" ]; then
		last_cmd="left-meta ${info,,}"
		echo "$last_cmd" | /home/pi/Raspberry-Rubber-Ducky-Pi/hid-gadget-test $kb >/dev/null

	elif [ "$cmd" == "MENU" -o "$cmd" == "APP" ]; then
		last_cmd="left-shift f10"
		echo "$last_cmd" | /home/pi/Raspberry-Rubber-Ducky-Pi/hid-gadget-test $kb >/dev/null

	elif [ "$cmd" == "DOWNARROW" -o "$cmd" == "DOWN" ]; then
		last_cmd="down"
		echo "$last_cmd" | /home/pi/Raspberry-Rubber-Ducky-Pi/hid-gadget-test $kb >/dev/null

	elif [ "$cmd" == "LEFTARROW" -o "$cmd" == "LEFT" ]; then
		last_cmd="left"
		echo "$last_cmd" | /home/pi/Raspberry-Rubber-Ducky-Pi/hid-gadget-test $kb >/dev/null

	elif [ "$cmd" == "RIGHTARROW" -o "$cmd" == "RIGHT" ]; then
		last_cmd="right"
		echo "$last_cmd" | /home/pi/Raspberry-Rubber-Ducky-Pi/hid-gadget-test $kb >/dev/null

	elif [ "$cmd" == "UPARROW" -o "$cmd" == "UP" ]; then
		last_cmd="up"
		echo "$last_cmd" | /home/pi/Raspberry-Rubber-Ducky-Pi/hid-gadget-test $kb >/dev/null

	elif [ "$cmd" == "DEFAULT_DELAY" -o "$cmd" == "DEFAULTDELAY" ]; then
		last_cmd="UNS"
		((defdelay = info * 1000))

	elif [ "$cmd" == "BREAK" -o "$cmd" == "PAUSE" ]; then
		last_cmd="pause"
		echo "$last_cmd" | /home/pi/Raspberry-Rubber-Ducky-Pi/hid-gadget-test $kb >/dev/null

	elif [ "$cmd" == "ESC" -o "$cmd" == "ESCAPE" ]; then
		last_cmd="escape"
		echo "$last_cmd" | /home/pi/Raspberry-Rubber-Ducky-Pi/hid-gadget-test $kb >/dev/null

	elif [ "$cmd" == "PRINTSCREEN" ]; then
		last_cmd="print"
		echo "$last_cmd" | /home/pi/Raspberry-Rubber-Ducky-Pi/hid-gadget-test $kb >/dev/null

	elif [ "$cmd" == "CAPSLOCK" -o "$cmd" == "DELETE" -o "$cmd" == "END" -o "$cmd" == "HOME" -o "$cmd" == "INSERT" -o "$cmd" == "NUMLOCK" -o "$cmd" == "PAGEUP" -o "$cmd" == "PAGEDOWN" -o "$cmd" == "SCROLLLOCK" -o "$cmd" == "SPACE" -o "$cmd" == "TAB" \
		-o "$cmd" == "F1" -o "$cmd" == "F2" -o "$cmd" == "F3" -o "$cmd" == "F4" -o "$cmd" == "F5" -o "$cmd" == "F6" -o "$cmd" == "F7" -o "$cmd" == "F8" -o "$cmd" == "F9" -o "$cmd" == "F10" -o "$cmd" == "F11" -o "$cmd" == "F12" ]; then
		last_cmd="${cmd,,}"
		echo "$last_cmd" | /home/pi/Raspberry-Rubber-Ducky-Pi/hid-gadget-test $kb >/dev/null

	elif [ "$cmd" == "REM" ]; then
		echo "$info"

	elif [ "$cmd" == "SHIFT" ]; then
		if [ "$info" == "DELETE" -o "$info" == "END" -o "$info" == "HOME" -o "$info" == "INSERT" -o "$info" == "PAGEUP" -o "$info" == "PAGEDOWN" -o "$info" == "SPACE" -o "$info" == "TAB" ]; then
			last_cmd="left-shift ${info,,}"
			echo "$last_cmd" | /home/pi/Raspberry-Rubber-Ducky-Pi/hid-gadget-test $kb >/dev/null

		elif [ "$info" == *"WINDOWS"* -o "$info" == *"GUI"* ]; then
			read -r gui char <<<"$info"
			last_cmd="left-shift left-meta ${char,,}"
			echo "$last_cmd" | /home/pi/Raspberry-Rubber-Ducky-Pi/hid-gadget-test $kb >/dev/null

		elif [ "$info" == "DOWNARROW" -o "$info" == "DOWN" ]; then
			last_cmd="left-shift down"
			echo "$last_cmd" | /home/pi/Raspberry-Rubber-Ducky-Pi/hid-gadget-test $kb >/dev/null

		elif [ "$info" == "LEFTARROW" -o "$info" == "LEFT" ]; then
			last_cmd="left-shift left"
			echo "$last_cmd" | /home/pi/Raspberry-Rubber-Ducky-Pi/hid-gadget-test $kb >/dev/null

		elif [ "$info" == "RIGHTARROW" -o "$info" == "RIGHT" ]; then
			last_cmd="left-shift right"
			echo "$last_cmd" | /home/pi/Raspberry-Rubber-Ducky-Pi/hid-gadget-test $kb >/dev/null

		elif [ "$info" == "UPARROW" -o "$info" == "UP" ]; then
			last_cmd="left-shift up"
			echo "$last_cmd" | /home/pi/Raspberry-Rubber-Ducky-Pi/hid-gadget-test $kb >/dev/null

		elif [ "$info" == "F1" -o "$info" == "F2" -o "$info" == "F3" -o "$info" == "F4" -o "$info" == "F5" -o "$info" == "F6" -o "$info" == "F7" -o "$info" == "F8" -o "$info" == "F9" -o "$info" == "F10" -o "$info" == "F11" -o "$info" == "F12" ]; then
			last_cmd="left-shift ${info,,}"
			echo "$last_cmd" | /home/pi/Raspberry-Rubber-Ducky-Pi/hid-gadget-test $kb >/dev/null
		else
			echo "($line_num) Parse error: Disallowed $cmd $info"
		fi

	elif [ "$cmd" == "CONTROL" -o "$cmd" == "CTRL" ]; then
		if [ "$info" == "BREAK" -o "$info" == "PAUSE" ]; then
			last_cmd="left-ctrl pause"
			echo "$last_cmd" | /home/pi/Raspberry-Rubber-Ducky-Pi/hid-gadget-test $kb >/dev/null

		elif [ "$info" == "F1" -o "$info" == "F2" -o "$info" == "F3" -o "$info" == "F4" -o "$info" == "F5" -o "$info" == "F6" -o "$info" == "F7" -o "$info" == "F8" -o "$info" == "F9" -o "$info" == "F10" -o "$info" == "F11" -o "$info" == "F12" ]; then
			last_cmd="left-ctrl ${cmd,,}"
			echo "$last_cmd" | /home/pi/Raspberry-Rubber-Ducky-Pi/hid-gadget-test $kb >/dev/null

		elif [ "$info" == "ESC" -o "$info" == "ESCAPE" ]; then
			last_cmd="left-ctrl escape"
			echo "$last_cmd" | /home/pi/Raspberry-Rubber-Ducky-Pi/hid-gadget-test $kb >/dev/null

		elif [ "$info" == "" ]; then
			last_cmd="left-ctrl"
			echo "$last_cmd" | /home/pi/Raspberry-Rubber-Ducky-Pi/hid-gadget-test $kb >/dev/null

		else
			last_cmd="left-ctrl ${info,,}"
			echo "$last_cmd" | /home/pi/Raspberry-Rubber-Ducky-Pi/hid-gadget-test $kb >/dev/null
		fi

	elif [ "$cmd" == "ALT" ]; then
		if [ "$info" == "END" -o "$info" == "SPACE" -o "$info" == "TAB" \
			-o "$info" == "F1" -o "$info" == "F2" -o "$info" == "F3" -o "$info" == "F4" -o "$info" == "F5" -o "$info" == "F6" -o "$info" == "F7" -o "$info" == "F8" -o "$info" == "F9" -o "$info" == "F10" -o "$info" == "F11" -o "$info" == "F12" ]; then
			last_cmd="left-alt ${info,,}"
			echo "$last_cmd" | /home/pi/Raspberry-Rubber-Ducky-Pi/hid-gadget-test $kb >/dev/null

		elif [ "$info" == "ESC" -o "$info" == "ESCAPE" ]; then
			last_cmd="left-alt escape"
			echo "$last_cmd" | /home/pi/Raspberry-Rubber-Ducky-Pi/hid-gadget-test $kb >/dev/null

		elif [ "$info" == "" ]; then
			last_cmd="left-alt"
			echo "$last_cmd" | /home/pi/Raspberry-Rubber-Ducky-Pi/hid-gadget-test $kb >/dev/null

		else
			last_cmd="left-alt ${info,,}"
			echo "$last_cmd" | /home/pi/Raspberry-Rubber-Ducky-Pi/hid-gadget-test $kb >/dev/null
		fi

	elif [ "$cmd" == "ALT-SHIFT" ]; then
		last_cmd="left-shift left-alt"
		echo "$last_cmd" | /home/pi/Raspberry-Rubber-Ducky-Pi/hid-gadget-test $kb >/dev/null

	elif [ "$cmd" == "CTRL-ALT" ]; then
		if [ "$info" == "BREAK" -o "$info" == "PAUSE" ]; then
			last_cmd="left-ctrl left-alt pause"
			echo "$last_cmd" | /home/pi/Raspberry-Rubber-Ducky-Pi/hid-gadget-test $kb >/dev/null

		elif [ "$info" == "END" -o "$info" == "SPACE" -o "$info" == "TAB" -o "$info" == "DELETE" -o "$info" == "F1" -o "$info" == "F2" -o "$info" == "F3" -o "$info" == "F4" -o "$info" == "F5" -o "$info" == "F6" -o "$info" == "F7" -o "$info" == "F8" -o "$info" == "F9" -o "$info" == "F10" -o "$info" == "F11" -o "$info" == "F12" ]; then
			last_cmd="left-ctrl left-alt ${cmd,,}"
			echo "$last_cmd" | /home/pi/Raspberry-Rubber-Ducky-Pi/hid-gadget-test $kb >/dev/null

		elif [ "$info" == "ESC" -o "$info" == "ESCAPE" ]; then
			last_cmd="left-ctrl left-alt escape"
			echo "$last_cmd" | /home/pi/Raspberry-Rubber-Ducky-Pi/hid-gadget-test $kb >/dev/null

		elif [ "$info" == "" ]; then
			last_cmd="left-ctrl left-alt"
			echo "$last_cmd" | /home/pi/Raspberry-Rubber-Ducky-Pi/hid-gadget-test $kb >/dev/null

		else
			last_cmd="left-ctrl left-alt ${info,,}"
			echo "$last_cmd" | /home/pi/Raspberry-Rubber-Ducky-Pi/hid-gadget-test $kb >/dev/null
		fi

	elif [ "$cmd" == "CTRL-SHIFT" ]; then
		if [ "$info" == "BREAK" -o "$info" == "PAUSE" ]; then
			last_cmd="left-ctrl left-shift pause"
			echo "$last_cmd" | /home/pi/Raspberry-Rubber-Ducky-Pi/hid-gadget-test $kb >/dev/null

		elif [ "$info" == "END" -o "$info" == "SPACE" -o "$info" == "TAB" -o "$info" == "DELETE" -o "$info" == "F1" -o "$info" == "F2" -o "$info" == "F3" -o "$info" == "F4" -o "$info" == "F5" -o "$info" == "F6" -o "$info" == "F7" -o "$info" == "F8" -o "$info" == "F9" -o "$info" == "F10" -o "$info" == "F11" -o "$info" == "F12" ]; then
			last_cmd="left-ctrl left-shift ${cmd,,}"
			echo "$last_cmd" | /home/pi/Raspberry-Rubber-Ducky-Pi/hid-gadget-test $kb >/dev/null

		elif [ "$info" == "ESC" -o "$info" == "ESCAPE" ]; then
			last_cmd="left-ctrl left-shift escape"
			echo "$last_cmd" | /home/pi/Raspberry-Rubber-Ducky-Pi/hid-gadget-test $kb >/dev/null

		elif [ "$info" == "" ]; then
			last_cmd="left-ctrl left-shift"
			echo "$last_cmd" | /home/pi/Raspberry-Rubber-Ducky-Pi/hid-gadget-test $kb >/dev/null

		else
			last_cmd="left-ctrl left-shift ${info,,}"
			echo "$last_cmd" | /home/pi/Raspberry-Rubber-Ducky-Pi/hid-gadget-test $kb >/dev/null
		fi

	elif [ "$cmd" == "REPEAT" ]; then
		if [ "$last_cmd" == "UNS" -o "$last_cmd" == "" ]; then
			echo "($line_num) Parse error: Using REPEAT with DELAY, DEFAULTDELAY or BLANK is not allowed."
		else
			for ((i = 0; i < $info; i++)); do
				if [ "$last_cmd" == "STRING" ]; then
					for ((j = 0; j < ${#last_string}; j++)); do
						kbcode=$(convert "${last_string:$j:1}")

						if [ "$kbcode" != "" ]; then
							echo "$kbcode" | /home/pi/Raspberry-Rubber-Ducky-Pi/hid-gadget-test $kb >/dev/null
						fi
					done
				else
					echo "$last_cmd" | /home/pi/Raspberry-Rubber-Ducky-Pi/hid-gadget-test $kb >/dev/null
				fi
				/home/pi/Raspberry-Rubber-Ducky-Pi/usleep $defdelay
			done
		fi

	elif [ "$cmd" != "" ]; then
		echo "($line_num) Parse error: Unexpected $cmd."
	fi
	/home/pi/Raspberry-Rubber-Ducky-Pi/usleep $defdelay
done <"$2"
