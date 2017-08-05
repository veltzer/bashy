function configure_spark() {
	# this is a bashrc snipplet to work with spark and ipython
	FOLDER="$HOME/install/spark"
	if [[ -d $FOLDER ]]
	then
		# set this to whereever you installed spark
		export SPARK_HOME="$FOLDER"
		# Where you specify options you would normally add after bin/pyspark
		export PYSPARK_SUBMIT_ARGS="--master local[2] pyspark-shell"
		return 0
	else
		return 1
	fi
}

register configure_spark
