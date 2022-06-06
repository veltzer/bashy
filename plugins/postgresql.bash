function _activate_postgresql() {
	local -n __var=$1
	local -n __error=$2
	if ! checkInPath psql __var __error; then return; fi
	export PGDATABASE=postgres
	__var=0
}

register _activate_postgresql
