# This plugin provides auto complete support to
# programs that use pytconf

function _activate_complete() {
	local -n __var=$1
	local -n __error=$2
	complete -C "pydmt complete" pydmt
	complete -C "pypitools complete" pypitools
	complete -C "pyawskit complete" pyawskit
	complete -C "pycmdtools complete" pycmdtools
	complete -C "pypowerline complete" pypowerline
	complete -C "pygitpub complete" pygitpub
	complete -C "pytsv complete" pytsv
	complete -C "pyscrapers complete" pyscrapers
	complete -C "pyflexebs complete" pyflexebs
	complete -C "pydatacheck complete" pydatacheck
	complete -C "pymultigit complete" pymultigit
	complete -C "pygooglecloud complete" pygooglecloud
	complete -C "pymakehelper complete" pymakehelper
	complete -C "pygcal complete" pygcal
	complete -C "pytubekit complete" pytubekit
	complete -C "pycontacts complete" pycontacts

	# shellcheck source=/dev/null
	source <(rsconstruct complete bash)
	# shellcheck source=/dev/null
	source <(rsmultigit complete bash)
	# shellcheck source=/dev/null
	source <(rscontacts complete bash)
	# shellcheck source=/dev/null
	source <(rscalendar complete bash)
	# shellcheck source=/dev/null
	source <(rsdedup complete bash)
	__var=0
}

register_interactive _activate_complete
