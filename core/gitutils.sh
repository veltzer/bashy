# This is a set of git bash functions for support for bashy.

# a function that returns whether or not the current working directory
# is inside a git tree
function git_is_inside() {
	result=$(git rev-parse --is-inside-work-tree 2> /dev/null)
	[ "$result" = "true" ]
}

# returns the top level of a git tree
function git_top_level() {
	git rev-parse --show-toplevel
}

# returns the name of the current git repo
function git_repo_name() {
	basename `git rev-parse --show-toplevel`
}
