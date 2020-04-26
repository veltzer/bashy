function configure_ruby() {
	local __user_var=$1
	# This configures the ruby gem envrionment
	export GEM_HOME="$HOME/install/gems"
	pathutils_add_head PATH "$HOME/install/gems/bin"
	var_set_by_name "$__user_var" 0
}

register configure_ruby
