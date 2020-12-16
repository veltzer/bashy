# hook subsystem of bashy

declare -a bashy_array_function

function register() {
	local function=$1
	bashy_array_function+=("$function")
}

function register_interactive() {
	local function=$1
	if is_interactive
	then
		register "$function"
	fi
}
