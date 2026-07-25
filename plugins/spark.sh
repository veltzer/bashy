# This is a plugin for spark

function _activate_spark() {
	local -n __var=$1
	local -n __error=$2
	SPARK_HOME="${HOME}/install/spark"
	local SPARK_BIN="${SPARK_HOME}/bin"
	if ! checkDirectoryExists "${SPARK_HOME}" __var __error; then return; fi
	if ! checkDirectoryExists "${SPARK_BIN}" __var __error; then return; fi
	_bashy_pathutils_add_head PATH "${SPARK_BIN}"
	export SPARK_HOME
	__var=0
}

function _install_spark() {
	before_strict
	# instructions for installing spark are at
	# https://medium.com/@patilmailbox4/install-apache-spark-on-ubuntu-ffa151e12e30
	# the download mirror lists a directory per release, take the highest one
	version=$(curl --fail --silent --location "https://dlcdn.apache.org/spark/" | grep -oP 'href="spark-\K[0-9]+\.[0-9]+\.[0-9]+(?=/")' | sort --version-sort --unique | tail -1)
	toplevel="spark-${version}-bin-hadoop3"
	# ~/install/spark is a symlink into the versioned directory, so it names what is installed
	installed_version=""
	if [ -d "${HOME}/install/spark" ]
	then
		installed_version=$(readlink "${HOME}/install/spark" | grep -oP 'spark-\K[0-9]+\.[0-9]+\.[0-9]+')
	fi
	if bashy_install_check "spark" "${installed_version}" "${version}"
	then
		after_strict
		return
	fi
	url="https://dlcdn.apache.org/spark/spark-${version}/${toplevel}.tgz"
	bashy_install_download "${url}"
	local archive
	bashy_download "${url}" archive || { after_strict; return; }
	# drop the previous install, otherwise every upgrade leaves the old tree behind
	rm -rf "${HOME}/install/spark" "${HOME}/install/${toplevel}"
	tar xzf "${archive}" -m -C "${HOME}/install"
	ln -sfn "${HOME}/install/${toplevel}" "${HOME}/install/spark"
	after_strict
}

function _uninstall_spark() {
	folder="${HOME}/install/spark"
	executable="${folder}/kubectl"
	if [ -f "${executable}" ]
	then
		echo "removing ${executable}"
		rm "${executable}"
	else
		echo "no kubectl detected"
	fi
}

register _activate_spark
