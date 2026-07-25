# this is a configuation for awscli
# there were several versions of the awscli and so there are several versions in this code.
# the one which is enabled is the latest v2 cli client of aws and also the one mentioned in
# the references.
#
# References:
# - https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html
#
# aws-iam-authenticator
# - https://docs.aws.amazon.com/eks/latest/userguide/install-aws-iam-authenticator.html
# - https://www.learnaws.org/2023/08/22/aws-iam-authenticator/

function _activate_awscli() {
	local -n __var=$1
	local -n __error=$2
	AWSCLI_HOME="${HOME}/install/aws"
	AWSCLI_HOME_BIN="${AWSCLI_HOME}/bin"
	if ! checkDirectoryExists "${AWSCLI_HOME}" __var __error; then return; fi
	if ! checkDirectoryExists "${AWSCLI_HOME_BIN}" __var __error; then return; fi
	_bashy_pathutils_add_head PATH "${AWSCLI_HOME_BIN}"
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
	rm -rf /tmp/awscli-bundle.zip /tmp/awscli-bundle
	wget https://s3.amazonaws.com/aws-cli/awscli-bundle.zip -P /tmp
	unzip /tmp/awscli-bundle.zip -d /tmp
	/tmp/awscli-bundle/install -b "${HOME}/install/bin/aws"
	rm -rf /tmp/awscli-bundle.zip /tmp/awscli-bundle
}

function _install_awscli() {
	aws_executable="${HOME}/install/aws/bin/aws"
	latest_aws_version=$(curl --fail --silent --location "https://api.github.com/repos/aws/aws-cli/tags?per_page=20" | jq --raw-output '[.[] | select(.name | startswith("2."))][0].name')
	installed_aws_version=""
	if [ -x "${aws_executable}" ]
	then
		installed_aws_version=$("${aws_executable}" --version 2>/dev/null | grep -oP 'aws-cli/\K[0-9]+\.[0-9]+\.[0-9]+' | head -1)
	fi
	needs_aws_install=true
	if bashy_install_check "awscli" "${installed_aws_version}" "${latest_aws_version}"
	then
		needs_aws_install=false
	fi
	if [ "${needs_aws_install}" = true ]; then
		rm -rf "${HOME}/install/aws"
		local aws_zip
		bashy_download "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" aws_zip || return 1
		# unpack into a private directory, /tmp/aws is a predictable path in a
		# world writable place and anyone could have created it first
		local aws_tmp
		aws_tmp=$(mktemp --directory)
		bashy_install_extract "${aws_zip}" "${aws_tmp}"
		"${aws_tmp}/aws/install" -i "${HOME}/install/aws" -b "${HOME}/install/aws/bin" > /dev/null
		rm -rf "${aws_tmp}"
		# checking that you do not have 'awscli' installed from pypi
		if pip show awscli 2> /dev/null
		then
			echo "you have the old 'awscli' python module installed. removing it!!!"
			pip uninstall awscli 2> /dev/null || true
		else
			echo "you dont have the old 'awscli' python module. no need to uninstall it. good!"
		fi
		echo "following is the version of awscli (aws --version)..."
		aws --version
	fi
	# aws-iam-authenticator
	iam_executable="${HOME}/install/aws/bin/aws-iam-authenticator"
	iam_release_json=$(curl --fail --silent --location https://api.github.com/repos/kubernetes-sigs/aws-iam-authenticator/releases/latest)
	iam_latest_version=$(echo "${iam_release_json}" | jq --raw-output '.tag_name' | sed 's/^v//')
	iam_installed_version=""
	if [ -x "${iam_executable}" ]
	then
		iam_installed_version=$("${iam_executable}" version 2>/dev/null | grep -oP '"Version":"\K[^"]+' | head -1)
	fi
	if bashy_install_check "aws-iam-authenticator" "${iam_installed_version}" "${iam_latest_version}"
	then
		return
	fi
	download_file=$(echo "${iam_release_json}" | jq -r '.assets[].browser_download_url | select(endswith("_linux_amd64"))')
	curl --fail --location --output "${iam_executable}" "${download_file}"
	chmod +x "${iam_executable}"
}

function _uninstall_awscli() {
	rm -rf "${HOME}/install/aws" || true
	# pip uninstall awscli 2> /dev/null || true
}

function awscli_select_profile() {
	readarray -t profiles < <(sed -nr 's/^\[(.*)\]$/\1/p' "${HOME}/.aws/credentials")
	echo "Please select a profile:"
	select profile in "${profiles[@]}"; do
		[[ -n "${profile}" ]] || { echo "Invalid choice. Please try again." >&2; continue; }
		break
	done
	echo "selected [${profile}]..."
	export AWS_PROFILE="${profile}"
}

register _activate_awscli
register_install _install_awscli
