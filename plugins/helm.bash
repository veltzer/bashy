function configure_helm() {
	local -n __var=$1
	if pathutils_is_in_path helm
	then
		__var=0
	else
		__var=1
	fi
}

register configure_helm
