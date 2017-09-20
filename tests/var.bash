#!/bin/bash -eu

source core/assert.bashinc
source core/var.bashinc

b=5
var_set_by_name b 6
assertEqual "$b" 6

function test_it() {
	local c=5
	var_set_by_name c 6
	assertEqual "$c" 6
}

test_it

if ! var_is_defined PATH
then
	assertFail
fi
if var_is_defined PATHY
then
	assertFail
fi
