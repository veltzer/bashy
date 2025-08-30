# This is a plugin for uv

function _activate_uv() {
	local -n __var=$1
	local -n __error=$2
	if ! checkInPath "uv" __var __error; then return; fi
	# shellcheck source=/dev/null
	if ! source <(uv --generate-shell-completion bash)
	then
		__var=1
		__error="problem in sourcing uv completion"
		return
	fi
	UV_PUBLISH_TOKEN=$(pass show keys/pypi-uv)
	export UV_PUBLISH_TOKEN
	__var=0
}

register_interactive _activate_uv
