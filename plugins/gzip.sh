function configure_gzip() {
	# this means that gzip will not save timestamp and name of
	# orignal file in the compressed file
	export GZIP="--no-name"
	return 0
}

register configure_gzip
