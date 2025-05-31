function _activate_pycharm() {
	local -n __var=$1
	local -n __error=$2
	#PYCHARM_HOME="${HOME}/install/pycharm"
	# FIX THIS! The hardcoded version of pycharm is horrible...
	PYCHARM_HOME="${HOME}/.local/share/JetBrains/Toolbox/apps/PyCharm-P/ch-1/221.5921.27"
	PYCHARM_BIN="${PYCHARM_HOME}/bin"
	if ! checkDirectoryExists "${PYCHARM_HOME}" __var __error; then return; fi
	if ! checkDirectoryExists "${PYCHARM_BIN}" __var __error; then return; fi
	export PYCHARM_HOME
	export PYCHARM_BIN
	_bashy_pathutils_add_tail PATH "${PYCHARM_BIN}"
	__var=0
}

register _activate_pycharm
