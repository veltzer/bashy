# This is a set of git bash functions

# a function that returns whether or not the current working directory
# is inside a git tree
#
# Seven prompt plugins ask this on every single prompt, and each answer used to
# fork "git rev-parse", so the same question cost about 28 ms per prompt. The
# answer only depends on the directory, so remember it per directory.
#
# The memo is keyed on PWD alone. Creating or removing a repository under a
# directory you are already sitting in is rare enough, and "git_is_inside_flush"
# is there for when it happens.
declare -gA _bashy_git_inside_cache=()

function git_is_inside() {
	if [ -n "${_bashy_git_inside_cache[${PWD}]+x}" ]
	then
		return "${_bashy_git_inside_cache[${PWD}]}"
	fi
	local result err
	result=$(git rev-parse --is-inside-work-tree 2> /dev/null)
	err="${?}"
	if [ "${err}" != 0 ]
	then
		_bashy_git_inside_cache[${PWD}]="${err}"
		return "${err}"
	fi
	[ "${result}" = "true" ]
	local err2="${?}"
	_bashy_git_inside_cache[${PWD}]="${err2}"
	return "${err2}"
}

# forget what git_is_inside remembered, for when a repository appears or
# disappears under a directory that has already been visited
function git_is_inside_flush() {
	_bashy_git_inside_cache=()
}

# returns the top level of a git tree
function git_top_level() {
	local -n __var=$1
	local toplevel
	toplevel=$(git rev-parse --show-toplevel)
	__var="${toplevel}"
}

# returns the name of the current git repo
function git_repo_name() {
	local -n __var=$1
	local toplevel
	git_top_levl toplevel
	local name=${toplevel##*/}
	__var="${name}"
}

# go to the root of the current git repo
function git_root() {
	# go to the root of the current git repo (if indeed inside a git repo)
	# the "git rev-parse" will also print an error if not inside a git repo
	cd_arg="$(git rev-parse --show-cdup)"
	if [ -n "${cd_arg}" ]
	then
		cd "${cd_arg}" || exit
	fi
}
