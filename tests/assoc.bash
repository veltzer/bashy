source core/assoc.bash

function testAssoc() {
	assoc_new conf
	assoc_config_read conf "data/test.conf"
	# assoc_print conf
	local len=
	assoc_len conf len
	assert_equal "${len}" 2
	a=
	assoc_get conf a "a"
	assert_equal "${a}" "a_value"
	b=
	assoc_get conf b "b"
	assert_equal "${b}" "b_value"
	# shellcheck disable=2034
	c=
	assoc_get conf c "c"
	if ! null_var_is_null c
	then
		assertFail
	fi
}
