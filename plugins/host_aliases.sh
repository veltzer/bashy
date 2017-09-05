function configure_host_aliases() {
	local __user_var=$1
	# setup HOSTALIASES for my own private hosts
	# References:
	# - https://www.physics.drexel.edu/~wking/unfolding-disasters-old/posts/HOSTALIASES/
	HOSTS_FILE="$HOME/.hosts"
	if [[ -f $HOSTS_FILE ]]
	then
		export HOSTALIASES=$HOSTS_FILE
		var_set_by_name "$__user_var" 0
	else
		var_set_by_name "$__user_var" 1
	fi
}

register_interactive configure_host_aliases
