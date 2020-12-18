function configure_host_aliases() {
	local -n __var=$1
	# setup HOSTALIASES for my own private hosts
	# References:
	# - https://www.physics.drexel.edu/~wking/unfolding-disasters-old/posts/HOSTALIASES/
	HOSTALIASES="$HOME/.hosts"
	if [ -r "$HOSTALIASES" ]
	then
		export HOSTALIASES
		__var=0
		return
	fi
	__var=1
}

register_interactive configure_host_aliases
