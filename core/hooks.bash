# hook subsystem of bashy

array_new bashy_array_function
assoc_new bashy_assoc_function

function register_core() {
	local _function=$1
	local _name=$2
	assoc_assert_key_not_exists bashy_assoc_function "${_function}"
	array_push bashy_array_function "${_function}"
	assoc_set bashy_assoc_function "${_function}" "${_name}"
}

function register() {
	local _function=$1
	local _name="${BASH_SOURCE[1]##*/}"
	register_core "${_function}" "${_name}"
}

function register_install() {
	:
}

function register_interactive() {
	local _function=$1
	local _name="${BASH_SOURCE[1]##*/}"
	if is_interactive
	then
		register_core "${_function}" "${_name}"
	fi
}
