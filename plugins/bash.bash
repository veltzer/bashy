function configure_bash() {
	local -n __var=$1
	local -n __error=$2
	set HISTSIZE=10000
	__var=0
}

register_interactive configure_bash
