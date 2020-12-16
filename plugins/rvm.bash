function configure_rvm() {
	local -n __var=$1
	# RVM is the ruby version manager
	# default version of RUBY
	export RUBY_VERSION=2.3.3
	if [ -d "$HOME/.rvm/bin" ] && [ -f "$HOME/.rvm/scripts/rvm" ]
	then
		pathutils_add_tail PATH "$HOME/.rvm/bin"
		# shellcheck source=/dev/null
		source "$HOME/.rvm/scripts/rvm"
		__var=0
		return
	fi
	__var=1
}

register_interactive configure_rvm
