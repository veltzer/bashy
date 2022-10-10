function _activate_google_cloud_sdk() {
	local -n __var=$1
	local -n __error=$2
	GOOGLE_CLOUD_HOME="$HOME/install/google-cloud-sdk"
	if ! checkDirectoryExists "$GOOGLE_CLOUD_HOME" __var __error; then return; fi
	export GOOGLE_CLOUD_HOME
	# shellcheck source=/dev/null
	source "$GOOGLE_CLOUD_HOME/path.bash.inc"
	# shellcheck source=/dev/null
	source "$GOOGLE_CLOUD_HOME/completion.bash.inc"
	__var=0
}

function _install_google_cloud_sdk() {
	curl --silent https://sdk.cloud.google.com | bash
	gcloud auth login
	gcloud components update
}

register_interactive _activate_google_cloud_sdk
