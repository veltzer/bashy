function configure_host_aliases() {
	# setup HOSTALIASES for my own private hosts
	# References:
	# - https://www.physics.drexel.edu/~wking/unfolding-disasters-old/posts/HOSTALIASES/
	HOSTS_FILE="$HOME/.hosts"
	if [[ -f $HOSTS_FILE ]]; then
		export HOSTALIASES=$HOSTS_FILE
		return 0
	else
		return 1
	fi
}

register_interactive configure_host_aliases
