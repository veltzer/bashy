function _activate_git() {
	local -n __var=$1
	local -n __error=$2
	__var=0
}

function git_clean_hard() {
	git clean -qffxd
}

register_interactive _activate_git
