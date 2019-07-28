function configure_gzip() {
	local __user_var=$1
	# this means that gzip will not save timestamp and name of
	# orignal file in the compressed file
	# the GZIP environment variable is currently deprecated and will be gone in the future
	# export GZIP="--no-name"
	var_set_by_name "$__user_var" 0
}

register configure_gzip
