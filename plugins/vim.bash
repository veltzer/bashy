function _activate_vim() {
	local -n __var=$1
	local -n __error=$2
	if ! checkInPath vim __var __error; then return; fi
	export EDITOR='vim'
	export VISUAL='vim'
	__var=0
}

register_interactive _activate_vim
