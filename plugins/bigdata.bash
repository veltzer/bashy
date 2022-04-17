function configure_bigdata() {
	local -n __var=$1
	local -n __error=$2

	# this is for java
	FOLDER="/usr/lib/jvm/java-8-openjdk-amd64"
	if [ ! -d "$FOLDER" ]
	then
		__error="[$FOLDER] doesnt exist"
		__var=1
		return
	fi
	# set this to whereever you have a jvm
	export JAVA_HOME="$FOLDER"

	# this is for hadoop
	FOLDER="$HOME/install/hadoop"
	if [ ! -d "$FOLDER" ]
	then
		__error="[$FOLDER] doesnt exist"
		__var=1
		return
	fi
	# set this to whereever you installed hadoop
	export HADOOP_HOME="$FOLDER"

	# this is a bashrc snipplet to work with spark and ipython
	FOLDER="$HOME/install/spark"
	if [ ! -d "$FOLDER" ]
	then
		__error="[$FOLDER] doesnt exist"
		__var=1
		return
	fi
	# set this to whereever you installed spark
	export SPARK_HOME="$FOLDER"
	# Where you specify options you would normally add after bin/pyspark
	export PYSPARK_SUBMIT_ARGS="--master local[2] pyspark-shell"

	# this is to run hive in local mode
	FOLDER="$HOME/install/apache-hive"
	if [ ! -d "$FOLDER" ]
	then
		__error="[$FOLDER] doesnt exist"
		__var=1
		return
	fi
	export HIVE_HOME="$FOLDER"
	#export HIVE_OPTS='-hiveconf mapred.job.tracker=local -hiveconf fs.default.name=file:///tmp -hiveconf hive.metastore.warehouse.dir=file:///tmp/warehouse'
	pathutils_add_head PATH "$HIVE_HOME/bin"

	# this is for pig
	FOLDER="$HOME/install/pig"
	if [ ! -d "$FOLDER" ]
	then
		__error="[$FOLDER] doesnt exist"
		__var=1
		return
	fi
	export PIG_HOME="$FOLDER"
	pathutils_add_head PATH "$PIG_HOME/bin"
	__var=0
}

register configure_bigdata
