# This plugin provides auto complete support to
# programs that use pytconf

function _activate_complete() {
	local -n __var=$1
	local -n __error=$2
	complete -C "pypitools complete" pypitools
	complete -C "pyawskit complete" pyawskit
	complete -C "pycmdtools complete" pycmdtools
	complete -C "pypowerline complete" pypowerline
	__var=0
}

register_interactive _activate_complete
