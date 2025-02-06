# This is a plugin to help you work with minikube
# It does NOT define the MINIKUBE_HOME which default is to ~

function _activate_minikube() {
	local -n __var=$1
	local -n __error=$2
	if ! checkInPath "minikube" __var __error; then return; fi
	# shellcheck source=/dev/null
	if ! source <(minikube completion bash)
	then
		__var=$?
		__error="could not source minikube completion"
		return
	fi
	__var=0
}

function _install_minikube() {
	# https://minikube.sigs.k8s.io/docs/start/
	# version="1.32.0"
	folder="${HOME}/install/binaries"
	executable="${folder}/minikube"
	curl --location --silent --output "${executable}" "https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64"
	# curl --location --silent --output "${executable}" "https://storage.googleapis.com/minikube/releases/${version}/minikube-linux-amd64"
	chmod +x "${executable}"
}

function _uninstall_minikube() {
	folder="${HOME}/install/minikube"
	if [ -d "${folder}" ]
	then
		echo "removing minikube at ${folder}"
		rm -rf "${folder}"
	else
		echo "no minikube detected"
	fi
}

register _activate_minikube
