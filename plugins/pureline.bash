function configure_pureline() {
	local -n __var=$1
	local -n __error=$2
	PURELINE="$HOME/install/pureline/pureline"
	if [ ! -r "$PURELINE" ]
	then
		__error="[$PURELINE] doesnt exist"
		__var=1
		return
	fi
	# shellcheck source=/dev/null
	source "$HOME/install/pureline/pureline" "$HOME/.pureline.conf"
	__var=0
}

register_interactive configure_pureline
