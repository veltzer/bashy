function configure_ansible() {
	local -n __user_var=$1
	# stop ansible from using cowsay to display status
	# References:
	# - https://michaelheap.com/cowsay-and-ansible/
	if pathutils_is_in_path ansible
	then
		export ANSIBLE_NOCOWS=1
		__var=0
		return
	fi
	__var=1
}

register configure_ansible
