# These are helpers to help you deal with "set -e" and "set +e"
# 
# You use it this way:
#
# local e=errexit_save_and_start()
# # now set -e is in effect
# errexit_restore ${e}


function errexist_save_and_start() {
	set -o errexit > /dev/null 2>&1 # Redirect output to suppress it
	local curr="$?"
	set -e
	return "${curr}"
}

function errexit_restore() {
	local curr=$1
	if [[ "${curr}" -eq 0 ]]
	then
		set -e
	else
		set +e
	fi
}
