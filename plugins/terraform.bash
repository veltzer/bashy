function _activate_terraform() {
	local -n __var=$1
	local -n __error=$2
	if ! checkInPath terraform __var __error; then return; fi
	complete -C /usr/bin/terraform terraform
	__var=0
}

function _install_terraform() {
	version="1.5.5"
	file="terraform_${version}_linux_amd64.zip"
	download="https://releases.hashicorp.com/terraform/${version}/${file}"
	rm -rf "/tmp/${file}" "${HOME}/install/binaries/terraform"
	wget "${download}" -P /tmp
	unzip "/tmp/${file}" -d "${HOME}/install/binaries" 
	rm -rf "/tmp/${file}"
}

register_interactive _activate_terraform
