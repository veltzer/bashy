function configure_ansible() {
	# stop ansible from using cowsay to display status
	# References:
	# - https://michaelheap.com/cowsay-and-ansible/
	if pathutils_is_in_path ansible
	then
		export ANSIBLE_NOCOWS=1
		result=0
	else
		result=1
	fi
}

register configure_ansible
