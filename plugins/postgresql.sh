function configure_postgresql() {
	# this configures the default options for postgresql
	if pathutils_is_in_path psql
	then
		export PGDATABASE=postgres
		return 0
	else
		return 1
	fi
}

register configure_postgresql
