function configure_google_cloud() {
	local __user_var=$1
	GOOGLE_CLOUD_HOME="$HOME/install/google-cloud-sdk"
	# The next line updates PATH for the Google Cloud SDK.
	if [ -d "$GOOGLE_CLOUD_HOME" ]
	then
		source "$GOOGLE_CLOUD_HOME/path.bash.inc"
		source "$GOOGLE_CLOUD_HOME/completion.bash.inc"
		var_set_by_name "$__user_var" 0
	else
		var_set_by_name "$__user_var" 1
	fi
}

function install_google_cloud() {
	curl https://sdk.cloud.google.com | bash
	gcloud auth login
	gcloud components update
}

register_interactive configure_google_cloud
