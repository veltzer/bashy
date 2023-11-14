# hook subsystem of bashy

_bashy_array_new _bashy_array_function
assoc_new _bashy_assoc_function

function register_core() {
	local _function=$1
	local _name=$2
	assoc_assert_key_not_exists _bashy_assoc_function "${_function}"
	_bashy_array_push _bashy_array_function "${_function}"
	assoc_set _bashy_assoc_function "${_function}" "${_name}"
}

function register() {
	local _function=$1
	local _name="${BASH_SOURCE[1]##*/}"
	register_core "${_function}" "${_name%.*}"
}

function register_install() {
	:
}

function register_interactive() {
	local _function=$1
	local _name="${BASH_SOURCE[1]##*/}"
	if is_interactive
	then
		register_core "${_function}" "${_name%.*}"
	fi
}
