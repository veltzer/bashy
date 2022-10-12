# this is a configuation for awscli
# there were several versions of the awscli and so there are several versions in this code.
# the one which is enabled is the latest v2 cli client of aws and also the one mentioned in
# the references.
#
# References:
# - https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html

function _activate_awscli() {
	local -n __var=$1
	local -n __error=$2
	AWSCLI_HOME="$HOME/install/aws"
	AWSCLI_HOME_BIN="$AWSCLI_HOME/bin"
	if ! checkDirectoryExists "$AWSCLI_HOME" __var __error; then return; fi
	if ! checkDirectoryExists "$AWSCLI_HOME_BIN" __var __error; then return; fi
	pathutils_add_head PATH "$AWSCLI_HOME_BIN"
	export AWSCLI_HOME
	__var=0
}

function _activate_awscli_wrapper() {
	local -n __var=$1
	local -n __error=$2
	# this is needed for the completer to work for the wrapper version
	# alias aws='awsv2'
	__var=0
}

function _install_awscli_wrapper() {
	# installation using pip of wrapper - this is not official aws
	/usr/bin/pip install --user awscliv2
}

function _install_awscli_old() {
	# installation using a bundle
	# we use -O [filename] instead of -P /tmp because -P will not overwrite the previous
	# file (if it exits) and will create a new file named [filename].1
	rm -rf /tmp/awscli-bundle.zip /tmp/awscli-bundle
	wget https://s3.amazonaws.com/aws-cli/awscli-bundle.zip -P /tmp
	unzip /tmp/awscli-bundle.zip -d /tmp
	/tmp/awscli-bundle/install -b ~/install/bin/aws
}

function _install_awscli() {
	# rm -rf /tmp/awscliv2.zip /tmp/awscliv2
	curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "/tmp/awscliv2.zip"
	unzip awscliv2.zip -d /tmp
	rm -rf ~/install/aws
	sudo ./aws/install -i ~/install/aws -b ~/install/aws/bin
}

function aws_select_profile() {
	readarray -t profiles < <(sed -nr 's/^\[(.*)\]$/\1/p' ~/.aws/credentials)
	echo "Please select a drive:"
	select profile in "${profiles[@]}"; do
		[[ -n "$profile" ]] || { echo "Invalid choice. Please try again." >&2; continue; }
		break
	done
	echo "selected [$profile]..."
	export AWS_PROFILE="$profile"
}

register _activate_awscli
