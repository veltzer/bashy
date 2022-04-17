function configure_gzip() {
	local -n __var=$1
	local -n __error=$2
	# this means that gzip will not save timestamp and name of
	# orignal file in the compressed file
	# the GZIP environment variable is currently deprecated and will be gone in the future
	# export GZIP="--no-name"
	__var=0
}

register configure_gzip
