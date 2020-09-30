#!/bin/bash -eu

# source all tests
for f in tests/*.sh
do
	# shellcheck source=/dev/null
	source "$f"
done

source test_harness.bashinc
