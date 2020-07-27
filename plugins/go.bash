function configure_go() {
	local __user_var=$1
	# This configures the ruby gem envrionment
	export GOPATH="$HOME/install/go"
	pathutils_add_head PATH "$HOME/install/go/bin"
	var_set_by_name "$__user_var" 0
}

register configure_go
