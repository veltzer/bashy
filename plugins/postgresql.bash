function configure_postgresql() {
	local -n __var=$1
	local -n __error=$2
	if ! pathutils_is_in_path psql
	then
		__error="psql is not in path"
		__var=1
		return
	fi
	export PGDATABASE=postgres
	__var=0
}

register configure_postgresql
