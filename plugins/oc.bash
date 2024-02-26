# This is a plugin for the redhat oc(1) client tool which is a superset of kubectl(1)
# for openshift based systems

function _activate_oc() {
	local -n __var=$1
	local -n __error=$2
	if ! checkInPath "oc" __var __error; then return; fi
	# shellcheck disable=1090
	if ! source <(oc completion bash)
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
	folder="${HOME}/install/binaries"
	wget --quiet "${url}" -O- | tar zxf - -C "${folder}" oc
	executable="${folder}/oc"
	chmod +x "${executable}"
}

function _uninstall_oc() {
	folder="${HOME}/install/binaries"
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
