# This is a set of git bash functions for support for bashy.

export _BASHY_CORE_GIT_DEBUG=1

# function to issue a message if we are in debug mode
function git_debug() {
	local msg=$1
	if [ "${_BASHY_CODE_GIT_DEBUG}" = 0 ]
	then
		echo "env: debug: $msg"
	fi
}

function git_debug_on() {
	_BASHY_CODE_GIT_DEBUG=0
}

function git_debug_off() {
	_BASHY_CODE_GIT_DEBUG=1
}

# a function that returns whether or not the current working directory
# is inside a git tree
# TODO: I'm calling this from lots of plugins for even cd so if I could
# cache the return value it would be great.
function git_is_inside() {
	result=$(git rev-parse --is-inside-work-tree 2> /dev/null)
	err="$?"
	git_debug "err is ${err}"
	if [ "${err}" != 0 ]
	then
		return "${err}"
	fi
	[ "$result" = "true" ]
	err2="$?"
	git_debug "err2 is ${err2}"
	return "${err2}"
}

# returns the top level of a git tree
function git_top_level() {
	local -n __var=$1
	local toplevel
	toplevel=$(git rev-parse --show-toplevel)
	__var="$toplevel"
}

# returns the name of the current git repo
function git_repo_name() {
	local -n __var=$1
	local toplevel
	git_top_levl toplevel
	local name=${toplevel##*/}
	__var="$name"
}

# go to the root of the current git repo
function git_root() {
	# go to the root of the current git repo (if indeed inside a git repo)
	cd_arg="$(git rev-parse --show-cdup)"
	if [ -n "$cd_arg" ]
	then
		cd "$cd_arg" || exit
	fi
}
