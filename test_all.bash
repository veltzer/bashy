#!/bin/bash -eu

source core/color.bash
source core/assert.bash
source core/source.bash

for f in tests/*.bash
do
	# shellcheck source=/dev/null
	source "${f}"
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
	if [[ "${name}" =~ ^test* ]]
	then
		echo -n "running [${name}]..."
		res=0
		(( count+=1 ))
		("${name}") || res=${?}
		if [ "${res}" == "0" ]
		then
			_bashy_cecho g "OK" 0
			(( count_ok+=1 ))
		else
			_bashy_cecho r "ERROR" 0
			(( count_er+=1 ))
		fi
	fi
done
echo "summary"
echo "number of tests run --> ${count}"
echo -n "number of tests ok --> "
_bashy_cecho g "${count_ok}" 0
echo -n "number of tests failed --> "
if [ "${count_er}" -eq 0 ]
then
	_bashy_cecho g "${count_er}" 0
	exit 0
else
	_bashy_cecho r "${count_er}" 0
	exit 1
fi
