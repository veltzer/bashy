function _activate_rvm() {
	local -n __var=$1
	local -n __error=$2
	# RVM is the ruby version manager
	# default version of RUBY
	RVM_BIN="${HOME}/.rvm/bin"
	RVM_SCRIPTS="${HOME}/.rvm/scripts/rvm"
	if ! checkDirectoryExists "${RVM_BIN}" __var __error; then return; fi
	if ! checkReadableFile "${RVM_SCRIPTS}" __var __error; then return; fi
	export RUBY_VERSION="2.3.3"
	_bashy_pathutils_add_tail PATH "${RVM_BIN}"
	# shellcheck source=/dev/null
	if ! source "${RVM_SCRIPTS}"
	then
		__var=$?
		_error="could not source rvm scripts"
		return
	fi
	__var=0
}

register_interactive _activate_rvm
