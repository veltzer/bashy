function configure_google_cloud_sdk() {
	local -n __var=$1
	GOOGLE_CLOUD_HOME="$HOME/install/google-cloud-sdk"
	if [ -d "$GOOGLE_CLOUD_HOME" ]
	then
		export GOOGLE_CLOUD_HOME
		# shellcheck source=/dev/null
		source "$GOOGLE_CLOUD_HOME/path.bash.inc"
		# shellcheck source=/dev/null
		source "$GOOGLE_CLOUD_HOME/completion.bash.inc"
		__var=0
		return
	fi
	__var=1
}

function install_google_cloud_sdk() {
	curl https://sdk.cloud.google.com | bash
	gcloud auth login
	gcloud components update
}

register_interactive configure_google_cloud_sdk
