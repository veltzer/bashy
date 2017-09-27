#!/bin/bash -eu

# source the bootstrap code
source core/source.bashinc

# source all tests
for f in $HOME/.bashy/tests/*.bashinc
do
	source "$f"
done

# find all functions that start with "test*"
# and run them one by one accumulating results
IFS=$'\n'
count=0
count_ok=0
count_er=0
for f in $(declare -F)
do
	name="${f:11}"
	if [[ "$name" == test* ]]
	then
		echo -n "running [$name]..."
		res=0
		let "count+=1"
		($name) || res=$?
		if [ "$res" == "0" ]
		then
			echo "OK"
			let "count_ok+=1"
		else
			echo "ERROR"
			let "count_err+=1"
		fi
	fi
done
echo "summary"
echo "number of tests run [$count]"
echo "number of tests failed [$count_er]"
echo "number of tests ok [$count_ok]"
