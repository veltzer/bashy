function _activate_bigdata() {
	local -n __var=$1
	local -n __error=$2

	# this is for java
	FOLDER="/usr/lib/jvm/java-8-openjdk-amd64"
	if ! checkDirectoryExists "${FOLDER}" __var __error; then return; fi
	# set this to whereever you have a jvm
	export JAVA_HOME="${FOLDER}"

	# this is for hadoop
	FOLDER="${HOME}/install/hadoop"
	if ! checkDirectoryExists "${FOLDER}" __var __error; then return; fi
	# set this to whereever you installed hadoop
	export HADOOP_HOME="${FOLDER}"

	# this is a bashrc snipplet to work with spark and ipython
	FOLDER="${HOME}/install/spark"
	if ! checkDirectoryExists "${FOLDER}" __var __error; then return; fi
	# set this to whereever you installed spark
	export SPARK_HOME="${FOLDER}"
	# Where you specify options you would normally add after bin/pyspark
	export PYSPARK_SUBMIT_ARGS="--master local[2] pyspark-shell"

	# this is to run hive in local mode
	FOLDER="${HOME}/install/apache-hive"
	if ! checkDirectoryExists "${FOLDER}" __var __error; then return; fi
	export HIVE_HOME="${FOLDER}"
	#export HIVE_OPTS='-hiveconf mapred.job.tracker=local -hiveconf fs.default.name=file:///tmp -hiveconf hive.metastore.warehouse.dir=file:///tmp/warehouse'
	_bashy_pathutils_add_head PATH "${HIVE_HOME}/bin"

	# this is for pig
	FOLDER="${HOME}/install/pig"
	if ! checkDirectoryExists "${FOLDER}" __var __error; then return; fi
	export PIG_HOME="${FOLDER}"
	_bashy_pathutils_add_head PATH "${PIG_HOME}/bin"
	__var=0
}

register _activate_bigdata
