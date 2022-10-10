# TODO
# - be more careful here, don't disable the touchpad if you don't have a touchpad
# - stop hardcoding the exact touchpad type
# - don't just disable the touchpad - add hotplug support that will disable the touch
# pad only when a mouse is connected and re-enable it once the mouse is disconnected.

function _activate_xinput() {
	local -n __var=$1
	local -n __error=$2
	if xinput --list --name-only | grep -q Touchpad
	then
		xinput --disable "DELL0A89:00 06CB:CE26 Touchpad"
	fi
	__var=0
}

function xinput_activate() {
	if xinput --list --name-only | grep -q Touchpad
	then
		xinput --enable "DELL0A89:00 06CB:CE26 Touchpad"
	fi
}

register _activate_xinput
