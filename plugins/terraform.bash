function _activate_terraform() {
	local -n __var=$1
	local -n __error=$2
	if ! checkInPath terraform __var __error; then return; fi
	complete -C /usr/bin/terraform terraform
	__var=0
}

function _install_terraform() {
	"https://releases.hashicorp.com/terraform/1.5.5/terraform_1.5.5_linux_amd64.zip"
	version="1.5.5"
	folder="terraform_${version}_linux_amd64.zip"
}

register_interactive _activate_terraform
