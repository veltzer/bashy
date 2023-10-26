source core/float.bash

function test_gt() {
	if float_gt 3.14 3.22
	then
		assertFail
	fi
}

function test_add() {
	f=
	float_add f 0.2 1.4
	assert_equal "${f}" 1.6
}

function test_div() {
	f=
	float_div f 1.4 0.2
	assert_lt "${f}" 7.1
	assert_gt "${f}" 6.9
}
