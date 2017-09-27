#!/bin/bash -eu

# source the bootstrap code
source core/source.bashinc
source core/color.bashinc

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
			cecho g "OK" 0
			let "count_ok+=1"
		else
			cecho r "ERROR" 0
			let "count_err+=1"
		fi
	fi
done
echo "summary"
echo "number of tests run --> $count"
echo -n "number of tests ok --> "
cecho g $count_ok 0
echo -n "number of tests failed --> "
if [ $count_er -eq 0 ]
then
	cecho g $count_er 0
else
	cecho r $count_er 0
fi
