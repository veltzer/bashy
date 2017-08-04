function configure_ansible() {
	# stop ansible from using cowsay to display status
	# References:
	# - https://michaelheap.com/cowsay-and-ansible/
	if is_in_path ansible; then
		export ANSIBLE_NOCOWS=1
		return 0
	else
		return 1
	fi
}

register configure_ansible
