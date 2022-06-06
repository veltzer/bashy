function _activate_hostaliases() {
	local -n __var=$1
	local -n __error=$2
	HOSTALIASES="$HOME/.hostaliases"
	if ! checkReadableFile "$HOSTALIASES" __var __error; then return; fi
	export HOSTALIASES
	__var=0
}

register _activate_hostaliases
