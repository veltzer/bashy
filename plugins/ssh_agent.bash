function _activate_ssh_agent() {
	local -n __var=$1
	local -n __error=$2
	if ! checkInPath ssh-add __var __error; then return; fi
	# this will check if an ssh agent is actually running
	if ! ssh-add -l 2> /dev/null > /dev/null
	then
		__error="generic error message from _activate_fail"
		__var=1
		return
	fi
	for key in ~/.keys/*.pem
	do
		ssh-add "${key}" 2> /dev/null
	done
	__var=0
}

register_interactive _activate_ssh_agent
