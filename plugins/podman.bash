# This is a plugin for podman

function _activate_podman() {
	local -n __var=$1
	local -n __error=$2
	if ! checkInPath "podman" __var __error; then return; fi
	eval "$(podman completion bash)"
	__var=0
}

register_interactive _activate_podman
