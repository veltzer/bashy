source core/assert.bashinc
source core/var.bashinc

function testSetByName() {
	local b=5
	var_set_by_name b 6
	assertEquals "$b" 6
}

function in_function() {
	local c=5
	var_set_by_name c 6
	assertEquals "$c" 6
}

function testInFunction() {
	in_function
}

function testDefinedPATH() {
	if ! var_is_defined PATH
	then
		assertFail
	fi
}

function testNotDefined() {
	if var_is_defined PATHY
	then
		assertFail
	fi
}