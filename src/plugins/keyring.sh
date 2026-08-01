# This is a plugin for the python keyring command line tool

function _activate_keyring() {
	local -n __var=$1
	local -n __error=$2
	if ! checkInPath "keyring" __var __error; then return; fi
	# you need to "pip install 'keyring[completion]'" for this to work
	# export PYTHON_KEYRING_BACKEND=keyring.backends.null.Keyring
	if ! bashy_completion keyring keyring --print-completion bash; then
		__var=1
		__error="problem in sourcing keyring completion"
		return
	fi
	__var=0
}

register_interactive _activate_keyring
