function configure_ansible() {
	local __user_var=$1
	# stop ansible from using cowsay to display status
	# References:
	# - https://michaelheap.com/cowsay-and-ansible/
	if pathutils_is_in_path ansible
	then
		export ANSIBLE_NOCOWS=1
		var_set_by_name "$__user_var" 0
	else
		var_set_by_name "$__user_var" 1
	fi
}

register configure_ansible
