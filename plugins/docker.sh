# This is a plugin for docker

function _activate_docker() {
	local -n __var=$1
	local -n __error=$2
	if ! checkInPath "docker" __var __error; then return; fi
	export DOCKER_HOST="unix:///var/run/docker.sock"
	__var=0
}

register_interactive _activate_docker
