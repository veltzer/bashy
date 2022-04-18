function configure_ansible() {
	local -n __var=$1
	local -n __error=$2
	if ! checkInPath ansible __var __error; then return; fi
	export ANSIBLE_NOCOWS=1
	__var=0
}

register configure_ansible
