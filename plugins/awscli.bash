function _activate_awscli() {
	local -n __var=$1
	local -n __error=$2
	# this is needed for the completer to work
	alias aws='awsv2'
	__var=0
}

function _install_awscli() {
	# installation using a bundle
	wget https://s3.amazonaws.com/aws-cli/awscli-bundle.zip -o /tmp
	unzip /tmp/awscli-bundle.zip
	/tmp/awscli-bundle/install -b ~/install/bin

	# installation using pip of wrapper - this is not official aws
	/usr/bin/pip install --user awscliv2
}

register _activate_awscli
