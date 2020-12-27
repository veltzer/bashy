function configure_pycharm() {
	local -n __var=$1
	# setup where you have pycharm installed (if you have it).
	export PYCHARM_HOME="${HOME}/install/pycharm"
	__var=0
}

register configure_pycharm
