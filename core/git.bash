# This is a set of git bash functions for support for bashy.

# a function that returns whether or not the current working directory
# is inside a git tree
function git_is_inside() {
	if ! git rev-parse 2> /dev/null > /dev/null
	then
		return "1"
	fi
	result=$(git rev-parse --is-inside-work-tree)
	[ "$result" = "true" ]
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
