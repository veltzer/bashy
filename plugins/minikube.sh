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
	folder="${HOME}/install/binaries"
	executable="${folder}/minikube"
	latest_version=$(curl --fail --silent --location "https://api.github.com/repos/kubernetes/minikube/releases/latest" | jq --raw-output '.tag_name' | sed 's/^v//')
	if [ -x "${executable}" ]; then
		installed_version=$("${executable}" version 2>/dev/null | grep -oP 'minikube version: v\K[0-9]+\.[0-9]+\.[0-9]+' | head -1)
		if [ "${installed_version}" = "${latest_version}" ]; then
			echo "minikube ${latest_version} is already installed (latest)"
			return
		fi
		echo "minikube ${installed_version} is installed, upgrading to ${latest_version}"
	else
		echo "Installing minikube ${latest_version}"
	fi
	curl --fail --location --silent --output "${executable}" "https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64"
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

register_interactive _activate_minikube
