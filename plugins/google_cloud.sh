function configure_google_cloud() {
	GOOGLE_CLOUD_HOME="$HOME/install/google-cloud-sdk"
	# The next line updates PATH for the Google Cloud SDK.
	if [ -d "$GOOGLE_CLOUD_HOME" ]
	then
		source "$GOOGLE_CLOUD_HOME/path.bash.inc"
		source "$GOOGLE_CLOUD_HOME/completion.bash.inc"
		result=0
	else
		result=1
	fi
}

function install_google_cloud() {
	curl https://sdk.cloud.google.com | bash
	gcloud auth login
	gcloud components update
}

register_interactive configure_google_cloud
