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
	version="3.5.4"
	toplevel="spark-${version}-bin-hadoop3"
	rm -f "${HOME}/install/spark" || true
	rm -rf "${HOME}/install/${toplevel}" || true
	url="https://dlcdn.apache.org/spark/spark-${version}/spark-${version}-bin-hadoop3.tgz"
	echo "url is [${url}]..."
	curl --location --silent "${url}" | tar xz -C "${HOME}/install"
	ln -s "${HOME}/install/${toplevel}" "${HOME}/install/spark"
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
