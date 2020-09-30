function configure_google_cloud_sdk() {
	local __user_var=$1
	GOOGLE_CLOUD_HOME="$HOME/install/google-cloud-sdk"
	if [ -d "$GOOGLE_CLOUD_HOME" ]
	then
		export GOOGLE_CLOUD_HOME
		# shellcheck source=/dev/null
		source "$GOOGLE_CLOUD_HOME/path.bash.inc"
		# shellcheck source=/dev/null
		source "$GOOGLE_CLOUD_HOME/completion.bash.inc"
		var_set_by_name "$__user_var" 0
	else
		var_set_by_name "$__user_var" 1
	fi
}

function install_google_cloud_sdk() {
	curl https://sdk.cloud.google.com | bash
	gcloud auth login
	gcloud components update
}

register_interactive configure_google_cloud_sdk
