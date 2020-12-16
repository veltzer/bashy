# This is integration of gh, the github command line tool
function configure_gh() {
	local -n __user_var=$1
	if pathutils_is_in_path gh
	then
		eval "$(gh completion -s bash)"
		__var=0
		return
	fi
	__var=1
}

register_interactive configure_gh
