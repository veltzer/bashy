function configure_pureline() {
	local -n __var=$1
	if [ -r "$HOME/install/pureline/pureline" ]
	then
		# shellcheck source=/dev/null
		source "$HOME/install/pureline/pureline" "$HOME/.pureline.conf"
		__var=0
		return
	fi
	__var=1
}

register_interactive configure_pureline
