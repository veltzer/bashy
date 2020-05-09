function configure_rust() {
	local __user_var=$1
	pathutils_add_head PATH "$HOME/.cargo/bin"
	var_set_by_name "$__user_var" 0
}

register configure_rust
