# This is a plugin to help you work with minikube
# It does NOT define the MINIKUBE_HOME which default is to ~

function _activate_minikube() {
	local -n __var=$1
	local -n __error=$2
	if ! checkInPath "minikube" __var __error; then return; fi
	if ! bashy_completion minikube minikube completion bash
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
	installed_version=""
	if [ -x "${executable}" ]
	then
		installed_version=$("${executable}" version 2>/dev/null | grep -oP 'minikube version: v\K[0-9]+\.[0-9]+\.[0-9]+' | head -1)
	fi
	if bashy_install_check "minikube" "${installed_version}" "${latest_version}"
	then
		return
	fi
	download_file="https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64"
	bashy_install_download "${download_file}"
	local binary
	bashy_download "${download_file}" binary || return
	bashy_verify_sha256 "${binary}" "${download_file}.sha256" || return
	rm -f "${executable}"
	cp "${binary}" "${executable}"
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
