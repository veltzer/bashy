function configure_rvm() {
	local __user_var=$1
	# RVM is the ruby version manager
	# default version of RUBY
	export RUBY_VERSION=2.3.3
	if [ -d "$HOME/.rvm/bin" ] && [ -f "$HOME/.rvm/scripts/rvm" ]
	then
		pathutils_add_tail PATH "$HOME/.rvm/bin"
		# shellcheck source=/dev/null
		source "$HOME/.rvm/scripts/rvm"
		var_set_by_name "$__user_var" 0
	else
		var_set_by_name "$__user_var" 1
	fi
}

register_interactive configure_rvm
