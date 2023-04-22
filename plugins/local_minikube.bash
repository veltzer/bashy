function _activate_minikube() {
	local -n __var=$1
	local -n __error=$2
	MINIKUBE_PATH="${HOME}/install/minikube"
	if ! checkDirectoryExists "$MINIKUBE_PATH" __var __error; then return; fi
	pathutils_add_head PATH "${MINIKUBE_PATH}"
	if ! checkInPath minikube __var __error; then return; fi
	# shellcheck disable=1090
	source <(minikube completion bash)
	__var=0
}

function _install_minikube() {
	# https://minikube.sigs.k8s.io/docs/start/
	rm -rf "${HOME}/install/minikube"
	mkdir -p "${HOME}/install/minikube"
	curl --location --silent --output "${HOME}/install/minikube/minikube" https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
	chmod +x "${HOME}/install/minikube/minikube"
}

register _activate_minikube
