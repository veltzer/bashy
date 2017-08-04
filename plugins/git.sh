function configure_git() {
	# some aliases for git stuff
	alias git-root='cd $(git rev-parse --show-cdup)'
	return 0
}

register_interactive configure_git
