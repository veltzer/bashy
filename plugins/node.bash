function _activate_node() {
	local -n __var=$1
	local -n __error=$2
	NODE_PATH="${HOME}/install/node"
	NODE_MODULES="${NODE_PATH}/node_modules"
	NODE_BIN="${NODE_MODULES}/.bin"
	if ! checkDirectoryExists "${NODE_PATH}" __var __error; then return; fi
	if ! checkDirectoryExists "${NODE_MODULES}" __var __error; then return; fi
	if ! checkDirectoryExists "${NODE_BIN}" __var __error; then return; fi
	export NODE_PATH NODE_MODULES NODE_BIN
	pathutils_add_head PATH "${NODE_BIN}"
	__var=0
}

function _install_node() {
	if ! dpkg -l npm > /dev/null
	then
		sudo apt-get install npm
		echo "installed the 'npm' package for you"
	else
		echo "you already have the 'npm' package"
	fi
	if [ ! -f "${HOME}/.bash_completion.d/npm" ]
	then
		npm completion > "${HOME}/.bash_completion.d/npm"
		echo "setup npm completion for you"
	else
		echo "you already have npm completions"
	fi
	if [ -d "${HOME}/install/node/node_modules/.bin" ]
	then
		echo "you already have a node_modules folder"
	else
		mkdir -p "${HOME}/install/node/node_modules/.bin"
		echo "made a 'node_modules' folder for you"
	fi
}

function npm_logout() {
	sed -i '/\(registry=\|_authToken=\)/d' "${HOME}/.npmrc"
}

register_interactive _activate_node
register_install _install_node
