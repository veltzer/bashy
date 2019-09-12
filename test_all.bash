#!/bin/bash -eu

# source all tests
for f in tests/*.sh
do
	source "$f"
done

source core/test.bashinc
