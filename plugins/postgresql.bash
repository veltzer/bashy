function configure_postgresql() {
	local -n __var=$1
	if pathutils_is_in_path psql
	then
		export PGDATABASE=postgres
		__var=0
		return
	fi
	__var=1
}

register configure_postgresql
