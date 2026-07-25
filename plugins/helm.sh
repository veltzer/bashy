# This plugin checks that you have helm(1) in your path
# and knows now to install it.
#
# References:
# - https://helm.sh/docs/intro/install/

function _activate_helm() {
	local -n __var=$1
	local -n __error=$2
	if ! checkInPath "helm" __var __error; then return; fi
	eval "$(helm completion bash)"
	__var=0
}

function _install_helm() {
	# get.helm.sh publishes the latest tag of each line; "helm-latest-version" is the
	# current one. The upstream get-helm-3 script is pinned to the v3 line, so using it
	# here would forever reinstall v3 while this check compared against v4.
	latest_version=$(curl --fail --silent --location "https://get.helm.sh/helm-latest-version")
	folder="${HOME}/install/binaries"
	executable="${folder}/helm"
	installed_version=""
	if [ -x "${executable}" ]
	then
		installed_version=$("${executable}" version --short 2>/dev/null | grep -oP '^v[0-9]+\.[0-9]+\.[0-9]+' | head -1)
	fi
	if bashy_install_check "helm" "${installed_version}" "${latest_version}"
	then
		return
	fi
	download_file="https://get.helm.sh/helm-${latest_version}-linux-amd64.tar.gz"
	bashy_install_download "${download_file}"
	local tar
	bashy_download "${download_file}" tar || return
	rm -f "${executable}"
	# --touch so the installed file is stamped now, not with the release build time
	tar xf "${tar}" -m -C "${folder}" --strip-components=1 linux-amd64/helm
}

register _activate_helm
