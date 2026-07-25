# This is a plugin for the redhat oc(1) client tool which is a superset of kubectl(1)
# for openshift based systems

function _activate_oc() {
	local -n __var=$1
	local -n __error=$2
	if ! checkInPath "oc" __var __error; then return; fi
	if ! bashy_completion oc oc completion bash
	then
		__var=$?
		__error="could not source oc completion"
		return
	fi
	__var=0
}

function _install_oc() {
	# instructions for installing oc are at
	# https://access.redhat.com/documentation/en-us/red_hat_build_of_microshift/4.12/html/cli_tools/microshift-oc-cli-install
	# But I'm using a different download link to account the need to log-in with a redhat account
	url="https://mirror.openshift.com/pub/openshift-v4/clients/ocp/latest/openshift-client-linux.tar.gz"
	folder=$(bashy_install_dir)
	executable="${folder}/oc"
	latest_version=$(curl --fail --silent --location "https://mirror.openshift.com/pub/openshift-v4/clients/ocp/latest/release.txt" | grep -oP 'Version:\s+\K[0-9]+\.[0-9]+\.[0-9]+' | head -1)
	installed_version=""
	if [ -x "${executable}" ]
	then
		installed_version=$("${executable}" version --client 2>/dev/null | grep -oP 'Client Version:\s+\K[0-9]+\.[0-9]+\.[0-9]+' | head -1)
	fi
	if bashy_install_check "oc" "${installed_version}" "${latest_version}"
	then
		return
	fi
	bashy_install_download "${url}"
	local tar
	bashy_download "${url}" tar || return
	bashy_verify_sha256 "${tar}" "https://mirror.openshift.com/pub/openshift-v4/clients/ocp/latest/sha256sum.txt" || return
	rm -f "${executable}"
	bashy_install_extract "${tar}" "${folder}" oc
	chmod +x "${executable}"
}

function _uninstall_oc() {
	folder=$(bashy_install_dir)
	executable="${folder}/oc"
	if [ -f "${executable}" ]
	then
		echo "removing ${executable}"
		rm "${executable}"
	else
		echo "no oc detected"
	fi
}

register _activate_oc
