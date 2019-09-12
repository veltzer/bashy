#!/bin/bash -eu

# source all tests
for f in tests/*.bashinc
do
	source "$f"
done

source shunit2
