# This is integration of akurtosis (kurtosis on the command line)
# https://docs.kurtosis.com/guides/adding-command-line-completion
function _activate_kurtosis() {
	local -n __var=$1
	local -n __error=$2
	if ! checkInPath "kurtosis" __var __error; then return; fi
	# shellcheck source=/dev/null
	if ! source <(kurtosis completion bash)
	then
		__var=$?
		__error="could not source kurtosis completion script"
	fi
	__var=0
}

function _install_kurtosis() {
	:
}

register_interactive _activate_kurtosis
