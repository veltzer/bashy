function configure_ansible() {
	local -n __var=$1
	if pathutils_is_in_path ansible
	then
		export ANSIBLE_NOCOWS=1
		__var=0
		return
	fi
	__var=1
}

register configure_ansible
