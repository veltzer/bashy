function configure_spark() {
	local __user_var=$1
	# this is a bashrc snipplet to work with spark and ipython
	FOLDER="$HOME/install/spark"
	if [[ -d $FOLDER ]]
	then
		# set this to whereever you installed spark
		export SPARK_HOME="$FOLDER"
		# Where you specify options you would normally add after bin/pyspark
		export PYSPARK_SUBMIT_ARGS="--master local[2] pyspark-shell"
		var_set_by_name "$__user_var" 0
	else
		var_set_by_name "$__user_var" 1
	fi
}

register configure_spark
