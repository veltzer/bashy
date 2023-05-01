# hook subsystem of bashy

declare -a bashy_array_function

function register_core() {
	local _function=$1
	local _name=$2
	bashy_array_function+=("${_function}")
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
