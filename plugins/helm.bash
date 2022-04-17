function configure_helm() {
	local -n __var=$1
	local -n __error=$2
	if ! pathutils_is_in_path helm
	then
		__error="[helm] is not in PATH"
		__var=1
		return
	fi
	__var=0
}

register configure_helm
