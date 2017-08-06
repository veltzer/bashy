function configure_postgresql() {
	# this configures the default options for postgresql
	if pathutils_is_in_path psql
	then
		export PGDATABASE=postgres
		result=0
	else
		result=1
	fi
}

register configure_postgresql
