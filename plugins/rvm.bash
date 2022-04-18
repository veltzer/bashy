function configure_rvm() {
	local -n __var=$1
	local -n __error=$2
	# RVM is the ruby version manager
	# default version of RUBY
	RVM_BIN="$HOME/.rvm/bin"
	RVM_SCRIPTS="$HOME/.rvm/scripts/rvm"
	if ! checkDirectoryExists "$RVM_BIN" __var __error; then return; fi
	if [ ! -f "RVM_SCRIPTS" ]
	then
		__error="[$RVM_SCRIPTS] doesnt exist"
		__var=1
		return
	fi
	export RUBY_VERSION=2.3.3
	pathutils_add_tail PATH "$RVM_BIN"
	# shellcheck source=/dev/null
	source "$RVM_SCRIPTS"
	__var=0
}

register_interactive configure_rvm
