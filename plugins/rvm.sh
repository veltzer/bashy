function configure_rvm() {
	# RVM is the ruby version manager
	# default version of RUBY
	export RUBY_VERSION=2.3.3
	if [ -d "$HOME/.rvm/bin" -a -f "$HOME/.rvm/scripts/rvm" ]
	then
		export PATH=$(pathutils_add_tail "$PATH" "$HOME/.rvm/bin")
		source "$HOME/.rvm/scripts/rvm"
		return 0
	else
		return 1
	fi
}

register_interactive configure_rvm
