function _activate_xinput() {
	local -n __var=$1
	local -n __error=$2
	xinput --disable "DELL0A89:00 06CB:CE26 Touchpad"
	xinput --enable "DELL0A89:00 06CB:CE26 Touchpad"
	__var=0
}

function xinput_activate() {
	xinput --enable "DELL0A89:00 06CB:CE26 Touchpad"
}

register _activate_xinput
