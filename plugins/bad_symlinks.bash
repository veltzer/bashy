# This plugin finds bad symlinks in your home directory

function _activate_bad_symlinks() {
	local -n __var=$1
	local -n __error=$2
	# it seems that firefox always creates a lock dangling symlink which
	# I have no great desire to see.
	find .\
		-type l\
		-and -not -exec test -e {} \;\
		-and -not -ipath "*/firefox/*"\
		-and -not -ipath "*/google-chrome/*"\
		-and -not -ipath "*/spyder.lock"\
		-and -not -ipath "*/whatsdesk/*"\
		-print
	__var=0
}

register_interactive _activate_bad_symlinks
