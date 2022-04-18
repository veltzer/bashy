function configure_node() {
	local -n __var=$1
	local -n __error=$2
	NODE_HOME="$HOME/install"
	NODE_HOME_BIN="$NODE_HOME/bin"
	if ! checkDirectoryExists "$NODE_HOME" __var __error; then return; fi
	if ! checkDirectoryExists "$NODE_HOME_BIN" __var __error; then return; fi
	pathutils_add_head PATH "$NODE_HOME_BIN"
	export NODE_HOME
	__var=0
}

register_interactive configure_node

function node_install() {
	sudo apt-get install npm
	npm completion > "${HOME}/.bash_completion.d/npm"
}
