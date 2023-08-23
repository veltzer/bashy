function _activate_node() {
	local -n __var=$1
	local -n __error=$2
	NODE_PATH="${HOME}/install/node"
	NODE_MODULES="${NODE_PATH}/node_modules"
	NODE_BIN="${NODE_MODULES}/.bin"
	NODE_MAN="${NODE_MODULES}/share/man"
	if ! checkDirectoryExists "${NODE_PATH}" __var __error; then return; fi
	if ! checkDirectoryExists "${NODE_MODULES}" __var __error; then return; fi
	if ! checkDirectoryExists "${NODE_BIN}" __var __error; then return; fi
	if ! checkDirectoryExists "${NODE_MAN}" __var __error; then return; fi
	pathutils_add_head PATH "${NODE_HOME_BIN}"
	pathutils_add_head PATH "${NODE_HOME_BIN}"
	export NODE_PATH NODE_MODULES NODE_BIN NODE_MAN
	# add manual pages for npm packages
	pathutils_add_tail MANPATH "${NODE_MAN}"
	__var=0
}

function _install_node() {
	sudo apt-get install npm
	npm completion > "${HOME}/.bash_completion.d/npm"
}

function npm_logout() {
	sed -i '/\(registry=\|_authToken=\)/d' "${HOME}/.npmrc"
}

register_interactive _activate_node
register_install _install_node
