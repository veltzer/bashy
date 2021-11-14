function configure_pycharm() {
	local -n __var=$1
	#PYCHARM_HOME="${HOME}/install/pycharm"
	PYCHARM_HOME="${HOME}/.local/share/JetBrains/Toolbox/apps/PyCharm-P/ch-1/211.7142.13"
	PYCHARM_BIN="$PYCHARM_HOME/bin"
	if [ -d "$PYCHARM_HOME" ] && [ -d "$PYCHARM_BIN" ]
	then
		export PYCHARM_HOME
		export PYCHARM_BIN
		pathutils_add_tail PATH "$PYCHARM_BIN"
		__var=0
		return
	fi
	__var=1
}

register configure_pycharm
