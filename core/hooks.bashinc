# hook subsystem of bashy

declare -a bashy_init_array

function register() {
	local function=$1
	bashy_init_array+=("$function")
}

function register_interactive() {
	local function=$1
	if is_interactive
	then
		register "$function"
	fi
}
