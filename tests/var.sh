source core/assert.sh
source core/var.sh

function testSetByName() {
	local b=5
	var_set_by_name b 6
	_bashy_assert_equal "${b}" 6
}

function in_function() {
	local c=5
	var_set_by_name c 6
	_bashy_assert_equal "${c}" 6
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
