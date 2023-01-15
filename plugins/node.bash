function _activate_node() {
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

function _install_node() {
	sudo apt-get install npm
	npm completion > "${HOME}/.bash_completion.d/npm"
}

function npm_logout() {
	sed -i '/\(registry=\|_autoToken=\)/d' "${HOME}/.npmrc"
}

register_interactive _activate_node
register_install _install_node
