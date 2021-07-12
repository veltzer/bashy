function configure_hostaliases() {
	local -n __var=$1
	HOSTALIASES="$HOME/.hostaliases"
	if [ -r "$HOSTALIASES" ]
	then
		export HOSTALIASES
		__var=0
		return
	fi
	__var=1
}

register configure_hostaliases
