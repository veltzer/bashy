function _activate_minikube() {
	local -n __var=$1
	local -n __error=$2
	MINIKUBE_PATH="${HOME}/install/minikube"
	if ! checkDirectoryExists "${MINIKUBE_PATH}" __var __error; then return; fi
	pathutils_add_head PATH "${MINIKUBE_PATH}"
	if ! checkInPath "minikube" __var __error; then return; fi
	# shellcheck disable=1090
	source <(minikube completion bash)
	__var=0
}

function _install_minikube() {
	# https://minikube.sigs.k8s.io/docs/start/
	folder="${HOME}/install/minikube"
	executable="${folder}/minikube"
	rm -rf "${folder}" || true
	mkdir -p "${folder}"
	curl --location --silent --output "${executable}" "https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64"
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
