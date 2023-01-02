function _activate_minikube() {
	local -n __var=$1
	local -n __error=$2
	if ! checkInPath minikube __var __error; then return; fi
	MINIKUBE_HOME="${HOME}/install/minikube"
	if ! checkDirectoryExists "$MINIKUBE_HOME" __var __error; then return; fi
	export MINIKUBE_HOME
	pathutils_add_head PATH "${MINIKUBE_HOME}"
	# shellcheck disable=1090
	source <(minikube completion bash)
	__var=0
}

function _install_minikube() {
	# https://minikube.sigs.k8s.io/docs/start/
	mkdir -p ~/install/minikube
	curl --location --silent --output ~/install/minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
	chmod +x ~/install/minikube/minikube
}

register _activate_minikube
