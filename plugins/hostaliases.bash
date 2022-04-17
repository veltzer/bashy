function configure_hostaliases() {
	local -n __var=$1
	local -n __error=$2
	HOSTALIASES="$HOME/.hostaliases"
	if [ ! -f "$HOSTALIASES" ] || [ ! -r "$HOSTALIASES" ]
	then
		__error="[$HOSTALIASES] either doesnt exist or is not readable"
		__var=1
		return
	fi
	export HOSTALIASES
	__var=0
}

register configure_hostaliases
